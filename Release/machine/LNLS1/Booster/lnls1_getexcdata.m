function ExcData = lnls1_getexcdata(CommonNames, CorrectionFactor)

AD = getad;

for i=1:length(CommonNames(:,1))
    try
        data = importdata([AD.Directory.ExcDataDir, filesep, deblank(CommonNames(i,:)), '.TXT'], ' ', 2);
        ExcData.data{i} = data.data;
        ExcData.colheaders{i} = data.colheaders;
    catch
        data = importdata([AD.Directory.ExcDataDir, filesep, deblank(CommonNames(i,:)), '.TXT'], '\t', 2);
        ExcData.data{i} = data.data;
        ExcData.colheaders{i} = data.colheaders;
    end   
    ExcData.data{i}(:,2) = ExcData.data{i}(:,2) * CorrectionFactor;
end
end
