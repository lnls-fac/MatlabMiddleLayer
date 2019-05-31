function r_particles = single_pulse(machine, param, n_part, point)
% Perfom the tracking of a number n_part of particles until the specified
% point with given parameters of injection. Returns the position or the 6
% component vector of particle at all points of ring, the end or at BPMs.
%
% INPUTS:
% - machine: ring model
% - param: struct with the following injection parameters
%      - twiss function at injection betax0, betay0, alphay0, etax0, etay0, etaxl0, etayl0
%      - offset_x and offset_xl are the values of position and angle of
%      injection
%      - beam parameters: emitx, emity, sigmae (energy spread) and sigmaz
%      (bunch length)
%      - cutoff: value to cutoff of distributions to generate initial bunch
%      - sigma_bpm: precision of BPM measurements at 1nC single-pass (2mm)
%      - sigma_scrn: precision of screen
% - n_part: number of particles
% - point: specific position to stop the tracking
%
% OUTPUTS:
% - r_particles: structure with the fields
%       - r_track: 6D coordinates for all the particles at all the points of
%       ring model
%       - r_bpm: position x and y for all the particles at BPM points (used to
%       average over particles and result in BPM measurement simulation)
%       - r_point: 6D coordinates for all the particles at the input point

    %   Initial offsets at injection point - nominal + syst. errors + jitter errors
    offsets = [param.offset_x; param.offset_xl; param.offset_y; param.offset_yl; param.delta; param.phase];

    % Twiss function at injection point
    twi.betax = param.twiss.betax0; twi.alphax = param.twiss.alphax0;
    twi.betay = param.twiss.betay0; twi.alphay = param.twiss.alphay0;
    twi.etax = param.twiss.etax0;   twi.etaxl = param.twiss.etaxl0;
    twi.etay = param.twiss.etay0;   twi.etayl = param.twiss.etayl0;

    % Generate particles
    if n_part > 1
        cutoff = 3;
        r_init = lnls_generate_bunch(param.beam.emitx, param.beam.emity, param.beam.sigmae, param.beam.sigmaz, twi, n_part, cutoff);
        r_init = bsxfun(@plus, r_init, offsets);
    else
        r_init = offsets;
    end

    % The beam energy is changed to simulate the dipoles adjusts
    r_init(5, :) = (r_init(5, :) - param.delta_ave) / (1 + param.delta_ave);

    if param.delta_ave ~= 0
        % To simulate dipoles adjusts changing the beam energy one has to consider that the BC energy is always fixed
        bc = findcells(machine, 'FamName', 'BC');
        theta0 = getcellstruct(machine, 'BendingAngle', bc);
        len = getcellstruct(machine, 'Length', bc);
        polyB_orig = getcellstruct(machine, 'PolynomB', bc);
        polyB_new = polyB_orig;
        dtheta = zeros(length(polyB_new), 1);

        for j = 1:length(polyB_orig)
            polyB_new{j} = polyB_orig{j} / (1 + param.delta_ave) ;
        end

        for j = 1:length(polyB_new)
            pb = polyB_new{j};
            dtheta(j) = theta0(j) ./ len(j) * (- param.delta_ave) / (1 + param.delta_ave);
            pb(1,1) = pb(1,1) - dtheta(j);
            polyB_new{j} = pb;
        end

        machine_new = setcellstruct(machine, 'PolynomB', bc, polyB_new);
    else
        machine_new = machine;
    end

    % Perform the tracking until the required point at the ring
    r_final = linepass(machine(1:point(end)), r_init, 1:point(end));
    r_final = reshape(r_final, 6, [], point(end));

    % Comparison with Vacuum Chamber at every point, lost particles are set as NaN
    r_xy = sirius_commis.common.compares_vchamb(machine, r_final([1,3], :, :), 1:point(end));
    r_final([1,3], :, :) = r_xy;
    % sirius_commis.scatplot(1e3 * squeeze(r_xy(1, :, point)), 1e3 * squeeze(r_xy(2, :, point)), 'circles', 2e-2, 2e3, 5, 1, 4);

    % Beam coordinates x and y at the required point
    for i = 1:length(point)
        r_point(:, :, i) = squeeze(r_xy(:, :, point(i)));
    end

    % If the tracking was performed in all the ring, it also returns the x, y position of all tracked particles at BPMs
    if point(end) == length(machine_new)
        bpm = findcells(machine_new, 'FamName', 'BPM');
        r_bpm = squeeze(r_xy(:, :, bpm));
        r_particles.r_bpm = r_bpm;
    end

    r_particles.r_track = r_final;
    r_particles.r_point = r_point;
end
