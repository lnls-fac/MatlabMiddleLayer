function [r_xy, r_end_ring, r_point, r_bpm] = single_pulse(machine, param, n_part, point)
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
% - r_xy: position x and y for all the particles at all the points of
% ring model
% - r_end_ring: 6 row vector for all the particles at the end of ring model
% (used to perform turns)
% - r_bpm: position x and y for all the particles at BPM points (used to
% average over particles and result in BPM measurement simulation)
%
% Version 1 - Murilo B. Alves - October 4th, 2018

    offsets = [param.offset_x; param.offset_xl; 0; 0; param.delta; param.phase]; 
    twi.betax = param.twiss.betax0; twi.alphax = param.twiss.alphax0;
    twi.betay = param.twiss.betay0; twi.alphay = param.twiss.alphay0;
    twi.etax = param.twiss.etax0;   twi.etaxl = param.twiss.etaxl0;
    twi.etay = param.twiss.etay0;   twi.etayl = param.twiss.etayl0;
    cutoff = 3;
    
    if n_part > 1
        r_init = lnls_generate_bunch(param.beam.emitx, param.beam.emity, param.beam.sigmae, param.beam.sigmaz, twi, n_part, cutoff);
        r_init = bsxfun(@plus, r_init, offsets);
    else
        r_init = offsets;       
    end
    
    r_init(5, :) = (r_init(5, :) - param.delta_ave) / (1 + param.delta_ave);
    r_final = linepass(machine(1:point), r_init, 1:point);
    r_final = reshape(r_final, 6, [], point);
    r_xy = sirius_commis.common.compares_vchamb(machine, r_final([1,3], :, :), 1:point);
    r_final([1,3], :, :) = r_xy;
    r_end_ring = squeeze(r_final(:, :, end));
    r_point = squeeze(r_xy(:, :, point));
    
%         r_cent_init = squeeze(mean(r_init, 2));
%         r_cent_final = linepass(machine(1:point), r_cent_init, 1:point);
%         r_cent_final = reshape(r_cent_final, 6, [], point);
%         r_xy = sirius_commis.common.compares_vchamb(machine, r_cent_final([1,3], :, :), 1:point);
%         r_cent_final([1,3], :, :) = r_xy;
%         r_cent_final = squeeze(r_cent_final(:, :, end));
%         r_end_ring = r_cent_final;   
    
    if point == length(machine)
        bpm = findcells(machine, 'FamName', 'BPM');
        r_bpm = squeeze(r_xy(:, :, bpm));
    end
end
