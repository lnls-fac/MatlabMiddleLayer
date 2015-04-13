function varargout = fofbsim_help(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fofbsim_help_OpeningFcn, ...
                   'gui_OutputFcn',  @fofbsim_help_OutputFcn, ...
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


% --- Executes just before fofbsim_help is made visible.
function fofbsim_help_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for fofbsim_help
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

try
    img = imread('simulation_model.bmp');
catch
    errordlg('The simulation model figure file was not found or is corrupted.', 'Error');
    close(hObject);    
end

image(img);
axis('off');
axis('image');


% --- Outputs from this function are returned to the command line.
function varargout = fofbsim_help_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;
