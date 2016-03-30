function trackcpp_da_ma_lt_colormap(path)

% users selects submachine
prompt = {'Submachine (bo/si)', 'energy [GeV]', 'Plot Loss Rate? (y/n)','Types of plots'};
defaultanswer = {'si', '3.0','n','ma xy ex'};
answer = inputdlg(prompt,'Select submachine, energy and nr of plots', 1, defaultanswer);
if isempty(answer), return; end;
energy = str2double(answer{2});
plot_LR = false; if strncmpi(answer{3},'y',1), plot_LR = true; end

xy = false; if any(strfind(answer{4},'xy')), xy = true;end
ex = false; if any(strfind(answer{4},'ex')), ex = true;end
ma = false; if any(strfind(answer{4},'ma')), ma = true;end

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
    
    limx = 18;
    limy = 6.0;
    lime = 3.0;
    limeLT=2.3;
    limsLT=496.8/10;
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
    params.emit0 = 0.246e-9; %ats.naturalEmittance;
    params.sigE  = 8.5e-4;   %ats.naturalEnergySpread;
    params.sigS  = 3.0e-3;   %3.5e-3; % takes IBS into account
    params.K     = 0.01;
    params.I     = 100;
    params.nrBun = 864;
    accepRF      = ats.energyacceptance;
    
    limx = 12;
    limy = 3.0;
    lime = 5.0;
    limeLT=6.0;
    limsLT=518.396/10;
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

size_font = 16;
type_colormap = 'Jet';

mostra = 0; % 0 = porcentagem de part perdidas
% 1 = número medio de voltas
% 2 = posicao em que foram perdidas
% 3 = plano em que foram perdidas

var_plane = 'x'; %determinaçao da abertura dinâmica por varreduda no plano x

% selects data folder
path = uigetdir(path,'Em qual pasta estao os dados?');
if (path == 0), return; end
path = find_right_folder({path});
if isempty(path), return; end

% gets number of random machines (= number of rms folders)
[~, result] = system(['ls -la ' path ' | grep ''^d'' | grep rms | wc -l']);
n_pastas = str2double(result);

Ltime = []; accep = []; Accep = []; LossRate = [];
lt_suc = 1;
lt_prob= 0;
for i=1:n_pastas
    pathname = fullfile(path,sprintf('rms%02d',i));
    if xy
        if exist(fullfile(pathname,'dynap_xy_out.txt'),'file')
            [~, area, dados1] = trackcpp_load_dynap_xy(pathname);
            if ~exist('idx_daxy','var'), idx_daxy = zeros(size(dados1.plane));end
            switch mostra
                case 0, idx_daxy = idx_daxy + (dados1.plane == 0);
                case 1, idx_daxy = idx_daxy + dados1.turn;
                case 2, idx_daxy = idx_daxy + mod(dados1.pos,51.8396);
                case 3, idx_daxy = idx_daxy + dados1.plane;
            end
        else fprintf('%-3d: xy nao carregou\n',i);
        end
    end
    if ex
        if exist(fullfile(pathname, 'dynap_ex_out.txt'),'file')
            [~, dados2] = trackcpp_load_dynap_ex(pathname);
            if ~exist('idx_daex','var'), idx_daex = zeros(size(dados2.plane));end
            switch mostra
                case 0, idx_daex = idx_daex + (dados2.plane == 0);
                case 1, idx_daex = idx_daex + dados2.turn;
                case 2, idx_daex = idx_daex + mod(dados2.pos,51.8396);
                case 3, idx_daex = idx_daex + dados2.plane;
            end
        else fprintf('%-3d: ex nao carregou\n',i);
        end
    end
    if ma
        if exist(fullfile(pathname,'dynap_ma_out.txt'),'file')
            [spos, aceit, ~, ~] = trackcpp_load_ma_data(pathname);
            if any(~aceit(:))
                lt_prob = lt_prob + 1;
            else
                accep(lt_suc,:,:) = aceit;
                Accep.s   = spos;
                Accep.pos = min(aceit(1,:), accepRF);
                Accep.neg = max(aceit(2,:), -accepRF);
                % não estou usando alguns outputs
                LT = lnls_tau_touschek_inverso(params,Accep,twi);
                Ltime(lt_suc) = 1/LT.AveRate/60/60; % em horas
                LossRate(lt_suc,:) = LT.Rate;
                lt_suc = lt_suc + 1;
            end
            else fprintf('%-3d: ma nao carregou\n',i);
        end
    end
end

if xy && (mostra == 0)
    idx_daxy = (n_pastas-idx_daxy)/n_pastas*100;
    idx_daxy(1,1) = 100;      idx_daxy(1,2) = 0;
end
if ex && (mostra == 0)
    idx_daex = (n_pastas-idx_daex)/n_pastas*100;
    idx_daex(1,1) = 100;      idx_daex(1,2) = 0;
end
if ma
    aveAccep = squeeze(mean(accep,1))*100; % em %
    aveLT = mean(Ltime);      stdLT = std(Ltime);
end

%% make the figures
if xy
    f1 = figure('Position',[636,3,629,462],'Color',[1 1 1]);
    ax1 = axes('Parent',f1,'Units','pixels','FontSize',size_font);
    xlim(ax1,[-limx limx]);   ylim(ax1,[0 limy]);
    box(ax1,'on');            hold(ax1,'all');
    xlabel('x [mm]','FontSize',size_font);
    ylabel('y [mm]','FontSize',size_font);
    pcolor(ax1, 1000*dados1.x, 1000*dados1.y, idx_daxy);
    colormap(ax1, type_colormap); shading(ax1, 'flat');%'interp');
    annotation(f1,'textbox','Units','pixels','Position', [450 372 102 37],'String',{'\delta = 0'},...
        'FontSize',size_font,'FitBoxToText','on','LineStyle','none','Color',[1 1 1]);
    colorbar('peer',ax1,'Units','pixels','Position',[557 60 14 390], ...
        'FontSize',size_font,'YTick',[0,20,40,60,80,100],...
        'YTickLabel',{'100%','80%','60%','40%','20%','0%'});
    set(ax1,'Position',[65,60,485,390]);
end
if ex
    f1 = figure('Position',[3,3,629,462],'Color',[1 1 1]);
    ax2 = axes('Parent',f1,'Units','pixels','XTick',[-6,-4,-2,0,2,4,6],...
        'XTickLabel',{'-6','-4','-2','0','2','4','6'},'FontSize',size_font);
    box(ax2,'on');              hold(ax2,'all');
    pcolor(ax2, 100*dados2.en, 1000*dados2.x, idx_daex);
    colormap(ax2, type_colormap); shading(ax2, 'flat');%'interp');
    xlabel(ax2, '\delta [%]','FontSize',size_font);
    ylabel(ax2, 'x [mm]','FontSize',size_font);
    xlim(ax2, [-lime lime]); ylim(ax2,[-limx,0]);
    annotation(f1,'textbox','Units','pixels','Position', [77 75 63 32],'String',{'y = 1 mm'},...
        'FontSize',size_font,'FitBoxToText','on','LineStyle','none','Color',[1 1 1]);
    colorbar('peer',ax2, 'Units','pixels','Position',[557 60 14 390],...
        'FontSize',size_font,'YTick',[0,20,40,60,80,100],...
        'YTickLabel',{'100%','80%','60%','40%','20%','0%'});
    set(ax2,'Position',[65,60,485,390]);
end


if ma
    f2=figure('Position',[3, 3, 956, 462]);
    falt = axes('Parent',f2,'YGrid','on','XGrid','on','yTickLabel',{'-5','-2.5','0','2.5','5'},...
        'YTick',[-5 -2.5 0 2.5 5],'Units','pixels','Position',[77 64 864, 385],'FontSize',size_font);
    box(falt,'on'); hold(falt,'all');
    xlabel('pos [m]','FontSize',size_font);
    ylabel('\delta [%]','FontSize',size_font);
    plot(falt,spos,squeeze(accep(:,1,:))*100,'Color',[0.6 0.6 1.0]);
    plot(falt,spos,squeeze(accep(:,2,:))*100,'Color',[0.6 0.6 1.0]);
    plot(falt,spos,aveAccep,'LineWidth',3,'Color',[0,0,1]);
    if plot_LR, plot(falt,LT.Pos,limeLT/2*LossRate/max(LossRate(:)),'Color',[0,0,0]); end
    lnls_drawlattice(the_ring,10, 0, true,0.2);
    xlim([0, limsLT]); ylim([-limeLT-0.3, limeLT+0.3]);
    
%     string = {sprintf('%-10s = %3.1f GeV','Energy',params.E/1e9),...
%         sprintf('%-10s = %5.3f mA','I/bunch',params.N*1.601e-19/1.72e-6*1e3),...
%         sprintf('%-10s = %3.1f %%','Coupling',params.K*100),...
%         sprintf('%-10s = %5.3f nm.rad','\epsilon_0',params.emit0*1e9),...
%         sprintf('%-10s = %5.3f %%','\sigma_{\delta}',params.sigE*100),...
%         sprintf('%-9s = %5.3f mm','\sigma_L',params.sigS*1e3),...
%         sprintf('Tousc LT = %5.1f \xb1 %3.1f h',aveLT,stdLT)};
%     annotation(f2,'textbox','Units','pixels','Position',[390, 162, 220, 90],'String',string(1:3),...
%         'FontSize',size_font,'FitBoxToText','on','LineStyle','none','Color',[0 0 0]);
%     annotation(f2,'textbox','Units','pixels','Position',[420, 267, 192, 91],'String',string(4:6),...
%         'FontSize',size_font,'FitBoxToText','on','LineStyle','none','Color',[0 0 0]);
%     annotation(f2,'textbox','Units','pixels','Position',[632, 202, 253, 37],'String',string(7),...
%         'FontSize',size_font,'FitBoxToText','on','LineStyle','none','Color',[0 0 0]);
end

function pathname = find_right_folder(paths)
pathname = '';
for i=1:length(paths)
    path = paths{i};
    listing = dir(path);
    if any(strncmp({listing.name},'rms',3))
        pathname = path;
        return;
    end
    paths2 = {};
    for ii=1:length(listing)
        if listing(ii).isdir && ~any(strcmp(listing(ii).name,{'.','..'}));
            paths2 = [paths2,fullfile(path,listing(ii).name)];
        end
    end
    if ~isempty(paths2)
        pathname = find_right_folder(paths2);
        if ~isempty(pathname), return; end
    end;
end