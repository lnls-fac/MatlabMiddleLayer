function ring = lnls_add_rotation_ROLL(errors, indices, ring)

C = cos(errors);
S = sin(errors);

% if indices is an 2D-array, transform it into a cellarray of vectors;
if isnumeric(indices)
    indices = mat2cell(indices, ones(1, size(indices,1)));
end

for i=1:length(indices)
    indcs = indices{i};
    RM = diag([C(i) C(i) C(i) C(i) 1  1 ]);
    RM(1,3) = S(i);
    RM(2,4) = S(i);
    RM(3,1) = -S(i);
    RM(4,2) = -S(i);
    for idx=indcs
        if isfield(ring{idx},'BendingAngle') && (ring{idx}.BendingAngle~=0) && (ring{idx}.Length~=0)
            rho = ring{idx}.Length / ring{idx}.BendingAngle;
            Sori = ring{idx}.PolynomA(1) * rho;
            Cori = ring{idx}.PolynomB(1) * rho + 1;               % Ler 'BndMPoleSymplectic4Pass.c'!
            ring{idx}.PolynomA(1) = (Sori*C(i) + S(i)*Cori) / rho;         % sin(teta)/rho
            ring{idx}.PolynomB(1) = ((Cori*C(i) - Sori*S(i)) - 1) / rho;   % (cos(teta)-1)/rho
        elseif (isfield(ring{idx},'R1') == 1)  % checa se o campo R1 existe
            ring{idx}.R1 = RM * ring{idx}.R1;
            ring{idx}.R2 = ring{idx}.R2 * RM';
        end
%         ring{idx}.R1 = RM * ring{idx}.R1;
%         ring{idx}.R2 = ring{idx}.R2 * RM';
    end
end
