function [the_ring, converged, tunesf, tunesi] = lnls_correct_tunes(the_ring, goal_tunes, families, method, max_iter, tolerancia)
% [the_ring0, converged, tunes] = lnls_correct_tune(the_ring, goal_tunes, families, method, max_iter, tolerancia)
%
% Correct tunes with specified quadrupole families.
% Inputs:
%   the_ring   : model of the ring;
%   families   : cell of strings with the family names of the quadrupoles
%                to be used;
%   goal_tunes : goal tunes, including the integer;
%   method     : if 'svd' uses svd considering each family as a knob, else
%                groups focusing and defocusing (by family name) in two
%                knobs and apply variations proportional to the strength of
%                each magnet.
%   max_iter   : maximum # of trials for the correction algorithm;
%   tolerancia : acceptable euclidian distance between tunes0 and goal_tunes
%                 for the definition of convergence of the algorithm;
%
% Outputs:
%   the_ring  : ring model with minimum distance from the desired solution
%   converged  : true if the euclidian distance between tunes0 and
%                 goal_tunes is lower than tolerancia;
%   tunesf     : tunes of the model the_ring0;
%   tunesi     : initial tunes, before adjust.

if ~exist('method', 'var') || isempty(method)
    method = 'svd';
end

if ~exist('families', 'var') || isempty(families)
    families = {'qda', 'qfa', 'qdb1', 'qdb2', 'qfb', 'qdp1', 'qdp2', 'qfp'};
end

if ~exist('max_iter', 'var')
    max_iter = 10;
end

if ~exist('tolerancia', 'var')
    tolerancia = 1e-6;
end

if strcmpi(method,'svd');
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
    [pseudoinv_mm, abort] = calc_tune_matrix_svd(the_ring, knobs);
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
            [pseudoinv_mm, abort] = calc_tune_matrix_svd(new_the_ring, knobs);
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
else
    % cria lista de indices de elementos do modelo AT
    kn = [];
    kp = [];
    for ii=1:length(families)
        if strncmpi(families{ii},'qd',2)
            kn  = [kn, findcells(the_ring, 'FamName', families{ii})];
        elseif strncmpi(families{ii},'qf',2)
            kp  = [kp, findcells(the_ring, 'FamName', families{ii})];
        else
            fprintf('There is no way to know if family %s is focusing or defocusing\n',families{ii});
            return;
        end
    end
    if isempty(kp), fprintf('No focusing families found\n');
    elseif isempty(kn), fprintf('No defocusing families found\n');end
    
    kn = sort(kn); kp = sort(kp);
    
    calc_rms = @(x)norm(x)/sqrt(length(x));
    
    [~, tunes] = twissring(the_ring,0,1:length(the_ring)+1);
    tunesf = tunes;
    tunesi = tunes;
    converged = false;
    [mm, abort] = calc_tune_matrix(the_ring, kn, kp);
    if abort, return; end
    factor = 1;
    res_vec = (tunes-goal_tunes);
    res = calc_rms(res_vec);
    ii = 0;
    while (res > tolerancia) && (ii <max_iter) && (factor > 0.001)
        dK = -factor * (res_vec/ mm) ;
        
        new_the_ring = the_ring;
        K = getcellstruct(new_the_ring, 'PolynomB', kn,1,2);
        new_the_ring = setcellstruct(new_the_ring, 'PolynomB',kn, K*(1 + dK(1)), 1, 2);
        K = getcellstruct(new_the_ring, 'PolynomB', kp,1,2);
        new_the_ring = setcellstruct(new_the_ring, 'PolynomB',kp, K*(1 + dK(2)), 1, 2);

        
        [~, tunes] = twissring(new_the_ring,0,1:length(new_the_ring)+1);
        new_res_vec = (tunes-goal_tunes);
        new_res = calc_rms(new_res_vec);
        
        if (new_res < res)
            [mm, abort] = calc_tune_matrix(new_the_ring, kn, kp);
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
end
end

function [pseudoinv_mm, abort] = calc_tune_matrix_svd(the_ring,knobs)

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
end

function [mm, abort] = calc_tune_matrix(the_ring, kn, kp)

% calcula matriz de variacao do residuo
dK = 1e-4;
mm = zeros(2,2);

calc_ring = the_ring;
K = getcellstruct(calc_ring, 'PolynomB', kn,1,2);
calc_ring = setcellstruct(calc_ring, 'PolynomB', kn, K*(1 + dK/2), 1, 2);
[~, tunes_up] = twissring(calc_ring,0,1:length(calc_ring)+1);
calc_ring = setcellstruct(calc_ring, 'PolynomB', kn, K*(1 - dK/2), 1, 2);
[~, tunes_down] = twissring(calc_ring,0,1:length(calc_ring)+1);
mm(:,1) = (tunes_up - tunes_down)/dK;

calc_ring = the_ring;
K = getcellstruct(calc_ring, 'PolynomB', kp,1,2);
calc_ring = setcellstruct(calc_ring, 'PolynomB', kp, K*(1 + dK/2), 1, 2);
[~, tunes_up] = twissring(calc_ring,0,1:length(calc_ring)+1);
calc_ring = setcellstruct(calc_ring, 'PolynomB', kp, K*(1 - dK/2), 1, 2);
[~, tunes_down] = twissring(calc_ring,0,1:length(calc_ring)+1);
mm(:,2) = (tunes_up - tunes_down)/dK;


abort = any(isnan(mm(:)));
end
