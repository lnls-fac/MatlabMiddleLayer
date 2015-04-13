function [StateNumber, StateString] = getsrstate
% [StateNumber, StateString] = getsrstate
%

if ~strcmpi(getmode(gethbpmfamily), 'Online')
    StateNumber = 0;
    StateString = 'Simulator';
    return;
end

StateNumber = getpv('SR_STATE');

if StateNumber == 0
   StateString = 'Unknown';
elseif StateNumber == 1
   StateString = 'Lattice cycled, ready for injection';
elseif StateNumber == -1
   StateString = 'Problem cycling lattice';
elseif StateNumber == 2
   StateString = 'Ready for injection';
elseif StateNumber == -2
   StateString = 'Problems setting up injection';
elseif StateNumber == 3
   StateString = 'User lattice';
elseif StateNumber == -3
   StateString = 'Problems setting up user lattice';
elseif StateNumber == 4
   StateString = 'Correcting the orbit';
elseif StateNumber == 4.1
   StateString = 'Orbit correction complete';
elseif StateNumber == -4
   StateString = 'Problems correcting the orbit';
elseif StateNumber == 5
   StateString = 'Orbit feedback running';
elseif StateNumber == 5.1
   StateString = 'Orbit feedback stopped';
elseif StateNumber == -5
   StateString = 'Problems with orbit feedback';
elseif StateNumber == 6
   StateString = 'Magnet Power Suppies Off';
elseif StateNumber == 6.1
   StateString = 'Magnet Turning Power Suppies Off';
elseif StateNumber == -6
   StateString = 'Problem Turning Power Suppies Off';
elseif StateNumber == 7
   StateString = 'Magnet Power Suppies On';
elseif StateNumber == 7.1
   StateString = 'Turning Magnet Power Suppies On';
elseif StateNumber == -7
   StateString = 'Problem Turning Power Suppies On';
else
   StateString = 'Unknown';
   StateNumber = 0;
   setpv('SR_STATE',0)
end

  

