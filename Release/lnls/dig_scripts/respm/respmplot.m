function Mdata = respmplot(M, plane, posang, bpmsource)

if nargin < 2 || isempty(plane)
    plane = 'h';
end

if nargin < 3 || isempty(posang)
    posang = 'pos';
end

if nargin < 4
    bpmsource = [];
end

if strcmpi(plane, 'h')
    Mplane = M.h;
else
    Mplane = M.v;
end

if strcmpi(posang, 'pos')
    Mdata_ = Mplane.pos;
    orbit_unit = 'm';
else
    Mdata_ = Mplane.ang;
    orbit_unit = 'rad';
end

if isempty(bpmsource)
elseif strcmpi(bpmsource, 'bpm')
    Mdata_ = Mdata_(M.bpm_index,:);
    M.orbit_names = M.orbit_names(M.bpm_index);
else
    Mdata_ = Mdata_(M.source_index,:);
    M.orbit_names = M.orbit_names(M.source_index);
end

if nargout == 0
    figure;
    surf(1:size(Mdata_,2), 1:size(Mdata_,1), (Mdata_));
    set(gca, 'XTick', 1:length(Mplane.names));
    set(gca, 'XTickLabel', Mplane.names);
    set(gca, 'YTick', 1:length(M.orbit_names));
    set(gca, 'YTickLabel', M.orbit_names);
    set(gca, 'FontSize', 12);
    xlabel('Corrector', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Orbit', 'FontSize', 12, 'FontWeight', 'bold');
    zlabel([orbit_unit '/' M.unit], 'FontSize', 12, 'FontWeight', 'bold');
else
    Mdata = Mdata_;
end