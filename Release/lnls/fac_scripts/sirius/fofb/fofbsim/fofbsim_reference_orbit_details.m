function varargout = fofbsim_reference_orbit_details(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fofbsim_reference_orbit_details_OpeningFcn, ...
                   'gui_OutputFcn',  @fofbsim_reference_orbit_details_OutputFcn, ...
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


% --- Executes just before fofbsim_reference_orbit_details is made visible.
function fofbsim_reference_orbit_details_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for fofbsim_reference_orbit_details
handles.output = hObject;

% Load simulation parameters from the FOFBSim main figure and stores it in the present figure
if ~isempty(varargin{1}.config.beam_response_matrix)
    handles.reference_orbit = varargin{1}.config.beam_reference_orbit;
    handles.n_bpm = size(varargin{1}.config.beam_response_matrix, 1);
    handles.n_horizontal_bpm = varargin{1}.config.n_horizontal_bpm;
else
    handles.reference_orbit = [];
    handles.n_bpm = 1;
    handles.n_horizontal_bpm = 1;
end

% Save FOFBSim main figure handle
handles.parent_window_handles = varargin{1};

update_figure(handles);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = fofbsim_reference_orbit_details_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% === CALLBACK FUNCTIONS ===

function btn_open_file_Callback(hObject, eventdata, handles)

[filename, pathname] = uigetfile('*.mat', 'Load reference orbit');

if filename
    try
        loaded_variables = load([pathname filename]);

        field_names = fieldnames(loaded_variables);
        if length(field_names) == 0
            throw(MException('fofbsim:btn_open_filename_Callback:empty_file', 'The .mat file has no variables.'));
        elseif length(field_names) > 1
            if ~isfield(loaded_variables, 'reference_orbit')
                throw(MException('fofbsim:btn_open_filename_Callback:no_reference_orbit', 'The .mat file has more than one variable. The reference orbit must be stored in a variable called ''reference_orbit''.'));
            else
                reference_orbit = loaded_variables.reference_orbit;
            end
        else
            reference_orbit = getfield(loaded_variables, field_names{1});
        end
        
        if isempty(reference_orbit) || ~isnumeric(reference_orbit)
            throw(MException('fofbsim:btn_open_filename_Callback:invalid_reference_orbit', 'Invalid reference_orbit'));
        end
        
        if length(reference_orbit) ~= handles.n_bpm
            throw(MException('fofbsim:btn_open_filename_Callback:reference_orbit_wrong_size', 'Reference orbit must contain the same number of elements than BPM readings in the response matrix.'));
        end
        
        set(handles.edt_reference_orbit_filename, 'String', [pathname filename]);
        
        handles.reference_orbit = reference_orbit;
        guidata(handles.reference_orbit_details_window, handles);
        
        update_figure(handles);
    catch err
        errordlg(['Cannot load reference orbit. ' err.message], 'Error');
        return;
    end
end


function btn_reset_Callback(hObject, eventdata, handles)

handles.reference_orbit = [];
guidata(handles.reference_orbit_details_window, handles);

set(handles.edt_reference_orbit_filename, 'String', '');

update_figure(handles);


function btn_cancel_Callback(hObject, eventdata, handles)

delete(handles.reference_orbit_details_window);


function btn_ok_Callback(hObject, eventdata, handles)

handles.parent_window_handles.config.beam_reference_orbit = handles.reference_orbit;

guidata(handles.parent_window_handles.main_figure, handles.parent_window_handles);

delete(handles.reference_orbit_details_window);

% ==========================


% === FUNCTIONS ===

function update_figure(handles)

if isempty(handles.reference_orbit)
    set(handles.txt_loaded_reference_orbit, 'String', 'default (zero)');
    reference_orbit = zeros(1, handles.n_bpm);
else
    set(handles.txt_loaded_reference_orbit, 'String', 'loaded');
    reference_orbit = handles.reference_orbit;    
end

plot(handles.ax_reference_orbit_h, reference_orbit(1:handles.n_horizontal_bpm), 'bs-');
xlabel(handles.ax_reference_orbit_h, 'BPM number');
ylabel(handles.ax_reference_orbit_h, 'Horizontal orbit (mm)');
grid(handles.ax_reference_orbit_h, 'on');
plot(handles.ax_reference_orbit_v, reference_orbit(handles.n_horizontal_bpm+1:end), 'rs-');
xlabel(handles.ax_reference_orbit_v, 'BPM number');
ylabel(handles.ax_reference_orbit_v, 'Vertical orbit (mm)');
grid(handles.ax_reference_orbit_v, 'on');

% =================