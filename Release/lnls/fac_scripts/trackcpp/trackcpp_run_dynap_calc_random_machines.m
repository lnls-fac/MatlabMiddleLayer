function trackcpp_run_dynap_calc_random_machines(path, use_default, inpfile)

if ~exist('use_default','var'), use_default = false; end

% users selects submachine
prompt = {'Submachine (bo/si)', 'dynap_xy (yes/no)', 'dynap_ex (yes/no)', 'dynap_ma (yes/no)',...
          'dynap_pxa (yes/no)', 'dynap_pya (yes/no)'};
gen_answer = {'si', 'yes', 'yes', 'yes', 'no', 'no'};
if ~use_default
    gen_answer = inputdlg(prompt,'Select submachine and trackcpp algorithms to run',1,gen_answer);
end
if isempty(gen_answer), return; end;
dynap_xy  = false; if strcmpi(gen_answer{2}, 'yes'), dynap_xy  = true; end
dynap_ex  = false; if strcmpi(gen_answer{3}, 'yes'), dynap_ex  = true; end
dynap_ma  = false; if strcmpi(gen_answer{4}, 'yes'), dynap_ma  = true; end
dynap_pxa = false; if strcmpi(gen_answer{5}, 'yes'), dynap_pxa = true; end
dynap_pya = false; if strcmpi(gen_answer{6}, 'yes'), dynap_pya = true; end

if strcmpi(gen_answer{1}, 'bo')
    % booster default parm values
    acc_answer = {'0.15', '828', 'on', 'on', 'on'};
    dynap_xy_answer    = {'5000','0',     '100', '-0.018','+0.018','30','0','0.006','1'};
    dynap_ex_answer    = {'5000','0.001', '80', '-0.03','+0.03','50','-0.018','0','1'};
    %                     turns    y0    e0      de   st_bk rescl  nit s0   sf  tr    fams
    dynap_ma_answer    = {'5000','1e-5','0.01','5e-3','1'  ,'0.33','3','0','49.681','1','pb pB physB mb mB'};
    dynap_pxa_answer   = {'5000','1e-5','0.00','1e-4','1'  ,'0.25','3','0','49.681','1','pb pB physB mb mB'};
    dynap_pya_answer   = {'5000','1e-5','0.00','1e-4','1'  ,'0.25','3','0','49.681','1','pb pB physB mb mB'};
else
    % storage ring default parm values
    acc_answer = {'3.00', '864', 'on', 'on', 'on'};
    dynap_xy_answer    = {'5000', '0', '120', '-0.012','+0.012','30','0','0.003','1'}; % to be changed
    dynap_ex_answer    = {'3500', '0.001', '40', '-0.05','+0.05','55','-0.012','0','1'}; % to be changed
    %                     turns    y0    e0      de   st_bk rescl  nit s0   sf  tr    fams
    dynap_ma_answer    = {'2000','1e-5','0.02','5e-3','1'  ,'0.33','3','0','104','1','calc_mom_accep mia mib mip'};
    dynap_pxa_answer   = {'2000','1e-5','0.00','5e-5','1'  ,'0.33','3','0','104','1','calc_mom_accep mia mib mip'};
    dynap_pya_answer   = {'2000','1e-5','0.00','5e-5','1'  ,'0.33','3','0','104','1','calc_mom_accep mia mib mip'};
end

%% user defines accelerator
prompt = {'energy[GeV]', 'harmonic_number', 'cavity_state', 'radiation_state', 'vchamber_state'};
if ~use_default
    acc_answer = inputdlg(prompt,'Specify accelerator parameters', 1, acc_answer);
end
if isempty(acc_answer), return; end;

% user defines dynap_xy parms, if the case.
if dynap_xy
    prompt = {'dynap_xy_nr_turns', 'dynap_xy_de', 'dynap_xy_x_nrpts',...
              'dynap_xy_x_min[m]', 'dynap_xy_x_max[m]', 'dynap_xy_y_nrpts',...
              'dynap_xy_y_min[m]', 'dynap_xy_y_max[m]', 'dynap_xy_nr_threads'};
    if ~use_default
        dynap_xy_answer = inputdlg(prompt,'Specify dynap_xy parameters', 1, dynap_xy_answer);
    end
    if isempty(dynap_xy_answer), return; end;
end

% user defines dynap_ex parms, if the case.
if dynap_ex
    prompt = {'dynap_ex_nr_turns', 'dynap_ex_y', 'dynap_ex_e_nrpts',...
              'dynap_ex_e_min[m]', 'dynap_ex_e_max[m]', 'dynap_ex_x_nrpts',...
              'dynap_ex_x_min[m]', 'dynap_ex_x_max[m]', 'dynap_ex_nr_threads'};
    if ~use_default
        dynap_ex_answer = inputdlg(prompt,'Specify dynap_ex parameters', 1, dynap_ex_answer);
    end
    if isempty(dynap_ex_answer), return; end;
end

% user defines dynap_ma parms, if the case.
if dynap_ma
    prompt = {'dynap_ma_nr_turns','dynap_ma_y0','dynap_ma_e_init','dynap_ma_e_delta', ...
              'dynap_ma_nr_steps_back','dynap_ma_rescale(<1)','dynap_ma_nr_iterations', ...
              'dynap_ma_s_min[m]','dynap_ma_s_max[m]','dynap_ma_nr_threads','dynap_ma_fam_names'};
    if ~use_default
        dynap_ma_answer = inputdlg(prompt,'Specify dynap_ma parameters', 1, dynap_ma_answer);
    end
    if isempty(dynap_ma_answer), return; end;
end

% user defines dynap_pxa parms, if the case.
if dynap_pxa
    prompt = {'dynap_pxa_nr_turns','dynap_pxa_y0','dynap_pxa_px_init','dynap_pxa_px_delta', ...
              'dynap_pxa_nr_steps_back','dynap_pxa_rescale(<1)','dynap_pxa_nr_iterations', ...
              'dynap_pxa_s_min[m]','dynap_pxa_s_max[m]','dynap_pxa_nr_threads','dynap_pxa_fam_names'};
    if ~use_default
        dynap_pxa_answer = inputdlg(prompt,'Specify dynap_pxa parameters', 1, dynap_pxa_answer);
    end
    if isempty(dynap_pxa_answer), return; end;
end

% user defines dynap_pya parms, if the case.
if dynap_pya
    prompt = {'dynap_pya_nr_turns','dynap_pya_y0','dynap_pya_py_init','dynap_pya_py_delta', ...
              'dynap_pya_nr_steps_back','dynap_pya_rescale(<1)','dynap_pya_nr_iterations', ...
              'dynap_pya_s_min[m]','dynap_pya_s_max[m]','dynap_pya_nr_threads','dynap_pya_fam_names'};
    if ~use_default
        dynap_pya_answer = inputdlg(prompt,'Specify dynap_pya parameters', 1, dynap_pya_answer);
    end
    if isempty(dynap_pya_answer), return; end;
end

% selects input file with random machine
if ~exist('path','var')
    path = fullfile(lnls_get_root_folder(), 'data', 'sirius', gen_answer{1}, 'beam_dynamics');
end
if ~use_default
    [inpfile,path,~] = uigetfile('*.mat','Select input file with random machines', fullfile(path, '*.mat'));
end
if isnumeric(inpfile), return; end
machine_fname = fullfile(path, inpfile);
data = load(machine_fname); machine = data.machine;

%% creates trackcpp folder, rms subfolders and input.py files
trackcpp_path = fullfile(path, '..', 'trackcpp');
system(['rm -rf ', trackcpp_path]);
system(['mkdir ', trackcpp_path]);

if dynap_xy
    fh = fopen(fullfile(trackcpp_path, 'runjob_xy.sh'),'w');
    fprintf(fh,'#!/bin/bash\n\nsource ~/.bashrc\n\npytrack.py input_xy.py > run_xy.log');
    fclose(fh); system(['chmod gu+wx ' fullfile(trackcpp_path, 'runjob_xy.sh')]);
end
if dynap_ex
    fh = fopen(fullfile(trackcpp_path, 'runjob_ex.sh'),'w');
    fprintf(fh,'#!/bin/bash\n\nsource ~/.bashrc\n\npytrack.py input_ex.py > run_ex.log');
    fclose(fh); system(['chmod gu+wx ' fullfile(trackcpp_path, 'runjob_ex.sh')]);
end
if dynap_ma
    fh = fopen(fullfile(trackcpp_path, 'runjob_ma.sh'),'w');
    fprintf(fh,'#!/bin/bash\n\nsource ~/.bashrc\n\npytrack.py input_ma.py > run_ma.log');
    fclose(fh); system(['chmod gu+wx ' fullfile(trackcpp_path, 'runjob_ma.sh')]);
end
if dynap_pxa
    fh = fopen(fullfile(trackcpp_path, 'runjob_pxa.sh'),'w');
    fprintf(fh,'#!/bin/bash\n\nsource ~/.bashrc\n\npytrack.py input_pxa.py > run_pxa.log');
    fclose(fh); system(['chmod gu+wx ' fullfile(trackcpp_path, 'runjob_pxa.sh')]);
end
if dynap_pya
    fh = fopen(fullfile(trackcpp_path, 'runjob_pya.sh'),'w');
    fprintf(fh,'#!/bin/bash\n\nsource ~/.bashrc\n\npytrack.py input_pya.py > run_pya.log');
    fclose(fh); system(['chmod gu+wx ' fullfile(trackcpp_path, 'runjob_pya.sh')]);
end


for i=1:length(machine)
    rmsdir = fullfile(trackcpp_path, num2str(i, 'rms%02i'));
    fprintf('creating %s ...\n', rmsdir);
    system(['mkdir ', rmsdir]); 
    flatfilename =  'flatfile.txt';
    if dynap_xy
        inputfilename = fullfile(rmsdir, 'input_xy.py');
        create_pytrack_input_daxy(inputfilename, flatfilename, acc_answer, dynap_xy_answer);
    end
    if dynap_ex
        inputfilename = fullfile(rmsdir, 'input_ex.py');
        create_pytrack_input_daex(inputfilename, flatfilename, acc_answer, dynap_ex_answer);
    end
    if dynap_ma
        inputfilename = fullfile(rmsdir, 'input_ma.py');
        create_pytrack_input_ma(inputfilename, flatfilename, acc_answer, dynap_ma_answer);
    end
    if dynap_pxa
        inputfilename = fullfile(rmsdir, 'input_pxa.py');
        create_pytrack_input_pxa(inputfilename, flatfilename, acc_answer, dynap_pxa_answer);
    end
    if dynap_pya
        inputfilename = fullfile(rmsdir, 'input_pya.py');
        create_pytrack_input_pya(inputfilename, flatfilename, acc_answer, dynap_pya_answer);
    end
    lnls_at2flatfile(machine{i}, fullfile(rmsdir, flatfilename));
    lnls_twiss_save2file(machine{i}, fullfile(rmsdir, 'twiss.txt')); % saves twiss into file (used to calculate IBS)
end

%% submit jobs
prompt = {'Description', 'possible hosts', 'extra input files',...
          'Priority - XY','Priority - MA','Priority - EX','Priority - PXA','Priority - PYA'};
comment = strrep(trackcpp_path, '/home/fac_files/data/','');
comment = strrep(comment, 'sirius/',''); 
comment = strrep(comment, 'beam_dynamics/',''); 
comment = strrep(comment, 'study.',''); 
comment = strrep(comment, '/cod_matlab/../trackcpp','');
comment = strrep(comment, '/','-');
sub_answer = {comment, 'all', '','1','2','0','0','0'};
if ~use_default
    sub_answer = inputdlg(prompt,'Parameters for pyjob submission',1,sub_answer);
end
if isempty(sub_answer), return; end;
if ~isempty(sub_answer{3}), sub_answer{3} = [',',sub_answer{3}]; end

if dynap_xy
    trackcpp_submit_jobs(['XY: ',sub_answer{1}],trackcpp_path,['input_xy.py',sub_answer{3}],...
                                '../runjob_xy.sh',sub_answer{2},sub_answer{4});
end
if dynap_ma
    trackcpp_submit_jobs(['MA: ',sub_answer{1}],trackcpp_path,['input_ma.py',sub_answer{3}],...
                                '../runjob_ma.sh',sub_answer{2},sub_answer{5});
end
if dynap_pxa
    trackcpp_submit_jobs(['PX: ',sub_answer{1}],trackcpp_path,['input_pxa.py',sub_answer{3}],...
                                '../runjob_pxa.sh',sub_answer{2},sub_answer{7});
end
if dynap_pya
    trackcpp_submit_jobs(['PY: ',sub_answer{1}],trackcpp_path,['input_pya.py',sub_answer{3}],...
                                '../runjob_pya.sh',sub_answer{2},sub_answer{8});
end
if dynap_ex
    trackcpp_submit_jobs(['EX: ',sub_answer{1}],trackcpp_path,['input_ex.py',sub_answer{3}],...
                                '../runjob_ex.sh',sub_answer{2},sub_answer{6});
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
dynap_xy_nr_threads = round(str2double(dynap_xy_answer{9}));
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
fprintf(fp, 'dynap_xy_nr_threads   = %i\n',   dynap_xy_nr_threads);
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
dynap_ex_nr_threads = round(str2double(dynap_ex_answer{9}));
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
fprintf(fp, 'dynap_ex_nr_threads   = %i\n',   dynap_ex_nr_threads);
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

dynap_ma_nr_turns      =round(str2double(dynap_ma_answer{1}));
dynap_ma_y0            = str2double(dynap_ma_answer{2});
dynap_ma_e_init        = str2double(dynap_ma_answer{3});
dynap_ma_e_delta       = str2double(dynap_ma_answer{4});
dynap_ma_nr_steps_back = round(str2double(dynap_ma_answer{5}));
dynap_ma_rescale       = str2double(dynap_ma_answer{6});
dynap_ma_nr_iterations = round(str2double(dynap_ma_answer{7}));
dynap_ma_s_min         = str2double(dynap_ma_answer{8});
dynap_ma_s_max         = str2double(dynap_ma_answer{9});
dynap_ma_nr_threads    = round(str2double(dynap_ma_answer{10}));
dynap_ma_fam_names     = dynap_ma_answer{11};
fams = regexp(dynap_ma_fam_names, ' ', 'split');
dynap_ma_fam_names = ['[', sprintf('"%s",', fams{:}), ']'];
fprintf(fp, 'dynap_ma_run           = True\n');
fprintf(fp, 'dynap_ma_flatfilename  = flat_filename\n');
fprintf(fp, 'dynap_ma_nr_turns      = %i\n',dynap_ma_nr_turns);
fprintf(fp, 'dynap_ma_y0            = %f\n',dynap_ma_y0);
fprintf(fp, 'dynap_ma_e_init        = %f\n',dynap_ma_e_init);
fprintf(fp, 'dynap_ma_e_delta       = %f\n',dynap_ma_e_delta);
fprintf(fp, 'dynap_ma_nr_steps_back = %i\n',dynap_ma_nr_steps_back);
fprintf(fp, 'dynap_ma_rescale       = %f\n',dynap_ma_rescale);
fprintf(fp, 'dynap_ma_nr_iterations = %i\n',dynap_ma_nr_iterations);
fprintf(fp, 'dynap_ma_s_min         = %f\n',dynap_ma_s_min);
fprintf(fp, 'dynap_ma_s_max         = %f\n',dynap_ma_s_max);
fprintf(fp, 'dynap_ma_nr_threads    = %i\n',dynap_ma_nr_threads);
fprintf(fp, 'dynap_ma_fam_names     = %s\n',dynap_ma_fam_names);
fclose(fp);


function create_pytrack_input_pxa(inputfilename, flatfilename, acc_answer, dynap_pxa_answer)

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

dynap_pxa_nr_turns      =round(str2double(dynap_pxa_answer{1}));
dynap_pxa_y0            = str2double(dynap_pxa_answer{2});
dynap_pxa_px_init       = str2double(dynap_pxa_answer{3});
dynap_pxa_px_delta      = str2double(dynap_pxa_answer{4});
dynap_pxa_nr_steps_back = round(str2double(dynap_pxa_answer{5}));
dynap_pxa_rescale       = str2double(dynap_pxa_answer{6});
dynap_pxa_nr_iterations = round(str2double(dynap_pxa_answer{7}));
dynap_pxa_s_min         = str2double(dynap_pxa_answer{8});
dynap_pxa_s_max         = str2double(dynap_pxa_answer{9});
dynap_pxa_nr_threads    = round(str2double(dynap_pxa_answer{10}));
dynap_pxa_fam_names     = dynap_pxa_answer{11};
fams = regexp(dynap_pxa_fam_names, ' ', 'split');
dynap_pxa_fam_names = ['[', sprintf('"%s",', fams{:}), ']'];
fprintf(fp, 'dynap_pxa_run           = True\n');
fprintf(fp, 'dynap_pxa_flatfilename  = flat_filename\n');
fprintf(fp, 'dynap_pxa_nr_turns      = %i\n',dynap_pxa_nr_turns);
fprintf(fp, 'dynap_pxa_y0            = %f\n',dynap_pxa_y0);
fprintf(fp, 'dynap_pxa_px_init       = %f\n',dynap_pxa_px_init);
fprintf(fp, 'dynap_pxa_px_delta      = %f\n',dynap_pxa_px_delta);
fprintf(fp, 'dynap_pxa_nr_steps_back = %i\n',dynap_pxa_nr_steps_back);
fprintf(fp, 'dynap_pxa_rescale       = %f\n',dynap_pxa_rescale);
fprintf(fp, 'dynap_pxa_nr_iterations = %i\n',dynap_pxa_nr_iterations);
fprintf(fp, 'dynap_pxa_s_min         = %f\n',dynap_pxa_s_min);
fprintf(fp, 'dynap_pxa_s_max         = %f\n',dynap_pxa_s_max);
fprintf(fp, 'dynap_pxa_nr_threads    = %i\n',dynap_pxa_nr_threads);
fprintf(fp, 'dynap_pxa_fam_names     = %s\n',dynap_pxa_fam_names);

fclose(fp);


function create_pytrack_input_pya(inputfilename, flatfilename, acc_answer, dynap_pya_answer)

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

dynap_pya_nr_turns      =round(str2double(dynap_pya_answer{1}));
dynap_pya_y0            = str2double(dynap_pya_answer{2});
dynap_pya_py_init       = str2double(dynap_pya_answer{3});
dynap_pya_py_delta      = str2double(dynap_pya_answer{4});
dynap_pya_nr_steps_back = round(str2double(dynap_pya_answer{5}));
dynap_pya_rescale       = str2double(dynap_pya_answer{6});
dynap_pya_nr_iterations = round(str2double(dynap_pya_answer{7}));
dynap_pya_s_min         = str2double(dynap_pya_answer{8});
dynap_pya_s_max         = str2double(dynap_pya_answer{9});
dynap_pya_nr_threads    = round(str2double(dynap_pya_answer{10}));
dynap_pya_fam_names     = dynap_pya_answer{11};
fams = regexp(dynap_pya_fam_names, ' ', 'split');
dynap_pya_fam_names = ['[', sprintf('"%s",', fams{:}), ']'];
fprintf(fp, 'dynap_pya_run           = True\n');
fprintf(fp, 'dynap_pya_flatfilename  = flat_filename\n');
fprintf(fp, 'dynap_pya_nr_turns      = %i\n',dynap_pya_nr_turns);
fprintf(fp, 'dynap_pya_y0            = %f\n',dynap_pya_y0);
fprintf(fp, 'dynap_pya_py_init       = %f\n',dynap_pya_py_init);
fprintf(fp, 'dynap_pya_py_delta      = %f\n',dynap_pya_py_delta);
fprintf(fp, 'dynap_pya_nr_steps_back = %i\n',dynap_pya_nr_steps_back);
fprintf(fp, 'dynap_pya_rescale       = %f\n',dynap_pya_rescale);
fprintf(fp, 'dynap_pya_nr_iterations = %i\n',dynap_pya_nr_iterations);
fprintf(fp, 'dynap_pya_s_min         = %f\n',dynap_pya_s_min);
fprintf(fp, 'dynap_pya_s_max         = %f\n',dynap_pya_s_max);
fprintf(fp, 'dynap_pya_nr_threads    = %i\n',dynap_pya_nr_threads);
fprintf(fp, 'dynap_pya_fam_names     = %s\n',dynap_pya_fam_names);

fclose(fp);