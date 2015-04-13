function errors = lnls_latt_err_generate_multipole_errors(name, the_ring, multi, nr_mach, cutoff)
% function errors = lnls_latt_err_generate_multipole_errors(name, the_ring, multi, nr_machines, cutoff)
%
% Generates random errors to be applied in the model by the function
% apply_errors.
%
% INPUTS:
%   name       : a string to be used as name to save the configuration data
%   the_ring   : is a ring model.
%   multi      : strucuture with configuration of the errors for groups of 
%     magnets. Each group must be of the form:
%       groupN.labels = {'qfa','qfb','qdb2','qf1','qf2','qf3','qf4'};
%       groupN.nrsegs = ones(1,7);
%       groupN.main_multipole = 2;% positive for normal negative for skew
%       groupN.r0 = 11.7e-3;
%       groupN.order       = [ 3   4   5   6   7   8   9   10]; % 1 for dipole
%       groupN.main_vals = 1*ones(1,8)*4e-5; 
%       groupN.skew_vals = 1*ones(1,8)*1e-5;
%
%   nr_mach : generate errors for this number of machines.
%   cutoff  : number of sigmas to cutoff the distribution (default is infinity)
%
%  OUTPUT:
%    errors : Structure with errors for each group of magnet. The errors
%       must be applied to the machines with the function
%       lnls_latt_err_apply_multipole_errors;
%
%  modified 2015/03/05 by Fernando.
%
% SEE ALSO: lnls_latt_err_apply_multipole_errors


fprintf(['--- generate_multipole_errors [' datestr(now) '] ---\n']);

if ~exist('cutoff', 'var'), cutoff = inf; end

save([name,'_generate_multipole_errors_input.mat'], 'multi', 'nr_mach', 'cutoff');

families = fieldnames(multi);
fam_idx = findcells(the_ring, 'FamName');
fam_list = getcellstruct(the_ring,'FamName',fam_idx);
for k=1:nr_mach
    for i=1:length(families)
        family = multi.(families{i});
        errors.(families{i}).indcs = [];
        Bn_norm = [];
        An_norm = [];
        for j=1:length(family.labels)
            label = family.labels{j};
            nrsgs = family.nrsegs(j);
            indcs = fam_idx(ismember(fam_list,label));
            errors.(families{i}).indcs = [errors.(families{i}).indcs indcs];
            nrels = length(indcs) / nrsgs;
            [Bn, An]= get_random_errors(family, nrels, nrsgs, cutoff);
            Bn_norm = [Bn_norm Bn];
            An_norm = [An_norm An];
        end
        errors.(families{i}).Bn_norm(k,:,:) = Bn_norm;
        errors.(families{i}).An_norm(k,:,:) = An_norm;
    end
end
fprintf('\n');


function [rndnr1, rndnr2] = get_random_errors(family, nrels, nrsgs, cutoff_errors)
%Componentes normais
num_orders = length(family.main_vals);
rndnr = zeros(1,nrels*num_orders);
sel = 1:nrels*num_orders;
while ~isempty(sel)
    rndnr(sel) = randn(1,length(sel));
    sel = find(abs(rndnr) > cutoff_errors);
end
rndnr = reshape(rndnr,num_orders,nrels);
rndnr = repmat(family.main_vals',1,nrels) .* rndnr;
rndnr = repmat(rndnr, nrsgs, 1);
rndnr1 = reshape(rndnr,num_orders,nrels*nrsgs);

%Componentes skew
rndnr = zeros(1,nrels*num_orders);
sel = 1:nrels*num_orders;
while ~isempty(sel)
    rndnr(sel) = randn(1,length(sel));
    sel = find(abs(rndnr) > cutoff_errors);
end
rndnr = reshape(rndnr,num_orders,nrels);
rndnr = repmat(family.skew_vals',1,nrels) .* rndnr;
rndnr = repmat(rndnr, nrsgs, 1);
rndnr2 = reshape(rndnr,num_orders,nrels*nrsgs);

