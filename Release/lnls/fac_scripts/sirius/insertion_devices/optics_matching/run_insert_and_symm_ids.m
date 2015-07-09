function run_insert_and_symm_ids

% Loads ID definitions
ids_names = {%'ipe', 'inga', 'sabia',...%high beta
             %'inga2','sabia2','ipe2',...
             %'caterete','ema','manaca','carnauba',...%low beta 
             %'caterete2','ema2','manaca2','carnauba2',...%low beta
             'EPU80PV' % high beta
             }; 
ids = ids_select(ids_names);

% Create nominal model
the_ring0 = sirius_si_lattice();
%save('the_ring.mat', 'the_ring');

% Calcs original twiss parameters
twiss0 = calctwiss(the_ring0, 'n+1'); 
tunes0 = [twiss0.mux(end)/2/pi, twiss0.muy(end)/2/pi];
mc = findcells(the_ring0,'FamName','mc');

% Inserts IDs
% ids(1).strength = 2;
the_ring = ids_insert_set(the_ring0, ids);
save('the_ring_withids_notsymm.mat', 'the_ring');

% Local symmetrization of each ID
% symm_loc.knobs    = {'qf1','qf2','qf3','qf4','qfa','qda','qfb','qdb1','qdb2'};
symm_loc.knobs    = {'qfa','qda','qfb','qdb1','qdb2'};
symm_loc.nr_iters = 10;
symm_loc.tol      = 0.01;
symm_loc.maxdK    = 0.3;
symm_loc.goal     = [twiss0.betax(mc(1)),twiss0.betay(mc(1)),twiss0.etax(mc(1))];
the_ring = ids_locally_symmetrize(the_ring, ids, symm_loc);

% Local symmetrization of each ID
% symm_glob.knobs    = {'qf1','qf2','qf3','qf4','qfa','qda','qfb','qdb1','qdb2'};
symm_glob.knobs    = {'qfa','qda','qfb','qdb1','qdb2'};
symm_glob.nr_iters = 3;
symm_glob.tol      = 3.0;
symm_glob.maxdK    = 0.3;
for i=1:5
    the_ring = ids_globally_symmetrize(the_ring, tunes0, [], symm_glob);
end

% re-label all quadrupole flanking IDs to original strings
dipoles = findcells(the_ring, 'BendingAngle');
quadrupoles = setdiff(findcells(the_ring, 'K'), dipoles);
for i=1:length(quadrupoles)
    if strfind(the_ring{quadrupoles(i)}.FamName, '_ID')
        the_ring{quadrupoles(i)}.FamName = the_ring{quadrupoles(i)}.FamName(1:end-5);
    end
end
% saves lattice model with ids
save('the_ring_withids.mat', 'the_ring');


