function r_final = sirius_booster_injection(ring, param, n_part)
%
% -->> ring: ring model
% -->> param: struct with the following parameters:
% - twiss functions in the point of injection: betax0, betay0, alphax0,
% alphay0, etax0, etay0, etaxl0, etayl0
% - kckr: angle of injection kicker
% - offset_x and offset_xl are the nominal values to correct injection
% - beam parameters: emitx, emity, energy spread and bunch length
% - cutoff: value to cutoff of distributions to generate initial bunch
% -->> n_part: number of particles
%
% Obs.: once the function sirius_bo_lattice_errors_analysis() is updated,
% this function must be checked too.

    % Setting the nominal kick of the injection kicker
    sept = findcells(ring, 'FamName','InjSept');
    ring = circshift(ring,[0,-(sept-1)]);

    injkckr = findcells(ring, 'FamName','InjKckr');
    ring = lnls_set_kickangle(ring, param.kckr, injkckr, 'x');
    % angle kicker = -19.34 mrad

    % Error in the magnets
    initializations();
    family_data = sirius_bo_family_data(ring);
    machine  = create_apply_errors(ring, family_data);
    machine  = create_apply_multipoles(machine, family_data);
    machine = machine{1};

    %Determines and sets the values of horizontal vacuum chamber at those points
    %following a linear interpolation
    [machine, s] = vchamber_injection(machine);

    %Offsets at injection points
    % offset_x = -30e-3;
    % offset_xl = 14.1e-3;
    
    offsets = [param.offset_x; param.offset_xl; 0; 0; 0; 0];
    offsets = repmat(offsets, 1, n_part);
    
    twi.betax = param.betax0; twi.alphax = param.alphax0;
    twi.betay = param.betay0; twi.alphay = param.alphay0;
    twi.etax = param.etax0;   twi.etaxl = param.etaxl0;
    twi.etay = param.etay0;   twi.etayl = param.etayl0;
    
    %Generate the random initial vector in phase space and adds the offset 
    r_init = lnls_generate_bunch(param.emitx, param.emity, param.sigmae, param.sigmaz, twi, n_part, param.cutoff);
    r_init = r_init + offsets;

    %Tracking and convertion to 3D matrix
    r_final = linepass(machine, r_init, 1:length(machine));
    r_final = reshape(r_final, 6, n_part, length(machine));

    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    VChamb = VChamb([1,2],:);
    VChamb = reshape(VChamb, 2, [], length(machine));

    %In the cas n_part = 1 there is a problem which is solved not transposing 
    r_final = r_final([1, 3], :, :);
 
    %For each element compares if x or y position ir greater than the vacuum
    %chamber limits
    ind = bsxfun(@gt, abs(r_final), VChamb);

    either = ind(1,:,:) | ind(2,:,:);
    ind(1,:,:) = either;
    ind(2,:,:) = either;
    
    ind_sum = cumsum(ind, 3);
    ind_sum = ind_sum >= 1;
    
    r_final(ind_sum) = NaN;
  
    % xx = squeeze(nanmean(r_final(1, :, :),2));
    xx = squeeze(r_final(1, :, :));
    %sxx = squeeze(nanstd(r_final(1, :, :), 0, 2));
    %plot(s, (xx+sxx)', 'r --');
    %hold all
    %plot(s, (xx-sxx)', 'r --');
    plot(s, (xx)', '.r');
    hold all
    plot(s, VChamb(1,:),'k');
    plot(s, -VChamb(1,:),'k');
    
    % Prints the percentage of lost particles 
    % display((1-(length(r_final(1,:, end)) - sum(isnan(r_final(1,:, end))))/length(r_final(1,:, end)))*100);
end
%% Initializations
function initializations()

    fprintf('\n<initializations> [%s]\n\n', datestr(now));

    % seed for random number generator
    seed = 131071;
    fprintf('-  initializing random number generator with seed = %i ...\n', seed);
    RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));

end
%% Magnet Errors:
function machine = create_apply_errors(the_ring, family_data)

    fprintf('\n<error generation and random machines creation> [%s]\n\n', datestr(now));

    % constants
    um = 1e-6; mrad = 0.001; percent = 0.01;

    % <quadrupoles> alignment, rotation and excitation errors
    config.fams.quads.labels     = {'QF','QD','QS'};
    config.fams.quads.sigma_x    = 160 * um;
    config.fams.quads.sigma_y    = 160 * um;
    config.fams.quads.sigma_roll = 0.800 * mrad;
    config.fams.quads.sigma_e    = 0.3 * percent;

    % <sextupoles> alignment, rotation and excitation errors
    config.fams.sexts.labels     = {'SD','SF'};
    config.fams.sexts.sigma_x    = 160 * um;
    config.fams.sexts.sigma_y    = 160 * um;
    config.fams.sexts.sigma_roll = 0.800 * mrad;
    config.fams.sexts.sigma_e    = 0.3 * percent;

    % <dipoles with more than one piece> alignment, rotation and excitation errors
    config.fams.b.labels       = {'B'};
    config.fams.b.sigma_x      = 160 * um;
    config.fams.b.sigma_y      = 160 * um;
    config.fams.b.sigma_roll   = 0.800 * mrad;
%         config.fams.b.sigma_e      = 0.15 * percent * 1;
    config.fams.b.sigma_e      = 0.05 * percent; % based on estimated error of measured fmap analysis from measurement bench fluctuation - XRR - 2018-08-23
%         config.fams.b.sigma_e_kdip = 2.4 * percent * 1;  % quadrupole errors due to pole variations
    config.fams.b.sigma_e_kdip = 0.3 * percent;  % based on measured fmap analysis - XRR - 2018-08-23 - see /home/fac_files/lnls-ima/bo-dipoles/model-09/analysis/hallprobe/production/magnet-dispersion.ipynb


    % sets number of segmentations for each family
    families = fieldnames(config.fams);
    for i=1:length(families)
        family = families{i};
        labels = config.fams.(family).labels;
        config.fams.(family).nrsegs = zeros(1,length(labels));
        for j=1:length(labels)
            config.fams.(family).nrsegs(j) = family_data.(labels{j}).nr_segs;
        end
    end

    % generates error vectors
    nr_machines   = 1;
    rndtype       = 'gaussian';
    cutoff_errors = 1;
    fprintf('-  generating errors ...\n');
    name = 'CONFIG';

    errors        = lnls_latt_err_generate_errors(name, the_ring, config, nr_machines, cutoff_errors, rndtype);

    % applies errors to machines
    fractional_delta = 1;
    fprintf('-  creating %i random machines and applying errors ...\n', nr_machines);
    fprintf('-  finding closed-orbit distortions with sextupoles off ...\n\n');
    machine = lnls_latt_err_apply_errors(name, the_ring, errors, fractional_delta);
end

%% Multipoles insertion
function machine = create_apply_multipoles(machine, family_data)

    fprintf('\n<application of multipole errors> [%s]\n\n', datestr(now));

    % QUADRUPOLES
    multi.quads.labels = {'QD','QF','QS'};
    multi.quads.main_multipole = 2;% positive for normal negative for skew
    multi.quads.r0 = 17.5e-3;
    multi.quads.order     = [3, 4, 5, 6, 7, 8, 9]; % 1 for dipole
    multi.quads.main_vals = [7.0, 4*ones(1,6)]*1e-4;
    multi.quads.skew_vals = [10, 5, ones(1,5)]*1e-4;

    % SEXTUPOLES
    multi.sexts.labels = {'SD','SF'};
    multi.sexts.main_multipole = 3;% positive for normal negative for skew
    multi.sexts.r0 = 17.5e-3;
    multi.sexts.order     = [4, 5, 6, 7, 8, 9, 10]; % 1 for dipole
    multi.sexts.main_vals = ones(1,7)*4e-4;
    multi.sexts.skew_vals = ones(1,7)*1e-4;

    % DIPOLES
    multi.bends.labels = {'B'};
    multi.bends.main_multipole = 1;% positive for normal negative for skew
    multi.bends.r0 = 17.5e-3;
    multi.bends.order = [3, 4, 5, 6, 7]; % 1 for dipole
    % based on measured fmap analysis - XRR - 2018-08-23 - see /home/fac_files/lnls-ima/bo-dipoles/model-09/analysis/hallprobe/production/magnet-dispersion.ipynb
    % (dSL)r_0^2 / (DL) ~ 2.3e-3, dSL ~ 0.945 T/m, DL ~ 0.126 T.m
%         multi.bends.main_vals = [5.5, 4*ones(1,4)]*1e-4;
    multi.bends.main_vals = [23, 4*ones(1,4)]*1e-4; 

    multi.bends.skew_vals = ones(1,5)*1e-4;

    % sets number of segmentations for each family
    families = fieldnames(multi);
    for i=1:length(families)
        family = families{i};
        labels = multi.(family).labels;
        multi.(family).nrsegs = zeros(1,length(labels));
        for j=1:length(labels)
            multi.(family).nrsegs(j) = family_data.(labels{j}).nr_segs;
        end
    end

    % adds systematic multipole errors to random machines
    for i=1:length(machine)
        machine{i} = sirius_bo_multipole_systematic_errors(machine{i});
    end
    
    % machine = machine{1,1};
    name = 'CONFIG';
    cutoff_errors = 2;
    multi_errors  = lnls_latt_err_generate_multipole_errors(name, machine{1,1}, multi, length(machine), cutoff_errors);
    machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);

end

function [machine, s] = vchamber_injection(machine)
    xcv_sep = 41.86e-3;
    xcv_kckr = 30.14e-3;
    
    s = findspos(machine, 1:length(machine));

    injkckr = findcells(machine, 'FamName','InjKckr');
    xcv = (xcv_kckr - xcv_sep) / (s(injkckr) - s(1)) * s(1:injkckr)  + xcv_sep;
    xcv = [xcv, xcv(end)];

    machine = setcellstruct(machine, 'VChamber', 1:injkckr+1, xcv, 1, 1);
end