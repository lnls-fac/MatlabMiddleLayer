function [res,obj,names] = calc_residue(x, opt)

ring = opt.set_values(opt.ring,opt.knobs,x);

%Tune-shifts with amplitude and energy:
amps.x=-(1:3:100)*1e-4;    amps.y=(1:2:30)*1e-4;
npols.x = 2;               npols.y = 2;
[tunex,tuney,px,py,~] = lnls_calc_tune_shifts(ring,false, amps, npols);

amps.e  =(-50:5:50)*1e-3;
npols.e = 6;
[par,fit] = lnls_calc_energy_dependent_optics(ring,amps.e,npols.e,false);
tunex.e = par.tunex'; tuney.e = par.tuney';
px.e = fit.tunex; py.e = fit.tuney;

% Particle loss or tune outside the permited window
tunex_int = [0.2,0.3];
tuney_int = [0.1,0.2];
lost.x = [];lost.y = []; lost.e = [];
pls = fieldnames(lost);
for i=1:length(pls)
    pl = pls{i};
    loss = isnan(tunex.(pl));
%     if strcmp(pl,'e')
    loss = loss | ...
        (tunex.(pl) < tunex_int(1) | tunex.(pl) > tunex_int(2)) | ...
        (tuney.(pl) < tuney_int(1) | tuney.(pl) > tuney_int(2));
%     end
    lost.(pl) = sum(loss)*5;
end
vec4 = [lost.x,lost.y,lost.e]';
names4 = {'lstx','lsty','lste'};

% Tune shifts with amplitude
Jx = 5e-6;
n = npols.x;
dnuxdJx = px.x(-(1:n)+end) .* (Jx.^(1:n)) * 200;
dnuxdJy = px.y(-(1:n)+end) .* (Jx.^(1:n)) * 200;
dnuydJx = py.x(-(1:n)+end) .* (Jx.^(1:n)) * 200;
dnuydJy = py.y(-(1:n)+end) .* (Jx.^(1:n)) * 200;
vec2     = [dnuxdJx, dnuxdJy, dnuydJx, dnuydJy]';
names2   = cell(1,4*n);
for ii=1:n,
    names2{n*0+ii} = sprintf('nxx%1d',ii);
    names2{n*1+ii} = sprintf('nxy%1d',ii);
    names2{n*2+ii} = sprintf('nyx%1d',ii);
    names2{n*3+ii} = sprintf('nyy%1d',ii);
end

%optic functions variation with energy:
de =  5.0e-2;
ne = npols.e;
crx = zeros(1,ne); cry = zeros(1,ne);
crx(2:ne) = px.e(-(2:ne)+end) .* (de.^(2:ne))*200;
cry(2:ne) = py.e(-(2:ne)+end) .* (de.^(2:ne))*200;
crx(1) = (px.e(end-1) - opt.chromx) * de * 1000;
cry(1) = (py.e(end-1) - opt.chromy) * de * 1000;
btx(1:ne) = fit.betax(-(1:ne)+end) .* (de.^(1:ne))*0.5;
%bty(1:ne) = fit.betay(-(1:ne)+end) .* (de.^(1:ne))*0.2;
%cox(1:ne) = fit.cox(-(1:ne)+end) .* (de.^(1:ne))*1000;
vec3 = [crx,cry,btx]';

% vec3     = [crx,cry]';
names3   = cell(1,3*ne);
for ii=1:ne,
    names3{ne*0+ii} = sprintf('crx%1d',ii);
    names3{ne*1+ii} = sprintf('cry%1d',ii);
    names3{ne*2+ii} = sprintf('btx%1d',ii);
%    names3{ne*3+ii} = sprintf('bty%1d',ii);
%    names3{ne*4+ii} = sprintf('cox%1d',ii);
end
% vec3(end+1) = max(par.betax)*0.1;
% names3{end+1} = 'betx';

% First order sextupolar and quadrupolar driving terms:
ring = lnls_refine_lattice(ring,0.03,{'BndMPoleSymplectic4Pass','StrMPoleSymplectic4Pass'});
ring = set_num_integ_steps(ring);
twiss = calctwiss(ring);
DT = lnls_calc_drive_terms(ring,twiss);

names1   = {'h21000','h30000','h10110','h10200','h10020','h20001','h00201','h10002'};
fac_vec1 = [ 10*[0.1,     0.1,     0.1,     0.1,    0.1],       1,       1,       1]';
vec1 = zeros(length(names1),1);
for ii=1:length(names1), vec1(ii) = fac_vec1(ii) * abs(DT.(names1{ii})); end

%Total residue:
res    = [vec1; vec2; vec3; vec4]; %randon walk
names  = [names1,names2,names3,names4];
% res    = [vec1; vec2];       % svd
obj = res' * res;