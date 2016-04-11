function nonlinearBSC_figure(data)
% analisa resultados do cálculo do bsc

%primeiro, vamos carregar os arquivos gerados pelo script de calculo
% nesse caso, temos dois calculos:
% o dos markers
the_ring = data.the_ring;
n_per    = data.n_per;
points   = data.points;
bsch_pos = data.bsch_pos;
bsch_neg = data.bsch_neg;
bscv_pos = data.bscv_pos;
bscv_neg = data.bscv_neg;


%vamos carregar as posicoes longitudinais
spos = findspos(the_ring,points);


% vamos calcular o bsc linear para comparar os resultados:
cam_vacx = getcellstruct(the_ring,'VChamber',1:length(the_ring),1);
cam_vacy = getcellstruct(the_ring,'VChamber',1:length(the_ring),2);
twiss = calctwiss(the_ring); 
hor_accep = min(cam_vacx./sqrt(twiss.betax)); 
ver_accep = min(cam_vacy./sqrt(twiss.betay));
bschl = hor_accep * sqrt(twiss.betax);
bscvl = ver_accep * sqrt(twiss.betay);

% Agora calculamos a amplitude touschek para um desvio de energia
% desejado. Para o anel scolhemos 6% por ser a aceitância de RF
delta = 0.06;
H0    = ((twiss.betax.*twiss.etaxl + twiss.alphax.*twiss.etax).^2 + ...
    twiss.etax.^2)./twiss.betax;
H_max = max(H0);
Amp   = (sqrt(H_max*twiss.betax) + twiss.etax)*delta;

bschl = max(bschl,Amp);

%% plota os resultados
fig = figure('Position',[1,1,1200,800]);

axv = axes('Parent',fig,'YGrid','on','FontSize',16, ...
           'Units','pixels','Position',[70,470,1100,330]);
box(axv,'on');
hold(axv,'on');
plot1(:,1) = plot(axv,spos,[bscv_pos;bscv_neg]*1e3,'MarkerSize',8,...
                  'MarkerFaceColor','b','Marker','o','Color','b',...
                  'LineStyle','--','LineWidth',1);
plot1(:,2) = plot(axv,twiss.pos,[bscvl,-bscvl]*1e3,'Color','r','LineWidth',2);
plot1(:,3) = plot(axv,twiss.pos,[-cam_vacy,cam_vacy]*1e3,'Color','k','LineWidth',2);
lnls_drawlattice(the_ring,n_per,0,true,1,true,axv,true);
xlabel('Position [m]');
xlim([spos(1), spos(end)]);
ylim([-1, 1]*1.1*max(cam_vacy)*1e3);
ylim([-15, 15]);
ylabel('Vertical BSC [mm]');
legend(plot1(1,:),'show',{'Nonlinear';'Linear';'Chamber'});


axh = axes('Parent',fig,'YGrid','on','FontSize',16, ...
           'Units','pixels','Position',[70,70,1100,330]);
box(axh,'on'); hold(axh,'on');
plot(axh,spos,[bsch_pos;bsch_neg]*1e3,'MarkerSize',8,...
                  'MarkerFaceColor','b','Marker','o','Color','b',...
                  'LineStyle','--','LineWidth',1);
plot(axh,twiss.pos,[bschl,-bschl]*1e3,'Color','r','LineWidth',2);
plot(axh,twiss.pos,[-cam_vacx,cam_vacx]*1e3,'Color','k','LineWidth',2);
lnls_drawlattice(the_ring,n_per,0,true,1,true,axh,true);
xlabel('Position [m]');
xlim([spos(1) spos(end)]);
ylim([-1, 1]*1.1*max(cam_vacx)*1e3);
ylim([-15, 15]);
ylabel('Horizontal BSC [mm]');