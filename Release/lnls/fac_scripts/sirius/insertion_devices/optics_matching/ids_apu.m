function ids = ids_apu(id_names, phase)

ids = cell(1,length(id_names));
fold_apu22 = '../id_modelling/APU22/APUKyma22mm_kickmap_shift_';
fold_apu58 = '../id_modelling/APU58/APUKyma58mm_kickmap_shift_';

for i =1:length(id_names)
    switch id_names{i}
        case 'carnauba'
            if phase(i) == 0
                ids{i}.kicktable_file = [fold_apu22, '0.txt'];
                ids{i}.label = 'carnauba_phase_0mm';
            elseif phase(i) == 2.75
                ids{i}.kicktable_file = [fold_apu22, '2p75.txt'];
                ids{i}.label = 'carnauba_phase_2p75mm';
            elseif phase(i) == 5.5
                ids{i}.kicktable_file = [fold_apu22, '5p5.txt'];
                ids{i}.label = 'carnauba_phase_5p5mm';
            elseif phase(i) == 8.25
                ids{i}.kicktable_file = [fold_apu22, '-5p5.txt'];
                ids{i}.label = 'carnauba_phase_8p25mm';
            elseif phase(i) == 11
                ids{i}.kicktable_file = [fold_apu22, '11.txt'];
                ids{i}.label = 'carnauba_phase_11mm';
            end
            ids{i}.nr_segs = 40;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 6;
        case 'caterete'
            if phase(i) == 0
                ids{i}.kicktable_file = [fold_apu22, '0.txt'];
                ids{i}.label = 'caterete_phase_0mm';
            elseif phase(i) == 2.75
                ids{i}.kicktable_file = [fold_apu22, '2p75.txt'];
                ids{i}.label = 'caterete_phase_2p75mm';
            elseif phase(i) == 5.5
                ids{i}.kicktable_file = [fold_apu22, '5p5.txt'];
                ids{i}.label = 'caterete_phase_5p5mm';
            elseif phase(i) == 8.25
                ids{i}.kicktable_file = [fold_apu22, '-5p5.txt'];
                ids{i}.label = 'caterete_phase_8p25mm';
            elseif phase(i) == 11
                ids{i}.kicktable_file = [fold_apu22, '11.txt'];
                ids{i}.label = 'caterete_phase_11mm';
            end
            ids{i}.nr_segs = 40;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 7;
        case 'ema'
            if phase(i) == 0
                ids{i}.kicktable_file = [fold_apu22, '0.txt'];
                ids{i}.label = 'ema_phase_0mm';
            elseif phase(i) == 2.75
                ids{i}.kicktable_file = [fold_apu22, '2p75.txt'];
                ids{i}.label = 'ema_phase_2p75mm';
            elseif phase(i) == 5.5
                ids{i}.kicktable_file = [fold_apu22, '5p5.txt'];
                ids{i}.label = 'ema_phase_5p5mm';
            elseif phase(i) == 8.25
                ids{i}.kicktable_file = [fold_apu22, '-5p5.txt'];
                ids{i}.label = 'ema_phase_8p25mm';
            elseif phase(i) == 11
                ids{i}.kicktable_file = [fold_apu22, '11.txt'];
                ids{i}.label = 'ema_phase_11mm';
            end
            ids{i}.nr_segs = 40;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 8;
        case 'manaca'
            if phase(i) == 0
                ids{i}.kicktable_file = [fold_apu22, '0.txt'];
                ids{i}.label = 'manaca_phase_0mm';
            elseif phase(i) == 2.75
                ids{i}.kicktable_file = [fold_apu22, '2p75.txt'];
                ids{i}.label = 'manaca_phase_2p75mm';
            elseif phase(i) == 5.5
                ids{i}.kicktable_file = [fold_apu22, '5p5.txt'];
                ids{i}.label = 'manaca_phase_5p5mm';
            elseif phase(i) == 8.25
                ids{i}.kicktable_file = [fold_apu22, '-5p5.txt'];
                ids{i}.label = 'manaca_phase_8p25mm';
            elseif phase(i) == 11
                ids{i}.kicktable_file = [fold_apu22, '11.txt'];
                ids{i}.label = 'manaca_phase_11mm';
            end
            ids{i}.nr_segs = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 9;
        case 'ipe'
            if phase(i) == 0
                ids{i}.kicktable_file = [fold_apu58, '0_solved.txt'];
                ids{i}.label = 'ipe_phase_0mm_solved';
            elseif phase(i) == 7.25
                ids{i}.kicktable_file = [fold_apu58, '7.25_solved.txt'];
                ids{i}.label = 'ipe_phase_7p25mm';
            elseif phase(i) == 14.5
                ids{i}.kicktable_file = [fold_apu58, '14.5_solved.txt'];
                ids{i}.label = 'ipe_phase_14p5mm';
            elseif phase(i) == 21.75
                ids{i}.kicktable_file = [fold_apu58, '21.75_solved.txt'];
                ids{i}.label = 'ipe_phase_21p75mm';
            elseif phase(i) == 29
                ids{i}.kicktable_file = [fold_apu58, '29_solved.txt'];
                ids{i}.label = 'ipe_phase_29mm';
            end
            ids{i}.nr_segs = 40;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 11;
    end
end
