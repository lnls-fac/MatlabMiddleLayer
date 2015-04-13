function lnls1_bba_analysis


r.dir_name = fullfile(getfamilydata('Directory', 'DataRoot'), 'Optics');
r.optics_dir = r.dir_name;
r.bpms = family2common('BPMx');
  
% seleciona diretório com dados
r.dir_name = uigetdir(fullfile(r.dir_name, 'docs'), 'Selecione o arquivo com as medidas de BBA');
if r.dir_name==0, return; end
files = dir(r.dir_name);
for i=1:length(files)
    if ~files(i).isdir, continue; end
    if ~isempty(findstr(files(i).name, 'BBA_'))
        r.bba_folder = files(i).name;
        files = dir(fullfile(r.dir_name, r.bba_folder));
        break;
    end
end
if ~isfield(r, 'bba_folder')
    fprintf('Diretório com dados do BBA não encontrado!\n');
    return;
end


r.offset = NaN * ones(size(r.bpms,1), 2);

% loop sobre arquivos com medidas

r.last_time = 0;
for i=1:length(files)
    
    if files(i).isdir, continue; end
    
    file_name = fullfile(r.dir_name, r.bba_folder, files(i).name);
    if files(i).datenum > r.last_time, r.last_time = files(i).datenum; end
    bpm_name = strrep(files(i).name, 'BBA_', '');
    bpm_name = strrep(bpm_name, '_H.dat', '');
    bpm_name = strrep(bpm_name, '_V.dat', '');
    counter = 1;
    while (counter <= size(r.bpms,1))
        if strcmpi(bpm_name, r.bpms(counter,:)), break; end
        counter = counter + 1;
    end
    if counter > size(r.bpms,1), continue; end
    
    
    % le dados
    data = load_bba_diagmaq_file(file_name);
    
    % analisa dados
    data = analyze_bba_data(data);
    
    % mostra resultados
    shows_results(data);  
    % fprintf('%s %i\n', bpm_name, counter);
    
    if data.meas_plane == 'H'
        r.offset(counter,1)   = data.fitting.bpm_at_minimum_rms;
        r.bba_data_x{counter} = data;
    else
        r.offset(counter,2) = data.fitting.bpm_at_minimum_rms;
        r.bba_data_y{counter} = data;
    end
    
   
end

show_global_results(r);
print_results(r);
save_results(r);


%% END OF MAIN FUNCTION


function show_global_results(r)

residue_x = NaN * length(r.bba_data_x);
residue_y = NaN * length(r.bba_data_y);
for i=1:length(r.bba_data_x)
    if ~isempty(r.bba_data_x{i}), residue_x(i) = r.bba_data_x{i}.fitting.residue;  end
    if ~isempty(r.bba_data_y{i}), residue_y(i) = r.bba_data_y{i}.fitting.residue;  end
end

figure('Name', r.bba_folder);
hold all
xlabel('Índice do BPM');
ylabel('Resíduo Normalizado do Fitting parabólico');
plot(residue_x, '-ob', 'MarkerFaceColor', 'b');
plot(residue_y, '-og', 'MarkerFaceColor', 'g');
legend('Horizontal', 'Vertical');  
axis([0 length(residue_x)+1 0 1])
vscale = max(max([residue_x residue_y]));
for i=1:size(r.bpms,1)
    text(i,0.10 * vscale + max([residue_x(i) residue_y(i)]), r.bpms(i,:), 'rotation', 90);
end

figure('Name', r.bba_folder);
hold all
plot(1000*r.offset(:,1), '-ob', 'MarkerFaceColor', 'b');
plot(1000*r.offset(:,2), '-og', 'MarkerFaceColor', 'g');
legend('Horizontal', 'Vertical');  
xlabel('Índice do BPM'); 
vscale = max(max([1000*r.offset(:,1) 1000*r.offset(:,2)]));
for i=1:size(r.bpms,1)
    text(i,0.05 * vscale + max([1000*r.offset(i,1) 1000*r.offset(i,2)]), r.bpms(i,:), 'rotation', 90);
end






function print_results(r)

for i=1:size(r.offset,1)
    try
        fprintf('%sH : %s, novo intervalo de kicks = [%+6.3f,%+6.3f] mrad\n', r.bpms(i,:), r.bba_data_x{i}.corrector_name, r.bba_data_x{i}.fitting.corrector_new_range(1), r.bba_data_x{i}.fitting.corrector_new_range(2));
        fprintf('%sV : %s, novo intervalo de kicks = [%+6.3f,%+6.3f] mrad\n', r.bpms(i,:), r.bba_data_y{i}.corrector_name, r.bba_data_y{i}.fitting.corrector_new_range(1), r.bba_data_y{i}.fitting.corrector_new_range(2));
    catch
    end
end

% imprime resultado no prompt
fprintf('MONITOR   OFFSET-H[mm]    OFFSET-V[mm]\n');
for i=1:size(r.offset,1)
    fprintf('%8s     %6.3f          %6.3f\n', r.bpms(i,:), r.offset(i,1), r.offset(i,2)); 
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


default_fname = fullfile(r.dir_name, ['BPMOffset_' datestr(r.last_time, 'yyyy-mm-dd_HH-MM-SS') '.mat']);
[FileName,PathName,FilterIndex] = uiputfile('*.mat', 'Salvar Dados Do Experimento', default_fname);
if FileName ~= 0, save(fullfile(PathName, FileName), 'r'); end


bba_data_fname = fullfile(r.optics_dir, 'bba_data.mat');
try 
    load(bba_data_fname);
catch
end

data.time_stamp = strrep(r.dir_name, 'C:\Arq\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Optics\','');
data.offsets = r.offset;

if exist('bba_data', 'var')
    is_match = false;
    for i=1:length(bba_data)
        is_match = is_match || strcmpi(data.time_stamp, bba_data(i).time_stamp);
        if is_match, break; end
    end
    if is_match,
        bba_data(i) = data;
    else
        bba_data(end+1) = data;
    end
else
    bba_data = data; 
end

save(bba_data_fname, 'bba_data');
assignin('base', 'bba_data', bba_data);

bba_data_fname = strrep(bba_data_fname, '.mat', '.txt');

fp = fopen(bba_data_fname, 'w');
fprintf(fp, 'DATA\tHORA\t');
pvs = family2common('BPMx');
for i=1:size(pvs,1);
    fprintf(fp, '%sH\t', pvs(i,:));
end
for i=1:size(pvs,1);
    fprintf(fp, '%sV\t', pvs(i,:));
end
fprintf(fp, '\r\n');


for j=1:length(bba_data)
    data = bba_data(j);
    %fprintf(fp, '%s\t', data.time_stamp);
    dn = datenum(data.time_stamp, 'yyyy-mm-dd_HH-MM-SS');
    ts = datestr(dn, 'dd/mm/yyyy HH:MM:SS');
    fprintf(fp, '%s\t', ts);
    for i=1:size(data.offsets,1)
        fprintf(fp, '%f\t', data.offsets(i,1));
    end
    for i=1:size(data.offsets,1)
        fprintf(fp, '%f\t', data.offsets(i,2));
    end
    fprintf(fp, '\r\n');
end
fclose(fp);


kick_range_fname = fullfile(r.dir_name, 'bba_intervalos_kicks.txt');
fp = fopen(kick_range_fname, 'w');
fprintf(fp, '# [DATA: %s] - Janelas de Kicks para medidas de BBA\r\n', datestr(r.last_time, 'yyyy-mm-dd_HH-MM-SS'));
fprintf(fp, '# Formato: NOME_BPM NOME_HCOR HKICKInf[MRAD] HKICKSup[MRAD] NOME_VCOR VKICKInf[MRAD] VKICKSup[MRAD]\r\n');
for i=1:size(r.offset,1)
    fprintf(fp, '%s\t', r.bpms(i,:));
    if isempty(r.bba_data_x{i})
        fprintf(fp, '%s\t%+6.3f\t%+6.3f\t', 'N.D.', 0,0);
        fprintf(fp, '%s\t%+6.3f\t%+6.3f\t', 'N.D.', 0,0);
    else
        fprintf(fp, '%s\t%+6.3f\t%+6.3f\t', r.bba_data_x{i}.corrector_name, r.bba_data_x{i}.fitting.corrector_new_range(1), r.bba_data_x{i}.fitting.corrector_new_range(2));
        fprintf(fp, '%s\t%+6.3f\t%+6.3f\t', r.bba_data_y{i}.corrector_name, r.bba_data_y{i}.fitting.corrector_new_range(1), r.bba_data_y{i}.fitting.corrector_new_range(2));
    end
    fprintf(fp, '\r\n');
end
fclose(fp);



function shows_results(bba_data)

%if (bba_data.fitting.residue < 0.1) && ~bba_data.fitting.extrapolation, return; end

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



function r = load_bba_diagmaq_file(file_name)


DELIMITER = '\t';
HEADERLINES = 15;

% Import the file
data = importdata(file_name, DELIMITER, HEADERLINES);

r.bpm_name       = data.colheaders{3};
r.corrector_name = data.colheaders{1};
r.corrector_ramp = data.data(:,1);
r.orbit_rms      = data.data(:,2);
r.bpm_pos        = data.data(:,3);
r.data           = data;


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



