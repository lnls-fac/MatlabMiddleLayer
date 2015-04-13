function [dynapt dados] = trackcpp_load_dynap_xy(pathname, var_plane)

nr_header_lines = 13;
fname = fullfile(pathname, 'dynap_xy_out.txt');

%variável para determinar o tipo de varredura no calculo da abertura;
if ~exist('var_plane','var');
     var_plane = 'y';  % varredura em y ou varredura em x;
end

tdata = importdata(fname, ' ', nr_header_lines); tdata = tdata.data;

% Agora, eu tenho que encontrar a DA
%primeiro eu identifico quantos x e y existem
npx = length(unique(tdata(:,6)));
npy = size(tdata,1)/npx;
%agora eu pego a coluna da frequencia x
x = tdata(:,6);
y = tdata(:,7);
plane = tdata(:,4);
turn = tdata(:,2);
% e a redimensiono para que todos os valores calculados para x iguais
%fiquem na mesma coluna:
x = reshape(x,npy,npx); dados.x = x;
y = reshape(y,npy,npx); dados.y = y;
plane = reshape(plane,npy,npx); dados.plane = plane;
turn = reshape(turn,npy,npx); dados.turn = turn;
% e vejo qual o primeiro valor nulo dessa frequencia, para identificar
% a borda da DA
if strcmp(var_plane,'y')
    y  = flipud(y);
    plane = flipud(plane);
    lost = plane == 0;
    [~,ind] = min(lost,[],1);
    % para lidar com casos em que a abertura vertical é maior que o espaço
    % calculado.
    ind = ind.*any(~lost) + (~any(~lost)).*ones(1,npx)*npy; 
    % por fim, defino a DA
    x = x(1,:);
    y = unique(y(ind,:)','rows');
    dynapt = [x', y'];
else
    idx = x(1,:) > 0;
    x_ma = x(1,idx);
    lost = plane(:,idx) == 0;
    [~,ind_pos] = min(lost,[],2);
    % para lidar com casos em que a abertura horizontal é maior que o espaço
    ind_pos = ind_pos.*any(~lost,2) + (~any(~lost,2)).*ones(npy,1)*sum(idx); % calculado.
    dynapt = [x_ma(ind_pos)' y(:,1)];
    x_mi = fliplr(x(1,~idx));
    lost = fliplr(plane(:,~idx)) == 0;
    [~,ind_neg] = min(lost,[],2);
    % para lidar com casos em que a abertura horizontal é maior que o espaço
    ind_neg = ind_neg.*any(~lost,2) + (~any(~lost,2)).*ones(npy,1)*sum(~idx); % calculado.
    dynapt = [[fliplr(x_mi(ind_neg))' flipud(y(:,1))]; dynapt];
end