function new_ring = lnls_add_multipoles(the_ring, Bn_norm, An_norm, main_monomial, r0, idx)

new_ring = the_ring;
len_idx = length(idx);

if length(main_monomial)==1 && length(main_monomial) ~= len_idx
    main_monomial = repmat(main_monomial,1,len_idx);
end
if size(Bn_norm,2)==1 && size(Bn_norm,2) ~= len_idx
    Bn_norm = repmat(Bn_norm,1,len_idx);
end
if size(An_norm,2)==1 && size(An_norm,2) ~= len_idx
    An_norm = repmat(An_norm,1,len_idx);
end

for ii=1:len_idx
    main_monomial_i = main_monomial(ii);
    Bn_norm_i = Bn_norm(:,ii)';
    An_norm_i = An_norm(:,ii)';
    idx_i = idx(ii);
    if abs(main_monomial_i)==1 && isfield(new_ring{idx_i},'BendingAngle') && (new_ring{idx_i}.BendingAngle~=0)
        if isfield(new_ring{idx_i},'Length') && new_ring{idx_i}.Length > 0
            KP = new_ring{idx_i}.BendingAngle/new_ring{idx_i}.Length;
        else
            KP = new_ring{idx_i}.BendingAngle;
        end
    else
        if sign(main_monomial_i)==1
            KP = new_ring{idx_i}.PolynomB(main_monomial_i);
        else
            KP = new_ring{idx_i}.PolynomA(-main_monomial_i);
        end
    end
    r0_i = r0.^(abs(main_monomial_i)-(1:size(An_norm_i,2)));
    newPolB = KP*r0_i.*Bn_norm_i;
    newPolA = KP*r0_i.*An_norm_i;
    oldPolB = new_ring{idx_i}.PolynomB;
    oldPolA =  new_ring{idx_i}.PolynomA;
    lenNewPolB = length(newPolB); 
    lenOldPolB = length(oldPolB);
    if lenNewPolB > lenOldPolB
        polB = newPolB; 
        polB(1:lenOldPolB) = polB(1:lenOldPolB) + oldPolB;
    else
        polB = oldPolB;
        polB(1:lenNewPolB) = polB(1:lenNewPolB) + newPolB;
    end
    lenNewPolA = length(newPolA); 
    lenOldPolA = length(oldPolA);
    if lenNewPolA > lenOldPolA
        polA = newPolA; 
        polA(1:lenOldPolA) = polA(1:lenOldPolA) + oldPolA;
    else
        polA = oldPolA; 
        polA(1:lenNewPolA) = polA(1:lenNewPolA) + newPolA;
    end
    new_ring{idx_i}.PolynomB = polB;
    new_ring{idx_i}.PolynomA = polA;
    new_ring{idx_i}.MaxOrder = max([length(polB), length(polA)])-1;
end
