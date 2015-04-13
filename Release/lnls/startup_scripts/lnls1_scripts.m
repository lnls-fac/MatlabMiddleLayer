function varargout = lnls1_scripts(varargin)
% M-file do lnls1_scripts.fig (janela de botões com scripts de experimentos)
%
% LNLS1_SCRIPTS M-file for lnls1_scripts.fig
%      LNLS1_SCRIPTS, by itself, creates a new LNLS1_SCRIPTS or raises the existing
%      singleton*.
%
%      H = LNLS1_SCRIPTS returns the handle to a new LNLS1_SCRIPTS or the handle to
%      the existing singleton*.
%
%      LNLS1_SCRIPTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LNLS1_SCRIPTS.M with the given input arguments.
%
%      LNLS1_SCRIPTS('Property','Value',...) creates a new LNLS1_SCRIPTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lnls1_scripts_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lnls1_scripts_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lnls1_scripts

% Last Modified by GUIDE v2.5 09-Dec-2010 11:13:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lnls1_scripts_OpeningFcn, ...
                   'gui_OutputFcn',  @lnls1_scripts_OutputFcn, ...
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


% --- Executes just before lnls1_scripts is made visible.
function lnls1_scripts_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lnls1_scripts (see VARARGIN)

% Choose default command line output for lnls1_scripts
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lnls1_scripts wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lnls1_scripts_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_medir_otica.
function pb_medir_otica_Callback(hObject, eventdata, handles)
% hObject    handle to pb_medir_otica (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disable_buttons(hObject, handles);
lnls1('Disconnect');
if isempty(which('getao')) || isempty(evalin('base', 'getao')), evalin('base', 'lnls1'); end
lnls1_comm_connect_inputdlg;
if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end
try
    lnls1_measoptics;
    h = msgbox('Fim das Medidas');
    uiwait(h);
catch
    disp(['last error: ' lasterr]);
    h = msgbox('Erro nas Medidas');
    uiwait(h);
    lnls1('Disconnect');
end
enable_buttons(hObject, handles);

% --- Executes on button press in pb_otimizar_bump.
function pb_otimizar_bump_Callback(hObject, eventdata, handles)
% hObject    handle to pb_otimizar_bump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disable_buttons(hObject, handles);
if isempty(which('getao')) || isempty(evalin('base', 'getao')), evalin('base', 'lnls1'); end
if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end
lnls1_injbump_optimization_gui;
enable_buttons(hObject, handles);


% --- Executes on button press in pb_ciclar_corretoras.
function pb_ciclar_corretoras_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ciclar_corretoras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(hObject, handles);
if isempty(which('getao')) || isempty(evalin('base', 'getao')), evalin('base', 'lnls1'); end
if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end
try
    lnls1_cycle_correctors;
    h = msgbox('Fim das Ciclagens');
    uiwait(h);
catch
    disp(['last error: ' lasterr]);
    h = msgbox('Erro nas Ciclagens');
    uiwait(h);
    lnls1('Disconnect');
end
enable_buttons(hObject, handles);





% --- Executes on button press in pb_medir_disp.
function pb_medir_disp_Callback(hObject, eventdata, handles)
% hObject    handle to pb_medir_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(hObject, handles);
if isempty(which('getao')) || isempty(evalin('base', 'getao')), evalin('base', 'lnls1'); end
if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end
try
    lnls1_measdisp('NoDisplay');
    h = msgbox('Fim das Medidas');
    uiwait(h);
catch
    disp(['last error: ' lasterr]);
    h = msgbox('Erro nas Medidas');
    uiwait(h);
    lnls1('Disconnect');
end
enable_buttons(hObject, handles);


% --- Executes on button press in pb_medir_mresp.
function pb_medir_mresp_Callback(hObject, eventdata, handles)
% hObject    handle to pb_medir_mresp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(hObject, handles);
if isempty(which('getao')) || isempty(evalin('base', 'getao')), evalin('base', 'lnls1'); end
if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end
try
    lnls1_measbpmresp;
    h = msgbox('Fim das Medidas');
    uiwait(h);
catch
    disp(['last error: ' lasterr]);
    h = msgbox('Erro nas Medidas');
    uiwait(h);
    lnls1('Disconnect');
end
enable_buttons(hObject, handles);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_limpar.
function pb_limpar_Callback(hObject, eventdata, handles)
% hObject    handle to pb_limpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    cd(handles.working_dir);
    evalin('base', 'clear all');
    evalin('base', 'setao([])');
    evalin('base', 'setad([])');
catch
end
enable_buttons(hObject, handles);


function disable_buttons(hObject, handles)

fnames = fieldnames(handles);
for i=1:length(fnames)
    tObject = handles.(fnames{i}); 
    try
        style = get(tObject, 'Style');
        if ~strcmpi(style, 'pushbutton'), continue; end
        if (~(tObject == handles.pb_limpar)), set(tObject, 'Enable', 'off'); end
    catch
    end
end

function enable_buttons(hObject, handles)

fnames = fieldnames(handles);
for i=1:length(fnames)
    tObject = handles.(fnames{i}); 
    try
        set(tObject, 'Enable', 'on');
    catch
    end
end


% --- Executes on button press in pb_medir_bpms.
function pb_medir_bpms_Callback(hObject, eventdata, handles)
% hObject    handle to pb_medir_bpms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(hObject, handles);
if isempty(which('getao')) || isempty(evalin('base', 'getao')), evalin('base', 'lnls1'); end
if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end
try
    lnls1_monbpm;
    h = msgbox('Fim das Medidas');
    uiwait(h);
catch
    disp(['last error: ' lasterr]);
    h = msgbox('Erro nas Medidas');
    uiwait(h);
    lnls1('Disconnect');
end
enable_buttons(hObject, handles);

% --- Executes on button press in pb_grampear_sintonias.
function pb_grampear_sintonias_Callback(hObject, eventdata, handles)
% hObject    handle to pb_grampear_sintonias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button_string = get(hObject, 'String');
if strcmpi(button_string, 'Abortar')
    % click para abortar medida
    assignin('base','abort_event',1);
    set(hObject, 'String', 'Grampear Sintonias');
    return;
end

disable_buttons(hObject, handles);
set(hObject, 'Enable', 'on');
set(hObject, 'String', 'Abortar');
drawnow;

if isempty(which('getao')) || isempty(evalin('base', 'getao')), evalin('base', 'lnls1'); end
if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end

assignin('base','abort_event',0);
lnls1_hold_tunes;
assignin('base','abort_event',0);
set(hObject, 'String', 'Grampear Sintonias');
enable_buttons(hObject, handles);
evalin('base','clear abort_event');

% --- Executes on button press in pb_analisar_bba.
function pb_analisar_bba_Callback(hObject, eventdata, handles)
% hObject    handle to pb_analisar_bba (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(hObject, handles);
if isempty(which('getao')) || isempty(evalin('base', 'getao')), evalin('base', 'lnls1'); end
lnls1_bba_analysis;
enable_buttons(hObject, handles);

% --- Executes during object creation, after setting all properties.
function uipanel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.working_dir = pwd;
guidata(hObject,handles)


% --- Executes on button press in pb_gerar_mresp_diagmaq.
function pb_gerar_mresp_diagmaq_Callback(hObject, eventdata, handles)
% hObject    handle to pb_gerar_mresp_diagmaq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(hObject, handles);
startup_path = which('startup.m');
[work_dir, name, ext, versn] = fileparts(startup_path); 
run(fullfile(work_dir, 'scripts matlab da fac', 'gera_matriz_resposta'));
enable_buttons(hObject, handles);


% --- Executes on button press in pb_analise_loco.
function pb_analise_loco_Callback(hObject, eventdata, handles)
% hObject    handle to pb_analise_loco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(which('getao')) || isempty(evalin('base', 'getao')), evalin('base', 'lnls1'); end
disable_buttons(hObject, handles);
lnls1_loco_analysis;
enable_buttons(hObject, handles);


% --- Executes on button press in pb_cicla_a2qs05.
function pb_cicla_a2qs05_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cicla_a2qs05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(hObject, handles);
if isempty(which('getao')) || isempty(evalin('base', 'getao')), evalin('base', 'lnls1'); end
if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end
try
    lnls1_cycle_power_supply('SKEWCORR');
    h = msgbox('Fim das Ciclagens');
    uiwait(h);
catch
    disp(['last error: ' lasterr]);
    h = msgbox('Erro nas Ciclagens');
    uiwait(h);
    lnls1('Disconnect');
end
enable_buttons(hObject, handles);


% --- Executes on button press in pb_cicla_skewecorr.
function pb_cicla_skewecorr_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cicla_skewecorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(hObject, handles);
if isempty(which('getao')) || isempty(evalin('base', 'getao')), evalin('base', 'lnls1'); end
if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end
try
    skewcorr_devlist = family2dev('SKEWCORR');
    hcm_devlist = family2dev('HCM');
    vcm_devlist = common2dev([...
        'ACV01B'; ...
        'ACV03A'; ...
        'ACV05A'; 'ACV05B'; ...
        'ACV07A'; 'ACV07B'; ...
        'ACV09A'; 'ACV09B'; ...
        'ACV11A'; 'ACV11B'; ...
        'ACV01A'; ...
        ], 'VCM');
    
    
    lnls1_cycle_power_supply({'SKEWCORR', 'HCM', 'VCM'}, {skewcorr_devlist, hcm_devlist, vcm_devlist});
    h = msgbox('Fim das Ciclagens');
    uiwait(h);
catch
    disp(['last error: ' lasterr]);
    h = msgbox('Erro nas Ciclagens');
    uiwait(h);
    lnls1('Disconnect');
end
enable_buttons(hObject, handles);


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(hObject, handles);
if isempty(which('getao')) || isempty(evalin('base', 'getao')), evalin('base', 'lnls1'); end
if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end
try
    lnls1_measbba; 
    h = msgbox('Fim do BBA');
    uiwait(h);
catch
    disp(['last error: ' lasterr]);
    h = msgbox('Erro na Medida do BBA');
    uiwait(h);
end
enable_buttons(hObject, handles);
