function new_ring = lnls_add_excitation(errors, indices, old_ring)

% History
%
% 2013-03-15: added support for correctors (KickAngle) - Ximenes.

new_ring = old_ring;


for i=1:size(indices,1)
    for j=1:size(indices,2)
        idx = indices(i,j);
        if isfield(new_ring{idx}, 'BendingAngle') && (new_ring{idx}.BendingAngle ~= 0)
            rho = new_ring{idx}.Length / new_ring{idx}.BendingAngle;
            erro_ori = new_ring{idx}.PolynomB(1);
            new_ring{idx}.PolynomB(1) = erro_ori + errors(i) / rho;    % Ler 'BndMPoleSymplectic4Pass.c'!
%             for k=2:length(new_ring{idx}.PolynomA)
%                 new_ring{idx}.PolynomA(k) = (1 + errors(i)) * new_ring{idx}.PolynomA(k);
%                 new_ring{idx}.PolynomB(k) = (1 + errors(i)) * new_ring{idx}.PolynomB(k);
%             end
        elseif (isfield(new_ring{idx}, 'KickAngle'))
            new_ring{idx}.KickAngle = (1 + errors(i)) * new_ring{idx}.KickAngle;
        elseif (isfield(new_ring{idx}, 'PolynomB'))
            for k=1:length(new_ring{idx}.PolynomA)
                new_ring{idx}.PolynomA(k) = (1 + errors(i)) * new_ring{idx}.PolynomA(k);
                new_ring{idx}.PolynomB(k) = (1 + errors(i)) * new_ring{idx}.PolynomB(k);
            end
        end
% O campo 'K' conterá o gradiente original (de design)
% com isto será possível com o mesmo modelo AT calcular a ótica nominal e a perturbada mudando-se os passmethods pois
% 'BendLinearPass', 'QuadLinearPass' não usam 'PolynomA' e 'PolynomB'.
%
%         if isfield(new_ring{idx}, 'K')
%             new_ring{idx}.K = (1 + errors(i)) * new_ring{idx}.K;
%         end
    end
end
