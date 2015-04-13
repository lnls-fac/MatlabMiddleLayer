function stepenergy(ScaleFactor)


% Booster extration kicker
Name(1,:) = 'BR2_____KE_____AC00';


% Booster bump magnets
Name(2,:) = 'BR2_____BUMP1__AC00';
Name(3,:) = 'BR2_____BUMP2__AC01';
Name(4,:) = 'BR2_____BUMP3__AC00';


% Booster Thin Septum
Name(5,:) = 'BR2_____SEN____AC00';


% Booster Thick Septum
Name(6,:) = 'BR2_____SEK____AC01';


% SR Thick Septum
Name(7,:) = 'SR01S___SEK____AC01';


% SR Thin Septum
Name(8,:) = 'SR01S___SEN____AC00';



% Get the starting point
InjSetpoints = getpv(Name);
Q            = getsp('Q');
BEND         = getsp('BEND');


% Make the change
setpv(Name,   ScaleFactor * InjSetpoints);
setsp('Q',    ScaleFactor * Q);
setsp('BEND', ScaleFactor * BEND);





