function [the_ring, converged, tunesf, tunesi] = lnls_correct_tunes(the_ring, goal_tunes, families, method, variation, max_iter, tolerance)
% [the_ring0, converged, tunes] = lnls_correct_tune(the_ring, goal_tunes, families, method, variation, max_iter, tolerance)
%
% Correct tunes with specified quadrupole families.
% Inputs:
%   the_ring   : model of the ring;
%
%   goal_tunes : goal tunes, including the integer;
%
%   families   : cell of strings with the family names of the quadrupoles
%                to be used (   DEFAULT = {'qda', 'qfa', 'qdb1', 'qdb2', 
%                                          'qfb', 'qdp1', 'qdp2', 'qfp'}  )
%
%   method     : 'svd'   --> uses svd considering each family as a knob (DEFAULT).
%                'group' --> groups focusing and defocusing (by family name) in two knobs 
%
%   variation  : 'prop'  --> the algorithm apply variations proportional
%                            to the strength of each magnet (DEFAULT).
%                'add'   --> it applies the same variation for each knob.
%
%   max_iter   : maximum # of trials for the correction algorithm (DEFAULT = 10);
%
%   tolerance  : acceptable euclidian distance between tunes0 and goal_tunes
%                 for the definition of convergence of the algorithm (DEFAULT = 1e-6);
%
% Outputs:
%   the_ring   : ring model with minimum distance from the desired solution
%   converged  : true if the euclidian distance between tunes0 and
%                 goal_tunes is lower than tolerance;
%   tunesf     : tunes of the model the_ring0;
%   tunesi     : initial tunes, before adjust.

if ~exist('method', 'var')||isempty(method),    method = 'svd'; end
if ~exist('variation','var')||isempty(variation), variation = 'prop'; end
if ~exist('max_iter', 'var')||isempty(max_iter),  max_iter = 10; end
if ~exist('tolerance','var')||isempty(tolerance), tolerance = 1e-6; end
if ~exist('families', 'var')||isempty(families)
    families = {'QDA','QFA','QDB1','QDB2','QFB','QDP1','QDP2','QFP'};
end


if strcmpi(variation,'prop'), prop = true;
elseif strcmpi(variation,'add'), prop = false;
else error('Wrong value for variation. Must be ''prop'' or ''add''');
end

if ~any(strcmpi(method,{'svd','group'}))
    error('Wrong method choice. Must be ''svd'' or ''group''');
end



if strcmpi(method,'svd')
    knobs = cell(1,length(families));
    for ii=1:length(families),  knobs{ii}  = findcells(the_ring, 'FamName', families{ii});
    end 
else
    knobs = cell(1,2);
    for ii=1:length(families)
        if strncmpi(families{ii},'qd',2),     knobs{1}  = [knobs{1}, findcells(the_ring, 'FamName', families{ii})];
        elseif strncmpi(families{ii},'qf',2), knobs{2}  = [knobs{2}, findcells(the_ring, 'FamName', families{ii})];
        else   fprintf('There is no way to know if family %s is focusing or defocusing\n',families{ii}); return;
        end
    end
    if isempty(knobs{1}), fprintf('No defocusing families found\n');
    elseif isempty(knobs{2}), fprintf('No focusing families found\n');
    end
    knobs{1} = sort(knobs{1}); knobs{2} = sort(knobs{2});
end
    
    calc_rms = @(x)norm(x)/sqrt(length(x));
    
    [~, tunes] = twissring(the_ring,0,1:length(the_ring)+1);
    tunesf = tunes;
    tunesi = tunes;
    converged = false;
    [pseudoinv_mm, mm, abort] = calc_tune_matrix(the_ring, knobs, prop);
    if abort, return; end
    factor = 1;
    res_vec = (tunes-goal_tunes).';
    res = calc_rms(res_vec);
    ii = 0;
    while (res > tolerance) && (ii <max_iter) && (factor > 0.001)
        
        if strcmpi(method,'svd'), dK = -factor * pseudoinv_mm * res_vec;
        else                      dK = -factor * (mm\res_vec) ;
        end
        
        new_the_ring = the_ring;
        for i=1:length(knobs)
            K = getcellstruct(new_the_ring, 'PolynomB', knobs{i},1,2);
            if prop, newK = K*(1 + dK(i)); else newK = K + dK(i); end
            new_the_ring = setcellstruct(new_the_ring, 'PolynomB',knobs{i}, newK, 1, 2);
        end
        
        [~, tunes] = twissring(new_the_ring,0,1:length(new_the_ring)+1);
        new_res_vec = (tunes-goal_tunes).';
        new_res = calc_rms(new_res_vec);
        
        if (new_res < res)
            res_vec = new_res_vec;
            res = new_res;
            the_ring = new_the_ring;
            tunesf = tunes;
            factor = min([factor * 2, 1]);
            if res < tolerance, break; end
            [pseudoinv_mm, mm, abort] = calc_tune_matrix(new_the_ring, knobs, prop);
            if abort, break; end
        else
            factor = factor / 2;
            %         [pseudoinv_mm, abort] = calc_tune_matrix(the_ring, knobs);
            %         if abort, break; end
        end
        ii = ii + 1;
    end
    
    converged = res < tolerance;
end

function [pseudoinv_mm, mm, abort] = calc_tune_matrix(the_ring,knobs, prop)

% calcula matriz de variacao do residuo
df = 1e-4;
mm = zeros(2,length(knobs));
pseudoinv_mm = zeros(length(knobs),2);
for i=1:length(knobs)
    calc_ring = the_ring;
    K = getcellstruct(calc_ring, 'PolynomB', knobs{i},1,2);
    if prop, dK = K*df; else dK = df; end
    calc_ring = setcellstruct(calc_ring, 'PolynomB', knobs{i}, K + dK/2, 1, 2);
    [~, tunes_up] = twissring(calc_ring,0,1:length(calc_ring)+1);
    calc_ring = setcellstruct(calc_ring, 'PolynomB', knobs{i}, K - dK/2, 1, 2);
    [~, tunes_down] = twissring(calc_ring,0,1:length(calc_ring)+1);
    mm(:,i) = (tunes_up - tunes_down)/df;
end

abort = any(isnan(mm(:)));
if abort, return; end

% calcula pseudo inversa da matriz de variacao do residuo
[U,S,V] = svd(mm,'econ');
pseudoinv_mm = V*(S\U');
end
