function [si,all_val,opt] = optimize_optics(si0)

fams  = {'qfa','qda','qf1','qf2','qf3','qf4','qdb1','qfb','qdb2'};
knobs = cell(1,length(fams));

% first, we load the lattice
if ~exist('si0','var')
    si0 = local_si5_lattice();
    si0 = combinebypassmethod(si0,'DriftPass',[],[]);
    mia = findcells(si0,'FamName','mia');
    si0 = si0(1:mia(2));
end

for i=1:length(fams), knobs{i} = findcells(si0,'FamName',fams{i}); end
x0 = knobs_get_values(si0,knobs);

opt.tunes = [49.08,14.12]/5;
opt.mia   = findcells(si0,'FamName','mia');
opt.mib   = findcells(si0,'FamName','mib');
opt.mc    = findcells(si0,'FamName','mc');
opt.betax_max = 20.0;
opt.betay_max = 28.4;
opt.betax_mia = 18.0;
opt.betay_mia =  4.3;
opt.betax_mib =  1.5;
opt.betay_mib =  1.5;
opt.knobs = knobs;
opt.ring  = si0;
opt.get_values = @knobs_get_values;
opt.set_values = @knobs_set_values;



params.calc_residue = @(x)calc_residue(x,opt);
params.update_Jac   = true;
params.nr_iters     = 100;
params.tol          = 1e-5;
params.svs_lst      = [3,6,9];
params.max_frac     = 1;
params.max_x        = 5;
[x, all_val]        = svd_optimizer(x0, params);

% params.calc_residue = @(x)calc_residue(x,opt);
% params.error        = 20;
% params.nr_iters     = 500;
% params.num_not_impr = 50;
% params.error_factor = 0.7;
% params.tol          = 1e-2;
% [x,all_val]         = random_walk_optimizer(x0, params);

si = opt.set_values(opt.ring,opt.knobs,x);



function [res,obj] = calc_residue(x, opt)

si = opt.set_values(opt.ring,opt.knobs,x);

twi = calctwiss(si,1:length(si));

sim_mc  = [twi.alphax(opt.mc); twi.alphay(opt.mc); 1000*twi.etax(opt.mc)]*100;
etax_st = twi.etax([opt.mia,opt.mib]) * 10000;
max_bet = [max(twi.betax)-opt.betax_max;max(twi.betay)-opt.betay_max] * 0.01;
tunes   = ([twi.mux(end),twi.muy(end)]/2/pi - opt.tunes)' * 10000;
funs_st = [twi.betax(opt.mia)-opt.betax_mia;...
           twi.betay(opt.mia)-opt.betay_mia;...
           twi.betax(opt.mib)-opt.betax_mib;...
           twi.betay(opt.mib)-opt.betay_mib];


%Total residue:
res    = [sim_mc; etax_st; max_bet; tunes; funs_st];
if any(imag(res)), obj = inf; else obj = res' * res; end

function values = knobs_get_values(ring, knobs)
values = zeros(length(knobs),1);
for ii=1:length(knobs)
    values(ii) = ring{knobs{ii}(1)}.PolynomB(2);
end

function ring = knobs_set_values(ring,knobs,values)
for ii=1:length(knobs)
    ring = setcellstruct(ring,'PolynomB',knobs{ii},values(ii),1,2);
end