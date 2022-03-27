function ids = apu58_phase(phase)

ids = cell(1);
fold = '../id_modelling/APU58/APUKyma58mm_kickmap_shift_';

if phase == 0
    ids{1}.kicktable_file = [fold, '0_solved.txt'];
    ids{1}.label = 'apu58_phase_0mm';
elseif phase == 7.25
    ids{1}.kicktable_file = [fold, '7.25_solved.txt'];
    ids{1}.label = 'apu58_phase_7p25mm';
elseif phase == 14.5
    ids{1}.kicktable_file = [fold, '14.5_solved.txt'];
    ids{1}.label = 'apu58_phase_14p5mm';
elseif phase == 21.75
    ids{1}.kicktable_file = [fold, '21.75_solved.txt'];
    ids{1}.label = 'apu58_phase_21p75mm';
elseif phase == 29
    ids{1}.kicktable_file = [fold, '29_solved.txt'];
    ids{1}.label = 'apu58_phase_29mm';
end

ids{1}.nr_segs = 40;
ids{1}.straight_label  = 'mip';
ids{1}.straight_number = 11;
end
