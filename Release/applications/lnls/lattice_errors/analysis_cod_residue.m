function analysis_cod_residue

case_folder   = 'CONFIG_V403_AC10_5_bpmsmoving';
config_folder = fullfile(pwd, case_folder);

% CODs
fname   = fullfile(config_folder, [case_folder '_codx_corrected.dat']); codx = load(fname);
fname   = fullfile(config_folder, [case_folder '_cody_corrected.dat']); cody = load(fname);

% Misalignments
fname   = fullfile(config_folder, [case_folder '_errors_x.dat']); errorx = load(fname);
fname   = fullfile(config_folder, [case_folder '_errors_y.dat']); errory = load(fname);

% Lattice
fname   = fullfile(config_folder, [case_folder '_the_ring.mat']); the_ring = load(fname); the_ring = the_ring.the_ring;


% sextupole indices
sexts = [];
sexts = [sexts; findcells(the_ring, 'FamName', 'sa1')'];
sexts = [sexts; findcells(the_ring, 'FamName', 'sa2')'];
sexts = [sexts; findcells(the_ring, 'FamName', 'sb1')'];
sexts = [sexts; findcells(the_ring, 'FamName', 'sb2')'];
sexts = [sexts; findcells(the_ring, 'FamName', 'sd1')'];
sexts = [sexts; findcells(the_ring, 'FamName', 'sd2')'];
sexts = [sexts; findcells(the_ring, 'FamName', 'sd3')'];
sexts = [sexts; findcells(the_ring, 'FamName', 'sf1')'];
sexts = [sexts; findcells(the_ring, 'FamName', 'sf2')'];
sexts = sort(sexts);

% sextupoles strength
L = getcellstruct(the_ring, 'Length', sexts);
S = getcellstruct(the_ring, 'PolynomB', sexts, 1, 3);


% relative cods
rcodx = 1e-6*(codx(:,sexts) - errorx(:,sexts));
rcody = 1e-6*(cody(:,sexts) - errory(:,sexts));

% extra focusing
K = 2 * rcodx .* repmat((S.*L)', size(rcodx,1), 1);

% extra coupling
C = 2 * rcody .* repmat((S.*L)', size(rcody,1), 1);

% statistics
rcodx_rms = sqrt(sum(rcodx.^2)/size(rcodx,1));
rcody_rms = sqrt(sum(rcody.^2)/size(rcody,1));
K_rms     = sqrt(sum(K.^2)/size(K,1));
C_rms     = sqrt(sum(C.^2)/size(C,1));

fprintf('mean codx @ sexts  r.m.s.: %5.2f um\n',    1e6*mean(rcodx_rms));
fprintf('mean cody @ sexts  r.m.s.: %5.2f um\n',    1e6*mean(rcody_rms));
fprintf('mean dK (focusing) r.m.s.: %7.5f 1/m^2\n', mean(K_rms));
fprintf('mean dC (coupling) r.m.s.: %7.5f 1/m^2\n', mean(C_rms));


plot(1e6*rcodx_rms);
xlabel('Sextupole Index'); ylabel('COD r.m.s. [\mu m]');