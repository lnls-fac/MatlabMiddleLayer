function the_ring = sirius_bo_multipole_systematic_errors(the_ring)

% multipole order convention: n=0(dipole), n=1(quadrupole), and so on. 
   
fam_data = sirius_bo_family_data(the_ring);

% DIPOLES
% =======

%Already applied while building the lattice model


% QF QUADRUPOLES
% ==============
% values based on rotating coil measurements of QF prototypes
r0         = 17.5/1000;
monoms     = [   5,   9,   13];
Bn_normal  = [-1.0, 1.1, 0.08]*1e-3;
Bn_skew    = [ 0.0, 0.0, 0.00];
main_monom = {1, 'normal'}; 
fams       = {'qf'};
the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% QD QUADRUPOLES
% ==============
% updated values in 2015-09-03 for model1 of QD quads with 100 mm physical length (XRR) (@ 3GeV excitation)
r0         = 17.5/1000;
monoms     = [   5,   9,   13];
Bn_normal  = [-4.7, 1.2, 1.2]*1e-3;
Bn_skew    = [ 0.0, 0.0, 0.00];
main_monom = {1, 'normal'}; 
fams       = {'qd'};
the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% SEXTUPOLES
% ==========
% updated in 2015-09-03 for model1 of SD/SF with 100 mm physical length (XRR)
r0         = 17.5/1000;
monoms     = [   8,   14];
Bn_normal  = [-2.5, -1.5]*1e-2;    
Bn_skew    = [ 0.0,  0.0];
main_monom = {2, 'normal'}; 
fams       = {'sd','sf'};
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
    idx     = fam_data.(family).ATIndex';
    idx     = idx(:);
    the_ring = lnls_add_multipoles(the_ring, new_Bn_normal, new_Bn_skew, new_main_monomial, r0, idx);
end


