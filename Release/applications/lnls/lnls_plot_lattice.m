function lnls_plot_lattice(the_ring, smin, smax, y, dy)

bends = findcells(the_ring, 'BendingAngle');
multi = setdiff(findcells(the_ring, 'PolynomB'), bends);
sexts = multi(getcellstruct(the_ring, 'PolynomB', multi, 1, 3) ~= 0);
quads = setdiff(multi, sexts);

if ~isempty(quads)
    quads_qf = (getcellstruct(the_ring, 'PolynomB', quads, 1, 2) >= 0);
else
    quads_qf = [];
end
%bpms  = findcells(the_ring, 'FamName', 'BPM');

s = findspos(the_ring, 1:length(the_ring)+1);
bends_pos = [s(bends)' s(bends+1)'];
sexts_pos = [s(sexts)' s(sexts+1)'];
quads_pos = [s(quads)' s(quads+1)'];
%bpms_pos  = [s(bpms)' s(bpms+1)'];


%bpms_height  = 0.50 * dy;
quads_height = 0.40 * dy;
bends_height = 0.50 * dy;
sexts_height = 0.40 * dy;

hold all;
plot([smin, smax], [y, y], 'k-');

% plots dipoles
for i=1:size(bends_pos, 1)
    pos = get_pos(bends_pos(i,:), smin, smax);
    if isempty(pos), continue; end;
    rectangle('Position', [pos(1),y-bends_height/2,diff(pos),bends_height], 'FaceColor', 'r', 'EdgeColor', 'r');
end

% plots quadrupoles
for i=1:size(quads_pos, 1)
    pos = get_pos(quads_pos(i,:), smin, smax);
    if (isempty(pos) || diff(pos)==0), continue; end;
    if quads_qf(i)
        rectangle('Position', [pos(1),y,diff(pos),quads_height], 'FaceColor', 'b', 'EdgeColor', 'b');
    else
        rectangle('Position', [pos(1),y-quads_height,diff(pos),quads_height], 'FaceColor', 'b', 'EdgeColor', 'b');
    end
end

% plots sextupoles
for i=1:size(sexts_pos, 1)
    pos = get_pos(sexts_pos(i,:), smin, smax);
    if (isempty(pos) || diff(pos)==0), continue; end;
    rectangle('Position', [pos(1),y-sexts_height/2,diff(pos),sexts_height], 'FaceColor', [0,0.8,0], 'EdgeColor', [0,0.8,0]);
end

% % plots BPMs
% for i=1:size(bpms_pos, 1)
%     pos = get_pos(bpms_pos(i,:), smin, smax);
%     if isempty(pos), continue; end;
%     line([pos(1), pos(1)], [y,y+bpms_height], 'LineStyle', '-', 'Color', [0,0,0]);
%     %rectangle('Position', [pos(1)-(smax-smin)*0.01*0.5,y+bpms_height,(smax-smin)*0.01,dy*0.01], 'Curvature', [1,1], 'FaceColor', [0,0,0], 'EdgeColor', [0,0,0]);
% end


function pos = get_pos(old_pos, smin, smax)

pos = old_pos;
if ((pos(1) > smax)||(pos(2) < smin))
    pos = [];
    return
end
if pos(1) < smin, pos(1) = smin; end
if pos(2) > smax, pos(2) = smax; end

