function read_multipole_files(tpath, currs, mag_field, mag_type, mag_label) 

rotcoil = getappdata(0, 'rotcoil');
if isempty(rotcoil)
    rotcoil = struct();
end
rotcoil.(mag_field).nmpoles = {};
rotcoil.(mag_field).smpoles = {};
rotcoil.(mag_field).currents = {};
for i=1:length(currs)
    cname = ['MULTIPOLES-', currs{i}, '.txt'];
    fname = fullfile(tpath, 'models', mag_type, cname);
    [rotcoil.(mag_field).harms, rotcoil.(mag_field).mags, curr, nmp, smp] = load_multipoles_file(fname, mag_label);
    rotcoil.(mag_field).currents{end+1} = curr;
    rotcoil.(mag_field).nmpoles{end+1} = nmp;
    rotcoil.(mag_field).smpoles{end+1} = smp;
end
setappdata(0, 'rotcoil', rotcoil);


function [harms, mags, currents, nmpoles, smpoles] = load_multipoles_file(filename, substr)

fp = fopen(filename, 'rt');
text = textscan(fp, '%s', 'Delimiter', '\n');
text = text{1};
mags = {};
currents = [];
nmpoles = [];
smpoles = [];
for i=1:length(text)
    line = text{i};
    if ~isempty(strfind(line, 'harmonics'))
        words = strsplit(line, 'n=0):');
        harms = str2num(words{2});
        n = length(harms);
    elseif ~isempty(strfind(line, substr))
        words = strsplit(line, ' ');
        mags{end+1} = words{1};
        mpoles = str2num(str2mat(words(2:end)));
        currents(end+1) = mpoles(1);
        nmpoles = [nmpoles; currents(end) * mpoles(2:1+n)'];
        smpoles = [smpoles; currents(end) * mpoles(2+n:end)'];
    end
end