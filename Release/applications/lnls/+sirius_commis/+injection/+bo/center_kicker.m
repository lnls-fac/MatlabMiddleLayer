function param = center_kicker(machine, param, a)
% Takes the value 'a' of screen 2 after kicker correction to adjust the
% angle of injection to compensate the lack of adjustment of position at
% injection point with screens

injkckr = findcells(machine, 'FamName', 'InjKckr');
injkckr_struct = machine(injkckr(1));
injkckr_struct = injkckr_struct{1};
L_kckr = injkckr_struct.Length;

s = findspos(machine, 1:length(machine));

d = s(injkckr) + L_kckr;

dtheta = - a / d;

param.offset_xl_sist = param.offset_xl_sist + dtheta;
end

