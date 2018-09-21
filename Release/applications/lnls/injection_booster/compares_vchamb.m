function [r_xy, VChamb] = compares_vchamb(machine, r_xy, points, diag)
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

