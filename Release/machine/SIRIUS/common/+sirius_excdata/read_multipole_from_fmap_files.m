function read_multipole_from_fmap_files(tpath, currs, mag_field, mag_label, serials, loc_folder)

if ~exist('loc_folder', 'var')
    loc_folder = '';
end
rotcoil = getappdata(0, 'rotcoil');
if isempty(rotcoil)
    rotcoil = struct();
end
rotcoil.(mag_field).nmpoles = {};
rotcoil.(mag_field).smpoles = {};
rotcoil.(mag_field).currents = {};
rotcoil.(mag_field).currents = {};
for i=1:length(currs)
    nmp = [];
    smp = [];
    rotcoil.(mag_field).mags = {};
    currents = [];
    for j=1:length(serials)
        rotcoil.(mag_field).mags{end+1} = [mag_label, serials{j}];
        fname = [lower(mag_label), serials{j}, '-', currs{i}];
        magnet = fullfile(tpath, 'models', 'dipoles', loc_folder, fname);
        if strcmpi(mag_label, 'b1-')
            magnet = fullfile(tpath, 'models', 'dipoles-b1', loc_folder, fname);
        elseif strcmpi(mag_label, 'b2-')
            magnet = fullfile(tpath, 'models', 'dipoles-b2', loc_folder, fname);
        end
        [harms, ~, nmpole, smpole, params] = sirius_excdata.load_fmap_model(magnet);
        nmp = [nmp; nmpole];
        smp = [smp; smpole];
        currents = [currents, params.current];
    end
    rotcoil.(mag_field).harms = harms;
    rotcoil.(mag_field).currents{end+1} = currents;
    rotcoil.(mag_field).nmpoles{end+1} = nmp;
    rotcoil.(mag_field).smpoles{end+1} = smp;
end
setappdata(0, 'rotcoil', rotcoil);
