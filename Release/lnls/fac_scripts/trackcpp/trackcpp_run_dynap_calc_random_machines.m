function trackcpp_run_dynap_calc_random_machines(default_dir)

% users selects submachine
prompt = {'Submachine (bo/si)', 'dynap_xy (yes/no)', 'dynap_ex (yes/no)', 'dynap_ma (yes/no)'};
bo_defaultanswer = {'si', 'yes', 'yes', 'yes'};
answer = inputdlg(prompt,'Select submachine and trackcpp algorithms to run',1,bo_defaultanswer);
if isempty(answer), return; end;
if strcmpi(answer{1}, 'bo')
    % booster default parm values
    accelerator_defaultanswer = {'0.15', '828', 'on', 'on', 'on'};
    dynap_xy_defaultanswer    = {'5000', '0',     '100', '-0.018','+0.018','30','0','0.006'};
    dynap_ex_defaultanswer    = {'5000', '0.001', '80', '-0.03','+0.03','50','-0.018','0'};
    dynap_ma_defaultanswer    = {'5000', '0.01', '0.001', '0', '49.681', 'pb mb'};
else
    % storage ring default parm values
    accelerator_defaultanswer = {'3.00', '864', 'on', 'on', 'on'};
    dynap_xy_defaultanswer    = {'5000', '0', '120', '-0.012','+0.012','30','0','0.003'}; % to be changed
    dynap_ex_defaultanswer    = {'3500', '0.001', '40', '-0.05','+0.05','55','-0.012','0'}; % to be changed
    dynap_ma_defaultanswer    = {'2000', '0.02', '0.001', '0', '52', 'calc_mom_accep mia mib'};
end

% user defines accelerator
prompt = {'energy[GeV]', 'harmonic_number', 'cavity_state', 'radiation_state', 'vchamber_state'};
acc_answer = inputdlg(prompt,'Specify accelerator parameters', 1, accelerator_defaultanswer);
if isempty(acc_answer), return; end;

% user defines dynap_xy parms, if the case.
if strcmpi(answer{2}, 'yes')
    prompt = {'dynap_xy_nr_turns', 'dynap_xy_de', 'dynap_xy_x_nrpts', 'dynap_xy_x_min[m]', 'dynap_xy_x_max[m]', 'dynap_xy_y_nrpts', 'dynap_xy_y_min[m]', 'dynap_xy_y_max[m]'};
    dynap_xy_answer = inputdlg(prompt,'Specify dynap_xy parameters', 1, dynap_xy_defaultanswer);
    if isempty(dynap_xy_answer), return; end;
else
    dynap_xy_answer = [];
end

% user defines dynap_ex parms, if the case.
if strcmpi(answer{3}, 'yes')
    prompt = {'dynap_ex_nr_turns', 'dynap_ex_y', 'dynap_ex_e_nrpts', 'dynap_ex_e_min[m]', 'dynap_ex_e_max[m]', 'dynap_ex_x_nrpts', 'dynap_ex_x_min[m]', 'dynap_ex_x_max[m]'};
    dynap_ex_answer = inputdlg(prompt,'Specify dynap_ex parameters', 1, dynap_ex_defaultanswer);
    if isempty(dynap_ex_answer), return; end;
else
    dynap_ex_answer = [];
end

% user defines dynap_ma parms, if the case.
if strcmpi(answer{4}, 'yes')
    prompt = {'dynap_ma_nr_turns', 'dynap_ma_e_e0', 'dynap_ma_e_tol', 'dynap_ma_s_min[m]', 'dynap_ma_s_max[m]', 'dynap_ma_fam_names'};
    dynap_ma_answer = inputdlg(prompt,'Specify dynap_ma parameters', 1, dynap_ma_defaultanswer);
    if isempty(dynap_ma_answer), return; end;
else
    dynap_ma_answer = [];
end

% selects input file with random machine
if ~exist('default_dir','var')
    default_dir = fullfile(lnls_get_root_folder(), 'data', 'sirius', answer{1}, 'beam_dynamics');
end
[inpfile,path,~] = uigetfile('*.mat','Select input file with random machines', fullfile(default_dir, '*.mat'));
if isnumeric(inpfile), return; end
machine_fname = fullfile(path, inpfile);
data = load(machine_fname); machine = data.machine;

% creates trackcpp folder, rms subfolders and input.py files
trackcpp_path = fullfile(path, '..', 'trackcpp');
system(['rm -rf ', trackcpp_path]);
system(['mkdir ', trackcpp_path]);

if ~isempty(dynap_xy_answer)
    fh = fopen(fullfile(trackcpp_path, 'runjob_xy.sh'),'w');
    fprintf(fh,'#!/bin/bash\n\nsource ~/.bashrc\n\npytrack.py input_xy.py > run_xy.log');
    fclose(fh); system(['chmod gu+wx ' fullfile(trackcpp_path, 'runjob_xy.sh')]);
end
if ~isempty(dynap_ex_answer)
    fh = fopen(fullfile(trackcpp_path, 'runjob_ex.sh'),'w');
    fprintf(fh,'#!/bin/bash\n\nsource ~/.bashrc\n\npytrack.py input_ex.py > run_ex.log');
    fclose(fh); system(['chmod gu+wx ' fullfile(trackcpp_path, 'runjob_ex.sh')]);
end
if ~isempty(dynap_ma_answer)
    fh = fopen(fullfile(trackcpp_path, 'runjob_ma.sh'),'w');
    fprintf(fh,'#!/bin/bash\n\nsource ~/.bashrc\n\npytrack.py input_ma.py > run_ma.log');
    fclose(fh); system(['chmod gu+wx ' fullfile(trackcpp_path, 'runjob_ma.sh')]);
end

for i=1:length(machine)
    rmsdir = fullfile(trackcpp_path, num2str(i, 'rms%02i'));
    fprintf('creating %s ...\n', rmsdir);
    system(['mkdir ', rmsdir]); 
    flatfilename =  'flatfile.txt';
    if ~isempty(dynap_xy_answer)
        inputfilename = fullfile(rmsdir, 'input_xy.py');
        create_pytrack_input_daxy(inputfilename, flatfilename, acc_answer, dynap_xy_answer);
    end
    if ~isempty(dynap_ex_answer)
        inputfilename = fullfile(rmsdir, 'input_ex.py');
        create_pytrack_input_daex(inputfilename, flatfilename, acc_answer, dynap_ex_answer);
    end
    if ~isempty(dynap_ma_answer)
        inputfilename = fullfile(rmsdir, 'input_ma.py');
        create_pytrack_input_ma(inputfilename, flatfilename, acc_answer, dynap_ma_answer);
    end
    lnls_at2flatfile(machine{i}, fullfile(rmsdir, flatfilename));
    lnls_twiss_save2file(machine{i}, fullfile(rmsdir, 'twiss.txt')); % saves twiss into file (used to calculate IBS)
end

% submit jobs
prompt = {'Description', 'possible hosts', 'extra input files','Priority - XY','Priority - MA','Priority - EX'};
comment = strrep(trackcpp_path, '/home/fac_files/data/','');
comment = strrep(comment, '/beam_dynamics',''); 
comment = strrep(comment, 'cod_matlab/../trackcpp','');
defaultanswer = {comment, 'all', '','1','2','0'};
answer = inputdlg(prompt,'Parameters for pyjob submission',1,defaultanswer);
if isempty(answer), return; end;
if ~isempty(answer{3}), answer{3} = [',',answer{3}]; end

if ~isempty(dynap_xy_answer)
    trackcpp_submit_jobs(['XY: ',answer{1}],trackcpp_path,['input_xy.py',answer{3}],...
                                '../runjob_xy.sh',answer{2},answer{4});
end
if ~isempty(dynap_ma_answer)
    trackcpp_submit_jobs(['MA: ',answer{1}],trackcpp_path,['input_ma.py',answer{3}],...
                                '../runjob_ma.sh',answer{2},answer{5});
end
if ~isempty(dynap_ex_answer)
    trackcpp_submit_jobs(['EX: ',answer{1}],trackcpp_path,['input_ex.py',answer{3}],...
                                '../runjob_ex.sh',answer{2},answer{6});
end


function create_pytrack_input_daxy(inputfilename, flatfilename, acc_answer, dynap_xy_answer)

accelerator_energy = str2double(acc_answer{1});
accelerator_harmonic_number = round(str2double(acc_answer{2}));
accelerator_cavity_state = acc_answer{3};
accelerator_radiation_state = acc_answer{4};
accelerator_vchamber_state = acc_answer{5};

fp = fopen(inputfilename, 'w');
fprintf(fp, 'ebeam_energy    = %f * 1e9\n',   accelerator_energy);
fprintf(fp, 'harmonic_number = %i\n',   accelerator_harmonic_number);
fprintf(fp, 'cavity_state    = "%s"\n', accelerator_cavity_state);
fprintf(fp, 'radiation_state = "%s"\n', accelerator_radiation_state);
fprintf(fp, 'vchamber_state  = "%s"\n', accelerator_vchamber_state);
fprintf(fp, '\n');
fprintf(fp, 'flat_filename   = "%s"\n', flatfilename);
fprintf(fp, '\n');

dynap_xy_nr_turns = round(str2double(dynap_xy_answer{1}));
dynap_xy_de = str2double(dynap_xy_answer{2});
dynap_xy_x_nrpts = round(str2double(dynap_xy_answer{3}));
dynap_xy_x_min = str2double(dynap_xy_answer{4});
dynap_xy_x_max = str2double(dynap_xy_answer{5});
dynap_xy_y_nrpts = round(str2double(dynap_xy_answer{6}));
dynap_xy_y_min = str2double(dynap_xy_answer{7});
dynap_xy_y_max = str2double(dynap_xy_answer{8});
fprintf(fp, 'dynap_xy_run          = True\n');
fprintf(fp, 'dynap_xy_flatfilename = flat_filename\n');
fprintf(fp, 'dynap_xy_de           = %f\n',   dynap_xy_de);
fprintf(fp, 'dynap_xy_nr_turns     = %i\n',   dynap_xy_nr_turns);
fprintf(fp, 'dynap_xy_x_nrpts      = %i\n',   dynap_xy_x_nrpts);
fprintf(fp, 'dynap_xy_x_min        = %f\n',   dynap_xy_x_min);
fprintf(fp, 'dynap_xy_x_max        = %f\n',   dynap_xy_x_max);
fprintf(fp, 'dynap_xy_y_nrpts      = %i\n',   dynap_xy_y_nrpts);
fprintf(fp, 'dynap_xy_y_min        = %f\n',   dynap_xy_y_min);
fprintf(fp, 'dynap_xy_y_max        = %f\n',   dynap_xy_y_max);
fprintf(fp, '\n');

fclose(fp);

function create_pytrack_input_daex(inputfilename, flatfilename, acc_answer, dynap_ex_answer)

accelerator_energy = str2double(acc_answer{1});
accelerator_harmonic_number = round(str2double(acc_answer{2}));
accelerator_cavity_state = acc_answer{3};
accelerator_radiation_state = acc_answer{4};
accelerator_vchamber_state = acc_answer{5};

fp = fopen(inputfilename, 'w');
fprintf(fp, 'ebeam_energy    = %f * 1e9\n',   accelerator_energy);
fprintf(fp, 'harmonic_number = %i\n',   accelerator_harmonic_number);
fprintf(fp, 'cavity_state    = "%s"\n', accelerator_cavity_state);
fprintf(fp, 'radiation_state = "%s"\n', accelerator_radiation_state);
fprintf(fp, 'vchamber_state  = "%s"\n', accelerator_vchamber_state);
fprintf(fp, '\n');
fprintf(fp, 'flat_filename   = "%s"\n', flatfilename);
fprintf(fp, '\n');

dynap_ex_nr_turns =round(str2double(dynap_ex_answer{1}));
dynap_ex_y = str2double(dynap_ex_answer{2});
dynap_ex_e_nrpts = round(str2double(dynap_ex_answer{3}));
dynap_ex_e_min = str2double(dynap_ex_answer{4});
dynap_ex_e_max = str2double(dynap_ex_answer{5});
dynap_ex_x_nrpts = round(str2double(dynap_ex_answer{6}));
dynap_ex_x_min = str2double(dynap_ex_answer{7});
dynap_ex_x_max = str2double(dynap_ex_answer{8});
fprintf(fp, 'dynap_ex_run          = True\n');
fprintf(fp, 'dynap_ex_flatfilename = flat_filename\n');
fprintf(fp, 'dynap_ex_y            = %f\n',   dynap_ex_y);
fprintf(fp, 'dynap_ex_nr_turns     = %i\n',   dynap_ex_nr_turns);
fprintf(fp, 'dynap_ex_e_nrpts      = %i\n',   dynap_ex_e_nrpts);
fprintf(fp, 'dynap_ex_e_min        = %f\n',   dynap_ex_e_min);
fprintf(fp, 'dynap_ex_e_max        = %f\n',   dynap_ex_e_max);
fprintf(fp, 'dynap_ex_x_nrpts      = %i\n',   dynap_ex_x_nrpts);
fprintf(fp, 'dynap_ex_x_min        = %f\n',   dynap_ex_x_min);
fprintf(fp, 'dynap_ex_x_max        = %f\n',   dynap_ex_x_max);
fprintf(fp, '\n');

fclose(fp);


function create_pytrack_input_ma(inputfilename, flatfilename, acc_answer, dynap_ma_answer)

accelerator_energy = str2double(acc_answer{1});
accelerator_harmonic_number = round(str2double(acc_answer{2}));
accelerator_cavity_state = acc_answer{3};
accelerator_radiation_state = acc_answer{4};
accelerator_vchamber_state = acc_answer{5};

fp = fopen(inputfilename, 'w');
fprintf(fp, 'ebeam_energy    = %f * 1e9\n',   accelerator_energy);
fprintf(fp, 'harmonic_number = %i\n',   accelerator_harmonic_number);
fprintf(fp, 'cavity_state    = "%s"\n', accelerator_cavity_state);
fprintf(fp, 'radiation_state = "%s"\n', accelerator_radiation_state);
fprintf(fp, 'vchamber_state  = "%s"\n', accelerator_vchamber_state);
fprintf(fp, '\n');
fprintf(fp, 'flat_filename   = "%s"\n', flatfilename);
fprintf(fp, '\n');

dynap_ma_nr_turns =round(str2double(dynap_ma_answer{1}));
dynap_ma_e_e0   = str2double(dynap_ma_answer{2});
dynap_ma_e_tol  = str2double(dynap_ma_answer{3});
dynap_ma_s_min  = str2double(dynap_ma_answer{4});
dynap_ma_s_max  = str2double(dynap_ma_answer{5});
dynap_ma_fam_names = dynap_ma_answer{6};
fams = regexp(dynap_ma_fam_names, ' ', 'split');
dynap_ma_fam_names = ['[', sprintf('"%s",', fams{:}), ']'];
fprintf(fp, 'dynap_ma_run          = True\n');
fprintf(fp, 'dynap_ma_flatfilename = flat_filename\n');
fprintf(fp, 'dynap_ma_nr_turns     = %i\n', dynap_ma_nr_turns);
fprintf(fp, 'dynap_ma_e_e0         = %f\n', dynap_ma_e_e0);
fprintf(fp, 'dynap_ma_e_tol        = %f\n', dynap_ma_e_tol);
fprintf(fp, 'dynap_ma_s_min        = %f\n', dynap_ma_s_min);
fprintf(fp, 'dynap_ma_s_max        = %f\n', dynap_ma_s_max);
fprintf(fp, 'dynap_ma_fam_names    = %s\n', dynap_ma_fam_names);

fclose(fp);

