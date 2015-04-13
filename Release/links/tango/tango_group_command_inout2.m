function argout = tango_group_command_inout2 (grp_id, cmd_name, forget, forward, varargin)
%tango_group_command_inout Executes asynchronously the TANGO command <cmd_name> on the specified group.
%
% See also TANGO_GROUP_COMMAND_INOUT_ASYNCH, TANGO_GROUP_COMMAND_argout.
%

if nargin < 2
   error('At least 2 arguments required');
end

% No answer 
if nargin < 3
   forget = 1;
end

% No subgroup
if nargin < 4
   forward = 0;
end

argout = tango_group_command_inout(grp_id, cmd_name, forget, forward, varargin);
% Error parsing for group command
if (argout.has_failed)
    for k=1:length(argout.replies)
        if argout.replies(k).has_failed
            for k1 = 1:length(argout.replies(k).error)
                argout.replies(k).error(k1)
            end
        end
    end
end

