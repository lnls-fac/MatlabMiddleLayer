function epu = lnls1_epu_create_interpolated_model


% carrega dados do campo medido e modelos calibrados
pathstr  = fileparts(mfilename('fullpath'));
filename = fullfile(pathstr, 'aux scripts', 'EPU_FIELD_DATA.mat');
addpath(fullfile(pathstr, 'aux scripts'));
if exist(filename, 'file')
    load(filename);
else
    epu = lnls1_epu_calibrate_model;
end


phase_gap = [];
phase_phase = [];
phase_mags = [];
cphase_gap = [];
cphase_phase = [];
cphase_mags = [];
for i=1:length(epu.data)
    pcsd = epu.data(i).phase_csd;
    pcie = epu.data(i).phase_cie;
    gapu = epu.data(i).gap_upstream;
    gapd = epu.data(i).gap_downstream;
    [gap phase counter_phase] = lnls1_epu_project_configuration(gapu, gapd, pcsd, pcie);
    if abs(phase) >= abs(counter_phase)
        phase_gap    = [phase_gap gap];
        phase_phase  = [phase_phase phase];
        phase_mags   = [phase_mags epu.data(i).calibration.mags];
    end
    if abs(phase) <= abs(counter_phase)
        cphase_gap   = [cphase_gap gap];
        cphase_phase = [cphase_phase counter_phase];
        cphase_mags  = [cphase_mags epu.data(i).calibration.mags];
    end
end

% extrapaloções necessárias
% (particulares ao AON11)
e_phase_gap = [];
e_phase_phase = [];
e_phase_mags = [];
e_cphase_gap = [];
e_cphase_phase = [];
e_cphase_mags = [];

% GAP = 300 MM, PHASE -25 MM
e_phase_gap   = [e_phase_gap 300];
e_phase_phase = [e_phase_phase -25];
e_phase_mags  = [e_phase_mags zeros(size(epu.data(1).calibration.mags))];

% GAP = 300 MM, PHASE +25 MM
e_phase_gap   = [e_phase_gap 300];
e_phase_phase = [e_phase_phase 25];
e_phase_mags  = [e_phase_mags zeros(size(epu.data(1).calibration.mags))];

% GAP = 300 MM, CPHASE -25 MM
e_cphase_gap   = [e_cphase_gap 300];
e_cphase_phase = [e_cphase_phase -25];
e_cphase_mags  = [e_cphase_mags zeros(size(epu.data(1).calibration.mags))];

% GAP = 300 MM, CPHASE +25 MM
e_cphase_gap   = [e_cphase_gap 300];
e_cphase_phase = [e_cphase_phase 25];
e_cphase_mags  = [e_cphase_mags zeros(size(epu.data(1).calibration.mags))];

% GAP = 22 MM, CPHASE -25 MM
target_point = [22; -25];
diff = [cphase_gap(:)'; cphase_phase(:)'] - repmat(target_point, 1, length(cphase_gap));
diff = diff ./ repmat([300-22; 25-(-25)], 1, length(cphase_gap));
[~, idx] = min(sum(diff.^2));
e_cphase_gap   = [e_cphase_gap target_point(1)];
e_cphase_phase = [e_cphase_phase target_point(2)];
e_cphase_mags  = [e_cphase_mags cphase_mags(:,idx)];

% GAP = 22 MM, CPHASE +25 MM
target_point = [22; 25];
diff = [cphase_gap(:)'; cphase_phase(:)'] - repmat(target_point, 1, length(cphase_gap));
diff = diff ./ repmat([300-22; 25-(-25)], 1, length(cphase_gap));
[~, idx] = min(sum(diff.^2));
e_cphase_gap   = [e_cphase_gap target_point(1)];
e_cphase_phase = [e_cphase_phase target_point(2)];
e_cphase_mags  = [e_cphase_mags cphase_mags(:,idx)];

% adicionar configs extrapoladas à lista de todas as configs.
phase_gap   = [phase_gap e_phase_gap];
phase_phase = [phase_phase e_phase_phase];
phase_mags  = [phase_mags e_phase_mags];
cphase_gap   = [cphase_gap e_cphase_gap];
cphase_phase = [cphase_phase e_cphase_phase];
cphase_mags  = [cphase_mags e_cphase_mags];



% cria objetos de interpolação.
for i=1:size(phase_mags,1)
    epu.interpolation.phase_InterpF{i} = TriScatteredInterp(phase_gap', phase_phase', phase_mags(i,:)');
end
for i=1:size(cphase_mags,1)
    epu.interpolation.cphase_InterpF{i} = TriScatteredInterp(cphase_gap', cphase_phase', cphase_mags(i,:)');
end

% grava dados
filename = fullfile(pathstr, 'EPU_INTERPOLATED_FIELD.mat');
save(filename, 'epu');

% coloca estrutura em application data workspace
setappdata(0, 'EPU_INTERPOLATED_FIELD', epu);

