function ids = ids_select(ids_names)
%ids = select_ids(ids_names)
% Select ids to be insert in the lattice;
% INPUT : id_names  - cellarray of strings defining the names of the IDS
% OUTPUT: ids       - array of structs with the ids properties
path2kcktbls = ['/home/fac_files/code/MatlabMiddleLayer/Release/',...
                'lnls/fac_scripts/sirius/insertion_devices/id_modelling/'];

ids = cell(1,length(ids_names));
for i =1:length(ids_names)
    switch ids_names{i}
        case 'carnauba'
            % trechos impares - Betas Baixos
            % --- phase 1 ---
            ids{i}.label           = 'carnauba';
            ids{i}.kicktable_file  = [path2kcktbls, 'U19/U19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 6;
        case 'ema'
            ids{i}.label           = 'ema';
            ids{i}.kicktable_file  = [path2kcktbls, 'U19/U19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 8;
        case 'inga'
            ids{i}.label           = 'inga';
            ids{i}.kicktable_file  = [path2kcktbls, 'U25_2ID/U25_2ID_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 9;
        case 'caterete'
            ids{i}.label           = 'caterete';
            ids{i}.kicktable_file  = [path2kcktbls, 'U19/U19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 10;
        case 'ipe_lh'
            ids{i}.label           = 'ipe_hp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_HP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 11;
        case 'ipe_lv'
            ids{i}.label           = 'ipe_vp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_VP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 11;
        case 'ipe_cp'
            ids{i}.label           = 'ipe_cp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_CP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 11;
        case 'sabia_hp'
            ids{i}.label           = 'sabia';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_HP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 12;
        case 'sabia_vp'
            ids{i}.label           = 'sabia';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_VP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 12;
        case 'sabia_cp'
            ids{i}.label           = 'sabia';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_CP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 12;
        case 'manaca'
            ids{i}.label           = 'manaca';
            ids{i}.kicktable_file  = [path2kcktbls, 'U19/U19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 14;
            
            
        case 'caterete2'
            % --- phase 2 ---
            ids{i}.label           = 'caterete2';
            ids{i}.kicktable_file  = [path2kcktbls, 'U19/U19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 2;
        case 'caterete3'
            % --- phase 2 ---
            ids{i}.label           = 'caterete3';
            ids{i}.kicktable_file  = [path2kcktbls, 'U19/U19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 18;
        case 'ema2'
            ids{i}.label           = 'ema2';
            ids{i}.kicktable_file  = [path2kcktbls, 'U19/U19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 4;
        case 'ema3'
            ids{i}.label           = 'ema3';
            ids{i}.kicktable_file  = [path2kcktbls, 'U19/U19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 20;
        case 'manaca2'
            ids{i}.label           = 'manaca2';
            ids{i}.kicktable_file  = [path2kcktbls, 'U19/U19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 14;
        case 'carnauba2'
            ids{i}.label           = 'carnauba2';
            ids{i}.kicktable_file  = [path2kcktbls, 'U19/U19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 16;
            % trechos impares - Betas Altos
%         case 'jatoba'
%             % --- phase 1 ---
%             ids{i}.label           = 'jatoba';
%             ids{i}.kicktable_file  = [path2kcktbls, 'SCW4T/SCW4T_kicktable.txt'];
%             ids{i}.nr_segs         = 20;
%             ids{i}.straight_label  = 'mia';
%             ids{i}.straight_number = 4;
        
        
        case 'sabia_ph'
            ids{i}.label           = 'sabia';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PH_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 13;
        case 'sabia_pv'
            ids{i}.label           = 'sabia';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PV_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 13;
%         case 'sabia'
%             ids{i}.label           = 'sabia';
%             ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PH_kicktable_6p5meters.txt'];
%             ids{i}.nr_segs         = 40;
%             ids{i}.straight_label  = 'mia';
%             ids{i}.straight_number = 7;
        case 'inga2'
            % --- phase 2 ---
            ids{i}.label           = 'inga2';
            ids{i}.kicktable_file  = [path2kcktbls, 'U25/U25_2ID_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 5;
        case 'sabia2_ph'
            ids{i}.label           = 'sabia2';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PH_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 15;
        case 'sabia2_pv'
            ids{i}.label           = 'sabia2';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PV_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 15;
%         case 'sabia2'
%             ids{i}.label           = 'sabia2';
%             ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PH_kicktable_6p5meters.txt'];
%             ids{i}.nr_segs         = 40;
%             ids{i}.straight_label  = 'mia';
%             ids{i}.straight_number = 8;
        case 'sabia3_ph'
            ids{i}.label           = 'sabia3';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PH_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 7;
        case 'sabia3_pv'
            ids{i}.label           = 'sabia3';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PV_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 7;
        case 'ipe2_ph'
            ids{i}.label           = 'ipe2';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PH_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 17;
        case 'ipe2_pv'
            ids{i}.label           = 'ipe2';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PV_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 17;
        case 'ipe3_ph'
            ids{i}.label           = 'ipe3';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PH_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 19;
        case 'ipe3_pv'
            ids{i}.label           = 'ipe3';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PV_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 19;
        case 'dhscu20'
            % -- tests --
            ids(i).label           = 'dhscu20';
            ids(i).kicktable_file  = [path2kcktbls, 'DHSCU20/DHSCU20_PL.txt'];
            ids(i).nr_segs         = 20;
            ids(i).straight_label  = 'mib';
            ids(i).straight_number = 20;
        case 'epu80pv'
            ids(i).label           = 'epu80pv';
            ids(i).kicktable_file  = [path2kcktbls, 'EPU80/EPU80_2ID_PV_kicktable.txt'];
            ids(i).nr_segs         = 40;
            ids(i).straight_label  = 'mia';
            ids(i).straight_number = 16;
        otherwise
            error('ID not recognized');
    end
end