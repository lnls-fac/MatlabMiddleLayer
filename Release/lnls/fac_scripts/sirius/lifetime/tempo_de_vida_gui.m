function varargout = tempo_de_vida_gui(varargin)
% TEMPO_DE_VIDA_GUI MATLAB code for tempo_de_vida_gui.fig
%      TEMPO_DE_VIDA_GUI, by itself, creates a new TEMPO_DE_VIDA_GUI or raises the existing
%      singleton*.
%
%      H = TEMPO_DE_VIDA_GUI returns the handle to a new TEMPO_DE_VIDA_GUI or the handle to
%      the existing singleton*.
%
%      TEMPO_DE_VIDA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEMPO_DE_VIDA_GUI.M with the given input arguments.
%
%      TEMPO_DE_VIDA_GUI('Property','Value',...) creates a new TEMPO_DE_VIDA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tempo_de_vida_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tempo_de_vida_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tempo_de_vida_gui

% Last Modified by GUIDE v2.5 26-Mar-2012 16:48:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tempo_de_vida_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @tempo_de_vida_gui_OutputFcn, ...
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


% --- Executes just before tempo_de_vida_gui is made visible.
function tempo_de_vida_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tempo_de_vida_gui (see VARARGIN)

% Choose default command line output for tempo_de_vida_gui
handles.output = hObject;

if handles.inicio
    set(handles.tempo_elastico,   'String','-');
    set(handles.tempo_inelastico, 'String','-');
    set(handles.tempo_touschek,   'String','-');
    set(handles.tempo_quantico,   'String','-');
    set(handles.tempo_total,      'String','-');
    handles.checkbox_elastico   = 0;
    handles.checkbox_inelastico = 0;
    handles.checkbox_touschek   = 0;
    handles.checkbox_quantico   = 0;
    set(handles.calcula,'Enable','off');
    set(handles.menu_visualiza1,'Enable','off');
    [handles.parametros.cp,~,...
        handles.parametros.E_n,handles.parametros.gamma,...
        handles.parametros.T_rev,handles.parametros.sigma_E,...
        handles.parametros.sigma_s,handles.parametros.tau_am,...
        handles.parametros.mcf,handles.parametros.U0,...
        handles.parametros.k] = carrega_parametros;
    handles.parametros.d_acc = ...
        calcula_aceitancia(handles.parametros.U0,...
        handles.parametros.mcf,handles.parametros.k,...
        handles.parametros.cp,handles.parametros.volt);
    handles.parametros.N = atualiza_N(handles);
    handles.parametros.arquivo = '';
    set(handles.parametro_fixo_E,      'String',handles.parametros.cp);
    set(handles.parametro_fixo_Gamma,  'String',handles.parametros.gamma);
    set(handles.parametro_fixo_dE,     'String',handles.parametros.d_acc);
    set(handles.parametro_N,           'String',handles.parametros.N);
    set(handles.parametro_fixo_Sigma_E,'String',handles.parametros.sigma_E);
    set(handles.parametro_fixo_Sigma_s,'String',handles.parametros.sigma_s);
    handles.inicio = 0;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tempo_de_vida_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tempo_de_vida_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox_elastico.
function checkbox_elastico_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_elastico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.checkbox_elastico = get(hObject,'Value');
testa_parametros(hObject,handles);
reset_grafico(handles);
reset_resultado(handles);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_elastico


% --- Executes during object creation, after setting all properties.
function checkbox_elastico_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox_elastico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox_inelastico.
function checkbox_inelastico_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_inelastico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.checkbox_inelastico = get(hObject,'Value');
testa_parametros(hObject,handles);
reset_grafico(handles);
reset_resultado(handles);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_inelastico


% --- Executes during object creation, after setting all properties.
function checkbox_inelastico_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox_inelastico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function EA_x_Callback(hObject, eventdata, handles)
% hObject    handle to EA_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = str2double(get(hObject,'String'));

if isnan(valor)
    set(hObject, 'String', 0);
    handles.parametros.EA_x = 0;
    uicontrol(hObject);
    guidata(hObject,handles);
end

handles.parametros.EA_x = valor;
reset_grafico(handles);
reset_resultado(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of EA_x as text
%        str2double(get(hObject,'String')) returns contents of EA_x as a double


% --- Executes during object creation, after setting all properties.
function EA_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EA_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.parametros.EA_x = 17.8;
guidata(hObject,handles);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EA_y_Callback(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = str2double(get(hObject,'String'));

if isnan(valor)
    set(hObject, 'String', 0);
    handles.parametros.EA_y = 0;
    uicontrol(hObject);
    guidata(hObject,handles);
end

handles.parametros.EA_y = valor;
reset_grafico(handles);
reset_resultado(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of text5 as text
%        str2double(get(hObject,'String')) returns contents of text5 as a double


% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R_Callback(hObject, eventdata, handles)
% hObject    handle to R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = str2double(get(hObject,'String'));

if isnan(valor)
    set(hObject, 'String', 0);
    handles.parametros.R = 0;
    uicontrol(hObject);
    guidata(hObject,handles);
end

handles.parametros.R = valor;
reset_grafico(handles);
reset_resultado(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of R as text
%        str2double(get(hObject,'String')) returns contents of R as a double


% --- Executes during object creation, after setting all properties.
function R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.parametros.R = 0.43;
guidata(hObject,handles);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T_Callback(hObject, eventdata, handles)
% hObject    handle to T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = str2double(get(hObject,'String'));

if isnan(valor)
    set(hObject, 'String', 0);
    handles.parametros.T = 0;
    uicontrol(hObject);
    guidata(hObject,handles);
end

handles.parametros.T = valor;
reset_grafico(handles);
reset_resultado(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of T as text
%        str2double(get(hObject,'String')) returns contents of T as a double


% --- Executes during object creation, after setting all properties.
function T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.parametros.T = 300.0;
guidata(hObject,handles);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Z_Callback(hObject, eventdata, handles)
% hObject    handle to Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = str2double(get(hObject,'String'));

if isnan(valor)
    set(hObject, 'String', 0);
    handles.parametros.Z = 0;
    uicontrol(hObject);
    guidata(hObject,handles);
end

handles.parametros.Z = valor;
reset_grafico(handles);
reset_resultado(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of Z as text
%        str2double(get(hObject,'String')) returns contents of Z as a double


% --- Executes during object creation, after setting all properties.
function Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.parametros.Z = 7;
guidata(hObject,handles);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calcula.
function calcula_Callback(hObject, eventdata, handles)
% hObject    handle to calcula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reset_resultado(handles);

W = 0;
Wm = 0;

handles.resultados.V = [];
handles.resultados.W_el = [];
handles.resultados.W_in = [];
handles.resultados.W_ts = [];
handles.resultados.W = [];

if(handles.checkbox_elastico)
    [W_el,Wm_el] = tau_elastico_inverso(handles.parametros.Z, ...
        handles.parametros.T,     handles.parametros.cp,  ...
        handles.parametros.R,     handles.parametros.EA_x,...
        handles.parametros.EA_y,  handles.parametros.r,   ...
        handles.parametros.P,     handles.parametros.Bx,  ...
        handles.parametros.By);
    
    T_el = (1/Wm_el) / 3600; % Tempo de vida em h
    set(handles.tempo_elastico,'String',T_el);
    
    W = W_el;
    Wm = Wm_el;
    handles.resultados.W_el = W_el;
end

if(handles.checkbox_inelastico)
    [W_in,Wm_in] = tau_inelastico_inverso(handles.parametros.Z,...
        handles.parametros.T,handles.parametros.d_acc,...
        handles.parametros.r,handles.parametros.P);
    
    T_in = (1/Wm_in) / 3600; % Tempo de vida em h
    set(handles.tempo_inelastico,'String',T_in);
    
    W = W + W_in;
    Wm = Wm + Wm_in;
    handles.resultados.W_in = W_in;
end

if(handles.checkbox_touschek)
    [W_ts,Wm_ts,V] = tau_touschek_inverso(handles.parametros.E_n,...
        handles.parametros.gamma   ,handles.parametros.N,      ...
        handles.parametros.sigma_E ,handles.parametros.sigma_s,...
        handles.parametros.d_acc   ,handles.parametros.r,      ...
        handles.parametros.Bx      ,handles.parametros.By,     ...
        handles.parametros.alpha   ,handles.parametros.eta,    ...
        handles.parametros.eta_diff,handles.parametros.K);
    
    T_ts = (1/Wm_ts) / 3600; % Tempo de vida em h
    set(handles.tempo_touschek,'String',T_ts);
    
    W = W + W_ts;
    Wm = Wm + Wm_ts;
    handles.resultados.V    = V;
    handles.resultados.W_ts = W_ts;
end

if(handles.checkbox_quantico)
    Wm_qu = tau_quantico_inverso(handles.parametros.tau_am,...
        handles.parametros.K,handles.parametros.EA_x,...
        handles.parametros.EA_y,handles.parametros.E_n,...
        handles.parametros.T_rev,handles.parametros.cp,...
        handles.parametros.mcf,handles.parametros.k,...
        handles.parametros.volt,handles.parametros.U0);
    
    T_qu = (1/Wm_qu) / 3600; % Tempo de vida em h
    set(handles.tempo_quantico,'String',T_qu);
    
    Wm = Wm + Wm_qu;
end

handles.resultados.W = W;
T = (1/Wm) / 3600;
set(handles.tempo_total,'String',T);
set(handles.menu_visualiza1,'Enable','on');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function calcula_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calcula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.inicio = 1;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function EA_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EA_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.parametros.EA_y = 5.74;
guidata(hObject,handles);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function testa_parametros(fig_handle,handles)
% Desativa o botão caso todas as contribuições estejam desativadas
testa_arquivo = isempty(handles.parametros.arquivo);
if (~testa_arquivo ...
        && (handles.checkbox_elastico ...
        || handles.checkbox_inelastico ...
        || handles.checkbox_touschek ...
        || handles.checkbox_quantico))
    set(handles.calcula,'Enable','on');
else
    set(handles.calcula,'Enable','off');
end
guidata(fig_handle,handles);


% --- Executes on selection change in menu_visualiza1.
function menu_visualiza1_Callback(hObject, eventdata, handles)
% hObject    handle to menu_visualiza1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.grafico1);

escolha = get(hObject,'Value');
switch escolha
    case 1
        plot(handles.parametros.r,handles.parametros.P);
        xlabel('s [m]');
        ylabel('P [mbar]');
    case 2
        plot(handles.parametros.r,handles.parametros.Bx);
        xlabel('s [m]');
        ylabel('B_x [m]');
    case 3
        plot(handles.parametros.r,handles.parametros.By);
        xlabel('s [m]');
        ylabel('B_y [m]');
    case 4
        if(isempty(handles.resultados.V))
            reset_grafico(handles,0);
            errordlg('Valores não calculados','Erro');
            return
        end
        plot(handles.parametros.r,handles.resultados.V);
        xlabel('s [m]');
        ylabel('V [m^3]');
    case 5
        if(isempty(handles.resultados.W_el))
            reset_grafico(handles,0);
            errordlg('Valores não calculados','Erro');
            return
        end
        plot(handles.parametros.r,handles.resultados.W_el);
        xlabel('s [m]');
        ylabel('1/\tau_{el} [1/s]');
    case 6
        if(isempty(handles.resultados.W_in))
            reset_grafico(handles,0);
            errordlg('Valores não calculados','Erro');
            return
        end
        plot(handles.parametros.r,handles.resultados.W_in);
        xlabel('s [m]');
        ylabel('1/\tau_{in} [1/s]');
    case 7
        if(isempty(handles.resultados.W_ts))
            reset_grafico(handles,0);
            errordlg('Valores não calculados','Erro');
            return
        end
        plot(handles.parametros.r,handles.resultados.W_ts);
        xlabel('s [m]');
        ylabel('1/\tau_{Tou} [1/s]');
    case 8
        plot(handles.parametros.r,handles.resultados.W);
        xlabel('s [m]');
        ylabel('1/\tau [1/s]');
end
% Hints: contents = cellstr(get(hObject,'String')) returns menu_visualiza1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_visualiza1


% --- Executes during object creation, after setting all properties.
function menu_visualiza1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_visualiza1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function reset_grafico(handles,desabilita)
set(handles.menu_visualiza1,'Value',1);
if(nargin==1 || desabilita)    
    set(handles.menu_visualiza1,'Enable','off');
end
testa_arquivo = isempty(handles.parametros.arquivo);
if(~testa_arquivo)
    axes(handles.grafico1);
    plot(handles.parametros.r,handles.parametros.P);
    xlabel('s [m]');
    ylabel('P [mbar]');
end


function reset_resultado(handles)
set(handles.tempo_elastico,   'String','-');
set(handles.tempo_inelastico, 'String','-');
set(handles.tempo_touschek,   'String','-');
set(handles.tempo_quantico,   'String','-');
set(handles.tempo_total,      'String','-');



function I_Callback(hObject, eventdata, handles)
% hObject    handle to I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = str2double(get(hObject,'String'));

if isnan(valor)
    set(hObject, 'String', 0);
    handles.parametros.I = 0;
    uicontrol(hObject);
    guidata(hObject,handles);
end

handles.parametros.I = valor;
reset_grafico(handles);
reset_resultado(handles);
handles.parametros.N = atualiza_N(handles);
set(handles.parametro_N,'String',handles.parametros.N);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of I as text
%        str2double(get(hObject,'String')) returns contents of I as a double


% --- Executes during object creation, after setting all properties.
function I_CreateFcn(hObject, eventdata, handles)
% hObject    handle to I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.parametros.I = 0.500;
guidata(hObject,handles);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nb_Callback(hObject, eventdata, handles)
% hObject    handle to Nb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = str2double(get(hObject,'String'));

if isnan(valor)
    set(hObject, 'String', 0);
    handles.parametros.Nb = 0;
    uicontrol(hObject);
    guidata(hObject,handles);
end

handles.parametros.Nb = valor;
reset_grafico(handles);
reset_resultado(handles);
handles.parametros.N = atualiza_N(handles);
set(handles.parametro_N,'String',handles.parametros.N);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of Nb as text
%        str2double(get(hObject,'String')) returns contents of Nb as a double


% --- Executes during object creation, after setting all properties.
function Nb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.parametros.Nb = 800;
guidata(hObject,handles);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function K_Callback(hObject, eventdata, handles)
% hObject    handle to K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = str2double(get(hObject,'String'));

if isnan(valor)
    set(hObject, 'String', 0);
    handles.parametros.K = 0;
    uicontrol(hObject);
    guidata(hObject,handles);
end

handles.parametros.K = valor;
reset_grafico(handles);
reset_resultado(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of K as text
%        str2double(get(hObject,'String')) returns contents of K as a double


% --- Executes during object creation, after setting all properties.
function K_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.parametros.K = 0.01;
guidata(hObject,handles);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_touschek.
function checkbox_touschek_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_touschek (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.checkbox_touschek = get(hObject,'Value');
testa_parametros(hObject,handles);
reset_grafico(handles);
reset_resultado(handles);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_touschek


% --- Executes on button press in escolhe_arquivo.
function escolhe_arquivo_Callback(hObject, eventdata, handles)
[nome caminho] = uigetfile('*.txt');
if(~nome)
    return
end
set(handles.perfil_escolhido,'String',nome);
handles.parametros.arquivo = fullfile(caminho,nome);
[handles.parametros.r,handles.parametros.P,...
    handles.parametros.Bx,handles.parametros.By,...
    handles.parametros.alpha,handles.parametros.eta,...
    handles.parametros.eta_diff,handles.parametros.s_P_dipolo]...
    = carrega_funcoes(handles.parametros.arquivo);
testa_parametros(hObject,handles);
reset_grafico(handles);
reset_resultado(handles);
guidata(hObject,handles);
% hObject    handle to escolhe_arquivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function N = atualiza_N(handles)
% Número de elétrons no bunch
N = handles.parametros.I * handles.parametros.T_rev ...
    / (1.60217653e-19 * handles.parametros.Nb);


% --- Executes during object creation, after setting all properties.
function parametro_N_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parametro_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox_quantico.
function checkbox_quantico_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_quantico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.checkbox_quantico = get(hObject,'Value');
testa_parametros(hObject,handles);
reset_grafico(handles);
reset_resultado(handles);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_quantico



function volt_Callback(hObject, eventdata, handles)
% hObject    handle to volt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = str2double(get(hObject,'String'));

if isnan(valor)
    set(hObject, 'String', 0);
    handles.parametros.K = 0;
    uicontrol(hObject);
    guidata(hObject,handles);
end

valor2 = 1000*valor; % Converte kV em V

handles.parametros.volt = valor2;

handles.parametros.d_acc = ...
    calcula_aceitancia(handles.parametros.U0,...
    handles.parametros.mcf,handles.parametros.k,...
    handles.parametros.cp,valor2);

set(handles.parametro_fixo_dE,'String',handles.parametros.d_acc);
reset_grafico(handles);
reset_resultado(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of volt as text
%        str2double(get(hObject,'String')) returns contents of volt as a double


% --- Executes during object creation, after setting all properties.
function volt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.parametros.volt = 3.5e6;
guidata(hObject,handles);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
