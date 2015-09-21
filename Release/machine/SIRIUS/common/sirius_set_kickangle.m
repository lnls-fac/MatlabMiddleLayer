function new_ring = sirius_set_kickangle(old_ring, kicks, ind, plane)

new_ring = old_ring;
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

nrsegs = size(ind,2);


for ii=1:size(ind,1)
    if strcmp(new_ring{ind(ii,1)}.PassMethod, 'CorrectorPass')
        new_ring = setcellstruct(new_ring, 'KickAngle', ind(ii,:), kicks(ii)/nrsegs, 1, pl);
        
    elseif  strcmp(new_ring{ind(ii,1)}.PassMethod, 'ThinMPolePass')
        if pl == 1
            pb    = getcellstruct(new_ring, 'PolynomB', ind(ii,:), 1, 1);
            npb   = getcellstruct(new_ring, 'PolynomB', ind(ii,:), 1, 1);
            errors = pb - npb;
            for j=1:size(ind, 2)
                new_ring = setcellstruct(new_ring, 'PolynomB', ind(ii,j), (-kicks(ii)/nrsegs) + errors(j), 1,1);
            end
            new_ring = setcellstruct(new_ring, 'NPB', ind(ii,:), (-kicks(ii)/nrsegs), 1, 1);
        else
            pa    = getcellstruct(new_ring, 'PolynomA', ind(ii,:), 1, 1);
            npa   = getcellstruct(new_ring, 'PolynomA', ind(ii,:), 1, 1);
            errors = pa - npa;
            for j=1:size(ind, 2)
                new_ring = setcellstruct(new_ring, 'PolynomA', ind(ii,j), (+kicks(ii)/nrsegs) + errors(j), 1,1);
            end
            new_ring = setcellstruct(new_ring, 'NPA', ind(ii,:),  (+kicks(ii)/nrsegs), 1, 1);
        end
        
    elseif any(strcmp(new_ring{ind(ii,1)}.PassMethod, { ...
            'BndMPoleSymplectic4Pass', 'BndMPoleSymplectic4RadPass', ...
            'StrMPoleSymplectic4Pass', 'StrMPoleSymplectic4RadPass'}))
        % in this case we chose to model corrector with uniform diolar
        % field. This is equivalent to hard-edge model of the corrector.
        lens = getcellstruct(new_ring, 'Length', ind(ii,:));
        if pl == 1
            pb    = getcellstruct(new_ring, 'PolynomB', ind(ii,:), 1, 1);
            npb   = getcellstruct(new_ring, 'PolynomB', ind(ii,:), 1, 1);
            errors = pb - npb;
            for j=1:size(ind, 2)
                new_ring = setcellstruct(new_ring, 'PolynomB', ind(ii,j), -kicks(ii)/sum(lens) + errors(j), 1,1);
            end
            new_ring = setcellstruct(new_ring, 'NPB', ind(ii,:), -kicks(ii)/sum(lens), 1, 1);
        else
            pa    = getcellstruct(new_ring, 'PolynomA', ind(ii,:), 1, 1);
            npa   = getcellstruct(new_ring, 'PolynomA', ind(ii,:), 1, 1);
            errors = pa - npa;
            for j=1:size(ind, 2)
                new_ring = setcellstruct(new_ring, 'PolynomA', ind(ii,j), +kicks(ii)/sum(lens) + errors(j), 1,1);
            end          
            new_ring = setcellstruct(new_ring, 'NPA', ind(ii,:), +kicks(ii)/sum(lens), 1, 1);
        end
        
    else
        error('Element cannot be used as corrector.')
    end
    
end
