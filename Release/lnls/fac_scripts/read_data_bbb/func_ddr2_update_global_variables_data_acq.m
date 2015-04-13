function func_ddr2_update_global_variables_data_acq(handles)

% % DATA PLOTTING PARAMETERS
% % DATA PLOTTING PARAMETERS
% 
% % Update Data Scaling parameters
 
temp_var_update = get(handles.checkbox_data_scaling, 'Value');
%
 
assignin('base','ddr2_default_plotting_scale_flag', temp_var_update);
% 
 
temp_var_update = str2double( get(handles.edit_data_scaling, 'String') );
%
 
assignin('base','ddr2_default_plotting_scale_value', temp_var_update);


% % Update Plotting type
 
temp_var_update_1 = get(handles.radiobutton_four_windows, 'Value');
if (temp_var_update_1)
    temp_var_update = 1;
else
    temp_var_update_2 = get(handles.radiobutton_one_window_four_data_streams, 'Value');
    if (temp_var_update_2)
        temp_var_update = 2;
    else
        temp_var_update = 3;
    end
end
%
 
assignin('base','ddr2_default_plotting_type_of_plot', temp_var_update);
% 
% % DATA PLOTTING PARAMETERS
% % DATA PLOTTING PARAMETERS

return;
