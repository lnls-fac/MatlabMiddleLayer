function [handles] = func_ddr2_generate_axes_objects(handles, axes_number)


 
standard_color_for_GUI = evalin('base', 'global_standard_color_for_GUI');
%
 
number_of_processing_chains_temp = evalin('base', 'global_number_of_processing_chains');


if (axes_number == 0)
     
    %
    if( isfield(handles, 'axes_DDR2_data_SINGLE') == 0)
        temp_handle_axes = axes('Parent', handles.figure_data_acquisition_main_window, ...
                         'Units', 'normalized', ...
                         'HandleVisibility','callback', ...
                         'ActivePositionProperty', 'outerposition', ...
                         'OuterPosition',[0 0.31 1 0.69], ...
                         'Color', standard_color_for_GUI,...
                         'Visible', 'off',...
                         'FontName', 'MS Sans Serif', ...
                         'FontSize', 8);

         
        %
        handles.axes_DDR2_data_SINGLE = temp_handle_axes;
    end
end

if (axes_number == 1)
     
    %
    if( isfield(handles, 'axes_DDR2_data_MULT_01') == 0)
        temp_handle_axes_01 = axes('Parent', handles.figure_data_acquisition_main_window, ...
                 'Units', 'normalized', ...
                 'HandleVisibility','callback', ...
                 'ActivePositionProperty', 'outerposition', ...
                 'Color', standard_color_for_GUI,...
                 'Visible', 'off', ...
                 'FontName', 'MS Sans Serif', ...
                 'FontSize', 8);
        if (number_of_processing_chains_temp == 4)
            set(temp_handle_axes_01, 'OuterPosition', [0 0.65 0.5 0.35]);
        elseif(number_of_processing_chains_temp == 5)
            set(temp_handle_axes_01, 'OuterPosition', [0 0.77 0.5 0.23]);
        else
            set(temp_handle_axes_01, 'OuterPosition', [0 0.31 1 0.69]);
        end
        %
         
        handles.axes_DDR2_data_MULT_01 = temp_handle_axes_01;
    end
end


if (axes_number == 2)
     
    %
    if( isfield(handles, 'axes_DDR2_data_MULT_02') == 0)
        temp_handle_axes_02 = axes('Parent', handles.figure_data_acquisition_main_window, ...
                         'Units', 'normalized', ...
                         'HandleVisibility','callback', ...
                         'ActivePositionProperty', 'outerposition', ...
                         'Color', standard_color_for_GUI,...
                         'Visible', 'off', ...
                         'FontName', 'MS Sans Serif', ...
                         'FontSize', 8);

        if (number_of_processing_chains_temp == 4)
            set(temp_handle_axes_02, 'OuterPosition', [0.5 0.65 0.5 0.35]);
        elseif(number_of_processing_chains_temp == 5)
            set(temp_handle_axes_02, 'OuterPosition', [0.5 0.77 0.5 0.23]);
        else
            set(temp_handle_axes_02, 'OuterPosition', [0 0.31 1 0.69]);
        end
        %
         
        handles.axes_DDR2_data_MULT_02 = temp_handle_axes_02;
    end
end

if (axes_number == 3)
     
    %
    if( isfield(handles, 'axes_DDR2_data_MULT_03') == 0)
        temp_handle_axes_03 = axes('Parent', handles.figure_data_acquisition_main_window, ...
                         'Units', 'normalized', ...
                         'HandleVisibility','callback', ...
                         'ActivePositionProperty', 'outerposition', ...
                         'Color', standard_color_for_GUI,...
                         'Visible', 'off', ...
                         'FontName', 'MS Sans Serif', ...
                         'FontSize', 7);

        if (number_of_processing_chains_temp == 4)
            set(temp_handle_axes_03, 'OuterPosition', [0 0.3 0.5 0.35]);
        elseif(number_of_processing_chains_temp == 5)
            set(temp_handle_axes_03, 'OuterPosition', [0 0.54 0.5 0.23]);
        else
            set(temp_handle_axes_03, 'OuterPosition', [0 0.31 1 0.69]);
        end
        %
         
        handles.axes_DDR2_data_MULT_03 = temp_handle_axes_03;
    end
end

if (axes_number == 4)
     
    %
    if( isfield(handles, 'axes_DDR2_data_MULT_04') == 0)
        temp_handle_axes_04 = axes('Parent', handles.figure_data_acquisition_main_window, ...
                         'Units', 'normalized', ...
                         'HandleVisibility','callback', ...
                         'ActivePositionProperty', 'outerposition', ...
                         'Color', standard_color_for_GUI,...
                         'Visible', 'off', ...
                         'FontName', 'MS Sans Serif', ...
                         'FontSize', 8);

        if (number_of_processing_chains_temp == 4)
            set(temp_handle_axes_04, 'OuterPosition', [0.5 0.3 0.5 0.35]);
        elseif(number_of_processing_chains_temp == 5)
            set(temp_handle_axes_04, 'OuterPosition', [0.5 0.54 0.5 0.23]);
        else
            set(temp_handle_axes_04, 'OuterPosition', [0 0.31 1 0.69]);
        end
        %
         
        handles.axes_DDR2_data_MULT_04 = temp_handle_axes_04;
    end
end

if (axes_number == 5)
     
    %
    if( isfield(handles, 'axes_DDR2_data_MULT_05') == 0)
        temp_handle_axes_05 = axes('Parent', handles.figure_data_acquisition_main_window, ...
                         'Units', 'normalized', ...
                         'HandleVisibility','callback', ...
                         'ActivePositionProperty', 'outerposition', ...
                         'Color', standard_color_for_GUI,...
                         'Visible', 'off', ...
                         'FontName', 'MS Sans Serif', ...
                         'FontSize', 8);

        if(number_of_processing_chains_temp == 5)
            set(temp_handle_axes_05, 'OuterPosition', [0 0.31 0.5 0.23]);
        else
            set(temp_handle_axes_05, 'OuterPosition', [0 0.31 1 0.69]);
        end
        %
         
        handles.axes_DDR2_data_MULT_05 = temp_handle_axes_05;
    end
end

 
%
% Update handles structure
guidata(handles.figure_data_acquisition_main_window, handles);

return;
