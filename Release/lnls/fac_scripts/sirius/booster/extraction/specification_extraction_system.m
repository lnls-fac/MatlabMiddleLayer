clear all

%Load the parameters of the simulation
parameters;
RandStream.setGlobalStream(RandStream('mt19937ar','seed', 131071));


%fing out the size of the matrix and preallocate memory
n_part = param.n_part;
n_simul = param.number_simu;
seb_ind = findcells(synchrotron,'FamName','SEPT_EX');
boo_xmax  = zeros(n_simul,seb_ind(1));  boo_xmin = boo_xmax;   boo_xave = boo_xmax;
boo_ymax = boo_xmax;   boo_ymin = boo_xmax;   boo_yave = boo_xmax;

ltba_xmax = zeros(n_simul,length(transfer_line)+1); ltba_xmin = ltba_xmax;
ltba_xave = ltba_xmax;  ltba_ymax = ltba_xmax;   ltba_ymin = ltba_xmax;   ltba_yave = ltba_xmax;

iniTL = zeros(6,n_simul*n_part); endTL = iniTL; 
if strcmp(param.sr.mode,'4kickers')
    x_pmm = zeros(param.sr.nturns+1,n_simul*n_part);
    xp_pmm = x_pmm;   InjSRx = x_pmm;    InjSRpx = x_pmm;
else
    x_pmm = zeros(param.sr.nturns+2,n_simul*n_part);
    xp_pmm = x_pmm;   InjSRx = x_pmm;    InjSRpx = x_pmm;
end
perty = zeros(length(storage_ring)+1, 2*floor(param.sr.sef_width/2) + param.sr.nturns_pert + 2, n_simul); pertx = perty;

cutoff = param.cutoff;
for ii= 1:n_simul
    % First, we generate all the errors:
    % error of the booster's kicker:
    if param.boo.kick_err ~= 0
        err.boo_kick = lnls_generate_random_numbers(param.boo.kick_err, 1,'uniform',cutoff,0);
    else
        err.boo_kick = 0;
    end
    % error of the extraction septum
    if param.ltba.seb_err ~= 0
        err.seb = lnls_generate_random_numbers(param.ltba.seb_err, 1,'uniform',cutoff,0);
    else
        err.seb = 0;
    end
    % error of the thick septum
    if param.ltba.seg_err ~= 0
        err.seg = lnls_generate_random_numbers(param.ltba.seg_err, 1,'uniform',cutoff,0);
    else
        err.seg = 0;
    end
    % error of the thin septum
    if param.ltba.sef_err ~= 0
        err.sef = lnls_generate_random_numbers(param.ltba.sef_err, 1,'uniform',cutoff,0);
    else
        err.sef = 0;
    end
    % Phase error of the storage ring kickers
    if param.sr.kick.pha_err ~= 0
        err.kick_pha = lnls_generate_random_numbers(param.sr.kick.pha_err, 4,'uniform',cutoff,0);
    else
        err.kick_pha = [0,0,0,0];
    end
    % Amplitude error of the storage ring kickers
    if param.sr.kick.amp_err ~= 0
        err.kick_amp = lnls_generate_random_numbers(param.sr.kick.amp_err, 4,'uniform',cutoff,0);
    else
        err.kick_amp = [0,0,0,0];
    end
    if param.sr.kick.deform_err ~= 0
        err.kick_deform = lnls_generate_random_numbers(param.sr.kick.deform_err, ...
                         4*(2*floor(param.sr.kick.nturns/2) + 1),'uniform',cutoff,0);
    else
        err.kick_deform = zeros(1,4*(2*floor(param.sr.kick.nturns/2) + 1));
    end
    % Amplitude error of the pmm
    if param.sr.pmm.amp_err ~= 0
        err.pmm_amp = lnls_generate_random_numbers(param.sr.pmm.amp_err, 1,'uniform',cutoff,0);
    else
        err.pmm_amp = 0;
    end
    
    if param.boo.simulate_orbit_errors
        synchrotron = machines{mod(ii,length(machines))+1};
    end
    
    %then, we perform the extraction
    [sposB outB sposTL outTL] = extraction_simulation(synchrotron, transfer_line, param, err);

    boo_xmax(ii,:) = outB.x_max; boo_xmin(ii,:) = outB.x_min; boo_xave(ii,:) = outB.x_ave;
    ltba_xmax(ii,:)= outTL.x_max;ltba_xmin(ii,:)= outTL.x_min;ltba_xave(ii,:)= outTL.x_ave;
    boo_ymax(ii,:) = outB.y_max; boo_ymin(ii,:) = outB.y_min; boo_yave(ii,:) = outB.y_ave;
    ltba_ymax(ii,:)= outTL.y_max;ltba_ymin(ii,:)= outTL.y_min;ltba_yave(ii,:)= outTL.y_ave;
    iniTL(:,((ii-1)*n_part+1):(ii*n_part)) = outTL.Rin;
    endTL(:,((ii-1)*n_part+1):(ii*n_part)) = outTL.Rout;
    
    % and inject in the storage ring, if desired
    if param.sr.inject
        [outSR Pert] = injection_sr(storage_ring, transfer_line, outTL.Rout, param, err);
        
        if strcmp(param.sr.mode,'4kickers')
            injSRx(:,((ii-1)*n_part+1):(ii*n_part)) = squeeze(outSR.Rin(1,:,:))';
            injSRpx(:,((ii-1)*n_part+1):(ii*n_part)) = squeeze(outSR.Rin(2,:,:))';
        else
            injSRx(:,((ii-1)*n_part+1):(ii*n_part)) = outSR.Rin(1,:);
            injSRpx(:,((ii-1)*n_part+1):(ii*n_part)) = outSR.Rin(2,:);
        end
        x_pmm(:,((ii-1)*n_part+1):(ii*n_part)) = squeeze(outSR.Rout(1,:,:))';
        xp_pmm(:,((ii-1)*n_part+1):(ii*n_part)) = squeeze(outSR.Rout(2,:,:))';
        pertx(:,:,ii) = squeeze(Pert(1,:,:));
        perty(:,:,ii) = squeeze(Pert(3,:,:));
    end
    fprintf('Ja foi:   %3d\n',ii);
end

%% plot the results
scrsz = get(0,'ScreenSize');

% Booster drawing:
figure1 = figure('OuterPosition', scrsz);

% coordinates to draw the septum
s_ini = findspos(synchrotron,seb_ind(1));
s_fim = synchrotron{seb_ind(1)}.Length + s_ini;
s_sept = [s_fim s_ini s_ini s_fim];
x_sept = [22, 22, 31, 31];
y_sept = [4.5, 4.5, -4.5, -4.5];

% coordinates to draw the kickers
ind_kick = findcells(synchrotron,'FamName','KICK_EX');
long_kick = findspos(synchrotron,ind_kick);
for ii=1:length(ind_kick)
    s_kick(ii,:) = [0 synchrotron{ind_kick(ii)}.Length]+long_kick(ii);
    xy_kick(ii,:)= [0 0];
end

% coordinates to draw the vacuum chamber
ind_b = findcells(synchrotron,'FamName','B');
s_vac = findspos(synchrotron,1:length(synchrotron));
xy_vac = repmat(18,1,length(s_vac));
xy_vac(ind_b) = 12;
sel = s_vac < (sposB(end)+2);
s_vac = s_vac(sel);
xy_vac = xy_vac(sel);


% calculate the trajectory x
max_coordBx = max(boo_xmax,[],1)*1e3;
min_coordBx = min(boo_xmin,[],1)*1e3;
ave_coordBx = mean(boo_xave,1)*1e3;
axes11 = subplot(2,2,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
box(axes11,'on');
hold(axes11,'all');
plot(sposB,min_coordBx,'LineStyle','--','Parent',axes11, 'Color','b');
plot(sposB,ave_coordBx,'LineWidth',3,'LineStyle','-','Parent',axes11, 'Color','b');
plot(sposB,max_coordBx,'LineStyle','--','Parent',axes11, 'Color','b');
drawlattice(0, 5, axes11, 21, synchrotron);
plot(s_sept,x_sept,'LineWidth',2,'LineStyle','-','Parent',axes11, 'Color','c');
for ii=1:length(ind_kick)
    plot(s_kick(ii,:), xy_kick(ii,:),'LineWidth',10,'LineStyle','-','Parent',axes11, 'Color','c');
end
plot(s_vac, [xy_vac; -xy_vac],'LineWidth',2,'LineStyle','-','Parent',axes11, 'Color','k');
ylabel(axes11,'x [mm]'); xlabel(axes11,'s [m]');
ylim([-5 35]);
title('Booster','Parent',axes11);

axes12 = subplot(2,2,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
plot(iniTL(1,:)*1e3,iniTL(2,:)*1e3,'.','Parent',axes12);
ylabel('xl [mrad]','Parent',axes12); xlabel('x [mm]','Parent',axes12);
title('Phase Space @ the beginning of the TLBA','Parent',axes12);


%print on the screen the final angle of the beam
exit_angle = (ave_coordBx(end)-ave_coordBx(end-1))/(sposB(end)-sposB(end-1))*180/pi*1e-3;
fprintf('exit angle of the beam: %4f\n\n',exit_angle);


%calculate trajectory in y
max_coordBy = max(boo_ymax,[],1)*1e3;
min_coordBy = min(boo_ymin,[],1)*1e3;
ave_coordBy = mean(boo_yave,1)*1e3;
% plot results in y-plane
axes21 = subplot(2,2,3,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
box(axes21,'on');
hold(axes21,'all');
plot(sposB,min_coordBy,'LineStyle','--','Parent',axes21, 'Color','b');
plot(sposB,ave_coordBy,'LineWidth',3,'LineStyle','-','Parent',axes21, 'Color','b');
plot(sposB,max_coordBy,'LineStyle','--','Parent',axes21, 'Color','b');
drawlattice(0, 5, axes21, 21, synchrotron);
plot(s_sept,y_sept,'LineWidth',2,'LineStyle','-','Parent',axes21, 'Color','c');
for ii=1:length(ind_kick)
    plot(s_kick(ii,:), xy_kick(ii,:),'LineWidth',10,'LineStyle','-','Parent',axes21, 'Color','c');
end
plot(s_vac, [xy_vac; -xy_vac],'LineWidth',2,'LineStyle','-','Parent',axes21, 'Color','k');
ylabel(axes21,'y [mm]'); xlabel(axes21,'s [m]');


axes22 = subplot(2,2,4,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
plot(iniTL(3,:)*1e3,iniTL(4,:)*1e3,'.','Parent',axes22);
ylabel('yl [mrad]','Parent',axes22); xlabel('y [mm]','Parent',axes22);



%Tranfer Line drawing:
figure2 = figure('OuterPosition', scrsz);

% coordinates to draw the vacuum chamber
ind_b = [ findcells(transfer_line,'FamName','bp') findcells(transfer_line,'FamName','bn')];
x_vac = repmat(18,1,length(sposTL));
y_vac = repmat(18,1,length(sposTL));
ind = sort([ind_b(ind_b<length(sposTL)), (ind_b(ind_b<length(sposTL))+1)]);
x_vac(ind) = 12;
y_vac(ind) = 12;
ind_sep = [findcells(transfer_line,'FamName','seb') findcells(transfer_line,'FamName','seg') findcells(transfer_line,'FamName','sef')];
ind = sort([ind_sep(ind_sep<length(sposTL)), (ind_sep(ind_sep<length(sposTL))+1)]);
x_vac(ind) = 4.5;
y_vac(ind) = 2.5;


% calculate the trajectory x
max_coordTLx = max(ltba_xmax,[],1)*1e3;
min_coordTLx = min(ltba_xmin,[],1)*1e3;
ave_coordTLx = mean(ltba_xave,1)*1e3;
%plot results in x-plane
axes11 = subplot(2,2,1,'Parent',figure2,'YGrid','on','XGrid','on','FontSize',16);
box(axes11,'on');
hold(axes11,'all');
drawlattice(0, 5, axes11, transfer_line);
plot(sposTL,min_coordTLx,'LineStyle','--','Parent',axes11, 'Color','b');
plot(sposTL,ave_coordTLx,'LineWidth',3,'LineStyle','-','Parent',axes11, 'Color','b');
plot(sposTL,max_coordTLx,'LineStyle','--','Parent',axes11, 'Color','b');
plot(sposTL, [x_vac; -x_vac],'LineWidth',2,'LineStyle','-','Parent',axes11, 'Color','k');
ylabel(axes11,'x [mm]'); xlabel(axes11,'s [m]');
ylim(axes11,[-20 20]);
title('Transfer Line','Parent',axes11);

axes12 = subplot(2,2,2,'Parent',figure2,'YGrid','on','XGrid','on','FontSize',16);
plot(endTL(1,:)*1e3,endTL(2,:)*1e3,'.','Parent',axes12);
ylabel('xl [mrad]','Parent',axes12); xlabel('x [mm]','Parent',axes12);
title('Phase Space @ the end of the TLBA','Parent',axes12);

%calculate trajectory in y
max_coordTLy = max(ltba_ymax,[],1)*1e3;
min_coordTLy = min(ltba_ymin,[],1)*1e3;
ave_coordTLy = mean(ltba_yave,1)*1e3;
% plot results in y-plane
axes21 = subplot(2,2,3,'Parent',figure2,'YGrid','on','XGrid','on','FontSize',16);
box(axes21,'on');
hold(axes21,'all');
drawlattice(0, 5, axes21, transfer_line);
plot(sposTL,min_coordTLy,'LineStyle','--','Parent',axes21, 'Color','b');
plot(sposTL,ave_coordTLy,'LineWidth',3,'LineStyle','-','Parent',axes21, 'Color','b');
plot(sposTL,max_coordTLy,'LineStyle','--','Parent',axes21, 'Color','b');
plot(sposTL, [y_vac; -y_vac],'LineWidth',2,'LineStyle','-','Parent',axes21, 'Color','k');
ylabel(axes21,'y [mm]'); xlabel(axes21,'s [m]');
ylim(axes21,[-20 20]);


axes22 = subplot(2,2,4,'Parent',figure2,'YGrid','on','XGrid','on','FontSize',16);
plot(endTL(3,:)*1e3,endTL(4,:)*1e3,'.','Parent',axes22);
ylabel('xl [mrad]','Parent',axes22); xlabel('x [mm]','Parent',axes22);



if param.sr.inject
    %Injection drawing:
    figure3 = figure('OuterPosition', scrsz);
    
    axes11 = subplot(2,2,1,'Parent',figure3,'YGrid','on','XGrid','on','FontSize',16);
    box(axes11,'on');
    hold(axes11,'on');
    %also, draw the septum's blade
%     pos_sef_blade = (12 + 0.5 + 3 + 0.5);
    pos_sef_blade = (12 + 2.5);
    plot([-12,-12, -pos_sef_blade,-pos_sef_blade],[6, -2, -2, 6],'c','Parent',axes11, 'LineWidth',3);
    
    %and the incoming beam
    plot(injSRx'*1e3,injSRpx'*1e3,'.', 'Parent',axes11);
    ylabel('xl [mrad]','Parent',axes11); xlabel('x [mm]','Parent',axes11);
    title('Phase Space @ the injection point of the SR','Parent',axes11);
    
    %shift the lattice to begin in the injection point:
    inj_ind = findcells(storage_ring,'FamName','inj');
    ind = [(inj_ind+1):length(storage_ring) 1:(inj_ind)];
    storage_ring = storage_ring(ind);
    
    if strcmp(param.sr.mode,'4kickers')
        % we set the kickers' angles
        k4_ind = findcells(storage_ring,'FamName','kick');
        kick_angles = [1, -1, -1, 1].*param.sr.kick.angle;
        storage_ringk4 = setcellstruct(storage_ring, 'KickAngle', k4_ind, kick_angles, 1);
        %find the closed orbit
        orb = findorbit6(storage_ringk4,1,[-9e-3;0;0;0;0;0]);
        % track to draw the phase space
        Rin = bsxfun(@plus,[[-9e-3;0;0;0;0;0],[-7e-3;0;0;0;0;0]],orb);
        Rout = ringpass(storage_ringk4,Rin,100);
        % and draw it
        plot(orb(1)*1e3,orb(2)*1e3,'r.','Parent',axes11,'MarkerSize',20);
        plot(Rout(1,:)*1e3,Rout(2,:)*1e3,'k.', 'Parent',axes11);

        ylim([-0.55,0.55]);
        
    elseif strcmp(param.sr.mode,'pmm')
       
        ylim([-0.55,4]);
        
        % track to draw the phase space
        Rin = [[-9e-3;0;0;0;0;0],[-7e-3;0;0;0;0;0]];
        Rout = ringpass(storage_ring,Rin,100);
        % and draw it
        plot(Rout(1,:)*1e3,Rout(2,:)*1e3,'k.', 'Parent',axes11);    
    end
    
    % shift the lattice to begin at the pmm exit
    pmm_ind = findcells(storage_ring,'FamName','pmm');
    ind = [(pmm_ind+1):length(storage_ring) 1:(pmm_ind)];
    storage_ring = storage_ring(ind);
    
    
    % now we plot the beam for nturns
    axes12 = subplot(2,2,2,'Parent',figure3,'YGrid','on','XGrid','on','FontSize',16);
    box(axes12,'on');
    hold(axes12,'on');
    plot(x_pmm'*1e3,xp_pmm'*1e3, '.', 'Parent',axes12);
    ylabel('xl [mrad]','Parent',axes12); xlabel('x [mm]','Parent',axes12);
    title('Phase Space after pmm for n turns in the SR','Parent',axes12);
    Rin = [[-12e-3;0;0;0;0;0],[-7e-3;0;0;0;0;0]];
    Rout = ringpass(storage_ring,Rin,100);
    plot(Rout(1,:)*1e3,Rout(2,:)*1e3,'k.', 'Parent',axes12);
    
    if strcmp(param.sr.mode,'pmm')
        polB = param.sr.pmm.polb;
        x = (-9:0.5:9)*1e-3;
        X = [];
        for ii = 0:(length(polB)-1)
            y = x.^ii;
            X = [X; y];
        end
        y = polB*X;
        y= y/max(y)*max(xp_pmm(1,:));
        
        plot(x*1e3,y*1e3, 'Parent',axes12);
    end
    
    % Now lets analyse the perturbation in the stored beam, if desired
    if param.sr.perturb_stored_beam
        
        % Select the points were we want to look the beam shaking;
        mia = findcells(storage_ring,'FamName','mia');mia=mia(2);
        mib = findcells(storage_ring,'FamName','mib');mib=mib(1);
        mc  = findcells(storage_ring,'FamName','mc');mc=mc(1);
        
        xpert_ave = max(pertx([mia,mib,mc],:,:),[],3);
        ypert_ave = max(perty([mia,mib,mc],:,:),[],3);
        turns = 1:size(xpert_ave,2);
        
        axes21 = subplot(2,2,3,'Parent',figure3,'YGrid','on','XGrid','on','FontSize',16);
        box(axes21,'on');
        hold(axes21,'on');
        plot(turns,xpert_ave*1e6, 'Parent',axes21);
        xlabel('number of turns [#]','Parent',axes21); ylabel('x [\mu m]','Parent',axes21);
        title('Average Perturbation of the stored beam','Parent',axes21);
        
        axes22 = subplot(2,2,4,'Parent',figure3,'YGrid','on','XGrid','on','FontSize',16);
        box(axes22,'on');
        hold(axes22,'on');
        plot(turns,ypert_ave*1e6, 'Parent',axes22);
        xlabel('number of turns [#]','Parent',axes22); ylabel('y [\mu m]','Parent',axes22);
        title('Average Perturbation of the stored beam','Parent',axes22);

    end
end


saveas(figure1,'extraction.fig');
saveas(figure2,'transport.fig');


%% Create a file with relevant data
fp = fopen('extraction_specific.txt','w');
fprintf(fp,'%15s %15s %15s %15s %15s %15s %15s %15s\n', 'Element','Pos [m]',...
    'Min. X [mm]','Media X [mm]','Max. X [mm]',...
    'Min. Y [mm]','Media Y [mm]','Max. Y [mm]');
for ii=1:length(sposB)
    fprintf(fp,'%15s %15.7f %15.7f %15.7f %15.7f %15.7f %15.7f %15.7f\n',...
        synchrotron{ii}.FamName,sposB(ii),min_coordBx(ii),ave_coordBx(ii),max_coordBx(ii),...
        min_coordBy(ii),ave_coordBy(ii),max_coordBy(ii));
end
fclose(fp);