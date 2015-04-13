function [handles] = func_ddr2_enable_scale(handles)


set(handles.edit_data_scaling, 'Enable', 'on', 'Visible', 'on');
%
set(handles.edit_data_scaling, 'BackgroundColor', [1 1 1]); 

% Update handles structure
guidata(handles.figure_data_acquisition_main_window, handles);

return;
