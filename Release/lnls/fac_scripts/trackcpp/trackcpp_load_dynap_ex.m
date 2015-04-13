function [dynapt dados] = trackcpp_load_dynap_ex(pathname)

nr_header_lines = 13;
fname = fullfile(pathname, 'dynap_ex_out.txt');
tdata = importdata(fname, ' ', nr_header_lines); tdata = tdata.data;

% Agora, eu tenho que encontrar a DA
%primeiro eu identifico quantos x e y existem
npe = length(unique(tdata(:,8)));
npx = size(tdata,1)/npe;
%agora eu pego a coluna da frequencia x
en = tdata(:,8);
x = tdata(:,6);
plane = tdata(:,4);
turn = tdata(:,2);
% e a redimensiono para que todos os valores calculados para x iguais
%fiquem na mesma coluna:
en = reshape(en,npx,npe); dados.en = en;
x = reshape(x,npx,npe); dados.x = x;
plane = reshape(plane,npx,npe); dados.plane = plane;
turn = reshape(turn,npx,npe); dados.turn = turn;
% e vejo qual o primeiro valor nulo dessa frequencia, para identificar
% a borda da DA
[~,ind] = min(plane == 0,[],1);

% por fim, defino a DA
en = en(1,:);
x = unique(x(ind,:)','rows');

dynapt = [en', x'];