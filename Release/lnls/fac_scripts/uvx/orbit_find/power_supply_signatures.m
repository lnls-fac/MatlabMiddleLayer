function r = power_supply_signatures

fclose('all'); close('all'); clc;

r.parms.the_ring_fname = 'the_ring_orb.mat';
r.flags = {'save_the_ring','load_the_ring'};
r.parms.families =  {'A2QF01', 'A2QF03', 'A2QF05', 'A2QF07', 'A2QF09', 'A2QF11', 'A2QD01', 'A2QD03', 'A2QD05', 'A2QD07', 'A2QD09', 'A2QD11', 'A6QF01', 'A6QF02','A6SD01','A6SD02','A6SF'};
r = fit_load_lattice_model(r);
r = fit_get_measured_data(r);

r.ripples = load('ripple amplitudes at power harmonics.mat'); r.ripples = r.ripples.ripples;
r = plot_signatures(r);


fit_orbit(r);

function fit_orbit(r)

fclose('all'); close('all');

% -- 60Hz --, 
%nr_svs = 3;
orb = [0.0028541526 -0.0017696418 -0.0040397117 0.0018174998 0.0013374697 -6.79E-05 -0.0004906471 -0.0018613998 -0.0008792949 0.0002078923 8.97E-05 -0.0012804712 -0.0003632695 -0.0005070003 -0.0010675449 -6.35E-05 0.0005177138 0.0001405699 -0.00210289 -0.0020057087 0.0027410281 0.0026601515 -0.0029089144 -0.0031176085 0.0038496511]' * 1000;

% -- 360Hz --,
%nr_svs = 2;
orb = [0.0027768989 0.000228053 -9.82E-05 -0.00084513 -0.0001360801 -0.0001728362 0.0011090053 0.0007402546 -0.0022542433 -0.0022727581 0.000809663 0.0007717294 -0.001233496 -0.0021115061 -0.0003471187 0.0002596728 0.0006437578 -0.000110621 -0.0012132167 -0.0003952882 0.0025354754 0.0022265001 -0.0009884179 -0.0010738912 0.0015916489]' * 1000;


families = r.parms.families;
for i=1:length(families)
    family = families{i};
    Mx(:,i) = r.meas_data.(family).sigx;
end

[U,S,V] = svd(Mx,'econ');

% vs = diag(S);
% sel = ((1:length(vs)) > nr_svs);
% ivs = 1./vs;
% ivs(sel) = 0;
% iS = diag(ivs);
% dA = (V*iS*U')*orb;
% orbt = Mx * dA;
% figure; plot([orb orbt]);
% legend({'FOFB HCOD', 'Reconstructed HCOD'})
    
%return;

for i=1:17
    nr_svs = i;
    vs = diag(S);
    sel = ((1:length(vs)) > nr_svs);
    ivs = 1./vs;
    ivs(sel) = 0;
    iS = diag(ivs);
    dA = (V*iS*U')*orb;
    orbt = Mx * dA;
    figure; plot([orb orbt]);
    fprintf('%02i: %5.1f [um] -> %5.1f[mA]\n', i, max(abs(orbt - orb)), max(abs(dA)));
end



function r = plot_signatures(r0)

r = r0;

leg = {};
hx = figure; hold all;
hy = figure; hold all;
families = r.parms.families;
rms_x = 0; rms_y = 0;
for i=1:length(families)
    family = families{i};
    A1 = getpv(family, 'Hardware'); steppv(family, r.meas_data.(family).dK, 'Physics');
    A2 = getpv(family, 'Hardware'); steppv(family, -r.meas_data.(family).dK, 'Physics');
    dA = (A2(1) - A1(1)) * 1000;
    fprintf('%-6s: %+6.0f mA\n', family, dA);
    sigx = 1e6 * r.meas_data.(family).codx / dA; %  [um/mA]
    sigy = 1e6 * r.meas_data.(family).cody / dA; %  [um/mA]
    r.meas_data.(family).sigx = sigx;
    r.meas_data.(family).sigy = sigy;
    figure(hx); plot(sigx(:,1));
    figure(hy); plot(sigy(:,1));
    leg = [leg family]; 
    rms_x = rms_x + (sigx * r.ripples.(family)).^2;
    rms_y = rms_y + (sigy * r.ripples.(family)).^2;
end
figure(hx); legend(leg); xlabel('BPM Index'); ylabel('COD [um/mA]');
figure(hy); legend(leg); xlabel('BPM Index'); ylabel('COD [um/mA]');
figure; plot(60:60:1080, max(sqrt(rms_x))); xlabel('Freq [Hz]'); ylabel('Max X COD RMS [um]');
figure; plot(60:60:1080, max(sqrt(rms_y))); xlabel('Freq [Hz]'); ylabel('Max Y COD RMS [um]');

fprintf('Fq[Hz]: ');
for i=1:length(r.ripples.A2QF01)
    fprintf('%4i ', 60*i);
end
fprintf('\n');

for i=1:length(families)
    family = families{i};
    ripples = r.ripples.(family);
    fprintf('%-6s: ', family);
    for j=1:length(ripples)
        fprintf('%4.1f ', ripples(j));
    end
    fprintf('\n');
end
