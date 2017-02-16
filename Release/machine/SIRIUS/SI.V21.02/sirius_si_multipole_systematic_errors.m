function the_ring = sirius_si_multipole_systematic_errors(the_ring,fam_data)

% multipole order convention: n=0(dipole), n=1(quadrupole), and so on. 
   
% ---- current model of sextupoles ---

% SEXTUPOLES COILS
% ================
fams = {'sn'};
r0         = 12/1000;
% systematic multipoles from '2016-01-29 Sextupolo_Anel_S_Modelo 5_-14_14mm_-500_500mm.txt'
monoms     =   [ 1,           2,           3,           4,           6,           7,           8,           9,           10,          13,          14];
Bn_normal  = 1*[+0.0000e+00, +0.0000e+00, +0.0000e+00, +2.1375e-04, -5.8657e-04, +0.0000e+00, -2.1622e-03, +0.0000e+00, +0.0000e+00, +0.0000e+00, +0.0000e+00];
Bn_skew    = 1*[-2.7682e-11, -4.2157e-07, +9.1876e-11, +2.4706e-06, -5.8532e-06, -2.3938e-10, +6.0205e-06, +2.0654e-10, -2.2377e-06, -3.1102e-11, +0.0000e+00];
main_monom = {2, 'normal'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% CH COILS IN SEXTUPOLES
% ======================
fams = {'CH'};
r0         = 12/1000;
% systematic multipoles from '2016-02-01 Sextupolo_Anel_S_CH_Modelo 5_-14_14mm_-500_500mm.txt'
monoms     =   [ 1,           2,           3,           4,           6,           7,           8,           9,           10,          13,          14];
Bn_normal  = 1*[-0.0000e+00, +2.7095e-03, -0.0000e+00, +2.9399e-01, +7.5225e-02, -0.0000e+00, -4.4112e-02, -0.0000e+00, -0.0000e+00, -0.0000e+00, +3.1510e-03];
Bn_skew    = 1*[+4.1723e-05, -1.2690e-03, -2.3411e-04, +7.4254e-03, -1.7352e-02, +1.4442e-03, +1.7496e-02, -1.7058e-03, -6.4012e-03, +5.0200e-04, -0.0000e+00];
main_monom = {0, 'normal'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% CV COILS IN SEXTUPOLES
% ======================
%fams = {'CV'}; % this should be changed to 'CVs' (CVs in sextupoles) XRR 2017-02-01 !!!
fams = {'CVS'}; 
r0         = 12/1000;
% systematic multipoles from '2016-02-01 Sextupolo_Anel_S_CV_Modelo 5_-14_14mm_-500_500mm.txt'
monoms     =   [ 1,           2,           3,           4,           6,           7,           8,           9,           10,          13,          14];
Bn_normal  = 1*[-0.0000e+00, +8.9809e-04, -0.0000e+00, -3.7395e-03, +1.1069e-02, -0.0000e+00, -1.1097e-02, -0.0000e+00, -0.0000e+00, -0.0000e+00, +3.3551e-03];
Bn_skew    = 1*[+3.8618e-05, -1.4830e-03, -2.2187e-04, -2.9344e-01, +1.2617e-02, +1.3048e-03, +3.3651e-02, -1.4938e-03, -5.7924e-04, +4.1594e-04, -0.0000e+00];
main_monom = {0, 'skew'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% QS COILS IN SEXTUPOLES
% ======================
%fams = {'qs'}; % this should be changed to 'qss' (QSs in sextupoles) XRR 2017-02-01 !!!
fams = {'QSS'};
r0         = 12/1000;
% systematic multipoles from '2015-02-01 Sextupolo_Anel_S_QS_Modelo 5_-14_14mm_-500_500mm.txt'
monoms    = [ 1,           2,           3,           4,           6,           7,           8,           9,           10,          13,          14];
Bn_normal = [-0.0000e+00, +1.9374e-03, -0.0000e+00, -1.0388e-02, +2.8264e-02, -0.0000e+00, -2.5529e-02, -0.0000e+00, -0.0000e+00, -0.0000e+00, +6.8507e-03];
Bn_skew   = [-0.0000e+00, -2.1055e-03, -5.7765e-01, +1.2248e-02, -2.8575e-02, +2.5363e-02, +2.8797e-02, +1.3401e-02, -1.0545e-02, -1.1152e-03, -0.0000e+00];
main_monom = {1, 'skew'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);


% FAST CORRECTORS - CH
% ====================
fams = {'FCH'};
r0         = 12/1000;
% systematic multipoles from '2017-01-05_SI_FC_Model02_Sim_X=-12_12mm_Z=-250_250mm_Ich=1A.txt'
monoms    = [ 0,           2,           8];
Bn_normal = [-0.0000e+00, -4.6145e-01, -4.2699e-02];
Bn_skew   = [-0.0000e+00, -0.0000e+00, -0.0000e+00];
main_monom = {0, 'normal'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% FAST CORRECTORS - CV
% ====================
fams = {'FCV'};
r0         = 12/1000;
% systematic multipoles from '2017-01-05_SI_FC_Model02_Sim_X=-12_12mm_Z=-250_250mm_ICV=1A.txt'
monoms    = [ 0,           2,           8];
Bn_normal = [-0.0000e+00, -0.0000e+00, -0.0000e+00];
Bn_skew   = [-0.0000e+00, +4.8318e-01, +4.6613e-02];
main_monom = {0, 'skew'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% QS COIILS IN FAST CORRECTORS
% ============================
fams = {'FCQ'};
r0         = 12/1000;
% systematic multipoles from
% '2017-01-05_SI_FC_Model02_Sim_X=-12_12mm_Z=-250_250mm_Iqs=3A.txt'
monoms    = [ 1,           5,           9            13];
Bn_normal = [-0.0000e+00, -0.0000e+00, -0.0000e+00, -0.0000e+00];
Bn_skew   = [-0.0000e+00, +6.6776e-02, -3.2592e-02, +1.9925e-02];
main_monom = {1, 'skew'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);


function the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0,fam_data)

% expands lists of multipoles
new_monomials = monoms+1;    % converts to tracy convention of multipole order
new_Bn_normal = zeros(max(new_monomials),1);
new_Bn_skew   = zeros(max(new_monomials),1);
new_Bn_normal(new_monomials,1) = Bn_normal;
new_Bn_skew(new_monomials,1)   = Bn_skew;
if strcmpi(main_monom{2}, 'normal')
    new_main_monomial = main_monom{1} + 1;
else
    new_main_monomial = -(main_monom{1} + 1);
end

% adds multipoles
for i=1:length(fams)
    family  = fams{i};
    idx     = fam_data.(family).ATIndex';
    idx     = idx(:);
    the_ring = lnls_add_multipoles(the_ring, new_Bn_normal, new_Bn_skew, new_main_monomial, r0, idx);
end


