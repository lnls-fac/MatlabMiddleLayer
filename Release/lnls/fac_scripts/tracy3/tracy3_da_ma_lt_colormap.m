function tracy3_da_ma_lt_colormap(path)

% users selects submachine
prompt = {'Submachine (bo/si)', 'energy [GeV]', 'Plot Loss Rate? (y/n)'};
defaultanswer = {'si', '3.0','n'};
answer = inputdlg(prompt,'Select submachine, energy and nr of plots', 1, defaultanswer);
if isempty(answer), return; end;
energy = str2double(answer{2});
plot_LR = false;
if strncmpi(answer{3},'y',1), plot_LR = true; end

if strcmpi(answer{1}, 'bo')
    
    if ~exist('path','var')
        path = '/home/fac_files/data/sirius/bo/beam_dynamics';
    end
    r = which('sirius_bo_lattice.m');
    if isempty(r)
        sirius('BO');
    end
    
    the_ring = sirius_bo_lattice(energy);
    ats = atsummary(the_ring);
    if (energy == 0.15)
        % BOOSTER (equillibirum parameters from LINAC)
        params.E     = energy * 1e9;
        params.emit0 = 170e-9;  % linac
        params.sigE  = 5.0e-3;  % linac
        params.sigS  = 11.2e-3; % linac
        accepRF      = 0.033;
        params.K     = 0.0002;
        params.I     = 0.6;
        params.nrBun = 1;
    else
        params.E     = energy * 1e9;
        params.emit0 = ats.naturalEmittance;
        params.sigE  = ats.naturalEnergySpread;
        params.sigS  = ats.bunchlength;
        params.K     = 0.0002;
        params.I     = 0.6;
        params.nrBun = 1;
        accepRF      = ats.energyacceptance;
    end 
else
    if ~exist('path','var')
        path = '/home/fac_files/data/sirius/si/beam_dynamics';
    end
    r = which('sirius_si_lattice.m');
    if isempty(r)
        sirius('SI');
    end
    
    the_ring = sirius_si_lattice(energy);
    ats = atsummary(the_ring);
    params.E     = energy * 1e9;
    % Data given by Natalia
    params.emit0 = 0.306e-9; %ats.naturalEmittance;
    params.sigE  = 8.8e-4;   %ats.naturalEnergySpread;
    params.sigS  = 2.7e-3;   %3.5e-3; % takes IBS into account
    params.K     = 0.01;
    params.I     = 100;
    params.nrBun = 864;
    accepRF      = ats.energyacceptance;
end


% users selects beam lifetime parameters
prompt = {'Emitance[nm.rad]', 'Energy spread', 'Bunch length (with IBS) [mm]',...
          'Coupling [%]', 'Current [mA]', 'Nr bunches', 'RF Energy Acceptance [%]'};
defaultanswer = {num2str(params.emit0/1e-9), num2str(params.sigE), ...
                 num2str(params.sigS*1000), num2str(100*params.K), ...
                 num2str(params.I), num2str(params.nrBun), num2str(accepRF*100)};
answer = inputdlg(prompt,'Parameters for beam lifetime calculation', 1, defaultanswer);
if isempty(answer), return; end;
params.emit0 = str2double(answer{1})*1e-9;
params.sigE  = str2double(answer{2});
params.sigS  = str2double(answer{3})/1000;
params.K     = str2double(answer{4})/100;
params.I     = str2double(answer{5})/1000;
params.nrBun = round(str2double(answer{6}));
accepRF      = str2double(answer{7})/100;
params.N     = params.I/params.nrBun/1.601e-19*ats.revTime;

twi = calctwiss(the_ring);

size_font = 28;
type_colormap = 'Jet';
limx = 12;
limy = 3.0;
lime = 5.0;

mostra = 0; % 0 = porcentagem de part perdidas
% 1 = número medio de voltas
% 2 = posicao em que foram perdidas
% 3 = plano em que foram perdidas

% loops over random machine, loading and plotting data
count = 0; countdp = 0;

% selects data folder
path = uigetdir(path,'Em qual pasta estao os dados?');
if (path == 0);
    return
end

% gets number of random machines (= number of rms folders)
[~, result] = system(['ls ' path '| grep rms | wc -l']);
n_pastas = str2double(result);

lifetime = []; accep = []; Accep = []; LossRate = [];
for i=1:n_pastas
    % -- FMAP --
    pathname = fullfile(path, ['rms', num2str(i, '%02i')]);
    
    if exist(fullfile(pathname,'daxy.out'),'file')
        [~, dados1] = tracy3_load_daxy_data(pathname);
        ind = dados1.plane == -1;
    elseif exist(fullfile(pathname, 'fmap.out'),'file')
        [~, dados1] = tracy3_load_fmap_data(pathname);
        ind = (dados1.fx ~= 0);
    elseif exist(fullfile(pathname,'dynap_xy_out.txt'),'file');
        [~, dados1] = trackcpp_load_dynap_xy(pathname);
        ind = dados1.plane == 0;
    else
        fprintf('%-3d: xy nao carregou\n',i);
    end
    
    if exist(fullfile(pathname, 'daex.out'),'file')
        [~, dados2] = tracy3_load_daex_data(pathname);
        inddp = dados2.plane == -1;
    elseif exist(fullfile(pathname, 'fmapdp.out'),'file')
        [~, dados2] = tracy3_load_fmapdp_data(pathname);
        inddp = (dados2.fen ~= 0);
    elseif exist(fullfile(pathname, 'dynap_ex_out.txt'),'file');
        [~, dados2] = trackcpp_load_dynap_ex(pathname);
        inddp = dados2.plane == 0;
    else
        fprintf('%-3d: ex nao carregou\n',i);
    end
    
    if exist(fullfile(pathname,'momAccept.out'),'file');
        [spos, accep(i,:,:), ~, ~] = tracy3_load_ma_data(pathname);
    elseif exist(fullfile(pathname,'dynap_ma_out.txt'),'file');
        [spos, accep(i,:,:), ~, ~] = trackcpp_load_ma_data(pathname);
    else
        fprintf('%-3d: ma nao carregou\n',i);
    end
    Accep(1,:) = spos;
    Accep(2,:) = min(accep(i,1,:), accepRF);
    Accep(3,:) = max(accep(i,2,:), -accepRF);
    % não estou usando alguns outputs
    LT = lnls_tau_touschek_inverso(params,Accep,twi);
    lifetime(i) = 1/LT.AveRate/60/60; % em horas
    LossRate(i,:) = LT.Rate;
    
    
    if i == 1, idx_daxy = zeros(size(ind));end;
    if i == 1, idx_daex = zeros(size(inddp));end;
    switch mostra
        case 0
            idx_daxy = idx_daxy + ind;
            idx_daex = idx_daex + inddp;
        case 1
            idx_daxy = idx_daxy + dados1.turn;
            idx_daex = idx_daex + dados2.turn;
        case 2
            idx_daxy = idx_daxy + mod(dados1.pos,51.8396);
            idx_daex = idx_daex + mod(dados2.pos,51.8396);
        case 3
            idx_daxy = idx_daxy + dados1.plane;
            idx_daex = idx_daex + dados2.plane;
    end
    count = count + 1;
    countdp = countdp+1;

end

switch mostra
    case 0
        idx_daxy = (count-idx_daxy)/count*100;
        idx_daxy(1,1) = 100; idx_daxy(1,2) = 0;
        idx_daex = (count-idx_daex)/countdp*100;
        idx_daex(1,1) = 100; idx_daex(1,2) = 0;
end

aveAccep = squeeze(mean(accep,1))*100; % em %
aveLT = mean(lifetime);
stdLT = std(lifetime);

%% make the figures
f1 = figure('Position',[1, 1, 1596, 553],'Color',[1 1 1]);
ax1 = axes('Parent',f1,'Position',[0.06 0.17 0.38 0.80],'FontSize',size_font);
xlim(ax1,[-limx limx]);   ylim(ax1,[0 limy]);
box(ax1,'on');            hold(ax1,'all');
xlabel('x [mm]','FontSize',size_font);
ylabel('y [mm]','FontSize',size_font);
pcolor(ax1, 1000*dados1.x, 1000*dados1.y, idx_daxy);
colormap(ax1, type_colormap); shading(ax1, 'flat');%'interp');

ax2 = axes('Parent',f1,'XTickLabel',{'-5','-2.5','0','2.5','5'},...
    'XTick',[-5 -2.5 0 2.5 5],'Position',[0.53 0.17 0.38 0.80],'FontSize',size_font);
box(ax2,'on');              hold(ax2,'all');
pcolor(ax2, 100*dados2.en, 1000*dados2.x, idx_daex);
colormap(ax2, type_colormap); shading(ax2, 'flat');%'interp');
xlabel(ax2, '\delta [%]','FontSize',size_font);
ylabel(ax2, 'x [mm]','FontSize',size_font);
xlim(ax2, [-lime lime]); ylim(ax2,[-limx,0]);

colorbar('peer',ax2, [0.92 0.17 0.013 0.80], 'FontSize',24,'YTick',...
    [0,20,40,60,80,100],'YTickLabel',{'100%','80%','60%','40%','20%','0%'});
annotation(f1,'textbox', [0.54 0.21 0.11 0.08],'String',{'y = 1 mm'},...
    'FontSize',28,'FitBoxToText','off','LineStyle','none','Color',[1 1 1]);
annotation(f1,'textbox',[0.35 0.83 0.06 0.08],'String',{'\delta = 0'},...
    'FontSize',28,'FitBoxToText','off','LineStyle','none','Color',[1 1 1]);

f2=figure('Position',[1, 1, 1296, 553]);
falt = axes('Parent',f2,'YGrid','on','XGrid','on','yTickLabel',{'-5','-2.5','0','2.5','5'},...
    'YTick',[-5 -2.5 0 2.5 5],'Position',[0.10 0.17 0.84 0.80],'FontSize',size_font);
box(falt,'on'); hold(falt,'all');
xlabel('pos [m]','FontSize',size_font);
ylabel('\delta [%]','FontSize',size_font);
plot(falt,spos,squeeze(accep(:,1,:))*100,'Color',[0.6 0.6 1.0]);
plot(falt,spos,squeeze(accep(:,2,:))*100,'Color',[0.6 0.6 1.0]);
plot(falt,spos,aveAccep,'LineWidth',3,'Color',[0,0,1]);
if plot_LR, plot(falt,LT.Pos,2.5*LossRate/max(LossRate(:)),'Color',[0,0,0]); end
lnls_drawlattice(the_ring,10, 0, true,0.2);
xlim([0, 52]); ylim([-5.3, 5.3]);

string = {sprintf('%-10s = %3.1f GeV','Energy',params.E/1e9),...
          sprintf('%-10s = %5.3f mA','I/bunch',params.N*1.601e-19/1.72e-6*1e3),...
          sprintf('%-10s = %3.1f %%','Coupling',params.K*100),...
          sprintf('%-10s = %5.3f nm.rad','\epsilon_0',params.emit0*1e9),...
          sprintf('%-10s = %5.3f %%','\sigma_{\delta}',params.sigE*100),...
          sprintf('%-9s = %5.3f mm','\sigma_L',params.sigS*1e3),...
          sprintf('Tousc LT = %5.1f \xb1 %3.1f h',aveLT,stdLT)};
annotation(f2,'textbox',[0.41 0.33 0.21 0.19],'String',string(1:3),...
    'FontSize',20,'FitBoxToText','off','LineStyle','none','Color',[0 0 0]);
annotation(f2,'textbox',[0.44 0.61 0.17 0.21],'String',string(4:6),...
    'FontSize',20,'FitBoxToText','off','LineStyle','none','Color',[0 0 0]);
annotation(f2,'textbox',[0.66 0.44 0.23 0.075],'String',string(7),...
    'FontSize',20,'FitBoxToText','off','LineStyle','none','Color',[0 0 0]);
% /home/fac_files/data/sirius/si/beam_dynamics/calcs/v03/study.new.optics/moga/default/firstRun_results/FR001436/multi.cod.tune.coup.physap/trackcpp

