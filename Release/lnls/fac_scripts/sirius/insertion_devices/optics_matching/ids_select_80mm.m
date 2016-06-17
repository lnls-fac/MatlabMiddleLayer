function ids = ids_select_80mm(ids_names)
%ids = select_ids(ids_names)
% Select ids to be insert in the lattice;
% INPUT : id_names  - cellarray of strings defining the names of the IDS
% OUTPUT: ids       - array of structs with the ids properties
path2kcktbls = ['/home/fac_files/code/MatlabMiddleLayer/Release/',...
                'lnls/fac_scripts/sirius/insertion_devices/id_modelling/'];

ids = cell(1,length(ids_names));
for i =1:length(ids_names)
    switch ids_names{i}
        
        % PHASE1
        case 'carnauba'
            % trechos impares - Betas Baixos
            % --- phase 1 ---
            ids{i}.label           = 'carnauba';
            ids{i}.kicktable_file  = [path2kcktbls, 'IVU19/IVU19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 6;
        case 'ema'
            ids{i}.label           = 'ema';
            ids{i}.kicktable_file  = [path2kcktbls, 'IVU19/IVU19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 8;
        case 'inga'
            ids{i}.label           = 'inga';
            ids{i}.kicktable_file  = [path2kcktbls, 'IVU25/IVU25_2ID_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 9;
        case 'caterete'
            ids{i}.label           = 'caterete';
            ids{i}.kicktable_file  = [path2kcktbls, 'IVU19/IVU19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 10;
        case 'ipe_hp'
            ids{i}.label           = 'ipe_hp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU50/EPU50_HP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 11;
        case 'ipe_vp'
            ids{i}.label           = 'ipe_vp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU50/EPU50_VP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 11;
        case 'ipe_cp'
            ids{i}.label           = 'ipe_cp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU50/EPU50_CP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 11;
        case 'sabia_hp'
            ids{i}.label           = 'sabia_hp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_HP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 12;
        case 'sabia_vp'
            ids{i}.label           = 'sabia_vp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_VP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 12;
        case 'sabia_cp'
            ids{i}.label           = 'sabia_cp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_CP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 12;
        case 'manaca'
            ids{i}.label           = 'manaca';
            ids{i}.kicktable_file  = [path2kcktbls, 'IVU19/IVU19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 14;
        
        %PHASE2    
        case 'carnauba2'
            ids{i}.label           = 'carnauba2';
            ids{i}.kicktable_file  = [path2kcktbls, 'IVU19/IVU19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 16;
        case 'ema2'
            ids{i}.label           = 'ema2';
            ids{i}.kicktable_file  = [path2kcktbls, 'IVU19/IVU19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 4; 
        case 'inga2'
            ids{i}.label           = 'inga2';
            ids{i}.kicktable_file  = [path2kcktbls, 'IVU25/IVU25_2ID_kicktable.txt'];
            ids{i}.nr_segs         = 40;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 5;  
        case 'caterete2'
            ids{i}.label           = 'caterete2';
            ids{i}.kicktable_file  = [path2kcktbls, 'IVU19/IVU19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 2; 
        case 'ipe2_hp'
            ids{i}.label           = 'ipe2_hp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU50/EPU50_HP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 17;
        case 'ipe2_vp'
            ids{i}.label           = 'ipe2_vp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU50/EPU50_VP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 17;
        case 'ipe2_cp'
            ids{i}.label           = 'ipe2_cp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU50/EPU50_CP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 17;
        case 'sabia2_hp'
            ids{i}.label           = 'sabia2_hp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_HP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 18;
        case 'sabia2_vp'
            ids{i}.label           = 'sabia2_vp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_VP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 18;
        case 'sabia2_cp'
            ids{i}.label           = 'sabia2_cp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_CP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 18;
        case 'manaca2'
            ids{i}.label           = 'manaca2';
            ids{i}.kicktable_file  = [path2kcktbls, 'IVU19/IVU19_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mib';
            ids{i}.straight_number = 20;
       case 'ipe3_hp'
            ids{i}.label           = 'ipe3_hp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU50/EPU50_HP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 7;
        case 'ipe3_vp'
            ids{i}.label           = 'ipe3_vp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU50/EPU50_VP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 7;
        case 'ipe3_cp'
            ids{i}.label           = 'ipe3_cp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU50/EPU50_CP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 7;
        case 'sabia3_hp'
            ids{i}.label           = 'sabia3_hp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_HP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 13;
        case 'sabia3_vp'
            ids{i}.label           = 'sabia3_vp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_VP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 13;
        case 'sabia3_cp'
            ids{i}.label           = 'sabia3_cp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_CP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mia';
            ids{i}.straight_number = 13;  
        case 'ipe4_hp'
            ids{i}.label           = 'ipe4_hp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU50/EPU50_HP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 15;
        case 'ipe4_vp'
            ids{i}.label           = 'ipe4_vp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU50/EPU50_VP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 15;
        case 'ipe4_cp'
            ids{i}.label           = 'ipe4_cp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU50/EPU50_CP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 15;
        case 'sabia4_hp'
            ids{i}.label           = 'sabia4_hp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_HP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 19;
        case 'sabia4_vp'
            ids{i}.label           = 'sabia4_vp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_VP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 19;
        case 'sabia4_cp'
            ids{i}.label           = 'sabia4_cp';
            ids{i}.kicktable_file  = [path2kcktbls, 'EPU80/EPU80_CP_kicktable.txt'];
            ids{i}.nr_segs         = 20;
            ids{i}.straight_label  = 'mip';
            ids{i}.straight_number = 19;
           
        otherwise
            error('ID not recognized');
    end
end