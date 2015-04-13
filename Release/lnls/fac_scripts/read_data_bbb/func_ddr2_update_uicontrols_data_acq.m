function [handles] = func_ddr2_update_uicontrols_data_acq(handles)

% % % SET DATA ACQUISITION &&& PLOTTING PARAMETERS
% % % SET DATA ACQUISITION &&& PLOTTING PARAMETERS
%
% % Set Plotting type
ddr2_default_plotting_type_of_plot_local = evalin('base','ddr2_default_plotting_type_of_plot');
if (ddr2_default_plotting_type_of_plot_local == 1)
    set(handles.radiobutton_four_windows, 'Value', 1);
    %
    set(handles.radiobutton_one_window_four_data_streams, 'Value', 0);
    %
    set(handles.radiobutton_one_window_one_data_stream, 'Value', 0);
elseif (ddr2_default_plotting_type_of_plot_local == 2)
    set(handles.radiobutton_four_windows, 'Value', 0);
    %
    set(handles.radiobutton_one_window_four_data_streams, 'Value', 1);
    %
    set(handles.radiobutton_one_window_one_data_stream, 'Value', 0);
else
    set(handles.radiobutton_four_windows, 'Value', 1);
    %
    set(handles.radiobutton_one_window_four_data_streams, 'Value', 0);
    %
    set(handles.radiobutton_one_window_one_data_stream, 'Value', 1);
end

% % Set Plot Parameters
ddr2_default_plotting_scale_value_local = evalin('base','ddr2_default_plotting_scale_value');
%
set(handles.edit_data_scaling, 'String', num2str(ddr2_default_plotting_scale_value_local));
%
ddr2_default_plotting_scale_flag_local = evalin('base','ddr2_default_plotting_scale_flag');
%
if ddr2_default_plotting_scale_flag_local
    set(handles.checkbox_data_scaling, 'Value', 1);
    %
    [handles] = func_ddr2_enable_scale(handles);
else
    set(handles.checkbox_data_scaling, 'Value', 0);
    %
    [handles] = func_ddr2_disable_scale(handles);
end

% % % SET DATA ACQUISITION &&& PLOTTING PARAMETERS
% % % SET DATA ACQUISITION &&& PLOTTING PARAMETERS


return;
