function kicks = sirius_get_kickangle(ring, ind, plane)

kicks = zeros(1,size(ind,1));
if ischar(plane) 
    if plane == 'x'
        pl = 1;
    elseif plane == 'y'
        pl = 2;
    else
        error('Value assigned to plane is not valid');
    end
elseif isnumeric(plane)
    if any(plane == [1,2])
        pl = plane;
    else
        error('Value assigned to plane is not valid');
    end
end

for ii=1:size(ind,1)
    if strcmp(ring{ind(ii,1)}.PassMethod, 'CorrectorPass')
        kicks(ii) = sum(ring{ind(ii,:)}.KickAngle(pl));
    elseif  strcmp(ring{ind(ii,1)}.PassMethod, 'ThinMPolePass')
        if pl == 1
            kicks(ii) = -sum(getcellstruct(ring, 'NPB', ind(ii,:), 1, 1));
        else
            kicks(ii) = +sum(getcellstruct(ring, 'NPA', ind(ii,:), 1, 1));
        end
    elseif any(strcmp(ring{ind(ii,1)}.PassMethod, { ...
            'BndMPoleSymplectic4Pass', 'BndMPoleSymplectic4RadPass', ...
            'StrMPoleSymplectic4Pass', 'StrMPoleSymplectic4RadPass'}))
        len = getcellstruct(ring, 'Length', ind(ii,:));
        if pl == 1
            kicks(ii) = -sum(getcellstruct(ring, 'NPB', ind(ii,:), 1, 1) .* len);
        else
            kicks(ii) = +sum(getcellstruct(ring, 'NPA', ind(ii,:), 1, 1) .* len);
        end
    else
        error('Element cannot be used as corrector.')
    end
end