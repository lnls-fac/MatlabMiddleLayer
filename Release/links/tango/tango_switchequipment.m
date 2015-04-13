function tango_switchequipment(FamilyName, CommandName)
% tango_switchequipment - tango command on a device using group

% TODO
% Check if command exist, has arguments ...

GroupId = family2tangogroup(FamilyName);
rep = tango_group_command_inout2(GroupId, CommandName);

pause(1)
rep = tango_group_command_inout2(GroupId, 'State');
for k=1:length(rep.replies),
    fprintf('%s %s \n', rep.replies(k).dev_name, rep.replies(k).data);
end
