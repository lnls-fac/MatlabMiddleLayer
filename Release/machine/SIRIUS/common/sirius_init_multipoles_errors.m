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

for l=1:size(Families, 1)
    Family = deblank(Families(l,:));
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

                IntegratedFields  = interp1(Data{idx}(:,1), Data{idx}(:,2:length(Data{idx})), HardwareValue(i));
                
                nr_harmonics = Harmonics{idx}(end);
                IntegratedFieldB = zeros(1, nr_harmonics + 1);
                IntegratedFieldA = zeros(1, nr_harmonics + 1);
                m = 1;
                for k=1:length(Harmonics{idx})
                    n = Harmonics{idx}(k);
                    IntegratedFieldB(n+1) = IntegratedFields(m);
                    IntegratedFieldA(n+1) = IntegratedFields(m+1);
                    m = m+2;
                end               
                
                for j=1:Nsplit
                    % resize PolynomB and PolynomA 
                    LenA = length(IntegratedFieldA) - length(THERING{ATIndex(i,j)}.PolynomA);
                    LenB = length(IntegratedFieldB) - length(THERING{ATIndex(i,j)}.PolynomB);
                    THERING{ATIndex(i,j)}.PolynomA = [THERING{ATIndex(i,j)}.PolynomA, zeros(1,LenA)];
                    THERING{ATIndex(i,j)}.PolynomB = [THERING{ATIndex(i,j)}.PolynomB, zeros(1,LenB)];     
                end 
                
                ProfileA = zeros(Nsplit, nr_harmonics + 1);
                ProfileB = zeros(Nsplit, nr_harmonics + 1);
                if Nsplit == 1
                    ProfileA(:,:) = 1;
                    ProfileB(:,:) = 1;
                else
                    for j=1:Nsplit
                        for n = 0:nr_harmonics
                            ProfileA(j,n+1) = THERING{ATIndex(i,j)}.PolynomA(n+1)*THERING{ATIndex(i,j)}.Length;
                            if isfield(THERING{ATIndex(i,j)}, 'BendingAngle')
                                ProfileB(j,n+1) = THERING{ATIndex(i,j)}.PolynomB(n+1)*THERING{ATIndex(i,j)}.Length + THERING{ATIndex(i,j)}.BendingAngle;
                            else
                                ProfileB(j,n+1) = THERING{ATIndex(i,j)}.PolynomB(n+1)*THERING{ATIndex(i,j)}.Length;
                            end
                        end
                    end

                    for n=0:nr_harmonics
                        if any(find(ProfileA(:,n+1)))
                            ProfileA(:,n+1) = ProfileA(:,n+1)/sum(ProfileA(:,n+1));
                        else
                            ProfileA(:,n+1) = 1/Nsplit;
                        end

                        if any(find(ProfileB(:,n+1)))
                            ProfileB(:,n+1) = ProfileB(:,n+1)/sum(ProfileB(:,n+1));
                        else
                            ProfileB(:,n+1) = 1/Nsplit;
                        end            
                    end
                end
                
                for j=1:Nsplit
                    DeltaPolynomB = ProfileB(j,:).*IntegratedFieldB/(THERING{ATIndex(i,j)}.Length * Brho);
                    DeltaPolynomA = ProfileA(j,:).*IntegratedFieldA/(THERING{ATIndex(i,j)}.Length * Brho);
                    
                    % Don't change the main harmonic value, set only the errors in PolynomA and PolynomB
                    if ExcData.skew{idx} 
                        DeltaPolynomA(MainHarmonic{idx}+1) = 0;
                    else
                        DeltaPolynomB(MainHarmonic{idx}+1) = 0;
                    end
                    
                    LenA = length(THERING{ATIndex(i,j)}.PolynomA) - length(DeltaPolynomA); 
                    LenB = length(THERING{ATIndex(i,j)}.PolynomB) - length(DeltaPolynomB);        
                    THERING{ATIndex(i,j)}.PolynomA = THERING{ATIndex(i,j)}.PolynomA + [DeltaPolynomA, zeros(1,LenA)];   
                    THERING{ATIndex(i,j)}.PolynomB = THERING{ATIndex(i,j)}.PolynomB + [DeltaPolynomB, zeros(1,LenB)];                
                    
                    LenDiff = length(THERING{ATIndex(i,j)}.PolynomA) - length(THERING{ATIndex(i,j)}.PolynomB);
                    if LenDiff ~= 0
                        THERING{ATIndex(i,j)}.PolynomA = [THERING{ATIndex(i,j)}.PolynomA, zeros(1,-LenDiff)];
                        THERING{ATIndex(i,j)}.PolynomB = [THERING{ATIndex(i,j)}.PolynomB, zeros(1, LenDiff)];
                    end

                    if isfield(THERING{ATIndex(i,j)}, 'MaxOrder')
                        THERING{ATIndex(i,j)}.MaxOrder = length(THERING{ATIndex(i,j)}.PolynomB) - 1;
                    end
                    
                    if isfield(THERING{ATIndex(i,j)}, 'K')
                        THERING{ATIndex(i,j)}.K = THERING{ATIndex(i,j)}.PolynomB(2);
                    end
                end     

            end
        end
    end
end

end



