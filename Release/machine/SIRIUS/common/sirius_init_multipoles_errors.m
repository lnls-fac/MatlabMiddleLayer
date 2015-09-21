function sirius_init_multipoles_errors
%SIRIUS_INIT_MULTIPOLES_ERRORS - Set initial values of the multipoles errors in AT model 
%
%2015-09-03

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

Families = getfamilylist;

for i=1:size(Families, 1)
    Family = deblank(Families(i,:));
    if ismemberof(Family, 'Magnet')
        HardwareValue = getpvmodel(Family, 'Hardware');

        ExcData       = getfamilydata(Family, 'ExcitationCurves');
        Data          = ExcData.multipoles_data;
        MainHarmonic  = ExcData.main_harmonic;
        Harmonics     = ExcData.harmonics;

        Energy        = getenergy;
        Brho          = getbrho(Energy);
        ElementsIndex = dev2elem(Family);
        ATIndex       = family2atindex(Family);
        Nsplit        = size(ATIndex,2);
        EffLength     = getleff(Family); 

        if any(EffLength(:) == 0)
            warning('Multipoles errors not set for %s\n', Family);
        else
            for i=1:size(ATIndex, 1)
                idx = ElementsIndex(i);

                IntegratedFields  = interp1(Data{idx}(:,1), Data{idx}(:, 2:length(Data{idx})), HardwareValue(i));

                DeltaPolynomA = zeros(1, Harmonics{idx}(length(Harmonics{idx})));
                DeltaPolynomB = zeros(1, Harmonics{idx}(length(Harmonics{idx})));
                j = 1;
                for k=1:length(Harmonics{idx})
                    n = Harmonics{idx}(k);
                    DeltaPolynomB(n) = IntegratedFields(j)/(EffLength(i) * Brho);
                    DeltaPolynomA(n) = IntegratedFields(j+1)/(EffLength(i) * Brho);
                    j = j+2;
                end

                for j=1:Nsplit

                    % Don't change the main harmonic value, set only the errors in PolynomA and PolynomB
                    if ExcData.skew{idx} 
                        DeltaPolynomA(MainHarmonic{idx}) = 0;
                    else
                        DeltaPolynomB(MainHarmonic{idx}) = 0;
                    end

                    LenA= length(THERING{ATIndex(i,j)}.PolynomA) - length(DeltaPolynomA);
                    THERING{ATIndex(i,j)}.PolynomA = [THERING{ATIndex(i,j)}.PolynomA, zeros(1,-LenA)] + [DeltaPolynomA, zeros(1,LenA)];

                    LenB = length(THERING{ATIndex(i,j)}.PolynomB) - length(DeltaPolynomB);
                    THERING{ATIndex(i,j)}.PolynomB = [THERING{ATIndex(i,j)}.PolynomB, zeros(1,-LenB)] + [DeltaPolynomB, zeros(1,LenB)];     

                    LenDiff = length(THERING{ATIndex(i,j)}.PolynomA) - length(THERING{ATIndex(i,j)}.PolynomB);
                    if LenDiff ~= 0
                        THERING{ATIndex(i,j)}.PolynomA = [THERING{ATIndex(i,j)}.PolynomA, zeros(1,-LenDiff)];
                        THERING{ATIndex(i,j)}.PolynomB = [THERING{ATIndex(i,j)}.PolynomB, zeros(1, LenDiff)];
                    end

                    if isfield(THERING{ATIndex(i,j)}, 'K')
                        THERING{ATIndex(i,j)}.K = THERING{ATIndex(i,j)}.PolynomB(2);
                    end

                    if isfield(THERING{ATIndex(i,j)}, 'MaxOrder')
                        THERING{ATIndex(i,j)}.MaxOrder = length(THERING{ATIndex(i,j)}.PolynomB) - 1;
                    end

                end     

            end
        end
    end
end

end



