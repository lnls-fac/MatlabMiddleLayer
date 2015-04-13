function [handles] = func_ddr2_disable_scale(handles)

standard_color_for_GUI = evalin('base', 'global_standard_color_for_GUI');
%
set(handles.edit_data_scaling, 'BackgroundColor', standard_color_for_GUI); 
%
set(handles.edit_data_scaling, 'Enable', 'inactive', 'Visible', 'on');


% Update handles structure
guidata(handles.figure_data_acquisition_main_window, handles);

return;
