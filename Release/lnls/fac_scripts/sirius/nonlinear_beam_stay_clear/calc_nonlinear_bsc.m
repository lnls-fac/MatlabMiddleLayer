function calc_nonlinear_bsc(the_ring, n_per)
% calc_nonlinear_bsc(the_ring, nper)
%
% calcula o beam stay clear nao linear para o primeiro superperiodo da rede
% the_ring, que possui n_per periodos. cam_vac eh o valor do raio da camara
% ao long do anel. O calculo deve ser rodado da pasta onde queira-se que os
% dados sejam salvos.



% vamos escolher um nome para o arquivo que sera salvo
name = 'marker_quad';

%agora, vamos selecionar os pontos em que sera calculada a AD
% quero calcular para todos os markers e quadrupolos do 1o super periodo:
spos = findspos(the_ring,1:(length(the_ring)+1));
super_per = spos <= ((spos(end)+0.01)/n_per);
points = findcells(the_ring(super_per),'PassMethod','IdentityPass');
points = points(2:end); % nao quero o marker 'inicio'

points2 = findcells(the_ring(super_per),'K');
points3 = findcells(the_ring(super_per),'BendingAngle');
points2 = setdiff(points2,points3);
points = sort([points, points2]);

%Define sposition of the calculated points
spos = spos(points);

%agora, tenho que preparar os arquivos para o calculo
%primeiro vamos definir as condicoes iniciais de varredura:
np = 121;

% e quantas voltas eu quero dar
nturns = 500;

cam_vac = getcellstruct(the_ring,'VChamber',1:length(the_ring));
cam_vac = cell2mat(cam_vac)';
cam_vac = cam_vac([1,2],:);
cam_vacx = cam_vac(1,:);
cam_vacy = cam_vac(2,:);
% preciso desnormalizar pelo gammax, para que no ponto de beta maximo a
% varredura va ate 12mm.
twissdata = twissring(the_ring,0,1:length(the_ring)); 
spos_twi = cat(1,twissdata.SPos)';
beta   = cat(1,twissdata.beta);  
alpha  = cat(1,twissdata.alpha);
betax  = beta(:,1)';                 
betay  = beta(:,2)'; 
alphax = alpha(:,1)';                
alphay = alpha(:,2)';
gammax = (1+alphax.^2)./betax;      
gammay = (1+alphay.^2)./betay;
[hor_accep, ~] = min(cam_vacx./sqrt(betax)); 
[ver_accep, ~] = min(cam_vacy./sqrt(betay));
x0 = 1.2*linspace(-1,1,np)*hor_accep;
y0 = 1.2*linspace(-1,1,np)*ver_accep;

%nao quero que as particulas andem exatamente na linha y=0 e x=0 para
%as varreduras em x e y, respectivamente, entao vou gerar uma
%distribuicao gaussiana sigma 0.1mm com corte em um sigma:
x0_rand = get_random_numbers(1e-2, np, 1)'*hor_accep;
y0_rand = get_random_numbers(1e-2, np, 1)'*ver_accep;

bsch_pos = zeros(1,length(points));
bsch_neg = zeros(1,length(points));
bscv_pos = zeros(1,length(points));
bscv_neg = zeros(1,length(points));
fprintf('Eu acho que pra terminar, como ja foram\n');
for ii=1:length(points)
    %estimativa de tempo de calculo
    fprintf('%2d calculos de %2d, ainda faltam %5.2f minutos\n',ii-1,...
        length(points),15/100*nturns/60*(length(points)-ii+1));
    
    % primeiro vamos shiftar a rede para comecar no ponto de calculo
    ind1 = [points(ii):(length(the_ring)-1) 2:(points(ii)-1)];
    the_ring_calc = the_ring([1,ind1,end]);
    
    %agora, vamos reescalar a varredura, para ter a mesma precisao:
    x0_rees = x0/sqrt(gammax(points(ii)));
    y0_rees = y0/sqrt(gammay(points(ii)));
    x_rand = x0_rand/sqrt(gammax(points(ii)));
    y_rand = y0_rand/sqrt(gammay(points(ii)));
    
    % agora eu monto as condicoes iniciais
    Rin = [[x0_rees; zeros(1,np);y_rand;zeros(3,np)] [x_rand; zeros(1,np);y0_rees;zeros(3,np)]];
    
    %primeiro eu faco um tracking detalhado para ver se as particulas estao
    %furando a camara de vacuo
    Rout=Rin;
    len_ring = length(the_ring_calc);
    nt_det =60; %tempo para elas darem mais de 3 voltas no espaco de fase
    np_left = 2*np;
    if 3*nt_det >= nturns
        error('Coloque mais voltas em nturns que 3*nt_det');
    end
    for i =1:nt_det
        %track
        Rout = linepass(the_ring_calc,Rout,1:len_ring);
        % look to x and y along all ring if it hit the vac_cham
        cam = [reshape(repmat(cam_vacx([1,ind1,end]),np_left,1),1,[]);...
               reshape(repmat(cam_vacy([1,ind1,end]),np_left,1),1,[])];
        ind = (abs(Rout([1 3],:)) >= cam);
        %if x or y hit
        ind = any(ind);
        % at any point of the ring
        ind = any(reshape(ind,[],len_ring)');
        % or if the particle is lost by other means
        Rout = Rout(:,(end-length(ind)+1):end);
        ind = ind | isnan(Rout(1,:));
        %I exclude it from the next tracking
        Rout = Rout(:,~ind);
        np_left = size(Rout,2);
    end
    %faz o tracking de varias voltas no anel
    Rout = ringpass(the_ring_calc,Rout,nturns-nt_det);
    
    %agora eu vejo se ele passou a camara de vacuo naquele ponto
    ind = (abs(Rout([1 3],:)) >= repmat(cam_vac(:,points(ii)),1,(nturns-nt_det)*np_left));
    ind = any(ind); %se passou em x ou y
    ind = reshape(ind,np_left,nturns-nt_det)'; %em alguma das voltas
    ind = any(ind);
    Rout = Rout(:,repmat(~ind,1,nturns-nt_det)); %excluo do vetor saida
    
    %calculo o beam stay clear:
    bsch_pos(ii) = max(Rout(1,:));
    bsch_neg(ii) = min(Rout(1,:));
    bscv_pos(ii) = max(Rout(3,:));
    bscv_neg(ii) = min(Rout(3,:));  
end

% vamos salvar os dados do BSC nao linear:
save(sprintf('%s',[date name]),'the_ring','points','bsch_pos','bsch_neg','bscv_pos','bscv_neg');


%por fim, vamos gerar um arquivo com o bsc nao linear
fp = fopen('nonlinear_bsc.txt','w');
fprintf(fp,'Beam Stay Clear nao-linear para a rede Sirius_v500-ac10_6\n\n');
fprintf(fp,'Pontos para os quais foi calculado: centro trechos retos, centro dipolos, BPMs, comeco quadrupolos\n\n');
fprintf(fp,'%10s   %11s   %11s   %11s   %11s\n','Position [m]','BSC_Hp [mm]','BSC_Hn [mm]','BSC_Vp [mm]','BSC_Vn [mm]');
fprintf(fp,'%10.5g   %11.5g   %11.5g   %11.5g   %11.5g\n',[spos;[bsch_pos;bsch_neg;bscv_pos;bscv_neg]*1e3]);
fclose(fp);


% vamos calcular o bsc linear para comparar os resultados:
bschl = hor_accep * sqrt(betax);
bscvl = ver_accep * sqrt(betay);

%plota os resultados
fig = figure('Position',[1,1,700,434]);

 axes_bscv = subplot(2,1,1,'Parent',fig,'YGrid','on','FontSize',16);
box(axes_bscv,'on');
hold on
plot1(:,1) = plot(spos,[bscv_pos;bscv_neg]*1e3,'MarkerSize',10,'Marker','.','Color','b','LineWidth',2);
plot1(:,2) = plot(spos_twi,[bscvl;-bscvl]*1e3,'Color','r','LineWidth',1);
plot1(:,3) = plot(spos_twi,[-cam_vacy;cam_vacy]*1e3,'Color','k','LineWidth',2);
lnls_drawlattice(the_ring,n_per,0,true,1,true,axes_bscv);
xlabel('Position [m]');
xlim([spos(1) spos(end)]);
ylabel('Vertical Beam Stay Clear [mm]');
legend(plot1(1,:),'show',{'non-linear';'linear';'vaccum_chamber'});


axes_bsch = subplot(2,1,2,'Parent',fig,'YGrid','on','FontSize',16);
box(axes_bsch,'on');
hold on
plot(spos,[bsch_pos;bsch_neg]*1e3,'MarkerSize',10,'Marker','.','Color','b','LineWidth',1);
plot(spos_twi,[bschl;-bschl]*1e3,'Color','r','LineWidth',1);
plot(spos_twi,[-cam_vacx;cam_vacx]*1e3,'Color','k','LineWidth',2);
lnls_drawlattice(the_ring,n_per,0,true,1,true,axes_bsch);
xlabel('Position [m]');
xlim([spos(1) spos(end)]);
ylabel('Horizontal Beam Stay Clear [mm]');



function rndnr = get_random_numbers(sigma, nrels, cutoff)

%distribuicao uniforme truncada em sqrt(3) sigma:
% rndnr = sqrt(3)*sigma * 2 * (rand(1, nrels) - 0.5);


max_value = cutoff;

rndnr = zeros(nrels,1);
sel = 1:nrels;
while ~isempty(sel)
    rndnr(sel) = randn(1,length(sel));
    sel = find(abs(rndnr) > max_value);
end
rndnr = sigma * rndnr;

