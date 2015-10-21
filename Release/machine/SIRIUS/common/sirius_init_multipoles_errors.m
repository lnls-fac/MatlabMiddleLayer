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

setfamilydata(1, 'SetMultipolesErrors');

Families = getfamilylist;

ModeFlag = getmode(deblank(Families(1,:)));
if strcmpi(ModeFlag, 'Simulator') || strcmpi(ModeFlag,'Model')   
else
    fprintf('\n   WARNING: Multipole errors functions should be used only in simulator mode.\n');
    fprintf('   No change made in the model!\n');
    return
end

fprintf('   Setting initial values of multipoles errors.\n');

for l=1:size(Families, 1)
    Family = deblank(Families(l,:));
    if ismemberof(Family, 'Magnet')
        HardwareValue = getpvmodel(Family, 'Hardware');

        ExcData       = getfamilydata(Family, 'ExcitationCurves');
        Data          = ExcData.multipoles_data;
        MainHarmonic  = ExcData.main_harmonic;
        Harmonics     = ExcData.harmonics;
        Skew          = ExcData.skew; 

        Energy        = getenergy;
        Brho          = getbrho(Energy);
        ElementsIndex = dev2elem(Family);
        ATIndex       = family2atindex(Family);
        EffLength     = getleff(Family); 

        if any(EffLength(:) == 0)
            warning('Multipoles errors not set for %s\n', Family);
        else
            for i=1:size(ATIndex, 1)
                idx = ElementsIndex(i);
                Index = ATIndex(i,:);
                IntegratedFields  = interp1(Data{idx}(:,1), Data{idx}(:,2:length(Data{idx})), HardwareValue(i));          
                THERING = set_errors(THERING, IntegratedFields, Index, Brho, Harmonics{idx}, MainHarmonic{idx}, Skew{idx});
            end          
        end
    end
end

end


function Ring = set_errors(Ring, IntegratedFields, Index, Brho, Harmonics, MainHarmonic, Skew)

Index = squeeze(Index);
Nsplit = length(Index);
nr_harmonics = Harmonics(end);

IntegratedFieldB = zeros(1, nr_harmonics + 1);
IntegratedFieldA = zeros(1, nr_harmonics + 1);
m = 1;
for k=1:length(Harmonics)
    n = Harmonics(k);
    IntegratedFieldB(n+1) = IntegratedFields(m);
    IntegratedFieldA(n+1) = IntegratedFields(m+1);
    m = m+2;
end               

for j=1:Nsplit
    % resize PolynomB and PolynomA 
    LenA = length(IntegratedFieldA) - length(Ring{Index(j)}.PolynomA);
    LenB = length(IntegratedFieldB) - length(Ring{Index(j)}.PolynomB);
    Ring{Index(j)}.PolynomA = [Ring{Index(j)}.PolynomA, zeros(1,LenA)];
    Ring{Index(j)}.PolynomB = [Ring{Index(j)}.PolynomB, zeros(1,LenB)];     
end 

[ProfileA, ProfileB] = get_field_profile(Ring, Index, nr_harmonics);

for j=1:Nsplit
    DeltaPolynomB = ProfileB(j,:).*IntegratedFieldB/(Ring{Index(j)}.Length * Brho);
    DeltaPolynomA = ProfileA(j,:).*IntegratedFieldA/(Ring{Index(j)}.Length * Brho);

    % Don't change the main harmonic value, set only the errors in PolynomA and PolynomB
    if Skew
        DeltaPolynomA(MainHarmonic+1) = 0;
    else
        DeltaPolynomB(MainHarmonic+1) = 0;
    end

    LenA = length(Ring{Index(j)}.PolynomA) - length(DeltaPolynomA); 
    LenB = length(Ring{Index(j)}.PolynomB) - length(DeltaPolynomB);        
    Ring{Index(j)}.PolynomA = Ring{Index(j)}.PolynomA + [DeltaPolynomA, zeros(1,LenA)];   
    Ring{Index(j)}.PolynomB = Ring{Index(j)}.PolynomB + [DeltaPolynomB, zeros(1,LenB)];                      

    LenDiff = length(Ring{Index(j)}.PolynomA) - length(Ring{Index(j)}.PolynomB);
    if LenDiff ~= 0
        Ring{Index(j)}.PolynomA = [Ring{Index(j)}.PolynomA, zeros(1,-LenDiff)];
        Ring{Index(j)}.PolynomB = [Ring{Index(j)}.PolynomB, zeros(1, LenDiff)];
    end

    if isfield(Ring{Index(j)}, 'MaxOrder')
        Ring{Index(j)}.MaxOrder = length(Ring{Index(j)}.PolynomB) - 1;
    end

    if isfield(Ring{Index(j)}, 'K')
        Ring{Index(j)}.K = Ring{Index(j)}.PolynomB(2);
    end
end  

end


function [ProfileA, ProfileB] = get_field_profile(Ring, Index, nr_harmonics)

Nsplit = length(Index);
ProfileA = zeros(Nsplit, nr_harmonics + 1);
ProfileB = zeros(Nsplit, nr_harmonics + 1);
if Nsplit == 1
    ProfileA(:,:) = 1;
    ProfileB(:,:) = 1;
else
    for j=1:Nsplit
        for n = 0:nr_harmonics
            ProfileA(j,n+1) = Ring{Index(j)}.PolynomA(n+1)*Ring{Index(j)}.Length;
            if isfield(Ring{Index(j)}, 'BendingAngle') && n == 0
                ProfileB(j,n+1) = Ring{Index(j)}.PolynomB(n+1)*Ring{Index(j)}.Length + Ring{Index(j)}.BendingAngle;
            else
                ProfileB(j,n+1) = Ring{Index(j)}.PolynomB(n+1)*Ring{Index(j)}.Length;
            end
        end
    end

    for n=0:nr_harmonics
        sumA = sum(ProfileA(:,n+1));
        sumB = sum(ProfileB(:,n+1));
        if sumA ~= 0
            ProfileA(:,n+1) = ProfileA(:,n+1)/sumA;
        else
            ProfileA(:,n+1) = 1/Nsplit;
        end

        if sumB ~= 0 
            ProfileB(:,n+1) = ProfileB(:,n+1)/sumB;
        else
            ProfileB(:,n+1) = 1/Nsplit;
        end            
    end
end

end

