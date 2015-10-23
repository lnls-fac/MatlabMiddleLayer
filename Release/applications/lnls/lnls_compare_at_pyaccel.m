function lnls_compare_at_pyaccel(accelerator)

% compares tracking results of AT models against Pyaccel models.
% see 'sirius-test-lattices.py' script in 'scripts' repo.

global THERING;

sirius(upper(accelerator));
traj_pyaccel = importdata([accelerator, '-linepass.txt']); traj_pyaccel = traj_pyaccel';

if (length(THERING) ~= size(traj_pyaccel,2))
   fprintf('lattice models in pyaccel and AT have different dimensions: %i and %i !\n', size(traj_pyaccel,2), length(THERING));
   return;
end

fprintf('--- comparison ---\n');
p0 = traj_pyaccel(:,1);
traj_at = linepass(THERING, p0, 1:length(THERING));
traj_diff = traj_pyaccel - traj_at;
[~,c] = find(abs(traj_diff) > eps);

if isempty(c)
    fprintf('AT and pyaccel linepass tracking match.\n');
else
    cm = min(c);
    fprintf('AT and pyaccel diverge at entrance of element #%i:\n', cm);
    fprintf('AT     : '); fprintf('%+.17e ', traj_at(:,cm)); fprintf('\n');
    fprintf('pyaccel: '); fprintf('%+.17e ', traj_pyaccel(:,cm)); fprintf('\n');
    fprintf('Element#%i is %s\n', cm-1, THERING{cm-1}.FamName);
end
fprintf('---\n');
    

