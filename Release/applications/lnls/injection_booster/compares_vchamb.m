function [r_xy, VChamb] = compares_vchamb(machine, r_xy, points, diag)
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    VChamb = VChamb([1, 2], points);
    VChamb = reshape(VChamb, 2, [], length(points));
    
          
    if diag
        if length(points) == 1;
            ind = bsxfun(@gt, abs(r_xy), VChamb');
            if ~isempty(r_xy(ind))
               x = r_xy(ind(:, 1), 1);
               y = r_xy(ind(:, 2), 2);
               r_xy(ind(:, 1), 1) = sign(x) * VChamb(1);
               r_xy(ind(:, 2), 2) = sign(y) * VChamb(2);
            end
        else
            VChamb = squeeze(VChamb);
            ind = bsxfun(@gt, abs(squeeze(r_xy)), VChamb);
            if ~isempty(r_xy(ind))
               x = squeeze(squeeze(r_xy(1, ind(1, :))));
               y = squeeze(squeeze(r_xy(2, ind(2, :))));
               if ~isempty(x)
                   r_xy(1, ind(1, :)) = sign(x) .* VChamb(1, ind(1, :));
               elseif ~isempty(y)
                   r_xy(2, ind(1, :)) = sign(y) .* VChamb(2, ind(2, :));    
               end  
            end
        end        
    else
        ind = bsxfun(@gt, abs(r_xy), VChamb);
        or = ind(1, :, :) | ind(2, :, :);
        ind(1, :, :) = or;
        ind(2, :, :) = or;
        ind_sum = cumsum(ind, 3);

        r_xy(ind_sum >= 1) = NaN;
    end
end

