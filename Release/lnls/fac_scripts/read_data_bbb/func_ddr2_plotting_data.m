function [handles, error_plotting_status] = func_ddr2_plotting_data(handles, plotting_structure)

error_plotting_status = 0;


number_of_processing_chains_local = evalin('base', 'global_number_of_processing_chains');

% READ DATA FROM FILE TO LOCAL VARIABLE
% READ DATA FROM FILE TO LOCAL VARIABLE
[file_name, file_local] = uigetfile('D:\ARQ\MATLAB\Libera_BBB\*.*',...
                               'Diretório onde está o arquivo BBB');
data_path_and_name = [file_local file_name];
if (file_name==0) 
    return;
end;

file_to_open_handle = fopen(data_path_and_name);
data_from_libera = fread(file_to_open_handle, [1,inf], 'int16');
fclose(file_to_open_handle);
assignin('base','bbb_data',data_from_libera);

% READ DATA FROM FILE TO LOCAL VARIABLE
% READ DATA FROM FILE TO LOCAL VARIABLE


% % Clear 'axes' with info text
axes(handles.axes_DDR2_data_TEXT);
cla;
set(handles.axes_DDR2_data_TEXT, 'Visible', 'off');
% % Clear 'axes' with info text


% Determine plot type
% Determine plot type
data_step_flag_local = 0;
%
if (data_step_flag_local == 1)
    type_of_figure = 3;
else
    type_of_figure = plotting_structure.plot_type;  
end
% Determine plot type
% Determine plot type


current_number_of_axes = get(handles.figure_data_acquisition_main_window, 'UserData');

if (type_of_figure == 1)
    % Five windows => Five 'axes' handles
    if (current_number_of_axes == number_of_processing_chains_local)
    else
        delete(handles.axes_DDR2_data_SINGLE);
        handles = rmfield(handles, 'axes_DDR2_data_SINGLE');
        %
        for nknk = 1:number_of_processing_chains_local
             
            eval([ '[handles] = func_ddr2_generate_axes_objects(handles, ' num2str(nknk, '%1d') '); ']);
        end
        %
        number_of_axes_plots = number_of_processing_chains_local;  % 1 - We have handle "axes_DDR2_data_SINGLE",  5 - We have handles "axes_DDR2_data_MULT_01 (02,03,04,05)"
        set(handles.figure_data_acquisition_main_window, 'UserData', number_of_axes_plots);
        
        % Update handles structure
        guidata(handles.figure_data_acquisition_main_window, handles);
    end
else
    % One window => one 'axes' handle
    if (current_number_of_axes == 1)
    else
        for hkhk = 1:number_of_processing_chains_local
             
            eval([ 'delete(handles.axes_DDR2_data_MULT_0' num2str(hkhk, '%1d') ');' ]);
            eval([ 'handles = rmfield(handles, ''axes_DDR2_data_MULT_0' num2str(hkhk, '%1d') ''');' ]);
        end
        
        [handles] = func_ddr2_generate_axes_objects(handles, 0);

        number_of_axes_plots = 1;  % 1 - We have handle "axes_DDR2_data_SINGLE",  5 - We have handles "axes_DDR2_data_MULT_01 (02,03,04,05)"
        set(handles.figure_data_acquisition_main_window, 'UserData', number_of_axes_plots);

        % Update handles structure
        guidata(handles.figure_data_acquisition_main_window, handles);
    end
end

% % Scale data
% % Scale data
if (plotting_structure.data_scaling_flag)
    scaling_value = plotting_structure.data_scaling_value;
else
    scaling_value = 0;
end
data_from_libera = data_from_libera + scaling_value;
% % Scale data
% % Scale data

% % Transform data
% % Transform data
if (type_of_figure == 3)
    data_from_libera_full = data_from_libera;
else
    for rtrt = 1:number_of_processing_chains_local
        eval([ 'data_channel_separate_CELL(' num2str(rtrt, '%1d') ') = {data_from_libera(' num2str(rtrt, '%1d') ':'  num2str(number_of_processing_chains_local, '%1d') ':end)};' ]);
    end
end
% % Transform data
% % Transform data


% % % % % % % % % % P L O T I N G % %  %
% % % % % % % % % % P L O T I N G % %  %
% % % % % % % % % % P L O T I N G % %  %
% % % % % % % % % % P L O T I N G % %  %
assignin('base','ddr2_default_plot_color',[1,1,1]);
plot_color_local = evalin('base', 'ddr2_default_plot_color');
free_part_of_plot_window = 0.1;

if (type_of_figure == 1)
    minimum_Y_axis = 1e100;
    maximum_Y_axis = -1e100;
    for qeqe = 1:number_of_processing_chains_local
        minimum_Y_axis = min([ minimum_Y_axis min(data_channel_separate_CELL{qeqe}) ]);
        maximum_Y_axis = max([ maximum_Y_axis max(data_channel_separate_CELL{qeqe}) ]);
    end
    max_amplitude_value = max(abs([maximum_Y_axis, minimum_Y_axis]));
    amplitude_range = maximum_Y_axis - minimum_Y_axis; 
    cond_to_calc_Y_bounds = (amplitude_range ~= 0);
    if (cond_to_calc_Y_bounds)
        extended_amp_range = free_part_of_plot_window * abs(amplitude_range);
        plot_reserve_empty = extended_amp_range/2/max_amplitude_value ;
        if ( (minimum_Y_axis < 0) && (maximum_Y_axis > 0) )
            minimum_Y_axis = minimum_Y_axis   -   plot_reserve_empty * max_amplitude_value;
            maximum_Y_axis = maximum_Y_axis +  plot_reserve_empty * max_amplitude_value;
        elseif (minimum_Y_axis > 0)
            maximum_Y_axis = maximum_Y_axis +  plot_reserve_empty * max_amplitude_value;
            minimum_Y_axis = minimum_Y_axis - plot_reserve_empty * max_amplitude_value;
        elseif (maximum_Y_axis < 0)
            minimum_Y_axis = minimum_Y_axis - plot_reserve_empty * max_amplitude_value;
            maximum_Y_axis = maximum_Y_axis + plot_reserve_empty * max_amplitude_value;
        end
    end
    %
    maximum_X_axis = -1e100;
    for qeqe = 1:number_of_processing_chains_local
        maximum_X_axis = max([ maximum_X_axis length(data_channel_separate_CELL{qeqe}) ]);
    end
    temp_max_X_axis = maximum_X_axis;
    maximum_X_axis = ceil(1.02* temp_max_X_axis);
    minimum_X_axis = - ceil(temp_max_X_axis * 0.02);
    
    % % PLOT ALL CHANNELS
    % % PLOT ALL CHANNELS
    for opopop = 1:number_of_processing_chains_local
        eval( ['axes(handles.axes_DDR2_data_MULT_0' num2str(opopop, '%1d') ');'] );
        %
        cla;
        %
        temp_color_string = ['ddr2_default_line_color_0' num2str(opopop, '%1d')] ;
        temp_color = evalin('base', temp_color_string);
        %
        plot(data_channel_separate_CELL{opopop}, 'Color', temp_color);
        %
        title_temp_content = ['Data Processing chain ' num2str(opopop, '%1d')];
        title(title_temp_content,  'FontName','MS Sans Serif', 'FontSize', 10, 'FontWeight', 'bold'); 
        %
        zoom on;
        %
        eval( ['set(handles.axes_DDR2_data_MULT_0' num2str(opopop, '%1d') ', ''Color'', plot_color_local);' ]);
        %
        if (cond_to_calc_Y_bounds)
            eval( ['set(handles.axes_DDR2_data_MULT_0' num2str(opopop, '%1d') ', ''YLim'', [minimum_Y_axis maximum_Y_axis]);'] );
        end
        eval( ['set(handles.axes_DDR2_data_MULT_0' num2str(opopop, '%1d') ', ''XLim'', [minimum_X_axis maximum_X_axis]);'] );
        %
        eval( ['set(handles.axes_DDR2_data_MULT_0' num2str(opopop, '%1d') ', ''FontName'', ''MS Sans Serif'', ''FontSize'', 7);'] );
    end
    % % PLOT ALL CHANNELS
    % % PLOT ALL CHANNELS
    
elseif (type_of_figure == 2)
    minimum_Y_axis = 1e100;
    maximum_Y_axis = -1e100;
    for qeqe = 1:number_of_processing_chains_local
        minimum_Y_axis = min([ minimum_Y_axis min(data_channel_separate_CELL{qeqe}) ]);
        maximum_Y_axis = max([ maximum_Y_axis max(data_channel_separate_CELL{qeqe}) ]);
    end
    max_amplitude_value = max(abs([maximum_Y_axis, minimum_Y_axis]));
    amplitude_range = maximum_Y_axis - minimum_Y_axis; 
    cond_to_calc_Y_bounds = (amplitude_range ~= 0);
    
    if (cond_to_calc_Y_bounds)
        extended_amp_range = free_part_of_plot_window * abs(amplitude_range);
        plot_reserve_empty = extended_amp_range/2/max_amplitude_value ;
        if ( (minimum_Y_axis < 0) && (maximum_Y_axis > 0) )
            minimum_Y_axis = minimum_Y_axis   -   plot_reserve_empty * max_amplitude_value;
            maximum_Y_axis = maximum_Y_axis +  plot_reserve_empty * max_amplitude_value;
        elseif (minimum_Y_axis > 0)
            maximum_Y_axis = maximum_Y_axis +  plot_reserve_empty * max_amplitude_value;
            minimum_Y_axis = minimum_Y_axis - plot_reserve_empty * max_amplitude_value;
        elseif (maximum_Y_axis < 0)
            minimum_Y_axis = minimum_Y_axis - plot_reserve_empty * max_amplitude_value;
            maximum_Y_axis = maximum_Y_axis + plot_reserve_empty * max_amplitude_value;
        end
    end
    %
    maximum_X_axis = -1e100;
    for qeqe = 1:number_of_processing_chains_local
        maximum_X_axis = max([ maximum_X_axis length(data_channel_separate_CELL{qeqe}) ]);
    end
    temp_max_X_axis = maximum_X_axis;
    maximum_X_axis = ceil(1.02* temp_max_X_axis);
    minimum_X_axis = - ceil(temp_max_X_axis * 0.02);
    
    % % PLOT ALL CHANNELS
    % % PLOT ALL CHANNELS
    axes(handles.axes_DDR2_data_SINGLE);
    %
    cla;
    
    for opopop = 1:number_of_processing_chains_local
         
        temp_color_string = ['ddr2_default_line_color_0' num2str(opopop, '%1d')] ;
        temp_color = evalin('base', temp_color_string);
        %
        plot(data_channel_separate_CELL{opopop}, 'Color', temp_color);
        % 
        hold all;
    end
    hold off; 
    title('All Data Processing Chains - Separate Plot for each Data Stream', 'FontName','MS Sans Serif', 'FontSize', 10, 'FontWeight', 'bold');
    zoom on;
    % % PLOT ALL CHANNELS
    % % PLOT ALL CHANNELS
    
    set(handles.axes_DDR2_data_SINGLE, 'Color', plot_color_local);
    if (cond_to_calc_Y_bounds)
        set(handles.axes_DDR2_data_SINGLE, 'YLim', [minimum_Y_axis maximum_Y_axis]);
    end
    set(handles.axes_DDR2_data_SINGLE, 'XLim', [minimum_X_axis maximum_X_axis]);
    %
    set(handles.axes_DDR2_data_SINGLE, 'FontName', 'MS Sans Serif', 'FontSize', 7);
   
elseif (type_of_figure == 3)

    axes(handles.axes_DDR2_data_SINGLE);
    %
    cla;
    
    minimum_Y_axis = min(data_from_libera_full);
    maximum_Y_axis = max(data_from_libera_full);
    max_amplitude_value = max(abs([maximum_Y_axis, minimum_Y_axis]));
    amplitude_range = maximum_Y_axis - minimum_Y_axis; 
    cond_to_calc_Y_bounds = (amplitude_range ~= 0);
    if (cond_to_calc_Y_bounds)
        extended_amp_range = free_part_of_plot_window * abs(amplitude_range);
        plot_reserve_empty = extended_amp_range/2/max_amplitude_value ;
        if ( (minimum_Y_axis < 0) && (maximum_Y_axis > 0) )
            minimum_Y_axis = minimum_Y_axis   -   plot_reserve_empty * max_amplitude_value;
            maximum_Y_axis = maximum_Y_axis +  plot_reserve_empty * max_amplitude_value;
        elseif (minimum_Y_axis > 0)
            maximum_Y_axis = maximum_Y_axis +  plot_reserve_empty * max_amplitude_value;
            minimum_Y_axis = minimum_Y_axis - plot_reserve_empty * max_amplitude_value;
        elseif (maximum_Y_axis < 0)
            minimum_Y_axis = minimum_Y_axis - plot_reserve_empty * max_amplitude_value;
            maximum_Y_axis = maximum_Y_axis + plot_reserve_empty * max_amplitude_value;
        end
    end
    %
    temp_max_X_axis = max( length(data_from_libera_full));
    maximum_X_axis = ceil(1.02* temp_max_X_axis);
    minimum_X_axis = - ceil(temp_max_X_axis * 0.02);
    
    temp_color = evalin('base', 'ddr2_default_line_color_01');
    %
    plot(data_from_libera_full, 'Color', temp_color);
    %
    title('All Data Processing Chains depicted as One Data Stream', 'FontName','MS Sans Serif', 'FontSize', 10, 'FontWeight', 'bold'); 
    %
    zoom on;
    %
    set(handles.axes_DDR2_data_SINGLE, 'Color', plot_color_local);
    %
    if (cond_to_calc_Y_bounds)
        set(handles.axes_DDR2_data_SINGLE, 'YLim', [minimum_Y_axis maximum_Y_axis]);
    end
    %
    set(handles.axes_DDR2_data_SINGLE, 'XLim', [minimum_X_axis maximum_X_axis]);
    %
    set(handles.axes_DDR2_data_SINGLE, 'FontName', 'MS Sans Serif', 'FontSize', 7);
else
end
% % % % % % % % % % P L O T I N G % %  %
% % % % % % % % % % P L O T I N G % %  %
% % % % % % % % % % P L O T I N G % %  %
% % % % % % % % % % P L O T I N G % %  %

drawnow;

% Update handles structure
guidata(handles.figure_data_acquisition_main_window, handles);

return;
