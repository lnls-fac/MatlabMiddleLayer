function [si,all_val] = optimize_phase_space(si0)

% first, we load the lattice
if ~exist('si0','var')
    si0 = local_si5_lattice();
    opt = set_options(si0);
    x0 = zeros(1,length(opt.knobs));
else
    opt = set_options(si0);
    x0 = knobs_get_values(si0,opt.knobs);
end

x0 = knobs_get_values(si0,opt.knobs);

% params.calc_residue = @(x)calc_residue(x,opt);
% params.update_Jac   = false;
% params.nr_iters     = 50;
% params.tol          = 1e-5;
% params.svs_lst      = [5,8,11,16,20,28];
% params.max_frac     = 1;
% params.max_x        = 240;
% params.plot         = true;
% [x, all_val]        = svd_optimizer(x0, params);
% si = opt.set_values(opt.ring,opt.knobs,x);

% params.calc_residue = @(x)calc_residue(x,opt);
% params.error        = 2;
% params.nr_iters     = 200;
% params.num_not_impr = 50;
% params.error_factor = 0.7;
% params.tol          = 1e-2;
% params.plot         = true;
% [x, all_val]        = random_walk_optimizer(x0, params);
% si = opt.set_values(opt.ring,opt.knobs,x);

x0 = x0.';
param.gen = 50; %number of generations
param.pop = 1000; % number of individuals in each generation
param.nObjectives = 3; % number of objective functions to minimize
param.nDeciVar  = length(x0); % number of decision variables
param.mutation_scale = 1;
param.minValueDeciVar = -240*(x0<0);
param.maxValueDeciVar =  240*(x0>0);
param.objective_function = @(x)calc_residue2(x,opt); 
param.folder = 'solution3'; % folder to save the results
% param.initialPop = repmat(x0,param.pop,1) + [zeros(1,length(x0)); 20*(0.5-rand(param.pop-1,length(x0)))];
a = load('solution/initialgeneration.txt');
param.initialPop = a(:,1:(param.nDeciVar));
param.continue = false;
nsga_2(param)

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
