% analisa resultados do cálculo do bsc

%primeiro, vamos carregar os arquivos gerados pelo script de calculo
% nesse caso, temos dois calculos:
% o dos markers
data = load('06-Dec-2013marker_quad.mat');
the_ring = data.the_ring;
points = data.points;
bsch_pos = data.bsch_pos;
bsch_neg = data.bsch_neg;
bscv_pos = data.bscv_pos;
bscv_neg = data.bscv_neg;


%vamos carregar as posicoes longitudinais
spos = findspos(the_ring,points);


% vamos calcular o bsc linear para comparar os resultados:
vac_cham = 12e-3;
TD  = twissring(the_ring,0,1:points(end));
spos_twi = cat(1,TD.SPos)';
beta     = cat(1, TD.beta);
betax = beta(:,1)';
betay = beta(:,2)';
bschl = vac_cham * sqrt(betax/max(betax));
bscvl = vac_cham * sqrt(betay/max(betay));


% também, vamos calcular o não linear, escalado linearmente
[betamax ind] = max(betax(points));
bschnl_pos    = bsch_pos(ind)*sqrt(betax/betamax);
bschnl_neg    = bsch_neg(ind)*sqrt(betax/betamax);
[betamay ind] = max(betay(points));
bscvnl_pos    = bscv_pos(ind)*sqrt(betay/betamay);
bscvnl_neg    = bscv_neg(ind)*sqrt(betay/betamay);

%plota os resultados
fig = figure('OuterPosition',get(0,'screenSize'));

axes_bscv = subplot(2,1,1,'Parent',fig,'YGrid','on','FontSize',16);
box(axes_bscv,'on');
hold on
plot1(:,1) = plot(spos,[bscv_pos;bscv_neg]*1e3,'MarkerSize',10,'Marker','.','Color','b');
plot1(:,2) = plot(spos_twi,[bscvnl_pos;bscvnl_neg]*1e3,'Color','g');
plot1(:,3) = plot(spos_twi,[bscvl;-bscvl]*1e3,'Color','r');
drawlattice(0,1,axes_bscv,spos(end));
xlabel('Position [m]');
xlim([spos(1) spos(end)]);
ylabel('Vertical Beam Stay Clear [mm]');
legend1 = legend(plot1(1,:),'show',{'non-linear';'misto';'linear'});


axes_bsch = subplot(2,1,2,'Parent',fig,'YGrid','on','FontSize',16);
box(axes_bsch,'on');
hold on
plot(spos,[bsch_pos;bsch_neg]*1e3,'MarkerSize',10,'Marker','.','Color','b');
plot(spos_twi,[bschnl_pos;bschnl_neg]*1e3,'Color','g');
plot(spos_twi,[bschl;-bschl]*1e3,'Color','r');
drawlattice(0,1,axes_bsch,spos(end));
xlabel('Position [m]');
xlim([spos(1) spos(end)]);
ylabel('Horizontal Beam Stay Clear [mm]');
