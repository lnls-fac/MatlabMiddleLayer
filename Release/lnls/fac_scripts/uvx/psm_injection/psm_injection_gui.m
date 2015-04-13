function varargout = psm_injection_gui(varargin)
% Programa de simulação de injeção com sextupolo pulsado
%
% PSM_INJECTION_GUI M-file for psm_injection_gui.fig 
%      PSM_INJECTION_GUI, by itself, creates a new PSM_INJECTION_GUI or raises the existing
%      singleton*.
%
%      H = PSM_INJECTION_GUI returns the handle to a new PSM_INJECTION_GUI or the handle to
%      the existing singleton*.
%
%      PSM_INJECTION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PSM_INJECTION_GUI.M with the given input arguments.
%
%      PSM_INJECTION_GUI('Property','Value',...) creates a new PSM_INJECTION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before psm_injection_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to psm_injection_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help psm_injection_gui

% Last Modified by GUIDE v2.5 31-Aug-2011 10:25:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @psm_injection_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @psm_injection_gui_OutputFcn, ...
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


% --- Executes just before psm_injection_gui is made visible.
function psm_injection_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to psm_injection_gui (see VARARGIN)

% Choose default command line output for psm_injection_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes psm_injection_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global THERING_PSM

lnls1_set_server('','','');
lnls1;

%inicializa mínimos e máximos das variáveis
set(handles.emitSL,'Min',100,'Max',1500);
set(handles.betaxSL,'Min',0.5,'Max',30);
set(handles.alphaxSL,'Min',-3,'Max',3);
set(handles.x0SL,'Min',-50,'Max',-30);
set(handles.xp0SL,'Min',-5,'Max',5);
set(handles.ASL,'Min',50,'Max',500);
set(handles.tauSL,'Min',0.1,'Max',5);
set(handles.t0SL,'Min',-1,'Max',5);

set(handles.emitSL,'Min',0,'Max',1500);
set(handles.betaxSL,'Min',0,'Max',1000);
set(handles.alphaxSL,'Min',-3,'Max',3);
set(handles.x0SL,'Min',-50,'Max',-30);
set(handles.xp0SL,'Min',-5,'Max',5);
set(handles.ASL,'Min',0,'Max',500);
set(handles.tauSL,'Min',0.1,'Max',5);
set(handles.t0SL,'Min',-1,'Max',5);


%inicializa posição dos slidebars
v=str2double(get(handles.emitEB,'String'));
set(handles.emitSL, 'Value', v); 
v=str2double(get(handles.betaxEB,'String'));
set(handles.betaxSL, 'Value', v); 
v=str2double(get(handles.alphaxEB,'String'));
set(handles.alphaxSL, 'Value', v); 
v=str2double(get(handles.x0EB,'String'));
set(handles.x0SL, 'Value', v); 
v=str2double(get(handles.xp0EB,'String'));
set(handles.xp0SL, 'Value', v); 
v=str2double(get(handles.AEB,'String'));
set(handles.ASL, 'Value', v); 
v=str2double(get(handles.tauEB,'String'));
set(handles.tauSL, 'Value', v); 
v=str2double(get(handles.t0EB,'String'));
set(handles.t0SL, 'Value', v); 

split=str2double(get(handles.TR7splitEB,'String'));
PSM_length=str2double(get(handles.LsextEB,'String'));
%THERING_PSM = insere_PSM_TR7(PSM_length, split);
THERING_PSM = insere_PSM(PSM_length, split);

set(handles.Inj_efficTX, 'String', ' ');
set(handles.AmplTX, 'String', ' ');

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Outputs from this function are returned to the command line.
function varargout = psm_injection_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function emitEB_Callback(hObject, eventdata, handles)
% hObject    handle to emitEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of emitEB as text
%        str2double(get(hObject,'String')) returns contents of emitEB as a double

v=str2double(get(handles.emitEB,'String'));
mx=get(handles.emitSL,'Max');
mn=get(handles.emitSL,'Min');
%if (v<mn), v=mn; end
%if (v>mx), v=mx; end
set(handles.emitSL,'Value',v);
set(handles.emitEB,'String',num2str(v));

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);

% --- Executes during object creation, after setting all properties.
function emitEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emitEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function emitSL_Callback(hObject, eventdata, handles)
% hObject    handle to emitSL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

v=get(handles.emitSL,'Value');
tx=num2str(v,'%6.1f');
set(handles.emitEB,'String',tx);

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function emitSL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emitSL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function betaxEB_Callback(hObject, eventdata, handles)
% hObject    handle to betaxEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of betaxEB as text
%        str2double(get(hObject,'String')) returns contents of betaxEB as a double

v=str2double(get(handles.betaxEB,'String'));
mx=get(handles.betaxSL,'Max');
mn=get(handles.betaxSL,'Min');
if (v<mn), v=mn; end
if (v>mx), v=mx; end
set(handles.betaxSL,'Value',v);
set(handles.betaxEB,'String',num2str(v));

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function betaxEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betaxEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function betaxSL_Callback(~, eventdata, handles)
% hObject    handle to betaxSL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
v=get(handles.betaxSL,'Value');
tx=num2str(v,'%6.1f');
set(handles.betaxEB,'String',tx);

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function betaxSL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betaxSL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function alphaxEB_Callback(hObject, eventdata, handles)
% hObject    handle to alphaxEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphaxEB as text
%        str2double(get(hObject,'String')) returns contents of alphaxEB as a double

v=str2double(get(handles.alphaxEB,'String'));
mx=get(handles.alphaxSL,'Max');
mn=get(handles.alphaxSL,'Min');
if (v<mn), v=mn; end
if (v>mx), v=mx; end
set(handles.alphaxSL,'Value',v);
set(handles.alphaxEB,'String',num2str(v));

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function alphaxEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaxEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function alphaxSL_Callback(hObject, eventdata, handles)
% hObject    handle to alphaxSL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
v=get(handles.alphaxSL,'Value');
tx=num2str(v,'%6.1f');
set(handles.alphaxEB,'String',tx);

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function alphaxSL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaxSL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function x0EB_Callback(hObject, eventdata, handles)
% hObject    handle to x0EB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x0EB as text
%        str2double(get(hObject,'String')) returns contents of x0EB as a double

v=str2double(get(handles.x0EB,'String'));
mx=get(handles.x0SL,'Max');
mn=get(handles.x0SL,'Min');
if (v<mn), v=mn; end
if (v>mx), v=mx; end
set(handles.x0SL,'Value',v);
set(handles.x0EB,'String',num2str(v));

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function x0EB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x0EB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function x0SL_Callback(hObject, eventdata, handles)
% hObject    handle to x0SL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
v=get(handles.x0SL,'Value');
tx=num2str(v,'%6.1f');
set(handles.x0EB,'String',tx);

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function x0SL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x0SL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function xp0EB_Callback(hObject, eventdata, handles)
% hObject    handle to xp0EB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xp0EB as text
%        str2double(get(hObject,'String')) returns contents of xp0EB as a double

v=str2double(get(handles.xp0EB,'String'));
mx=get(handles.xp0SL,'Max');
mn=get(handles.xp0SL,'Min');
if (v<mn), v=mn; end
if (v>mx), v=mx; end
set(handles.xp0SL,'Value',v);
set(handles.xp0EB,'String',num2str(v));

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function xp0EB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xp0EB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function xp0SL_Callback(hObject, eventdata, handles)
% hObject    handle to xp0SL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
v=get(handles.xp0SL,'Value');
tx=num2str(v,'%6.1f');
set(handles.xp0EB,'String',tx);

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function xp0SL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xp0SL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function AEB_Callback(hObject, eventdata, handles)
% hObject    handle to AEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AEB as text
%        str2double(get(hObject,'String')) returns contents of AEB as a double

v=str2double(get(handles.AEB,'String'));
mx=get(handles.ASL,'Max');
mn=get(handles.ASL,'Min');
if (v<mn), v=mn; end
if (v>mx), v=mx; end
set(handles.ASL,'Value',v);
set(handles.AEB,'String',num2str(v));

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function AEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function ASL_Callback(hObject, eventdata, handles)
% hObject    handle to ASL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
v=get(handles.ASL,'Value');
tx=num2str(v,'%6.1f');
set(handles.AEB,'String',tx);

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function ASL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ASL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function tauEB_Callback(hObject, eventdata, handles)
% hObject    handle to tauEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tauEB as text
%        str2double(get(hObject,'String')) returns contents of tauEB as a double

v=str2double(get(handles.tauEB,'String'));
mx=get(handles.tauSL,'Max');
mn=get(handles.tauSL,'Min');
if (v<mn), v=mn; end
if (v>mx), v=mx; end
set(handles.tauSL,'Value',v);
set(handles.tauEB,'String',num2str(v));

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function tauEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tauEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function tauSL_Callback(hObject, eventdata, handles)
% hObject    handle to tauSL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
v=get(handles.tauSL,'Value');
tx=num2str(v,'%6.1f');
set(handles.tauEB,'String',tx);

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function tauSL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tauSL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function t0EB_Callback(hObject, eventdata, handles)
% hObject    handle to t0EB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t0EB as text
%        str2double(get(hObject,'String')) returns contents of t0EB as a double

v=str2double(get(handles.t0EB,'String'));
mx=get(handles.t0SL,'Max');
mn=get(handles.t0SL,'Min');
if (v<mn), v=mn; end
if (v>mx), v=mx; end
set(handles.t0SL,'Value',v);
set(handles.t0EB,'String',num2str(v));

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function t0EB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t0EB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function t0SL_Callback(hObject, eventdata, handles)
% hObject    handle to t0SL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
v=get(handles.t0SL,'Value');
tx=num2str(v,'%6.1f');
set(handles.t0EB,'String',tx);

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function t0SL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t0SL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function TR7splitEB_Callback(hObject, eventdata, handles)
% hObject    handle to TR7splitEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TR7splitEB as text
%        str2double(get(hObject,'String')) returns contents of TR7splitEB as a double

global THERING_PSM

split=str2double(get(handles.TR7splitEB,'String'));
PSM_length=str2double(get(handles.LsextEB,'String'));
%THERING_PSM = insere_PSM_TR7(PSM_length, split);
THERING_PSM = insere_PSM(PSM_length, split);

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function TR7splitEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TR7splitEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function nr_partEB_Callback(hObject, eventdata, handles)
% hObject    handle to nr_partEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nr_partEB as text
%        str2double(get(hObject,'String')) returns contents of nr_partEB as a double

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function nr_partEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nr_partEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function aceitEB_Callback(hObject, eventdata, handles)
% hObject    handle to aceitEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aceitEB as text
%        str2double(get(hObject,'String')) returns contents of aceitEB as a double

%aceitancia na injeção

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function aceitEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aceitEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function nr_turns_trajEB_Callback(hObject, eventdata, handles)
% hObject    handle to nr_turns_trajEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nr_turns_trajEB as text
%        str2double(get(hObject,'String')) returns contents of nr_turns_trajEB as a double

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function nr_turns_trajEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nr_turns_trajEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function nr_turns_phaseEB_Callback(hObject, eventdata, handles)
% hObject    handle to nr_turns_phaseEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nr_turns_phaseEB as text
%        str2double(get(hObject,'String')) returns contents of nr_turns_phaseEB as a double

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);



function nr_sigmasEB_Callback(hObject, eventdata, handles)
% hObject    handle to nr_sigmasEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nr_sigmasEB as text
%        str2double(get(hObject,'String')) returns contents of nr_sigmasEB as a double

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);

% --- Executes during object creation, after setting all properties.
function nr_turns_phaseEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nr_turns_phaseEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LsextEB_Callback(hObject, eventdata, handles)
% hObject    handle to LsextEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LsextEB as text
%        str2double(get(hObject,'String')) returns contents of LsextEB as a double

global THERING_PSM

split=str2double(get(handles.TR7splitEB,'String'));
PSM_length=str2double(get(handles.LsextEB,'String'));
THERING_PSM = insere_PSM(PSM_length, split);

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function LsextEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LsextEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in track_ellipseRB.
function track_ellipseRB_Callback(hObject, eventdata, handles)
% hObject    handle to track_ellipseRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of track_ellipseRB

set(handles.track_ellipseRB, 'Value', 1);
set(handles.track_distribRB, 'Value', 0);

set(handles.Inj_efficTX, 'String', ' ');
set(handles.AmplTX, 'String', ' ');

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes on button press in track_distribRB.
function track_distribRB_Callback(hObject, eventdata, handles)
% hObject    handle to track_distribRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of track_distribRB

set(handles.track_distribRB, 'Value', 1);
set(handles.track_ellipseRB, 'Value', 0);

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function Inj_efficTX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Inj_efficTX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function phapEB_Callback(hObject, eventdata, handles)
% hObject    handle to phapEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phapEB as text
%        str2double(get(hObject,'String')) returns contents of phapEB as a double

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function phapEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phapEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phapinjEB_Callback(hObject, eventdata, handles)
% hObject    handle to phapinjEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phapinjEB as text
%        str2double(get(hObject,'String')) returns contents of phapinjEB as a double

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);


% --- Executes during object creation, after setting all properties.
function phapinjEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phapinjEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function swsupEB_Callback(hObject, eventdata, handles)
% hObject    handle to swsupEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of swsupEB as text
%        str2double(get(hObject,'String')) returns contents of swsupEB as a double

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);

% --- Executes during object creation, after setting all properties.
function swsupEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to swsupEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function swinfEB_Callback(hObject, eventdata, handles)
% hObject    handle to swinfEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of swinfEB as text
%        str2double(get(hObject,'String')) returns contents of swinfEB as a double

dados = input_data(handles);
atualiza_psm_injection_gui(dados, handles);

% --- Executes during object creation, after setting all properties.
function swinfEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to swinfEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data = input_data(handles)

data.emit   = 1e-9 * str2double(get(handles.emitEB,'String'));
data.betax  = str2double(get(handles.betaxEB,'String'));
data.alphax = str2double(get(handles.alphaxEB,'String'));
data.x0     = str2double(get(handles.x0EB,'String'));
data.xp0    = str2double(get(handles.xp0EB,'String'));
data.A      = str2double(get(handles.AEB,'String'));
data.tau    = 1e-6 * str2double(get(handles.tauEB,'String'));
data.t0     = 1e-6 * str2double(get(handles.t0EB,'String'));
data.aceit  = 1e-6 * str2double(get(handles.aceitEB,'String'));
data.nr_part  = str2double(get(handles.nr_partEB,'String'));
data.nr_turns_traj = str2double(get(handles.nr_turns_trajEB,'String'));
data.nr_turns_phase = str2double(get(handles.nr_turns_phaseEB,'String'));
data.phys_apert     = str2double(get(handles.phapEB,'String'));
data.phys_apert_inj = str2double(get(handles.phapinjEB,'String'));
data.swinf          = str2double(get(handles.swinfEB,'String'));
data.swsup          = str2double(get(handles.swsupEB,'String'));




function surv = get_survivals_acceptance(surv0, vp, aceit, beta, alpha)

surv = surv0;
for k=1:length(surv0)
    x = vp(1,k);
    xp = vp(2,k);
    Xn2 = x^2/beta;
    Pn2 = (alpha*x+beta*xp)^2/beta;
    em = Xn2 + Pn2;
    surv(k) = surv(k) & (em < aceit);
end


function survivals = get_survivals(survivals0, traj, physical_aperture)

survivals = survivals0;
for k=1:length(survivals0)
    x = traj(1,k:length(survivals0):end);
    survivals(k) = survivals(k) & all(abs(x(1:end-1)) < physical_aperture);
end
  

function xxp = gera_distribuicao(emit, beta, alpha, x0, xp0, n)

rt = [ -log(rand(1,n-1))*emit; 2*pi*rand(1,n-1) ];
Xn   = sqrt(rt(1,:)).*cos(rt(2,:));
Pn   = sqrt(rt(1,:)).*sin(rt(2,:));
x    = 1000*sqrt(beta)*Xn + x0;
xp   = 1000*(Pn-alpha*Xn)/sqrt(beta) + xp0;
xxp = [ [x0; xp0] [x; xp] ];


function plot_efase(d, n, xxp_aceit, xxp0, xxp_antes_PSM, xxp_apos_PSM, cor, h)
%gráficos espaço de fase

axes(h);

tp=8;

plot([d.swinf d.swinf], [-2.5 2.5], '--k');
hold on;
plot([d.swsup d.swsup], [-2.5 2.5], '--k');


plot_elipse(xxp0,tp,[0 0 0],h);
plot_elipse(xxp_antes_PSM,tp,[1 0 0],h);

for i=n:-1:1
    plot_elipse(xxp_apos_PSM(:,:,i),tp,cor(min([i size(cor,1)]),:),h);
end

xxp_aceit(:,1)=xxp_aceit(:,end);
plot(xxp_aceit(1,:),xxp_aceit(2,:),'--k', 'LineWidth', 1.5);


axis([-45.0 35.0 -2.5 2.5]);
xlabel('x (mm)');
ylabel('xp (mrad)');
grid off;

hold off;


function plot_elipse(xxp,s,cor,h)

axes(h);

f=xxp;
c=xxp(:,1);
f(:,1)=[];
scatter(f(1,:),f(2,:),s,cor);
scatter(c(1,:),c(2,:),1.5*s,cor,'filled');


function plot_traj(traj, Amps, inva, plot_idx, accep, cor, h)

axes(h);

accep = 0.030*0.001;
sc = max(abs(traj(plot_idx,:)));
plot(traj(plot_idx,:), 'b');
hold all
plot(sc*inva/max(abs(inva)), 'r');
plot([1 length(inva)], [1 1]*sc*accep/max(abs(inva)), 'k');
if size(Amps,1)>0
    n=size(Amps,2);
    corgr=cor(1:n,:);
    scatter(Amps(1,:), sc*Amps(2,:)/max(abs(Amps(2,:))), 50, corgr, 'filled');
    %scatter(Amps(1,:), sc*Amps(2,:)/max(abs(Amps(2,:))), 50, [1 0 0], 'filled');
end

hold off;


function xxp = gera_elipse(emit, beta, alpha, x0, xp0, n)
% Gera coordenadas x, xp (mm,mrad) para n partículas sobre a 
%   elipse definida pelos parâmetros de Twiss emit, beta, alpha
% emit = emitância do feixe em m.rad
% beta = função bétatron em m
% x0   = posição do centróide em mm
% xp0  = posição angular do centróide em mrad

A = sqrt(emit);
dteta = 2*pi/(n-1);

xxp = [x0; xp0];  % centróide

for i=0:n-2
    teta = i*dteta;
    Xn   = A*cos(teta);
    Pn   = A*sin(teta);
    x    = 1000*sqrt(beta)*Xn + x0;
    xp   = 1000*(Pn-alpha*Xn)/sqrt(beta) + xp0;
    xxp = [xxp [x; xp]];
end

function r = get_invariant(p, lat, BETA, ALFA)

for i=1:size(p,2)
    rx = p(1,i);
    px = p(2,i);
    beta = BETA(lat(i),1);
    alfa = ALFA(lat(i),1);
    gamma = (1 + alfa^2)/beta;
    r(i) = gamma * rx^2 + 2 * alfa * rx * px + beta * px^2;
end



function r = pulse1(t,A,tau,t0)

tl = t + t0;
r  = A * cos(pi*tl/(tau+10^-16));
if tl>tau/2 || tl<-tau/2
    r = 0;
end

function [new_lattice Amp] = change_psm(lattice, n, kick_idx, A, tau, t0)

const = lnls_constants;

GeV        = 1;
Energy     = 0.5 * GeV;
c          = const.c;
rev_period = findspos(lattice,length(lattice)+1)/c;
Amp        = pulse1(n*rev_period, A, tau, t0);
BRho       = Energy / 0.3;
kick       = -(Amp/2)/BRho;

lattice{kick_idx}.PolynomB = [0 0 kick 0];

new_lattice = lattice;

function THERING_PSM = insere_PSM(PSM_length,split_ratio)

global THERING
global PARMS

lnls1_specific_parameters;

THERING2 = THERING;
THERING2{PARMS.kick_idx-1}.Length = THERING2{PARMS.kick_idx-1}.Length + THERING2{PARMS.kick_idx+1}.Length;
THERING2(PARMS.kick_idx:PARMS.kick_idx+1) = [];

drift_idx = PARMS.kick_idx-1;
drift1 = THERING2{drift_idx}; 
drift1.Length = THERING2{drift_idx}.Length * split_ratio - PSM_length/2;
psm    = sextupole('PSM', PSM_length, 0, 'StrMPoleSymplectic4Pass');
lat    = buildlat(psm);
psm    = lat{1};
drift2 = THERING2{drift_idx};
drift2.Length = THERING2{drift_idx}.Length * (1-split_ratio) - PSM_length/2;
if (drift1.Length<=0) || (drift2.Length<=0), error('Drift spaces negativos!'); end
THERING_PSM = [THERING2(1:drift_idx-1) drift1 psm drift2 THERING2(drift_idx+1:end)];


function lnls1_specific_parameters

global THERING
global PARMS

a2qd03 = findcells(THERING, 'FamName', 'A2QD03');
PARMS.kick_idx = findcells(THERING, 'FamName', 'PSM');
PARMS.injection_idx = findcells(THERING, 'FamName', 'INJECTION');
PARMS.injection_chamber_idx = PARMS.injection_idx:a2qd03(3);

function atualiza_psm_injection_gui(d, handles)

global THERING_PSM
global PARMS

lat1 = PARMS.injection_idx:PARMS.kick_idx-1;
latkick = PARMS.kick_idx;
lat2 = PARMS.kick_idx+1:length(THERING_PSM);
lat3 = 1:PARMS.injection_idx-1;

physical_aperture = d.phys_apert / 1000;
physical_aperture_inj_chamber = d.phys_apert_inj / 1000;

pa_vector = physical_aperture * ones(1,length(THERING_PSM));
pa_vector(PARMS.injection_chamber_idx) = physical_aperture_inj_chamber;

%cor das curvas nos gráficos
cor = [ 0 1 0; 0 1 1; 1 0 1; 1 0.6 0.2; 0.2 0.1 0.9; 0.8 0.8 0.8];

%aceitancia na injeção
[Twiss_inj, tune] = twissring(THERING_PSM, 0, PARMS.injection_idx);
betax=Twiss_inj.beta(1);
alphax=Twiss_inj.alpha(1);
xxp_aceit_inj = gera_elipse(d.aceit, betax, alphax, 0, 0, 50);

%aceitancia no PSM
[Twiss_inj, tune] = twissring(THERING_PSM, 0, PARMS.kick_idx);
betax_psm=Twiss_inj.beta(1);
alphax_psm=Twiss_inj.alpha(1);
xxp_aceit_PSM = gera_elipse(d.aceit, betax_psm, alphax_psm, 0, 0, 50);


% trajetória do centróide
TD = twissring(THERING_PSM,0,1:length(THERING_PSM));
BETA = cat(1,TD.beta);
ALFA = cat(1,TD.alpha);
S = cat(1,TD.SPos);

pos0          = [d.x0/1000 d.xp0/1000 0.0 0 0 0]';
p = pos0;
traj = [];
Amps = [];
inva = [];
plot_idx = 1;
sAmp = '';

for i=1:d.nr_turns_traj
    p = linepass(THERING_PSM(lat1), p(:,end), 1:length(lat1)+1); 
    traj = [traj p(:,1:end-1)]; 
    inva = [inva get_invariant(p(:,1:end-1), lat1, BETA, ALFA)];

    [THERING_PSM Amp] = change_psm(THERING_PSM, i-1, PARMS.kick_idx, d.A, d.tau, d.t0);
    Amps = [Amps [size(traj,2)+1; Amp]];
    
    p = linepass(THERING_PSM(latkick), p(:,end), 1:length(latkick)+1); 
    p = linepass(THERING_PSM(lat2), p(:,end), 1:length(lat2)+1); 
    traj = [traj p(:,1:end-1)];
    inva = [inva get_invariant(p(:,1:end-1), lat2, BETA, ALFA)];

    p = linepass(THERING_PSM(lat3), p(:,end), 1:length(lat3)+1); 
    traj = [traj p(:,1:end-1)]; 
    inva = [inva get_invariant(p(:,1:end-1), lat3, BETA, ALFA)];

    h = handles.trajGR;
    plot_traj(traj, Amps, inva, plot_idx, d.aceit, cor, h);
end

% Distribuição de partículas no espaço de fase

tr_ellipse = get(handles.track_ellipseRB, 'Value');

if (tr_ellipse)
    % Distribuição inicial de partículas no contorno da elipse
    xxp0 = gera_elipse(d.emit,d.betax,d.alphax,d.x0,d.xp0,d.nr_part);
    R0 = [ xxp0/1000; zeros(4,d.nr_part) ];

    %tracking do ponto de injeção até antes do PSM
    R = linepass(THERING_PSM(lat1), R0);
    xxp_antes_PSM = 1000*R(1:2,:);

    %ajusta valor do sextupolo para primeira passada
    [THERING_PSM Amp] = change_psm(THERING_PSM, 0, PARMS.kick_idx, d.A, d.tau, d.t0);

    %após PSM primeira passada
    R = linepass(THERING_PSM(latkick), R);
    xxp_apos_PSM(:,:,1) = 1000*R(1:2,:);

    for i=2:d.nr_turns_phase

        %após PSM i-esima passada
        R = linepass(THERING_PSM(lat2), R);
        R = linepass(THERING_PSM(lat3), R);
        R = linepass(THERING_PSM(lat1), R);
        [THERING_PSM Amp] = change_psm(THERING_PSM, i-1, PARMS.kick_idx, d.A, d.tau, d.t0);
        R = linepass(THERING_PSM(latkick), R);
        xxp_apos_PSM(:,:,i) = 1000*R(1:2,:);
    end

else
    
    % Distribuição inicial de partículas aleatória, distribuição
    % bi-gaussiana
    xxp0 = gera_distribuicao(d.emit,d.betax,d.alphax,d.x0,d.xp0,d.nr_part);
    R0 = [ xxp0/1000; zeros(4, d.nr_part) ];

    Ntot=size(R0,2);
    survivals = (1:Ntot)>0; 

    
    
    
    R = R0;
    
    % sobreviventes ao septum
    survivals = survivals & ((R(1,:) < d.swinf/1000) | R(1,:) > d.swsup/1000);
    
    
    vp = R;
    
    %tracking do ponto de injeção até antes do PSM
    R = linepass(THERING_PSM(lat1), vp, 1:length(lat1)+1);
    vp = R(:,end-d.nr_part+1:end);
    xxp_antes_PSM = 1000*vp(1:2,:);
    survivals = get_survivals(survivals, R, pa_vector(lat1));
    
    %ajusta valor do sextupolo para primeira passada
    [THERING_PSM Amp] = change_psm(THERING_PSM, 0, PARMS.kick_idx, d.A, d.tau, d.t0);
    tx = sprintf( '%i) %5.1f %%\n', 1, 100*Amp/d.A);
    sAmp = [sAmp tx];
    
    %após PSM primeira passada
    vp = linepass(THERING_PSM(latkick), vp);
    xxp_apos_PSM(:,:,1) = 1000*vp(1:2,:);
    sInj_effic = sprintf( '%i) %5.1f %%\n',1, 100*sum(survivals)/Ntot);
 
    max_nr_lines = 7;
    
    for i=2:d.nr_turns_phase
        %após PSM i-esima passada
        lattmp = [lat2 lat3 lat1];
        R = linepass(THERING_PSM(lattmp), vp, 1:length(lattmp)+1); 
        vp = R(:,end-d.nr_part+1:end);
        survivals = get_survivals(survivals, R, pa_vector(lattmp));
        tx = sprintf( '%i) %5.1f %%\n',i, 100*sum(survivals)/Ntot);
        if (i<max_nr_lines), sInj_effic=[sInj_effic tx]; end;
       
        [THERING_PSM Amp] = change_psm(THERING_PSM, i-1, PARMS.kick_idx, d.A, d.tau, d.t0);
        vp = linepass(THERING_PSM(latkick), vp);
        xxp_apos_PSM(:,:,i) = 1000*vp(1:2,:);
        tx = sprintf( '%i) %5.1f %%\n',i, 100*Amp/d.A);
        sAmp = [sAmp tx];

    end
    survivals = get_survivals_acceptance(survivals, vp, d.aceit, betax_psm, alphax_psm);
    tx = sprintf( 'Final) %5.1f %%', 100*sum(survivals)/Ntot);
    sInj_effic = [sInj_effic tx ];
 
    set(handles.Inj_efficTX, 'String', sInj_effic);
    set(handles.AmplTX, 'String', sAmp);

end

h = handles.efaseGR;
plot_efase(d, d.nr_turns_phase, xxp_aceit_PSM, xxp0, xxp_antes_PSM, xxp_apos_PSM, cor, h);
