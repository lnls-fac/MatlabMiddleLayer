function [AM, tout, DataTime, ErrorFlag]  = tango_group_read_attribute2(group_id, attr_name, forward)
%TANGO_GROUP_WRITE_ATTRIBUTES - enhance function with error handling
%
%  INPUTS
%  1. Group identification number
%  2. Attr_name Attribute name
%  3. forward
%
%  See Also tango_group_read_attribute

%
%% Written by Laurent S. Nadolski
% 3 December, modification for handling vectors

DataTime = 0;

if nargin < 2
   error('At least 2 arguments required');
end
if nargin < 3
   forward = 0;
end

replies = tango_group_read_attribute(group_id, attr_name, forward);

if tango_error == -1
    tango_print_error_stack;
    ErrorFlag = 1;
    tout = etime(clock, t0);
    return;
else
    if replies.has_failed > 0
        ErrorFlag = 1;
        for k=1:length(replies.replies),
            if replies.replies(k).has_failed
                tango_print_error_stack_as_it_is(replies.replies(k).error);
            end
        end
        ErrorFlag = 1;
        tout = etime(clock, t0);
        %return;
    end
end

% construct data
%vectorSize = replies.replies(1).n; 
vectorSize = max([replies.replies.n]); % to take care of disabled BPMs
AM = ones(length(replies.replies), vectorSize)*NaN;

for k = 1:length(replies.replies),    
    if ~replies.replies(k).has_failed && replies.replies(k).is_enabled 
        AM(k,:) = replies.replies(k).value(1:vectorSize);
    else
        AM(k,:) = NaN;
    end
end
