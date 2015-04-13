%   [s_P,P,s_P_dipolo,nome_pos_dipolo,nome_fim_trecho] =
%   IMPORTA_PERFIL_PRESSAO(arquivo) importa o perfil de pressão do arquivo
%   de texto. Na primeira linha, dipolo= indica a posição do dipolo no
%   perfil de pressão em m (não deve haver espaço antes do número; se for
%   vazio, o resultado é NaN. Após a terceira linha, a primeira coluna do
%   arquivo deve conter as posições (s_P) em m; a segunda, os valores de
%   pressão correspondentes (P) em mbar. Strings com o FamName do elemento
%   que determina a posição do dipolo e o fim do trecho são carregadas em
%   nome_pos_dipolo e nome_fim_trecho.

function [s_P,P,s_P_dipolo,nome_pos_dipolo,nome_fim_trecho] = importa_perfil_pressao(arquivo)

perfil_pressao = importdata(arquivo);

% Obtém dados de posição (m) e pressão (mbar) em um trecho do anel.
s_P = perfil_pressao.data(:,1);   % Posição
P = perfil_pressao.data(:,2);     % Pressão

dipolo_str = perfil_pressao.textdata{1};
s_P_dipolo = str2double(dipolo_str(8:length(dipolo_str)));

pos_str = perfil_pressao.textdata{2};
nome_pos_dipolo = pos_str(8:length(pos_str));

fim_str = perfil_pressao.textdata{3};
nome_fim_trecho = fim_str(8:length(fim_str));

end