function ids = apu22_phase(phase)

ids = cell(1);
fold = '../id_modelling/APU22/APUKyma22mm_kickmap_shift_';

if phase == 0
    ids{1}.kicktable_file = [fold, '0.txt'];
    ids{1}.label = 'apu22_phase_0mm';
elseif phase == 2.75
    ids{1}.kicktable_file = [fold, '2p75.txt'];
    ids{1}.label = 'apu22_phase_2p75mm';
elseif phase == 5.5
    ids{1}.kicktable_file = [fold, '5p5.txt'];
    ids{1}.label = 'apu22_phase_5p5mm';
elseif phase == 8.25
    ids{1}.kicktable_file = [fold, '-5p5.txt'];
    ids{1}.label = 'apu22_phase_8p25mm';
elseif phase == 11
    ids{1}.kicktable_file = [fold, '11.txt'];
    ids{1}.label = 'apu22_phase_11mm';
end

ids{1}.nr_segs = 40;
ids{1}.straight_label  = 'mia';
ids{1}.straight_number = 9;
end
