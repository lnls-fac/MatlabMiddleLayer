function ids = epu_uvx_apple2(polarization)

ids = cell(1);
fold = '../id_modelling/EPU50/';

if polarization == 'HP'
    ids{1}.kicktable_file = [fold, 'EPU50_HP_kicktable.txt'];
    ids{1}.label = 'EPU50_HP_UVX';
elseif polarization == 'VP'
    ids{1}.kicktable_file = [fold, 'EPU50_VP_kicktable.txt'];
    ids{1}.label = 'EPU50_VP_UVX';
elseif polarization == 'CP'
    ids{1}.kicktable_file = [fold, 'EPU50_CP_kicktable.txt'];
    ids{1}.label = 'EPU50_CP_UVX';
end

ids{1}.nr_segs = 40;
ids{1}.straight_label  = 'mip';
ids{1}.straight_number = 15;
end
