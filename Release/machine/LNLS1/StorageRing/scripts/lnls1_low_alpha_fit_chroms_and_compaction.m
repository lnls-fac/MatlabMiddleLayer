function lnls1_low_alpha_fit_chroms_and_compaction

global THERING

goal_chromx = -3.2;
goal_chromy = +4.2;
goal_alpha2 = 2.47e-2;

%load('THERING_best.mat');
r = calc_merit_function(goal_chromx, goal_chromy, goal_alpha2);
fprintf('%f\n', r);
iter = 0;
while (true)
    if (mod(iter,100) == 0) 
        disp(getpv('A6SF', 'Physics'));
        disp(getpv('A6SD01', 'Physics'));
        disp(getpv('A6SD02', 'Physics'));
    end    
    iter = iter + 1;
    old_THERING = THERING;
    vary_sextupoles();
    r_new = calc_merit_function(goal_chromx, goal_chromy, goal_alpha2);
    if (r_new < r)
        r = r_new;
        fprintf('%06i: %f\n', iter, r);
        save(['THERING_', num2str(iter, '%06i'), '.mat'], 'THERING');
        save(['THERING_best.mat'], 'THERING');
    else
        THERING = old_THERING;
    end
end



function r = calc_merit_function(chromx, chromy, alpha2)

global THERING

alpha = mcf(THERING, 3);
[~, ~, chrom] = twissring(THERING, 0, 1:length(THERING)+1, 'chrom', 1e-8);
r = 0;
r1 = (alpha(2) - alpha2)/alpha2;
r2 = (chrom(1) - chromx)/chromx;
r3 = (chrom(2) - chromy)/chromy;

r = r + r1^2;
r = r + r2^2;
r = r + r3^2;
r = sqrt(r/3);


function vary_sextupoles()

step = 0.3; % [1/m^3]

% a6sf   = unique(getpv('A6SF', 'Physics'));
% a6sd01 = unique(getpv('A6SD01', 'Physics'));
% a6sd02 = unique(getpv('A6SD02', 'Physics'));
% 
% a6sf   = a6sf   + step * 2 * (rand()   - 0.5);
% a6sd01 = a6sd01 + step * 2 * (rand() - 0.5);
% a6sd02 = a6sd02 + step * 2 * (rand() - 0.5);

a6sf   = getpv('A6SF', 'Physics');
a6sd01 = getpv('A6SD01', 'Physics');
a6sd02 = getpv('A6SD02', 'Physics');

a6sf   = a6sf   + step * 2 * (rand(size(a6sf))   - 0.5);
a6sd01 = a6sd01 + step * 2 * (rand(size(a6sd01)) - 0.5);
a6sd02 = a6sd02 + step * 2 * (rand(size(a6sd02)) - 0.5);

setpv('A6SF',   a6sf,   'Physics');
setpv('A6SD01', a6sd01, 'Physics');
setpv('A6SD02', a6sd02, 'Physics');