function varargout = showresongui(varargin)
% SHOWRESONGUI M-file for showresongui.fig
% Gui for plotting resonances in a given window 
% Can be a standalone application or called from another gui
% 
%  If varargin is not void then it has to be a structure with a fieldname 
%  'figure1' containing a handles to a figure with three private variables
%  where2plot, handle to the axe
%  fen, window dimension [xmin xmax zmin zmax] 
%  Tab, tab where to store resonances
%  eg: getappdata(handles_figure) should return at least
%
%        fen: [18 20 10 12]
%        where2plot: 217.0009
%        Tab: []
%
% Laurent S. Nadolski, Synchrotron SOLEIL, 02/04

%
%      SHOWRESONGUI, by itself, creates a new SHOWRESONGUI or raises the existing
%      singleton*.
%
%      H = SHOWRESONGUI returns the handle to a new SHOWRESONGUI or the handle to
%      the existing singleton*.
%
%      SHOWRESONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOWRESONGUI.M with the given input arguments.
%
%      SHOWRESONGUI('Property','Value',...) creates a new SHOWRESONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before showresongui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to showresongui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help showresongui

% Last Modified by GUIDE v2.5 06-Mar-2004 19:43:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @showresongui_OpeningFcn, ...
                   'gui_OutputFcn',  @showresongui_OutputFcn, ...
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


% --- Executes just before showresongui is made visible.
function showresongui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to showresongui (see VARARGIN)

% Choose default command line output for showresongui

if iscell(varargin) && ~isempty(varargin)    
    %%%% Laurent
    % store handle from caller
    handles.caller = varargin{1}.figure1;
    
    % Update handles structure
    guidata(hObject, handles);

    %%%%% Laurent    
    % Get A and B values from Application-Defined data
    handles.where2plot = getappdata(handles.caller, 'where2plot');
    handles.fen = getappdata(handles.caller, 'fen');
else
    figure
    handles.where2plot =axes;
    handles.fen = [18 19 10 11];
    handles.caller = hObject;
    set(hObject,'Tag','main');
    setappdata(hObject,'Tab',[]);
    %% souris contextualmenu to identify resonances
%     cmenu = uicontextmenu;
%     set(handles.where2plot, 'UIContextMenu', cmenu);
%     uimenu(cmenu, 'Callback','souris_Callback(handles)');
%    handles.toto=uimenu(cmenu, 'Callback', ' showresongui(''souris_Callback'',gcbo,[],guidata(gcbo))');    
end

set(handles.caller,'DoubleBuffer','on');

handles.output = hObject;
handles.a = 3;
handles.b = 1;
handles.c = 65;
handles.periodicity = 4;
handles.order = 4;
handles.tab = [];
axes(handles.where2plot);

set(handles.periodicityvalue,'String',num2str(handles.periodicity));
set(handles.ordervalue,'String',num2str(handles.order));
set(handles.avalue,'String',num2str(handles.a));
set(handles.bvalue,'String',num2str(handles.b));
set(handles.cvalue,'String',num2str(handles.c));
set(handles.eq1,'String',[num2str(handles.a) ' nux + ' num2str(handles.b) ...
        ' nuz = ' num2str(handles.c)]); 

% reson(handles.order,handles.periodicity,handles.fen);
hold on
% reson(3,handles.periodicity,handles.fen);
% reson(5,handles.periodicity,handles.fen);
% reson(7,handles.periodicity,handles.fen);
axis(handles.fen);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes showresongui wait for user response (see UIRESUME)
% uiwait(handles.main);

% --- Outputs from this function are returned to the command line.
function varargout = showresongui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

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
axes(handles.where2plot);
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
axes(handles.where2plot);
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
axes(handles.where2plot);
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
if isnan(val)
    uiwait(errordlg('Incorrect value'));        
else
    handles.periodicity = val;
    % guidata(hObject, handles);
    % axes(handles.where2plot);
    % reson(handles.order,handles.periodicity,handles.fen);
    plotandsettab(hObject,handles)
end

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

% set resonance order
val = str2double(get(hObject,'String'));
if isnan(val)
    uiwait(errordlg('Incorrect value'));        
else
    plotandsettab(hObject,handles)
end

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%plotandsettab(hObject,handles)

function plotandsettab(hObject,handles)

if hObject ~= handles.periodicityvalue    
    handles.order=str2double(get(hObject,'String'));
    set(handles.ordervalue,'String',num2str(handles.order));
end

axes(handles.where2plot);
[k tab] =reson(handles.order,handles.periodicity,handles.fen);

if (k ~=0)
    % Force le premier coef a etre positif
    tab(tab(:,1) <0,:)=-tab(tab(:,1) <0,:);
    % Si a = 0, force le coef de nuz a etre positif
    r= tab(:,2) <0 & tab(:,1) ==0; 
    tab(r,:)=-tab(r,:);
    %% remove redundancy
    lnls_resongui = unique(handles.tab,'rows');
    
    %% cherche le pgcd et prend le pgcd des pgcd
    %% dans ce cas on perd la periodicite N, mais c'est plus clair
    pgcd =gcd(gcd(tab(:,1),tab(:,2)),gcd(tab(:,2),tab(:,3)));
    tab= tab./repmat(pgcd,1,3);
    
    % Complete le tableau des resonances
    handles.tab = [handles.tab; tab];
    %% remove redundancy
    handles.tab = unique(handles.tab,'rows');
end
axes(handles.where2plot);

handles.tab
% size(handles.tab)
guidata(hObject, handles);
setappdata(handles.caller,'Tab',handles.tab);
% setappdata(handles.toto,'Tab',handles.tab);

% --- Executes on button press in pushbutton_clear.
function pushbutton_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.where2plot);
%% Deselectionne toutes les checkbox
set(findobj(get(handles.main,'Children'),'Style','CheckBox'),'Value',0);
cla
handles.tab = [];
guidata(hObject, handles);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14
plotandsettab(hObject,handles)
% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox15
plotandsettab(hObject,handles)


% --- Executes on button press in pushbutton_axis.
function pushbutton_axis_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.where2plot);
uiwait(axlimdlg('Axis limits'));
handles.fen = [get(handles.where2plot,'Xlim') get(handles.where2plot,'Ylim')];
guidata(hObject,handles);

% --------------------------------------------------------------------
function souris_Callback(hObject, eventdata, handles)
% hObject    handle to souris (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pt=get(gca,'CurrentPoint');
tab = getappdata(gcbo,'Tab');
pt=[pt(1,1), pt(1,2)];
str=plusprochereson(pt,tab);
%set(gcbo,'Label', str);
text(pt(1),pt(2),str,'BackgroundColor','y');

