function [handles] = func_ddr2_disable_step(handles)

set(handles.radiobutton_four_windows, 'Enable', 'on', 'Visible', 'on');
%
set(handles.radiobutton_one_window_four_data_streams, 'Enable', 'on', 'Visible', 'on');

standard_color_for_GUI = evalin('base', 'global_standard_color_for_GUI');
%
set(handles.edit_step, 'BackgroundColor', standard_color_for_GUI); 
%
set(handles.edit_step, 'Enable', 'inactive', 'Visible', 'on');


% Update handles structure
guidata(handles.figure_data_acquisition_main_window, handles);

return;
