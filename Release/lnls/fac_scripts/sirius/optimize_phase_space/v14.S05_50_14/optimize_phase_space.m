function [si,all_val,opt] = optimize_phase_space(si0)

fams  = {'sfa','sda','sd1j','sf1j','sd2j','sd3j','sf2j',...
         'sdb','sfb','sf2k','sd3k','sd2k','sf1k','sd1k'};
knobs = cell(1,length(fams));

% first, we load the lattice
if ~exist('si0','var')
    si0 = local_si5_lattice();
    si0 = combinebypassmethod(si0,'DriftPass',[],[]);
    mia = findcells(si0,'FamName','mia');
    si0 = si0(1:mia(2));
    for i=1:length(fams), knobs{i} = findcells(si0,'FamName',fams{i}); end
    x0 = zeros(1,length(knobs));
else
    for i=1:length(fams), knobs{i} = findcells(si0,'FamName',fams{i}); end
    x0 = knobs_get_values(si0,knobs);
end

x0 = knobs_get_values(si0,knobs);

opt.chromx     =  2.5/5;
opt.chromy     = -2.5/5;
opt.knobs      = knobs;
opt.ring       = si0;
opt.get_values = @knobs_get_values;
opt.set_values = @knobs_set_values;

params.calc_residue = @(x)calc_residue(x,opt);
params.update_Jac   = false;
params.nr_iters     = 100;
params.tol          = 1e-5;
params.svs_lst      = [5,8,11,14];
params.max_frac     = 1;
params.max_x        = 250;
params.plot         = true;
[x, all_val]        = svd_optimizer(x0, params);

% params.calc_residue = @(x)calc_residue(x,opt);
% params.error        = 5;
% params.nr_iters     = 400;
% params.num_not_impr = 50;
% params.error_factor = 0.7;
% params.tol          = 1e-2;
% params.plot         = true;
% [x, all_val]        = random_walk_optimizer(x0, params);


% param.gen = 100; %number of generations
% param.pop = 500; % number of individuals in each generation
% param.nObjectives = 19; % number of objective functions to minimize
% param.nDeciVar  = 14; % number of decision variables
% param.mutation_scale = 1;
% param.minValueDeciVar = -250*[0,1,1,0,1,1,0,1,0,0,1,1,0,1];
% param.maxValueDeciVar =  250*[1,0,0,1,0,0,1,0,1,1,0,0,1,0];
% param.objective_function = @(x)calc_residue(x,opt); 
% param.folder = 'solution'; % folder to save the results
% % Uncomment these lines to start from an specified initial population;
% % param.initialPop = load('solution/initialgeneration.txt');
% % param.initialPop = param.initialPop(:,1:param.nDeciVar);
% nsga_2(param)

% % I tried to use matlab's functions, without success.
% problem.objective = @(x)calc_residue(x,opt);
% problem.x0        = zeros(14,1);
% problem.goal      = zeros(16,1);
% problem.weight    = ones(16,1);
% problem.lb        = 250*zeros(14,1);
% problem.ub        = -250*zeros(14,1);
% problem.solver    = 'fgoalattain';
% problem.options   = optimset(optimset('fgoalattain'),...    'Algorithm','interior-point',...
%     'Display','iter-detailed',...
%     'TolCon',1,...
%     'TypicalX',2000000*ones(14,1));
% x = fgoalattain(problem);

si = opt.set_values(opt.ring,opt.knobs,x);



function [res,obj,names] = calc_residue(x, opt)

ring = opt.set_values(opt.ring,opt.knobs,x);

%Tune-shifts with amplitude and energy:
amps.x = -(1:2:50)*1e-4;
amps.y = (1:2:25)*1e-4;
amps.e = (-30:4:30)*1e-3;
npols.x = 2; npols.y = 2; npols.e = 3;
[tunex,~,px,py,~] = lnls_calc_tune_shifts(ring,false, amps, npols);

lostx = sum(isnan(tunex.x))*1;
losty = sum(isnan(tunex.y))*1;
loste = sum(isnan(tunex.e))*1;

vec3 = [lostx,losty,loste]';
names3 = {'lstx','lsty','lste'};

de =  4e-2;
Jx = 5e-6;

ne = npols.e;
crx = zeros(1,ne); cry = zeros(1,ne);
crx(2:ne) = px.e(-(2:ne)+end) .* (de.^(2:ne))*100;
cry(2:ne) = py.e(-(2:ne)+end) .* (de.^(2:ne))*100;
crx(1) = (px.e(end-1) - opt.chromx) * de * 1000;
cry(1) = (py.e(end-1) - opt.chromy) * de * 1000;

n = npols.x;
dnuxdJx = px.x(-(1:n)+end) .* (Jx.^(1:n)) * 100;
dnuxdJy = px.y(-(1:n)+end) .* (Jx.^(1:n)) * 100;
dnuydJx = py.x(-(1:n)+end) .* (Jx.^(1:n)) * 100;
dnuydJy = py.y(-(1:n)+end) .* (Jx.^(1:n)) * 100;

vec2     = [crx, cry, dnuxdJx, dnuxdJy, dnuydJx, dnuydJy]';
names2   = {'crx1','crx2','crx3','cry1','cry2','cry3',...
            'nxx1','nxx2','nxy1','nxy2',...
            'nyx1','nyx2','nyy1','nyy2'};
%sextupole strengths
% vals = knobs_get_values(si,opt.knobs);
% vec3 = vals'*vals/ 250^2;

% First order sextupolar and quadrupolar driving terms:
ring = lnls_refine_lattice(ring,0.03,{'BndMPoleSymplectic4Pass','StrMPoleSymplectic4Pass'});
ring = set_num_integ_steps(ring);
twiss = calctwiss(ring,1:length(ring));
DT = lnls_calc_drive_terms(ring,twiss);

names1   = {'h21000','h30000','h10110','h10200','h10020','h20001','h00201','h10002'};
fac_vec1 = [     0.1,     0.1,     0.1,     0.1,     0.1,       1,       1,       1]';
vec1 = zeros(length(names1),1);
for ii=1:length(names1), vec1(ii) = fac_vec1(ii) * real(DT.(names1{ii})); end

%Total residue:
res    = [vec1; vec2; vec3]; %randon walk
names  = [names1,names2,names3];
% res    = [vec1; vec2];       % svd
obj = res' * res;



function values = knobs_get_values(ring, knobs)
values = zeros(length(knobs),1);
for ii=1:length(knobs)
    values(ii) = ring{knobs{ii}(1)}.PolynomB(3);
end

function ring = knobs_set_values(ring,knobs,values)
for ii=1:length(knobs)
    ring = setcellstruct(ring,'PolynomB',knobs{ii},values(ii),1,3);
end