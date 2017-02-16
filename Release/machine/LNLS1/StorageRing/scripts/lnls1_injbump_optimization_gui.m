function varargout = lnls1_injbump_optimization_gui(varargin)
%Optimiza bump de injeção (GUI)
%
%      lnls1_injbump_optimization_gui M-file for lnls1_injbump_optimization_gui.fig
%      lnls1_injbump_optimization_gui, by itself, creates a new lnls1_injbump_optimization_gui or raises the existing
%      singleton*.
%
%      H = lnls1_injbump_optimization_gui returns the handle to a new lnls1_injbump_optimization_gui or the handle to
%      the existing singleton*.
%
%      lnls1_injbump_optimization_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in lnls1_injbump_optimization_gui.M with the given input arguments.
%
%      lnls1_injbump_optimization_gui('Property','Value',...) creates a new lnls1_injbump_optimization_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the lnls1_injbump_optimization_gui before lnls1_injbump_optimization_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lnls1_injbump_optimization_gui_OpeningFcn via varargin.
%
%      *See lnls1_injbump_optimization_gui Options on GUIDE's Tools menu.  Choose "lnls1_injbump_optimization_gui allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lnls1_injbump_optimization_gui

% Last Modified by GUIDE v2.5 18-Feb-2010 12:20:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lnls1_injbump_optimization_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @lnls1_injbump_optimization_gui_OutputFcn, ...
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


% --- Executes just before lnls1_injbump_optimization_gui is made visible.
function lnls1_injbump_optimization_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lnls1_injbump_optimization_gui (see VARARGIN)

% Choose default command line output for lnls1_injbump_optimization_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global point_parms;

point_parms = [18 18 18 0 0 0 0 10 10]';
abort_flag = false;

% UIWAIT makes lnls1_injbump_optimization_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lnls1_injbump_optimization_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_akc02_V_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc02_V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc02_V as text
%        str2double(get(hObject,'String')) returns contents of edit_akc02_V as a double


% --- Executes during object creation, after setting all properties.
function edit_akc02_V_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc02_V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc03_V_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc04_V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc04_V as text
%        str2double(get(hObject,'String')) returns contents of edit_akc04_V as a double


% --- Executes during object creation, after setting all properties.
function edit_akc03_V_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc04_V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc04_V_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc03_V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc03_V as text
%        str2double(get(hObject,'String')) returns contents of edit_akc03_V as a double


% --- Executes during object creation, after setting all properties.
function edit_akc04_V_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc03_V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc02_T_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc04_V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc04_V as text
%        str2double(get(hObject,'String')) returns contents of edit_akc04_V as a double


% --- Executes during object creation, after setting all properties.
function edit_akc02_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc04_V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc03_T_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc04_V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc04_V as text
%        str2double(get(hObject,'String')) returns contents of edit_akc04_V as a double


% --- Executes during object creation, after setting all properties.
function edit_akc03_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc04_V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc04_T_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc04_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc04_T as text
%        str2double(get(hObject,'String')) returns contents of edit_akc04_T as a double


% --- Executes during object creation, after setting all properties.
function edit_akc04_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc04_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_start.
function button_start_Callback(hObject, eventdata, handles)
% hObject    handle to button_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Initialization

set(handles.pushbutton_plot_waveforms, 'Enable', 'Off');
set(handles.pushbutton_save, 'Enable', 'Off');

evalin('base', 'clear injbump_abort_flag');

global obj_state;

if strcmpi(get(handles.button_start, 'String'), 'ABORT')
    
    assignin('base', 'injbump_abort_flag', true);
    
    set(handles.button_start, 'String', 'START');
    set(handles.button_start, 'ForegroundColor', 'black');
    objnames = fieldnames(handles);
    for i=1:length(objnames)
        obj = objnames{i};
        try
            set(handles.(obj), 'Enable', obj_state.(obj));
        catch
        end
    end
    
    return;
    
end

%% Disable Start and Enable Abort

objnames = fieldnames(handles);
for i=1:length(objnames)
    obj = objnames{i};
    try
        obj_state.(obj) = get(handles.(obj), 'Enable');
        set(handles.(obj), 'Enable', 'Off');
    
    catch
    end
end

set(handles.button_start, 'String', 'ABORT');
set(handles.button_start, 'ForegroundColor', 'red');
set(handles.button_start, 'Enable', 'On');

drawnow;
refresh;

%% Max Tension Verification

if str2double(get(handles.edit_akc02_1,'String')) > str2double(get(handles.edit_max_voltage, 'String'))
    set(handles.edit_akc02_1, 'String', get(handles.edit_max_voltage, 'String'));
end

if str2double(get(handles.edit_akc03_1,'String')) > str2double(get(handles.edit_max_voltage, 'String'))
    set(handles.edit_akc03_1, 'String', get(handles.edit_max_voltage, 'String'));
end

if str2double(get(handles.edit_akc04_1,'String')) > str2double(get(handles.edit_max_voltage, 'String'))
    set(handles.edit_akc04_1, 'String', get(handles.edit_max_voltage, 'String'));
end
%% Optimization settings

% Parametros de otimizacao
input_parms.nr_pts             = str2double(get(handles.edit_nr_pts,'String'));
input_parms.nr_pts_avg         = str2double(get(handles.edit_nr_pts_avg,'String'));
input_parms.max_kicker_voltage = str2double(get(handles.edit_max_voltage,'String'));

% Intervalo de importancia
if (get(handles.checkbox_entire_interval,'Value')) == (get(handles.checkbox_entire_interval,'Max'))
    input_parms.data_range_libera = [1 str2double(get(handles.edit_nr_samples,'String'))];
else
    input_parms.data_range_libera = [round(str2double(get(handles.edit_idx1,'String'))) round(str2double(get(handles.edit_idx2,'String')))];
end

%% Simulation Settings

global point_parms;

input_parms.sim_point_parms = point_parms;


%% plot

% Definido pelo checkbox
if (get(handles.checkbox_plot,'Value')) == (get(handles.checkbox_plot,'Max'))
    input_parms.plot = true;
else
    input_parms.plot = false;
end

%% Method

% Definido pelos radiobuttons
if (get(handles.radiobutton_simulated_annealing,'Value')) == (get(handles.radiobutton_simulated_annealing,'Max'))
    input_parms.method = 'sim_annealing';
elseif (get(handles.radiobutton_single_parameter_scan,'Value')) == (get(handles.radiobutton_single_parameter_scan,'Max'))
    input_parms.method = 'parms_scan';
elseif (get(handles.radiobutton_svd,'Value')) == (get(handles.radiobutton_svd,'Max'))
    input_parms.method = 'svd_response_matrix';
end



%% Simulated Annealing Settings

input_parms.parms_delta(1) = str2double(get(handles.edit_akc02_V,'String')) ;
input_parms.parms_delta(2) = str2double(get(handles.edit_akc03_V,'String')) ;
input_parms.parms_delta(3) = str2double(get(handles.edit_akc04_V,'String')) ;
input_parms.parms_delta(4) = str2double(get(handles.edit_akc02_T,'String')) ;
input_parms.parms_delta(5) = str2double(get(handles.edit_akc03_T,'String')) ;
input_parms.parms_delta(6) = str2double(get(handles.edit_akc04_T,'String')) ;

%% Single Parameter Scan Settings

comp_array                  = get(handles.popupmenu_parameter_to_scan, 'String');
selected_item               = get(handles.popupmenu_parameter_to_scan, 'Value');

input_parms.scan_component  = comp_array{selected_item};
input_parms.scan_interval   = [str2double(get(handles.edit_scan_ini,'String')) str2double(get(handles.edit_scan_end,'String'))];



%% Mode

if (get(handles.radiobutton_online,'Value')) == (get(handles.radiobutton_online,'Max'))
    input_parms.mode = 'online';
else
    input_parms.mode = 'sim';
end


%% Libera Settings

input_parms.ip               = (get(handles.edit_ip,'String'));
input_parms.nr_pts_libera    = str2double((get(handles.edit_nr_samples,'String')));
input_parms.file_name        = (get(handles.edit_filename,'String'));
input_parms.local_dir        = (get(handles.edit_localdir,'String'));
input_parms.username         = (get(handles.edit_username,'String'));
input_parms.password         = (get(handles.edit_password,'String'));
input_parms.t4erexec         = (get(handles.edit_program_dir,'String'));

%% Call Function


try
    r = lnls1_injbump_optimization(input_parms);
    assignin('base','Injbump_optimization_data', r);    
catch
    le = lasterror;
    
    tmpstr1 = 'medida injbump abortada!';
    tmpstr2 = 'time out na espera do arquivo do libera';
    
    if strcmpi(le.message(end-length(tmpstr1)+1:end),tmpstr1)
        msgbox('Medida Abortada','Erro','error');
    elseif strcmpi(le.message(end-length(tmpstr2)+1:end),tmpstr2)
        msgbox('Time-out na espera do arquivo do libera','Erro','error');        
    else
        msgbox('Erro na execucao do script injbump_optimization.m','Erro','error');
    end
end

%%


set(handles.button_start, 'String', 'START');
set(handles.button_start, 'ForegroundColor', 'black');
objnames = fieldnames(handles);
for i=1:length(objnames)
    obj = objnames{i};
    try
        set(handles.(obj), 'Enable', obj_state.(obj));
    catch
    end
end

    

%% Enable plot and save
if ~exist('le','var')
    set(handles.pushbutton_plot_waveforms, 'Enable', 'On');
    set(handles.pushbutton_save, 'Enable', 'On');
end

%% 

if exist('le', 'var'), rethrow(le); end


function edit_nr_pts_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nr_pts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nr_pts as text
%        str2double(get(hObject,'String')) returns contents of edit_nr_pts as a double


% --- Executes during object creation, after setting all properties.
function edit_nr_pts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nr_pts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nr_pts_avg_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nr_pts_avg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nr_pts_avg as text
%        str2double(get(hObject,'String')) returns contents of edit_nr_pts_avg as a double


% --- Executes during object creation, after setting all properties.
function edit_nr_pts_avg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nr_pts_avg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_plot.
function checkbox_plot_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_plot


% --- Executes on button press in pushbutton_get_parms.
function pushbutton_get_parms_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_get_parms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.radiobutton_online,'Value')) == (get(handles.radiobutton_online,'Max'))
    switch2online;
    set(handles.edit_akc02_1, 'String', getpv('AKC02_SP'));
    set(handles.edit_akc03_1, 'String', getpv('AKC03_SP'));
    set(handles.edit_akc04_1, 'String', getpv('AKC04_SP'));
    if (get(handles.radiobutton_total_delay,'Value')) == (get(handles.radiobutton_total_delay,'Max'))
        set(handles.edit_akc02_2, 'String', lnls1_booster_GF2delay(getpv('AKC02_AG_SP'),getpv('AKC02_AF_SP')));
        set(handles.edit_akc03_2, 'String', lnls1_booster_GF2delay(getpv('AKC03_AG_SP'),getpv('AKC03_AF_SP')));
        set(handles.edit_akc04_2, 'String', lnls1_booster_GF2delay(getpv('AKC04_AG_SP'),getpv('AKC04_AF_SP')));
    else
        set(handles.edit_akc02_2, 'String', getpv('AKC02_AG_SP'));
        set(handles.edit_akc03_2, 'String', getpv('AKC03_AG_SP'));
        set(handles.edit_akc04_2, 'String', getpv('AKC04_AG_SP'));
        set(handles.edit_akc02_3, 'String', getpv('AKC02_AF_SP'));
        set(handles.edit_akc03_3, 'String', getpv('AKC03_AF_SP'));
        set(handles.edit_akc04_3, 'String', getpv('AKC04_AF_SP'));
    end
end

if (get(handles.radiobutton_sim,'Value')) == (get(handles.radiobutton_sim,'Max'))
    switch2sim;
    set(handles.edit_akc02_1, 'String', lnls1_injbump_optimization('injbump_getpv', 'AKC02_SP'));
    set(handles.edit_akc03_1, 'String', lnls1_injbump_optimization('injbump_getpv', 'AKC03_SP'));
    set(handles.edit_akc04_1, 'String', lnls1_injbump_optimization('injbump_getpv', 'AKC04_SP'));
    if (get(handles.radiobutton_total_delay,'Value')) == (get(handles.radiobutton_total_delay,'Max'))
        set(handles.edit_akc02_2, 'String', lnls1_booster_GF2delay(lnls1_injbump_optimization('injbump_getpv', 'AKC02_AG_SP'),lnls1_injbump_optimization('injbump_getpv', 'AKC02_AF_SP')));
        set(handles.edit_akc03_2, 'String', lnls1_booster_GF2delay(lnls1_injbump_optimization('injbump_getpv', 'AKC03_AG_SP'),lnls1_injbump_optimization('injbump_getpv', 'AKC03_AF_SP')));
        set(handles.edit_akc04_2, 'String', lnls1_booster_GF2delay(lnls1_injbump_optimization('injbump_getpv', 'AKC04_AG_SP'),lnls1_injbump_optimization('injbump_getpv', 'AKC04_AF_SP')));
    else
        set(handles.edit_akc02_2, 'String', lnls1_injbump_optimization('injbump_getpv','AKC02_AG_SP'));
        set(handles.edit_akc03_2, 'String', lnls1_injbump_optimization('injbump_getpv','AKC03_AG_SP'));
        set(handles.edit_akc04_2, 'String', lnls1_injbump_optimization('injbump_getpv','AKC04_AG_SP'));
        set(handles.edit_akc02_3, 'String', lnls1_injbump_optimization('injbump_getpv','AKC02_AF_SP'));
        set(handles.edit_akc03_3, 'String', lnls1_injbump_optimization('injbump_getpv','AKC03_AF_SP'));
        set(handles.edit_akc04_3, 'String', lnls1_injbump_optimization('injbump_getpv','AKC04_AF_SP'));
    end
end

% --- Executes on button press in pushbutton_set_parms.
function pushbutton_set_parms_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_set_parms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.radiobutton_online,'Value')) == (get(handles.radiobutton_online,'Max'))
    setpv('AKC02_SP',str2double(get(handles.edit_akc02_1, 'String')));
    setpv('AKC03_SP',str2double(get(handles.edit_akc03_1, 'String')));
    setpv('AKC04_SP',str2double(get(handles.edit_akc04_1, 'String')));
    if (get(handles.radiobutton_total_delay,'Value')) == (get(handles.radiobutton_total_delay,'Max'))
        [G F] = lnls1_booster_delay2GF(str2double(get(handles.edit_akc02_2, 'String')));
        setpv('AKC02_AG_SP',G);
        setpv('AKC02_AF_SP',F);
        [G F] = lnls1_booster_delay2GF(str2double(get(handles.edit_akc03_2, 'String')));
        setpv('AKC03_AG_SP',G);
        setpv('AKC03_AF_SP',F);
        [G F] = lnls1_booster_delay2GF(str2double(get(handles.edit_akc04_2, 'String')));
        setpv('AKC04_AG_SP',G);
        setpv('AKC04_AF_SP',F);
    else
        setpv('AKC02_AG_SP',str2double(get(handles.edit_akc02_2, 'String')));
        setpv('AKC02_AG_SP',str2double(get(handles.edit_akc03_2, 'String')));
        setpv('AKC02_AG_SP',str2double(get(handles.edit_akc04_2, 'String')));
        setpv('AKC02_AF_SP',str2double(get(handles.edit_akc02_3, 'String')));
        setpv('AKC03_AF_SP',str2double(get(handles.edit_akc03_3, 'String')));
        setpv('AKC04_AF_SP',str2double(get(handles.edit_akc04_3, 'String')));
    end
end

if (get(handles.radiobutton_sim,'Value')) == (get(handles.radiobutton_sim,'Max'))
    lnls1_injbump_optimization('injbump_setpv', 'AKC02_SP',str2double(get(handles.edit_akc02_1, 'String')));
    lnls1_injbump_optimization('injbump_setpv', 'AKC03_SP',str2double(get(handles.edit_akc03_1, 'String')));
    lnls1_injbump_optimization('injbump_setpv', 'AKC04_SP',str2double(get(handles.edit_akc04_1, 'String')));
    if (get(handles.radiobutton_total_delay,'Value')) == (get(handles.radiobutton_total_delay,'Max'))
        [G F] = lnls1_booster_delay2GF(str2double(get(handles.edit_akc02_2, 'String')));
        lnls1_injbump_optimization('injbump_setpv', 'AKC02_AG_SP',G);
        lnls1_injbump_optimization('injbump_setpv', 'AKC02_AF_SP',F);
        [G F] = lnls1_booster_delay2GF(str2double(get(handles.edit_akc03_2, 'String')));
        lnls1_injbump_optimization('injbump_setpv', 'AKC03_AG_SP',G);
        lnls1_injbump_optimization('injbump_setpv', 'AKC03_AF_SP',F);
        [G F] = lnls1_booster_delay2GF(str2double(get(handles.edit_akc04_2, 'String')));
        lnls1_injbump_optimization('injbump_setpv', 'AKC04_AG_SP',G);
        lnls1_injbump_optimization('injbump_setpv', 'AKC04_AF_SP',F);
    else
        lnls1_injbump_optimization('injbump_setpv', 'AKC02_AG_SP',str2double(get(handles.edit_akc02_2, 'String')));
        lnls1_injbump_optimization('injbump_setpv', 'AKC02_AG_SP',str2double(get(handles.edit_akc03_2, 'String')));
        lnls1_injbump_optimization('injbump_setpv', 'AKC02_AG_SP',str2double(get(handles.edit_akc04_2, 'String')));
        lnls1_injbump_optimization('injbump_setpv', 'AKC02_AF_SP',str2double(get(handles.edit_akc02_3, 'String')));
        lnls1_injbump_optimization('injbump_setpv', 'AKC03_AF_SP',str2double(get(handles.edit_akc03_3, 'String')));
        lnls1_injbump_optimization('injbump_setpv', 'AKC04_AF_SP',str2double(get(handles.edit_akc04_3, 'String')));
    end
end

function edit_akc02_1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc02_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc02_1 as text
%        str2double(get(hObject,'String')) returns contents of edit_akc02_1 as a double
if str2double(get(hObject,'String')) > (handles.edit_max_voltage)
    set(handles.edit_akc02_1, 'String', get(handles.edit_max_voltage, 'String'));
end

% --- Executes during object creation, after setting all properties.
function edit_akc02_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc02_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc02_2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc02_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc02_2 as text
%        str2double(get(hObject,'String')) returns contents of edit_akc02_2 as a double


% --- Executes during object creation, after setting all properties.
function edit_akc02_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc02_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc03_1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc03_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc03_1 as text
%        str2double(get(hObject,'String')) returns contents of edit_akc03_1 as a double


% --- Executes during object creation, after setting all properties.
function edit_akc03_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc03_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc03_2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc03_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc03_2 as text
%        str2double(get(hObject,'String')) returns contents of edit_akc03_2 as a double


% --- Executes during object creation, after setting all properties.
function edit_akc03_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc03_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc04_1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc04_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc04_1 as text
%        str2double(get(hObject,'String')) returns contents of edit_akc04_1 as a double


% --- Executes during object creation, after setting all properties.
function edit_akc04_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc04_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc04_2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc04_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc04_2 as text
%        str2double(get(hObject,'String')) returns contents of edit_akc04_2 as a double


% --- Executes during object creation, after setting all properties.
function edit_akc04_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc04_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc02_3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc02_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc02_3 as text
%        str2double(get(hObject,'String')) returns contents of edit_akc02_3 as a double


% --- Executes during object creation, after setting all properties.
function edit_akc02_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc02_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc03_3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc03_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc03_3 as text
%        str2double(get(hObject,'String')) returns contents of edit_akc03_3 as a double


% --- Executes during object creation, after setting all properties.
function edit_akc03_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc03_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_akc04_3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_akc04_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_akc04_3 as text
%        str2double(get(hObject,'String')) returns contents of edit_akc04_3 as a double


% --- Executes during object creation, after setting all properties.
function edit_akc04_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc04_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_idx1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_idx1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_idx1 as text
%        str2double(get(hObject,'String')) returns contents of edit_idx1 as a double


% --- Executes during object creation, after setting all properties.
function edit_idx1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_idx1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_idx2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_idx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_idx2 as text
%        str2double(get(hObject,'String')) returns contents of edit_idx2 as a double


% --- Executes during object creation, after setting all properties.
function edit_idx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_idx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_entire_interval.
function checkbox_entire_interval_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_entire_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_entire_interval
if get(hObject,'Value') == get(hObject,'Max')
    set(handles.edit_idx1,'Enable','Off');
    set(handles.edit_idx2,'Enable','Off');
else
    set(handles.edit_idx1,'Enable','On');
    set(handles.edit_idx2,'Enable','On');
end


function edit_max_voltage_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max_voltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_max_voltage as text
%        str2double(get(hObject,'String')) returns contents of edit_max_voltage as a double


% --- Executes during object creation, after setting all properties.
function edit_max_voltage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max_voltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_parameter_to_scan.
function popupmenu_parameter_to_scan_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_parameter_to_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_parameter_to_scan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_parameter_to_scan
contents       = get(hObject,'String');
Parameter_name = contents{get(hObject,'Value')};
if strcmp(Parameter_name, 'AKC02_voltage')||strcmp(Parameter_name, 'AKC03_voltage')||strcmp(Parameter_name, 'AKC04_voltage')
    set(handles.text_single_parms_unit,'String', '(kiloVolts)');
else
    set(handles.text_single_parms_unit,'String', '(nanoseconds)');
end
   

% --- Executes during object creation, after setting all properties.
function popupmenu_parameter_to_scan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_parameter_to_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scan_ini_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scan_ini (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scan_ini as text
%        str2double(get(hObject,'String')) returns contents of edit_scan_ini as a double


% --- Executes during object creation, after setting all properties.
function edit_scan_ini_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scan_ini (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scan_end_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scan_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scan_end as text
%        str2double(get(hObject,'String')) returns contents of edit_scan_end as a double


% --- Executes during object creation, after setting all properties.
function edit_scan_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scan_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_step_Callback(hObject, eventdata, handles)
% hObject    handle to edit_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_step as text
%        str2double(get(hObject,'String')) returns contents of edit_step as a double


% --- Executes during object creation, after setting all properties.
function edit_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ip_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ip as text
%        str2double(get(hObject,'String')) returns contents of edit_ip as a double


% --- Executes during object creation, after setting all properties.
function edit_ip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nr_samples_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nr_samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nr_samples as text
%        str2double(get(hObject,'String')) returns contents of edit_nr_samples as a double


% --- Executes during object creation, after setting all properties.
function edit_nr_samples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nr_samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_filename as a double


% --- Executes during object creation, after setting all properties.
function edit_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_localdir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_localdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_localdir as text
%        str2double(get(hObject,'String')) returns contents of edit_localdir as a double


% --- Executes during object creation, after setting all properties.
function edit_localdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_localdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_password_Callback(hObject, eventdata, handles)
% hObject    handle to edit_password (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_password as text
%        str2double(get(hObject,'String')) returns contents of edit_password as a double


% --- Executes during object creation, after setting all properties.
function edit_password_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_password (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_username_Callback(hObject, eventdata, handles)
% hObject    handle to edit_username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_username as text
%        str2double(get(hObject,'String')) returns contents of edit_username as a double


% --- Executes during object creation, after setting all properties.
function edit_username_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_program_dir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_program_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_program_dir as text
%        str2double(get(hObject,'String')) returns contents of edit_program_dir as a double


% --- Executes during object creation, after setting all properties.
function edit_program_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_program_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_quit.
function pushbutton_quit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in pushbutton_plot_waveforms.
function pushbutton_plot_waveforms_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot_waveforms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp          = evalin('base','Injbump_optimization_data');
first_point   = cell2mat(temp.point(1).acq_data);
min_idx       = temp.point_min.idx;
minimum_point = cell2mat(temp.point(min_idx).acq_data);

figure;

subplot(2,1,1)
plot(1:length(first_point), first_point(:,5)/1000,1:length(first_point), first_point(:,6)/1000);
xlabel('Turn');
ylabel('Transversal Position (micrometers) - x(blue) y(green)');
title({'Transversal oscilation after kick - Initial Bump'});

subplot(2,1,2)
plot(1:length(minimum_point), minimum_point(:,5)/1000,1:length(minimum_point), minimum_point(:,6)/1000);
xlabel('Turn');
ylabel('Transversal Position (micrometers) - x(blue) y(green)');
title({'Transversal oscilation after kick - Optimized Bump'});

% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = evalin('base','Injbump_optimization_data');
uisave('temp',['Injbump_data_' datestr(now, 'YYYY-MM-DD_HH-mm-ss')]);

% --- Executes when selected object is changed in panel_analysis_mode.
function panel_analysis_mode_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_analysis_mode 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

panel_libera = [handles.edit_ip handles.edit_nr_samples handles.edit_filename handles.edit_localdir handles.edit_username handles.edit_password handles.edit_program_dir handles.text23 handles.text24 handles.text25 handles.text26 handles.text27 handles.text28 handles.text29]; 
if (get(handles.radiobutton_sim,'Value')) == (get(handles.radiobutton_sim,'Max'))
    set(panel_libera,'Enable','Off');
    set(handles.text_kick_parms, 'String', 'Kick Parameters - Simulation Variable (point_parms)');
else
    set(panel_libera,'Enable','On');
    set(handles.text_kick_parms, 'String', 'Kick Parameters - lnls1_link');
end


% --- Executes when selected object is changed in panel_opt_method.
function panel_opt_method_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_opt_method 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
panel_sim_anneal = [handles.edit_akc02_V handles.edit_akc04_V handles.edit_akc03_V handles.edit_akc04_V handles.edit_akc02_T handles.edit_akc03_T handles.edit_akc04_T handles.text1 handles.text2 handles.text3 handles.text4 handles.text5];
panel_single_par_scan = [handles.popupmenu_parameter_to_scan handles.edit_scan_ini handles.edit_scan_end handles.text_single_parms_unit handles.text17 handles.text18];
if (get(handles.radiobutton_simulated_annealing,'Value')) == (get(handles.radiobutton_simulated_annealing,'Max'))
    set(panel_sim_anneal,'Enable','On');
    set(panel_single_par_scan,'Enable','Off');
else
    set(panel_sim_anneal,'Enable','Off');
    set(panel_single_par_scan,'Enable','On');
end


% --- Executes on button press in radiobutton7.
%function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7


% --- Executes on button press in radiobutton8.
%function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8


% --- Executes when selected object is changed in uipanel15.
function uipanel15_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel15 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
delay_objects = [handles.edit_akc02_3 handles.edit_akc03_3 handles.edit_akc04_3 handles.text14];
if (get(handles.radiobutton_G_F,'Value')) == (get(handles.radiobutton_G_F,'Max'))
    set(delay_objects,'Visible','On');
    set(handles.text13, 'String','Gross Delay (ns)');
    [G F] = lnls1_booster_delay2GF(str2double(get(handles.edit_akc02_2, 'String')));
    set(handles.edit_akc02_2, 'String', G);
    set(handles.edit_akc02_3, 'String', F);
    [G F] = lnls1_booster_delay2GF(str2double(get(handles.edit_akc03_2, 'String')));
    set(handles.edit_akc03_2, 'String', G);
    set(handles.edit_akc03_3, 'String', F);
    [G F] = lnls1_booster_delay2GF(str2double(get(handles.edit_akc04_2, 'String')));
    set(handles.edit_akc04_2, 'String', G);
    set(handles.edit_akc04_3, 'String', F);
else
    set(delay_objects,'Visible','Off');
    set(handles.text13, 'String','Total Delay (ns)');
    G = str2double(get(handles.edit_akc02_2, 'String'));
    F = str2double(get(handles.edit_akc02_3, 'String'));
    set(handles.edit_akc02_2, 'String', lnls1_booster_GF2delay(G,F));
    G = str2double(get(handles.edit_akc03_2, 'String'));
    F = str2double(get(handles.edit_akc03_3, 'String'));
    set(handles.edit_akc03_2, 'String', lnls1_booster_GF2delay(G,F));
    G = str2double(get(handles.edit_akc04_2, 'String'));
    F = str2double(get(handles.edit_akc04_3, 'String'));
    set(handles.edit_akc04_2, 'String', lnls1_booster_GF2delay(G,F));
end
    


% --- Executes when selected object is changed in panel_analysis_mode.
function uipanel_analysis_mode_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_analysis_mode 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_abort.
function pushbutton_abort_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_abort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on edit_akc02_1 and none of its controls.
function edit_akc02_1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc02_1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if str2double(get(hObject,'String')) > str2double(get(handles.edit_max_voltage, 'String'))
    set(handles.edit_akc02_1, 'String', get(handles.edit_max_voltage, 'String'));
end


% --- Executes on key press with focus on edit_akc03_1 and none of its controls.
function edit_akc03_1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc03_1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String')) > str2double(get(handles.edit_max_voltage, 'String'))
    set(handles.edit_akc03_1, 'String', get(handles.edit_max_voltage, 'String'));
end


% --- Executes on key press with focus on edit_akc04_1 and none of its controls.
function edit_akc04_1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc04_1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if str2double(get(hObject,'String')) > str2double(get(handles.edit_max_voltage, 'String'))
    set(handles.edit_akc04_1, 'String', get(handles.edit_max_voltage, 'String'));
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit_akc04_1.
function edit_akc04_1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit_akc04_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
