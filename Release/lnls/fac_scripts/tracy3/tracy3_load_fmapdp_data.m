function [dynapt, dados] = tracy3_load_fmapdp_data(pathname)

fname = fullfile(pathname, 'fmapdp.out');

[~, fmapdp] = hdrload(fname);

% Agora, eu tenho que encontrar a DA
%primeiro eu identifico quantos x e y existem
npe = length(unique(fmapdp(:,1)));
npx = size(fmapdp,1)/npe;
%agora eu pego a coluna da frequencia x
en = fmapdp(:,1);
x = fmapdp(:,2);
fen = fmapdp(:,3);
% e a redimensiono para que todos os valores calculados para x iguais
%fiquem na mesma coluna:
en = reshape(en,npx,npe); dados.en = en;
x = reshape(x,npx,npe); dados.x = x;
fen = reshape(fen,npx,npe); dados.fen = fen;
% e vejo qual o primeiro valor nulo dessa frequencia, para identificar
% a borda da DA
[~,ind] = min(fen,[],1);

% por fim, defino a DA
en = en(1,:);
x = unique(x(ind,:)','rows');

dynapt = [en', x'];



% % loads raw data
% [~, raw_data] = hdrload(fname);
% 
% % finds number of x points (nx) and y points (ny) in 'fmapdp.out'
% nx = find(raw_data(2:end,1) ~= raw_data(1,1), 1);
% ny = size(raw_data,1)/nx;
% 
% % loads data into 'dynapt' matrix
% dynapt = [];
% for j=0:(ny-1)
%     m=1;
%     controle=0;
%     while ((controle < 1) && (m<=nx))
%         if (raw_data(j*nx+m,3)==0)
%             controle=controle+1;
%         end
%         m=m+1;
%     end
%     dynapt = [dynapt; raw_data(j*nx+m-1,:)];
% end