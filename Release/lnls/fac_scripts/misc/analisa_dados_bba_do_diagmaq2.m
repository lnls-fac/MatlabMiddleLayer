function r = analisa_dados_bba_do_diagmaq2(varargin)

r.dir_name = 'C:\Arq\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Optics';
r.optics_dir = 'C:\Arq\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Optics';
r.bpms = { ...
    'AMP01B', ...
    'AMP02A', 'AMP02B', 'AMP03A', 'AMP03B', 'AMP03C', ...
    'AMP04A', 'AMP04B', 'AMP05A', 'AMP05B', ...
    'AMP06A', 'AMP06B', 'AMP07A', 'AMP07B', ...
    'AMP08A', 'AMP08B', 'AMP09A', 'AMP09B', ...
    'AMP10A', 'AMP10B', 'AMU11A', ...
    'AMU11B', 'AMP12A', 'AMP12B', ...
    'AMP01A' ...
};
  
% seleciona arquivo com dados
[FileName,r.dir_name,FilterIndex] = uigetfile(r.dir_name, 'Selecione o arquivo com as medidas de BBA do DiagMaq');
if ~r.dir_name, return; end
r.file_name = fullfile(r.dir_name, FileName);
r.offset = NaN * ones(length(r.bpms), 2);
show_global_results(r);
print_results(r);
save_results(r);



function show_global_results(r)

residue_x = NaN * length(r.bba_data_x);
residue_y = NaN * length(r.bba_data_y);
for i=1:length(r.bba_data_x)
    if ~isempty(r.bba_data_x{i}), residue_x(i) = r.bba_data_x{i}.fitting.residue;  end
    if ~isempty(r.bba_data_y{i}), residue_y(i) = r.bba_data_y{i}.fitting.residue;  end
end

figure;
hold all
xlabel('Índice do BPM');
ylabel('Resíduo Normalizado do Fitting parabólico');
plot(residue_x, '-ob', 'MarkerFaceColor', 'b');
plot(residue_y, '-og', 'MarkerFaceColor', 'g');
legend('Horizontal', 'Vertical');  
axis([0 length(residue_x)+1 0 1])
vscale = max(max([residue_x residue_y]));
for i=1:length(r.bpms)
    text(i,0.10 * vscale + max([residue_x(i) residue_y(i)]), r.bpms{i}, 'rotation', 90);
end

figure;
hold all
plot(1000*r.offset(:,1), '-ob', 'MarkerFaceColor', 'b');
plot(1000*r.offset(:,2), '-og', 'MarkerFaceColor', 'g');
legend('Horizontal', 'Vertical');  
xlabel('Índice do BPM'); 
vscale = max(max([1000*r.offset(:,1) 1000*r.offset(:,2)]));
for i=1:length(r.bpms)
    text(i,0.05 * vscale + max([1000*r.offset(i,1) 1000*r.offset(i,2)]), r.bpms{i}, 'rotation', 90);
end

function print_results(r)

for i=1:size(r.offset,1)
    try
        fprintf('%sH : %s, novo intervalo de kicks = [%+6.3f,%+6.3f] mrad\n', r.bpms{i}, r.bba_data_x{i}.corrector_name, r.bba_data_x{i}.fitting.corrector_new_range(1), r.bba_data_x{i}.fitting.corrector_new_range(2));
        fprintf('%sV : %s, novo intervalo de kicks = [%+6.3f,%+6.3f] mrad\n', r.bpms{i}, r.bba_data_y{i}.corrector_name, r.bba_data_y{i}.fitting.corrector_new_range(1), r.bba_data_y{i}.fitting.corrector_new_range(2));
    catch
    end
end

% imprime resultado no prompt
fprintf('MONITOR   OFFSET-H[mm]    OFFSET-V[mm]\n');
for i=1:size(r.offset,1)
    fprintf('%8s     %6.3f          %6.3f\n', r.bpms{i}, r.offset(i,1), r.offset(i,2)); 
end
fprintf('\n');
for i=1:size(r.offset,1)
    fprintf('%f ', 1000*r.offset(i,1));
end
fprintf('\n');
for i=1:size(r.offset,1)
    fprintf('%f ', 1000*r.offset(i,2));
end
fprintf('\n');

function save_results(r)

default_fname = fullfile(r.optics_dir, ['BPMOffset_' datestr(r.last_time, 'yyyy-mm-dd_HH-MM-SS') '.mat']);
[FileName,PathName,FilterIndex] = uiputfile('*.mat', 'Salvar Dados Do Experimento', default_fname);
if FileName == 0, return; end
save(fullfile(PathName, FileName), 'r');

function shows_results(bba_data)

if (bba_data.fitting.residue < 0.1) && ~bba_data.fitting.extrapolation, return; end

figure('Name', [bba_data.bpm_name '_' bba_data.meas_plane]);
xlabel([bba_data.bpm_name ' pos [mm]']);
ylabel('RMS da Órbita [\mum]');

hold on;
x = linspace(bba_data.bpm_pos(1), bba_data.bpm_pos(end), 50);
y = polyval(bba_data.fitting.bpm_polycoeffs, x);
if bba_data.meas_plane == 'H', linestyle = '-b'; else linestyle = '-g'; end
tmpstr = [bba_data.corrector_name ' centrado: [' num2str(bba_data.fitting.corrector_new_range(1), '%+06.3f')  ',' num2str(bba_data.fitting.corrector_new_range(2), '%+06.3f') '] mrad'];
text(min(x) + 0.25 * (max(x) - min(x)), min(1e3*y) + 0.95 * (max(1e3*y) - min(1e3*y)), tmpstr);
plot(x,1e3*y, linestyle);
plot(bba_data.bpm_pos, 1e3*bba_data.orbit_rms, 'ro', 'MarkerEdgeColor', 'k', 'MarkerFaceColor','k');

function r = analyze_bba_data(bba_data)

r = bba_data;

if strcmpi(r.corrector_name(1:3), 'ACH')
    r.meas_plane = 'H';
else
    r.meas_plane = 'V';
end

r.fitting.corrector_polycoeffs = polyfit(r.corrector_ramp, r.orbit_rms, 2);
r.fitting.corrector_at_minimum_rms = - r.fitting.corrector_polycoeffs(2)/(2*r.fitting.corrector_polycoeffs(1));
r.fitting.corrector_new_range = r.corrector_ramp([1 end]) - r.fitting.corrector_at_minimum_rms;

r.fitting.bpm_polycoeffs = polyfit(r.bpm_pos, r.orbit_rms, 2);
r.fitting.bpm_at_minimum_rms = - r.fitting.bpm_polycoeffs(2)/(2*r.fitting.bpm_polycoeffs(1));

vy = polyval(r.fitting.bpm_polycoeffs, r.bpm_pos);
r.fitting.residue = tanh(sqrt(sum((vy - r.orbit_rms).^2)/length(vy)) / sqrt(sum((vy).^2)/length(vy))); 

r.fitting.extrapolation = (r.fitting.corrector_at_minimum_rms <= r.corrector_ramp(1)) || (r.fitting.corrector_at_minimum_rms >= r.corrector_ramp(end));



