function [r_xy, VChamb] = compares_vchamb(machine, r_xy, points, diag)
% Compares the x and y position of particles with vacuum chamber in the
% specified points. If the position is greater than the vacuum chamber, the
% value of position is set as NaN (particles are considered lost if its
% position is NaN). If diagnostic is set, the function checks if the
% position at screens or bpms are greater than vacuum chamber and if it is
% the case, set the position as the value of vacuum chamber with sign
% included (simulate a hint of where the particles are being lost).
%
% INPUTS:
%   - machine: ring model
%   - r_xy: average x and y position of particles for each pulse (dimension
%   is (2, number_of_pulses, number_of_points)
%   - points: specific points to compare the vacuum chamber
%   - diag: 'screen' or 'bpm'
%
% OUTPUTS:
%   - r_xy: position after comparison 
%   - VChamb: vacuum chamber at specified point
%
% Version 1 - Murilo B. Alves - October 5th, 2018

VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
VChamb = VChamb([1, 2], points);
VChamb = reshape(VChamb, 2, [], length(points));

if ~exist('diag', 'var')
    ind = bsxfun(@gt, abs(r_xy), VChamb);
    or = ind(1, :, :) | ind(2, :, :);
    ind(1, :, :) = or;
    ind(2, :, :) = or;
    ind_sum = cumsum(ind, 3);
    r_xy(ind_sum >= 1) = NaN;
elseif strcmp(diag, 'screen')
    ind = bsxfun(@gt, abs(r_xy), VChamb');
    if ~isempty(r_xy(ind))
       x = r_xy(ind(:, 1), 1);
       y = r_xy(ind(:, 2), 2);
       r_xy(ind(:, 1), 1) = sign(x) * VChamb(1);
       r_xy(ind(:, 2), 2) = sign(y) * VChamb(2);
    end
elseif strcmp(diag, 'bpm')
    VChamb = squeeze(VChamb);
    r_xy = squeeze(r_xy);
    ind = bsxfun(@gt, abs(r_xy), VChamb);
    if ~isempty(r_xy(ind))
       x = r_xy(1, ind(1, :));
       y = r_xy(2, ind(2, :));
       if ~isempty(x)
           r_xy(1, ind(1, :)) = sign(x) .* VChamb(1, ind(1, :));
       end
       if ~isempty(y)
           r_xy(2, ind(2, :)) = sign(y) .* VChamb(2, ind(2, :));    
       end  
    end
end
end

