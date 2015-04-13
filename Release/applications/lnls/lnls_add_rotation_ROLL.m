function new_ring = lnls_add_rotation_ROLL(errors, indices, old_ring)

new_ring = old_ring;

C = cos(errors);
S = sin(errors);

for i=1:size(indices,1)
    RM = diag([C(i) C(i) C(i) C(i) 1  1 ]);
    RM(1,3) = S(i);
    RM(2,4) = S(i);
    RM(3,1) = -S(i);
    RM(4,2) = -S(i);
    for j=1:size(indices,2)
        idx = indices(i,j);
        if isfield(new_ring{idx},'BendingAngle') && (new_ring{idx}.BendingAngle~=0) && (new_ring{idx}.Length~=0)
            rho = new_ring{idx}.Length / new_ring{idx}.BendingAngle;
            Sori = new_ring{idx}.PolynomA(1) * rho;
            Cori = new_ring{idx}.PolynomB(1) * rho + 1;               % Ler 'BndMPoleSymplectic4Pass.c'!
            new_ring{idx}.PolynomA(1) = (Sori*C(i) + S(i)*Cori) / rho;         % sin(teta)/rho
            new_ring{idx}.PolynomB(1) = ((Cori*C(i) - Sori*S(i)) - 1) / rho;   % (cos(teta)-1)/rho
        elseif (isfield(new_ring{idx},'R1') == 1); % checa se o campo R1 existe
            new_ring{idx}.R1 = RM * new_ring{idx}.R1;
            new_ring{idx}.R2 = new_ring{idx}.R2 * RM';
        end
%         new_ring{idx}.R1 = RM * new_ring{idx}.R1;
%         new_ring{idx}.R2 = new_ring{idx}.R2 * RM';
    end
end
