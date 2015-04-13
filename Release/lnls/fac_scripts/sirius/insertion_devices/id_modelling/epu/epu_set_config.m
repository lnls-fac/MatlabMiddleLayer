%function epu = set_config(epu0, gap, phase, varargin)
function epu = epu_set_config(epu0, gap_upstream, gap_downstream, phase_csd, phase_cie)

epu = epu0;


% movimentações em paralelo
% =========================

old_gap = (epu0.gap_upstream + epu0.gap_downstream) / 2;
old_phase_csd = epu0.phase_csd;
old_phase_cie = epu0.phase_cie;
new_gap = (gap_upstream + gap_downstream) / 2;

%CSD
for i=1:length(epu.csd)
    epu.csd(i).pos = epu.csd(i).pos + [0 (phase_csd - old_phase_csd) (new_gap - old_gap)/2]';
end
%CSE
for i=1:length(epu.cse)
    epu.cse(i).pos = epu.cse(i).pos + [0 0 (new_gap - old_gap)/2]';
end
%CIE
for i=1:length(epu.cie)
    epu.cie(i).pos = epu.cie(i).pos + [0 (phase_cie - old_phase_cie) -(new_gap - old_gap)/2]';
end
%CID
for i=1:length(epu.cid)
    epu.cid(i).pos = epu.cid(i).pos + [0 0 -(new_gap - old_gap)/2]';
end

epu.gap_upstream   = gap_upstream;
epu.gap_downstream = gap_downstream;
epu.phase_csd = phase_csd;
epu.phase_cie = phase_cie;

% tapering

delta_gap = gap_upstream - gap_downstream;
encoder1_pos = -2373.5/2; % medidas do desenho CAD
encoder2_pos = +2373.5/2;
tapering_angle  = atan(delta_gap / (encoder2_pos - encoder1_pos));
c = cos(tapering_angle);
s = sin(tapering_angle);
rotation_matrix = [1 0 0; 0 c -s; 0 s c];

% CSD
pos = [epu.csd(:).pos];
rotation_center = [mean(pos(1,:)) (encoder1_pos + encoder2_pos)/2 mean(pos(3,:))]';
for i=1:length(epu.csd)
    epu.csd(i).rotc = rotation_center;
    epu.csd(i).rotm = rotation_matrix;
end

% CSE
pos = [epu.cse(:).pos];
rotation_center = [mean(pos(1,:)) (encoder1_pos + encoder2_pos)/2 mean(pos(3,:))]';
for i=1:length(epu.cse)
    epu.cse(i).rotc = rotation_center;
    epu.cse(i).rotm = rotation_matrix;
end

% CIE
pos = [epu.cie(:).pos];
rotation_center = [mean(pos(1,:)) (encoder1_pos + encoder2_pos)/2 mean(pos(3,:))]';
for i=1:length(epu.cie)
    epu.cie(i).rotc = rotation_center;
    epu.cie(i).rotm = inv(rotation_matrix);
end

% CID
pos = [epu.cid(:).pos];
rotation_center = [mean(pos(1,:)) (encoder1_pos + encoder2_pos)/2 mean(pos(3,:))]';
for i=1:length(epu.cid)
    epu.cid(i).rotc = rotation_center;
    epu.cid(i).rotm = inv(rotation_matrix);
end


% updates gmatrix for registered points
if isfield(epu, 'registered_points')
    registered_points = epu.registered_points;
    epu.registered_points = {};
    for i=1:length(registered_points)
        epu = register_points(epu, registered_points{i}.points);
    end
end
