function varargout = lnls_resongui(varargin)
%lnls_resongui M-file for lnls_resongui.fig
%      lnls_resongui, by itself, creates a new lnls_resongui or raises the existing
%      singleton*.
%
%      H = lnls_resongui returns the handle to a new lnls_resongui or the handle to
%      the existing singleton*.
%
%      lnls_resongui('Property','Value',...) creates a new lnls_resongui using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to lnls_resongui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      lnls_resongui('CALLBACK') and lnls_resongui('CALLBACK',hObject,...) call the
%      local function named CALLBACK in lnls_resongui.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)"
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lnls_resongui

% Last Modified by GUIDE v2.5 19-Jan-2013 14:49:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lnls_resongui_OpeningFcn, ...
                   'gui_OutputFcn',  @lnls_resongui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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
% --- Executes just before lnls_resongui is made visible.
function lnls_resongui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for lnls_resongui
handles.output = hObject;

%Met la barre d'outil (zoom)
set(hObject,'ToolBar','figure');

% Update handles structure
guidata(hObject, handles);

% Parte inteira da Sintonia
handles.intQx= str2double(get(handles.edit_intQx,'String'));
handles.intQz= str2double(get(handles.edit_intQz,'String'));
handles.sub1 = false;

%% Lit les donnees
handles.pathname = uigetdir('/opt/sirius_tracy','Em qual pasta est�o os dados?'); %chemin de lancement
if (handles.pathname==0);
    handles.pathname = pwd;
end;
handles.color='off'; % carte en couleur avec diffusion
handles.maptype = 'fmap'; %% fmap or fmapdp
handles.data_inducedamplitude = fullfile(handles.pathname,'induced_amplitude.out');

loaddata(hObject,handles); %% charge les donnees
% OBLIGATOIRE car la fonction loaddata a modifier handles et 
% travailler sur une copie de handles
handles = guidata(hObject); 
handles.str='';

handles.period = 1;
set(handles.Periodicity,'String',num2str(handles.period));
handles.order = 1;
handles.tab = [];
%% Couleur de depart pour identifiactaion point a point
handles.couleurs=[1 0 0];
%% zoom 
handles.type='shift';
handles.shiftaxis = str2double(get(handles.edit_shift,'String'));
handles.zoomaxis= str2double(get(handles.edit_zoom,'String'));

%%% Variable pour echange avec autres gui
setappdata(handles.figure1, 'Tab',[]);
guidata(hObject, handles);

set(handles.color_ResID,'BackgroundColor',handles.couleurs);
%%% Affiche le point de fonctionnement
print_value(handles,handles.x1(1),handles.x2(1),handles.f1(1),handles.f2(1));
%%%% dessine les donnees
plotdata(handles);
% --- Outputs from this function are returned to the command line.
function varargout = lnls_resongui_OutputFcn(hObject, eventdata, handles)
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
%ordena os dados para pcolor funcionar corretamente.
[~, ind] = sort(data(:,2));
data = data(ind,:);
[~, ind] = sort(data(:,1));
data = data(ind,:);

string = handles.pathname;
set(handles.text_pathname,'String',string, 'Fontsize',12);

z = data(:,2)*1e3;
switch handles.maptype
    case 'fmap'
        x = data(:,1)*1e3; %% x in mm
    case 'fmapdp'
        x = data(:,1)*1e2; %% energy in %
end

if handles.sub1
    fx=handles.intQx + (1 - abs(data(:,3)));
    fz=handles.intQz + (1 - abs(data(:,4)));
else
    fx=handles.intQx + data(:,3);
    fz=handles.intQz + data(:,4);
end


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
indx=(fx~=handles.intQx);
handles.f1=fx(indx);
handles.f2=fz(indx);
handles.x1=x(indx);
handles.x2=z(indx);    

guidata(hObject,handles);
% select stable particles




% --- Executes on button press in replot.
function replot_Callback(hObject, eventdata, handles)
% hObject    handle to replot (see GCBO)
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
cla(handles.DA);
plotdata(handles);
getappdata(handles.figure1,'Tab');
function plotdata(handles)

switch handles.maptype
    case 'fmap'
        strx = 'x [mm]';
        stry = 'z [mm]';
    case 'fmapdp'
        strx = 'dp [%]';
        stry = 'x [mm]';
end

switch handles.color
    case 'off'
        axes(handles.fmap); %  hold on;
        get(handles.fmap,'Children')
        %         if ~isempty(get(handles.fmap,'Children'))
        %             delete(findobj(get(handles.fmap,'Children'),'Tag','fspace'));
        %         end
        plot(handles.f1,handles.f2,'kd','MarkerSize',5.0,'MarkerFaceColor','k','Tag','fspace');
        grid on; hold on;
        %         xlabel('fx');  ylabel('fz');
        %axis([18.15 18.27 10.265 10.32]) 
        axis([min(handles.f1) max(handles.f1) min(handles.f2) max(handles.f2)]) % modification 8 mars 2010 � cause pb �chelle (mat)
        axes(handles.DA); hold off;        
        %%% Choix des axes
        
        plot(handles.x1,handles.x2,'kd','MarkerSize',5.0,'MarkerFaceColor','k','Tag','cspace');
        xlabel(strx,'FontSize',20); ylabel(stry,'FontSize',20);
        axis([min(handles.x1) max(handles.x1) min(handles.x2) max(handles.x2)])
        grid on;  hold on;
    case 'on'
        axes(handles.fmap);  %hold on
        get(handles.fmap,'Children');
        mesh(handles.fxgrid,handles.fzgrid, handles.diffu,'Marker','.','MarkerSize',5.0,'FaceColor','none','LineStyle','none','Tag','fspace');
        %         if ~isempty(get(handles.fmap,'Children'))
        %             delete(findobj(get(handles.fmap,'Children'),'Tag','fspace'));
        %         end
        %image(cat(3,handles.diffu,handles.diffu,handles.diffu)/-10,'Tag','fspace');
        view(2); grid on; hold on
        xlabel('\nu_x','FontSize',20); ylabel('\nu_z','FontSize',20)
        axis([min(handles.f1) max(handles.f1) min(handles.f2) max(handles.f2)]) % modification 8 mars 2010 � cause pb �chelle (mat)
        axes(handles.DA);
        %mesh(handles.xgrid,handles.zgrid,handles.diffu,'Marker','.','MarkerSize',5.0,'FaceColor','none','LineStyle','none','Tag','cspace');
        %view(2); grid on; hold on;
        pcolor(handles.xgrid,handles.zgrid,handles.diffu); hold on;
        %mesh(handles.xgrid,handles.zgrid, handles.diffu,'Marker','.','MarkerSize',8.0,'FaceColor','none','LineStyle','none','Tag','fspace');

        shading flat
        axis([min(handles.x1) max(handles.x1) min(handles.x2) max(handles.x2)]);
        xlabel(strx,'FontSize',20); ylabel(stry,'FontSize',20);
end

%datalabel on

% hc=uicontextmenu;
% hm=uimenu('parent',hc);
% set(h,'UIContextMenu',hc);
% hha=findobj(get(handles.DA,'Children'),'Type','axes');
% set(get(handles.DA,'Parent'),'WindowButtonDownFcn', ...
%     'pt=get(gca,''CurrentPoint'' ); disp(pt); disp(hm); set(hm,''Label'',[num2str(pt(1,1)) '', '' num2str(pt(1,2))])' )

%%% Affiche le point de fonctionnement
print_value(handles,handles.x1(1),handles.x2(1),handles.f1(1),handles.f2(1));




% --- Executes on button press in resonID.
function resonID_Callback(hObject, eventdata, handles)
% hObject    handle to resonID (see GCBO)
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
axes(handles.DA);
plot(handles.x1(i3),handles.x2(i3),'o','Color',handles.couleurs);
axes(handles.fmap);
plot(handles.f1(i3),handles.f2(i3),'o','Color',handles.couleurs);

print_value(handles,handles.x1(i3),handles.x2(i3),handles.f1(i3),handles.f2(i3));
function print_value(handles,x1,x2,f1,f2)
%%% Met a jour les valeurs selectionnees
formatDA='% 6.4f';
formatfmap='% 8.5f';

switch handles.maptype
    case 'fmap'
        strx ='x =';
        stry ='z =';
    case 'fmapdp'
        strx ='dp =';
        stry ='x =';
end
string=sprintf([strx,formatDA],x1);
set(handles.selection_x,'String',string);
string=sprintf([stry,formatDA],x2);
set(handles.selection_z,'String',string);
string=sprintf(['fx = ',formatfmap],f1);
set(handles.selection_fx,'String',string);
string=sprintf(['fz = ',formatfmap],f2);
set(handles.selection_fz,'String',string);


% --- Executes on button press in color_ResID.
function color_ResID_Callback(hObject, eventdata, handles)
% hObject    handle to color_ResID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = uisetcolor;
if (size(h,2) ~=1) 
    handles.couleurs = h;
    guidata(hObject, handles);
    set(handles.color_ResID,'BackgroundColor',handles.couleurs);
end



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


% --- Executes on button press in resetfmap.
function resetfmap_Callback(hObject, eventdata, handles)
% hObject    handle to resetfmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.fmap);
axis([min(handles.f1) max(handles.f1) min(handles.f2) max(handles.f2)]) % modification 8 mars 2010 � cause pb �chelle (mat)



function edit_shift_Callback(hObject, eventdata, handles)
% hObject    handle to edit_shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_shift as text
%        str2double(get(hObject,'String')) returns contents of edit_shift as a double
handles.shiftaxis= str2double(get(hObject,'String'));
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function edit_shift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_zoom_Callback(hObject, eventdata, handles)
% hObject    handle to edit_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_zoom as text
%        str2double(get(hObject,'String')) returns contents of edit_zoom as a double
handles.zoomaxis= str2double(get(hObject,'String'));
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function edit_zoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in toogle_zoom.
function toogle_zoom_Callback(hObject, eventdata, handles)
% hObject    handle to toogle_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toogle_zoom
set(handles.increaseH,'String','+');
set(handles.decreaseH,'String','-');
set(handles.increaseV,'String','+');
set(handles.decreaseV,'String','-');
mutual_exclude(handles.toogle_shift);
handles.type='zoom';
guidata(hObject, handles);
% --- Executes on button press in toogle_shift.
function toogle_shift_Callback(hObject, eventdata, handles)
% hObject    handle to toogle_shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toogle_shift
set(handles.increaseH,'String','>');
set(handles.decreaseH,'String','<');
set(handles.increaseV,'String','^');
set(handles.decreaseV,'String','v');
mutual_exclude(handles.toogle_zoom);
handles.type='shift';
guidata(hObject, handles);
function mutual_exclude(off)
set(off,'Value',0);



% --- Executes on button press in IA.
function IA_Callback(hObject, eventdata, handles)
% hObject    handle to IA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(hObject,'Value')
switch val
    case 1
        fname = handles.data_inducedamplitude;
        if exist(fname)
            axes(handles.DA);
            [header A] = hdrload(fname);
            plot(A(:,1),A(:,2),'k-.','Tag','IA');
        else
            warning('Filname %s not found\n',fname);
            set(handles.IA,'Value',0);
        end
    otherwise
        delete(findobj(get(handles.DA,'Children'),'Tag','IA'))        
end
% --- Executes on button press in Diffusion.
function Diffusion_Callback(hObject, eventdata, handles)
% hObject    handle to Diffusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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




% --- Executes on selection change in typemap.
function typemap_Callback(hObject, eventdata, handles)
% hObject    handle to typemap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns typemap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from typemap
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
% --- Executes during object creation, after setting all properties.
function typemap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typemap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% RESONANCES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot ressonances and set handle.tab. Called by next functions
function plotandsettab(hObject,handles)

if hObject ~= handles.period    
    handles.order=str2double(get(hObject,'String'));
end

axes(handles.fmap);
current_limits_x=get(handles.fmap,'Xlim');
current_limits_y=get(handles.fmap,'Ylim');
[k tab] =reson(handles.order,handles.period,[min(handles.f1) max(handles.f1) min(handles.f2) max(handles.f2)]);

if (k ~=0)
    % Force le premier coef a etre positif
    tab(tab(:,1) <0,:)=-tab(tab(:,1) <0,:);
    % Si a = 0, force le coef de nuz a etre positif
    r= tab(:,2) <0 & tab(:,1) ==0; 
    tab(r,:)=-tab(r,:);
    %% remove redundancy
    handles.tab = unique(handles.tab,'rows');
    
    %% cherche le pgcd et prend le pgcd des pgcd
    %% dans ce cas on perd la periodicite N, mais c'est plus clair
    pgcd =gcd(gcd(tab(:,1),tab(:,2)),gcd(tab(:,2),tab(:,3)));
    tab= tab./repmat(pgcd,1,3);
    
    % Complete le tableau des resonances
    handles.tab = [handles.tab; tab];
    %% remove redundancy
    handles.tab = unique(handles.tab,'rows');
end
axes(handles.fmap);
axis([current_limits_x current_limits_y]);
handles.tab
% size(handles.tab)
guidata(hObject, handles);
setappdata(handles.figure1,'Tab',handles.tab);
% setappdata(handles.toto,'Tab',handles.tab);

function Periodicity_Callback(hObject, eventdata, handles)
% hObject    handle to Periodicity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = str2double(get(hObject,'String'));
if isnan(val)
    uiwait(errordlg('Incorrect value'));        
else
    handles.period = val;
    % guidata(hObject, handles);
    % axes(handles.fmap);
    % reson(handles.order,handles.period,handles.fen);
    plotandsettab(hObject,handles);
end
% --- Executes during object creation, after setting all properties.
function Periodicity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Periodicity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Res_Clear.
function Res_Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Res_Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.fmap);
%% Tira a sele��o de todas as checkbox de resson�ncia e limpa a figura
current_limits_x=get(handles.fmap,'Xlim');
current_limits_y=get(handles.fmap,'Ylim');
set(findobj(get(handles.figure1,'Children'),'Style','CheckBox'),'Value',0);
cla
handles.tab = [];
plotdata(handles);
axes(handles.fmap);
axis([current_limits_x current_limits_y]);
guidata(hObject, handles);



function Res_Tot_Callback(hObject, eventdata, handles)
% hObject    handle to Res_Tot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Res_Tot as text
%        str2double(get(hObject,'String')) returns contents of Res_Tot as a double


% --- Executes during object creation, after setting all properties.
function Res_Tot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Res_Tot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Res_nux_Callback(hObject, eventdata, handles)
% hObject    handle to Res_nux (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Res_nux as text
%        str2double(get(hObject,'String')) returns contents of Res_nux as a double


% --- Executes during object creation, after setting all properties.
function Res_nux_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Res_nux (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Res_nuz_Callback(hObject, eventdata, handles)
% hObject    handle to Res_nuz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Res_nuz as text
%        str2double(get(hObject,'String')) returns contents of Res_nuz as a double


% --- Executes during object creation, after setting all properties.
function Res_nuz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Res_nuz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_plot_ind_res.
function pushbutton_plot_ind_res_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot_ind_res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
axes(handles.fmap);
plot_reson(str2double(get(handles.Res_nux,'String')),str2double(get(handles.Res_nuz,'String')),str2double(get(handles.Res_Tot,'String')),[get(handles.fmap,'Xlim') get(handles.fmap,'Ylim')]);


% --- Executes during object creation, after setting all properties.
function pushbutton_plot_ind_res_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot_ind_res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on button press in Res_1.
function Res_1_Callback(hObject, eventdata, handles)
% hObject    handle to Res_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_2.
function Res_2_Callback(hObject, eventdata, handles)
% hObject    handle to Res_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_3.
function Res_3_Callback(hObject, eventdata, handles)
% hObject    handle to Res_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_4.
function Res_4_Callback(hObject, eventdata, handles)
% hObject    handle to Res_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_5.
function Res_5_Callback(hObject, eventdata, handles)
% hObject    handle to Res_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_6.
function Res_6_Callback(hObject, eventdata, handles)
% hObject    handle to Res_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_7.
function Res_7_Callback(hObject, eventdata, handles)
% hObject    handle to Res_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_8.
function Res_8_Callback(hObject, eventdata, handles)
% hObject    handle to Res_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_9.
function Res_9_Callback(hObject, eventdata, handles)
% hObject    handle to Res_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_10.
function Res_10_Callback(hObject, eventdata, handles)
% hObject    handle to Res_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_11.
function Res_11_Callback(hObject, eventdata, handles)
% hObject    handle to Res_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_12.
function Res_12_Callback(hObject, eventdata, handles)
% hObject    handle to Res_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_13.
function Res_13_Callback(hObject, eventdata, handles)
% hObject    handle to Res_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_14.
function Res_14_Callback(hObject, eventdata, handles)
% hObject    handle to Res_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_15.
function Res_15_Callback(hObject, eventdata, handles)
% hObject    handle to Res_15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);

% --- Executes on button press in Res_16.
function Res_16_Callback(hObject, eventdata, handles)
% hObject    handle to Res_16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotandsettab(hObject,handles);


function LoadDataInduced_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDataInduced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function LoadDataFile_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDataFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = getdata(handles);
guidata(hObject,handles);
loaddata(hObject, handles);
handles=guidata(hObject); % mis a jour des modification dans loaddata
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


% --- Executes on button press in load_data.
function load_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = uigetdir(handles.pathname,'Em qual pasta est�o os dados?'); %chemin de lancement
if (path~=0) handles.pathname = path; end;
clear path;
handles.data_inducedamplitude = fullfile(handles.pathname,'induced_amplitude.out');

loaddata(hObject,handles); %% charge les donnees
% OBLIGATOIRE car la fonction loaddata a modifier handles et 
% travailler sur une copie de handles
handles = guidata(hObject); 
get(handles.fmap,'Children');
%children=findobj(handles.axes,'Children','Type','Line'))
%child=findobj(handles.axes,'Children','Tag','fmap'))
%children(children==child)=[];
%delete(children mais pas child)
cla(handles.fmap);
cla(handles.DA);
plotdata(handles);


% --- Executes on button press in create_figure.
function create_figure_Callback(hObject, eventdata, handles)
% hObject    handle to create_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    a = figure('Position', [680 149 1019 831], 'XVisual',...
        '0x3e (TrueColor, depth 24, RGB mask 0xff0000 0xff00 0x00ff)');
catch
    a = figure('Position', [680 149 1019 831]);
end
    
fmap = copyobj(handles.fmap,a);
% Create axes
set(fmap,'Position',[0.0916666666666667 0.58893064853602 0.8109375 0.380758807588076],...
    'FontSize',20,...
    'ColorOrder',[0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0;0 0.75 0.75;0 0.5 0;0.75 0.75 0;1 0.5 0.25;0.75 0 0.75;0.7 0.7 0.7;0.8 0.7 0.6;0.6 0.5 0.4]);

fmapdp = copyobj(handles.DA,a);
% Create axes
 set(fmapdp,'Position',[0.0921875 0.0886587758333442 0.8109375 0.405149051490515],...
    'FontSize',20);

% Create text
% [path DirName]=fileparts(handles.pathname);
% text1 = [handles.maptype ' - ' DirName];
% addlabel(0,0,text1,7);

% Create colorbar
colorbar('peer',fmap,...
    [0.932216282262873 0.0862068965517241 0.0234192037470726 0.879310344827586],...
    'FontSize',20);



function edit_intQx_Callback(hObject, eventdata, handles)
% hObject    handle to edit_intQx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_intQx as text
%        str2double(get(hObject,'String')) returns contents of edit_intQx as a double
handles.intQx= str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_intQx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_intQx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_intQz_Callback(hObject, eventdata, handles)
% hObject    handle to edit_intQz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_intQz as text
%        str2double(get(hObject,'String')) returns contents of edit_intQz as a double
handles.intQz= str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_intQz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_intQz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in tune_shift_amp.
function tune_shift_amp_Callback(hObject, eventdata, handles)
% hObject    handle to tune_shift_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file1= fullfile(handles.pathname, 'nudx.out');
file2= fullfile(handles.pathname, 'nudz.out');
tracy_plotnudx(file1,file2);


% --- Executes on button press in tune_shit_mom.
function tune_shit_mom_Callback(hObject, eventdata, handles)
% hObject    handle to tune_shit_mom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file1= fullfile(handles.pathname, 'nudp.out');
plotnudpT(file1);


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when uipanel3 is resized.
function uipanel3_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when uipanel2 is resized.
function uipanel2_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in subtract1.
function subtract1_Callback(hObject, eventdata, handles)
% hObject    handle to subtract1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
switch val
    case 0
        handles.sub1 = false;
    case 1
         handles.sub1 = true;
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of subtract1
