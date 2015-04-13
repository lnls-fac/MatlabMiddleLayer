function resetudferrors

Families = {'HCM','VCM','Q','BEND'};

for i = 1:length(Families)
    setpv(family2channel(Families{i}, 'Setpoint'),     'UDF', 0);
    setpv(family2channel(Families{i}, 'Monitor'),      'UDF', 0);
   %setpv(family2channel(Families{i}, 'RampRate'),     'UDF', 0);
   %setpv(family2channel(Families{i}, 'TimeConstant'), 'UDF', 0);
    setpv(family2channel(Families{i}, 'OnControl'),    'UDF', 0);
    setpv(family2channel(Families{i}, 'Ready'),        'UDF', 0);
end


% setpv(family2channel('TV', 'Setpoint'),  'UDF', 0);
% setpv(family2channel('TV', 'Monitor'),   'UDF', 0);
% setpv(family2channel('TV', 'In'),        'UDF', 0);
% setpv(family2channel('TV', 'InControl'), 'UDF', 0);
% setpv(family2channel('TV', 'Out'),       'UDF', 0);
% setpv(family2channel('TV', 'Lamp'),     'UDF', 0);

    
% setpv('Physics1.UDF',  0);
% setpv('Physics2.UDF',  0);
% setpv('Physics3.UDF',  0);
% setpv('Physics4.UDF',  0);
% setpv('Physics5.UDF',  0);
% setpv('Physics6.UDF',  0);
% setpv('Physics7.UDF',  0);
% setpv('Physics8.UDF',  0);
% setpv('Physics9.UDF',  0);
% setpv('Physics10.UDF', 0);
