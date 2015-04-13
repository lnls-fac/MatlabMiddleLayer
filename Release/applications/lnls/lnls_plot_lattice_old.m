function lnls_plot_lattice(varargin)

global THERING;

% valores default dos parâmetros
g.min_s  = 0;
g.max_s  = findspos(THERING,length(THERING)+1);
g.offset = 5;
g.height  = 1 * (0.5/1.4);

h = [];

% processa input
i = 1;
while (i<=length(varargin))
    if ischar(varargin{i})
        if strcmpi(varargin{i},'AllLattice')
            g.min_s = 0;
            g.max_s = findspos(THERING,length(THERING)+1);
        elseif strcmpi(varargin{i}, 'Min')
            g.min_s = varargin{i+1};
            i = i + 1;
        elseif strcmpi(varargin{i}, 'Max')
            g.max_s = varargin{i+1};
            i = i + 1;
        elseif strcmpi(varargin{i}, 'Offset')
            g.offset = varargin{i+1};
            i = i + 1;
        elseif strcmpi(varargin{i}, 'Scale')
            g.height = varargin{i+1} * (0.5/1.4);
            i = i + 1;
        elseif strcmpi(varargin{i}, 'HCM')
            g.hcm = varargin{i+1};
        elseif strcmpi(varargin{i}, 'VCM')
            g.vcm = varargin{i+1};    
        elseif strcmpi(varargin{i}, 'SKEW')
            g.skew = varargin{i+1};
        end
    elseif isnumeric(varargin{i})
        if ishghandle(varargin{i})
            h = varargin{i};
        end
    end
    i = i + 1;
end
    
if isempty(h),
    h = figure;
end


set(h, 'Color', [1 1 1]);
%axis off;

g.pos = g.min_s;
for i=1:length(THERING)
    s1 = findspos(THERING,i);
    s2 = findspos(THERING,i+1);
    if (s1 < g.min_s), continue; end;
    if (s1 >= g.max_s), break; end; % elemento não pertence ao intervalo
    g.len = min([g.max_s s2]) - s1;
    g.ele = THERING{i};
    %if (g.len == 0) && ~strcmpi(g.ele.FamName, 'BPM'), continue; end; % elemento com comprimento de plot nulo
    if isfield(g, 'hcm') && intersect(i, g.hcm)
        g.ele.FamName = 'HCM';
        plot_cmag(h, g);
    end
    if isfield(g, 'vcm') && intersect(i, g.vcm)
        g.ele.FamName = 'VCM';
        plot_cmag(h, g);
    end
    if isfield(g, 'skew') && intersect(i, g.skew(:,1))
        plot_skewquad(h, g);
    end
    if any(strcmpi(THERING{i}.FamName,{'AWG01','AON11','AWG09'}))
        plot_id(h,g);
    elseif isfield(g.ele, 'BendingAngle')
        plot_bend(h, g);
    elseif isfield(g.ele, 'K')
        plot_quad(h, g);
    elseif isfield(g.ele, 'PolynomB') && length(THERING{i}.PolynomB)>2 && (THERING{i}.PolynomB(3) || any(strcmpi(THERING{i}.FamName,{'SF','SFF','SD','SDD','HSF','HSD'})))
        plot_sext(h, g);
    else
        plot_line(h, g);
    end
    drawnow;
    g.pos = g.pos + g.len;
    if ~ishghandle(h), return; end;
end

g.pos = g.min_s;
for i=1:length(THERING)
    s1 = findspos(THERING,i);
    s2 = findspos(THERING,i+1);
    if (s1 < g.min_s), continue; end;
    if (s1 >= g.max_s), break; end; % elemento não pertence ao intervalo
    g.len = min([g.max_s s2]) - s1;
    g.ele = THERING{i};
    if strcmpi(g.ele.FamName, 'BPM')
        plot_bpms(h, g);
    end
    drawnow;
    g.pos = g.pos + g.len;
    if ~ishghandle(h), return; end;
end

%axis([0 g.max_s -5 5]);

function plot_cmag(h, g)

if ~ishghandle(h), return; end;
%figure(h);
if any(strcmpi(g.ele.FamName, {'HCM', 'cm'}))
    col = [0 0 1]; 
    y   = g.offset + [1.2 * g.height 1.4 * g.height];
    line([g.pos g.pos], y, 'Color', col, 'Marker','.');
elseif any(strcmpi(g.ele.FamName, {'VCM', 'cm'}))
    col = [1 0 0]; 
    y   = g.offset + [-1.2 * g.height -1.4 * g.height];
    line([g.pos g.pos], y, 'Color', col, 'Marker','.');
else
end


function plot_skewquad(h, g)

if ~ishghandle(h), return; end;
%figure(h);
line([g.pos-0*g.len/2, g.pos+0*g.len/2], g.offset + 1.3*g.height * [1 1], 'Color', [0 0.8 0], 'Marker', 'X'); 




function plot_line(h, g)

if ~ishghandle(h), return; end;
%figure(h);
line([g.pos g.pos+g.len], g.offset + [0 0], 'Color', [0 0 0]);

function plot_id(h, g)

if ~ishghandle(h), return; end;
%figure(h);
col = [1 0.7 0];
%if strcmpi(g.ele.FamName, 'BC'), col = [1 0.7 0]; end;
%if strcmpi(g.ele.FamName, 'BI'), col = [0.9 0.9 0]; end;
rectangle('Position',[g.pos,-0.3 * g.height + g.offset,g.len,0.6 * g.height],'FaceColor',col, 'EdgeColor',col);

function plot_bend(h, g)

if ~ishghandle(h), return; end;
%figure(h);
col = [1 1 0];
if strcmpi(g.ele.FamName, 'BC'), col = [1 0.7 0]; end;
if strcmpi(g.ele.FamName, 'BI'), col = [0.9 0.9 0]; end;
rectangle('Position',[g.pos,-1 * g.height + g.offset ,g.len,2 * g.height],'FaceColor',col, 'EdgeColor',col);

function plot_quad(h, g)

if ~ishghandle(h), return; end;
%figure(h);
if g.ele.K > 0
    col = [0 0 1];
else
    col = [1 0 0];
end
rectangle('Position',[g.pos,-0.8 * g.height + g.offset,g.len,1.6 * g.height],'FaceColor',col, 'EdgeColor',col,'Curvature',[0.9,0.1]);

function plot_sext(h, g)

if ~ishghandle(h), return; end;
%figure(h);
if g.ele.PolynomB(3) < 0
    col = [0 0.7 0];
else
    col = [0.7 0 0.7];
end
rectangle('Position',[g.pos,-0.6 * g.height + g.offset,g.len,1.2 * g.height],'FaceColor',col, 'EdgeColor',col,'Curvature',[0.9,0.1]);

function plot_bpms(h, g)

if ~ishghandle(h), return; end;
%figure(h);
line([g.pos g.pos], [0 0] + g.offset, 'Marker','O','Color', [0 0 0],'MarkerFaceColor',[0 0 0], 'MarkerSize', 5);

