function NewRing = sirius_setpolynom(OldRing, Family, Field, NewHardwareValue, DeviceList)
%SIRIUS_SETPOLYNOM - Set PolynomA and PolynomB including multipoles errors from excitation curve
%
%2015-09-03

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

Energy        = getenergy;
Brho          = getbrho(Energy);
ElementsIndex = dev2elem(Family,DeviceList);
ATIndexList   = family2atindex(Family, DeviceList);
EffLength     = getleff(Family, DeviceList); 

ExcData       = getfamilydata(Family, 'ExcitationCurves');
Data          = ExcData.multipoles_data;
MainHarmonic  = ExcData.main_harmonic;
Harmonics     = ExcData.harmonics;

for i=1:length(ElementsIndex)
    idx = ElementsIndex(i);
       
    PrevIntegratedFields  = interp1(Data{idx}(:,1), Data{idx}(:, 2:length(Data{idx})), PrevHardwareValue(i));
    NewIntegratedFields   = interp1(Data{idx}(:,1), Data{idx}(:, 2:length(Data{idx})), NewHardwareValue(i));
    DeltaIntegratedFields = NewIntegratedFields - PrevIntegratedFields;
   
    DeltaPolynomA = zeros(1, Harmonics{idx}(length(Harmonics{idx})));
    DeltaPolynomB = zeros(1, Harmonics{idx}(length(Harmonics{idx})));
    j = 1;
    for k=1:length(Harmonics{idx})
        n = Harmonics{idx}(k);
        DeltaPolynomB(n) = DeltaIntegratedFields(j)/(EffLength(i) * Brho);
        DeltaPolynomA(n) = DeltaIntegratedFields(j+1)/(EffLength(i) * Brho);
        j = j+2;
    end
    
    LenA= length(NewRing{ATIndexList(i)}.PolynomA) - length(DeltaPolynomA);
    NewRing{ATIndexList(i)}.PolynomA = [NewRing{ATIndexList(i)}.PolynomA, zeros(1,-LenA)] + [DeltaPolynomA, zeros(1,LenA)];
    LenB = length(NewRing{ATIndexList(i)}.PolynomB) - length(DeltaPolynomB);
    NewRing{ATIndexList(i)}.PolynomB = [NewRing{ATIndexList(i)}.PolynomB, zeros(1,-LenB)] + [DeltaPolynomB, zeros(1,LenB)];     
   
    LenDiff = length(NewRing{ATIndexList(i)}.PolynomA) - length(NewRing{ATIndexList(i)}.PolynomB);
    if LenDiff ~= 0
        NewRing{ATIndexList(i)}.PolynomA = [NewRing{ATIndexList(i)}.PolynomA, zeros(1,-LenDiff)];
        NewRing{ATIndexList(i)}.PolynomB = [NewRing{ATIndexList(i)}.PolynomB, zeros(1, LenDiff)];
    end
    
    if isfield(NewRing{ATIndexList(i)}, 'K')
        NewRing{ATIndexList(i)}.K = NewRing{ATIndexList(i)}.PolynomB(2);
    end
    
    if isfield(NewRing{ATIndexList(i)}, 'MaxOrder')
        NewRing{ATIndexList(i)}.MaxOrder = length(NewRing{ATIndexList(i)}.PolynomB) - 1;
    end
    
    if ExcData.skew{idx}    
        NewRing{ATIndexList(i)}.NPA(MainHarmonic{idx}) = NewRing{ATIndexList(i)}.NPA(MainHarmonic{idx}) + DeltaPolynomA(MainHarmonic{idx});
    else
        NewRing{ATIndexList(i)}.NPB(MainHarmonic{idx}) = NewRing{ATIndexList(i)}.NPB(MainHarmonic{idx}) + DeltaPolynomB(MainHarmonic{idx});
    end
    
end

end
