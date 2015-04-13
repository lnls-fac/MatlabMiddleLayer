function replies = tango_group_write_attribute2(group_id, attr_name, attr_value, forward)
%TANGO_GROUP_WRITE_ATTRIBUTES - enhance function with error handling
%
%  INPUTS
%  1. Group identification number
%  2. Attr_name Attribute name
%  3. attr_values Attribute value to write
%  4. forward
%
%  See Also tango_group_write_attribute

%
%% Written by Laurent S. Nadolski

if nargin < 3
   error('At least 3 arguments required');
end
if nargin < 4
   forward = 0;
end

replies = tango_group_write_attribute(group_id, attr_name, forward, attr_value);

if tango_error == -1 || (isnumeric(replies) &&  replies == -1)
    tango_print_error_stack
    return,
else
    if replies.has_failed 
        disp('Error when reading data for BPM');
        for k = 1:length(replies.replies),
            if replies.replies(k).has_failed
                fprintf('Error with device %s\n',replies.replies(k).dev_name)
                tango_print_error_stack_as_it_is(replies.replies(k).error)
            end
        end
    end
end