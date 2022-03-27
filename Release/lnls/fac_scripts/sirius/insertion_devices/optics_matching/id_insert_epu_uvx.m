function ids = id_insert_epu_uvx(polari)

ids = cell(1);
fold = '/home/facs/repos/MatlabMiddleLayer/Release/lnls/fac_scripts/sirius/insertion_devices/id_modelling/EPU50/';

if polari == 'HP'
    ids{1}.kicktable_file = [fold, 'EPU50_HP_kicktable.txt'];
    ids{1}.label = 'EPU50_HP_UVX';
elseif polari == 'VP'
    ids{1}.kicktable_file = [fold, 'EPU50_VP_kicktable.txt'];
    ids{1}.label = 'EPU50_VP_UVX';
elseif polari == 'CP'
    ids{1}.kicktable_file = [fold, 'EPU50_CP_kicktable.txt'];
    ids{1}.label = 'EPU50_CP_UVX';
end

ids{1}.nr_segs = 40;
ids{1}.straight_label  = 'mip'; 
ids{1}.straight_number = 15;
end

