inp = struct;

inp.nr_machines = 50;       % número de máquinas aleatórias

percent = 0.01;
micrometer = 1e-6;
millirad = 1e-3;

% erros: [strength X Z rot]
sigS = 1 * 0.05 * percent;
sigX = 1 * 30 * micrometer;
sigZ = 1 * 30 * micrometer;
sigA = 1 * 0.2 * millirad;
edist = 'U';
ntrunc=1;

n = 1;
inp.lattice_errors = {};

inp.lattice_errors{n}.elements = 'QUAD';
inp.lattice_errors{n}.distribution = edist;
inp.lattice_errors{n}.sigma = [sigS sigX sigZ sigA];
inp.lattice_errors{n}.trunc = ntrunc;
n = n + 1;

inp.lattice_errors{n}.elements = 'BEND';
inp.lattice_errors{n}.distribution = edist;
inp.lattice_errors{n}.sigma = [sigS 0 0 sigA];
inp.lattice_errors{n}.trunc = ntrunc;
n = n + 1;

inp.lattice_errors{n}.elements = 'SEXT';
inp.lattice_errors{n}.distribution = edist;
inp.lattice_errors{n}.cluster_size = 2;
inp.lattice_errors{n}.sigma = [sigS sigX sigZ sigA];
inp.lattice_errors{n}.trunc = ntrunc;
n = n + 1;


%{
inp.lattice_errors{n}.elements = 1:10;
inp.lattice_errors{n}.distribution = edist;
inp.lattice_errors{n}.sigma = [sigS sigX sigZ sigA];
inp.lattice_errors{n}.trunc = ntrunc;
n = n + 1;
%}

%{
inp.lattice_errors{n}.elements = 'BO';
inp.lattice_errors{n}.distribution = edist;
inp.lattice_errors{n}.sigma = [sigS sigX sigZ sigA];
inp.lattice_errors{n}.trunc = ntrunc;
n = n + 1;


inp.lattice_errors{n}.elements = 'BIE';
inp.lattice_errors{n}.distribution = edist;
inp.lattice_errors{n}.sigma = [sigS 0 0 sigA];
inp.lattice_errors{n}.trunc = ntrunc;
n = n + 1;


inp.lattice_errors{n}.elements = 'BIS';
inp.lattice_errors{n}.distribution = edist;
inp.lattice_errors{n}.sigma = [sigS 0 0 sigA];
inp.lattice_errors{n}.trunc = ntrunc;
n = n + 1;


inp.lattice_errors{n}.elements = 'BC';
inp.lattice_errors{n}.cluster_size = 2;
inp.lattice_errors{n}.distribution = edist;
inp.lattice_errors{n}.sigma = [sigS 0 0 sigA];
inp.lattice_errors{n}.trunc = ntrunc;
n = n + 1;
%}

r = orbit_correlation_matrix(@siriuslattice, inp);
 

