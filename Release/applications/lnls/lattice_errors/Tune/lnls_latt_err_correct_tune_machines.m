function machine = lnls_latt_err_correct_tune_machines(tune, machine)
% function machine = lnls_latt_err_correct_optics(name, machine, coup)
%
% Correct tune of several machines.
%
% INPUTS:
%   machine : cell array of lattice models to symmetrize the optics.
%   tune    : structure with fields
%      families - families of quadrupoles to be used in correction;
%      goal - desired tunes;
%      method - 'svd' or 'group'
%      variation - 'prop' or 'add'
%      max_iter - maximum number of iteractions to be performed;
%      tolerance - if at some iteraction the difference the disered and
%         current tunes is less than this value, the correction is considered
%         to have converged and will terminate.
%   
% Look at lnls_correct_tunes for more informations.
%
% OUTPUT:
%   machine : cell array of lattice models with the tune corrected.
%

fprintf('-  goal tunes:');fprintf(' %9.6f ',tune.goal);
fprintf('\n   families used for correction:');fprintf(' %s ',tune.families{:});
fprintf('\n   maximum number of tune correction iterations: %4d\n',tune.max_iter);
fprintf('   tolerance: %8.2e\n\n', tune.tolerance);
fprintf('\n');
fprintf('    ------------------------------------------------------- \n');
fprintf('   |    initial tunes    | converged |     final tunes     |\n');
fprintf('---|-------------------------------------------------------|\n');
for i=1:length(machine)
    [machine{i}, converged, tunesf, tunesi] = lnls_correct_tunes(machine{i}, tune.goal, tune.families, tune.method, tune.variation, tune.max_iter, tune.tolerance);
    if (converged), cstr = 'yes'; else cstr = 'no'; end;
    fprintf('%03i| %9.6f %9.6f |    %3s    | %9.6f %9.6f |\n',i,tunesi,cstr,tunesf);
end
fprintf('---|-------------------------------------------------------|\n');
fprintf('\n');