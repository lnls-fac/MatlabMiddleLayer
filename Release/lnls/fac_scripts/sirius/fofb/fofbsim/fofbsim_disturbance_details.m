function varargout = fofbsim_disturbance_details(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fofbsim_disturbance_details_OpeningFcn, ...
                   'gui_OutputFcn',  @fofbsim_disturbance_details_OutputFcn, ...
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


% --- Executes just before fofbsim_disturbance_details is made visible.
function fofbsim_disturbance_details_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for fofbsim_disturbance_details
handles.output = hObject;

% Load simulation parameters from the FOFBSim main figure and stores it in the present figure
if ~isempty(varargin{1}.config.beam_response_matrix)
    handles.n_bpm = size(varargin{1}.config.beam_response_matrix, 1);
    handles.n_horizontal_bpm = varargin{1}.config.n_horizontal_bpm;
else
    handles.n_bpm = 1;
    handles.n_horizontal_bpm = 1;
end
handles.simulation_time = varargin{1}.config.sim_time;
handles.disturbance_config = varargin{1}.disturbance_config;

% Check if number of BPM has changed and update amplitude scaling vector
if length(handles.disturbance_config.scale_amplitude) ~= handles.n_bpm
    handles.disturbance_config.scale_amplitude = ones(1, handles.n_bpm);
end

% Check if number of BPM has changed and update selected BPM reading
if handles.disturbance_config.selected_bpm > handles.n_bpm
    handles.disturbance_config.selected_bpm = 1;
end

update_controls(handles);
show_disturbance(handles);

% Save FOFBSim main figure handle
handles.parent_window_handles = varargin{1};
    
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = fofbsim_disturbance_details_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% === FUNCTIONS ===

function update_controls(handles)

% Load disturbance configuration
disturbance_config = handles.disturbance_config;

write_disturbance_config_to_figure(handles, disturbance_config);

% Fill BPM selector pop-up
aux_array = cell(handles.n_bpm,1);
for i=1:handles.n_horizontal_bpm
    aux_array{i} = ['H_BPM_' num2str(i)];
end
for i=1:handles.n_bpm-handles.n_horizontal_bpm
    aux_array{handles.n_horizontal_bpm+i} = ['V_BPM_' num2str(i)];
end
set(handles.pop_bpm, 'String', aux_array);
set(handles.pop_bpm, 'Value', disturbance_config.selected_bpm);


function show_disturbance(handles)

try
    distubance_config = read_disturbance_config_from_figure(handles);
    disturbance = generate_disturbance(distubance_config, handles.simulation_time, handles.n_bpm);

    if isempty(disturbance)
        time = [0; handles.simulation_time];
        data = repmat([0; 0], 1, handles.n_bpm);
        disturbance = [time data];
    end

    plot(handles.ax_disturbance, disturbance(:,1), disturbance(:,2:end));
    xlabel(handles.ax_disturbance, 'Time (s)', 'FontSize', 8);
    ylabel(handles.ax_disturbance, 'Position disturbance (mm)', 'FontSize', 8);
    grid(handles.ax_disturbance, 'on');

catch err
   errordlg('Could not plot disturbance. ', err.message, 'Error'); 
end


% Load disturbance configuration from the user's interface
function disturbance_config = read_disturbance_config_from_figure(handles)

if get(handles.rb_vib, 'Value') 
    selected_disturbance = 'vib';
elseif get(handles.rb_id, 'Value')
    selected_disturbance = 'id';
elseif get(handles.rb_therm, 'Value')
    selected_disturbance = 'therm';
elseif get(handles.rb_no_disturbance, 'Value')
    selected_disturbance = 'no_disturbance';
end

if get(handles.rb_disturbance_all, 'Value')
    selected_scaling = 'all';
elseif get(handles.rb_disturbance_one_bpm, 'Value')
    selected_scaling = 'one_bpm';
end

disturbance_config = struct('selected_disturbance', selected_disturbance, ...
    'vib_frequencies', str2num(get(handles.edt_vib_frequencies, 'String')), ...
    'vib_rms', str2num(get(handles.edt_vib_rms, 'String')), ...
    'id_stoptime', str2num(get(handles.edt_id_stoptime, 'String')), ...
    'id_amplitude', str2num(get(handles.edt_id_amplitude, 'String')), ...
    'therm_tconstant', str2num(get(handles.edt_therm_tconstant, 'String')), ...
    'therm_amplitude', str2num(get(handles.edt_therm_amplitude, 'String')), ...
    'selected_scaling', selected_scaling, ...
    'scale_amplitude', str2num(get(handles.edt_scale_amplitude, 'String')), ...
    'selected_bpm', get(handles.pop_bpm, 'Value'));


% Load disturbance configuration to the user's interface
function write_disturbance_config_to_figure(handles, disturbance_config)

switch  disturbance_config.selected_disturbance
    case 'vib'
        set(handles.rb_vib, 'Value', 1);
        set(handles.rb_id, 'Value', 0);
        set(handles.rb_therm, 'Value', 0);
        set(handles.rb_no_disturbance, 'Value', 0);
    case 'id'
        set(handles.rb_vib, 'Value', 0);
        set(handles.rb_id, 'Value', 1);
        set(handles.rb_therm, 'Value', 0);
        set(handles.rb_no_disturbance, 'Value', 0);
    case 'therm'
        set(handles.rb_vib, 'Value', 0);
        set(handles.rb_id, 'Value', 0);
        set(handles.rb_therm, 'Value', 1);
        set(handles.rb_no_disturbance, 'Value', 0);
    case 'no_disturbance'
        set(handles.rb_vib, 'Value', 0);
        set(handles.rb_id, 'Value', 0);
        set(handles.rb_therm, 'Value', 0);
        set(handles.rb_no_disturbance, 'Value', 1);
end

switch disturbance_config.selected_scaling
    case 'all'
        set(handles.rb_disturbance_all, 'Value', 1);
        set(handles.rb_disturbance_one_bpm, 'Value', 0);
    case 'one_bpm'
        set(handles.rb_disturbance_all, 'Value', 0);
        set(handles.rb_disturbance_one_bpm, 'Value', 1);
end

set(handles.edt_vib_frequencies, 'String', mat2str(disturbance_config.vib_frequencies));
set(handles.edt_vib_rms, 'String', mat2str(disturbance_config.vib_rms));
set(handles.edt_id_stoptime, 'String', num2str(disturbance_config.id_stoptime));
set(handles.edt_id_amplitude, 'String', num2str(disturbance_config.id_amplitude));
set(handles.edt_therm_tconstant, 'String', num2str(disturbance_config.therm_tconstant));
set(handles.edt_therm_amplitude, 'String', num2str(disturbance_config.therm_amplitude));
if isempty(disturbance_config.scale_amplitude)
    set(handles.edt_scale_amplitude, 'String', mat2str(ones(1,handles.n_bpm)));
else
    set(handles.edt_scale_amplitude, 'String', mat2str(disturbance_config.scale_amplitude));
end

% =================


% --- Executes on button press in btn_ok.
function btn_ok_Callback(hObject, eventdata, handles)

try
    handles.parent_window_handles.disturbance_config = read_disturbance_config_from_figure(handles);
    guidata(handles.parent_window_handles.main_figure, handles.parent_window_handles);
    delete(handles.disturbance_details_window);
catch err
    errordlg(err.message, 'Error');
end

% --- Executes on button press in pushbutton2.
function btn_cancel_Callback(hObject, eventdata, handles)

delete(handles.disturbance_details_window);


function edt_scale_amplitude_Callback(hObject, eventdata, handles)

set(handles.rb_disturbance_all,'Value', 1);

show_disturbance(handles);


% --- Executes on selection change in popupmenu1.
function pop_bpm_Callback(hObject, eventdata, handles)

set(handles.rb_disturbance_one_bpm,'Value', 1);

show_disturbance(handles);


function edt_vib_frequencies_Callback(hObject, eventdata, handles)

% Guarantees that both parameters (frequency and RMS value) have the same number of elements
frequencies = str2num(get(handles.edt_vib_frequencies, 'String'));
rms_values = str2num(get(handles.edt_vib_rms, 'String'));
n_frequencies = length(frequencies);
n_rms_values = length(rms_values);

if ~isempty(frequencies)
    rms_values_aux = zeros(1, n_frequencies);
    rms_values_aux(1:min(n_rms_values, n_frequencies)) = rms_values(1:min(n_rms_values, n_frequencies));
    set(handles.edt_vib_rms, 'String', mat2str(rms_values_aux));

    set(handles.rb_vib,'Value', 1);
    show_disturbance(handles);
else
    errordlg('Invalid vibration frequencies.', 'Error');
    set(handles.edt_vib_frequencies, 'String', mat2str(zeros(1, n_rms_values)));
end 


function edt_vib_rms_Callback(hObject, eventdata, handles)

% Guarantees that both parameters (frequency and RMS value) have the same number of elements
frequencies = str2num(get(handles.edt_vib_frequencies, 'String'));
rms_values = str2num(get(handles.edt_vib_rms, 'String'));
n_frequencies = length(frequencies);
n_rms_values = length(rms_values);

if ~isempty(rms_values)
    frequencies_aux = zeros(1, n_rms_values);
    frequencies_aux(1:min(n_rms_values, n_frequencies)) = frequencies(1:min(n_rms_values, n_frequencies));
    set(handles.edt_vib_frequencies, 'String', mat2str(frequencies_aux));

    set(handles.rb_vib,'Value', 1);
    show_disturbance(handles);
else
    errordlg('Invalid vibration RMS values.', 'Error');
    set(handles.edt_vib_rms, 'String', mat2str(zeros(1, n_frequencies)));
end


function edt_id_stoptime_Callback(hObject, eventdata, handles)

set(handles.rb_id,'Value', 1);
show_disturbance(handles);


function edt_id_amplitude_Callback(hObject, eventdata, handles)

set(handles.rb_id,'Value', 1);
show_disturbance(handles);


function edt_therm_tconstant_Callback(hObject, eventdata, handles)

set(handles.rb_therm,'Value', 1);
show_disturbance(handles);


function edt_therm_amplitude_Callback(hObject, eventdata, handles)

set(handles.rb_therm,'Value', 1);
show_disturbance(handles);


function rb_Callback(hObject, eventdata, handles)

if get(hObject,'Value')
    show_disturbance(handles);
else
    set(hObject,'Value', 1);
end