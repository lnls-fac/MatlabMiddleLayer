function ids = ids_select(ids_names)
%ids = select_ids(ids_names)
% Select ids to be insert in the lattice;
% INPUT : id_names  - cellarray of strings defining the names of the IDS
% OUTPUT: ids       - array of structs with the ids properties

ids = repmat(struct(),1,length(ids_names));
for i =1:length(ids_names)
    switch ids_names{i}
        case 'carnauba'
            % trechos impares - Betas Baixos
            % --- phase 1 ---
            ids(i).label           = 'carnauba';
            ids(i).kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
            ids(i).nr_segs         = 20;
            ids(i).straight_label  = 'mib';
            ids(i).straight_number = 3;
            ids(i).strength        = 1;
        case 'ema'
            ids(i).label           = 'ema';
            ids(i).kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
            ids(i).nr_segs         = 20;
            ids(i).straight_label  = 'mib';
            ids(i).straight_number = 4;
            ids(i).strength        = 1;
        case 'caterete'
            ids(i).label           = 'caterete';
            ids(i).kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
            ids(i).nr_segs         = 20;
            ids(i).straight_label  = 'mib';
            ids(i).straight_number = 5;
            ids(i).strength        = 1;
        case 'manaca'
            ids(i).label           = 'manaca';
            ids(i).kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
            ids(i).nr_segs         = 20;
            ids(i).straight_label  = 'mib';
            ids(i).straight_number = 6;
            ids(i).strength        = 1;
        case 'caterete2'
            % --- phase 2 ---
            ids(i).label           = 'caterete2';
            ids(i).kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
            ids(i).nr_segs         = 20;
            ids(i).straight_label  = 'mib';
            ids(i).straight_number = 1;
            ids(i).strength        = 1;
        case 'ema2'
            ids(i).label           = 'ema2';
            ids(i).kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
            ids(i).nr_segs         = 20;
            ids(i).straight_label  = 'mib';
            ids(i).straight_number = 2;
            ids(i).strength        = 1;
        case 'manaca2'
            ids(i).label           = 'manaca2';
            ids(i).kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
            ids(i).nr_segs         = 20;
            ids(i).straight_label  = 'mib';
            ids(i).straight_number = 7;
            ids(i).strength        = 1;
        case 'carnauba2'
            ids(i).label           = 'carnauba2';
            ids(i).kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
            ids(i).nr_segs         = 20;
            ids(i).straight_label  = 'mib';
            ids(i).straight_number = 8;
            ids(i).strength        = 1;
            % trechos impares - Betas Altos
        case 'jatoba'
            % --- phase 1 ---
            ids(i).label           = 'jatoba';
            ids(i).kicktable_file  = '../id_modelling/SCW4T/SCW4T_kicktable.txt';
            ids(i).nr_segs         = 20;
            ids(i).straight_label  = 'mia';
            ids(i).straight_number = 4;
            ids(i).strength        = 1;
        case 'inga'
            ids(i).label           = 'inga';
            ids(i).kicktable_file  = '../id_modelling/U25/U25_kicktable_4meters.txt';
            ids(i).nr_segs         = 40;
            ids(i).straight_label  = 'mia';
            ids(i).straight_number = 5;
            ids(i).strength        = 2; % two IDs in series
        case 'ipe'
            ids(i).label           = 'ipe';
            ids(i).kicktable_file  = '../id_modelling/EPU80/EPU80_PH_kicktable_5p4meters.txt';
            ids(i).nr_segs         = 40;
            ids(i).straight_label  = 'mia';
            ids(i).straight_number = 6;
            ids(i).strength        = 2; % two IDs in series
        case 'sabia'
            ids(i).label           = 'sabia';
            ids(i).kicktable_file  = '../id_modelling/EPU80/EPU80_PH_kicktable_5p4meters.txt';
            ids(i).nr_segs         = 40;
            ids(i).straight_label  = 'mia';
            ids(i).straight_number = 7;
            ids(i).strength        = 2; % two IDs in series
%         case 'sabia'
%             ids(i).label           = 'sabia';
%             ids(i).kicktable_file  = '../id_modelling/EPU80/EPU80_PH_kicktable_6p5meters.txt';
%             ids(i).nr_segs         = 40;
%             ids(i).straight_label  = 'mia';
%             ids(i).straight_number = 7;
%             ids(i).strength        = 2 * (6.5/5.4); % two IDs in series
        case 'inga2'
            % --- phase 2 ---
            ids(i).label           = 'inga2';
            ids(i).kicktable_file  = '../id_modelling/U25/U25_kicktable_4meters.txt';
            ids(i).nr_segs         = 40;
            ids(i).straight_label  = 'mia';
            ids(i).straight_number = 3;
            ids(i).strength        = 2; % two IDs in series
        case 'sabia2'
            ids(i).label           = 'sabia2';
            ids(i).kicktable_file  = '../id_modelling/EPU80/EPU80_PH_kicktable_5p4meters.txt';
            ids(i).nr_segs         = 40;
            ids(i).straight_label  = 'mia';
            ids(i).straight_number = 8;
            ids(i).strength        = 2; % two IDs in series
%         case 'sabia2'
%             ids(i).label           = 'sabia2';
%             ids(i).kicktable_file  = '../id_modelling/EPU80/EPU80_PH_kicktable_6p5meters.txt';
%             ids(i).nr_segs         = 40;
%             ids(i).straight_label  = 'mia';
%             ids(i).straight_number = 8;
%             ids(i).strength        = 2 * (6.5/5.4); % two IDs in series
        case 'ipe2'
            ids(i).label           = 'ipe2';
            ids(i).kicktable_file  = '../id_modelling/EPU80/EPU80_PH_kicktable_5p4meters.txt';
            ids(i).nr_segs         = 40;
            ids(i).straight_label  = 'mia';
            ids(i).straight_number = 9;
            ids(i).strength        = 2; % two IDs in series
        case 'dhscu20'
            % -- tests --
            ids(i).label           = 'dhscu20';
            ids(i).kicktable_file  = '../id_modelling/DHSCU20/DHSCU20_PL.txt';
            ids(i).nr_segs         = 20;
            ids(i).straight_label  = 'mib';
            ids(i).straight_number = 10;
            ids(i).strength        = 1;
%         case 'sabia2'
%             ids(i).label           = 'sabia2';
%             ids(i).kicktable_file  = '../id_modelling/EPU80/EPU80_PV_kicktable_5p4meters.txt';
%             ids(i).nr_segs         = 40;
%             ids(i).straight_label  = 'mia';
%             ids(i).straight_number = 8;
%             ids(i).strength        = 2; % two IDs in series
        otherwise
            error('ID not recognized');
    end
end