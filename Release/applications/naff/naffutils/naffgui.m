function varargout = naffgui(varargin)
% NAFFGUI M-file for naffgui.fig
%      NAFFGUI, by itself, creates a new NAFFGUI or raises the existing
%      singleton*.
%
%      H = NAFFGUI returns the handle to a new NAFFGUI or the handle to
%      the existing singleton*.
%
%      NAFFGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NAFFGUI.M with the given input arguments.
%
%      NAFFGUI('Property','Value',...) creates a new NAFFGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before naffgui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to naffgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help naffgui

% Last Modified by GUIDE v2.5 07-Oct-2010 17:07:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @naffgui_OpeningFcn, ...
                   'gui_OutputFcn',  @naffgui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before naffgui is made visible.
function naffgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to naffgui (see VARARGIN)

% Choose default command line output for naffgui
handles.output = hObject;
handles.a = 3;
handles.b = 1;
handles.c = 65;
handles.periodicity = 4;
handles.order = 4;
handles.fen=[23 24 13 14];

reson(handles.order,handles.periodicity,handles.fen);
set(handles.periodicityvalue,'String',num2str(handles.periodicity));
set(handles.ordervalue,'String',num2str(handles.order));
set(handles.avalue,'String',num2str(handles.a));
set(handles.bvalue,'String',num2str(handles.b));
set(handles.cvalue,'String',num2str(handles.c));
set(handles.eq1,'String',[num2str(handles.a) ' nux + ' num2str(handles.b) ...
        ' nuz = ' num2str(handles.c)]); 

reson(handles.order,handles.periodicity,handles.fen);
hold on
reson(3,handles.periodicity,handles.fen);
reson(5,handles.periodicity,handles.fen);
reson(7,handles.periodicity,handles.fen);
axis(handles.fen);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes naffgui wait for user response (see UIRESUME)
% uiwait(handles.main);


% --- Outputs from this function are returned to the command line.
function varargout = naffgui_OutputFcn(hObject, eventdata, handles)
edit% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Ferme toutes les fenetres sauf le gui !
figs=findobj('Type','Figure');
close(figs(figs~=gcbf));

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_fmap('fmap.out')
% ces 2 autres versions permettent de superposer des résultats TRACY en
% couleurs et les mesures on-momentum en noir sur la figure(1000)
% prérequis : fmap.out de TRACY -> fmap_simulation.out
%             fmap.out des mesures -> fmap_mesure.out
%plot_fmap_version_mat_simulation('fmap_simulation.out')
%plot_fmap_version_mat_mesure('fmap_mesure.out')

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tracy_plotnudx

% --- Executes on button press in pushbutton_nudp.
function pushbutton_nudp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nudp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotnudpT

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.checkbox_tracy3,'Value') == 1
    plotchamberT('tracy3')
else
    plotchamberT
end
    

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_fmapdp('fmapdp.out')

% --- Executes during object creation, after setting all properties.
function cvalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function cvalue_Callback(hObject, eventdata, handles)
% hObject    handle to cvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cvalue as text
%        str2double(get(hObject,'String')) returns contents of cvalue as a double

val = str2double(get(hObject,'String'));
handles.c = val;
guidata(hObject, handles);
set(handles.eq1,'String',[num2str(handles.a) ' nux + ' num2str(handles.b) ...
        ' nuz = ' num2str(handles.c)]); 
plot_reson(handles.a,handles.b,handles.c,handles.fen)

% --- Executes during object creation, after setting all properties.
function avalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function avalue_Callback(hObject, eventdata, handles)
% hObject    handle to avalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avalue as text
%        str2double(get(hObject,'String')) returns contents of avalue as a double
val = str2double(get(hObject,'String'));
handles.a = val;
guidata(hObject, handles);
set(handles.eq1,'String',[num2str(handles.a) ' nux + ' num2str(handles.b) ...
        ' nuz = ' num2str(handles.c)]); 
plot_reson(handles.a,handles.b,handles.c,handles.fen)


% --- Executes during object creation, after setting all properties.
function bvalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function bvalue_Callback(hObject, eventdata, handles)
% hObject    handle to bvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bvalue as text
%        str2double(get(hObject,'String')) returns contents of bvalue as a double
val = str2double(get(hObject,'String'));
handles.b = val;
guidata(hObject, handles);
set(handles.eq1,'String',[num2str(handles.a) ' nux + ' num2str(handles.b) ...
        ' nuz = ' num2str(handles.c)]); 
plot_reson(handles.a,handles.b,handles.c,handles.fen)


% --- Executes during object creation, after setting all properties.
function periodicityvalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to periodicityvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function periodicityvalue_Callback(hObject, eventdata, handles)
% hObject    handle to periodicityvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of periodicityvalue as text
%        str2double(get(hObject,'String')) returns contents of periodicityvalue as a double
val = str2double(get(hObject,'String'));
handles.periodicity = val;
guidata(hObject, handles);
reson(handles.order,handles.periodicity,handles.fen);


% --- Executes during object creation, after setting all properties.
function ordervalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ordervalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ordervalue_Callback(hObject, eventdata, handles)
% hObject    handle to ordervalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ordervalue as text
%        str2double(get(hObject,'String')) returns contents of ordervalue as a double
val = str2double(get(hObject,'String'));
handles.order = val;
guidata(hObject, handles);
reson(handles.order,handles.periodicity,handles.fen);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reson(handles.order,handles.periodicity,handles.fen);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_touschek.
function pushbutton_touschek_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_touschek (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[T, Tp, Tn]=Calc_Tous('soleil.out','linlat.out')
 


% --- Executes on button press in pushbutton_beta.
function pushbutton_beta_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plottwissT;

% --- Executes on button press in pushbutton_dispersion.
function pushbutton_dispersion_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_dispersion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_fmapdp6D('fmapdp.out');

% --- Executes on button press in pushbutton_twiss.
function pushbutton_twiss_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_twiss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_tracy3.
function checkbox_tracy3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_tracy3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_tracy3
