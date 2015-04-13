function tango_print_error_stack2
%TANGO_PRINT_ERROR_STACK Prints the TANGO error stack in the command window.
%
% Syntax:
% -------
%   tango_print_error_stack
%
% Example:
% --------
%   %- get "unknown command" info
%   cmd_info = tango_command_query('tango/tangotest/3', 'dummy');
%   %- always check error
%   if (tango_error == -1)
%     %- handle error (cmd_info is not valid - DO NOT USE IT)
%     %- print error stack
%     tango_print_error_stack;
%     %- can't continue
%     return;
%   end
%   %- cmd_info is valid
%   disp(cmd_info);
%
%   This code generates the following output:
%
%   ************************************************************
%   *                    TANGO ERROR STACK                     *
%   ************************************************************
%   - ERROR 1
%   	|-reason.....API_CommandNotFound
%   	|-desc.......Command dummy not found
%   	|-origin.....Device_2Impl::command_query_2
%   	|-severity...Error (1)
%   - ERROR 2
%   	|-reason.....command_query failed
%   	|-desc.......failed to execute command_query on device tango/tangotest/3
%   	|-origin.....TangoBinding::command_query
%   	|-severity...Error (1)
%   ************************************************************
%   
%   See also TANGO_ERROR_STACK, TANGO_ERROR

fprintf('************************************************************\n', datestr(clock))
fprintf('*                  %s                    *\n', datestr(clock))
tango_print_error_stack