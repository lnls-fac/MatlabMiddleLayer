function r = WLS_comparison

lnls_setpath_mml_at;

inp.energy_deviation = [-0.01 0 0.01];
lnls1_set_server('','','')
lnls1;
setenergymodel(1.37);

% BARE LATTICE
d.label = 'BARE LATTICE';
setoperationalmode(4);
plotbeta;
plottwiss;
d.atsummary = atsummary;
d.QF = getpv('QF', 'Physics');
d.QD = getpv('QD', 'Physics');
d.QFC = getpv('QFC', 'Physics');
%d.dynapt = lnls_dynapt(inp);
r(1) = d;

% LATTICE WITH DIPOLE ERRORS
d.label = 'LATTICE WITH DIPOLE ERRORS';
lnls1_load_multipole_errors;
lnls1_symmetrize_simulation_optics([5.27 4.17], 'QuadFamilies', 'SymmetryPoints');
lnls1_symmetrize_simulation_optics([5.27 4.17], 'QuadFamilies', 'SymmetryPoints');
lnls1_symmetrize_simulation_optics([5.27 4.17], 'QuadFamilies', 'SymmetryPoints');
plotbeta;
plottwiss;
d.atsummary = atsummary;
d.QF = getpv('QF', 'Physics');
d.QD = getpv('QD', 'Physics');
d.QFC = getpv('QFC', 'Physics');
%d.dynapt = lnls_dynapt(inp);
r(2) = d;


% LATTICE WITH DIPOLE ERRORS and IDs
d.label = 'LATTICE WITH DIP ERRORS and IDs';
lnls1_set_id_field('AWG01', 2.0);
lnls1_set_id_field('AWG09', 4.0);
lnls1_set_id_field('AON11', 0.48);
lnls1_symmetrize_simulation_optics([5.27 4.17], 'QuadFamilies', 'SymmetryPoints');
lnls1_symmetrize_simulation_optics([5.27 4.17], 'QuadFamilies', 'SymmetryPoints');
lnls1_symmetrize_simulation_optics([5.27 4.17], 'QuadFamilies', 'SymmetryPoints');
lnls1_symmetrize_simulation_optics([5.27 4.17], 'SimpleTuneCorrectors', 'OnlyTunes');
lnls1_symmetrize_simulation_optics([5.27 4.17], 'SimpleTuneCorrectors', 'OnlyTunes');
plotbeta;
plottwiss;
d.atsummary = atsummary;
d.QF = getpv('QF', 'Physics');
d.QD = getpv('QD', 'Physics');
d.QFC = getpv('QFC', 'Physics');
%d.dynapt = lnls_dynapt(inp);
r(3) = d;





% LATTICE WITH DIPOLE ERRORS, IDs and AWS07
d.label = 'LATTICE WITH DIPOLE ERRORS, IDs and AWS07';
lnls1_set_id_field('AWS07', 2.304827359446053);
lnls1_symmetrize_simulation_optics([5.27 4.17], 'AllSymmetries');
lnls1_symmetrize_simulation_optics([5.27 4.17], 'AllSymmetries');
lnls1_symmetrize_simulation_optics([5.27 4.17], 'AllSymmetries');
lnls1_symmetrize_simulation_optics([5.27 4.17], 'SimpleTuneCorrectors', 'OnlyTunes');
lnls1_symmetrize_simulation_optics([5.27 4.17], 'SimpleTuneCorrectors', 'OnlyTunes');
plotbeta;
plottwiss;
d.atsummary = atsummary;
d.QF = getpv('QF', 'Physics');
d.QD = getpv('QD', 'Physics');
d.QFC = getpv('QFC', 'Physics');
%d.dynapt = lnls_dynapt(inp);
r(4) = d;



