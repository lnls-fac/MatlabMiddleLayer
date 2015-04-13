function optimize_sirius_emittance

clear global FAMLIST;
clc;


opt = getappdata(0, 'opt');
if isempty(opt)
    if exist('OPT.mat','file')
        load('OPT.mat');
    else
        %opt.the_ring     = define_max_iv;
        opt.the_ring     = define_mba5;
    end
end
opt = simplify_lattice(opt);

opt.stepsize_len = 0.01 * 1;
opt.stepsize_fld = 0.01 * 1;
opt.stepsize_grd = 0.01 * 1;
opt.energy       = 3;
opt.nr_cells     = 20;
opt.length_total = 510;
opt.length_id_ss = 6.00; %7.00; %5.35;
opt.max_length   = 500;
opt.max_field    = 0.8;
opt.max_bendg    = 10.0;
opt.max_quadg    = 45.0;
opt.coupling     = 0.1 / 100;

opt = initialization(opt); 
opt = identity_elements(opt);
opt = calc_optics(opt);
opt = close_ring(opt);
opt = calc_chi2(opt);



%optimize_sirius_plot_solution(opt);

iter = 0;
fprintf('%03i: emit:%f nm.rad, len:%f m, sigmas: %f %f um, beta: %f %f m, eta: %f mm\n', iter, opt.naturalEmittance / 1e-9, opt.length_total, opt.sigmax / 1e-6, opt.sigmay / 1e-6, opt.optics.max_betax, opt.optics.max_betay, 1000*opt.optics.etax(end));
while true
    opt0 = opt;
    opt = vary_parameter(opt);
    iter = iter + 1;
    if (opt.chi2 > opt0.chi2)
        opt = opt0;
    else
        fprintf('%03i: emit:%f nm.rad, len:%f m, sigmas: %f %f um, beta: %f %f m, eta: %f mm\n', iter, opt.naturalEmittance / 1e-9, opt.length_total, opt.sigmax / 1e-6, opt.sigmay / 1e-6, opt.optics.max_betax, opt.optics.max_betay, 1000*opt.optics.etax(end));
        setappdata(0, 'opt', opt);
    end
end

function opt = identity_elements(opt0)

opt = opt0;

id = calc_identity(opt.the_ring);
uid = unique(id);
for i=1:length(uid)
    sel = (id == uid(i));
    opt.identical_elements{i} = find(sel);
end

   
    
 function r = calc_identity(the_ring)

r = 1:length(the_ring);
for i=2:length(r)
    %disp(i);
    for j=1:i-1
        if are_the_same(the_ring{i}, the_ring{j})
            r(i) = r(j);
            break;
        end
    end
end

function r = are_the_same(e1, e2)

r = false;


if ~strcmpi(e1.FamName, e2.FamName), return; end;
if (e1.Length ~= e2.Length), return; end;
if ~strcmpi(e1.PassMethod, e2.PassMethod), return; end;

if isfield(e1, 'PolynomB')
    if isfield(e2, 'PolynomB')
        if any(e1.PolynomB ~= e2.PolynomB), return; end;
    else
       return; 
    end
end

if isfield(e1, 'PolynomA')
    if isfield(e2, 'PolynomA')
        if any(e1.PolynomA ~= e2.PolynomA), return; end;
    else
       return; 
    end
end

if isfield(e1, 'MaxOrder')
    if isfield(e2, 'MaxOrder')
        if any(e1.MaxOrder ~= e2.MaxOrder), return; end;
    else
       return; 
    end
end

if isfield(e1, 'NumIntSteps')
    if isfield(e2, 'NumIntSteps')
        if any(e1.NumIntSteps ~= e2.NumIntSteps), return; end;
    else
       return; 
    end
end

if isfield(e1, 'R1')
    if isfield(e2, 'R1')
        if any(e1.R1 ~= e2.R1), return; end;
    else
       return; 
    end
end

if isfield(e1, 'R2')
    if isfield(e2, 'R2')
        if any(e1.R2 ~= e2.R2), return; end;
    else
       return; 
    end
end


if isfield(e1, 'T1')
    if isfield(e2, 'T1')
        if any(e1.T1 ~= e2.T1), return; end;
    else
       return; 
    end
end

if isfield(e1, 'T2')
    if isfield(e2, 'T2')
        if any(e1.T2 ~= e2.T2), return; end;
    else
       return; 
    end
end


if isfield(e1, 'NumX')
    if isfield(e2, 'NumX')
        if any(e1.NumX ~= e2.NumX), return; end;
    else
        return;
    end
end

if isfield(e1, 'NumY')
    if isfield(e2, 'NumY')
        if any(e1.NumY ~= e2.NumY), return; end;
    else
        return;
    end
end

if isfield(e1, 'PxGrid')
    if isfield(e2, 'PxGrid')
        if any(e1.PxGrid ~= e2.PxGrid), return; end;
    else
        return;
    end
end

if isfield(e1, 'PyGrid')
    if isfield(e2, 'PyGrid')
        if any(e1.PyGrid ~= e2.PyGrid), return; end;
    else
        return;
    end
end

if isfield(e1, 'XGrid')
    if isfield(e2, 'XGrid')
        if any(e1.PxGrid ~= e2.PxGrid), return; end;
    else
        return;
    end
end

if isfield(e1, 'YGrid')
    if isfield(e2, 'YGrid')
        if any(e1.PyGrid ~= e2.PyGrid), return; end;
    else
        return;
    end
end


r = true;   
    
function opt = simplify_lattice(opt0)

opt = opt0;
the_ring = {};
i = 1; while (i <= length(opt.the_ring))
    j=i; while (j<=length(opt.the_ring)) && strcmpi(opt.the_ring{j}.PassMethod, 'DriftPass') && strcmpi(opt.the_ring{j}.PassMethod, opt.the_ring{i}.PassMethod), j = j + 1; end; j = j - 1;
    the_ring{end+1} = opt.the_ring{i};
    j = max([j i]);
    len = getcellstruct(opt.the_ring, 'Length', i:j);
    the_ring{end}.Length = sum(len);
    i = j + 1;
end
opt.the_ring = the_ring;
    
function opt = vary_parameter(opt0)

opt  = opt0;
p_len = opt.stepsize_len;
p_fld = opt.stepsize_fld;
p_grd = opt.stepsize_grd;

while true
    
    the_ring = opt.the_ring;
    
    while true
        type = randi(3,1,1);
        switch type
            case 1
                if ~isempty(opt.knobs.len_idx)
                    elem = opt.knobs.len_idx(randi(length(opt.knobs.len_idx),1,1));
                    step = 2*(rand - 0.5) * (p_len) * opt.the_ring{elem}.Length;
                    nval =  opt.the_ring{elem}.Length + step;
                    if ~isempty(opt.knobs.len_max(elem)) && (nval > opt.knobs.len_max(elem)), continue; end;
                    if ~isempty(opt.knobs.len_min(elem)) && (nval < opt.knobs.len_min(elem)), continue; end;
                    opt.the_ring{elem}.Length = nval;
                    break;
                end
            case 2
                if ~isempty(opt.knobs.fld_idx)
                    elem = opt.knobs.fld_idx(randi(length(opt.knobs.fld_idx),1,1));
                    step = 2*(rand - 0.5) * (p_fld) * opt.max_field;
                    oval = opt.b_rho * opt.the_ring{elem}.BendingAngle / opt.the_ring{elem}.Length;
                    nval = oval + step;
                    if ~isempty(opt.knobs.fld_max(elem)) && (nval > opt.knobs.fld_max(elem)), continue; end;
                    if ~isempty(opt.knobs.fld_min(elem)) && (nval < opt.knobs.fld_min(elem)), continue; end;
                    ang = sqrt(nval * opt.the_ring{elem}.Length / opt.b_rho);
                    opt.the_ring{elem}.BendingAngle = ang;
                    opt.the_ring{elem}.EntranceAngle = opt.the_ring{elem}.EntranceAngle * (nval/oval);
                    opt.the_ring{elem}.ExitAngle = opt.the_ring{elem}.ExitAngle * (nval/oval);
                    break;
                end
            case 3
                if ~isempty(opt.knobs.grd_idx)
                    elem = opt.knobs.grd_idx(randi(length(opt.knobs.grd_idx),1,1));
                    step = 2*(rand - 0.5) * (p_grd) * opt.max_quadg;
                    oval = opt.b_rho * opt.the_ring{elem}.K;
                    nval = oval + step;
                    if ~isempty(opt.knobs.grd_max(elem)) && (nval > opt.knobs.grd_max(elem)), continue; end;
                    if ~isempty(opt.knobs.grd_min(elem)) && (nval < opt.knobs.grd_min(elem)), continue; end;
                    K = nval / opt.b_rho;
                    opt.the_ring{elem}.K = K;
                    opt.the_ring{elem}.PolynomB(1,2) = K;
                    break;
                end
        end
    end
    
    % propaga mudanças para elementos idênticos
    if isfield(opt, 'identical_elements')
        for i=1:length(opt.identical_elements)
            elems = opt.identical_elements{i};
            if any(elem == elems)
                for j=1:length(elems)
                    opt.the_ring{elems(j)} = opt.the_ring{elem};
                end
                break;
            end
        end
    end
    
    opt = close_ring(opt);
    opt = calc_optics(opt);
    if isfield(opt.optics, 'betax') && (opt.naturalEmittance >= 0) && all(opt.radiationDamping >= 0)
        opt = calc_chi2(opt);
        break;
    else
        opt.the_ring = the_ring;
    end
    
end

function opt = calc_chi2(opt0)

opt = opt0;

%opt.chi2 = opt.naturalEmittance;
%opt.chi2 = sqrt((5 * (opt.naturalEmittance / (0.5e-9))^2 + 1 * (opt.optics.max_betax / 35)^2 + 1 * (opt.optics.max_betay / 35)^2)/7);

% opt.chi2 = sqrt(( ...
%       5 * (opt.naturalEmittance / (0.5e-9))^2 ...
%     + 1 * (opt.optics.max_betax / 35)^2 ...
%     + 1 * (opt.optics.max_betay / 35)^2 ...
%     + 5 * (opt.length_total / 400)^2 ...
%     )/12);


params = {
    5, (opt.naturalEmittance / (0.5e-9))^2; ...
    1, (opt.optics.max_betax / 35)^2; ...
    1, (opt.optics.max_betay / 35)^2; ...
    5, (opt.length_total / 400)^2; ...
    2, (opt.optics.etax(end) / 0.001)^2; ...
    };

opt.chi2 = 0;
for i=1:size(params,1)
    opt.chi2 = opt.chi2 + params{i,1} * sum(params{i,2});
end
opt.chi2 = sqrt(opt.chi2 / sum([params{:,1}]));


function opt = close_ring(opt0)

opt = opt0;

bends = findcells(opt.the_ring, 'BendingAngle');
quads = findcells(opt.the_ring, 'K');
quads = setdiff(quads,bends);


% comprimento
mag = 2:(length(opt.the_ring)-2);
len = getcellstruct(opt.the_ring, 'Length', 1:length(opt.the_ring));
avl = (opt.max_length / opt.nr_cells) - opt.length_id_ss;
if (sum(len(mag)) > avl)
    len(mag) = len(mag) * (avl / sum(len(mag)));
    opt.the_ring = setcellstruct(opt.the_ring, 'Length', 1:length(opt.the_ring), len);
end

% campo
ang = getcellstruct(opt.the_ring, 'BendingAngle', bends);
leg = len(bends);
rho = leg ./ ang;
fld = opt.b_rho ./ rho;
sel = find(abs(fld) > opt.max_field);
fld(sel) = fld(sel) .* (opt.max_field ./ fld(sel));
rho = opt.b_rho ./ fld;
new_ang = leg ./ rho;
new_ang = new_ang * (2*pi/sum(new_ang)/opt.nr_cells);

opt.length_total = opt.nr_cells * sum(len);
opt.the_ring = setcellstruct(opt.the_ring, 'BendingAngle', bends, new_ang);
a = getcellstruct(opt.the_ring, 'EntranceAngle', bends);
opt.the_ring = setcellstruct(opt.the_ring, 'EntranceAngle', bends, a .* (new_ang./ang));
a = getcellstruct(opt.the_ring, 'ExitAngle', bends);
opt.the_ring = setcellstruct(opt.the_ring, 'ExitAngle', bends, a .* (new_ang./ang));

function opt = initialization(opt0)

opt = opt0;
[opt.beta opt.gamma opt.b_rho] = lnls_beta_gamma(opt.energy);
opt.length_magnets = (opt.length_total / opt.nr_cells - opt.length_id_ss)/2;
opt = trim_driftspaces(opt);

if ~isfield(opt, 'knobs')
    for i=1:length(opt.the_ring)
        opt.knobs.type{i} = 'drift';
        opt.knobs.len_flag(i) = true;
        opt.knobs.len_max(i)  = NaN;
        opt.knobs.len_min(i)  = NaN;
        if isfield(opt.the_ring{i}, 'K')
            opt.knobs.type{i} = 'quad';
            opt.knobs.grd_flag(i) = true;
            opt.knobs.grd_max(i)  =  opt.max_quadg;
            opt.knobs.grd_min(i)  = -opt.max_quadg;
        end
        if isfield(opt.the_ring{i}, 'BendingAngle')
            opt.knobs.type{i} = 'bend';
            opt.knobs.fld_flag(i) = true;
            opt.knobs.fld_max(i)  =  opt.max_field;
            opt.knobs.fld_min(i)  =  0;
            opt.knobs.grd_flag(i) = true;
            opt.knobs.grd_max(i)  =  opt.max_bendg;
            opt.knobs.grd_min(i)  = -opt.max_bendg;
        end
    end
    opt.knobs.len_flag(1)     = false;
    opt.knobs.len_flag(end-1) = false;
    opt.knobs.len_flag(end)   = false;
end


opt.knobs.len_idx = find(opt.knobs.len_flag);
opt.knobs.fld_idx = find(opt.knobs.fld_flag);
opt.knobs.grd_idx = find(opt.knobs.grd_flag);



function opt = trim_driftspaces(opt0)

opt = opt0;
i1=1; while any(strcmpi(opt.the_ring{i1}.PassMethod, {'DriftPass', 'IdentityPass'})), i1=i1+1; end;
i2=length(opt.the_ring); while any(strcmpi(opt.the_ring{i2}.PassMethod, {'DriftPass', 'IdentityPass'})), i2=i2-1; end;
ds = [drift('IDDS', opt.length_id_ss/2, 'DriftPass') marker('END', 'IdentityPass')];
dspace = buildlat(ds);
opt.the_ring = [dspace(1), opt.the_ring(i1:i2), dspace(1), dspace(2)];
opt.the_ring = setcellstruct(opt.the_ring, 'Energy', 1:length(opt.the_ring), 1e9*opt.energy);

function opt = calc_optics(opt0)

opt = opt0;

if isfield(opt, 'optics'), opt = rmfield(opt, 'optics'); end;
[M44, MS] = findm44(opt.the_ring, 0, 1:length(opt.the_ring)+1,[0 0 0 0 0 0]');

opt.optics.M44 = M44;
opt.optics.tracex = M44(1,1) + M44(2,2);
opt.optics.tracey = M44(3,3) + M44(4,4);

if (opt.optics.tracex >= 2) || (opt.optics.tracey >= 2) || ...
        (opt.optics.tracex <= -2) || (opt.optics.tracey <= -2)
    return;
end

opt = calc_atsummary(opt);

function opt = calc_atsummary(opt0)

opt = opt0;

const = lnls_constants;
the_ring = opt.the_ring;

% Structure to store info
r.e0 = opt.energy;
r.circumference = opt.nr_cells * findspos(the_ring, length(the_ring)+1);
r.revTime = r.circumference / const.c;
r.revFreq = const.c / r.circumference;
r.gamma = opt.gamma;
r.beta = sqrt(1 - 1/r.gamma);
[TD, r.tunes, r.chromaticity] = twissring(the_ring, 0, 1:length(the_ring)+1, 'chrom', 1e-8);
r.twiss.beta        = cat(1,TD.beta);
r.twiss.mu          = cat(1,TD.mu);
r.twiss.alpha       = cat(1,TD.alpha);
r.twiss.ClosedOrbit = [TD.ClosedOrbit]';
r.twiss.Dispersion  = [TD.Dispersion]';
r.twiss.SPos        = cat(1,TD.SPos);

% For calculating the synchrotron integrals
temp  = cat(2,TD.Dispersion);
D_x   = temp(1,:)';
D_x_  = temp(2,:)';
beta  = cat(1, TD.beta);
alpha = cat(1, TD.alpha);
gamma = (1 + alpha.^2) ./ beta;
circ  = TD(length(the_ring)+1).SPos;

opt.optics.betax = beta(:,1);
opt.optics.betay = beta(:,2);
opt.optics.mux = r.twiss.mu(:,1);
opt.optics.muy = r.twiss.mu(:,2);

opt.optics.max_betax = max(opt.optics.betax);
opt.optics.max_betay = max(opt.optics.betay);
opt.optics.etax   = D_x;



% Synchrotron integral calculation
r.integrals = [0.0 0.0 0.0 0.0 0.0 0.0];

for i = 1:length(the_ring),
    if isfield(the_ring{i}, 'BendingAngle') && isfield(the_ring{i}, 'EntranceAngle')
        rho = the_ring{i}.Length/the_ring{i}.BendingAngle;
        dispersion = 0.5*(D_x(i)+D_x(i+1));
        r.integrals(1) = r.integrals(1) + dispersion*the_ring{i}.Length/rho;
        r.integrals(2) = r.integrals(2) + the_ring{i}.Length/(rho^2);
        r.integrals(3) = r.integrals(3) + the_ring{i}.Length/(rho^3);
        % For general wedge magnets
        r.integrals(4) = r.integrals(4) + ...
            D_x(i)*tan(the_ring{i}.EntranceAngle)/rho^2 + ...
            (1 + 2*rho^2*the_ring{i}.PolynomB(2))*(D_x(i)+D_x(i+1))*the_ring{i}.Length/(2*rho^3) + ...
            D_x(i+1)*tan(the_ring{i}.ExitAngle)/rho^2;
        %         r.integrals(4) = r.integrals(4) + 2*0.5*(D_x(i)+D_x(i+1))*the_ring{i}.Length/rho^3;
        H1 = beta(i,1)*D_x_(i)*D_x_(i)+2*alpha(i)*D_x(i)*D_x_(i)+gamma(i)*D_x(i)*D_x(i);
        H0 = beta(i+1,1)*D_x_(i+1)*D_x_(i+1)+2*alpha(i+1)*D_x(i+1)*D_x_(i+1)+gamma(i+1)*D_x(i+1)*D_x(i+1);
        r.integrals(5) = r.integrals(5) + the_ring{i}.Length*(H1+H0)*0.5/abs(rho^3);
        %         if H1+H0 < 0
        %             fprintf('%f %i %s\n', H1+H0, i, the_ring{i}.FamName)
        %         end
        r.integrals(6) = r.integrals(6) + the_ring{i}.PolynomB(2)^2*dispersion^2*the_ring{i}.Length;
    end
end

r.integrals(1) = opt.nr_cells * r.integrals(1);
r.integrals(2) = opt.nr_cells * r.integrals(2);
r.integrals(3) = opt.nr_cells * r.integrals(3);
r.integrals(4) = opt.nr_cells * r.integrals(4);
r.integrals(5) = opt.nr_cells * r.integrals(5);
r.integrals(6) = opt.nr_cells * r.integrals(6);

% Damping numbers
% Use Robinson's Theorem
r.damping(1) = 1 - r.integrals(4)/r.integrals(2);
r.damping(2) = 1;
r.damping(3) = 2 + r.integrals(4)/r.integrals(2);

r.radiation = 8.846e-5*r.e0.^4*r.integrals(2)/(2*pi);
r.naturalEnergySpread = sqrt(3.8319e-13*r.gamma.^2*r.integrals(3)/(2*r.integrals(2) + r.integrals(4)));
r.naturalEmittance = 3.8319e-13*(r.e0*1e3/const.E0).^2*r.integrals(5)/(r.damping(1)*r.integrals(2));

% Damping times
r.radiationDamping(1) = 1/(2113.1*r.e0.^3*r.integrals(2)*r.damping(1)/circ);
r.radiationDamping(2) = 1/(2113.1*r.e0.^3*r.integrals(2)*r.damping(2)/circ);
r.radiationDamping(3) = 1/(2113.1*r.e0.^3*r.integrals(2)*r.damping(3)/circ);

% Slip factor
%r.etac = r.gamma^(-2) - r.compactionFactor;

opt.naturalEmittance = r.naturalEmittance;
opt.naturalEnergySpread = r.naturalEnergySpread;
opt.radiationDamping(1) = r.radiationDamping(1);
opt.radiationDamping(2) = r.radiationDamping(2);
opt.radiationDamping(3) = r.radiationDamping(3);

opt.sigmax = sqrt(opt.naturalEmittance * opt.optics.betax(1) + (opt.naturalEnergySpread * opt.optics.etax(1))^2);
opt.sigmay = sqrt(opt.coupling * opt.naturalEmittance * opt.optics.betay(1));
