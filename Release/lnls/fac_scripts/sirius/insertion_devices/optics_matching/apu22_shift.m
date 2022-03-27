function ids = apu22_shift(shift)

ids = cell(1);
fold = '../id_modelling/APU22/APUKyma22mm_kickmap_shift_';

if shift == 0
    ids{1}.kicktable_file = [fold, '0.txt'];
    ids{1}.label = 'manaca_shift_0mm';
elseif shift == 2.75
    ids{1}.kicktable_file = [fold, '2p75.txt'];
    ids{1}.label = 'manaca_shift_2p75mm';
elseif shift == 5.5
    ids{1}.kicktable_file = [fold, '5p5.txt'];
    ids{1}.label = 'manaca_shift_5p5mm';
elseif shift == 8.25
    ids{1}.kicktable_file = [fold, '-5p5.txt'];
    ids{1}.label = 'manaca_shift_8p25mm';
elseif shift == 11
    ids{1}.kicktable_file = [fold, '11.txt'];
    ids{1}.label = 'manaca_shift_11mm';
end

ids{1}.nr_segs = 40;
ids{1}.straight_label  = 'mia'; 
ids{1}.straight_number = 9;
end

