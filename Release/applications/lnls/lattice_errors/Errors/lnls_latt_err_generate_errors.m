function errors = lnls_latt_err_generate_errors(name, the_ring, config, nr_mach, cutoff, rndtype)
%
% Generates random errors to be applied in the model by the function
% apply_errors.
%
% INPUTS:
%   name       : a string to be used as name to save the configuration data
%   the_ring   : is a ring model.
%   config     : strucuture with configuration of the errors with the
%                fields fams and girders. Both are optional:
%     fams   : structure with fields defining type of errors and rms values. Example:
%       quads.labels       = {'qfa','qdb2','qfb'};
%       quads.nrsegs       = [1,1,1];      % nrsegs is the number of divisions of each magnet in the lattice model
%       quads.sigma_x      = 40 * um * 1;  % all fields below are optional
%       quads.sigma_y      = 40 * um * 1;
%       quads.sigma_roll   = 0.20 * mrad * 1;
%       quads.sigma_e      = 0.05 * percent * 1;
%       quads.sigma_yaw    = 0.10 * mrad * 0;
%       quads.sigma_pitch  = 0.10 * mrad * 0;
%
%     girder : Define alignment errors for girders. This option will only
%              work if the the magnets in the_ring have a field specifying
%              to which girder they belong. Example:
%       girder_error_flag = false;   % if false, the whole field is ignored
%       correlated_errors = false;   % if true, adjacents girders will have correlated errors
%       sigma_x     = 100 * um * 1;  % all fields below are optional
%       sigma_y     = 100 * um * 1;
%       sigma_roll  =0.20 * mrad * 1;
%       sigma_yaw   =  20 * mrad * 0;
%       sigma_pitch =  20 * mrad * 0;
%   nr_mach : generate errors for this number of machines.
%   cutoff  : number of sigmas to cutoff the distribution (default is infinity)
%   rndtype : type of distribution. Possible values: 'sin' and 'gauss' (default is 'gauss')
%
%  OUTPUT:
%    errors : Structure with fields: errors_{x,y,roll,yaw,pitch,e,e_kdip}.
%      Each field is an array with dimension nr_machines x length(the_ring)
%      with errors generated for the elements defined by the inputs. If an
%      element errors has contributions from fams and girders, the value
%      present in this output will be the sum of them.
%
%  modified 2015/03/05 by Fernando.
%
% SEE ALSO: lnls_latt_err_apply_errors, lnls_latt_err_correct_cod, 
% lnls_latt_err_correct_coupling, lnls_latt_err_correct_optics,
% lnls_latt_err_correct_tune_machines

errors.errors_x      = zeros(nr_mach, length(the_ring));
errors.errors_y      = zeros(nr_mach, length(the_ring));
errors.errors_roll   = zeros(nr_mach, length(the_ring));
errors.errors_yaw    = zeros(nr_mach, length(the_ring));
errors.errors_pitch  = zeros(nr_mach, length(the_ring));
errors.errors_e      = zeros(nr_mach, length(the_ring));
errors.errors_e_kdip = zeros(nr_mach, length(the_ring));

if ~exist('cutoff','var'), cutoff = []; end
if ~exist('rndtype','var'), rndtype = 'gaussian'; end;

save([name,'_generate_errors_input.mat'],'config','nr_mach','cutoff','rndtype');

if isfield(config, 'fams')
    families = fieldnames(config.fams);
    fam_idx = findcells(the_ring, 'FamName');
    fam_list = getcellstruct(the_ring,'FamName',fam_idx);
    for k=1:nr_mach
        for i=1:length(families)
            family = config.fams.(families{i});
            if ischar(family.labels)
                % GIRDERS!!!
                label = family.labels;
                idx = fam_idx(ismember(fam_list,label));
                idx   = idx(:)';
                idx   = [idx; idx(2:end) idx(1)]';
                for j=1:size(idx, 1)
                    if idx(j,2) < idx(j,1)
                        indcs = [idx(j,1)+1:length(the_ring) 1:idx(j,2)-1];
                    else
                        indcs = idx(j,1)+1:idx(j,2)-1;
                    end
                    nrsgs = length(indcs);
                    nrels = length(indcs) / nrsgs;
                    errors = get_fam_random_errors(errors, family, k, indcs, nrels, ...
                        nrsgs, cutoff, rndtype);
                end
            elseif iscell(family.labels{1})
                indcs = [];
                for j=1:length(family.labels{1})
                    indcs = [indcs fam_idx(ismember(fam_list,family.labels{1}{j}))];
                end
                nrels = 1;
                nrsgs = length(indcs);
                errors = get_fam_random_errors(errors, family, k, indcs, nrels, nrsgs, ...
                    cutoff, rndtype);
            else
                for j=1:length(family.labels)
                    label = family.labels{j};
                    nrsgs = family.nrsegs(j);
                    indcs = fam_idx(ismember(fam_list,label));
                    nrels = length(indcs) / nrsgs;
                    errors = get_fam_random_errors(errors, family, k, indcs, nrels, ...
                        nrsgs, cutoff, rndtype);
                end
            end
        end
    end
end

if isfield(config,'girder') && (config.girder.girder_error_flag)
    girders_idx = findcells(the_ring,'Girder');
    girders_list = getcellstruct(the_ring,'Girder',girders_idx);
    [fam_girders, fam_idx, ~] = unique(girders_list);
    [~, idx_fam] = sort(girders_idx(fam_idx));
    fam_girders = fam_girders(idx_fam);
    
    girder = config.girder;
    
    if ~girder.correlated_errors
        nrels = length(fam_girders);
        indcs = ones(1,length(the_ring));
        for ii=1:nrels
            label = fam_girders{ii};
            idx = girders_idx(ismember(girders_list,label));
            indcs(idx) = indcs(idx) + ii;
        end
        
        for k=1:nr_mach
            errors = get_gir_random_errors(errors, girder, k,indcs, nrels, ...
                cutoff, rndtype);
        end
    else
        dip_idx = findcells(the_ring,'BendingAngle');
        dip_girder = unique(girders_list(ismember(girders_idx,dip_idx)));
        nrels = length(dip_girder);
        indcs  = ones(1,length(the_ring));
        indcs2 = ones(2,length(the_ring));
        for ii=1:nrels
            label = dip_girder{ii};
            idx = girders_idx(ismember(girders_list,label));
            indcs(idx) = indcs(idx) + ii;
            [~,id] = ismember(label,fam_girders);
            idx = girders_idx(ismember(girders_list,fam_girders{id-1}));
            indcs2(1,idx) = indcs2(1,idx) + ii;
            idx = girders_idx(ismember(girders_list,fam_girders{id+1}));
            indcs2(2,idx) = indcs2(2,idx) + ii;
        end
        
        for k=1:nr_mach
            errors = get_gir_random_errors(errors, girder, k,indcs, nrels, ...
                cutoff, rndtype, indcs2);
        end
    end
end



function errors = get_fam_random_errors(errors, family, k, indcs, nrels, nrsgs, cutoff_errors, rndtype)

type_err = {'x','y','roll','yaw','pitch','e','e_kdip'};
for ii=type_err
    error_type = ['sigma_' ii{:}];
    if isfield(family, error_type)
        rndnr1 = get_random_numbers(family.(error_type), nrels, cutoff_errors, rndtype);
        rndnr1 = repmat(rndnr1', nrsgs, 1); rndnr1 = rndnr1(:);
        errors.(['errors_' ii{:}])(k,indcs) = errors.(['errors_' ii{:}])(k,indcs) + rndnr1';
    end
end


function errors = get_gir_random_errors(errors, girder, k, indcs, nrels, cutoff_errors, rndtype, indcs2)

if ~exist('indcs2','var')
    indcs2 = ones(2,length(errors.errors_x));
end

type_err = {'x','y','roll','yaw','pitch'};
for ii=type_err
    error_type = ['sigma_' ii{:}];
    if isfield(girder, error_type)
        rndn1 = get_random_numbers(girder.(error_type), nrels, cutoff_errors, rndtype); rndn1 = [0, rndn1'];
        errors.(['errors_' ii{:}])(k,:) = errors.(['errors_' ii{:}])(k,:) + rndn1(indcs) + (rndn1(indcs2(1,:))+rndn1(indcs2(2,:)))/2;
    end
end


function rndnr = get_random_numbers(sigma, nrels, cutoff, type)
% erro gaussiano truncado em 1 sigma: decidido apos conversa com o Ricardo
% sobre erros de alinhamento em 17/09/2012.
max_value = cutoff;
rndnr = zeros(nrels,1);
sel = 1:nrels;
if any(strcmpi(type, {'gaussian','gauss','norm', 'normal'}))
    while ~isempty(sel)
        rndnr(sel) = randn(1,length(sel));
        sel = find(abs(rndnr) > max_value);
        %     sel = []; % abri mão da truncagem para para tornar os erros repetitivos.
    end
elseif any(strcmpi(type, {'sin','vibration','ripple', 'cos','time-average'}))
    rndnr(sel) = gen_random_from_sin(length(sel));
end
rndnr = sigma * rndnr;


function rndnr = gen_random_from_sin(nrnrs)

rndnr = sin(2*pi*rand(1,nrnrs));


