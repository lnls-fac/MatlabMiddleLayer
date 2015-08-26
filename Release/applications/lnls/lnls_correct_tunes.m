function [the_ring, converged, tunesf, tunesi] = lnls_correct_tunes(the_ring, families, goal_tunes, max_iter, tolerancia)
% [the_ring0, converged, tunes] = lnls_correct_tune(the_ring, families, goal_tune, max_iter, tolerancia)
% 
% Correct tunes with specified quadrupole families.
% Inputs:
%   the_ring   : model of the ring;
%   families   : cell of strings with the family names of the quadrupoles
%                 to be used;
%   goal_tunes : goal tunes, including the integer;
%   max_iter   : maximum # of trials for the correction algorithm;
%   tolerancia : acceptable euclidian distance between tunes0 and goal_tunes
%                 for the definition of convergence of the algoritm;
%
% Outputs:
%   the_ring  : ring model with minimum distance from the desired solution
%   converged  : true if the euclidian distance between tunes0 and
%                 goal_tunes is lower than tolerancia;
%   tunesf     : tunes of the model the_ring0;
%   tunesi     : initial tunes, before adjust.


% cria lista de indices a elementos do modelo AT
knobs = cell(1,length(families));
for ii=1:length(families)
    knobs{ii}  = findcells(the_ring, 'FamName', families{ii});
end

calc_rms = @(x)norm(x)/sqrt(length(x));

[~, tunes] = twissring(the_ring,0,1:length(the_ring)+1);
tunesf = tunes;
tunesi = tunes;
converged = false;
[pseudoinv_mm, abort] = calc_tune_matrix(the_ring, knobs);
if abort, return; end
factor = 1;
res_vec = (tunes-goal_tunes)';
res = calc_rms(res_vec);
ii = 0;
while (res > tolerancia) && (ii <max_iter) && (factor > 0.001)
    dK = - factor * pseudoinv_mm * res_vec;
    
    new_the_ring = the_ring;
    for i=1:length(knobs)
        K = getcellstruct(new_the_ring, 'PolynomB', knobs{i},1,2);
        new_the_ring = setcellstruct(new_the_ring, 'PolynomB',knobs{i}, K + dK(i), 1, 2);
    end
    
    [~, tunes] = twissring(new_the_ring,0,1:length(new_the_ring)+1);
    new_res_vec = (tunes-goal_tunes)';
    new_res = calc_rms(new_res_vec);
    
    if (new_res < res)
        [pseudoinv_mm, abort] = calc_tune_matrix(new_the_ring, knobs);
        if abort, break; end
        res_vec = new_res_vec;
        res = new_res;
        the_ring = new_the_ring;
        tunesf = tunes;
        factor = min([factor * 2, 1]);
    else
        factor = factor / 2;
%         [pseudoinv_mm, abort] = calc_tune_matrix(the_ring, knobs);
%         if abort, break; end
    end
    ii = ii + 1;
end

converged = res < tolerancia;


function [pseudoinv_mm, abort] = calc_tune_matrix(the_ring,knobs)

% calcula matriz de variacao do residuo
dK = 1e-4;
mm = zeros(2,length(knobs));
pseudoinv_mm = zeros(length(knobs),2);
for i=1:length(knobs)
    calc_ring = the_ring;
    K = getcellstruct(calc_ring, 'PolynomB', knobs{i},1,2);
    calc_ring = setcellstruct(calc_ring, 'PolynomB', knobs{i}, K + dK/2, 1, 2);
    [~, tunes_up] = twissring(calc_ring,0,1:length(calc_ring)+1);
    calc_ring = setcellstruct(calc_ring, 'PolynomB', knobs{i}, K - dK/2, 1, 2);
    [~, tunes_down] = twissring(calc_ring,0,1:length(calc_ring)+1);
    mm(:,i) = (tunes_up - tunes_down)/dK;
end

abort = any(isnan(mm(:)));
if abort, return; end
%sv = diag(S);
%sel = (sv ./ sv(1)) <= 0.01;
%inv_S = inv(S);
%inv_S(sel) = 0;

% calcula pseudo inversa da matriz de variacao do res�duo
[U,S,V] = svd(mm,'econ');
pseudoinv_mm = V*(S\U');
