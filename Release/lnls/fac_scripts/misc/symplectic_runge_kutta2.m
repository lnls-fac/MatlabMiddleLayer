function symplectic_runge_kutta2(h);

r.handle = h;
r.betay0          = 3;
r.alfy0           = 0;

r.max_k           = 3.0;
r.dipole_rho      = 5.003640424877480;
r.dipole_length   = 1.7*3^(1/3);
r.line_length     = 2.5;
r.nr_elements     = 7;
r.length_vector   = (r.line_length/r.nr_elements) * ones(1,r.nr_elements);
r.strength_vector = 0 * ones(1, r.nr_elements);
r.transfer_matrix = calc_line_transfer_matrix(r);
r.chi2            = calc_chi2(r);

r_old = r;

i0 = 1;
for i=1:200000
r_new = new_line(r_old);
if (r_new.chi2 <= r_old.chi2) && line_is_ok(r_new)
    r_old = r_new;
    fprintf('%i %f\n', i, r_new.chi2);
    if (i-i0 > 1000)
        plot_results(r_old);
        i0 = i;
    end
end
if r_old.chi2 < 0.00001, break; end
end

r = r_old;

function plot_results(r)

s = 0;
vs = [];
vk = [];
for i=1:r.nr_elements
    vs = [vs s s+r.length_vector(i)];
    vk = [vk r.strength_vector(i) r.strength_vector(i)];
    s = s + r.length_vector(i);
end
figure(r.handle);
axis([0 r.line_length -r.max_k r.max_k]);
plot([0 r.line_length], [0 0]);
%hold all
plot(vs, vk);
axis([0 r.line_length -r.max_k r.max_k]);


function ok = line_is_ok(r)

ok = max(abs(r.strength_vector)) < r.max_k;


function r = new_line(r0)

length_delta   = 0.01;
strength_delta = 0.01;

r = r0;
rn1 = randi(2);
rn2 = randi(r.nr_elements);
rn3 = 2 * (rand - 0.5);

rn1 = 2;
if rn1==1
    length_step = length_delta * rn3;
    r.length_vector(rn2) = abs(r.length_vector(rn2) + length_step);
else
    strength_step = strength_delta * rn3;
    r.strength_vector(rn2) = r.strength_vector(rn2) + strength_step;
end


r.length_vector = 0.5*(r.length_vector + fliplr(flipud(r.length_vector)));
r.strength_vector = 0.5*(r.strength_vector + fliplr(flipud(r.strength_vector)));

tot_length = 0;
for i=1:r.nr_elements
    tot_length = tot_length + r.length_vector(i);
end
for i=1:r.nr_elements
    r.length_vector(i) = (r.line_length / tot_length) * r.length_vector(i);
end


r.transfer_matrix = calc_line_transfer_matrix(r);
r.chi2 = calc_chi2(r);

%chisqrt(sum((r.strength_vector(2:end) - r.strength_vector(1:end-1)).^2)/(r.nr_elements-1)));


    
function chi2 = calc_chi2(r)

TM   = r.transfer_matrix;
TM0  = [-7/2 3*r.dipole_length/2; 15/(2*r.dipole_length) -7/2];
chi2 = sqrt(sum(sum((TM - TM0).^2)));

function TM = calc_line_transfer_matrix(r)

TM = calc_elem_transfer_matrix(0,0);
for i=1:r.nr_elements
    elem_TM = calc_elem_transfer_matrix(r.length_vector(i), r.strength_vector(i));
    TM = elem_TM * TM;
end


function TM = calc_elem_transfer_matrix(ele_length, ele_strength)

w = sqrt(ele_strength) * ele_length;
s = sin(w);
c = cos(w);
r = sqrt(ele_strength);

if abs(ele_strength) < 1e-8
    M11 = 1;
    M12 = ele_length;
    M21 = 0;
    M22 = 1;
else
    M11 = real(c);
    M12 = real(s/r);
    M21 = real(-r*s);
    M22 = real(c);
end
TM = [M11 M12; M21 M22];

