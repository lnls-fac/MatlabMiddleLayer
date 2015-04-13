%   [s_V,Vx,Vy] = LNLS_IMPORTA_PERFIL_CAMARA(arquivo) importa o perfil de
%   câmara de vácuo do arquivo de texto.
%
%   ENTRADA
%       arquivo     arquivo .txt para importar, com posições [m] na
%                   primeira coluna e meia abertura horizontal e vertical
%                   [mm] na segunda e terceira colunas, respectivamente
%   SAÍDA
%       s_V         posição [m]
%       Vx          meia abertura horizontal da câmara de vácuo [mm]
%       Vy          meia abertura vertical da câmara de vácuo [mm]

function [s_V,Vx,Vy] = lnls_importa_perfil_camara(arquivo)

perfil_camara = importdata(arquivo);

% Obtém dados de posição e meia abertura em um trecho do anel.
s_V = perfil_camara(:,1); % Posição [m]
Vx  = perfil_camara(:,2); % Meia abertura horizontal [mm]
Vy  = perfil_camara(:,3); % Meia abertura vertical [mm]

end