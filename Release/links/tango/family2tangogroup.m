function [GroupId, ErrorFlag] = family2tangogroup(Family)
%FAMILY2TANGOGROUP - Return TANGO group family
% [GroupId, ErrorFlag] = family2tangogroup(Family, Field, DeviceList)
%
% INPUTS  
% 1. Family = Family Name 
%             Data Structure
%             Accelerator Object
%             Cell Array
% 
% OUTPUTS 
% 1. GroupId = Tango Group ID if defined, NaN otherwise
%
% See also family2tango, tango2family

% 
% Written by Laurent S. Nadolski


if nargin == 0
    error('Must have at least one input (''Family'')!');
end

if isstruct(Family)
    if isfield(Family,'FamilyName') 
        % For data structures (as returned by getpv)
        InputStruct = Family;       
        if isfield(InputStruct,'FamilyName')
            % Data structure
            Family = InputStruct.FamilyName;   
        else
            error('Family input of unknown type');
        end      
    end
end

if iscell(Family)    
    for i = 1:length(Family),
            [GroupId{i}, ErrorFlag{i}] = family2tangogroup(Family{i});
    end
    return    
end

% Check number of argment
if nargin <1
    error('Must have at least one input (''Family'')!');
end

% If valid familyname
if isfamily(Family)
    ErrorFlag = 0;
    GroupId = getfamilydata(Family,'GroupId');
    
    % if no group defined
    if isempty(GroupId)
        ErrorFlag = 1;
        GroupId = NaN;
    end
else % if not a valid family
    ErrorFlag = 1;
    GroupId = NaN;
end
