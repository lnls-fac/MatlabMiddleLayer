function machine = study_errors_effects()

% initializations
name = 'CONFIG'; name_saved_machines = name;
initializations(name);

% defines nominal lattice model
read_from_file = false; 
[the_ring, family_data] = create_nominal_model(read_from_file, name);

% creates and applies misalignment, rotation and excitation errors
machine = create_apply_errors(the_ring, name, family_data);

%application of bpm offset errors
machine = create_apply_bpm_errors(machine, family_data, name);

% corrects closed orbit
machine = correct_orbit(the_ring, machine, family_data, name, name_saved_machines);

% corrects coupling 
machine = correct_coupling(the_ring, machine, family_data, name, name_saved_machines);

% corrects tunes
machine = correct_tune(the_ring, machine, name_saved_machines);

% creates and applies multipolar errors
machine = create_apply_multipoles(the_ring, machine, family_data, name, name_saved_machines);

% finalizacoes
finalizations();

%% Initializations
function initializations(name)

fprintf('\n<initializations> [%s]\n\n', datestr(now));

% seed for random number generator
seed = 131071;
fprintf('-  initializing random number generator with seed = %i ...\n', seed);
RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));

% sends copy of all output to a diary in a file
fprintf('-  creating diary file ...\n');
diary([name, '_summary.txt']);


%% Definition of the nominal AT model
function [the_ring, family_data] = create_nominal_model(read_from_file, name)

if (read_from_file)
    load('the_ring_withids.mat');
else
    the_ring  = sirius_si_lattice('C','05');
    the_ring = setcavity('off', the_ring);
    the_ring = setradiation('off', the_ring);
end
save([name,'the_ring.mat'], 'the_ring');
family_data = sirius_si_family_data(the_ring);
    

    
%% Magnet Errors:
function machine = create_apply_errors(the_ring, name, family_data)

fprintf('\n<error generation and random machines creation> [%s]\n\n', datestr(now));
        
% constants
um = 1e-6; mrad = 0.001; percent = 0.01;

% <quadrupoles> alignment, rotation and excitation errors
config.fams.quads.labels     = {'qfa','qdb2','qfb','qdb1','qda','qf1','qf2','qf3','qf4'};
config.fams.quads.sigma_x    = 40 * um * 1;
config.fams.quads.sigma_y    = 40 * um * 1;
config.fams.quads.sigma_roll = 0.30 * mrad * 1;
config.fams.quads.sigma_e    = 0.05 * percent * 1;

% <sextupoles> alignment, rotation and excitation errors
config.fams.sexts.labels     = {'sda','sfa','sd1','sf1','sd2','sd3','sf2','sf3','sd4','sd5','sf4','sd6','sdb','sfb'};
config.fams.sexts.sigma_x    = 40 * um * 1;
config.fams.sexts.sigma_y    = 40 * um * 1;
config.fams.sexts.sigma_roll = 0.30 * mrad * 1;
config.fams.sexts.sigma_e    = 0.05 * percent * 1;

%ERRORS FOR DIPOLES B1 AND B2 ARE DEFINED IN GIRDERS AND IN THE
%MAGNET BLOCKS

% <dipoles with only one piece> alignment, rotation and excitation errors
config.fams.b3bc.labels     = {'b3','bc'};
config.fams.b3bc.sigma_y    = 40 * um * 1;
config.fams.b3bc.sigma_x    = 40 * um * 1;
config.fams.b3bc.sigma_roll = 0.30 * mrad * 1;
config.fams.b3bc.sigma_e    = 0.05 * percent * 1;
config.fams.b3bc.sigma_e_kdip = 0.10 * percent * 1;  % quadrupole errors due to pole variations

% <girders> alignment and rotation
config.girder.girder_error_flag = true;
config.girder.correlated_errors = false;
config.girder.sigma_x     = 80 * um * 1;
config.girder.sigma_y     = 80 * um * 1;
config.girder.sigma_roll  = 0.30 * mrad * 1;

% sets number of segmentations for each family
families = fieldnames(config.fams);
for i=1:length(families)
    family = families{i};
    labels = config.fams.(family).labels;
    config.fams.(family).nrsegs = zeros(1,length(labels));
    for j=1:length(labels)
        config.fams.(family).nrsegs(j) = family_data.(labels{j}).nr_segs;
    end
end

% <dipole pieces> alignment, rotation and excitation
% errors for each 
config.fams.bendblocks.labels       = {'b1','b2'};
config.fams.bendblocks.nrsegs       = [1,1];
config.fams.bendblocks.sigma_x      = 40 * um * 1;
config.fams.bendblocks.sigma_y      = 40 * um * 1;
config.fams.bendblocks.sigma_roll   = 0.30 * mrad * 1;
config.fams.bendblocks.sigma_e      = 0.05 * percent * 1;
config.fams.bendblocks.sigma_e_kdip = 0.10 * percent * 1;  % quadrupole errors due to pole variations


% generates error vectors
nr_machines   = 20;
rndtype       = 'gaussian';
cutoff_errors = 1;
fprintf('-  generating errors ...\n');
errors        = lnls_latt_err_generate_errors(name, the_ring, config, nr_machines, cutoff_errors, rndtype);

% applies errors to machines
fractional_delta = 1;
fprintf('-  creating %i random machines and applying errors ...\n', nr_machines);
fprintf('-  finding closed-orbit distortions with sextupoles off ...\n\n');
machine = lnls_latt_err_apply_errors(name, the_ring, errors, fractional_delta(1)); 
    

%% BPM and Correctors Errors
function machine = create_apply_bpm_errors(machine, family_data, name)

% BPM  anc Corr errors are treated differently from magnet errors:
% constants
um = 1e-6; mrad = 0.001; percent = 0.01;

control.bpm.idx = family_data.bpm.ATIndex;
control.bpm.sigma_offsetx   = 20 * um * 1;
control.bpm.sigma_offsety   = 20 * um * 1;

cutoff_errors = 1;
machine = lnls_latt_err_generate_apply_bpmcorr_errors(name, machine, control, cutoff_errors);

    

%% Cod Correction
function machine = correct_orbit(the_ring, machine, family_data, name, name_saved_machines)
    % parameters for slow correction algorithms

orbit.bpm_idx = sort(family_data.bpm.ATIndex);
orbit.hcm_idx = sort(family_data.chs.ATIndex);
orbit.vcm_idx = sort(family_data.cvs.ATIndex);

orbit.sext_ramp         = [0 1];
orbit.svs               = 'all';
orbit.max_nr_iter       = 50;
orbit.tolerance         = 1e-5;
orbit.correct2bba_orbit = false;
orbit.simul_bpm_err     = false;

nper = 10;
orbit.respm = calc_respm_cod(the_ring, orbit.bpm_idx, orbit.hcm_idx, orbit.vcm_idx, nper, true);
orbit.respm = orbit.respm.respm;
machine = lnls_latt_err_correct_cod(name, machine, orbit);

name_saved_machines = [name_saved_machines,'_machines_cod_corrected'];
save([name_saved_machines '.mat'], 'machine');
    

%% Coupling Correction
function machine = correct_coupling(the_ring, machine, family_data, name, name_saved_machines)

coup.scm_idx = sort(family_data.qs.ATIndex);
coup.bpm_idx = sort(family_data.bpm.ATIndex);
coup.hcm_idx = sort(family_data.chs.ATIndex);
coup.vcm_idx = sort(family_data.cvs.ATIndex);
coup.svs           = 'all';
coup.max_nr_iter   = 50;
coup.tolerance     = 1e-5;
coup.simul_bpm_corr_err = false;

% calcs coupling symmetrization matrix
nper = 10;
fname = [name '_info_coup.mat'];
%         if ~exist(fname, 'file')
    [respm, info] = calc_respm_coupling(the_ring, coup, nper);
    coup.respm = respm;
    save(fname, 'info');
%         else
%             data = load(fname);
%             [respm, ~] = calc_respm_coupling(the_ring, coup, nper, data.info);
%             coup.respm = respm;
%         end
machine = lnls_latt_err_correct_coupling(name, machine, coup);

name_saved_machines = [name_saved_machines '_coup'];
save([name_saved_machines '.mat'], 'machine');

    
%% Tune Correction
function machine = correct_tune(the_ring, machine, name_saved_machines)
    
tune.correction_flag = false;
tune.families        = {'qfa','qdb2','qfb','qdb1','qda'};
[~, tune.goal]       = twissring(the_ring,0,1:length(the_ring)+1);
tune.max_iter        = 10;
tune.tolerance       = 1e-6;

% faz correcao de tune
machine = lnls_latt_err_correct_tune_machines(tune, machine);

name_saved_machines = [name_saved_machines '_tune'];
save([name_saved_machines '.mat'], 'machine');



%% Multipoles insertion
function machine = create_apply_multipoles(the_ring, machine, family_data, name, name_saved_machines)
    

 % QUADRUPOLES
multi.quadsM.labels = {'qdb1','qda', 'qfa','qfb','qdb2','qf1','qf2','qf3','qf4'};
multi.quadsM.main_multipole = 2;% positive for normal negative for skew
multi.quadsM.r0 = 11.7e-3;
multi.quadsM.order     = [ 3   4   5   6]; % 1 for dipole
multi.quadsM.main_vals = ones(1,4)*1.5e-4;
multi.quadsM.skew_vals = ones(1,4)*0.5e-4;

% SEXTUPOLES
multi.sexts.labels = {'sda','sfa','sd1','sf1','sd2','sd3','sf2','sf3','sd4','sd5','sf4','sd6','sdb','sfb'};
multi.sexts.main_multipole = 3;% positive for normal negative for skew
multi.sexts.r0 = 11.7e-3;
multi.sexts.order     = [4   5   6   7 ]; % 1 for dipole
multi.sexts.main_vals = ones(1,4)*1.5e-4;
multi.sexts.skew_vals = ones(1,4)*0.5e-4;

% DIPOLES
multi.bends.labels = {'b1','b2','b3', 'bc'};
multi.bends.main_multipole = 1;% positive for normal negative for skew
multi.bends.r0 = 11.7e-3;
multi.bends.order = [ 3   4   5   6]; % 1 for dipole
multi.bends.main_vals = ones(1,4)*1.5e-4;
multi.bends.skew_vals = ones(1,4)*0.5e-4;

 % sets number of segmentations for each family
families = fieldnames(multi);
for i=1:length(families)
    family = families{i};
    labels = multi.(family).labels;
    multi.(family).nrsegs = zeros(1,length(labels));
    for j=1:length(labels)
        multi.(family).nrsegs(j) = family_data.(labels{j}).nr_segs;
    end
end

% adds systematic multipole errors to random machines
for i=1:length(machine)
    machine{i} = sirius_si_multipole_systematic_errors(machine{i});
end
fname = which('sirius_si_multipole_systematic_errors');
copyfile(fname, [name '_multipole_systematic_errors.m']);

cutoff_errors = 2;
multi_errors  = lnls_latt_err_generate_multipole_errors(name, the_ring, multi, length(machine), cutoff_errors);
machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);
        
name_saved_machines = [name_saved_machines '_multi'];
save([name_saved_machines '.mat'], 'machine');

    
    
%% finalizations
function finalizations()

% closes diary and all open plots
diary 'off'; fclose('all');

