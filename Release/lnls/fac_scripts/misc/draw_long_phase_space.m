function draw_long_phase_space(the_ring)

[~, the_ring] = setcavity('on',the_ring); 
[~, ~, ~, ~, ~, ~, the_ring] = setradiation('on',the_ring);

orb = findorbit6(the_ring);
% orb = [findorbit4(the_ring,0);0;0];


var_grid = linspace(-0.75e-2, 0 ,8);
% var_grid = linspace(-1e-3, 1e-3 ,11);
ngrid = length(var_grid);
nturns = 5000;

xini  = var_grid;% -5.5e-3*ones(1,ngrid);
xlini = 0*ones(1,ngrid);
yini  = 0.5e-3*ones(1,ngrid);
ylini = 0*ones(1,ngrid);
enini = 0*ones(1,ngrid);
long_ini = 0*ones(1,ngrid);

Rin = repmat(orb,1,ngrid) + [xini;xlini;yini;ylini;enini;long_ini];

out = ringpass(the_ring,Rin,nturns);

en = reshape(out(5,:),ngrid,nturns)';
s  = reshape(out(6,:),ngrid,nturns)';
x  = reshape(out(1,:),ngrid,nturns)';
xl = reshape(out(2,:),ngrid,nturns)';
y  = reshape(out(3,:),ngrid,nturns)';
yl = reshape(out(4,:),ngrid,nturns)';
isnan(s(end,:))


% figure; plot(x,xl,'.');
figure; plot(x);
% figure; plot(y,yl,'.');
% figure; plot(y);
figure; plot(s,en,'.');
% figure; plot(en);

f = fft(x);
% figure;plot((1:nturns)/nturns,abs(f));
f = fft(y);
% figure;plot((1:nturns)/nturns,abs(f));
f = fft(s-s(1,1));
figure;plot((1:nturns)/nturns,abs(f));