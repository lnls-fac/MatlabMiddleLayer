function the_ring = sirius_si_multipole_systematic_errors(the_ring)

% multipole order convention: n=0(dipole), n=1(quadrupole), and so on. 
   
fam_data = sirius_si_family_data(the_ring);

% DIPOLES
% =======
% The default systematic multipoles for the dipoles were changed.
% Now we are using the values of a standard pole dipole which Ricardo
% optimized (2015/02/02) as base for comparison with the other alternative with
% incrusted coils in the poles for independent control of que gradient.

model_name = 'BEND';
r0         = 11.7/1000;
monoms     =   [2,      3,      4,     5,     6];
Bn_normal  = 1*[1.4e-4 -6.7e-5 -5.1e-4 5.9e-5 3.3e-4];  
Bn_skew    = 1*[0.0     0.0     0.0    0.0    0.0]; 
main_monom = {0, 'normal'}; 
fams       = findmemberof(model_name);
the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% QUADRUPOLES Q14 MODEL2
% ======================
model_name = 'q14';
r0         = 11.7/1000;
% systematic multipoles from '2015-01-27 Quadrupolo_Anel_QC_Modelo 2_-12_12mm_-500_500mm.txt'
monoms     =   [ 5,       9,       13,       17];
Bn_normal  = 1*[-3.6e-4, +1.4e-3, -5.9e-04, +5.7e-5];
Bn_skew    = 1*[ 0.0,     0.0,     0.0,      0.0];
main_monom = {1, 'normal'}; 
fams       = findmemberof(model_name);
the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% QUADRUPOLES Q20 MODEL3
% ======================
model_name = 'q20';
r0         = 11.7/1000;
% systematic multipoles from '2015-02-10 Quadrupolo_Anel_QM_Modelo 3_-12_12mm_-500_500mm.txt'
monoms     =   [ 5,       9,       13,       17];
Bn_normal  = 1*[-3.7e-4, +1.4e-3, -5.7e-04, +3.8e-5];
Bn_skew    = 1*[ 0.0,     0.0,     0.0,      0.0];
main_monom = {1, 'normal'}; 
fams       = findmemberof(model_name);
the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% QUADRUPOLES Q30 MODEL4
% ======================
model_name = 'q30';
r0         = 11.7/1000;
% systematic multipoles from '2015-02-13 Quadrupolo_Anel_QL_Modelo 4_-12_12mm_-500_500mm.txt'
monoms     =   [ 5,       9,       13,       17];
Bn_normal  = 1*[-3.9e-4, +1.5e-3, -6.0e-04, +4.8e-5];
Bn_skew    = 1*[ 0.0,     0.0,     0.0,      0.0];
main_monom = {1, 'normal'}; 
fams       = findmemberof(model_name);
the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% SEXTUPOLES
% ==========
model_name = 'SEXT';
r0         = 11.7/1000;
% systematic multipoles from '2015-02-03 Sextupolo_Anel_S_Modelo 1_-12_12mm_-500_500mm.txt'
monoms     =   [ 4,       6,       8,       14];
Bn_normal  = 1*[-6.7e-5, -1.3e-4, -2.1e-3, +1.0e-3];
Bn_skew    = 1*[ 0.0,     0.0,     0.0,     0.0];
main_monom = {2, 'normal'}; 
fams       = findmemberof(model_name);
the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% CHS
% ===
model_name = 'chs';
r0         = 11.7/1000;
% systematic multipoles from '2015-02-27 Sextupolo_Anel_S_CH_Modelo 1_-12_12mm_-500_500mm.txt'
monoms     =   [ 4,       6,       8,       14];
Bn_normal  = 1*[+2.8e-1, +2.8e-2, -3.9e-2, +1.1e-2];
Bn_skew    = 1*[ 0.0,     0.0,     0.0,     0.0];
main_monom = {0, 'normal'}; 
fams       = findmemberof(model_name);
the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% CVS
% ===
model_name = 'cvs';
r0         = 11.7/1000;
% systematic multipoles from '2015-02-27 Sextupolo_Anel_S_CV_Modelo 1_-12_12mm_-500_500mm.txt'
monoms     =   [ 4,       6,       8,       10     ];
Bn_normal  = 1*[ 0.0,     0.0,     0.0,     0.0,   ];
Bn_skew    = 1*[ -2.6e-1, -3.0e-3, +4.5e-2, -8.3e-3];
main_monom = {0, 'skew'}; 
fams       = findmemberof(model_name);
the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);



function the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0,fam_data)

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
    idx     = fam_data.(family).ATIndex;
    the_ring = lnls_add_multipoles(the_ring, new_Bn_normal, new_Bn_skew, new_main_monomial, r0, idx);
end


