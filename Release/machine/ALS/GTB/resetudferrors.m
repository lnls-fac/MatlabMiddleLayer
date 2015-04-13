function resetudferrors

fprintf('   Reseting the UDF field on the GTB.\n');

Families = {'HCM','VCM','Q','BEND','SOL'};

for i = 1:length(Families)
    UDF_Local(Families{i}, 'Setpoint');
    UDF_Local(Families{i}, 'Monitor');
   %UDF_Local(Families{i}, 'RampRate');
   %UDF_Local(Families{i}, 'TimeConstant');
    UDF_Local(Families{i}, 'OnControl');
   %UDF_Local(Families{i}, 'Ready');
   %UDF_Local(Families{i}, 'Reset');
end


UDF_Local('Timing', 'Setpoint');
setpv('GTL_____TIMING_BC00.UDF', 0);
setpv('GTL_____TIMING_BC01.UDF', 0);

UDF_Local('AS', 'Setpoint');
UDF_Local('AS', 'LoopControl');


UDF_Local('TV', 'Setpoint');
UDF_Local('TV', 'InControl');

UDF_Local('VVR', 'OpenControl');

UDF_Local('EG', 'Setpoint');

UDF_Local('GTL', 'Setpoint');
UDF_Local('GTL', 'BC');


UDF_Local('TV', 'Setpoint');
UDF_Local('TV', 'Monitor');

UDF_Local('ExtraMachineConfig','Setpoint');
UDF_Local('ExtraControls','Setpoint');
 


function UDF_Local(Family, Field)
try
    ChanName = family2channel(Family, Field);
    if isempty(ChanName);
        return;
    end
    
    for i = 1:size(ChanName, 1)
        if ~isempty(deblank(ChanName(i,:)))
            UDFString(i,:) = '.UDF';
        else
            UDFString(i,:) = '    ';
        end
    end
    ChanName = [ChanName, UDFString];

    setpv(ChanName, 0);
catch
    fprintf('  Error getting the UDF field for %s.%s\n', Family, Field);
end

