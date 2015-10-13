function NewRing = sirius_set_multipoles_errors(OldRing, varargin)
%SIRIUS_SET_MULTIPOLES_ERRORS - Set the multipoles errors from excitation curve in PolynomA and PolynomB 
%
%  INPUTS
%  1. THERING
%  2. Family - Family name 
%  3. Field  - Field {Default: 'Setpoint'}
%  4. NewHardwareValue - New setpoint value in hardware units
%  5. DeviceList - [Sector Device #] {Default: whole family}
%
%  OUTPUTS
%  1. THERING 
%
%2015-09-03

Family = '';
Field = '';
NewHardwareValue = [];
DeviceList = [];
if length(varargin) >= 1 && ischar(varargin{1})
    Family = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1 && ischar(varargin{1})
    Field = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1
    NewHardwareValue = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1
    DeviceList = varargin{1};
end
if isempty(Field)
    Field = 'Setpoint';
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end

if size(NewHardwareValue,1) ~= size(DeviceList,1)
    
    if size(NewHardwareValue,1) == 1 && size(NewHardwareValue,2) == 1
        NewHardwareValue = ones(size(DeviceList,1),1) * NewHardwareValue;
    
    elseif size(NewHardwareValue,1) == 1 && size(NewHardwareValue,2) == size(DeviceList,1)
        NewHardwareValue = NewHardwareValue.';
    
    else
        error('Setpoint size must equal the device list size or be a scalar.');
    end
end

NewRing = OldRing;
PrevHardwareValue = getpvmodel(Family, Field, DeviceList, 'Hardware');

ExcData       = getfamilydata(Family, 'ExcitationCurves');
Data          = ExcData.multipoles_data;
MainHarmonic  = ExcData.main_harmonic;
Harmonics     = ExcData.harmonics;

Energy        = getenergy;
Brho          = getbrho(Energy);
ElementsIndex = dev2elem(Family,DeviceList);
ATIndex       = family2atindex(Family, DeviceList);
Nsplit        = size(ATIndex,2);
EffLength     = getleff(Family, DeviceList); 

if any(EffLength(:) == 0)
    warning('Multipoles errors not set for %s\n', Family);
else   
    for i=1:size( ElementsIndex, 1)
        idx = ElementsIndex(i);

        PrevIntegratedFields  = interp1(Data{idx}(:,1), Data{idx}(:, 2:length(Data{idx})), PrevHardwareValue(i));
        NewIntegratedFields   = interp1(Data{idx}(:,1), Data{idx}(:, 2:length(Data{idx})), NewHardwareValue(i));
        DeltaIntegratedFields = NewIntegratedFields - PrevIntegratedFields;

        DeltaIntegratedFieldB = zeros(1, Harmonics{idx}(length(Harmonics{idx})));
        DeltaIntegratedFieldA = zeros(1, Harmonics{idx}(length(Harmonics{idx})));
        m = 1;
        for k=1:length(Harmonics{idx})
            n = Harmonics{idx}(k);
            DeltaIntegratedFieldB(n) = DeltaIntegratedFields(m);
            DeltaIntegratedFieldA(n) = DeltaIntegratedFields(m+1);
            m = m+2;
        end
        
        for j=1:Nsplit
            % resize PolynomB and PolynomA 
            LenA = length(DeltaIntegratedFieldA) - length(NewRing{ATIndex(i,j)}.PolynomA);
            NewRing{ATIndex(i,j)}.PolynomA = [NewRing{ATIndex(i,j)}.PolynomA, zeros(1,LenA)];
            LenB = length(DeltaIntegratedFieldB) - length(NewRing{ATIndex(i,j)}.PolynomB);
            NewRing{ATIndex(i,j)}.PolynomB = [NewRing{ATIndex(i,j)}.PolynomB, zeros(1,LenB)];     
        end 

        nr_harmonics = Harmonics{idx}(length(Harmonics{idx}));
        ProfileA = zeros(Nsplit, nr_harmonics);
        ProfileB = zeros(Nsplit, nr_harmonics);
        if Nsplit == 1
            ProfileA(:,:) = 1;
            ProfileB(:,:) = 1;
        else
            for j=1:Nsplit
                for n=1:nr_harmonics
                    ProfileA(j,n) = NewRing{ATIndex(i,j)}.PolynomA(n)*NewRing{ATIndex(i,j)}.Length;
                    if isfield(NewRing{ATIndex(i,j)}, 'BendingAngle')
                        ProfileB(j,n) = NewRing{ATIndex(i,j)}.PolynomB(n)*NewRing{ATIndex(i,j)}.Length + NewRing{ATIndex(i,j)}.BendingAngle;
                    else
                        ProfileB(j,n) = NewRing{ATIndex(i,j)}.PolynomB(n)*NewRing{ATIndex(i,j)}.Length;
                    end
                end
            end

            for n=1:nr_harmonics
                if any(find(ProfileA(:,n)))
                    ProfileA(:,n) = ProfileA(:,n)/sum(ProfileA(:,n));
                else
                    ProfileA(:,n) = 1/Nsplit;
                end
                
                if any(find(ProfileB(:,n)))
                    ProfileB(:,n) = ProfileB(:,n)/sum(ProfileB(:,n));
                else
                    ProfileB(:,n) = 1/Nsplit;
                end            
            end
        end
                      
        for j=1:Nsplit
            
            DeltaPolynomB = ProfileB(j,:).*DeltaIntegratedFieldB/(NewRing{ATIndex(i,j)}.Length * Brho);
            DeltaPolynomA = ProfileA(j,:).*DeltaIntegratedFieldA/(NewRing{ATIndex(i,j)}.Length * Brho);
            
            % Don't change the main harmonic value, set only the errors in PolynomA and PolynomB
            if ExcData.skew{idx} 
                DeltaPolynomA(MainHarmonic{idx}) = 0;
            else
                DeltaPolynomB(MainHarmonic{idx}) = 0;
            end
            
            LenA = length(NewRing{ATIndex(i,j)}.PolynomA) - length(DeltaPolynomA);
            NewRing{ATIndex(i,j)}.PolynomA = NewRing{ATIndex(i,j)}.PolynomA + [DeltaPolynomA, zeros(1,LenA)];   
            LenB = length(NewRing{ATIndex(i,j)}.PolynomB) - length(DeltaPolynomB);                  
            NewRing{ATIndex(i,j)}.PolynomB = NewRing{ATIndex(i,j)}.PolynomB + [DeltaPolynomB, zeros(1,LenB)];          

            LenDiff = length(NewRing{ATIndex(i,j)}.PolynomA) - length(NewRing{ATIndex(i,j)}.PolynomB);
            if LenDiff ~= 0
                NewRing{ATIndex(i,j)}.PolynomA = [NewRing{ATIndex(i,j)}.PolynomA, zeros(1,-LenDiff)];
                NewRing{ATIndex(i,j)}.PolynomB = [NewRing{ATIndex(i,j)}.PolynomB, zeros(1, LenDiff)];
            end

            if isfield(NewRing{ATIndex(i,j)}, 'K')
                NewRing{ATIndex(i,j)}.K = NewRing{ATIndex(i,j)}.PolynomB(2);
            end

            if isfield(NewRing{ATIndex(i,j)}, 'MaxOrder')
                NewRing{ATIndex(i,j)}.MaxOrder = length(NewRing{ATIndex(i,j)}.PolynomB) - 1;
            end

        end     

    end
end

end



