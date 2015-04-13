function varargout = fofbsim(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fofbsim_OpeningFcn, ...
                   'gui_OutputFcn',  @fofbsim_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before fofbsim is made visible.
function fofbsim_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for fofbsim
handles.output = hObject;

% Initialize simulation parameters
handles.config = struct('bpm_min_pos', -10, ...
    'bpm_max_pos', 10, ...
    'bpm_noise', 0.001, ...
    'bpm_bandwidth', 2000, ...
    'bpm_adc_bits', 16, ...
    'bpm_sampling_rate', 10000, ...
    'ps_min_current', -10, ...
    'ps_max_current', 10, ...
    'ps_response_time', 0.001, ...
    'ps_response_damping_factor', 1, ...
    'ps_max_slew_rate', 30, ...
    'ps_dac_bits', 16, ...
    'ps_update_rate', 10000, ...
    'corr_A_to_G', 20, ...
    'corr_G_to_mrad', 0.4, ...
    'vac_cutoff_H', 1700, ...
    'vac_cutoff_V', 1700, ...
    'delay_measurement', 100e-6, ...
    'delay_processing', 20e-6, ...
    'delay_actuation', 5e-6, ...
    'sim_time', 1, ...
    'sim_max_step', 0.00005, ...
    'sim_max_step_auto', 1, ...
    'ctrl_correction_matrix', [], ...
    'beam_response_matrix', [], ...
    'n_horizontal_bpm', [], ...
    'n_horizontal_corr', [], ...
    'beam_reference_orbit', [], ...
    'beam_disturbance', []);

% Initialize state-space matrices used for simulating dynamic systems
handles.ss_matrices = struct('bpm_filter', [], ...
    'ps_dynamics', [], ...
    'vac_dynamics', [], ...
    'ctrl_algorithm', []);

% Initialize results (void structure)
handles.simulation_results = struct('time', [], ...
    'actual_pos', [], ...
    'bpm_pos', [], ...
    'current_setpoint', [], ...
    'actual_current', [], ...
    'kick_angle', [], ...
    'pos_error', [], ...
    'pos_rms', [], ...
    'pos_max_deviation', [], ...
    'mfield_max_derivative', [], ...
    'kick_rms', [], ...
    'kick_max_amplitude', []);

% Initialize disturbance settings
handles.disturbance_config = struct('selected_disturbance', 'no_disturbance', ...
    'vib_frequencies', 0, ...
    'vib_rms', 0, ...
    'id_stoptime', 0, ...
    'id_amplitude', 0, ...
    'therm_tconstant', 0, ...
    'therm_amplitude', 0, ...
    'selected_scaling', 'all', ...
    'scale_amplitude', 1, ...
    'selected_bpm', 1);

% Initialize controller settings
handles.controller_config = struct('selected_controller', 'pid', ...
    'pid_Kp', 1, ...
    'pid_Ki', 100, ...
    'pid_Kd', 0, ...
    'tf_num', [0.03 0], ...
    'tf_den', [1 -1]);

try
    % Try to load default configuration file
    load('.\default_config.mat', 'config');
    load('.\default_config.mat', 'disturbance_config');
    load('.\default_config.mat', 'controller_config');

    handles.config = config;
    handles.disturbance_config = disturbance_config;
    handles.controller_config = controller_config;
catch err
    %uiwait(warndlg(['Cannot open the default configuration file. ' err.message]));
end 

write_config_to_figure(handles);
update_controls(handles);
show_void_results(handles);

% Store configuration
guidata(handles.main_figure, handles);


% --- Outputs from this function are returned to the command line.
function varargout = fofbsim_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close main_figure.
function main_figure_CloseRequestFcn(hObject, eventdata, handles)

delete(hObject);


% === CALLBACK FUNCTIONS ===

function btn_simulate_Callback(hObject, eventdata, handles)

% Disable user's interface controls before simulation
enable_editable_fields(handles, 'off');
set(handles.btn_simulate, 'String', 'Simulating...');
    
try
    handles.config = read_config_from_figure(handles);
    
    handles.simulation_results = simulate_fofb(handles.config, handles.disturbance_config, handles.controller_config, handles.ss_matrices);
    
    % Show results
    update_controls(handles);
    show_results_pos(handles);
    show_results_ps_corr(handles);
    write_config_to_figure(handles);
    
    % Store configuration
    guidata(handles.main_figure, handles);

catch err
    errordlg(['Could not run simulation. ' err.message], 'Error');
end

% Enable user's interface controls after simulation
set(handles.btn_simulate, 'String', 'Simulate');
enable_editable_fields(handles, 'on');


function cb_sim_max_step_auto_Callback(hObject, eventdata, handles)

% Toogle Simulation integraion time edit control
if get(handles.cb_sim_max_step_auto, 'Value')
    set(handles.edt_sim_max_step, 'Enable', 'off');
else
    set(handles.edt_sim_max_step, 'Enable', 'on');
end


function btn_controller_details_Callback(hObject, eventdata, handles)

try
    handles.config = read_config_from_figure(handles);

    % Open Correction matrix details window and wait for its return
    uiwait(fofbsim_controller_details(handles));

    % Reload handles structure (with the modified configuration) and use it to update the user's interface controls
    handles = guidata(handles.main_figure);
    write_config_to_figure(handles);

catch err
    errordlg(['Could open the Controller Details window. ' err.message], 'Error');
end


function btn_correction_matrix_details_Callback(hObject, eventdata, handles)

try
    handles.config = read_config_from_figure(handles);

    % Open Correction matrix details window and wait for its return
    uiwait(fofbsim_correction_matrix_details(handles));

    % Reload handles structure (with the modified configuration) and use it to update the user's interface controls
    handles = guidata(handles.main_figure);
    write_config_to_figure(handles);

catch err
    errordlg(['Could open the Correction Matrix Details window. ' err.message], 'Error');
end

function btn_response_matrix_details_Callback(hObject, eventdata, handles)

try
    handles.config = read_config_from_figure(handles);

    % Open Response matrix details window and wait for its return
    uiwait(fofbsim_response_matrix_details(handles));

    % Reload handles structure (with the modified configuration) and use it to update the user's interface controls
    handles = guidata(handles.main_figure);
    write_config_to_figure(handles);

catch err
    errordlg(['Could open the Response Matrix Details window. ' err.message], 'Error');
end

function btn_reference_orbit_details_Callback(hObject, eventdata, handles)

try
    handles.config = read_config_from_figure(handles);

    % Open Reference orbit details window and wait for its return
    uiwait(fofbsim_reference_orbit_details(handles));

    % Reload handles structure (with the modified configuration) and use it to update the user's interface controls
    handles = guidata(handles.main_figure);
    write_config_to_figure(handles);

catch err
    errordlg(['Could open the Reference Orbit Details window. ' err.message], 'Error');
end

function btn_disturbance_details_Callback(hObject, eventdata, handles)

try
    handles.config = read_config_from_figure(handles);

    % Open Disturbance details window and wait for its return
    uiwait(fofbsim_disturbance_details(handles));

    % Reload handles structure (with the modified configuration) and use it to update the user's interface controls
    handles = guidata(handles.main_figure);
    write_config_to_figure(handles);
catch err
    errordlg(['Could open the Disturbance Details window. ' err.message], 'Error');
end

function pop_bpm_Callback(hObject, eventdata, handles)

selected_bpms = get(handles.pop_bpm, 'Value');

if selected_bpms == 1
    % All BPMs selected
    show_results_pos(handles);
else
    % One BPM selected
    show_results_pos(handles,selected_bpms-1);
end


function pop_corr_Callback(hObject, eventdata, handles)

selected_corr = get(handles.pop_corr, 'Value');

if selected_corr == 1
    % All correctors selected
    show_results_ps_corr(handles);
else
    % One corrector selected
    show_results_ps_corr(handles,selected_corr-1);
end


function tool_open_config_Callback(hObject, eventdata, handles)

[filename, pathname] = uigetfile('*.mat', 'Open configuration');

if filename
    try
        % Load .mat file
        loaded_variables = load([pathname filename], 'config', 'disturbance_config', 'controller_config');
        
        verify_config(loaded_variables.config);
        
        % If simulation parameters are consistent, update configuration structures
        handles.config = loaded_variables.config;
        handles.disturbance_config = loaded_variables.disturbance_config;
        handles.controller_config = loaded_variables.controller_config;

        write_config_to_figure(handles);
        
        % Store configuration
        guidata(handles.main_figure, handles);
        
    catch err
        errordlg(['Could not open file. ' err.message], 'Error');
        return;
    end
end


function tool_save_config_Callback(hObject, eventdata, handles)

[filename, pathname] = uiputfile('*.mat', 'Save configuration');

if filename
    try
        config = read_config_from_figure(handles);
        disturbance_config = handles.disturbance_config;
        controller_config = handles.controller_config;

        % Save .mat file
        save([pathname filename], 'config', 'disturbance_config', 'controller_config');
        
    catch err
        errordlg(['Could not save file. ' err.message], 'Error');
        return;
    end
end


function tool_export_results_Callback(hObject, eventdata, handles)

[filename, pathname]=uiputfile('*.mat', 'Export results');

simulation_results = handles.simulation_results;

if filename
    try
        % Save .mat file
        save([pathname filename], 'simulation_results');
        
    catch err
        errordlg(['Could not save file. ' err.message], 'Error');
        return;
    end
end


function tool_system_freqresp_H_Callback(hObject, eventdata, handles)

try
    system_freqresp(read_config_from_figure(handles), handles.controller_config, 'H');

catch err
    errordlg(['Could not plot the horizontal plane theoretical frequency response. ' err.message], 'Error');
end


function tool_system_freqresp_V_Callback(hObject, eventdata, handles)

try
    system_freqresp(read_config_from_figure(handles), handles.controller_config, 'V');

catch err
    errordlg(['Could not plot the horizontal plane theoretical frequency response. ' err.message], 'Error');
end


function tool_help_Callback(hObject, eventdata, handles)

fofbsim_help;

% ==========================


% === FUNCTIONS ===

% Change 'Enable' parameter of user's interface controls to the same state ('on' or 'off')
function handles = enable_editable_fields(handles, state)

set(handles.edt_bpm_min_pos, 'Enable', state);
set(handles.edt_bpm_max_pos, 'Enable', state);
set(handles.edt_bpm_noise, 'Enable', state);
set(handles.edt_bpm_adc_bits, 'Enable', state);
set(handles.edt_bpm_sampling_rate, 'Enable', state);
set(handles.edt_ps_min_current, 'Enable', state);
set(handles.edt_ps_max_current, 'Enable', state);
set(handles.edt_ps_max_slew_rate, 'Enable', state);
set(handles.edt_ps_dac_bits, 'Enable', state);
set(handles.edt_ps_update_rate, 'Enable', state);
set(handles.edt_corr_A_to_G, 'Enable', state);
set(handles.edt_corr_G_to_mrad, 'Enable', state);
set(handles.edt_delay_measurement, 'Enable', state);
set(handles.edt_delay_processing, 'Enable', state);
set(handles.edt_delay_actuation, 'Enable', state);
set(handles.edt_sim_time, 'Enable', state);
if get(handles.cb_sim_max_step_auto, 'Value')
    set(handles.edt_sim_max_step, 'Enable', 'off');
else
    set(handles.edt_sim_max_step, 'Enable', state);
end
set(handles.cb_sim_max_step_auto, 'Enable', state);
set(handles.edt_ctrl_num, 'Enable', state);
set(handles.edt_ctrl_den, 'Enable', state);
set(handles.edt_bpm_bandwidth, 'Enable', state);
set(handles.edt_ps_response_time, 'Enable', state);
set(handles.edt_ps_response_damping_factor, 'Enable', state);
set(handles.edt_vac_cutoff_H, 'Enable', state);
set(handles.edt_vac_cutoff_V, 'Enable', state);
set(handles.edt_vac_cutoff_V, 'Enable', state);

set(handles.txt_ctrl_correction_matrix, 'Enable', state);
set(handles.txt_beam_reference_orbit, 'Enable', state);
set(handles.txt_beam_response_matrix, 'Enable', state);
set(handles.txt_beam_disturbance, 'Enable', state);

set(handles.btn_ctrl_controller_details, 'Enable', state);
set(handles.btn_ctrl_correction_matrix_details, 'Enable', state);
set(handles.btn_beam_response_matrix_details, 'Enable', state);
set(handles.btn_beam_reference_orbit_details, 'Enable', state);
set(handles.btn_beam_disturbance_details, 'Enable', state);
set(handles.btn_simulate, 'Enable', state);

set(handles.pop_bpm, 'Enable', state);
set(handles.pop_corr, 'Enable', state);


% Load simulation parameters from the user's interface
function config = read_config_from_figure(handles)

% Load simulation parameters
config = handles.config;

config.bpm_min_pos = str2num(get(handles.edt_bpm_min_pos, 'String'));
config.bpm_max_pos = str2num(get(handles.edt_bpm_max_pos, 'String'));
config.bpm_noise = str2num(get(handles.edt_bpm_noise, 'String'));
config.bpm_bandwidth = str2num(get(handles.edt_bpm_bandwidth, 'String'));
config.bpm_adc_bits = floor(str2num(get(handles.edt_bpm_adc_bits, 'String')));
config.bpm_sampling_rate = str2num(get(handles.edt_bpm_sampling_rate, 'String'));
config.ps_min_current = str2num(get(handles.edt_ps_min_current, 'String'));
config.ps_max_current = str2num(get(handles.edt_ps_max_current, 'String'));
config.ps_response_time = str2num(get(handles.edt_ps_response_time, 'String'));
config.ps_response_damping_factor = str2num(get(handles.edt_ps_response_damping_factor, 'String'));
config.ps_max_slew_rate = str2num(get(handles.edt_ps_max_slew_rate, 'String'));
config.ps_dac_bits = floor(str2num(get(handles.edt_ps_dac_bits, 'String')));
config.ps_update_rate = str2num(get(handles.edt_ps_update_rate, 'String'));
config.corr_A_to_G = str2num(get(handles.edt_corr_A_to_G, 'String'));
config.corr_G_to_mrad = str2num(get(handles.edt_corr_G_to_mrad, 'String'));
config.vac_cutoff_H = str2num(get(handles.edt_vac_cutoff_H, 'String'));
config.vac_cutoff_V = str2num(get(handles.edt_vac_cutoff_V, 'String'));
config.delay_measurement = str2num(get(handles.edt_delay_measurement, 'String'));
config.delay_processing = str2num(get(handles.edt_delay_processing, 'String'));
config.delay_actuation = str2num(get(handles.edt_delay_actuation, 'String'));
config.sim_time = str2num(get(handles.edt_sim_time, 'String'));
if get(handles.cb_sim_max_step_auto, 'Value')
    config.sim_max_step_auto = 1;
else
    config.sim_max_step_auto = 0;
    config.sim_max_step = str2num(get(handles.edt_sim_max_step, 'String'));
end

verify_config(config);


% Verify if simulation parameters are consistent. If not, throw exception describing inconsistent fields
function verify_config(config)

i = 1;
errors = {};

if isempty(config.bpm_min_pos) || ~isnumeric(config.bpm_min_pos) || ~isscalar(config.bpm_min_pos)
    errors{i} = 'Invalid BPM minimum position';
    i=i+1;
end

if isempty(config.bpm_max_pos) || ~isnumeric(config.bpm_max_pos) || ~isscalar(config.bpm_max_pos)
    errors{i} = 'Invalid BPM maximum position';
    i=i+1;
end

if ~isempty(config.bpm_min_pos) && ~isempty(config.bpm_max_pos) && (config.bpm_max_pos <= config.bpm_min_pos)
    errors{i} = 'BPM maximum position must be greater than BPM minimun position';
    i=i+1;
end

if isempty(config.bpm_noise) || ~isnumeric(config.bpm_noise) || ~isscalar(config.bpm_noise)
    errors{i} = 'Invalid BPM white noise RMS value';
    i=i+1;
elseif config.bpm_noise < 0
    errors{i} = 'Negative BPM white noise RMS value';
    i=i+1;    
end

if isempty(config.bpm_bandwidth) || ~isnumeric(config.bpm_bandwidth) || ~isscalar(config.bpm_bandwidth)
    errors{i} = 'Invalid BPM bandwidth';
    i=i+1;
elseif config.bpm_bandwidth <= 0
    errors{i} = 'Non-positive BPM bandwidth';
    i=i+1;    
elseif config.bpm_bandwidth >= config.bpm_sampling_rate/2
    errors{i} = ['BPM bandwidth must be less than half the BPM sampling rate (' num2str(config.bpm_sampling_rate/2) ' Hz)'];
    i=i+1;
end    

if isempty(config.bpm_adc_bits) || ~isnumeric(config.bpm_adc_bits) || ~isscalar(config.bpm_adc_bits)
    errors{i} = 'Invalid BPM ADC number of bits';
    i=i+1;
elseif config.bpm_adc_bits <= 0
    errors{i} = 'Non-positive BPM ADC number of bits';
    i=i+1;
end

if isempty(config.bpm_sampling_rate) || ~isnumeric(config.bpm_sampling_rate) || ~isscalar(config.bpm_sampling_rate)
    errors{i} = 'Invalid BPM sampling rate';
    i=i+1;
elseif config.bpm_sampling_rate <= 0
    errors{i} = 'Non-positive BPM sampling rate';
    i=i+1;  
end

if isempty(config.ps_min_current) || ~isnumeric(config.ps_min_current) || ~isscalar(config.ps_min_current)
    errors{i} = 'Invalid power supply minimum current';
    i=i+1;
end

if isempty(config.ps_max_current) || ~isnumeric(config.ps_max_current) || ~isscalar(config.ps_max_current)
    errors{i} = 'Invalid power supply maximum current';
    i=i+1;
end

if ~isempty(config.ps_min_current) && ~isempty(config.ps_max_current) && (config.ps_max_current <= config.ps_min_current)
    errors{i} = 'Power supply maximum current must be greater than power supply minimum position';
    i=i+1;
end

if isempty(config.ps_response_time) || ~isnumeric(config.ps_response_time) || ~isscalar(config.ps_response_time)
    errors{i} = 'Invalid power supply response time';
    i=i+1;
elseif config.ps_response_time <= 0
    errors{i} = 'Non-positive power supply response time';
    i=i+1;
end

if isempty(config.ps_response_damping_factor) || ~isnumeric(config.ps_response_damping_factor) || ~isscalar(config.ps_response_damping_factor)
    errors{i} = 'Invalid power supply response damping factor';
    i=i+1;
elseif config.ps_response_damping_factor < 0
    errors{i} = 'Non-positive power supply response damping factor';
    i=i+1;
end

if isempty(config.ps_max_slew_rate) || ~isnumeric(config.ps_max_slew_rate) || ~isscalar(config.ps_max_slew_rate)
    errors{i} = 'Invalid power supply maximum slew rate';
    i=i+1;
elseif config.ps_max_slew_rate <= 0
    errors{i} = 'Non-positive power supply maximum slew rate';
    i=i+1;
end

if isempty(config.ps_dac_bits) || ~isnumeric(config.ps_dac_bits) || ~isscalar(config.ps_dac_bits)
    errors{i} = 'Invalid power supply DAC number of bits';
    i=i+1;
elseif config.ps_dac_bits <= 0
    errors{i} = 'Non-positive power supply DAC number of bits';
    i=i+1;
end

if isempty(config.ps_update_rate) || ~isnumeric(config.ps_update_rate) || ~isscalar(config.ps_update_rate)
    errors{i} = 'Invalid power supply update rate';
    i=i+1;
elseif config.ps_update_rate <= 0
    errors{i} = 'Non-positive power supply update rate';
    i=i+1;
end

if isempty(config.corr_A_to_G) || ~isnumeric(config.corr_A_to_G) || ~isscalar(config.corr_A_to_G)
    errors{i} = 'Invalid corrector gain (G/A)';
    i=i+1;
elseif config.corr_A_to_G <= 0
    errors{i} = 'Non-positive corrector gain (G/A)';
    i=i+1;
end

if isempty(config.corr_G_to_mrad) || ~isnumeric(config.corr_G_to_mrad) || ~isscalar(config.corr_G_to_mrad)
    errors{i} = 'Invalid corrector gain (mrad/G)';
    i=i+1;
elseif config.corr_G_to_mrad <= 0
    errors{i} = 'Non-positive corrector gain (mrad/G)';
    i=i+1;
end

if isempty(config.vac_cutoff_H) || ~isnumeric(config.vac_cutoff_H) || ~isscalar(config.vac_cutoff_H)
    errors{i} = 'Invalid vacuum chamber cutoff frequency (horizontal plane)';
    i=i+1;
elseif config.vac_cutoff_H <= 0
    errors{i} = 'Non-positive vacuum chamber cutoff frequency (horizontal plane)';
    i=i+1;
end

if isempty(config.vac_cutoff_V) || ~isnumeric(config.vac_cutoff_V) || ~isscalar(config.vac_cutoff_V)
    errors{i} = 'Invalid vacuum chamber cutoff frequency (vertical plane)';
    i=i+1;
elseif config.vac_cutoff_V <= 0
    errors{i} = 'Non-positive vacuum chamber cutoff frequency (vertical plane)';
    i=i+1;
end

if isempty(config.delay_measurement) || ~isnumeric(config.delay_measurement) || ~isscalar(config.delay_measurement)
    errors{i} = 'Invalid measurement data distribution delay';
    i=i+1;
elseif config.delay_measurement < 0
    errors{i} = 'Negative measurement data distribution delay';
    i=i+1;    
end

if isempty(config.delay_processing) || ~isnumeric(config.delay_processing) || ~isscalar(config.delay_processing)
    errors{i} = 'Invalid controller processing time';
    i=i+1;
elseif config.delay_processing < 0
    errors{i} = 'Negative controller processing time';
    i=i+1;    
end

if isempty(config.delay_actuation) || ~isnumeric(config.delay_actuation) || ~isscalar(config.delay_actuation)
    errors{i} = 'Invalid actuation data distribution delay';
    i=i+1;
elseif config.delay_actuation < 0
    errors{i} = 'Negative actuation data distribution delay';
    i=i+1;    
end

if isempty(config.sim_time) || ~isnumeric(config.sim_time) || ~isscalar(config.sim_time)
    errors{i} = 'Invalid simulation time';
    i=i+1;
elseif config.sim_time <= 0
    errors{i} = 'Non-positive simulation time';
    i=i+1;
end

if isempty(config.sim_max_step) || ~isnumeric(config.sim_max_step) || ~isscalar(config.sim_max_step)
    errors{i} = 'Invalid maximum integration time';
    i=i+1;
elseif config.sim_max_step <= 0
    errors{i} = 'Non-positive maximum integration time';
    i=i+1;
end

if ~isempty(errors)
    error_string = ['"' errors{1} '"'];
    for i=2:length(errors)
        error_string = [error_string '; "' errors{i} '"'];
    end
    throw(MException('fofbsim:read_config_from_figure:invalid_parameters', [num2str(length(errors)) ' error(s) found: ' error_string '.']));
end


% Load simulation parameters to the user's interface
function write_config_to_figure(handles)

% Load simulation parameters
config = handles.config;

% Load disturbance configuration
disturbance_config = handles.disturbance_config;

% Load disturbance configuration
controller_config = handles.controller_config;

% Update scalar fields in the user's interface
set(handles.edt_bpm_min_pos, 'String', num2str(config.bpm_min_pos));
set(handles.edt_bpm_max_pos, 'String', num2str(config.bpm_max_pos));
set(handles.edt_bpm_noise, 'String', num2str(config.bpm_noise));
set(handles.edt_bpm_adc_bits, 'String', num2str(config.bpm_adc_bits));
set(handles.edt_bpm_sampling_rate, 'String', num2str(config.bpm_sampling_rate));
set(handles.edt_ps_min_current, 'String', num2str(config.ps_min_current));
set(handles.edt_ps_max_current, 'String', num2str(config.ps_max_current));
set(handles.edt_ps_max_slew_rate, 'String', num2str(config.ps_max_slew_rate));
set(handles.edt_ps_dac_bits, 'String', num2str(config.ps_dac_bits));
set(handles.edt_ps_update_rate, 'String', num2str(config.ps_update_rate));
set(handles.edt_corr_A_to_G, 'String', num2str(config.corr_A_to_G));
set(handles.edt_corr_G_to_mrad, 'String', num2str(config.corr_G_to_mrad));
set(handles.edt_delay_measurement, 'String', num2str(config.delay_measurement));
set(handles.edt_delay_processing, 'String', num2str(config.delay_processing));
set(handles.edt_delay_actuation, 'String', num2str(config.delay_actuation));
set(handles.edt_sim_time, 'String', num2str(config.sim_time));
set(handles.edt_sim_max_step, 'String', num2str(config.sim_max_step));

% Update matrix fields in the user's interface
[ctrl_num, ctrl_den] = generate_contoller(controller_config, 1/config.ps_update_rate);
set(handles.edt_ctrl_num, 'String', mat2str(ctrl_num));
set(handles.edt_ctrl_den, 'String', mat2str(ctrl_den));
set(handles.edt_bpm_bandwidth, 'String', num2str(config.bpm_bandwidth));
set(handles.edt_ps_response_time, 'String', num2str(config.ps_response_time));
set(handles.edt_ps_response_damping_factor, 'String', num2str(config.ps_response_damping_factor));
set(handles.edt_vac_cutoff_H, 'String', num2str(config.vac_cutoff_H));
set(handles.edt_vac_cutoff_V, 'String', num2str(config.vac_cutoff_V));

% Update checkbox fields in the user's interface
set(handles.cb_sim_max_step_auto, 'Value', config.sim_max_step_auto);
if config.sim_max_step_auto
    set(handles.edt_sim_max_step, 'Enable', 'off');
else
    set(handles.edt_sim_max_step, 'Enable', 'on');
end     

% Update detailed fields in the user's interface
if isempty(config.beam_response_matrix)
    set(handles.txt_beam_response_matrix, 'String', 'not loaded');
    set(handles.txt_beam_response_matrix, 'ForegroundColor', [1 0 0]);
else
    [n_bpm, n_corr] = size(config.beam_response_matrix);
    set(handles.txt_beam_response_matrix, 'String', ['loaded: ' num2str(n_bpm) ' x ' num2str(n_corr)]);
    set(handles.txt_beam_response_matrix, 'ForegroundColor', [0 0 0]);
end

if isempty(config.ctrl_correction_matrix)
    set(handles.txt_ctrl_correction_matrix, 'String', 'default (SVD calculated)');
else
    set(handles.txt_ctrl_correction_matrix, 'String', 'loaded');
end

if isempty(config.beam_reference_orbit)
    set(handles.txt_beam_reference_orbit, 'String', 'default (zero)');
else
    set(handles.txt_beam_reference_orbit, 'String', 'loaded');
end

if strcmp(disturbance_config.selected_disturbance, 'no_disturbance')
    set(handles.txt_beam_disturbance, 'String', 'default (zero)');
else
    set(handles.txt_beam_disturbance, 'String', 'loaded');
end


% Update simulation results controls
function update_controls(handles)

% Load simulation parameters
config = handles.config;

if isempty(config.beam_response_matrix)
    % Calculate default configuration for empty response matrix
    n_bpm = 1;
    n_corr = 1;
    config.n_horizontal_bpm = 1;
    config.n_horizontal_corr = 1;
else
    [n_bpm, n_corr] = size(config.beam_response_matrix);
end
    
% Fill BPM selector pop-up
aux_array = cell(n_bpm+1,1);
aux_array{1} = '(All)';
for i=1:config.n_horizontal_bpm
    aux_array{i+1} = ['H_BPM_' num2str(i)];
end
for i=1:n_bpm-config.n_horizontal_bpm
    aux_array{config.n_horizontal_bpm+i+1} = ['V_BPM_' num2str(i)];
end
set(handles.pop_bpm, 'String', aux_array);
set(handles.pop_bpm, 'Value', 1);

% Fill corrector selector pop-up
aux_array = cell(n_corr+1,1);
aux_array{1} = '(All)';
for i=1:config.n_horizontal_corr
    aux_array{i+1} = ['H_CORR_' num2str(i)];
end
for i=1:n_corr-config.n_horizontal_corr
    aux_array{config.n_horizontal_corr+i+1} = ['V_CORR_' num2str(i)];
end
set(handles.pop_corr, 'String', aux_array);
set(handles.pop_corr, 'Value', 1);


% Show position results (actual position and measured position)
function show_results_pos(handles, selected_bpm)

% Load simulation results
results = handles.simulation_results;

% If no BPM was selected, show results of all BPMs
if nargin < 2
    selected_bpm = 1:size(results.bpm_pos,2);
end

% Plot graphs
pos = [results.bpm_pos(:, selected_bpm) results.actual_pos(:, selected_bpm)];
plot(handles.ax_pos, results.time, pos);
grid(handles.ax_pos, 'on');

% Show legend if only one BPM was selected
if length(selected_bpm) == 1
	legend(handles.ax_pos, 'Measured position', 'Actual position', 'Location', 'NorthWest');
end

% Update graphh labels
xlabel(handles.ax_pos, 'Time (s)', 'FontSize', 8, 'FontUnit', 'normalized');
ylabel(handles.ax_pos, 'mm', 'FontSize', 8, 'FontUnit', 'normalized');
set(handles.ax_pos, 'FontSize', 8, 'FontUnit', 'normalized');

% Update calculated results values
if length(selected_bpm) == 1
    [value, unit] = good_unit(handles.simulation_results.pos_error(selected_bpm)*1e-3, 'm');
    set(handles.edt_pos_error, 'String', [num2str(value, '%0.1f') ' ' unit]);
    set(handles.edt_pos_error, 'Enable', 'inactive');

    [value, unit] = good_unit(handles.simulation_results.pos_rms(selected_bpm)*1e-3, 'm');
    set(handles.edt_pos_rms, 'String', [num2str(value, '%0.1f') ' ' unit]);
    set(handles.edt_pos_rms, 'Enable', 'inactive');

    [value, unit] = good_unit(handles.simulation_results.pos_max_deviation(selected_bpm)*1e-3, 'm');
    set(handles.edt_pos_max_deviation, 'String', [num2str(value, '%0.1f') ' ' unit]);
    set(handles.edt_pos_max_deviation, 'Enable', 'inactive');

else
    set(handles.edt_pos_error, 'Enable', 'off');
    set(handles.edt_pos_error, 'String', '0.0 mm');
    set(handles.edt_pos_rms, 'Enable', 'off');
    set(handles.edt_pos_rms, 'String', '0.0 mm');
    set(handles.edt_pos_max_deviation, 'Enable', 'off');
    set(handles.edt_pos_max_deviation, 'String', '0.0 mm');
end


% Show power supplies and correctors results (power supplies' current setpoint and actual current and kick angle inside corrector's vacuum chamber)
function show_results_ps_corr(handles, selected_corr)

% Load simulation results
results = handles.simulation_results;

% If no corrector was selected, show results of all correctors
if nargin < 2
    selected_corr = 1:size(results.current_setpoint, 2);
end

% Plot graphs
ax = plotyy(handles.ax_ps_corr, results.time, [results.current_setpoint(:, selected_corr) results.actual_current(:, selected_corr)], results.time, results.kick_angle(:, selected_corr));
grid(ax(1), 'on');
set(ax(2), 'YColor', [0 0 0]);

% Show legend if only one corrector was selected
if length(selected_corr) == 1
	legend(ax(1), 'Current setpoint', 'Actual current', 'Location', 'NorthWest');
    legend(ax(2), 'Kick angle');
end

% Update graphh labels
xlabel(handles.ax_ps_corr, 'Time (s)', 'FontSize', 8, 'FontUnit', 'normalized');
ylabel(ax(1), 'A', 'FontSize', 8, 'FontUnit', 'normalized');
ylabel(ax(2), 'mrad', 'FontSize', 8, 'FontUnit', 'normalized');
set(ax, 'FontSize', 8, 'FontUnit', 'normalized');

% Update calculated results values
if length(selected_corr) == 1
    [value, unit] = good_unit(handles.simulation_results.mfield_max_derivative(selected_corr), 'G/s');
    set(handles.edt_mfield_max_derivative, 'String', [num2str(value, '%0.1f') ' ' unit]);
    set(handles.edt_mfield_max_derivative, 'Enable', 'inactive');
    
    [value, unit] = good_unit(handles.simulation_results.kick_rms(selected_corr)*1e-3, 'rad');
    set(handles.edt_kick_rms, 'String', [num2str(value, '%0.1f') ' ' unit]);
    set(handles.edt_kick_rms, 'Enable', 'inactive');

    [value, unit] = good_unit(handles.simulation_results.kick_max_amplitude(selected_corr)*1e-3, 'rad');
    set(handles.edt_kick_max_amplitude, 'String', [num2str(value, '%0.1f') ' ' unit]);
    set(handles.edt_kick_max_amplitude, 'Enable', 'inactive');    
else
    set(handles.edt_mfield_max_derivative, 'String', '0.0 G/s');
    set(handles.edt_mfield_max_derivative, 'Enable', 'off');
    set(handles.edt_kick_rms, 'Enable', 'off');
    set(handles.edt_kick_rms, 'String', '0.0 mrad');
    set(handles.edt_kick_max_amplitude, 'Enable', 'off');
    set(handles.edt_kick_max_amplitude, 'String', '0.0 mrad');
end


% Plot and show void results
function show_void_results(handles)

plot(handles.ax_pos, [0 1], [0 0]);
grid(handles.ax_pos, 'on');
plot(handles.ax_ps_corr, [0 1], [0 0]);
grid(handles.ax_ps_corr, 'on');
set(handles.edt_pos_error, 'String', '0.0 mm');
set(handles.edt_pos_rms, 'String', '0.0 mm');
set(handles.edt_pos_max_deviation, 'String', '0.0 mm');
set(handles.edt_mfield_max_derivative, 'String', '0.0 G/s');
set(handles.edt_kick_rms, 'String', '0.0 mrad');
set(handles.edt_kick_max_amplitude, 'String', '0.0 mrad');    

% =================