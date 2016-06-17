function run_insert_and_symm_ids

% Loads Phase1 ID definitions
ids_names = {};

ids_names{end+1} = 'carnauba';  % SS-06 PHASE1
ids_names{end+1} = 'ema';       % SS-08 PHASE1
ids_names{end+1} = 'inga';      % SS-09 PHASE1
ids_names{end+1} = 'caterete';  % SS-10 PHASE1
ids_names{end+1} = 'ipe_hp';    % SS-11 PHASE1
ids_names{end+1} = 'sabia_hp';  % SS-12 PHASE1
ids_names{end+1} = 'manaca';    % SS-14 PHASE1
             
ids_phase1 = ids_select_80mm(ids_names);

% Create nominal model
sirius('SI.V14B');
the_ring0 = sirius_si_lattice();
save('the_ring0.mat', 'the_ring0');

% Calcs original twiss parameters
twiss0 = calctwiss(the_ring0, 'n+1'); 
tunes0 = [twiss0.mux(end), twiss0.muy(end)]/2/pi;
mc = findcells(the_ring0,'FamName','mc');

% Inserts IDs of Phase1
strength = 1;
the_ring1 = ids_insert_set(the_ring0, ids_phase1, strength);
save('the_ring_nosym.mat', 'the_ring1');

% % Checks effect of IDs on optics
% r0 = calctwiss(the_ring0);
% r1 = calctwiss(the_ring1);
% fprintf('the_ring0: %.6f %.6f\n', r0.mux(end)/2/pi, r0.muy(end)/2/pi);
% fprintf('the_ring1: %.6f %.6f\n', r1.mux(end)/2/pi, r1.muy(end)/2/pi);
% figure; hold all; plot(r0.pos, r0.betax); plot(r1.pos, r1.betax); 
% figure; hold all; plot(r0.pos, r0.betay); plot(r1.pos, r1.betay); 

% Local symmetrization of each ID
symm_loc.knobs       = {'qfa','qda','qfb','qdb1'};
symm_loc.nr_iters    = 20;
symm_loc.tol         = 1e-6;
symm_loc.goal        = [twiss0.betax(mc(1)),twiss0.alphax(mc(1)),...
                       twiss0.betay(mc(1)),twiss0.alphay(mc(1)),...
                       twiss0.etax(mc(1)), twiss0.etaxl(mc(1))];
if isempty(ids_phase1)
    symm_loc.id_sections = [];
else
    symm_loc.id_sections = getcellstruct(ids_phase1,'straight_number',1:length(ids_phase1));
end
the_ring2 = ids_locally_symmetrize(the_ring1, symm_loc);
save('the_ring_locsym.mat', 'the_ring2');

% Global symmetrization with tune fitting
symm_glob.knobs      = {'qfa','qda','qfb','qdb1'};
symm_glob.id_sections = symm_loc.id_sections;
symm_glob.nr_iters = 80;
symm_glob.tol      = 1e-2;
symm_glob.svs_lst  = [3,5,10,18];
the_ring2          = ids_globally_symmetrize(the_ring2, tunes0, symm_glob);

% saves lattice model with ids
save('the_ring_withids.mat', 'the_ring2');

% % Checks effect of IDs on optics
% r0 = calctwiss(the_ring0);
% r2 = calctwiss(the_ring2);
% fprintf('the_ring0: %.6f %.6f\n', r0.mux(end)/2/pi, r0.muy(end)/2/pi);
% fprintf('the_ring2: %.6f %.6f\n', r2.mux(end)/2/pi, r2.muy(end)/2/pi);
% figure; hold all; plot(r0.pos, r0.betax); plot(r2.pos, r2.betax); 
% figure; hold all; plot(r0.pos, r0.betay); plot(r2.pos, r2.betay); 


%% --- phase2 ---

ids_names = {};
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

ids_phase2 = ids_select_80mm(ids_names);

% Inserts IDs of Phase2
strength = 1;
the_ring2 = ids_insert_set(the_ring2, ids_phase2, strength);

% Local symmetrization of each ID
symm_loc.id_sections = [getcellstruct(ids_phase1,'straight_number',1:length(ids_phase1)); getcellstruct(ids_phase2, 'straight_number', 1:length(ids_phase2))];
the_ring2 = ids_locally_symmetrize(the_ring2, symm_loc);

% Local symmetrization of each ID
symm_glob.id_sections = symm_loc.id_sections;
symm_glob.nr_iters = 30;
symm_glob.tol      = 1e-2;
symm_glob.svs_lst  = [1,3,5,10,20,30,38];
the_ring2           = ids_globally_symmetrize(the_ring2, tunes0, symm_glob);

% Checks effect of IDs on optics
r0 = calctwiss(the_ring0);
r2 = calctwiss(the_ring2);
fprintf('the_ring0: %.6f %.6f\n', r0.mux(end)/2/pi, r0.muy(end)/2/pi);
fprintf('the_ring2: %.6f %.6f\n', r2.mux(end)/2/pi, r2.muy(end)/2/pi);
figure; hold all; plot(r0.pos, r0.betax); plot(r2.pos, r2.betax); 
figure; hold all; plot(r0.pos, r0.betay); plot(r2.pos, r2.betay); 

% saves lattice model with ids
save('the_ring_withids.mat', 'the_ring2');
