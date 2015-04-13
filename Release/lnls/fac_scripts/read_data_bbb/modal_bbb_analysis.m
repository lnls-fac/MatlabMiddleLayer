function varargout = modal_bbb_analysis(varargin)
% MODAL_BBB_ANALYSIS MATLAB code for modal_bbb_analysis.fig
%      MODAL_BBB_ANALYSIS, by itself, creates a new MODAL_BBB_ANALYSIS or raises the existing
%      singleton*.
%
%      H = MODAL_BBB_ANALYSIS returns the handle to a new MODAL_BBB_ANALYSIS or the handle to
%      the existing singleton*.
%
%      MODAL_BBB_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODAL_BBB_ANALYSIS.M with the given input arguments.
%
%      MODAL_BBB_ANALYSIS('Property','Value',...) creates a new MODAL_BBB_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before modal_bbb_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to modal_bbb_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help modal_bbb_analysis

% Last Modified by GUIDE v2.5 06-Jun-2011 09:36:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @modal_bbb_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @modal_bbb_analysis_OutputFcn, ...
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


% --- Executes just before modal_bbb_analysis is made visible.
function modal_bbb_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to modal_bbb_analysis (see VARARGIN)

    assignin('base','modal_bbb_analysys_running',1);
    

    % Choose default command line output for modal_bbb_analysis
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    pb_update_Callback(hObject, eventdata, handles);

% UIWAIT makes modal_bbb_analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = modal_bbb_analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_update.
function pb_update_Callback(hObject, eventdata, handles)
% hObject    handle to pb_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        % lê qual o pacote desejado
        num_pacote=str2num(get(handles.edt_bunch,'String'));

        if ((num_pacote < 146) && (num_pacote > 0)) 
            frev = 476066000/148;
            Trev = 1/frev;

            % lê dados da última aquisição
            bbb_pacotes = evalin('base','bbb_data')-8191;

            % arredonda número de pontos para um múltiplo inteiro de 148
            num_points = 148*floor(length(bbb_pacotes)/148);

            % monta vetor para 4 pacotes consecutivos
            pacote1 = bbb_pacotes(num_pacote:148:num_points);
            pacote2 = bbb_pacotes(num_pacote+1:148:num_points);
            pacote3 = bbb_pacotes(num_pacote+2:148:num_points);
            pacote4 = bbb_pacotes(num_pacote+3:148:num_points);

            % verifica tamanho de cada vetor
            N1 = length(pacote1);
            N2 = length(pacote2);
            N3 = length(pacote3);
            N4 = length(pacote4);

            % monta vetor de freqüências da FFT
            freq1=linspace(-frev/2,frev/2,N1);
            freq2=linspace(-frev/2,frev/2,N2);
            freq3=linspace(-frev/2,frev/2,N3);
            freq4=linspace(-frev/2,frev/2,N4);

            % calcula DC de cada pacote
            pacote_dc1 = mean(pacote1);
            pacote_dc2 = mean(pacote2);
            pacote_dc3 = mean(pacote3);
            pacote_dc4 = mean(pacote4);

            % calcula std de cada pacote
            pacote_std1 = std(pacote1);
            pacote_std2 = std(pacote2);
            pacote_std3 = std(pacote3);
            pacote_std4 = std(pacote4);

            % imprime valores de DC e std no terminal
            sprintf('O DC dos pacotes são: %d, %d, %d, %d',pacote_dc1,pacote_dc2,pacote_dc3,pacote_dc4);
            sprintf('O std dos pacotes são: %d, %d, %d, %d',pacote_std1,pacote_std2,pacote_std3,pacote_std4);

            % calcula AC dos pacotes 
            pacote_ac1 = pacote1 - pacote_dc1;
            pacote_ac2 = pacote2 - pacote_dc2;
            pacote_ac3 = pacote3 - pacote_dc3;
            pacote_ac4 = pacote4 - pacote_dc4;

            % calcula FFT pros pacotes
            FFT1 = 4.624*2*abs(fft(pacote_ac1'.*flattopwin(N1)))/N1;
            FFT2 = 4.624*2*abs(fft(pacote_ac2'.*flattopwin(N2)))/N2;
            FFT3 = 4.624*2*abs(fft(pacote_ac3'.*flattopwin(N3)))/N3;
            FFT4 = 4.624*2*abs(fft(pacote_ac4'.*flattopwin(N4)))/N4;

            % constroi eixo X dos pacotes
            fft_freq1 = freq1(floor(N1/2)+1:N1);
            fft_freq2 = freq2(floor(N2/2)+1:N2);
            fft_freq3 = freq3(floor(N3/2)+1:N3);
            fft_freq4 = freq4(floor(N4/2)+1:N4);

            % seleciona 1/2 espelho da FFT
            fft_amp1 = FFT1(1:ceil(N1/2));
            fft_amp2 = FFT2(1:ceil(N2/2));
            fft_amp3 = FFT3(1:ceil(N3/2));
            fft_amp4 = FFT4(1:ceil(N4/2));

            % monta gráficos para cada pacote
            hold off;        
            axes(handles.axes_bunch1);
            plot(pacote1);
            ylabel('Amplitude (Counts)','FontWeight','bold');
            legend(['Bunch ',num2str(num_pacote)]);
            hold off;
            axes(handles.axes_fft1);
            plot(fft_freq1,fft_amp1);
            ylabel('Spec. Amp. (Counts)','FontWeight','bold');
%             set(gca,'XLim',[0 1000000]);
            set(gca,'YScale','log');
            set(gca,'YLim',[0.01 10000]);
            legend(['FFT Bunch ',num2str(num_pacote)]);

            hold off;        
            axes(handles.axes_bunch2);
            plot(pacote2);
            ylabel('Amplitude (Counts)','FontWeight','bold');
            legend(['Bunch ',num2str(num_pacote+1)]);
            hold off;
            axes(handles.axes_fft2);
            plot(fft_freq2,fft_amp2);
            ylabel('Spec. Amp. (Counts)','FontWeight','bold');
%             set(gca,'XLim',[0 1000000]);
            set(gca,'YScale','log');
            set(gca,'YLim',[0.01 10000]);
            legend(['FFT Bunch ',num2str(num_pacote+1)]);

            hold off;        
            axes(handles.axes_bunch3);
            plot(pacote3);
            ylabel('Amplitude (Counts)','FontWeight','bold');
            legend(['Bunch ',num2str(num_pacote+2)]);
            hold off;
            axes(handles.axes_fft3);
            plot(fft_freq3,fft_amp3);
            ylabel('Spec. Amp. (Counts)','FontWeight','bold');
%             set(gca,'XLim',[0 1000000]);
            set(gca,'YScale','log');
            set(gca,'YLim',[0.01 10000]);
            legend(['FFT Bunch ',num2str(num_pacote+2)]);

            hold off;        
            axes(handles.axes_bunch4);
            plot(pacote4);
            xlabel('Sample','FontWeight','bold');
            ylabel('Amplitude (Counts)','FontWeight','bold');
            legend(['Bunch ',num2str(num_pacote+3)]);
            hold off;
            axes(handles.axes_fft4);
            plot(fft_freq4,fft_amp4);
            xlabel('Frequency (Hz)','FontWeight','bold');
            ylabel('Spec. Amp. (Counts)','FontWeight','bold');
%             set(gca,'XLim',[0 1000000]);
            set(gca,'YScale','log');
            set(gca,'YLim',[0.01 10000]);
            legend(['FFT Bunch ',num2str(num_pacote+3)]);

            pause(1);
        else
           warndlg('Please, enter a bunch number between 1 and 145.', 'Warning') 
        end


function edt_bunch_Callback(hObject, eventdata, handles)
% hObject    handle to edt_bunch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_bunch as text
%        str2double(get(hObject,'String')) returns contents of edt_bunch as a double

    pb_update_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edt_bunch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_bunch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edt_bunch.
function edt_bunch_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edt_bunch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on edt_bunch and none of its controls.
function edt_bunch_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edt_bunch (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

    cur_init_bunch = str2num(get(gco,'String'));
    
    if ~isempty(cur_init_bunch)
        if strcmp(eventdata.Key,'uparrow')
            if (cur_init_bunch<145)&&(cur_init_bunch>0)
                set(gco,'String',num2str(str2num(get(gco,'String'))+4));
                pb_update_Callback(hObject, eventdata, handles);
            end
        elseif strcmp(eventdata.Key,'downarrow')
            if (cur_init_bunch<149)&&(cur_init_bunch>4)
                set(gco,'String',num2str(str2num(get(gco,'String'))-4));
                pb_update_Callback(hObject, eventdata, handles);
            end
        end
    end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    assignin('base','modal_bbb_analysys_running',0);


% --------------------------------------------------------------------
function menu_closewimn_Callback(hObject, eventdata, handles)
% hObject    handle to menu_closewimn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    close(gcbf) % to close GUI
