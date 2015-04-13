% lnls1_booster: carrega estrutura MML do booster do LNLS1

dr = pwd;

mml_root = fullfile(lnls_get_root_folder(), 'code', 'MatlabMiddleLayer', 'Release');

% desconecta com servidor se conexao existir
addpath(fullfile(mml_root, 'mml'));
cd(fullfile(mml_root, 'links', 'lnls_link','lnls1_link'));
lnls1_comm_disconnect;
rmpath(fullfile(mml_root, 'mml'));

% carrega paths do LNLS1
cd(fullfile(mml_root, 'mml'))
setpathlnls('LNLS1', 'Booster', 'lnls1_link');

% volta ao working dir inicial
cd(dr);
clear dr;
