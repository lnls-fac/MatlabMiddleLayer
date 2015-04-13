function calc_ID_dtune_ALL


ebeam_def.energy = 3; % [GeV]

id_mat_file_name = fullfile('SCW3T', 'SCW3T - KICKTABLES.mat'); 
ebeam_def.betax = 3.91; % AC10_2 - MIB
ebeam_def.betay = 0.71; % AC10_2 - MIB 
calc_ID_dtune(id_mat_file_name, ebeam_def);

id_mat_file_name = fullfile('W2T', 'W2T - KICKTABLES.mat'); 
ebeam_def.betax = 3.91; % AC10_2 - MIB
ebeam_def.betay = 0.71; % AC10_2 - MIB 
calc_ID_dtune(id_mat_file_name, ebeam_def);

id_mat_file_name = fullfile('U18', 'U18 - KICKTABLES.mat'); 
ebeam_def.betax = 17.0; % AC10_2 - MIA
ebeam_def.betay = 3.40; % AC10_2 - MIA  
%ebeam_def.betax = 3.91; % AC10_2 - MIB
%ebeam_def.betay = 0.71; % AC10_2 - MIB 
calc_ID_dtune(id_mat_file_name, ebeam_def);

id_mat_file_name = fullfile('EPU50', 'EPU50_PH - KICKTABLES.mat'); 
ebeam_def.betax = 17.0; % AC10_2 - MIA
ebeam_def.betay = 3.40; % AC10_2 - MIA 
calc_ID_dtune(id_mat_file_name, ebeam_def);

id_mat_file_name = fullfile('EPU50', 'EPU50_PC - KICKTABLES.mat'); 
ebeam_def.betax = 16.5; % AC10_2 - MIA
ebeam_def.betay = 3.9;  % AC10_2 - MIA
calc_ID_dtune(id_mat_file_name, ebeam_def);

id_mat_file_name = fullfile('EPU50', 'EPU50_PV - KICKTABLES.mat'); 
ebeam_def.betax = 16.5; % AC10_2 - MIA
ebeam_def.betay = 3.9;  % AC10_2 - MIA
calc_ID_dtune(id_mat_file_name, ebeam_def);

id_mat_file_name = fullfile('EPU200', 'EPU200_PH - KICKTABLES.mat'); 
ebeam_def.betax = 16.5; % AC10_2 - MIA
ebeam_def.betay = 3.9;  % AC10_2 - MIA
calc_ID_dtune(id_mat_file_name, ebeam_def);

id_mat_file_name = fullfile('EPU200', 'EPU200_PC - KICKTABLES.mat'); 
ebeam_def.betax = 16.5; % AC10_2 - MIA
ebeam_def.betay = 3.9;  % AC10_2 - MIA
calc_ID_dtune(id_mat_file_name, ebeam_def);

id_mat_file_name = fullfile('EPU200', 'EPU200_PV - KICKTABLES.mat'); 
ebeam_def.betax = 16.5; % AC10_2 - MIA
ebeam_def.betay = 3.9;  % AC10_2 - MIA
calc_ID_dtune(id_mat_file_name, ebeam_def);
