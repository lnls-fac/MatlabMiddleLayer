function run_insert_and_symm_ids(ids_phase2)

% Loads Phase1 ID definitions
ids_names = {};

ids_names{end+1} = 'carnauba';  % SS-06 PHASE1
ids_names{end+1} = 'ema';       % SS-08 PHASE1
ids_names{end+1} = 'inga';      % SS-09 PHASE1
ids_names{end+1} = 'caterete';  % SS-10 PHASE1
ids_names{end+1} = 'ipe_hp';    % SS-11 PHASE1
ids_names{end+1} = 'sabia_hp';  % SS-12 PHASE1
ids_names{end+1} = 'manaca';    % SS-14 PHASE1
ids_names{end+1} = 'caterete2'; % SS-02 
ids_names{end+1} = 'ema2';      % SS-04        (with 3rd H cavity?)
ids_names{end+1} = 'inga2';     % SS-05          
ids_names{end+1} = 'ipe3_hp';   % SS-07
ids_names{end+1} = 'sabia3_hp'; % SS-13
ids_names{end+1} = 'ipe4_hp';   % SS-15
ids_names{end+1} = 'carnauba2'; % SS-16
ids_names{end+1} = 'ipe2_hp';   % SS-17
ids_names{end+1} = 'sabia2_hp'; % SS-18
ids_names{end+1} = 'sabia4_hp'; % SS-19
ids_names{end+1} = 'manaca2';   % SS-20
             
% ids_phase2 = ids_select_80mm(ids_names);


%% Create nominal model
% sirius('SI.V20.01');
the_ring0 = sirius_si_lattice();
save('the_ring0.mat', 'the_ring0');



%% Inserts IDs of Phase1
% strength = 2.8/3.6;
% length_scale = 2.8/3.6;
strength = 1;
length_scale = 1;
ring_nosym = ids_insert_set(the_ring0, ids_phase2, strength, length_scale);
save('the_ring_nosym_apu_commissioning.mat', 'ring_nosym');



%% Local symmetrization of each ID
symm.knobs       = {'QFA','QDA','QFB','QDB1','QDB2', 'QFP', 'QDP1', 'QDP2'};
symm.nr_iters    = 20;
symm.tol         = 1e-6;
symm.look_tune   = false;
symm.the_ring0   = the_ring0;

if isempty(ids_phase2)
    symm.id_sections = [];
else
    symm.id_sections = getcellstruct(ids_phase2,'straight_number',1:length(ids_phase2));
end

ring_sym = ids_symmetrize(ring_nosym, symm);
save('the_ring_sym_apu_commissioning.mat', 'ring_sym');



%% Tune correction
fprintf('Correcting Tune...')
[~, goal_tunes] = twissring(the_ring0,0,1:length(the_ring0)+1);
[ring_symtune, conv] = lnls_correct_tunes(ring_sym,goal_tunes,[],'svd');
if conv, fprintf(' converged.\n'); else fprintf(' did not converge.\n'); end


%% Chromaticity correction
disp('Correcting chromaticity...')
ring_symtune = lnls_correct_chrom(ring_symtune, [2.5,2.5]);



%% saves lattice model with ids
save('the_ring_withids_apu_commissioning.mat', 'ring_symtune');
disp('Symmetrized ring saved in file: the_ring_withids.mat')
end

