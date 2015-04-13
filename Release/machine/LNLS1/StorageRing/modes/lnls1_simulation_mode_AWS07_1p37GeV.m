function lnls1_simulation_mode_AWS07_1p37GeV

%{
lnls1_set_id_field('AWG01', 0);
lnls1_set_id_field('AWG09', 0);
lnls1_set_id_field('AON11', 0);
lnls1_set_id_field('AWS07', 2.304827359446053);
setpv('QD',      'Physics',  -2.966760294677084);
setpv('A2QD07',  'Physics',  -2.967524313348996);
setpv('QF',      'Physics',   2.770024386714366);
setpv('A2QF07',  'Physics',   2.770462765879043);
setpv('QFC',     'Physics',   1.960547029161874);
setpv('SD',      'Physics', -39.860455880296364);
setpv('SF',      'Physics', 56.844346161490897);
%}

lnls1_set_id_field('AWG01', 0);
lnls1_set_id_field('AWG09', 0);
lnls1_set_id_field('AON11', 0);
lnls1_set_id_field('AWS07', 2.304827359446053);

setpv('QF',     'Physics',  2.769797597571764);
setpv('A2QF07', 'Physics',  2.774227007274041);
setpv('QD',     'Physics', -2.966716951336110);
setpv('A2QD07', 'Physics', -2.969064114259590);
setpv('QFC', 'Physics',  1.961093182324501);
setpv('SD',  'Physics', -39.860455880296364);
setpv('SF',  'Physics', 56.844346161490897);
