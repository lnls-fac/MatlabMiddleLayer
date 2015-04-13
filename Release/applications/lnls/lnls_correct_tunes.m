function [the_ring0, converged, tunesf, tunesi] = lnls_correct_tunes(the_ring, families, goal_tunes, max_iter, tolerancia)
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
%   the_ring0  : ring model with minimum distance from the desired solution
%   converged  : true if the euclidian distance between tunes0 and
%                 goal_tunes is lower than tolerancia;
%   tunesf     : tunes of the model the_ring0;
%   tunesi     : initial tunes, before adjust.


% cria lista de indices a elementos do modelo AT
knobs = cell(1,length(families));
for ii=1:length(families)
    knobs{ii}  = findcells(the_ring, 'FamName', families{ii});
end

[~, tunes] = twissring(the_ring,0,1:length(the_ring)+1);
res = sqrt((tunes-goal_tunes)*(tunes-goal_tunes)');

the_ring0 = the_ring;
tunesf = tunes;
tunesi = tunes;

calc_matrix = true;

ii = 0;
while ii < max_iter && res > tolerancia
    
    if calc_matrix
        % calcula matriz de variacao do residuo
        dK = 1e-3;
        mm = zeros(2,length(knobs));
        for i=1:length(knobs)
            calc_ring = the_ring;
            K = getcellstruct(calc_ring, 'PolynomB', knobs{i},1,2);
            calc_ring = setcellstruct(calc_ring, 'PolynomB', knobs{i}, K + dK/2, 1, 2);
            [~, tunes_up] = twissring(calc_ring,0,1:length(calc_ring)+1);
            calc_ring = setcellstruct(calc_ring, 'PolynomB', knobs{i}, K - dK/2, 1, 2);
            [~, tunes_down] = twissring(calc_ring,0,1:length(calc_ring)+1);
            mm(:,i) = -(tunes_up - tunes_down)/dK;
        end
        %sv = diag(S);
        %sel = (sv ./ sv(1)) <= 0.01;
        % inv_S = inv(S);
        %inv_S(sel) = 0;

        % calcula pseudo inversa da matriz de variacao do res�duo
        [U,S,V] = svd(mm,'econ');
        pseudoinv_mm = V*(S\U');
    end
    
    % calcula solucao
    deltaK = pseudoinv_mm * (tunes-goal_tunes)';
    
    % ajusta modelo AT com nova sintonia
    for i=1:length(knobs)
        K = getcellstruct(the_ring, 'PolynomB', knobs{i},1,2);
        the_ring = setcellstruct(the_ring, 'PolynomB',knobs{i}, K + deltaK(i), 1, 2);
    end
    
    [~, tunes] = twissring(the_ring,0,1:length(the_ring)+1);
    
    new_res = sqrt((tunes-goal_tunes)*(tunes-goal_tunes)');
    if new_res < res
        the_ring0 = the_ring;
        res = new_res;
        tunesf = tunes;
        calc_matrix = false;
    else
        calc_matrix = true;
    end
    ii = ii + 1;
end

converged = true;
if (ii==max_iter && res > tolerancia) || isnan(res)
    converged = false;
end


