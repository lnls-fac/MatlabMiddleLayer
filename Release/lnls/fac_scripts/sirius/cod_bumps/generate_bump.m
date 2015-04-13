function generate_bump

OCS0 = load('OCS.mat'); OCS0 = OCS0.OCS;

[DeviceList, Family, ErrorFlag] = common2dev('bpm_s_04_b', 'bpmx');
bpm1 = dev2elem('bpmx', DeviceList);
[DeviceList, Family, ErrorFlag] = common2dev('bpm_s_04_c', 'bpmx');
bpm2 = dev2elem('bpmx', DeviceList);
pos = getfamilydata('bpmx','Position');
pos1 = pos(bpm1); pos2 = pos(bpm2);
if pos2 < pos1
    distance = (getcircumference - pos1) + pos2;
else
    distance = pos2 - pos1;
end

setpv('hcm',0);
setpv('vcm',0);

bump0 = 1:15;

%OCS.Display = false;
OCS0.NIter   = 3;


%OCS.BPM{1}.Status = false(length(OCS.BPM{1}.Status),1);
%OCS.BPM{1}.Status(bpm1) = true;
%OCS.BPM{1}.Status(bpm2) = true;


%OCS.BPM{1}.Status(bpm1-1) = false;
%OCS.BPM{1}.Status(bpm2+1) = false;

for i=1:length(bump0)
    OCS0.GoalOrbit{1}(bpm1) = bump0(i);
    OCS0.GoalOrbit{1}(bpm2) = bump0(i); 
    OCS = build_ocs(OCS0, bpm1, bpm2, [-9 -10 -8 -7 -6 -5 -4 -3 -2 -1 1 2 3 4 5 6 7 8 9 10]);
    setorbit(OCS);
    x = getx;
    bump1(i) = 0.5 * (x(bpm1) + x(bpm2));
    angle(i) = (x(bpm2) - x(bpm1)) / distance;
    x([bpm1 bpm2]) = 0;
    rms(i) = sqrt(sum(x.^2)/(length(x)-2));
end
    

function OCS = build_ocs(OCS0, bpm1, bpm2, list)

OCS = OCS0;
ups = bpm1 + list(list < 0);
dws = bpm2 + list(list > 0);
exc = [ups(:); dws(:)];
OCS.BPM{1}.DeviceList(exc,:) = [];
OCS.BPM{1}.Status(exc,:) = [];
OCS.BPM{1}.Data(exc) = [];
OCS.GoalOrbit{1}(exc) = [];
