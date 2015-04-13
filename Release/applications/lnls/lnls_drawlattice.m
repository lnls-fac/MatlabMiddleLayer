function lnls_drawlattice(the_ring, nper, offset, unset_names, scale, bpms_and_cms, h)
% lnls_drawlattice(the_ring, nper, offset, unset_names, scale, bpms_and_cms, h)
%
% INPUTS:
%   the_ring    - lattice to be drawn;
%   nper        - symmetry of the ring. The lattice will be drawn from the
%                 beginning of the_ring up to smax/nper;
%   offset      - offset the drawing in the vertical axis (default: 0)
%   unset_names - boolean. Disables display of the family names (default: true)
%   bpms_and_cms- boolean. Plot BPMs and Correctors (default: false)
%   scale       - scales the rectangles and lines to mach the plot scale
%                 (default: 1)
%   h           - handle to the axis where to draw (default: gca)
%
% Created: Unknown
% Modified: Fernando 2015-01-31 - inclusion of input h and bug corrections


if ~exist('offset', 'var')
    offset = 0;
end

if ~exist('unset_names', 'var')
    unset_names = true;
end

if exist('scale','var')
    Delta=scale;
    %offset=offset*scale;
else
    Delta=1;
end

if ~exist('bpms_and_cms', 'var')
    bpms_and_cms = false;
end

if ~exist('h','var')
    h = gca;
end

pos = findspos(the_ring, 1:(length(the_ring)+1));
max_pos = pos(end) / (nper - 0.001);
if bpms_and_cms
    bpms = findcells(the_ring, 'FamName', 'bpm');
    for i=1:length(bpms)
        s = pos(bpms(i));
        if (s > max_pos), break; end;
        line([s s], [0+offset Delta*1.5+offset], 'Color', [0 0 0],'Parent',h)
    end
    hcms = findcells(the_ring, 'FamName', 'hcm');
    for i=1:length(hcms)
        s = pos(hcms(i));
        if (s > max_pos), break; end;
        line([s s], [0+offset -1.5*Delta+offset], 'Color', [0 0 1],'Parent',h)
    end
    vcms = findcells(the_ring, 'FamName', 'vcm');
    for i=1:length(vcms)
        s = pos(vcms(i));
        if (s > max_pos), break; end;
        line([s s], [0+offset -1.5*Delta+offset], 'Color', [1 0 0],'Parent',h)
    end
    
end

idx = findcells(the_ring, 'PassMethod', 'IdentityPass');
the_ring(idx) = [];
for i=length(the_ring):-1:2
    if strcmpi(the_ring{i-1}.FamName, the_ring{i}.FamName)
        the_ring{i-1}.Length = the_ring{i-1}.Length + the_ring{i}.Length;
        the_ring(i) = [];
    end
end

pos = findspos(the_ring, 1:(length(the_ring)+1));
max_pos = pos(end) / (nper - 0.001);
s = 0;
for i=1:(length(pos)-1)
    len = pos(i+1) - pos(i);
    if isfield(the_ring{i}, 'BendingAngle')
        rectangle('Position',[s,-1*Delta+offset,len,2*Delta], 'FaceColor', [0 0.535 0.711], 'EdgeColor', [0 0.535 0.711],'Parent',h);
        if ~unset_names
            text(s+len/2, 1.9, the_ring{i}.FamName, 'HorizontalAlignment', 'center', 'FontWeight', 'bold','Parent',h);
        end
    elseif isfield(the_ring{i}, 'K')
        rectangle('Position',[s,-1*Delta+offset,len,2*Delta], 'FaceColor', [0.918 0.609 0.32], 'EdgeColor', [0.918 0.609 0.32],'Parent',h);
        if ~unset_names
            text(s+len/2, 1.9, the_ring{i}.FamName, 'HorizontalAlignment', 'center', 'FontWeight', 'bold','Parent',h);
        end
    elseif isfield(the_ring{i}, 'PolynomB')
        if (strcmpi(the_ring{i}.FamName,'pmm')==0)
            rectangle('Position',[s,-1*Delta+offset,len,2*Delta], 'FaceColor', [0.539 0.598 0.465], 'EdgeColor', [0.539 0.598 0.465],'Parent',h);
            if ~unset_names
                text(s+len/2, -1.9, the_ring{i}.FamName, 'HorizontalAlignment', 'center', 'FontWeight', 'bold','Parent',h);
            end
        else
            line([s s+len], [0+offset 0+offset], 'Color', [0 0 0],'Parent',h);
        end
    else
        line([s s+len], [0+offset 0+offset], 'Color', [0 0 0],'Parent',h);
    end
    s = s + len;
    if (s > max_pos), break; end;
end
xlim(h,[0,max_pos]);
% axis(h,[0 max_pos -5+offset 10]);

%axis off;
% set(h, 'Color', [1 1 1]);

    
    
