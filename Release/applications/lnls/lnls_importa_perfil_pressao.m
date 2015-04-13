%   [s_P,P] = LNLS_IMPORTA_PERFIL_PRESSAO(arquivo) importa o perfil de pressão
%   do arquivo de texto.
%
%   ENTRADA
%       arquivo     arquivo com o perfil de pressão a importar, com
%                   posições [m] na primeira coluna e pressão [mbar] na
%                   segunda coluna
%   SAÍDA
%       s_P         posição [m]
%       P           pressão [mbar]

function [s_P,P] = lnls_importa_perfil_pressao(arquivo)

perfil_pressao = importdata(arquivo);

% Obtém dados de posição e pressão em um trecho do anel.
s_P = perfil_pressao(:,1); % Posição [m]
P   = perfil_pressao(:,2); % Pressão [mbar]

end