function varargout = resongui(varargin)
% RESONGUI M-file for resongui.fig
%      RESONGUI, by itself, creates a new RESONGUI or raises the existing
%      singleton*.
%
%      H = RESONGUI returns the handle to a new RESONGUI or the handle to
%      the existing singleton*.
%
%      RESONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESONGUI.M with the given input arguments.
%
%      RESONGUI('Property','Value',...) creates a new RESONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before resongui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to resongui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help resongui

% Last Modified by GUIDE v2.5 13-Apr-2011 15:35:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @resongui_OpeningFcn, ...
    'gui_OutputFcn',  @resongui_OutputFcn, ...
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


% --- Executes just before resongui is made visible.
function resongui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to resongui (see VARARGIN)

% Choose default command line output for resongui
handles.output = hObject;

%Met la barre d'outil (zoom)
set(hObject,'ToolBar','figure');

% Update handles structure
guidata(hObject, handles);

%% Lit les donnees
handles.pathname = pwd; %chemin de lancement
handles.color='off'; % carte en couleur avec diffusion
handles.maptype = 'fmap'; %% fmap or fmapdp
handles.data_inducedamplitude = fullfile(pwd,'induced_amplitude.out');

loaddata(hObject,handles); %% charge les donnees
% OBLIGATOIRE car la fonction loaddata a modifier handles et 
% travailler sur une copie de handles
handles = guidata(hObject); 
handles.str='';

%% Couleur de depart pour identifiactaion point a point
handles.couleurs=[1 0 0];
%% zoom 
handles.type='shift';
set(handles.edit_shift,'String','0.05');
handles.shiftaxis = str2double(get(handles.edit_shift,'String'));
handles.zoomaxis= str2double(get(handles.edit_zoom,'String'));

%%% Variable pour echange avec autres gui
setappdata(handles.figure1, 'Tab',[]);
guidata(hObject, handles);

set(handles.edit_color,'BackgroundColor',handles.couleurs);
%%% Affiche le point de fonctionnement
print_value(handles,handles.x1(1),handles.x2(1),handles.f1(1),handles.f2(1));
%%%% dessine les donnees
plotdata(handles);

%%% axes par defaut
%set(handles.fmap,'Xlim',[18.1 18.3],'Ylim',[10.20 10.4]);

% UIWAIT makes resongui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = resongui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function loaddata(hObject,handles)

handles.dataname = [handles.maptype '.out'];
while (1)
    fname = fullfile(handles.pathname, handles.dataname);
    try
        [header data]=hdrload(fname);
        break;
    catch
        %     error('Error while opening filename %s ',fname)
        uiwait(errordlg('No input data found'));    
        handles = getdata(handles);
    end
end

z = data(:,2)*1e3;
switch handles.maptype
    case 'fmap'
        x = data(:,1)*1e3; %% z in mm
    case 'fmapdp'
        x = data(:,1)*1e2; %% energy in %
end

fx=7+abs(data(:,3));
fz=2+abs(data(:,4));

if size(data,2) == 6;
    %%% Data for color printing
    nz = sum(x==x(1));
    nx = size(x,1)/nz;
    dfx=data(:,5);
    dfz=data(:,6);
    
    xgrid = reshape(x,nz,nx);
    zgrid = reshape(z,nz,nx);
    fxgrid = reshape(fx,nz,nx);
    fzgrid = reshape(fz,nz,nx);
    dfxgrid = reshape(dfx,nz,nx);
    dfzgrid = reshape(dfz,nz,nx);
    diffu = log10(sqrt(dfxgrid.*dfxgrid+dfzgrid.*dfzgrid));
    %% saturation
    ind = isinf(diffu); 
    diffu(ind) = NaN;
    diffumax = -2; diffumin = -10;
    diffu(diffu< diffumin) = diffumin; % very stable
    diffu(diffu> diffumax) = diffumax; %chaotic
    %%  pour affichage couleur
    handles.diffu = diffu;
    handles.fxgrid=fxgrid;
    handles.fzgrid=fzgrid;
    handles.xgrid=xgrid;
    handles.zgrid=zgrid;
end
%% pour affichage noir et blanc
indx=(fx~=7.0);
handles.f1=fx(indx);
handles.f2=fz(indx);
handles.x1=x(indx);
handles.x2=z(indx);    

guidata(hObject,handles);
% select stable particles


% --- Executes on button press in pushbutton_replot.
function pushbutton_replot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_replot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
replot(hObject,handles);

function replot(hObject,handles)
%Efface figure et redessine les donnees brutes
get(handles.fmap,'Children');
%children=findobj(handles.axes,'Children','Type','Line'))
%child=findobj(handles.axes,'Children','Tag','fmap'))
%children(children==child)=[];
%delete(children mais pas child)
cla(handles.fmap);
cla(handles.da);
plotdata(handles);
getappdata(handles.figure1,'Tab');

function plotdata(handles)

switch handles.color
    case 'off'
        axes(handles.fmap); %  hold on;
        get(handles.fmap,'Children')
        %         if ~isempty(get(handles.fmap,'Children'))
        %             delete(findobj(get(handles.fmap,'Children'),'Tag','fspace'));
        %         end
        plot(handles.f1,handles.f2,'kd','MarkerSize',0.5,'MarkerFaceColor','k','Tag','fspace');
        grid on; hold on;
        %         xlabel('fx');  ylabel('fz');
        %axis([18.15 18.27 10.265 10.32]) 
        axis([min(handles.f1) max(handles.f1) min(handles.f2) max(handles.f2)]) % modification 8 mars 2010 à cause pb échelle (mat)
        axes(handles.da); hold off;        
        %%% Choix des axes
        switch handles.maptype
            case 'fmap'
                strx = 'x(mm)';
                stry = 'z(mm)';
            case 'fmapdp'
                strx = 'dp (%)';
                stry = 'x (mm)';
        end
        plot(handles.x1,handles.x2,'kd','MarkerSize',2.0,'MarkerFaceColor','k','Tag','cspace');
        xlabel(strx); ylabel(stry);
        grid on;  hold on;
    case 'on'
        axes(handles.fmap);  %hold on
        get(handles.fmap,'Children');
        mesh(handles.fxgrid,handles.fzgrid, handles.diffu,'Marker','.','MarkerSize',0.5,'FaceColor','none','LineStyle','none','Tag','fspace');
        %         if ~isempty(get(handles.fmap,'Children'))
        %             delete(findobj(get(handles.fmap,'Children'),'Tag','fspace'));
        %         end
        %image(cat(3,handles.diffu,handles.diffu,handles.diffu)/-10,'Tag','fspace');
        view(2); grid on; hold on
        xlabel('fx'); ylabel('fz')
        axes(handles.da);
        mesh(handles.xgrid,handles.zgrid,handles.diffu,'Marker','.','MarkerSize',2.0,'FaceColor','none','LineStyle','none','Tag','cspace');
        %image(reshape(handles.xgrid,1,prod(size(handles.xgrid))), ...
%             reshape(handles.zgrid,1 ,prod(size(handles.zgrid))), ...
%             cat(3,handles.diffu,handles.diffu,handles.diffu)/-10);
        view(2); grid on; hold on        
end


%datalabel on

% hc=uicontextmenu;
% hm=uimenu('parent',hc);
% set(h,'UIContextMenu',hc);
% hha=findobj(get(handles.da,'Children'),'Type','axes');
% set(get(handles.da,'Parent'),'WindowButtonDownFcn', ...
%     'pt=get(gca,''CurrentPoint'' ); disp(pt); disp(hm); set(hm,''Label'',[num2str(pt(1,1)) '', '' num2str(pt(1,2))])' )


%%% Affiche le point de fonctionnement
print_value(handles,handles.x1(1),handles.x2(1),handles.f1(1),handles.f2(1));

% --- Executes on button press in bouton_resonid.
function bouton_resonid_Callback(hObject, eventdata, handles)
% hObject    handle to bouton_resonid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Loop, picking up the points.
disp('Left mouse button picks points.')
disp('Right mouse button picks last point.')
hold on
button = 1;
n=0;
while button == 1
    [xi,yi,button] = ginput(1);
    %    plot(xi,yi,'o','Color',handles.couleurs,2.0,'MarkerFaceColor',handles.couleurs)
    n = n+1;
    identifier(xi,yi,handles)    
end

function identifier(xi,yi,handles)

%%% cherche le point le plus proche au sens de la norme 2
[dp1, i1]=min((handles.f1-xi).^2+(handles.f2-yi).^2);
[dp2, i2]=min((handles.x1-xi).^2+(handles.x2-yi).^2);

%selectionne la bonne figure sur laquelle on a clique
if (dp1 < dp2)
    i3 = i1;
else
    i3 =i2;
end

%%% affiche le point selectionne
axes(handles.da);
plot(handles.x1(i3),handles.x2(i3),'o','Color',handles.couleurs);
axes(handles.fmap);
plot(handles.f1(i3),handles.f2(i3),'o','Color',handles.couleurs);

print_value(handles,handles.x1(i3),handles.x2(i3),handles.f1(i3),handles.f2(i3));

function print_value(handles,x1,x2,f1,f2)
%%% Met a jour les valeurs selectionnees
formatda='% 6.4f';
formatfmap='% 8.5f';

switch handles.maptype
    case 'fmap'
        strx ='x  =';
        stry ='z  =';
    case 'fmapdp'
        strx ='dp =';
        stry ='x  =';
end
string=sprintf([strx,formatda],x1);
set(handles.text_x,'String',string);
string=sprintf([stry,formatda],x2);
set(handles.text_z,'String',string);
string=sprintf(['fx = ',formatfmap],f1);
set(handles.text_fx,'String',string);
string=sprintf(['fz = ',formatfmap],f2);
set(handles.text_fz,'String',string);

% --- Executes during object creation, after setting all properties.
function edit_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_color_Callback(hObject, eventdata, handles)
% hObject    handle to edit_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_color as text
%        str2double(get(hObject,'String')) returns contents of edit_color as a double
h = uisetcolor;
if (size(h,2) ~=1) 
    handles.couleurs = h;
    guidata(hObject, handles);
    set(handles.edit_color,'BackgroundColor',handles.couleurs);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% ZOOM AND SHIFT OF FMAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in increaseV.
function increaseV_Callback(hObject, eventdata, handles)
% hObject    handle to increaseV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prop ='Ylim';
zoomshift(handles,prop,1);


% --- Executes on button press in increaseH.
function increaseH_Callback(hObject, eventdata, handles)
% hObject    handle to increaseH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prop ='Xlim';
zoomshift(handles,prop,1);

% --- Executes on button press in decreaseV.
function decreaseV_Callback(hObject, eventdata, handles)
% hObject    handle to decreaseV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prop ='Ylim';
zoomshift(handles,prop,-1);


% --- Executes on button press in decreaseH.
function decreaseH_Callback(hObject, eventdata, handles)
% hObject    handle to decreaseH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prop ='Xlim';
zoomshift(handles,prop,-1);

function zoomshift(handles,prop,fac)
%% Fonction qui gere zoom et deplacement d'axe

scale = get(handles.fmap,prop);

switch handles.type
    case 'shift'
        set(handles.fmap,prop,scale+fac*handles.shiftaxis);        
    case 'zoom'
        w = scale(2)-scale(1);
        mid=scale(1) + w/2;
        if fac ==-1
            newscale = mid + [-1 1]*0.5*w*handles.zoomaxis;
        else
            newscale = mid + [-1 1]*0.5*w/handles.zoomaxis;
        end
        set(handles.fmap,prop,newscale);
end
axes(handles.fmap);
setappdata(handles.figure1, 'fen',axis);

% --- Executes during object creation, after setting all properties.
function edit_zoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_zoom_Callback(hObject, eventdata, handles)
% hObject    handle to edit_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_zoom as text
%        str2double(get(hObject,'String')) returns contents of edit_zoom as a double
handles.zoomaxis= str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
mutual_exclude(handles.radiobutton2);
handles.type='zoom';
guidata(hObject, handles);

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
mutual_exclude(handles.radiobutton1);
handles.type='shift';
guidata(hObject, handles);

%%% fonction pour faire des radioboutons
function mutual_exclude(off)
set(off,'Value',0);


% --- Executes during object creation, after setting all properties.
function edit_shift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_shift_Callback(hObject, eventdata, handles)
% hObject    handle to edit_shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_shift as text
%        str2double(get(hObject,'String')) returns contents of edit_shift as a double
handles.shiftaxis= str2double(get(hObject,'String'));
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in resetfmap.
function resetfmap_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_replot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.fmap,'XLimMode','auto','YLimMode','auto');
pause(0.1);
set(handles.fmap,'XLimMode','manual','YLimMode','manual');


% --------------------------------------------------------------------
function souris_Callback(hObject, eventdata, handles)
% hObject    handle to souris (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pt=get(gca,'CurrentPoint');
tab = getappdata(handles.figure1,'Tab');
handles.str = plusprochereson([pt(1,1), pt(1,2)],tab);
set(handles.resonance,'Label', handles.str);
guidata(hObject,handles); %% mise a jour donnees

% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_reson.
function pushbutton_reson_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reson (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.figure1, 'where2plot',handles.fmap);
axes(handles.fmap);
setappdata(handles.figure1, 'fen',axis);
% if ~isfield(handles,'showreson')
handles.showreson=showresongui(handles);
guidata(hObject,handles);
% end 
% showresongui('where2plot',handles.fmap,'fen',axis);


% --------------------------------------------------------------------
function resonance_Callback(hObject, eventdata, handles)
% hObject    handle to resonance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(handles.str)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LoadDataFile_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDataFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = getdata(handles);
guidata(hObject,handles);
loaddata(hObject, handles);
handles=guidata(hObject); % mis a jour des modification dans loaddata


% --------------------------------------------------------------------
function handles = getdata(handles);
% fonction pour ouvrir un fichier de donnees
% utilise l'interface graphique
% ne rend la main que si un fichier a ete correctement choisi!

[filename, pathname] = uigetfile('*.out', 'Pick an data file');

if isequal(filename,0) | isequal(pathname,0)
    disp('User pressed cancel')
else
    disp(['User selected ', fullfile(pathname, filename)])
    handles.dataname = filename;
    handles.pathname = pathname;
end

% --------------------------------------------------------------------
function LoadDataInduced_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDataInduced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in toggle_IA.
function toggle_IA_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_IA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_IA
val = get(hObject,'Value')
switch val
    case 1
        fname = handles.data_inducedamplitude;
        if exist(fname)
            axes(handles.da);
            [header A] = hdrload(fname);
            plot(A(:,1),A(:,2),'k-.','Tag','IA');
        else
            warning('Filname %s not found\n',fname);
            set(handles.toggle_IA,'Value',0);
        end
    otherwise
        delete(findobj(get(handles.da,'Children'),'Tag','IA'))        
end

% --- Executes on button press in toogle_color.
function toogle_color_Callback(hObject, eventdata, handles)
% hObject    handle to toogle_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toogle_color
val = get(hObject,'Value');
switch val
    case 0
        handles.color = 'off';
    case 1
        if isfield(handles,'diffu')
            handles.color = 'on';
        else
            set(hObject,'Value',0);
        end        
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_typemap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_typemap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu_typemap.
function popupmenu_typemap_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_typemap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_typemap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_typemap

contents = get(hObject,'String');
val = contents{get(hObject,'Value')};
switch val
    case 'fmap'
        handles.maptype = 'fmap';    
    case 'fmapdp'
        handles.maptype = 'fmapdp';
end
guidata(hObject,handles);
loaddata(hObject,handles);




% --------------------------------------------------------------------
function menu_popup_Callback(hObject, eventdata, handles)
% hObject    handle to menu_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_popup1_Callback(hObject, eventdata, handles)
% hObject    handle to menu_popup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = figure;
b = copyobj(handles.fmap, a); 
% set(b, 'Position', [0.1300    0.5811    0.7750    0.3439]);
set(b, 'Position', get(0,'FactoryAxesPosition'));
% set(b, 'ButtonDownFcn','');

% --------------------------------------------------------------------
function menu_popup2_Callback(hObject, eventdata, handles)
% hObject    handle to menu_popup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = figure;
b = copyobj(handles.da, a); 
% set(b, 'Position', [0.1300    0.5811    0.7750    0.3439]);
set(b, 'Position', get(0,'FactoryAxesPosition'));
set(b, 'ButtonDownFcn','');

% --------------------------------------------------------------------
function menu_popup12_Callback(hObject, eventdata, handles)
% hObject    handle to menu_popup12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = figure;
b = copyobj(handles.fmap, a); 
set(b, 'Position', [0.1300    0.5811    0.7750    0.3439]);
set(b, 'ButtonDownFcn','');
% if strcmpi(get(handles.('AddPlot1_Lattice'),'Checked'),'On')
%     b = copyobj(handles.('Graph3'), a); 
%     set(b, 'Position', [0.1300    0.5811    0.7750    0.3439]);
% end

b = copyobj(handles.da, a); 
set(b, 'Position', [0.1300    0.1100    0.7750    0.3439]);
set(b, 'ButtonDownFcn','');
% if strcmpi(get(handles.('AddPlot2_Lattice'),'Checked'),'On')
%     b = copyobj(handles.('Graph4'), a); 
%     set(b, 'Position', [0.1300    0.1100    0.7750    0.3439]);
% end
xlabel('Position [meters]');

Data = getappdata(gcbf, 'RawY');
if isfield(Data, 'TimeStamp')
    addlabel(1,0,datestr(Data.TimeStamp,21));
end
orient tall
