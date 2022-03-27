function ids = apu58_shift(shift)

ids = cell(1);
fold = '../id_modelling/APU58/APUKyma58mm_kickmap_shift_';

if shift == 0
    ids{1}.kicktable_file = [fold, '0_solved.txt'];
    ids{1}.label = 'ipe_shift_0mm_solved';
elseif shift == 7.25
    ids{1}.kicktable_file = [fold, '7.25_solved.txt'];
    ids{1}.label = 'ipe_shift_7p25mm';
elseif shift == 14.5
    ids{1}.kicktable_file = [fold, '14.5_solved.txt'];
    ids{1}.label = 'ipe_shift_14p5mm';
elseif shift == 21.75
    ids{1}.kicktable_file = [fold, '21.75_solved.txt'];
    ids{1}.label = 'ipe_shift_21p75mm';
elseif shift == 29
    ids{1}.kicktable_file = [fold, '29_solved.txt'];
    ids{1}.label = 'ipe_shift_29mm';
end

ids{1}.nr_segs = 40;
ids{1}.straight_label  = 'mip'; 
ids{1}.straight_number = 11;
end

