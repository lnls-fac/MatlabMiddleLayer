function varargout = fofbsim_response_matrix_details(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fofbsim_response_matrix_details_OpeningFcn, ...
                   'gui_OutputFcn',  @fofbsim_response_matrix_details_OutputFcn, ...
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


% --- Executes just before fofbsim_response_matrix_details is made visible.
function fofbsim_response_matrix_details_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for fofbsim_response_matrix_details
handles.output = hObject;

% Load simulation parameters from the FOFBSim main figure and stores it in the present figure
handles.response_matrix = varargin{1}.config.beam_response_matrix;
handles.n_horizontal_bpm = varargin{1}.config.n_horizontal_bpm;
handles.n_horizontal_corr = varargin{1}.config.n_horizontal_corr;

% Save FOFBSim main figure handle
handles.parent_window_handles = varargin{1};

update_figure(handles);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = fofbsim_response_matrix_details_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% === CALLBACK FUNCTIONS ===

function sld_bpm_proportion_Callback(hObject, eventdata, handles)

n_bpm = size(handles.response_matrix,1);
handles.n_horizontal_bpm = floor((1-get(handles.sld_bpm_proportion, 'Value'))*n_bpm);
guidata(handles.response_matrix_details_window, handles);
update_controls(handles);


function sld_corr_proportion_Callback(hObject, eventdata, handles)

n_corr = size(handles.response_matrix,2);
handles.n_horizontal_corr = floor((1-get(handles.sld_corr_proportion, 'Value'))*n_corr);
guidata(handles.response_matrix_details_window, handles);
update_controls(handles);


function edt_horizontal_bpm_Callback(hObject, eventdata, handles)

n_bpm = size(handles.response_matrix,1);

n_horizontal_bpm = str2num(get(handles.edt_horizontal_bpm, 'String'));

if isempty(n_horizontal_bpm) || ~isnumeric(n_horizontal_bpm) || ~isscalar(n_horizontal_bpm)
    errordlg('The number of horizontal BPMs is not valid.', 'Error');
elseif (n_horizontal_bpm < 0)
    errordlg('The number of horizontal BPMs must be greater than or equal to 0.', 'Error');
elseif (n_horizontal_bpm > n_bpm)
    errordlg('The number of horizontal BPMs must be shorter than or equal to the total number of BPMs.', 'Error');
else
    handles.n_horizontal_bpm = n_horizontal_bpm;
    guidata(handles.response_matrix_details_window, handles);
    update_controls(handles);
end


function edt_vertical_bpm_Callback(hObject, eventdata, handles)

n_bpm = size(handles.response_matrix,2);

n_vertical_bpm = str2num(get(handles.edt_vertical_bpm, 'String'));

if isempty(n_vertical_bpm) || ~isnumeric(n_vertical_bpm) || ~isscalar(n_vertical_bpm)
    errordlg('The number of vertical BPMs is not valid.', 'Error');
elseif (n_vertical_bpm < 0)
    errordlg('The number of vertical BPMs must be greater than or equal to 0.', 'Error');
elseif (n_vertical_bpm > n_bpm)
    errordlg('The number of vertical BPMs must be shorter than or equal to the total number of BPMs.', 'Error');
else
    handles.n_horizontal_bpm = ceil(n_bpm - n_vertical_bpm);
    guidata(handles.response_matrix_details_window, handles);
    update_controls(handles);
end

function edt_horizontal_corr_Callback(hObject, eventdata, handles)

n_corr = size(handles.response_matrix,2);

n_horizontal_corr = str2num(get(handles.edt_horizontal_corr, 'String'));

if isempty(n_horizontal_corr) || ~isnumeric(n_horizontal_corr) || ~isscalar(n_horizontal_corr)
    errordlg('The number of horizontal correctors is not valid.', 'Error');
elseif (n_horizontal_corr < 0)
    errordlg('The number of horizontal correctors must be greater than or equal to 0.', 'Error');
elseif (n_horizontal_corr > n_corr)
    errordlg('The number of horizontal correctors must be shorter than or equal to the total number of correctors.', 'Error');
else
    handles.n_horizontal_corr = n_horizontal_corr;
    guidata(handles.response_matrix_details_window, handles);
    update_controls(handles);
end


function edt_vertical_corr_Callback(hObject, eventdata, handles)

n_corr = size(handles.response_matrix,2);

n_vertical_corr = str2num(get(handles.edt_vertical_corr, 'String'));

if isempty(n_vertical_corr) || ~isnumeric(n_vertical_corr) || ~isscalar(n_vertical_corr)
    errordlg('The number of vertical correctors is not valid.', 'Error');
elseif (n_vertical_corr < 0)
    errordlg('The number of vertical correctors must be greater than or equal to 0.', 'Error');
elseif (n_vertical_corr > n_corr)
    errordlg('The number of vertical correctors must be shorter than or equal to the total number of correctors.', 'Error');
else
    handles.n_horizontal_corr = ceil(n_corr - n_vertical_corr);
    guidata(handles.response_matrix_details_window, handles);
    update_controls(handles);
end


function btn_open_file_Callback(hObject, eventdata, handles)

[filename, pathname] = uigetfile('*.mat', 'Load response matrix');

if filename
    try
        loaded_variables = load([pathname filename]);

        field_names = fieldnames(loaded_variables);
        if isempty(field_names)
            throw(MException('fofbsim:btn_open_filename_Callback:empty_file', 'The .mat file has no variables.'));
        elseif length(field_names) > 1
            if ~isfield(loaded_variables, 'response_matrix')
                throw(MException('fofbsim:btn_open_filename_Callback:no_response_matrix', 'The .mat file has more than one variable. The matrix response must be stored in a variable called ''response_matrix''.'));
            else
                response_matrix = loaded_variables.response_matrix;
            end
        else
            response_matrix = getfield(loaded_variables, field_names{1});
        end
        
        if isempty(response_matrix) || ~isnumeric(response_matrix)
            throw(MException('fofbsim:btn_open_filename_Callback:invalid_response_matrix', 'Invalid response matrix'));
        end
        
        set(handles.edt_response_matrix_filename, 'String', [pathname filename]);
        
        handles.response_matrix = response_matrix;
        [handles.n_horizontal_bpm, handles.n_horizontal_corr] = get_h_v_planes(handles.response_matrix);
        guidata(handles.response_matrix_details_window, handles);
        
        update_figure(handles);
        update_controls(handles);
    catch err
        errordlg(['Cannot load response matrix. ' err.message], 'Error');
        return;
    end
end


function btn_reset_Callback(hObject, eventdata, handles)

handles.response_matrix = [];
handles.n_horizontal_bpm = 1;
handles.n_horizontal_corr = 1;
guidata(handles.response_matrix_details_window, handles);

set(handles.edt_response_matrix_filename, 'String', '');

update_figure(handles);
update_controls(handles);


function btn_cancel_Callback(hObject, eventdata, handles)

delete(handles.response_matrix_details_window);


function btn_ok_Callback(hObject, eventdata, handles)

handles.parent_window_handles.config.beam_response_matrix = handles.response_matrix;
handles.parent_window_handles.config.n_horizontal_bpm = handles.n_horizontal_bpm;
handles.parent_window_handles.config.n_horizontal_corr = handles.n_horizontal_corr;

guidata(handles.parent_window_handles.main_figure, handles.parent_window_handles);

delete(handles.response_matrix_details_window);

% ==========================


% === FUNCTIONS ===

function update_figure(handles)

if isempty(handles.response_matrix)
    set(handles.txt_loaded_response_matrix, 'String', 'not loaded');
    set(handles.txt_loaded_response_matrix, 'ForegroundColor', [1 0 0]);
    set(handles.txt_loaded_response_matrix, 'FontWeight', 'bold');

    set(handles.sld_bpm_proportion, 'Enable', 'off');
    set(handles.edt_horizontal_bpm, 'Enable', 'off');
    set(handles.edt_vertical_bpm, 'Enable', 'off');

    set(handles.sld_corr_proportion, 'Enable', 'off');
    set(handles.edt_horizontal_corr, 'Enable', 'off');
    set(handles.edt_vertical_corr, 'Enable', 'off');
    
    surfstairs(handles.ax_response_matrix, 1);
    xlabel('BPMs');
    ylabel('Correctors');    

else
    [n_bpm, n_corr] = size(handles.response_matrix);
    
    set(handles.txt_loaded_response_matrix, 'String', ['BPMs: ' num2str(n_bpm) '     Correctors: ' num2str(n_corr)]);
    set(handles.txt_loaded_response_matrix, 'ForegroundColor', [0 0 0]);
    set(handles.txt_loaded_response_matrix, 'FontWeight', 'normal');
    
    n_horizontal_bpm = handles.n_horizontal_bpm;
    n_vertical_bpm = n_bpm - n_horizontal_bpm;
    bpm_proportion = n_horizontal_bpm/n_bpm;
    
    set(handles.edt_horizontal_bpm, 'String', num2str(n_horizontal_bpm));
    set(handles.edt_vertical_bpm, 'String', num2str(n_vertical_bpm));
    set(handles.sld_bpm_proportion, 'Value', 1-bpm_proportion);
    set(handles.sld_bpm_proportion, 'SliderStep', [1/n_bpm 1/n_bpm*5]);
    
    set(handles.sld_bpm_proportion, 'Enable', 'on');
    set(handles.edt_horizontal_bpm, 'Enable', 'on');
    set(handles.edt_vertical_bpm, 'Enable', 'on');

    n_horizontal_corr = handles.n_horizontal_corr;
    n_vertical_corr = n_corr - n_horizontal_corr;
    corr_proportion = n_horizontal_corr/n_corr;
    
    set(handles.edt_horizontal_corr, 'String', num2str(n_horizontal_corr));
    set(handles.edt_vertical_corr, 'String', num2str(n_vertical_corr));
    set(handles.sld_corr_proportion, 'Value', 1-corr_proportion);
    set(handles.sld_corr_proportion, 'SliderStep', [1/n_corr 1/n_corr*5]);
    
    set(handles.sld_corr_proportion, 'Enable', 'on');
    set(handles.edt_horizontal_corr, 'Enable', 'on');
    set(handles.edt_vertical_corr, 'Enable', 'on');
    
    surfstairs(handles.ax_response_matrix, handles.response_matrix');
    view([60 30]);
    axis('image');
    xlabel('BPMs');
    ylabel('Correctors');
end


function update_controls(handles)

if ~isempty(handles.response_matrix)
    [n_bpm, n_corr] = size(handles.response_matrix);
else
    n_bpm = 1;
    n_corr = 1;
end
    
n_horizontal_bpm = handles.n_horizontal_bpm;
n_vertical_bpm = n_bpm - n_horizontal_bpm;

set(handles.edt_horizontal_bpm, 'String', num2str(n_horizontal_bpm));
set(handles.edt_vertical_bpm, 'String', num2str(n_vertical_bpm));
set(handles.sld_bpm_proportion, 'Value', 1-n_horizontal_bpm/n_bpm);

n_horizontal_corr = handles.n_horizontal_corr;
n_vertical_corr = n_corr - n_horizontal_corr;

set(handles.edt_horizontal_corr, 'String', num2str(n_horizontal_corr));
set(handles.edt_vertical_corr, 'String', num2str(n_vertical_corr));
set(handles.sld_corr_proportion, 'Value', 1-n_horizontal_corr/n_corr);


function [n_horizontal_bpms, n_horizontal_corr] = get_h_v_planes(response_matrix)

tol = 1e3*eps;
[n_bpm, n_corr] = size(response_matrix);

if isnumeric(response_matrix) && ~isempty(response_matrix)
    if length(response_matrix) == 1
        n_horizontal_corr = 1;
        n_horizontal_bpms = 1; 
    else
        for i_bpm = floor(n_bpm/2):n_bpm-1
            for i_corr = floor(n_corr/2):n_corr-1
                if all(~any(abs(response_matrix(i_bpm+1:end,1:i_corr)) > tol)) && all(~any(abs(response_matrix(1:i_bpm,i_corr+1:end)) > tol))
                    n_horizontal_corr = i_corr;
                    n_horizontal_bpms = i_bpm;
                    return;
                end
            end
            for i_corr = floor(n_corr/2)-1:-1:1
                if all(~any(abs(response_matrix(i_bpm+1:end,1:i_corr)) > tol)) && all(~any(abs(response_matrix(1:i_bpm,i_corr+1:end)) > tol))
                    n_horizontal_corr = i_corr;
                    n_horizontal_bpms = i_bpm;
                    return;
                end
            end
        end
        for i_bpm = floor(n_bpm/2)-1:-1:1
            for i_corr = floor(n_corr/2):n_corr-1
                if all(~any(abs(response_matrix(i_bpm+1:end,1:i_corr)) > tol)) && all(~any(abs(response_matrix(1:i_bpm,i_corr+1:end)) > tol))
                    n_horizontal_corr = i_corr;
                    n_horizontal_bpms = i_bpm;
                    return;
                end
            end
            for i_corr = floor(n_corr/2)-1:-1:1
                if all(~any(abs(response_matrix(i_bpm+1:end,1:i_corr)) > tol)) && all(~any(abs(response_matrix(1:i_bpm,i_corr+1:end)) > tol))
                    n_horizontal_corr = i_corr;
                    n_horizontal_bpms = i_bpm;
                    return;
                end
            end        
        end

        n_horizontal_corr = n_corr;
        n_horizontal_bpms = n_bpm;
    end
else
    n_horizontal_corr = [];
    n_horizontal_bpms = [];
end

% =================