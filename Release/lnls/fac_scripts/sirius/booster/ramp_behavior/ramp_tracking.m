function ramp_tracking()

global THERING;
THERING = sirius_bo_lattice;
setradiation('on'); setcavity('on');

the_ring = THERING;

circ = findspos(the_ring, length(the_ring)+1);
T0 = circ/299792458;

%% Define ramp
nturns = 1;
Tint  = nturns*T0;

freq = 2;
dt = 0.0:Tint:(0.5/freq);
E0 =   150e6;
Einf = 3e9;
Et    =  gamat2(Einf, E0, freq, dt(1:end));
% These three lines add a constant energy period of 50ms in the end of the
% ramp:

% dtadd = (dt(end)+Tint):Tint:(dt(end) + 50e-3);
% dt = [dt dtadd];
% Et = [Et Einf*ones(size(dtadd))];


%rampa linear:
% tf = sum(dt<0.2);
% Vi = 200e3;
% Vf = 1000e3;
% Vramp  = Vi+(Vf-Vi)/dt(tf)*dt(1:tf); 
% V =  [Vramp, Vf*ones(1,length(dt)-tf)];
%rampa com over-voltage constante:
rho0 = 1.152*50/2/pi;
gamat = Et/511e3;
q = 1.5;
Vf = 1e6;
Vi = 0.2e6;
U0 = 88.5*(0.511e-3*gamat).^4/rho0*1e3;
V = q*U0 + Vi;
ind = V >Vf;
V(ind) = Vf;

cavi = findcells(the_ring,'FamName','cav');

%% Generate file with ramp for elegant simulations
fileName = 'ramp.dat';
fp = fopen(fileName,'w+', 'n','US-ASCII');
dados = [dt; Et/511e3];
fprintf(fp,'%#10.6e %#10.6e\n',dados);
fclose(fp);
return
%% Define particle distribution;
twi = calctwiss(the_ring);
betx = twi.betax(1);
bety = twi.betay(1);
etx  = twi.etax(1);

n_part = 10;
cutoff = 2;
emitx = 50e-6/E0*511e3;
emity = emitx;
sigmae= 5e-3;
sigmat= 1e-10 * 299792458;

RandStream.setDefaultStream(RandStream('mt19937ar','seed', 131071));

the_ring = setcellstruct(the_ring,'Energy',1:length(the_ring),Et(1));
the_ring = setcellstruct(the_ring, 'Voltage', cavi, V(1));
cod = findorbit6(the_ring);
sigmaep = get_random_numbers(sigmae, n_part, cutoff)';
sigmatp = get_random_numbers(sigmat, n_part, cutoff)';
x  = cod(1) + get_random_numbers(sqrt(betx*emitx), n_part, cutoff)' + etx*sigmaep;
xp = cod(2) + get_random_numbers(sqrt(emitx/betx), n_part, cutoff)';
y  = cod(3) + get_random_numbers(sqrt(bety*emity), n_part, cutoff)';
yp = cod(4) + get_random_numbers(sqrt(emity/bety), n_part, cutoff)';

Rin = [x;xp;y;yp;sigmaep+cod(5);sigmatp+cod(6)];
%% Track and show results


fprintf('energy  : %f\n', Et(1)/1e9);
Rout = ringpass(the_ring,Rin,nturns);
mat = reshape(Rout,6,n_part,nturns);
Rin = mat(:,:,end);
media = squeeze(mean(mat,2));
stand = squeeze(std(mat,0,2));
temp  = T0:T0:(nturns*T0);

f = figure;

for in = 1:6;
    px(in) = subplot(3,2,in,'Parent',f, 'FontSize',14);
    plot(px(in), gamat2(Einf, E0, freq, temp)/1e9, [media(in,:); stand(in,:)]);
    hold(px(in),'on');
end
media = [];
stand = [];
temp  = [];


for ii = 2:length(dt)
    the_ring = setcellstruct(the_ring,'Energy',1:length(the_ring),Et(ii));
    the_ring = setcellstruct(the_ring, 'Voltage', cavi, V(ii));
    Rin(2,:) = Rin(2,:)*Et(ii-1)/Et(ii);
    Rin(4,:) = Rin(4,:)*Et(ii-1)/Et(ii);
    new_delta = ((Rin(5,:)+1)*Et(ii-1)-Et(ii))/Et(ii);
%     Rin(1,:) = Rin(1,:) - etx*(Rin(5,:)-new_delta);
    Rin(5,:) = new_delta;
    Rout = ringpass(the_ring,Rin,nturns);
    mat = reshape(Rout,6,n_part,nturns);
    perd = isnan(mat(1,:,end));
    Rin = mat(:,:,end);
    media = [media squeeze(mean(mat(:,~perd,:),2))];
    stand = [stand squeeze(std(mat(:,~perd,:),0,2))];
    temp  = [temp T0*[(1 + (ii-1)*nturns):1:(ii*nturns)]];
    if mod(ii,1000/nturns)==0
        for in = 1:6;
            plot(px(in), gamat2(Einf, E0, freq, temp)/1e9, [media(in,:); stand(in,:)]);
        end
        media = [];
        stand = [];
        temp  = [];
        fprintf('energy  : %f  particles left : %d\n', Et(ii)/1e9, sum(~isnan(Rin(1,:))));
        drawnow;
    end
end

y_label{1} = '\sigma_x, \mu_x [m]';
y_label{2} = '\sigma_{x''}, \mu_{x''} [rad]';
y_label{3} = '\sigma_y, \mu_y [m]';
y_label{4} = '\sigma_{y''}, \mu_{y''} [rad]';
y_label{5} = '\sigma_{e}, \mu_{e}';
y_label{6} = '\sigma_{l}, \mu_{l} [m]';

for in = 1:6;
    plot(px(in), gamat2(Einf, E0, freq, temp)/1e9, [media(in,:); stand(in,:)]);
    ylabel(px(in),y_label{in},'FontSize',14);
    if in>4
        xlabel(px(in),'Energy [GeV]','FontSize',20);
    end
end

disp('fim');











function rndnr = get_random_numbers(sigma, nrels, cutoff)

%distribui��o uniforme truncada em sqrt(3) sigma:
% rndnr = sqrt(3)*sigma * 2 * (rand(1, nrels) - 0.5);


% erro gaussiano truncado em 1 sigma: decidido ap�s conversa com o Ricardo
% sobre erros de alinhamento em 17/09/2012.
max_value = cutoff;

rndnr = zeros(nrels,1);
sel = 1:nrels;
while ~isempty(sel)
    rndnr(sel) = randn(1,length(sel));
    sel = find(abs(rndnr) > max_value);
    %     sel = []; % abri mão da truncagem para para tornar os erros repetitivos.
end
rndnr = sigma * rndnr;


function gamat = gamat2(gamainf, gama0, freq, dt)

gamat = (gamainf + gama0)/2 + (gamainf-gama0)/2*cos(2*pi*freq*dt - pi);
%gamat =  (gama0 + (gamainf-gama0)*2*freq*dt);
