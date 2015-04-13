function machine = calc_ripple_effects(r, selection)

global THERING;

fprintf(['--- ripple_effects [' datestr(now) '] ---\n']);

dim = '4d';

the_ring0 = r.params.the_ring;
coupling =  r.params.ref_coupling;

twiss0 = calctwiss(the_ring0);
ats0 = atsummary(the_ring0);
sigmax0 = sqrt(twiss0.betax * ats0.naturalEmittance + (ats0. naturalEnergySpread * twiss0.etax).^2)';
sigmay0 = sqrt(twiss0.betay * ats0.naturalEmittance * coupling)';


if isfield(r.params, 'ripple_rms_x')
    for i=selection
        r.machine{i} = redefine_the_ring(r.machine{i}, dim, r.params.ripple_rms_x, r.params.ripple_rms_y);
        [tx, ty] = calc_cod(r.machine{i}, dim); rmsx = std(tx); rmsy = std(ty);
        fprintf('%03i | codx[um] %5.1f(std) | cody[um] %5.1f(std) \n', i, 1e6*rmsx, 1e6*rmsy);
    end
end


machine1 = r.machine;
fractions = [1];


r.machine = apply_errors(r, fractions, 'ripple');


codx1 = []; cody1 = []; %sigmax1 = []; sigmay1 = [];
codx2 = []; cody2 = []; %sigmax2 = []; sigmay2 = [];
for i=selection
    
    THERING = machine1{i};
    [tx ty] = calc_cod(THERING, dim); codx1 = [codx1; tx(:)']; cody1 = [cody1; ty(:)'];
    %[Tilt, Eta, EpsX, EpsY, Ratio, ENV, DP, DL, sigmas] = calccoupling;
    %sigmax1 = [sigmax1; sigmas(1,1:end-1)]; sigmay1 = [sigmay1; sigmas(2,1:end-1)]; 
    
    THERING = r.machine{i};
    [tx ty] = calc_cod(THERING, dim); codx2 = [codx2; tx(:)']; cody2 = [cody2; ty(:)'];
    %[Tilt, Eta, EpsX, EpsY, Ratio, ENV, DP, DL, sigmas] = calccoupling;
    %sigmax2 = [sigmax2; sigmas(1,1:end-1)]; sigmay2 = [sigmay2; sigmas(2,1:end-1)];
    
end

ripple_codx = codx2 - codx1; ripple_cody = cody2 - cody1;
%sigmax = sqrt(sum(ripple_codx.^2 + repmat(sigmax0,size(ripple_codx,1),1).^2)/size(ripple_codx,1));
%sigmay = sqrt(sum(ripple_cody.^2 + repmat(sigmay0,size(ripple_cody,1),1).^2)/size(ripple_cody,1));
%figure; plot(twiss0.pos, 100*(sigmax-sigmax0) ./ sigmax0);
%figure; plot(twiss0.pos, 100*(sigmay-sigmay0) ./ sigmay0);
mc  = findcells(THERING, 'FamName', 'mc');
ids = [findcells(THERING, 'FamName', 'mia') findcells(THERING, 'FamName', 'mib')];
px1 =  100*sqrt(sum(ripple_codx.^2)/size(ripple_codx,1))./sigmax0;
py1 =  100*sqrt(sum(ripple_cody.^2)/size(ripple_cody,1))./sigmay0;
figure; plot(twiss0.pos, px1); xlabel('Pos [m]'); ylabel('codx rms/sigmax [%]'); if isfield(r.params, 'ripple_string'), title(r.params.ripple_string); end;
figure; plot(twiss0.pos, py1); xlabel('Pos [m]'); ylabel('cody rms/sigmay [%]'); if isfield(r.params, 'ripple_string'), title(r.params.ripple_string); end;
fprintf('max (cod_rms/sigma) [%%] ALL -  x:%+5.1f, y:%+5.1f\n', max(px1), max(py1));
fprintf('max (cod_rms/sigma) [%%] IDS -  x:%+5.1f, y:%+5.1f\n', max(px1(ids)), max(py1(ids)));
fprintf('max (cod_rms/sigma) [%%] BC  -  x:%+5.1f, y:%+5.1f\n', max(px1(mc)), max(py1(mc)));
%figure; plot(twiss0.pos, 100*std(ripple_cody)./sigmay0); xlabel('Pos [m]'); ylabel('cody_rms/sigmay [%%]');
fprintf('\n');



function the_ring = redefine_the_ring(the_ring0, dim, rms_x, rms_y)

hcm = findcells(the_ring0, 'FamName', 'hcm');
vcm = findcells(the_ring0, 'FamName', 'vcm');
% kickx0 = getcellstruct(the_ring0, 'KickAngle', hcm, 1, 1);
% kicky0 = getcellstruct(the_ring0, 'KickAngle', vcm, 1, 2);
kickx0 = lnls_get_kickangle(the_ring0, hcm, 'x');
kicky0 = lnls_get_kickangle(the_ring0, vcm, 'y');
[tx, ty] = calc_cod(the_ring0, dim); rmsx0 = std(tx); rmsy0 = std(ty);

if (rms_x <= rmsx0) || (rms_y <= rmsy0)
    error('not possible to gen ring with smaller cod rms!');
end

the_ring = the_ring0;

r = [1.0 1.0];
rmsm = 0; 
while (rmsm < rms_x)
    r(2) = r(1);
    r(1) = r(1) * 0.9;
    the_ring = lnls_set_kickangle(the_ring, kickx0 * r(1), hcm, 'x');
%     the_ring = setcellstruct(the_ring, 'KickAngle', hcm, kickx0 * r(1), 1, 1);
    [tx, ~] = calc_cod(the_ring, dim);
    rmsm = std(tx);
end
while (abs(rmsm - rms_x) > 1e-6)
    rm = 0.5 * (r(1) + r(2));
    the_ring = lnls_set_kickangle(the_ring, kickx0 * rm, hcm, 'x');
%     the_ring = setcellstruct(the_ring, 'KickAngle', hcm, kickx0 * rm, 1, 1);
    [tx, ~] = calc_cod(the_ring, dim);
    rmsm = std(tx);
    if (rmsm > rms_x)
        r(1) = rm;
    else
        r(2) = rm;
    end
end

r = [1.0 1.0];
rmsm = 0; 
while (rmsm < rms_y)
    r(2) = r(1);
    r(1) = r(1) * 0.9;
    the_ring = lnls_set_kickangle(the_ring, kicky0 * r(1), vcm, 'y');
%     the_ring = setcellstruct(the_ring, 'KickAngle', vcm, kicky0 * r(1), 1, 2);
    [~, ty] = calc_cod(the_ring, dim);
    rmsm = std(ty);
end
while (abs(rmsm - rms_y) > 1e-6)
    rm = 0.5 * (r(1) + r(2));
    the_ring = lnls_set_kickangle(the_ring, kicky0 * rm, vcm, 'y');
%     the_ring = setcellstruct(the_ring, 'KickAngle', vcm, kicky0 * rm, 1, 2);
    [~, ty] = calc_cod(the_ring, dim);
    rmsm = std(ty);
    if (rmsm > rms_y)
        r(1) = rm;
    else
        r(2) = rm;
    end
end

