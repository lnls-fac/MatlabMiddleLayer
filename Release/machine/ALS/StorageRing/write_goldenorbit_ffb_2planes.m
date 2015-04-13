function write_goldenorbit_ffb_2planes(Plane, GoldenOrbit, BPMlist)
%WRITE_GOLDENORBIT_FFTB_2PLANES - Sets the BPM setpoints which are used by the fast feedback system
%  write_goldenorbit_ffb_2planes(Plane, GoldenOrbit, BPMlist)
%
%  Christoph Steier, August 2002
%
%  6-19-06 T.Scarvie, modified to work with new Matlab Middle Layer


if nargin ~= 3
    error('write_goldenorbit_ffb_2planes needs 3 input arguments');
end

if Plane == 1
    ChannelName = family2channel('BPMx',BPMlist);
elseif Plane == 2
    ChannelName = family2channel('BPMy',BPMlist);
else
    error('Unknown plane.');
end

% Change to setpoint
ChannelName(:,end-2) = 'C'; 


% 'XT_AC' and 'YT_AC' setpoints are not being used yet
% (Still waiting on sectors 4, 8, 12)
i = find(ChannelName(:,end-5) ~= 'T');

% Since it's only used online
setpvonline(ChannelName(i,:), GoldenOrbit(i));

i = find(ChannelName(:,end-5) == 'T');
j = find(BPMlist(i,1)~=4 & BPMlist(i,1)~=8 & BPMlist(i,1)~=12);

setpvonline(ChannelName(i(j),:), GoldenOrbit(i(j)));

% if Plane == 1
%     for loop=1:size(BPMlist,1)
%         paramname=getname('BPMx',BPMlist(loop,:));
%         try
%             changeindex=findstr(paramname,'X_AM');
%             paramname(changeindex:(changeindex+3))='X_AC';
%             setpv(paramname,GoldenOrbit(loop));
%         catch
%             %changeindex=findstr(paramname,'XT_AM'); %don't use these BPMs yet, so this is an attempt to speed up orbit feedback
%             %paramname(changeindex:(changeindex+4))='XT_AC';
%         end
%         %setpv(paramname,GoldenOrbit(loop)); %SR04, 08, and 12 do not have FOFB setpoint channels yet
%     end
% elseif Plane == 2
%     for loop=1:size(BPMlist,1)
%         paramname=getname('BPMy',BPMlist(loop,:));
%         try
%             changeindex=findstr(paramname,'Y_AM');
%             paramname(changeindex:(changeindex+3))='Y_AC';
%             setpv(paramname,GoldenOrbit(loop));
%         catch
%             %changeindex=findstr(paramname,'YT_AM');
%             %paramname(changeindex:(changeindex+4))='YT_AC';
%         end
%         %setpv(paramname,GoldenOrbit(loop));
%     end
% end
