function lnls_setgoldenorbit(bpm_commonname, value_x, value_y)

if isfamily('BPMx')
    FamilyBPMx = 'BPMx';
    FamilyBPMy = 'BPMy';
else
    FamilyBPMx = 'bpmx';
    FamilyBPMy = 'bpmy';
end

DeviceBPMx  = common2dev(bpm_commonname,FamilyBPMx);
DeviceBPMy  = common2dev(bpm_commonname,FamilyBPMy);
ElementBPMx = dev2elem(FamilyBPMx,DeviceBPMx);
ElementBPMy = dev2elem(FamilyBPMy,DeviceBPMy);

if ~isempty(value_x)
    GoldenX = getfamilydata(FamilyBPMx, 'Golden');
    GoldenX(ElementBPMx) = value_x;
    setfamilydata(GoldenX, FamilyBPMx, 'Golden');
end

if exist('value_y', 'var') && ~isempty(value_y)
    GoldenY = getfamilydata(FamilyBPMy, 'Golden');
    GoldenY(ElementBPMy) = value_y;
    setfamilydata(GoldenY, FamilyBPMy, 'Golden');
end
