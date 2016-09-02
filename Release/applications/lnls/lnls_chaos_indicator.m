function indicator = lnls_chaos_indicator(ring, param, plota)
% indicator = lnls_chaos_indicator(ring, param, plota)
%   Calculate ADR (see Plinio's internship report) and diffusion for a
%   model of ring.
%
%   INPUT
%       ring    = accelerator model.
%       param   = struct with the mandatory field 'plane', which defines
%                 the plane to search for chaos ('x','y','ep','en') and the
%                 optional fields:
%                   .pos    = position, in meters, in the ring, for which
%                             the analysis will be done;
%                   .window = window for which the tune cannot leave
%                             (aper_win), see lnls_tune_cross_window for
%                             details;
%                   .n_adr  = number of turns to use in ADR;
%                   .n_dif  = number of turns to use in diffusion;
%                   .offset = offset for all initial conditions;
%                   .x      = determine initial conditions for 'plane';
%                   .Rin    = determine initial conditions.
%       plota   = boolean determining whether to plot ADR and diffusion.
%
%   OUTPUT
%       indicator = struct with the following fields:
%                   	.aper_stb   = first initial condition for which the
%                                     particle is lost due to tracking;
%                       .aper_adr   = first initial condition for which the
%                                     ADR indicator reaches a threshold;
%                       .aper_dif   = first initial condition for which the
%                                     difusion indicator reaches a
%                                     threshold;
%                       .aper_win   = first initial condition for which the
%                                     tune leaves the window;
%                       .adr        = ADR for each initial condition;
%                       .x_adr      = initial conditions for ADR;
%                       .dif        = difusion for each initial condition;
%                       .x_dif      = initial conditions for diffusion;
%                       .tunex      = horizontal tune (use x_dif);
%                       .tuney      = vertical tune (use x_dif).

indicator = struct('aper_stb', [], 'aper_adr', [], 'aper_dif', [], ...
    'aper_win', [], 'adr', [], 'x_adr', [], 'dif', [], ...
    'tunex', [], 'tuney', [], 'x_dif', []);

if isstruct(param)
    if ~isfield(param,'plane'), error('Define Plane'); end
    if ~isfield(param,'pos'), param.pos       = 0.0; end
    if ~isfield(param,'n_adr'), param.n_adr   = 130; end
    if ~isfield(param,'n_dif'), param.n_dif   = 121; end
    if ~isfield(param,'window'), param.window = [-1 0 0; 0 -1 0; 1 0 0.5; 0 1 0.5]; end
    if ~isfield(param,'offset'), param.offset = [0;0;0;0;0;0]; end
    
    plane  = param.plane;
    pos    = param.pos;
    window = param.window;
    n_adr  = param.n_adr;
    n_dif  = param.n_dif;
    offset = param.offset;
else
    plane	= param;
    pos     = 0.0;
    n_adr   = 130;
    n_dif   = 121;
    window	= [-1 0 0; 0 -1 0; 1 0 0.5; 0 1 0.5];
    offset	= [0;0;0;0;0;0];
end

if ~exist('plota','var'),  plota  = false; end

if and(length(pos) > 1, size(offset,2) > 1)
    warning('Input of several pos and offset is not allowed, I will continue only with the first column of offset.');
    offset = offset(:,1);
end

if length(pos) > 1
    for i = 1:length(pos)
        aux = chaos_indicator(ring, param, plane, pos(i), plota, window, n_adr, n_dif, offset);
        indicator.aper_stb(i) = aux.aper_stb; indicator.aper_adr(i) = aux.aper_adr;
        indicator.aper_dif(i) = aux.aper_dif; indicator.aper_win(i) = aux.aper_win;
        indicator.adr(:,i)    = aux.adr;
        indicator.dif(:,i)    = aux.dif;
        indicator.tunex(:,i)  = aux.tunes(:,1);
        indicator.tuney(:,i)  = aux.tunes(:,2);
    end
else
    for i = 1:size(offset,2)
        aux = chaos_indicator(ring, param, plane, pos, plota, window, n_adr, n_dif, offset(:,i));
        indicator.aper_stb(i) = aux.aper_stb; indicator.aper_adr(i) = aux.aper_adr;
        indicator.aper_dif(i) = aux.aper_dif; indicator.aper_win(i) = aux.aper_win;
        indicator.adr(:,i)    = aux.adr;
        indicator.dif(:,i)    = aux.dif;
        indicator.tunex(:,i)  = aux.tunes(:,1);
        indicator.tuney(:,i)  = aux.tunes(:,2);
    end
end

indicator.x_adr = aux.x_adr';
indicator.x_dif = aux.x_dif';

end

function indicator = chaos_indicator(ring, param, plane, pos, plota, window, n_adr, n_dif, offset)

indicator = struct('aper_stb', 0, 'aper_adr', 0, 'aper_dif', 0, 'aper_win', 0,...
    'adr', [], 'x_adr', [], 'dif', [], 'tunes', [], 'x_dif', []);

n_adr = n_adr + mod(n_adr,2) + 1;
n_dif = n_dif + 12 - mod(n_dif,12) + 1; %to satisfy naff conditions

nturns = max(n_adr, n_dif);

ntunes = 2; % number of tunes used to calculate the diffusion;

expoent = 1; % exponential spacing between initial conditions
np = 351; % number of initial conditions

offset([2,4]) = offset([2,4]) + 1e-6; % a small delta to exclude singularity;

if strcmpi(plane,'x')
    lim_adr = 1.05;
    lim_dif = 1e-04;
    pl = 1;
    xi =  -6e-3;
    xf = -13e-3;
elseif strcmpi(plane,'y')
    lim_adr = 1.05;
    lim_dif = 1e-04;
    pl = 3;
    xi = 2e-3;
    xf = 3e-3;
elseif strcmpi(plane,'ep')
    lim_adr = 1.05;
    lim_dif = 1e-04;
    pl = 5;
    xi = 2e-2;
    xf = 5e-2;
elseif strcmpi(plane,'en')
    lim_adr = 1.05;
    lim_dif = 1e-04;
    pl = 5;
    xi = -2e-2;
    xf = -5e-2;
end

% create the vector of initial conditions
if isstruct(param) && isfield(param,'x')
    x = param.x;
else
    x = linspace(0,1,np).^expoent;
    x = xi + (xf-xi)*x;
end
Rin = repmat(offset(:),1,length(x));
Rin(pl,:) = x;

if isstruct(param) && isfield(param,'Rin')
    Rin = param.Rin;
end

% shift the ring to the point where the tracking will be done:
spos = findspos(ring,1:length(ring));
[~,point] = min(abs(pos-spos));
ring = ring([point:end,1:point-1]);

% tracking
Rou = [Rin, ringpass(ring,Rin,nturns)];
Rou = reshape(Rou,6,size(Rin,2),[]);

% subtract closed orbit
if (strcmpi(plane,'ep') || strcmpi(plane,'en'))
    x_dP = [0; 0; 0; 0];
    for j=1:size(Rou,2)
        x_dP = findorbit4(ring, Rou(5,j,1),1,[x_dP; 0; 0]);
        Rou(1:4,j,:) = Rou(1:4,j,:) - repmat(x_dP, [1,1,size(Rou,3)]);
    end
else
	x_dP = findorbit4(ring, Rou(5,1,1),1);
	for j=1:size(Rou,2)
		Rou(1:4,j,:) = Rou(1:4,j,:) - repmat(x_dP, [1,1,size(Rou,3)]);
	end
end

%-----------------Stability-----------------%

ind_stb = find(isnan(Rou(1,:,end)),1,'first'); if isempty(ind_stb), ind_stb=length(x); end;
indicator.aper_stb = x(ind_stb);

%----------Average-Distance-Ratio-----------%

Rou_adr = Rou(:,:,1:n_adr+1);

delta_x = diff(Rou_adr,1,2);
exp2 = mean(delta_x.*delta_x,3);

delta_x = delta_x(:,:,1:end/2);
exp1 = mean(delta_x.*delta_x,3);

adr = sqrt(mean((exp2(1:4,:)./exp1(1:4,:)/4))); % adr = sqrt(mean((exp2(1:4,:)./exp1(1:4,:)/4)));

ind_adr = find(adr > lim_adr,1,'first'); if isempty(ind_adr), ind_adr = length(x); end;
indicator.aper_adr  = x(min([ind_adr,ind_stb]));

indicator.adr = adr;
indicator.x_adr = x(1:end-1);

%----------------Diffusion------------------%

Rou_dif = Rou(:,:,1:n_dif+1);

x0  = reshape(Rou_dif(1,:),[],n_dif+1); % +1, because of initial condition
xl  = reshape(Rou_dif(2,:),[],n_dif+1);
y0  = reshape(Rou_dif(3,:),[],n_dif+1);
yl  = reshape(Rou_dif(4,:),[],n_dif+1);
ind = ~isnan(x0(:,end));

tunex = NaN*ones(size(Rin,2),ntunes);
tuney = NaN*ones(size(Rin,2),ntunes);
amplx = NaN*ones(size(Rin,2),ntunes);
amply = NaN*ones(size(Rin,2),ntunes);
[tunex(ind,:) amplx(ind,:)] = lnls_calcnaff(x0(ind,1:end/2),...
    xl(ind,1:end/2),ntunes);
[tuney(ind,:) amply(ind,:)] = lnls_calcnaff(y0(ind,1:end/2),...
    yl(ind,1:end/2),ntunes);

tune1 = [tunex, tuney];
ampl1 = [amplx, amply];
[~,indt1] = sort(ampl1,2,'descend');
for j = 1:size(x0,1)
    tune1(j,:) = tune1(j,indt1(j,:));
end

indicator.tunes = [tunex(:,1) tuney(:,1)];

tunex = NaN*ones(size(Rin,2),ntunes);
tuney = NaN*ones(size(Rin,2),ntunes);
amplx = NaN*ones(size(Rin,2),ntunes);
amply = NaN*ones(size(Rin,2),ntunes);
[tunex(ind,:) amplx(ind,:)] = lnls_calcnaff(x0(ind,end/2+1:end),...
    xl(ind,end/2+1:end),ntunes);
[tuney(ind,:) amply(ind,:)] = lnls_calcnaff(y0(ind,end/2+1:end),...
    yl(ind,end/2+1:end),ntunes);

tune2 = [tunex, tuney];
ampl2 = [amplx, amply];
[~,indt2] = sort(ampl2,2,'descend');
for j = 1:size(x0,1)
    tune2(j,:) = tune2(j,indt2(j,:));
end

dif_ind = sqrt(sum( (tune2(:,1:ntunes)-tune1(:,1:ntunes)).^2 ,2));

ind_dif = find(dif_ind > lim_dif,1,'first'); if isempty(ind_dif), ind_dif = length(x); end;
indicator.aper_dif  = x(min([ind_dif,ind_stb]));

indicator.dif = dif_ind;
indicator.x_dif = x;

%-------------------Window------------------%

tunex = lnls_calcnaff(x0(ind,1:end-1), xl(ind,1:end-1));
tuney = lnls_calcnaff(y0(ind,1:end-1), yl(ind,1:end-1));

C = window(:,[1,2]) * [tunex,tuney]';
idx = any(C > repmat(window(:,3),1,size(C,2)),1);
ind_win = find(idx > 0,1,'first'); if isempty(ind_win), ind_win = length(x); end;

indicator.aper_win = x(min([ind_win,ind_stb]));

%-------------------------------------------%

if plota
    figure('OuterPosition',[633*1,540*(1-1),633, 540]); plot(x(1:end-1),adr);
    str=sprintf('Plot of ADR (%d turns)', n_adr); title(str)
    xlabel(plane)
    ylabel('adr')
    
    figure('OuterPosition',[633*1,540*(1-0),633, 540]);
    plot(x,dif_ind);
    str=sprintf('Plot of Diffusion (%d turns, %d tunes)', n_dif, ntunes);
    title(str)
    xlabel(plane)
    ylabel('diffusion')
end

end
