function the_ring = insert_segmented_model(the_ring_original, file_name, family_name, marker_name)

bpm_label = 'BPM';
hcm_label = 'HCM';
vcm_label = 'VCM';

the_ring = the_ring_original;

% registers positions of BPMs, HCMs and VCMs
idx = findcells(the_ring, 'FamName', bpm_label); bpm_spos = findspos(the_ring, idx); the_ring(idx) = [];
idx = findcells(the_ring, 'FamName', hcm_label); hcm_spos = findspos(the_ring, idx); the_ring(idx) = [];
idx = findcells(the_ring, 'FamName', vcm_label); vcm_spos = findspos(the_ring, idx); the_ring(idx) = [];

% load AT model, sets its FamName and gets is half length
load(file_name); 
at_model = setcellstruct(at_model, 'FamName', 1:length(at_model), family_name);
model_length = sum(getcellstruct(at_model, 'Length', 1:length(at_model)));

min_spc = Inf;
idx = findcells(the_ring, 'FamName', marker_name);
for i=1:length(idx)
    id=idx(i); ld=the_ring{id}.Length; while(id <= length(the_ring) && (strcmpi(the_ring{id}.FamName, family_name) || any(strcmpi(the_ring{id}.PassMethod, {'IdentityPass','DriftPass'})))), ld=ld+the_ring{id}.Length; id = id + 1;  end;
    iu=idx(i); lu=the_ring{iu}.Length; 
    while(iu <= length(the_ring) && (strcmpi(the_ring{iu}.FamName, family_name) || any(strcmpi(the_ring{iu}.PassMethod, {'IdentityPass','DriftPass'})))), 
        lu=lu+the_ring{iu}.Length; iu = iu - 1; 
    end;
    if min([ld lu]) < min_spc, min_spc = min([ld lu]); end;
end
fprintf('max. half model spacing: %f\n', min_spc);
if min_spc < model_length
    error('there is no space for insertion of segmented model');
end
    

% finds init and final positions of AT model in the ring
idx = findcells(the_ring, 'FamName', marker_name);
marker_pos = findspos(the_ring, idx); 
init_pos  =  marker_pos - model_length;
final_pos =  marker_pos + model_length;
full_at_model = [fliplr(at_model) the_ring{idx(1)} at_model];

% breaks driftspaces so that AT model can be inserted find init and final
% indices
new_the_ring = the_ring;
new_the_ring = segs_at_s_points(new_the_ring, init_pos);
new_the_ring = segs_at_s_points(new_the_ring, final_pos);
spos = findspos(new_the_ring, 1:length(new_the_ring)+1);
%fprintf('removing...\n');
for i=1:length(init_pos)
    i1(i) = find(spos == init_pos(i), 1);
    i2(i) = find(spos == final_pos(i), 1)-1;
    famnames = getcellstruct(new_the_ring, 'FamName', i1(i):i2(i));
    %fprintf('%01i: ', i); for j=1:length(famnames), fprintf('%s ', famnames{j}); end; fprintf('\n');
end

% creates the_ring with AT model of element
the_ring = new_the_ring(1:i1(1)-1);

for i=1:length(i1)-1
    the_ring = [the_ring full_at_model new_the_ring(i2(i)+1:i1(i+1)-1)];
end
the_ring = [the_ring full_at_model new_the_ring(i2(end)+1:end)];


% inserts BPMs, HCMs and VCMs back into the_ring
line = [marker(bpm_label, 'IdentityPass') corrector(hcm_label, 0, [0 0], 'CorrectorPass') corrector(vcm_label, 0, [0 0], 'CorrectorPass')];
faketr = buildlat(line);
% --- BPMs ---
the_ring = segs_at_s_points(the_ring, bpm_spos);
for i=1:length(bpm_spos)
    spos = findspos(the_ring, 1:length(the_ring)+1);
    idx = find(spos == bpm_spos(i), 1);
    the_ring = [the_ring(1:idx-1) faketr{1} the_ring(idx:end)];
end
% --- HCMs ---
the_ring = segs_at_s_points(the_ring, hcm_spos);
for i=1:length(hcm_spos)
    spos = findspos(the_ring, 1:length(the_ring)+1);
    idx = find(spos == hcm_spos(i), 1);
    the_ring = [the_ring(1:idx-1) faketr{2} the_ring(idx:end)];
end
% --- VCMs ---
the_ring = segs_at_s_points(the_ring, vcm_spos);
for i=1:length(vcm_spos)
    spos = findspos(the_ring, 1:length(the_ring)+1);
    idx = find(spos == vcm_spos(i), 1);
    the_ring = [the_ring(1:idx-1) faketr{3} the_ring(idx:end)];
end

function new_the_ring = segs_at_s_points(the_ring, init_pos)


% segments the_ring so that it contains model extremities
spos = findspos(the_ring, 1:length(the_ring)+1);
i1 = zeros(size(init_pos));
for i=1:length(init_pos)
    i1(i) = find(spos > init_pos(i), 1) - 1;
end

new_the_ring = the_ring(1:i1(1)-1);
for i=1:length(i1)-1
    s = findspos(new_the_ring, length(new_the_ring)+1);
    e1 = the_ring{i1(i)}; e1.Length = init_pos(i) - s;
    e2 = the_ring{i1(i)}; e2.Length = the_ring{i1(i)}.Length - e1.Length;
    new_the_ring = [new_the_ring e1 e2 the_ring(i1(i)+1:i1(i+1)-1)];
end
s = findspos(new_the_ring, length(new_the_ring)+1);
e1 = the_ring{i1(end)}; e1.Length = init_pos(end) - s;
e2 = the_ring{i1(end)}; e2.Length = the_ring{i1(end)}.Length - e1.Length;
new_the_ring = [new_the_ring e1 e2 the_ring(i1(end)+1:end)];

