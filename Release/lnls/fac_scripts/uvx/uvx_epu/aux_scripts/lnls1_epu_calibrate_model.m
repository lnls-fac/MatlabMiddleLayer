function epu_data = lnls1_epu_calibrate_model

fprintf('LNLS1_EPU_CALIBRATE_MODEL\n');
fprintf('=========================\n');

% lê em arquivo medidas do campo do ondulador.
fprintf('reading measured data from files...\n');
lnls1_epu_clear_all_data;
lnls1_epu_read_field_measurements;
lnls1_epu_transf_field_from_bench_to_ring;
epu.data = lnls1_epu_calc_field_parameters;

% cria modelo do EPU
addpath('c:\Arq\MatlabMiddleLayer\Release\lnls\fac_scripts\epu');
remove_epu_data_file;
for i=1:length(epu.data)
    
    fprintf('\n');
    fprintf('Config #%i\n', i);
    fprintf('Gap_upstream  : %f\n', epu.data(i).gap_upstream);
    fprintf('Gap_downstream: %f\n', epu.data(i).gap_upstream);
    fprintf('Phase_CSD     : %f\n', epu.data(i).phase_csd);
    fprintf('Phase_CIE     : %f\n', epu.data(i).phase_cie);
    
    fprintf('creating model...\n');
    epu.data(i).model = epu_create_from_file;
    
    fprintf('setting config...\n');
    epu.data(i).model = epu_set_config(epu.data(i).model, epu.data(i).gap_upstream, epu.data(i).gap_downstream, epu.data(i).phase_csd, epu.data(i).phase_cie);
    
    fprintf('aligning measured data to model...\n');
    epu.data(i) = align_data_with_model(epu.data(i));
    
    fprintf('calibrating model magnetizations...\n');
    epu.data(i).calibration = [];
    epu.data(i) = calibrate_model(epu.data(i));
    
    save_epu_data(epu);
    
end

function remove_epu_data_file

pathstr = fileparts(mfilename('fullpath'));
fname = fullfile(pathstr, 'EPU_FIELD_DATA.mat');
if exist(fname, 'file')
    delete(fname);
end

function save_epu_data(epu)

pathstr = fileparts(mfilename('fullpath'));
fname = fullfile(pathstr, 'EPU_FIELD_DATA.mat');
if exist(fname, 'file')
    save(fname, 'epu', '-append');
else
    save(fname, 'epu');
end

function r = calibrate_model(r0)

r = r0;

% pontos onde modelo e medida serão comparados
allpos = [max([min(r.bx.pos.data) min(r.by.pos.data) min(r.bz.pos.data)]) min([max(r.bx.pos.data) max(r.by.pos.data) max(r.bz.pos.data)])];
posy = min(allpos):r.period/8:max(allpos);
pos = zeros(3,length(posy));
pos(2,:) = posy;
fprintf('points for comparison defined. nrpts:%i,  min:%f[mm],  max:%f[mm]\n', length(posy), min(posy), max(posy));

% interpolação da medida nos pontos escolhidos
field_meas(1,:) = interp1(r.bx.pos.data, r.bx.field.data, posy);
field_meas(2,:) = interp1(r.by.pos.data, r.by.field.data, posy);
field_meas(3,:) = interp1(r.bz.pos.data, r.bz.field.data, posy);
fmeas = field_meas(:);
fprintf('interpolated measured data at comparison points\n');

% cálculo da matriz G
fprintf('calculating G matrix (all blocks independent) ...\n');
r.model = epu_remove_registered_points(r.model);
r.model = epu_set_tags_all_blocks_independent(r.model);
r.model = epu_register_points(r.model, pos);

% cálculo do fator global de normalização
fprintf('calculating overall constant magnetization factor...\n');
tags = epu_get_tags_list(r.model);
mag0 = epu_get_mag(r.model, tags);
rms0 = calc_rms(r.model, field_meas);
fprintf('residual RMS before global magnetization factor: %f Gauss\n', rms0 * 10000);
field_model = epu_field(r.model);
field_model = field_model{1};
fmodel = field_model(:);
factor = (fmeas' * fmodel) / (fmodel' * fmodel);
mag1 = factor * mag0;
r.model = epu_set_mag(r.model, tags, mag1);
rms1 = calc_rms(r.model, field_meas);
fprintf('residual RMS after global magnetization factor: %f Gauss\n', rms1 * 10000);
delta_field = field_meas - field_model;
%plot(posy, delta_field);

% otimização fina
fprintf('fine optimization of magnetizations...\n');
field_model = epu_field(r.model);
field_model = field_model{1};
fmodel = field_model(:);
delta_field = fmeas - fmodel;

fprintf('SVD calculation...\n');
[U S V] = svd(r.model.registered_points{1}.gmatrix, 'econ');
f1 = U' * delta_field;
iS = zeros(size(S));

fprintf('generating cumulative magnetization vector...\n');
vect = zeros(size(V,1),size(S,2));
for i=1:size(S,1)
    iS(i,i) = 1/S(i,i);
    f2 = iS * f1;
    vect(:,i) = V * f2;
    iS(i,i) = 0;
end
mags = cumsum(vect,2);

fprintf('choosing final magnetization vector...\n');
maxvalues = max(abs(mags));
idx = find(maxvalues <= 0.2, 1, 'last');
mag = mag1 + reshape(mags(:,idx), 3, []);
r.model = epu_set_mag(r.model, tags, mag);
field_model = epu_field(r.model);
field_model = field_model{1};
fmodel = field_model(:);
rms2 = calc_rms(r.model, field_meas);
fprintf('residual RMS after fine magnetization optimization: %f Gauss\n', rms2 * 10000);
delta_field = field_meas - field_model;
%plot(posy, delta_field);

r.calibration.posy = posy;
r.calibration.residue_field = delta_field;
r.calibration.rms  = rms2;
r.calibration.mags = mag(:);
r.model = epu_remove_registered_points(r.model);

return;

% otimização das bordas

% cálculo da matriz G
fprintf('calculating G matrix (termination blocks) ...\n');
tmp_rp = r.model.registered_points;
r.model = epu_remove_registered_points(r.model);
r.model = epu_set_tags_termination_blocks(r.model, 300);
r.model = epu_register_points(r.model, pos);


fprintf('SVD calculation...\n');
[U S V] = svd(r.model.registered_points{1}.gmatrix(:,4:end), 'econ');
f1 = U' * delta_field(:);
iS = zeros(size(S));

fprintf('generating cumulative magnetization vector...\n');
vect = zeros(size(V,1),size(S,2));
for i=1:size(S,1)
    iS(i,i) = 1/S(i,i);
    f2 = iS * f1;
    vect(:,i) = V * f2;
    iS(i,i) = 0;
end
mags = cumsum(vect,2);

fprintf('choosing final magnetization vector...\n');
tags = epu_get_tags_list(r.model);
mag0 = epu_get_mag(r.model, tags);
mag0 = mag0(:,2:end);
maxvalues = max(abs(mags));
idx = find(maxvalues <= 0.2, 1, 'last');
mag = mag0 + reshape(mags(:,idx), 3, []);
r.model = epu_set_mag(r.model, tags(2:end), mag);
r.model = epu_set_tags_all_blocks_independent(r.model);
r.model.registered_points = tmp_rp;
field_model = epu_field(r.model);
field_model = field_model{1};
fmodel = field_model(:);
rms3 = calc_rms(r.model, field_meas);
fprintf('residual RMS after fine magnetization optimization: %f Gauss\n', rms3 * 10000);
delta_field = field_meas - field_model;
plot(posy, delta_field);



function rms = calc_rms(epu, field_meas)

field_model = epu_field(epu);
field_model = field_model{1};
delta_field = field_meas - field_model;
rms = sqrt(sum(sum(delta_field .^ 2))/numel(field_meas));


function r = align_data_with_model(r0)

r = r0;

% define pontos para comparação
posy = linspace(-4*r.period,4*r.period, 85);
pos  = zeros(3,length(posy));
pos(2,:) = posy;

% calcula campo do modelo nos pontos
field_model = epu_field(r.model, pos);

shifts = linspace(-r.period/2, r.period/2, 21);
while (shifts(end)-shifts(1)>0.001)
    
    for i=1:length(shifts)
        % interpola campo das medidas
        field_meas(1,:) = interp1(r.bx.pos.data + shifts(i), r.bx.field.data, posy);
        field_meas(2,:) = interp1(r.by.pos.data + shifts(i), r.by.field.data, posy);
        field_meas(3,:) = interp1(r.bz.pos.data + shifts(i), r.bz.field.data, posy);
        delta_field = field_meas - field_model;
        % calcula rms da diferença
        rms(i) = sum(sum(delta_field(r.main_component_idx,:) .^ 2));
        %fprintf('%f  %f\n', shifts(i), rms(i));
    end
    [~, idx] = min(rms);
    delta = (shifts(end)-shifts(1))/(length(shifts)-1);
    shifts = linspace(shifts(idx)-delta,shifts(idx)+delta,length(shifts));
end

% implementa shift
[~, idx] = min(rms);
r.bx.pos.data = r.bx.pos.data + shifts(idx);
r.by.pos.data = r.by.pos.data + shifts(idx);
r.bz.pos.data = r.bz.pos.data + shifts(idx);
r.bx.center = r.bx.center + shifts(idx);
r.by.center = r.by.center + shifts(idx);
r.bz.center = r.bz.center + shifts(idx);





