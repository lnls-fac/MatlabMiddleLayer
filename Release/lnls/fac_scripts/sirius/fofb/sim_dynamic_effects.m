clear all;

% primeiro, vamos carregar o modelo do anel de armazenamento:
the_ring = sirius_si_lattice;
[~, ~, ~, ~, ~, ~, the_ring] = setradiation('on',the_ring);
[~, the_ring] = setcavity('on',the_ring);
orb0 = findorbit6(the_ring);

%Botao para escolher a cromaticidade do anel(soh eh necessario para
%pacotes com mais de uma particula):
chromx = 0.0; % max ~ 8;
chromy = 0.0; % max ~ 4;
the_ring = fitchrom2(the_ring, [chromx,chromy],'sd1', 'sf1');


% agora, vamos descobrir as posicoes das corretoras horizontais;
ch_ind = findcells(the_ring,'FamName','hcm');
ch_ind = ch_ind([1,5]);

% vamos escolher o numero de voltas que queremos dar;
nvolta = 100;  % aprox. 12ms


% E agora definimos o kick em funcao do tempo:
nt_ramp = 5;
nt_zero = 10;
kick = 1e-7*[zeros(1,nt_zero), (1:nt_ramp)/nt_ramp, ones(1,nvolta-nt_zero-nt_ramp)];


% E agora, vamos ver qual eh a resposta dinamica do feixe:
% para isso, temos que gerar um pacote de eletrons que estava em equilibrio
% antes do kick ser ligado:
% para gerar esse pacote, precisamos das funcoes oticas do ponto inicial de
% onde vamos solta-lo:
ini_ind = findcells(the_ring,'FamName','inicio');
twi = calctwiss(the_ring);
twiss(1) = twi.betax(ini_ind);   twiss(3) = twi.betay(ini_ind);
twiss(2) = twi.alphax(ini_ind);  twiss(4) = twi.alphay(ini_ind);
twiss(5) = twi.etax(ini_ind);    twiss(7) = twi.etay(ini_ind);
twiss(6) = twi.etaxl(ini_ind);   twiss(8) = twi.etayl(ini_ind);

% tambem precisamos dos parametros de equilibrio do anel:
% na verdade, nao 'precisamos' com P maiusculo, o importante mesmo eh que o
% feixe tenha o formato correto, que eh determinado pelas funcoes oticas. O
% tamanho dele poderia ser qualquer um proximo do real:
emitx  = 2.8e-10;
emity  = 2.8e-12;
sigmae = 8.3e-4;
sigmas = 3e-3;
% Uma boa maneira de testar se o numero de particulas eh suficiente eh
% colocando um kick nulo, rodar o script e ver qual a oscilacao residual do
% pacote. Sabemos que ela deveria ser nula para um pacote ideal, mas devido
% ao numero finito de particulas simuladas ele nao sera. Se essa oscilacao
% residual for desprezivel em comparacao com a orbita fechada gerada pelo
% kick, entao o numero de particulas eh suficiente. Caso contrario eh
% melhor aumetar esse numero.
n_part = 1;  % numero de particulas
cutoff = 3;    % numero de sigmas para cortar a distribuicao


% vamos colocar alguma ordem na aleatoriedade dos numeros gerados:
RandStream.setGlobalStream(RandStream('mt19937ar','seed', 131071));

% e geramos o pacote:
% esse pacote eh uma matriz com a seguinte interpretacao:
%  x1    x2   x3  ... xn   posicao horizontal
% xl1   xl2  xl3 ... xln   angulo horizontal
%  y1    y2   y3  ... yn   posicao vertical
% yl1   yl2  yl3 ... yln   angulo vertical
%  e1    e2   e3  ... en   desvio de energia
%  s1    s2   s3  ... sn   posicao longitudinal
if n_part ~=1
    Rin = lnls_generate_bunch(emitx,emity,sigmae,sigmas,twiss,n_part,cutoff);
else
    Rin = [0;0;0;0;0;0];
end
Rin = bsxfun(@plus,Rin,orb0);

% agora vamos fazer o tracking desse pacote pelo anel perturbado com a
% corretora por algumas voltas e ver a evolucao do centroide e do segundo
% momento do feixe:
len = length(the_ring)+1;
x_ave = zeros(nvolta,len);
x_std = zeros(nvolta,len);
for ii=1:nvolta
    the_ring{ch_ind(1)}.KickAngle(1) = kick(ii);
    the_ring{ch_ind(2)}.KickAngle(1) = -kick(ii)/5;
    %                anel          pac. inicial    pos. do anel em que quero output
    Rout = linepass(the_ring    ,    Rin         ,             1:len);
    % Rout tem o seguinte formato: [ pac. na pos 1, pac na pos 2, ..., pac. na pos n]
    
    % agora, vamos selecionar a posicao x das particulas:
    x = reshape(Rout(1,:),n_part,len);
    % e calcular a media e o standard deviation
    x_ave(ii,:) = mean(x,1);
%     x_std(ii,:) = std(x,0,1);
    
    % vamos definir o pacote para o input da proxima volta:
    Rin = Rout(:,(end-n_part+1):end);
    
    if mod(ii,100)==0, fprintf('Ja foi:   %3d\n',ii); end;
end


% Por fim, vamos ver qual eh a orbita fechada que esse kick gera:
orb = findorbit6(the_ring,1:length(the_ring)+1);

% Pronto! agora vamos fazer alguns graficos:
%%

scrsz = get(0,'ScreenSize');
figure1 = figure('OuterPosition', scrsz);

% Vamos selecionar os pontos de radiacao:
mia = findcells(the_ring,'FamName','mia');
mib = findcells(the_ring,'FamName','mib');
mc  = findcells(the_ring,'FamName','mc');
voltas = 1:nvolta;


axes11 = subplot(2,2,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
box(axes11,'on');
hold(axes11,'all');
plot(voltas,orb(1,mia)'*ones(1,nvolta)*1e6,'LineWidth',3,'Parent',axes11, 'Color','k');
plot(voltas,x_ave(:,mia)'*1e6,'LineStyle','--','Parent',axes11);
xlabel('Numero da volta [#]','Parent',axes11); ylabel('x [\mu m]','Parent',axes11);
title('Centroid motion @ mia','Parent',axes11);


axes12 = subplot(2,2,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
box(axes12,'on');
hold(axes12,'all');
plot(voltas,orb(1,mib)'*ones(1,nvolta)*1e6,'LineWidth',3,'Parent',axes12, 'Color','k');
plot(voltas,x_ave(:,mib)'*1e6,'LineStyle','--','Parent',axes12);
xlabel('Numero da volta [#]','Parent',axes12); ylabel('x [\mu m]','Parent',axes12);
title('Centroid motion @ mib','Parent',axes12);

axes21 = subplot(2,2,3,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
box(axes21,'on');
hold(axes21,'all');
plot(voltas,orb(1,mc)'*ones(1,nvolta)*1e6,'LineWidth',2,'Parent',axes21, 'Color','k');
plot(voltas,x_ave(:,mc)'*1e6,'LineStyle','--','Parent',axes21);
xlabel('Numero da volta [#]','Parent',axes21); ylabel('x [\mu m]','Parent',axes21);
title('Centroid motion @ mc','Parent',axes21);


axes22 = subplot(2,2,4,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
box(axes22,'on');
hold(axes22,'all');
plot(voltas,orb(1,ch_ind)'*ones(1,nvolta)*1e6,'LineWidth',3,'Parent',axes22, 'Color','k');
plot(voltas,x_ave(:,ch_ind)'*1e6,'LineStyle','--','Parent',axes22);
xlabel('Numero da volta [#]','Parent',axes22); ylabel('x [\mu m]','Parent',axes22);
title('Centroid motion @ the corrector','Parent',axes22);
