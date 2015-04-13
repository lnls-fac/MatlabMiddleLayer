function lnls1_loco_analysis
%Faz análise LOCO de medidas de flutuação de BPMs, função dispersão e matriz resposta.
%
%História: 
%
%2010-09-13: comentários iniciais no código.

dir_name = uigetdir('C:\Arq\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Optics\docs', 'Selecione diretório com dados para análise LOCO');
if dir_name==0, return; end

try
    buildlocoinput(dir_name, 1);
catch
    fprintf('Problema ao construir o input do LOCO: arquivos com dados não encontrados no diretório especificado.\n');
    return;
end

OutputFileName = fullfile(dir_name, 'LOCODataFileSLM');
if exist('buildlocofitparameters', 'file')
    buildlocofitparameters(OutputFileName, 2, 0);
else
    fprintf('   buildlocofitparameters.m was not found so the FitParameters variable still needs to be created.\n');
end

[BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck(OutputFileName);


converged = false;
while ~converged
    [LocoModel(end+1), BPMData(end+1), CMData(end+1), FitParameters(end+1), LocoFlags(end+1), RINGData] = loco(LocoMeasData(end), BPMData(end), CMData(end), FitParameters(end), LocoFlags(end), RINGData(end));
    %semilogy([LocoModel(:).ChiSquare], '-o', 'MarkerFaceColor', 'b');
    %pause(0);
    %drawnow;
    if abs(100*(LocoModel(end).ChiSquare - LocoModel(end-1).ChiSquare)/LocoModel(end).ChiSquare) < 0.01
        converged = true;
    end
end


save(OutputFileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');

loco_data_fname = fullfile('C:\Arq\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Optics', 'loco_data.mat');
try 
    load(loco_data_fname);
catch
end


data.time_stamp = strrep(dir_name, 'C:\Arq\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Optics\','');
data.ChiSquare = LocoModel(end).ChiSquare;
data.HBPMGain = BPMData(end).HBPMGain;
data.VBPMGain = BPMData(end).VBPMGain;
data.HBPMCoupling = BPMData(end).HBPMCoupling;
data.VBPMCoupling = BPMData(end).VBPMCoupling;
data.QF  = FitParameters(end).Values(1:12);
data.QD  = FitParameters(end).Values(13:24);
data.QFC = FitParameters(end).Values(25:36);
data.HCMGain = CMData(end).HCMKicks ./ CMData(1).HCMKicks;
data.VCMGain = CMData(end).VCMKicks ./ CMData(1).VCMKicks;

if exist('loco_data', 'var')
    is_match = false;
    for i=1:length(loco_data)
        is_match = is_match || strcmpi(data.time_stamp, loco_data(i).time_stamp);
        if is_match, break; end
    end
    if is_match,
        loco_data(i) = data;
    else
        loco_data(end+1) = data;
    end
else
    loco_data = data; 
end

save(loco_data_fname, 'loco_data');
assignin('base', 'loco_data', loco_data);

loco_data_fname = strrep(loco_data_fname, '.mat', '.txt');

fp = fopen(loco_data_fname, 'w');
fprintf(fp, 'DATA\tHORA\t');
pvs = family2common('BPMx');
for i=1:size(pvs,1);
    fprintf(fp, 'HGAIN_%s\t', pvs(i,:));
end
for i=1:size(pvs,1);
    fprintf(fp, 'VGAIN_%s\t', pvs(i,:));
end
for i=1:size(pvs,1);
    fprintf(fp, 'HCOUP_%s\t', pvs(i,:));
end
for i=1:size(pvs,1);
    fprintf(fp, 'VCOUP_%s\t', pvs(i,:));
end
pvs = family2common('HCM');
for i=1:size(pvs,1);
    fprintf(fp, 'GAIN_%s\t', pvs(i,:));
end
pvs = family2common('VCM');
for i=1:size(pvs,1);
    fprintf(fp, 'GAIN_%s\t', pvs(i,:));
end
pvs = family2common('QF');
for i=1:size(pvs,1);
    fprintf(fp, 'K_%s\t', pvs(i,:));
end
pvs = family2common('QD');
for i=1:size(pvs,1);
    fprintf(fp, 'K_%s\t', pvs(i,:));
end
pvs = family2common('QFC');
for i=1:size(pvs,1);
    fprintf(fp, 'K_%s\t', pvs(i,:));
end
fprintf(fp, '\r\n');


for j=1:length(loco_data)

    data = loco_data(j);
    
    %fprintf(fp, '%s\t', data.time_stamp);
    dn = datenum(data.time_stamp, 'yyyy-mm-dd_HH-MM-SS');
    ts = datestr(dn, 'dd/mm/yyyy HH:MM:SS');
    fprintf(fp, '%s\t', ts);
    
    for i=1:length(data.HBPMGain)
        fprintf(fp, '%f\t', data.HBPMGain(i));
    end
    for i=1:length(data.VBPMGain)
        fprintf(fp, '%f\t', data.VBPMGain(i));
    end
    for i=1:length(data.HBPMCoupling)
        fprintf(fp, '%f\t', data.HBPMCoupling(i));
    end
    for i=1:length(data.VBPMCoupling)
        fprintf(fp, '%f\t', data.VBPMCoupling(i));
    end
    for i=1:length(data.HCMGain)
        fprintf(fp, '%f\t', data.HCMGain(i));
    end
    for i=1:length(data.VCMGain)
        fprintf(fp, '%f\t', data.VCMGain(i));
    end
    for i=1:length(data.QF)
        fprintf(fp, '%f\t', data.QF(i));
    end
    for i=1:length(data.QD)
        fprintf(fp, '%f\t', data.QD(i));
    end
    for i=1:length(data.QFC)
        fprintf(fp, '%f\t', data.QFC(i));
    end
    fprintf(fp, '\r\n');
        
end
     
fclose(fp);







