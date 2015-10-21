function sirius_delete_multipoles_errors

global THERING;

indices = findcells(THERING, 'PolynomB');
for i=1:length(indices)   
    if isfield(THERING{indices(i)}, 'NPB')
        THERING{indices(i)}.PolynomB = THERING{indices(i)}.NPB;
    end
    if isfield(THERING{indices(i)}, 'NPA')
        THERING{indices(i)}.PolynomA = THERING{indices(i)}.NPA;
    end
end

setfamilydata(0, 'SetMultipolesErrors');

end