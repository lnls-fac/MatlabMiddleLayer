function lnls1_set_server(server_type, server_ip, server_port)
% Define servidor LNLS1LinkS default para conexão
%
% lnls1_set_server
% --------------------
% Script que permite ao usuário definir um servidor default para conexão
% e acesso à máquina (real ou simulada). Os parâmetros que definem o
% servidor são armazenados em uma estrutura na área de dados de aplicativos 
% do Matlab e são, portanto, diretamente invisíveis do workspace. Esta
% estrutura quando existende permite que a inicialização da comunicação
% com o servidor seja realizada pelos scripts do MML de forma automática,
% sem o input do usuário.
%
% Exemplos:
%
% 1) Simulator Mode
% >>lnls1_set_server('','','');
%
% 2) Conexão com OPR1 (a partir da rede de controle):
% >>lnls1_set_server('REMOTE', '10.128.1.2', '53131');
%
% 3) Conexão com Servidor MML-LNLS1Link (emulação) rodando no mesmo PC 
% >>lnls1_set_server('REMOTE', '127.0.0.1', '53131');
%
%
% Histórico
%
% 2012-01-25: corrigidos os comentários. (X.R.R.)
% 2011-04-27: dados de conexão são registrados em estrutura PVServer independente do MML (X.R.R.)
% 2010-09-22: versão inicial com comentários.

PVServer = getappdata(0, 'PVServer');
PVServer.server.type = server_type;
PVServer.server.ip_address   = server_ip;
PVServer.server.ip_port = server_port;
setappdata(0, 'PVServer', PVServer);