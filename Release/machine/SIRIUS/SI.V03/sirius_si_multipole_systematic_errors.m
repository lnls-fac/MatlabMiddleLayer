function new_the_ring = sirius_si_multipole_systematic_errors(the_ring, parameters)

% multipole order convention: n=0(dipole), n=1(quadrupole), and so on. 

parameter_just_print = (exist('parameters', 'var') && isfield(parameters, 'just_print') && (parameters.just_print));
    
new_the_ring = the_ring;


% DIPOLES
% =======
%The default systematic multipoles for the dipoles were changed.
%Now we are using the values of a standard pole dipole which Ricardo
%optimized (2015/02/02) as base for comparison with the other alternative with
%incrusted coils in the poles for independent control of que gradient.
model_name    = 'BEND';
r0            = 11.7/1000;
monomials     =   [2,      3,      4,     5,     6];
Bn_normal     = 1*[1.4e-4 -6.7e-5 -5.1e-4 5.9e-5 3.3e-4];  
An_skew       = 1*[0.0     0.0     0.0    0.0    0.0]; 
main_monomial = {0, 'normal'}; 
families      = findmemberof(model_name);
if (parameter_just_print)
    printfamily(model_name, r0, monomials, Bn_normal, An_skew, main_monomial, families);
else
    new_the_ring = insert_multipoles(new_the_ring, families, monomials, Bn_normal, An_skew, main_monomial, r0);
end


% QUADRUPOLES Q14 MODEL2
% ======================
model_name    = 'q14';
r0            = 11.7/1000;
monomials     = [ 5,       9,       13,       17];
Bn_normal     = 1*[-3.6e-4, +1.4e-3, -5.9e-04, +5.7e-5];
An_skew       = 1*[ 0.0,     0.0,     0.0,      0.0];
main_monomial = {1, 'normal'}; 
families      = findmemberof(model_name);
if (parameter_just_print)
    printfamily(model_name, r0, monomials, Bn_normal, An_skew, main_monomial, families);
else
    new_the_ring = insert_multipoles(new_the_ring, families, monomials, Bn_normal, An_skew, main_monomial, r0);
end

% QUADRUPOLES Q20 MODEL3
% ======================
model_name    = 'q20';
r0            = 11.7/1000;
monomials     = [ 5,       9,       13,       17];
Bn_normal     = 1*[-3.7e-4, +1.4e-3, -5.7e-04, +3.8e-5];
An_skew       = 1*[ 0.0,     0.0,     0.0,      0.0];
main_monomial = {1, 'normal'}; 
families      = findmemberof(model_name);
if (parameter_just_print)
    fprintf('model name: %s', model_name);
else
    new_the_ring = insert_multipoles(new_the_ring, families, monomials, Bn_normal, An_skew, main_monomial, r0);
end

% QUADRUPOLES Q30 MODEL4
% ======================
model_name    = 'q30';
r0            = 11.7/1000;
monomials     = [ 5,       9,       13,       17];
Bn_normal     = 1*[-3.9e-4, +1.5e-3, -6.0e-04, +4.8e-5];
An_skew       = 1*[ 0.0,     0.0,     0.0,      0.0];
main_monomial = {1, 'normal'}; 
families      = findmemberof(model_name);
if (parameter_just_print)
    fprintf('model name: %s', model_name);
else
    new_the_ring = insert_multipoles(new_the_ring, families, monomials, Bn_normal, An_skew, main_monomial, r0);
end

% SEXTUPOLES
% ==========
model_name    = 'SEXT';
r0            = 11.7/1000;
% systematic multipoles from '2015-02-03 Sextupolo_Anel_S_Modelo 1_-12_12mm_-500_500mm.txt'
monomials     = [ 4,       6,       8,       14];
Bn_normal     = 1*[-6.7e-5, -1.3e-4, -2.1e-3, +1.0e-3];
An_skew       = 1*[ 0.0,     0.0,     0.0,     0.0];
% % original systematic multipoles
% monomials     = [8,       14];
% Bn_normal     = 1*[+4.0e-6, -1.0e-7];
% An_skew       = 1*[+0.0e-0, +0.0e-0];
main_monomial = {2, 'normal'}; 
families      = findmemberof(model_name);
if (parameter_just_print)
    fprintf('model name: %s', model_name);
else
    new_the_ring = insert_multipoles(new_the_ring, families, monomials, Bn_normal, An_skew, main_monomial, r0);
end




function printfamily(model_name, r0, monomials, Bn_normal, An_skew, main_monomial, families)

fprintf('model name: %s', model_name);

function new_the_ring = insert_multipoles(the_ring, families, monomials, Bn_normal, An_skew, main_monomial, r0)

% expands lists of multipoles
new_monomials = monomials+1;    % converts to tracy convention of multipole order
new_Bn_normal = zeros(max(new_monomials),1);
new_An_skew   = zeros(max(new_monomials),1);
new_Bn_normal(new_monomials,1) = Bn_normal;
new_An_skew(new_monomials,1)   = An_skew;
if strcmpi(main_monomial{2}, 'normal')
    new_main_monomial = main_monomial{1} + 1;
else
    new_main_monomial = -(main_monomial{1} + 1);
end

new_the_ring = the_ring;
% adds multipoles
for i=1:length(families)
    family  = families{i};
    idx     = findcells(new_the_ring, 'FamName', family);
    new_the_ring = lnls_add_multipoles(new_the_ring, new_Bn_normal, new_An_skew, new_main_monomial, r0, idx);
end


