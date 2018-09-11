function [r_xy, VChamb] = compares_vchamb(machine, r_xy, points)
    
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    VChamb = VChamb([1, 2], points);
    VChamb = reshape(VChamb, 2, [], length(points));

    ind = bsxfun(@gt, abs(r_xy), VChamb);

    or = ind(1, :, :) | ind(2, :, :);
    ind(1, :, :) = or;
    ind(2, :, :) = or;
    ind_sum = cumsum(ind, 3);

    r_xy(ind_sum >= 1) = NaN;
end

