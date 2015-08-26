function run_insert_and_symm_ids

ids_names = {};
% Loads ID definitions
% ids_names{end+1} = 'caterete2'; % SS-02 
% ids_names{end+1} = 'ema2';      % SS-04        (with 3rd H cavity?)
% ids_names{end+1} = 'inga2';     % SS-05          
ids_names{end+1} = 'carnauba';  % SS-06 PHASE1
% ids_names{end+1} = 'ipe3_vp';   % SS-07
ids_names{end+1} = 'ema';       % SS-08 PHASE1
ids_names{end+1} = 'inga';      % SS-09 PHASE1
ids_names{end+1} = 'caterete';  % SS-10 PHASE1
ids_names{end+1} = 'ipe_vp';    % SS-11 PHASE1
ids_names{end+1} = 'sabia_vp';  % SS-12 PHASE1
% ids_names{end+1} = 'sabia3_vp'; % SS-13
ids_names{end+1} = 'manaca';    % SS-14 PHASE1
% ids_names{end+1} = 'ipe4_vp';   % SS-15
% ids_names{end+1} = 'carnauba2'; % SS-16
% ids_names{end+1} = 'ipe2_vp';   % SS-17
% ids_names{end+1} = 'sabia2_vp'; % SS-18
% ids_names{end+1} = 'sabia4_vp'; % SS-19
% ids_names{end+1} = 'manaca2';   % SS-20
            
ids = ids_select(ids_names);

% Create nominal model
the_ring = sirius_si_lattice();
save('the_ring0.mat', 'the_ring');

% Calcs original twiss parameters
twiss0 = calctwiss(the_ring, 'n+1'); 
tunes0 = [twiss0.mux(end), twiss0.muy(end)]/2/pi;
mc = findcells(the_ring,'FamName','mc');

% Inserts IDs
strength = 1;
the_ring = ids_insert_set(the_ring, ids, strength);
save('the_ring_nosym.mat', 'the_ring');

% Local symmetrization of each ID
symm_loc.knobs       = {'qfa','qda','qfb','qdb1'};
symm_loc.nr_iters    = 20;
symm_loc.tol         = 1e-6;
symm_loc.goal        = [twiss0.betax(mc(1)),twiss0.alphax(mc(1)),...
                       twiss0.betay(mc(1)),twiss0.alphay(mc(1)),...
                       twiss0.etax(mc(1)), twiss0.etaxl(mc(1))];
symm_loc.id_sections = getcellstruct(ids,'straight_number',1:length(ids));
the_ring = ids_locally_symmetrize(the_ring, symm_loc);
save('the_ring_locsym.mat', 'the_ring');

% Local symmetrization of each ID
symm_glob.knobs      = {'qfa','qda','qfb','qdb1'};
symm_glob.id_sections = symm_loc.id_sections;
symm_glob.nr_iters = 80;
symm_glob.tol      = 1e-2;
symm_glob.svs_lst  = [3,5,10,18];
the_ring           = ids_globally_symmetrize(the_ring, tunes0, symm_glob);

% saves lattice model with ids
save('the_ring_withids.mat', 'the_ring');


%% --- phase2 ---

ids_names = {};
% Loads ID definitions
ids_names{end+1} = 'caterete2'; % SS-02 
ids_names{end+1} = 'ema2';      % SS-04        (with 3rd H cavity?)
ids_names{end+1} = 'inga2';     % SS-05          
ids_names{end+1} = 'ipe3_vp';   % SS-07
%ids_names{end+1} = 'sabia3_vp'; % SS-13
% ids_names{end+1} = 'ipe4_vp';   % SS-15
ids_names{end+1} = 'carnauba2'; % SS-16
ids_names{end+1} = 'ipe2_vp';   % SS-17
ids_names{end+1} = 'sabia2_vp'; % SS-18
% ids_names{end+1} = 'sabia4_vp'; % SS-19
ids_names{end+1} = 'manaca2';   % SS-20

ids = ids_select(ids_names);

% Inserts IDs
strength = 1;
the_ring = ids_insert_set(the_ring, ids, strength);

% Local symmetrization of each ID
symm_loc.id_sections = getcellstruct(ids,'straight_number',1:length(ids));
the_ring = ids_locally_symmetrize(the_ring, symm_loc);

% Local symmetrization of each ID
symm_glob.id_sections = symm_loc.id_sections;
symm_glob.nr_iters = 30;
symm_glob.tol      = 1e-2;
symm_glob.svs_lst  = [1,3,5,10,20,30,38];
the_ring           = ids_globally_symmetrize(the_ring, tunes0, symm_glob);


% saves lattice model with ids
save('the_ring_withids.mat', 'the_ring');
