function IDKickMap = create_kickmap_U72PPM

% unidades
mm    = 1;
Tesla = 1;

% parametros do ID
id_def.id_label = 'U72PPM';
id_def.nr_periods          = 116;
id_def.magnetic_gap        = 17.2495 * mm;
id_def.period              = 72 * mm;
id_def.cassette_separation = 0.001 * mm; % diferente de zero para evitar singularidades nas expressões
id_def.block_separation    = 0  * mm;
id_def.block_width         = 50 * mm;
id_def.block_height        = 40 * mm;
id_def.phase_csd           = 0  * mm;
id_def.phase_cie           = 0  * mm;
id_def.chamfer             = 0  * mm;
id_def.magnetization       = 1.24 * Tesla;


% parametros do mapa de kick
kickmaps_def.kicktable_lim_inf_x = -40 * mm;
kickmaps_def.kicktable_lim_sup_x =  40 * mm;
kickmaps_def.kicktable_lim_inf_z = -(id_def.magnetic_gap/2 - 0.1 * mm);
kickmaps_def.kicktable_lim_sup_z =   id_def.magnetic_gap/2 - 0.1 * mm;
kickmaps_def.symmetric_kickmap   = true;
kickmaps_def.kicktable_npts_x    = 81;
kickmaps_def.kicktable_npts_z    = 17;

% parametros do feixe e do ponto de instalação
ebeam_def = kickmap_ebeam_def('Low Emittance','ml');


IDKickMap.id_def = id_def;
IDKickMap.kickmaps_def = kickmaps_def;
IDKickMap.ebeam_def = ebeam_def;

% cria modelo 3D (a la Radia)
IDKickMap.id_model = epu_create(IDKickMap.id_def);

% calcula mapas de kicks
IDKickMap.kickmaps = kickmap_calc_kickmaps(IDKickMap.id_model, IDKickMap.id_def, IDKickMap.kickmaps_def);

% gera tabelas de kicks em arquivo
kickmap_save_kickmap_tables(IDKickMap.id_def, IDKickMap.kickmaps);

% calcula efeito do ID sobre feixe
IDKickMap.ebeam_dtune = kickmap_calc_dtunes(IDKickMap.id_def, IDKickMap.kickmaps, IDKickMap.ebeam_def);


% grava dados
save(IDKickMap.id_def.id_label, 'IDKickMap');

% plota resultados
kickmap_plots(IDKickMap);

% salva resultados
kickmap_save_plots;