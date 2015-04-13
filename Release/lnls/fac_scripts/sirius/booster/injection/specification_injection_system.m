clear all

RandStream.setGlobalStream(RandStream('mt19937ar','seed', 131071));



% we need to define the septum in relation to the booster:
param.x_sep = -35e-3; %position
%if the angle is zero, then the septum and its vacuum chamber are aligned
%with the booster orbit and the exit angle of the incoming beam must be
%achieved by an septum error
param.xp_sep = 16.3e-3*1;%angle

% Angle of the incoming beam in relation to the septum orbit
param.part_dang = 0e-3;
param.sep_err = 0.1/100; % flat top or variation pulse to pulse

% kicker angle
param.kick_ang = -22.32e-3;
param.kick_err = 0.1/100;

%I want to shake the initial conditions to test the system:
n_mac = 50;
Rin = [lnls_generate_random_numbers(2e-4, n_mac,'norm',2,0);... %x_ini
    zeros(1,n_mac);... %xp_ini
    lnls_generate_random_numbers(2e-4, n_mac,'norm',2,0);... %y_ini
    zeros(1,n_mac);... %yp_ini
    lnls_generate_random_numbers(2.5e-3, n_mac,'norm',2,0);... %energy_ini
    zeros(1,n_mac)];
% Rin = zeros(6,1);

%bunch tracking or single particle?:
param.n_part=10000;
param.cutoff = 3;
param.emitx = 50e-6/150e6*511e3;
param.emity = param.emitx;
param.sigmae= 5e-3;
param.sigmas= 7e-3;

%for how many meters do you want to track the incoming beamin the booster?
% keep in mind that 150m consumes swap memory in a 8gb pc.
param.len2trackB = 25;

%Calculate and load machines with orbit errors
% lattice_errors([pwd '/cod_matlab']);
% machines = load('/opt/MatlabMiddleLayer/Release/lnls/fac_scripts/sirius/booster/extraction/cod_matlab/CONFIG_machines_cod_corrected.mat');
% machines = machines.machine;
machines{1} = sirius_bo_lattice;

the_ring = machines{1};
% first, let's set its energy;
[~, ~, ~, ~, ~, ~, the_ring] = setradiation('on',the_ring);
[~, the_ring] = setcavity('on',the_ring);
the_ring = setcellstruct(the_ring,'Energy',1:length(the_ring),0.15e9);
cav_ind = findcells(the_ring,'FamName','CAV');
the_ring{cav_ind}.Voltage = 1.5e5;

% Now, lets load the transfer line
[transfer_line param.IniCond] = sirius_lb_lattice;

% The dispersion function is not matched correctly, if we set it to the
% value below, the injection works better.
% param.IniCond.Dispersion = [-0.3,0,0,0]';
% param.IniCond.beta = [7, 7];
% param.IniCond.alpha= [0,0];

% shift the ring to begin at the end of the septum:
sep_ind = findcells(the_ring,'FamName','SEPT_IN');
ind = [(sep_ind+1):length(the_ring) 1:(sep_ind)];
the_ring = the_ring(ind);
%fing out the size of the matrix and preallocate memory
spos = findspos(the_ring,1:length(the_ring));
ind = spos <= param.len2trackB;
RoutTLx = zeros(length(Rin(1,:))*param.n_part,length(transfer_line)+1); 
RoutTLy = zeros(length(Rin(1,:))*param.n_part,length(transfer_line)+1);
RoutBx  = zeros(length(Rin(1,:))*param.n_part,sum(ind));
RoutBy  = zeros(length(Rin(1,:))*param.n_part,sum(ind));
for ii= 1:length(Rin(1,:))
    param.Rin = Rin(:,ii);
    
    %Do the simulation
    [RoutTL RoutB sposTL sposB] = injection_simulation(the_ring, param, transfer_line);
    % Keep x e y coordinates:
    idx = ((ii-1)*param.n_part+1):(ii*param.n_part);
    RoutTLx(idx,:) = reshape(RoutTL(1,:),param.n_part,length(sposTL));
    RoutTLy(idx,:) = reshape(RoutTL(3,:),param.n_part,length(sposTL));
    RoutBx(idx,:)  = reshape(RoutB(1,:),param.n_part,length(sposB));
    RoutBy(idx,:)  = reshape(RoutB(3,:),param.n_part,length(sposB));
    fprintf('Ja foi:   %3d\n',ii);
end




%% plot the results

%Booster drawing:

% coordinates to draw the kickers
ind_kick = findcells(the_ring,'FamName','KICK_IN');
long_kick = findspos(the_ring,ind_kick);
for ii=1:length(ind_kick)
    s_kick(ii,:) = [0 the_ring{ind_kick(ii)}.Length]+long_kick(ii);
    xy_kick(ii,:)= [0 0];
end

% coordinates to draw the vacuum chamber
ind_b = findcells(the_ring,'FamName','B');
xy_vac = repmat(18,1,length(sposB));
xy_vac(ind_b(ind_b<length(sposB))) = 12;



% calculate the trajectory x
max_coordBx = max(RoutBx,[],1)*1e3;
min_coordBx = min(RoutBx,[],1)*1e3;
ave_coordBx = mean(RoutBx,1)*1e3;
%plot results in x-plane
scrsz = get(0,'ScreenSize');
figure1 = figure('OuterPosition', scrsz);
axes12 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
box(axes12,'on');
hold(axes12,'all');
global THERING; the_ring0 = THERING; THERING = the_ring; drawlattice(0,5,axes12,sposB(end)); THERING = the_ring0;
plot(sposB,min_coordBx,'LineStyle','--','Parent',axes12, 'Color','b');
plot(sposB,ave_coordBx,'LineWidth',3,'LineStyle','-','Parent',axes12, 'Color','b');
plot(sposB,max_coordBx,'LineStyle','--','Parent',axes12, 'Color','b');
for ii=1:length(ind_kick)
    plot(s_kick(ii,:), xy_kick(ii,:),'LineWidth',10,'LineStyle','-','Parent',axes12, 'Color','c');
end
plot(sposB, [xy_vac; -xy_vac],'LineWidth',2,'LineStyle','-','Parent',axes12, 'Color','k');
ylabel(axes12,'x [mm]'); xlabel(axes12,'s [m]');
ylim(axes12, [-50 35]);
title('Booster','Parent', axes12);


%calculate trajectory in y
max_coordBy = max(RoutBy,[],1)*1e3;
min_coordBy = min(RoutBy,[],1)*1e3;
ave_coordBy = mean(RoutBy,1)*1e3;
% plot results in y-plane
figure2 = figure('OuterPosition', scrsz);
axes22 = subplot(2,1,2,'Parent',figure2,'YGrid','on','XGrid','on','FontSize',16);
box(axes22,'on');
hold(axes22,'all');
the_ring0 = THERING; THERING = the_ring; drawlattice(0,5,axes22,sposB(end)); THERING = the_ring0;
plot(sposB,min_coordBy,'LineStyle','--','Parent',axes22, 'Color','b');
plot(sposB,ave_coordBy,'LineWidth',3,'LineStyle','-','Parent',axes22, 'Color','b');
plot(sposB,max_coordBy,'LineStyle','--','Parent',axes22, 'Color','b');
for ii=1:length(ind_kick)
    plot(s_kick(ii,:), xy_kick(ii,:),'LineWidth',10,'LineStyle','-','Parent',axes22, 'Color','c');
end
plot(sposB, [xy_vac; -xy_vac],'LineWidth',2,'LineStyle','-','Parent',axes22, 'Color','k');
ylabel(axes22,'y [mm]'); xlabel(axes22,'s [m]');
ylim(axes22,[-20 20]);
title('Booster','Parent',axes22);


%Tranfer Line drawing:

% coordinates to draw the vacuum chamber
ind_b = [ findcells(transfer_line,'FamName','bp') findcells(transfer_line,'FamName','bn')];
xy_vac = repmat(18,1,length(sposTL));
ind = sort([ind_b(ind_b<length(sposTL)), (ind_b(ind_b<length(sposTL))+1)]);
xy_vac(ind) = 12;
ind_sep = findcells(transfer_line,'FamName','sep');
ind = sort([ind_sep(ind_sep<length(sposTL)), (ind_sep(ind_sep<length(sposTL))+1)]);
xy_vac(ind) = 13;

% calculate the trajectory x
max_coordTLx = max(RoutTLx,[],1)*1e3;
min_coordTLx = min(RoutTLx,[],1)*1e3;
ave_coordTLx = mean(RoutTLx,1)*1e3;
%plot results in x-plane
axes11 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
box(axes11,'on');
hold(axes11,'all');
the_ring0 = THERING; THERING = transfer_line; drawlattice(0,5,axes11); THERING = the_ring0;
plot(sposTL,min_coordTLx,'LineStyle','--','Parent',axes11, 'Color','b');
plot(sposTL,ave_coordTLx,'LineWidth',3,'LineStyle','-','Parent',axes11, 'Color','b');
plot(sposTL,max_coordTLx,'LineStyle','--','Parent',axes11, 'Color','b');
plot(sposTL, [xy_vac; -xy_vac],'LineWidth',2,'LineStyle','-','Parent',axes11, 'Color','k');
ylabel(axes11,'x [mm]'); xlabel(axes11,'s [m]');
ylim(axes11,[-20 20]);
title('Transfer Line','Parent',axes11);


%calculate trajectory in y
max_coordTLy = max(RoutTLy,[],1)*1e3;
min_coordTLy = min(RoutTLy,[],1)*1e3;
ave_coordTLy = mean(RoutTLy,1)*1e3;
% plot results in y-plane
axes21 = subplot(2,1,1,'Parent',figure2,'YGrid','on','XGrid','on','FontSize',16);
box(axes21,'on');
hold(axes21,'all');
the_ring0 = THERING; THERING = transfer_line; drawlattice(0,5,axes21); THERING = the_ring0;
plot(sposTL,min_coordTLy,'LineStyle','--','Parent',axes21, 'Color','b');
plot(sposTL,ave_coordTLy,'LineWidth',3,'LineStyle','-','Parent',axes21, 'Color','b');
plot(sposTL,max_coordTLy,'LineStyle','--','Parent',axes21, 'Color','b');
plot(sposTL, [xy_vac; -xy_vac],'LineWidth',2,'LineStyle','-','Parent',axes21, 'Color','k');
ylabel(axes21,'y [mm]'); xlabel(axes21,'s [m]');
ylim(axes21,[-20 20]);
title('Transfer Line','Parent',axes21);


% return;
saveas(figure1,'injection_x.fig');
saveas(figure2,'injection_y.fig');

%% Create a file with relevant data
fp = fopen('injection_specific.txt','w');
fprintf(fp,'%15s %15s %15s %15s %15s %15s %15s %15s\n', 'Element','Pos [m]',...
    'Min. X [mm]','Media X [mm]','Max. X [mm]',...
    'Min. Y [mm]','Media Y [mm]','Max. Y [mm]');
for ii=1:sum(sposB<=25)
    fprintf(fp,'%15s %15.7f %15.7f %15.7f %15.7f %15.7f %15.7f %15.7f\n',...
        the_ring{ii}.FamName,sposB(ii),min_coordBx(ii),ave_coordBx(ii),max_coordBx(ii),...
        min_coordBy(ii),ave_coordBy(ii),max_coordBy(ii));
end
fclose(fp);

