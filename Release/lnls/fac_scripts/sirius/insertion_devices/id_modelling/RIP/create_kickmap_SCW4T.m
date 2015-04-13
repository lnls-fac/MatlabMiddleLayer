function IDKickMap = create_kickmap_SCW4T

fit_scw4tdata = false;

% lê dados de medidas do SCW4T

if fit_scw4tdata
    addpath('SCW4T KickMaps');
    scw4tdata = read_scw4tdata;
end


% unidades
mm    = 1;
Tesla = 1;

% parametros do ID
id_def.id_label = 'SCW4T';
id_def.nr_periods          = 16;
id_def.magnetic_gap        = 18.4 * mm;
id_def.cassette_separation = 0.001 * mm; % diferente de zero para evitar singularidades nas expressões
id_def.block_separation    = 0  * mm;
id_def.block_width         = 50 * mm;
id_def.block_height        = 40 * mm;
id_def.phase_csd           = 0  * mm;
id_def.phase_cie           = 0  * mm;
id_def.chamfer             = 0  * mm;

if fit_scw4tdata
    id_def.period              = scw4tdata.period;
    % calibra amplitude de campo;
    id_def.magnetization       = 1.24 * Tesla;
    IDKickMap.model = epu_create(params);
    posy = linspace(0,id_def.period, 50);
    pos  = zeros(3,length(posy));
    pos(2,:) = posy;
    field = epu_field(IDKickMap.model, pos);
    [Maxbz idx] = max(field(3,:));
    posy_max = pos(2,idx);
    id_def.magnetization = id_def.magnetization * (scw4tdata.Maxbz / Maxbz);
    posx = linspace(-12,12,25);
    pos  = zeros(3,length(posx));
    pos(1,:) = posx;
    pos(2,:) = posy_max;
    % calibra largura dos blocos
    block_width = 30:1:50;
    sext = zeros(size(block_width));
    for i=1:length(block_width)
        id_def.block_width = block_width(i);
        IDKickMap.model = epu_create(params);
        field = epu_field(IDKickMap.model, pos);
        p = polyfit(posx, field(3,:), 4);
        sext(i) = p(3);
    end
    bwidth = interp1(abs(sext), block_width, scw4tdata.sextupole, 'cubic');
    id_def.block_width = bwidth;
else
    id_def.period = 59.19 * mm;
    id_def.magnetization = 6.2104 * Tesla;
    id_def.block_width = 39.734358709704878 * mm;
end


% parametros do mapa de kick
kickmaps_def.kicktable_lim_inf_x = -40 * mm;
kickmaps_def.kicktable_lim_sup_x =  40 * mm;
kickmaps_def.kicktable_lim_inf_z = -(id_def.magnetic_gap/2 - 0.1 * mm);
kickmaps_def.kicktable_lim_sup_z =   id_def.magnetic_gap/2 - 0.1 * mm;
kickmaps_def.symmetric_kickmap   = true;
kickmaps_def.kicktable_npts_x    = 81;
kickmaps_def.kicktable_npts_z    = 17;

% parametros do feixe e do ponto de instalação
ebeam_def = kickmap_ebeam_def('Low Emittance','ms');


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