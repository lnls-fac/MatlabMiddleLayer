function varargout = fofbsim_correction_matrix_details(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fofbsim_correction_matrix_details_OpeningFcn, ...
                   'gui_OutputFcn',  @fofbsim_correction_matrix_details_OutputFcn, ...
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


% --- Executes just before fofbsim_correction_matrix_details is made visible.
function fofbsim_correction_matrix_details_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for fofbsim_correction_matrix_details
handles.output = hObject;

% Calculate correction matrix singular values
if ~isempty(varargin{1}.config.beam_response_matrix)
    [U,V,W] = svd(varargin{1}.config.beam_response_matrix, 'econ');
    handles.singular_values = diag(V);
else
    handles.singular_values = 1;
end

% Save FOFBSim main figure handle
handles.parent_window_handles = varargin{1};

update_figure(handles);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = fofbsim_correction_matrix_details_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% === FUNCTIONS ===

function update_figure(handles)

stem(handles.ax_singular_values, 1:length(handles.singular_values), handles.singular_values, '.');
% hold on
% stairs(handles.ax_singular_values, 1:length(handles.singular_values), handles.singular_values);
xlabel(handles.ax_singular_values, 'Singular values');
ylabel(handles.ax_singular_values, 'a.u.');
grid(handles.ax_singular_values, 'on');

% =================
