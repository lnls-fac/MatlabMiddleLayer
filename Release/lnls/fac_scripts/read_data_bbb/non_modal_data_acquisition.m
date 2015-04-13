function varargout = non_modal_data_acquisition(varargin)
% NON_MODAL_DATA_ACQUISITION M-file for non_modal_data_acquisition.fig
%      NON_MODAL_DATA_ACQUISITION, by itself, creates a new NON_MODAL_DATA_ACQUISITION or raises the existing
%      singleton*.
%
%      H = NON_MODAL_DATA_ACQUISITION returns the handle to a new NON_MODAL_DATA_ACQUISITION or the handle to
%      the existing singleton*.
%
%      NON_MODAL_DATA_ACQUISITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NON_MODAL_DATA_ACQUISITION.M with the given input arguments.
%
%      NON_MODAL_DATA_ACQUISITION('Property','Value',...) creates a new NON_MODAL_DATA_ACQUISITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before non_modal_data_acquisition_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to non_modal_data_acquisition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help non_modal_data_acquisition

% Last Modified by GUIDE v2.5 28-Jul-2011 10:38:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @non_modal_data_acquisition_OpeningFcn, ...
                   'gui_OutputFcn',  @non_modal_data_acquisition_OutputFcn, ...
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


% --- Executes just before non_modal_data_acquisition is made visible.
function non_modal_data_acquisition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to non_modal_data_acquisition (see VARARGIN)

% Choose default command line output for non_modal_data_acquisition
handles.output = hObject;

%Define global Variables
assignin('base', 'global_number_of_processing_chains',4)
assignin('base', 'global_standard_color_for_GUI',[0.831, 0.816,0.784]);
assignin('base','ddr2_default_plotting_scale_value',-8191);
assignin('base','ddr2_default_plotting_scale_flag',1);
assignin('base','ddr2_default_plotting_type_of_plot',3);
assignin('base', 'ddr2_default_line_color_01',[0,0,1]);
assignin('base', 'ddr2_default_line_color_02',[1,0,0]);
assignin('base', 'ddr2_default_line_color_03',[1,0,1]);
assignin('base', 'ddr2_default_line_color_04',[0,1,0]);
assignin('base', 'ddr2_default_line_color_05',[0,0,0]);

% Update handles structure
guidata(hObject, handles);

if ( isempty(handles) == 0)

    
    number_of_processing_chains_local = evalin('base', 'global_number_of_processing_chains');
    
    
    %set default color
    standard_color_for_GUI = evalin('base', 'global_standard_color_for_GUI');
    set(handles.figure_data_acquisition_main_window, 'Color', standard_color_for_GUI); 
    set(handles.uipanel_data_plot_type, 'BackgroundColor', standard_color_for_GUI); 
    set(handles.uipanel_data_analysis, 'BackgroundColor', standard_color_for_GUI); 
    set(handles.radiobutton_four_windows, 'BackgroundColor', standard_color_for_GUI); 
    set(handles.radiobutton_one_window_four_data_streams, 'BackgroundColor', standard_color_for_GUI); 
    set(handles.radiobutton_one_window_one_data_stream, 'BackgroundColor', standard_color_for_GUI); 
    set(handles.uipanel_plot_params_ALL, 'BackgroundColor', standard_color_for_GUI); 
    set(handles.uipanel_data_scaling, 'BackgroundColor', standard_color_for_GUI); 
     set(handles.uipanel_acquisition_control, 'BackgroundColor', standard_color_for_GUI);
    set(handles.checkbox_data_scaling, 'BackgroundColor', standard_color_for_GUI); 

    
    number_in_words_Upper = 'Four'; number_in_words_lower = 'four';
    string_for_tooltip_multiple_windows = 'Acquired samples divided and plotted in four separate windows';
    string_for_tooltip_single_window_multiple_streams = 'Acquired samples plotted as four data streams';
    set(handles.radiobutton_four_windows, 'String', [number_in_words_Upper ' plot windows']);
    set(handles.radiobutton_four_windows, 'TooltipString', string_for_tooltip_multiple_windows);
    set(handles.radiobutton_one_window_four_data_streams, 'String', ['One plot window, ' number_in_words_lower  ' data streams']);
    set(handles.radiobutton_one_window_four_data_streams, 'TooltipString', string_for_tooltip_single_window_multiple_streams);
    

    % % % Set default values
    [handles] = func_ddr2_update_uicontrols_data_acq(handles);
    % % % Set default values
    
    if( isfield(handles, 'axes_DDR2_data_TEXT') == 0)
        if ( isempty( get(handles.uipanel_acquisition_control, 'UserData')) )
            temp_handle_axes_starting_text = axes('Parent', handles.figure_data_acquisition_main_window, ...
                             'Units', 'normalized',  'HandleVisibility','on', 'Position',[0.05 0.4 0.90 0.55], ...
                             'Color', standard_color_for_GUI, 'Visible', 'off');
            handles.axes_DDR2_data_TEXT = temp_handle_axes_starting_text;
            axes(handles.axes_DDR2_data_TEXT);
            cla;
            figure_size = get(handles.axes_DDR2_data_TEXT, 'Position');
            text_position = [ (figure_size(1)+figure_size(3)/2 - 0.2)  (figure_size(2)+figure_size(4)/2 - 0.1) ];
            text(text_position(1), text_position(2), 'Acquired data will be depicted here...', 'FontSize', 14);
            set(handles.uipanel_acquisition_control, 'UserData', 1);
        end
    end

    % Update handles structure
    guidata(hObject, handles);

    type_of_figure = (get(handles.radiobutton_four_windows, 'Value')) + (get(handles.radiobutton_one_window_four_data_streams, 'Value'))*2 + ...
                     (get(handles.radiobutton_one_window_one_data_stream, 'Value'))*4;  
    if (type_of_figure == 1)
        for knkn = 1:number_of_processing_chains_local
           eval([ '[handles] = func_ddr2_generate_axes_objects(handles, ' num2str(knkn, '%1d') '); ']);
        end
        
        number_of_axes_plots = number_of_processing_chains_local;  % 1 - We have handle "axes_DDR2_data_SINGLE",  5 - We have handles "axes_DDR2_data_MULT_01 (02,03,04,05)"
        set(handles.figure_data_acquisition_main_window, 'UserData', number_of_axes_plots);
    else    
        [handles] = func_ddr2_generate_axes_objects(handles, 0);
        
        number_of_axes_plots = 1;  % 1 - We have handle "axes_DDR2_data_SINGLE",  5 - We have handles "axes_DDR2_data_MULT_01 (02,03,04,05)"
        set(handles.figure_data_acquisition_main_window, 'UserData', number_of_axes_plots);
    end

    % Update handles structure
    guidata(hObject, handles);
end
% UIWAIT makes non_modal_data_acquisition wait for user response (see UIRESUME)
% uiwait(handles.figure_data_acquisition_main_window);


% --- Outputs from this function are returned to the command line.
function varargout = non_modal_data_acquisition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles;


% --- Executes when user attempts to close figure_data_acquisition_main_window.
function figure_data_acquisition_main_window_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_data_acquisition_main_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if ( isempty(handles) == 0)
    func_ddr2_update_global_variables_data_acq(handles);
end
assignin('base','figure_data_acquisition_window_flag', 0);

delete(hObject);


% --- Executes on button press in togglebutton_start.
function togglebutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_start
start_button_state = get(handles.togglebutton_start, 'Value');
if (start_button_state == 1)
    % Update global variables
    func_ddr2_update_global_variables_data_acq(handles);
    %
    set(handles.togglebutton_start, 'FontWeight','normal', 'FontSize',8, 'ForegroundColor', [0 0 0], 'FontAngle', 'italic');
    %
    start_button_flag_local = get(handles.togglebutton_start, 'Value');
    %
    set(handles.togglebutton_start, 'Enable', 'inactive');
    %
    axes(handles.axes_DDR2_data_TEXT);
    %
    cla;
    %
    figure_size = get(handles.axes_DDR2_data_TEXT, 'Position');
    text_position = [ (figure_size(1)+figure_size(3)/2 - 0.2)  (figure_size(2)+figure_size(4)/2 - 0.1) ];
    %
    text(text_position(1), text_position(2), 'Acquired data will be depicted here...', 'FontSize', 14);

    if (  isfield(handles, 'axes_DDR2_data_MULT_01') == 1)
        axes(handles.axes_DDR2_data_MULT_01); 
        %
        cla;
        %
        set(handles.axes_DDR2_data_MULT_01, 'Visible', 'off');
    end
    %
    if (  isfield(handles, 'axes_DDR2_data_MULT_02') == 1)
        axes(handles.axes_DDR2_data_MULT_02); 
        %
        cla;
        %
        set(handles.axes_DDR2_data_MULT_02, 'Visible', 'off');
    end
    %
    if (  isfield(handles, 'axes_DDR2_data_MULT_03') == 1)
        axes(handles.axes_DDR2_data_MULT_03); 
        %
        cla;
        %
        set(handles.axes_DDR2_data_MULT_03, 'Visible', 'off');
    end
    %
    if (  isfield(handles, 'axes_DDR2_data_MULT_04') == 1)
        axes(handles.axes_DDR2_data_MULT_04); 
        %
        cla;
        %
        set(handles.axes_DDR2_data_MULT_04, 'Visible', 'off');
    end
    %
    if (  isfield(handles, 'axes_DDR2_data_MULT_05') == 1)
        axes(handles.axes_DDR2_data_MULT_05); 
        %
        cla;
        %
        set(handles.axes_DDR2_data_MULT_05, 'Visible', 'off');
    end
    %
    if (  isfield(handles, 'axes_DDR2_data_SINGLE') == 1)
        axes(handles.axes_DDR2_data_SINGLE); 
        %
        cla;
        %
        set(handles.axes_DDR2_data_SINGLE, 'Visible', 'off');
    end
    drawnow;

    axes(handles.axes_DDR2_data_TEXT);
    %
    cla;
    %
    figure_size = get(handles.axes_DDR2_data_TEXT, 'Position');
    text_position = [ (figure_size(1)+figure_size(3)/2 - 0.2)  (figure_size(2)+figure_size(4)/2 - 0.1) ];
    %
    text(text_position(1), text_position(2), 'Acquired data will be depicted here...', 'FontSize', 14);
    drawnow;


    % Update global variables
    func_ddr2_update_global_variables_data_acq(handles);


    % Get plotting parameters
    plotting_structure.data_scaling_flag    = evalin('base', 'ddr2_default_plotting_scale_flag');
    %
    plotting_structure.data_scaling_value   = evalin('base', 'ddr2_default_plotting_scale_value');
    %
    plotting_structure.plot_type            = evalin('base', 'ddr2_default_plotting_type_of_plot');
    %
    
    % Plotting
    %
    [handles, error_plotting_status] = func_ddr2_plotting_data(handles, plotting_structure);
    %
    %Plotting
    
    % Update global variables
    func_ddr2_update_global_variables_data_acq(handles);
    set(handles.togglebutton_start, 'Value', 0);
    %
    set(handles.togglebutton_start, 'FontWeight','bold',   'FontSize',10, 'ForegroundColor', [1 0 0], 'FontAngle', 'normal');
    %
    set(handles.togglebutton_start, 'Enable', 'on');
    %
    
    % Update handles structure
    guidata(hObject, handles);
end


function edit_data_scaling_Callback(hObject, eventdata, handles)
% hObject    handle to edit_data_scaling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_data_scaling as text
%        str2double(get(hObject,'String')) returns contents of edit_data_scaling as a double


% --- Executes during object creation, after setting all properties.
function edit_data_scaling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_data_scaling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_data_scaling.
function checkbox_data_scaling_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_data_scaling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_data_scaling

if (get(hObject, 'Value') == get(hObject, 'Max'))
    [handles] = func_ddr2_enable_scale(handles);
else
    [handles] = func_ddr2_disable_scale(handles);
end



% --- Executes on button press in pushbutton_BbB_analysis.
function pushbutton_BbB_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_BbB_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    try
        modal_bbb_analysis();
    catch
        warndlg('Please, perform a data acquisition first.', 'BbB Analysis');
    end

% --- Executes on button press in pushbutton_TbT_analysis.
function pushbutton_TbT_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_TbT_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        try
            TbT();
        catch
            warndlg('Please, perform a data acquisition first.', 'BbB Analysis');
        end

% --- Executes on button press in pushbutton_multibunch_fft.
function pushbutton_multibunch_fft_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_multibunch_fft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 try 
        frf = 476066000;
        Trf = 1/frf;

        data = evalin('base','bbb_data');

        N = length(data);
        NFFT = 2^nextpow2(N);

        %freq=linspace(-frf/2,frf/2,N);
        freq=(frf/2)*linspace(0,1,NFFT/2+1);
        
        Xac = data - mean(data);

        FFT = 4.624*2*abs(fft(Xac.*flattopwin(N)',NFFT))/N;

        fft_x = freq;
        fft_y = FFT(1:NFFT/2+1);

        assignin('base','fft_x',fft_x);
        assignin('base','fft_y',fft_y);

        hold off;
        h = figure;
        set(h,'NumberTitle','off','Name','Multibunch Analysis');
        semilogy(fft_x,fft_y);
        set(gca,'YLim',[0.01 30000]);
        xlabel('Frequency (Hz)','FontWeight','bold');
        ylabel('Amplitude (counts)','FontWeight','bold');
    catch
        warndlg('Please, perform a data acquisition first.', 'FFT Data');
    end

% --- Executes when figure_data_acquisition_main_window is resized.
function figure_data_acquisition_main_window_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure_data_acquisition_main_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if ( isempty(handles) == 0)
%     
%      
%     main_window_position_local = getpixelposition(handles.figure_data_acquisition_main_window);
% 
%      
%     minimal_main_window_width_pixels_local = evalin('base', 'ddr2_itech_data_acq_window_minimal_width_pixels');
%     %
%      
%     minimal_main_window_height_pixels_local = evalin('base', 'ddr2_itech_data_acq_window_minimal_height_pixels');
%     %
%     screensize_04 = get(0, 'ScreenSize');
%     
%     main_window_position_local = func_resize_modal_windows(main_window_position_local, screensize_04, minimal_main_window_width_pixels_local, minimal_main_window_height_pixels_local);
% 
%     % APPLY NEW POSITION
%      
%     %
%     setpixelposition(handles.figure_data_acquisition_main_window, main_window_position_local);
%     
%      
% end

% --------------------------------------------------------------------
function menu_start_Callback(hObject, eventdata, handles)
% hObject    handle to menu_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    togglebutton_start_Callback(hObject, eventdata, handles);
