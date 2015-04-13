function [handles] = func_ddr2_enable_step(handles)


set(handles.radiobutton_four_windows, 'Enable', 'off', 'Visible', 'on');
%
set(handles.radiobutton_one_window_four_data_streams, 'Enable', 'off', 'Visible', 'on');

set(handles.edit_step, 'Enable', 'on', 'Visible', 'on');
%
set(handles.edit_step, 'BackgroundColor', [1 1 1]); 

set(handles.radiobutton_one_window_one_data_stream, 'Value', 1);


% Update handles structure
guidata(handles.figure_data_acquisition_main_window, handles);

return;
