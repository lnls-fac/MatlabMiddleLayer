function symplectic_runge_kutta

Lb   = 0.5;
L    = Lb + 3.5;
npts = 100;
g    = 0*ones(1,npts);
k    = 0*ones(1,npts);




chi_old = calc_chi(L,npts,k,g);
for i=1:2000000
    k_new = new_optics(L,npts,k);
    chi_new = calc_chi(L,npts,k_new);
    if (chi_new <= chi_old) && optics_is_ok(L,npts,k_new)
        k = k_new;
        chi_old = chi_new;
        fprintf('%i %f\n', i, chi_new);
    end
    if chi_new < 0.00001, break; end
end

plot_functions(L,npts,k)

function r = optics_is_ok(L,npts,k)

r = (max(abs(k))<3);


function r = calc_chi(L,npts,k)

LBEND = 1;
[CF DCF SF DSF] = integrate(L,npts,k);
r = + 1*(CF(end) + 7/2)^2 ...
    + 1*(SF(end) - 3*LBEND/2)^2 ...
    + 1*(DCF(end)-15*LBEND/2)^2 ...
    + 1*(DSF(end) + 7/2)^2 ...
    ;
r = sqrt(r);

function plot_functions(L,npts,k)

s = linspace(0,L,npts);
[CF DCF SF DSF] = integrate(L,npts,k);
plot(s,CF, 'b');
hold all
plot(s,DCF, 'b');
plot(s,SF, 'r');
plot(s,DSF, 'r');
figure
plot(s,k)
M = [CF(end) SF(end); DCF(end) DSF(end)];
disp(M);

function k1 = new_optics(L,npts,k0)

idx = randi(length(k0));
val = 2*(rand-0.5) * 1 * 0.01;
k1 = k0;
k1(idx) = k1(idx) + val;

k1 = 0.5 * (k1 + k1(sort(1:length(k1), 'descend')));

function [CF DCF SF DSF] = integrate(L,npts,k)

delta = L/(npts-1);


% COS function
% ============
q = zeros(1,npts);
p = zeros(1,npts);
q(1)=1;
for i=1:npts-1 
    q(i+1) = (1-k(i)*delta^2)*q(i) + delta*p(i);
    p(i+1) = -k(i)*delta*q(i) + p(i);
end
CF = q;
DCF = p;

% SIN function
% ============
q = zeros(1,npts);
p = zeros(1,npts);
p(1)=1;
for i=1:npts-1 
    q(i+1) = (1-k(i)*delta^2)*q(i) + delta*p(i);
    p(i+1) = -k(i)*delta*q(i) + p(i);
end
SF = q;
DSF = p;


