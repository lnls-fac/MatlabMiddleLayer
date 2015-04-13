% Script de finalização
%
% Histórico
% 
% 2010-09-16: comentários iniciais no código

% disconnect from LNLS PVServer
try
    lnls1_comm_disconnect;
catch
end