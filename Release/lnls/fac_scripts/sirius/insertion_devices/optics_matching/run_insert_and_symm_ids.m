function run_insert_and_symm_ids

% Loads ID definitions
ids_names = {'ipe', 'inga', 'sabia',...%high beta
              'inga2','sabia2','ipe2',...%high beta
              'caterete','ema','manaca','carnauba',...%low beta 
              'caterete2','ema2','manaca2','carnauba2',...%low beta
              'caterete3','ema3','sabia3','ipe3'}; 
ids = ids_select(ids_names);

% Create nominal model
the_ring0 = sirius_si_lattice();
save('the_ring.mat', 'the_ring0');

% Calcs original twiss parameters
twiss0 = calctwiss(the_ring0, 'n+1'); 
tunes0 = [twiss0.mux(end), twiss0.muy(end)]/2/pi;
mc = findcells(the_ring0,'FamName','mc');

% Inserts IDs
the_ring = ids_insert_set(the_ring0, ids);
save('the_ring_withids_notsymm.mat', 'the_ring');

% Local symmetrization of each ID
symm_loc.knobs      = {'qfa','qda','qfb','qdb1'};
symm_loc.nr_iters   = 20;
symm_loc.tol        = 1e-6;
symm_loc.goal       = [twiss0.betax(mc(1)),twiss0.alphax(mc(1)),...
                       twiss0.betay(mc(1)),twiss0.alphay(mc(1)),...
                       twiss0.etax(mc(1)), twiss0.etaxl(mc(1))];
symm_loc.id_sections = getcellstruct(ids,'straight_number',1:length(ids));
the_ring = ids_locally_symmetrize(the_ring, symm_loc);

% Local symmetrization of each ID
symm_glob.knobs      = {'qfa','qda','qfb','qdb1'};
symm_glob.id_sections = symm_loc.id_sections;
symm_glob.nr_iters = 30;
symm_glob.tol      = 1e-2;
symm_glob.svs_lst  = [10,20,30,40];
the_ring = ids_globally_symmetrize(the_ring, tunes0, symm_glob);

% saves lattice model with ids
save('the_ring_withids.mat', 'the_ring');


