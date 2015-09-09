function ErrorFlag = lnls1_quadset(FamilyName, Field, AM, DeviceList, WaitFlag)
%LNLS1_QUADGET - Decompose values of magnet excitation of individual quadrupoles into families and shunts power supply values.
%
%Hist�ria
%
%2011-04-05: adicionada linha inicial que vectoriazila vetor AM
%2010-09-13: c�digo fonte com coment�rios iniciais.

AM = AM(:);

QuadElements      = dev2elem(FamilyName, DeviceList);
QuadCommonNames   = family2common(FamilyName);
FamilyChannelNames = family2channel(FamilyName, Field);
[ShuntCommonNames, ErrorFlag] = family2common('QUADSHUNT');

% agrupa quadrupolos que pertencem a mesma familia de fontes (mesmo
% channelname)

% Groups{:}.ChannelName    : channelname que define o grupo
% Groups{:}.FamilyElements : lista com indices na fam�lia dos elementos do grupo 
% Groups{:}.ShuntElements  : lista com indices na fam�lia QUADSHUNT dos elementos do grupo 
% Groups{:}.ShuntOnIdx     : lista com indices dos shunts no grupo que est�o ligados

Groups = {};
ChannelNames = unique(FamilyChannelNames, 'rows');
for i=1:size(ChannelNames,1)
    n = length(Groups);
    ChannelName = ChannelNames(i,:);
    FamilyElements = [];
    ShuntElements = [];
    for j=1:size(FamilyChannelNames,1)
        if strcmpi(FamilyChannelNames(j,:), ChannelName) %&& any(QuadElements == j)
            FamilyElements = [FamilyElements; j];
        end
    end
    for j=1:length(FamilyElements)
        ShuntDevice = common2dev(QuadCommonNames(FamilyElements(j),:), 'QUADSHUNT');
        ShuntElements = [ShuntElements; dev2elem('QUADSHUNT', ShuntDevice)];
    end
        
    Groups{n+1}.ChannelName    = ChannelName;
    Groups{n+1}.FamilyElements = FamilyElements;
    Groups{n+1}.FamilyDevices  = elem2dev(FamilyName, FamilyElements);
    Groups{n+1}.ShuntElements  = ShuntElements;
    Groups{n+1}.ShuntDevices   = elem2dev('QUADSHUNT', ShuntElements);
end

% faz leitura de valores e agrupa 
for i=1:length(Groups)
    Groups{i}.FamilyValue = getpv(Groups{i}.ChannelName);
    ShuntOnOff  = getpv('QUADSHUNT',  'OnOffSP', Groups{i}.ShuntDevices);
    Groups{i}.ShuntOnIdx  = find(~(ShuntOnOff == 0));
    Groups{i}.ShuntValues = getpv('QUADSHUNT', Field, Groups{i}.ShuntDevices);
    Groups{i}.OldValue    = Groups{i}.FamilyValue + Groups{i}.ShuntValues(Groups{i}.ShuntOnIdx);
    Groups{i}.NewValue    = Groups{i}.OldValue;
    for j=1:length(Groups{i}.FamilyElements)
        p = find(Groups{i}.FamilyElements(j) == QuadElements);
        if ~isempty(p), Groups{i}.NewValue(j) = AM(p); end
    end
end

% faz ajustes
for i=1:length(Groups)
    newFamValue   = mean(Groups{i}.NewValue);
    newShuntValue = Groups{i}.NewValue - newFamValue;
    setpv(Groups{i}.ChannelName, newFamValue);
    setpv('QUADSHUNT', Field, newShuntValue, Groups{i}.ShuntDevices);
end

if ~isempty(WaitFlag) && WaitFlag>0,  pause(WaitFlag); end

return;
