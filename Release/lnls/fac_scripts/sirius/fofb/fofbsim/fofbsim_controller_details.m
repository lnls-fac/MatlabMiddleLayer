function varargout = fofbsim_controller_details(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fofbsim_controller_details_OpeningFcn, ...
                   'gui_OutputFcn',  @fofbsim_controller_details_OutputFcn, ...
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


% --- Executes just before fofbsim_controller_details is made visible.
function fofbsim_controller_details_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for fofbsim_controller_details
handles.output = hObject;

handles.ps_update_rate = varargin{1}.config.ps_update_rate;
handles.controller_config = varargin{1}.controller_config;

update_controls(handles);

% Save FOFBSim main figure handle
handles.parent_window_handles = varargin{1};
    
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = fofbsim_controller_details_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% === FUNCTIONS ===

function update_controls(handles)

% Load controller configuration
controller_config = handles.controller_config;

write_controller_config_to_figure(handles, controller_config);


% Load controller configuration from the user's interface
function controller_config = read_controller_config_from_figure(handles)

if get(handles.rb_pid, 'Value') 
    selected_controller = 'pid';
elseif get(handles.rb_tf, 'Value')
    selected_controller = 'tf';
end

controller_config = struct('selected_controller', selected_controller, ...
    'pid_Kp', str2num(get(handles.edt_pid_Kp, 'String')), ...
    'pid_Ki', str2num(get(handles.edt_pid_Ki, 'String')), ...
    'pid_Kd', str2num(get(handles.edt_pid_Kd, 'String')), ...
    'tf_num', str2num(get(handles.edt_tf_num, 'String')), ...
    'tf_den', str2num(get(handles.edt_tf_den, 'String')));


% Load controller configuration to the user's interface
function write_controller_config_to_figure(handles, controller_config)

switch  controller_config.selected_controller
    case 'pid'
        set(handles.rb_pid, 'Value', 1);
        set(handles.rb_tf, 'Value', 0);
    case 'tf'
        set(handles.rb_pid, 'Value', 0);
        set(handles.rb_tf, 'Value', 1);
end

set(handles.edt_pid_Kp, 'String', mat2str(controller_config.pid_Kp));
set(handles.edt_pid_Ki, 'String', mat2str(controller_config.pid_Ki));
set(handles.edt_pid_Kd, 'String', num2str(controller_config.pid_Kd));
set(handles.edt_tf_num, 'String', mat2str(controller_config.tf_num));
set(handles.edt_tf_den, 'String', mat2str(controller_config.tf_den));

% =================


% --- Executes on button press in btn_ok.
function btn_ok_Callback(hObject, eventdata, handles)

try
    handles.parent_window_handles.controller_config = read_controller_config_from_figure(handles);
    guidata(handles.parent_window_handles.main_figure, handles.parent_window_handles);
    delete(handles.controller_details_window);
catch err
    errordlg(err.message, 'Error');
end


% --- Executes on button press in pushbutton2.
function btn_cancel_Callback(hObject, eventdata, handles)

delete(handles.controller_details_window);