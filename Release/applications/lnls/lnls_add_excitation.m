function ring = lnls_add_excitation(errors, indices, ring)

% History
%
% 2013-03-15: added support for correctors (KickAngle) - Ximenes.

% if indices is an 2D-array, transform it into a cellarray of vectors;
if isnumeric(indices)
    indices = mat2cell(indices, ones(1, size(indices,1)));
end

for i=1:length(indices)
    indcs = indices{i};
    for idx=indcs
        if isfield(ring{idx}, 'BendingAngle') && (ring{idx}.BendingAngle ~= 0)
            rho = ring{idx}.Length / ring{idx}.BendingAngle;
            erro_ori = ring{idx}.PolynomB(1);
            ring{idx}.PolynomB(1) = erro_ori + errors(i) / rho;    % Ler 'BndMPoleSymplectic4Pass.c'!
%             for k=2:length(ring{idx}.PolynomA)
%                 ring{idx}.PolynomA(k) = (1 + errors(i)) * ring{idx}.PolynomA(k);
%                 ring{idx}.PolynomB(k) = (1 + errors(i)) * ring{idx}.PolynomB(k);
%             end
        elseif (isfield(ring{idx}, 'KickAngle'))
            ring{idx}.KickAngle = (1 + errors(i)) * ring{idx}.KickAngle;
        elseif (isfield(ring{idx}, 'PolynomB'))
            for k=1:length(ring{idx}.PolynomA)
                ring{idx}.PolynomA(k) = (1 + errors(i)) * ring{idx}.PolynomA(k);
                ring{idx}.PolynomB(k) = (1 + errors(i)) * ring{idx}.PolynomB(k);
            end
        end
% O campo 'K' conterá o gradiente original (de design)
% com isto será possível com o mesmo modelo AT calcular a ótica nominal e a perturbada mudando-se os passmethods pois
% 'BendLinearPass', 'QuadLinearPass' não usam 'PolynomA' e 'PolynomB'.
%
%         if isfield(new_ring{idx}, 'K')
%             ring{idx}.K = (1 + errors(i)) * ring{idx}.K;
%         end
    end
end
