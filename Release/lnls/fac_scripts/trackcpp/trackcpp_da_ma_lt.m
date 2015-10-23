function trackcpp_da_ma_lt(path)

% users selects submachine
prompt = {'Submachine (bo/si)', 'energy [GeV]', 'Number of plots','Types of plots'};
defaultanswer = {'si', '3.0', '2','ma xy ex'};
answer = inputdlg(prompt,'Select submachine, energy and nr of plots', 1, defaultanswer);
if isempty(answer), return; end;
energy = str2double(answer{2});
n_calls = round(str2double(answer{3}));

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
    params.emit0 = 0.240e-9; %ats.naturalEmittance;
    params.sigE  = 9.4e-4;   %ats.naturalEnergySpread;
    params.sigS  = 3.0e-3;   %3.5e-3; % takes IBS into account
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

% parâmetros para a geração das figuras
color_vec = {'b','r','g','m','c','k','y'};
esp_lin = 5;
size_font = 24;
limx = 12;
limy = 3.5;
limpe = 6;
limne = 6;

% if ~exist('var_plane','var')
var_plane = 'x'; %determinaçao da abertura dinâmica por varreduda no plano x
% end

cell_leg_text = cell(1,n_calls);
pl = zeros(n_calls,3);
pldp = zeros(n_calls,3);
pllt = zeros(n_calls,2);
i=0;

while i < n_calls
    paths = my_uigetdir(path,'Em qual pasta estao os dados?');
    if isempty(paths);
        return;
    end
    paths = find_right_folders(paths);
    
    for jj=1:length(paths)
        path = paths{jj};
        if i >= n_calls, break; end
        i=i+1;
        
        area = []; onda =  []; offda = [];
        lifetime = []; accep = []; Accep = [];
        
        [~, result] = system(['ls -la ' path ' | grep ''^d'' | grep rms | wc -l']);
        n_pastas = str2double(result);
        rms_mode = true;
        if n_pastas == 0
            rms_mode = false;
            n_pastas = 1;
        end
        %     if nr_rms == 0, nr_rms = n_pastas; end
        
        na = regexp(path,'/','split');
        cell_leg_text(i) = inputdlg('Digite a legenda','Legenda',1,na(end-2));
        
        j=1;
        m=1;
        lt_suc=1;
        lt_prob=0;
        for k=1:n_pastas; %min([n_pastas, nr_rms]);
            pathname = path;
            if rms_mode, pathname = fullfile(path,sprintf('rms%02d',k)); end
            
            if xy
                if exist(fullfile(pathname,'dynap_xy_out.txt'),'file')
                    [onda(j,:,:),area(j), ~] = trackcpp_load_dynap_xy(pathname,var_plane);
                    j = j + 1;
                else fprintf('%-2d-%-3d: xy nao carregou\n',i,k);
                end
            end
            if ex
                if exist(fullfile(pathname, 'dynap_ex_out.txt'),'file')
                    [offda(m,:,:), ~] = trackcpp_load_dynap_ex(pathname);
                    m = m + 1;
                else fprintf('%-2d-%-3d: ex nao carregou\n',i,k);
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
                        lifetime(lt_suc) = 1/LT.AveRate/60/60; % em horas
                        lt_suc = lt_suc + 1;
                    end
                else fprintf('%-2d-%-3d: ma nao carregou\n',i,k);
                end
            end
        end
        
        if xy, aveOnda = mean(onda,1); aveYatNegX = aveOnda(1,3,1); aveArea = mean(area); end
        if ex, aveOffda = mean(offda,1); end
        if ma, aveAccep = squeeze(mean(accep,1))*100; aveLT = mean(lifetime); end
        if rms_mode
            if xy, rmsOnda = std(onda,1); rmsYatNegX = rmsOnda(1,3,1); rmsArea = std(area); end
            if ex, rmsOffda = std(offda,1); end
            if ma, rmsAccep = squeeze(std(accep,0,1))*100; rmsLT = std(lifetime); end
        end
        
        %% exposição dos resultados
        
        color = color_vec{mod(i-1,length(color_vec))+1};
        
        if i==1
            if xy && ma
                fprintf('\n%-20s %-15s %-15s %-15s\n','Config', 'Dynap XY [mm^2]', 'Aper@y=0.2 [mm]', 'Lifetime [h]');
            elseif ma
                fprintf('\n%-20s %-15s\n','Config', 'Lifetime [h]');
            elseif xy
                fprintf('\n%-20s %-15s\n','Config', 'Dynap XY [mm^2]', 'Aper@y=0.2 [mm]');
            end
        end
        if xy || ma, fprintf('%-20s ',upper(cell_leg_text{i})); end
        
        if xy
            if i == 1
                f  = figure('Position',[1,1,896,750]);
                fa = axes('Parent',f,'YGrid','on','XGrid','on','FontSize',size_font);
                box(fa,'on');  hold(fa,'all');
                xlabel('x [mm]','FontSize',size_font);
                ylabel('y [mm]','FontSize',size_font);
                xlim(fa,[-limx limx]);  ylim(fa,[0 limy]);
            end
            pl(i,2) = plot(fa, 1000*aveOnda(1,:,1), 1000*aveOnda(1,:,2), ...
                'Marker','.','LineWidth',esp_lin,'Color',color, 'LineStyle','-');
            if rms_mode
                fprintf('%5.2f \x00B1 %-5.2f   %5.1f \x00B1 %-5.1f   ',...
                        aveArea*1e6, rmsArea*1e6, aveYatNegX*1e3, rmsYatNegX*1e3);
                pl(i,1) = plot(fa, 1000*(rmsOnda(1,:,1)+aveOnda(1,:,1)),1000*(rmsOnda(1,:,2)+aveOnda(1,:,2)),...
                    'Marker','.','LineWidth',2,'LineStyle','--','Color', color);
                pl(i,3) = plot(fa, 1000*(aveOnda(1,:,1)-rmsOnda(1,:,1)),1000*(aveOnda(1,:,2)-rmsOnda(1,:,2)),...
                    'Marker','.','LineWidth',2,'LineStyle','--','Color', color);
            else
                fprintf('%5.2f           %5.1f           ', aveArea*1e6, aveYatNegX*1e3);
            end
        end
        
        if ex
            if i == 1
                fdp  = figure('Position',[1,1,896,750]);
                fdpa = axes('Parent',fdp,'YGrid','on','XGrid','on','FontSize',size_font);
                box(fdpa,'on'); hold(fdpa,'all');
                xlabel('\delta [%]','FontSize',size_font);
                ylabel('x [mm]','FontSize',size_font);
                xlim(fdpa,[-limne limpe]);  ylim(fdpa,[-limx,0]);
            end
            pldp(i,2) = plot(fdpa, 100*aveOffda(1,:,1),1000*aveOffda(1,:,2),...
                'Marker','.','LineWidth',esp_lin,'Color',color, 'LineStyle','-');
            if rms_mode
                pldp(i,1) = plot(fdpa, 100*aveOffda(1,:,1), 1000*(rmsOffda(1,:,2)+aveOffda(1,:,2)),...
                    'Marker','.','LineWidth',2,'LineStyle','--','Color', color);
                pldp(i,3) = plot(fdpa, 100*aveOffda(1,:,1),1000*(aveOffda(1,:,2)-rmsOffda(1,:,2)),...
                    'Marker','.','LineWidth',2,'LineStyle','--','Color', color);
            end
        end
        
        if ma
            %imprime o tempo de vida
            if rms_mode
                fprintf('%5.2f \x00B1 %-5.2f ', aveLT, rmsLT);
                if lt_prob, 
                    fprintf(['   *%02d máquinas desprezadas no cálculo',...
                            ' por possuírem aceitancia nula.'],lt_prob);
                end
            else
                fprintf('%5.2f ', aveLT);
            end
            
            if i == 1
                flt  = figure('Position',[1, 1, 1296, 553]);
                falt = axes('Parent',flt,'YGrid','on','FontSize',size_font,...
                            'Position',[0.10 0.17 0.84 0.73],'XGrid','on',...
                            'yTickLabel',{'-5','-2.5','0','2.5','5'},...
                            'YTick',[-5 -2.5 0 2.5 5]);
                box(falt,'on');  hold(falt,'all'); 
                ylim(falt, [-limne-0.2,limpe+0.2]); xlim(falt, [0, 52]);
                xlabel('Pos [m]','FontSize',size_font);
                ylabel('\delta [%]','FontSize',size_font);
            end
            pllt(i,:) = plot(falt,spos,aveAccep, 'Marker','.','LineWidth',...
                esp_lin,'Color',color, 'LineStyle','-');
            if rms_mode;
                plot(falt,spos,aveAccep + rmsAccep, 'Marker','.','Color',...
                     color,'LineWidth',2,'LineStyle','--');
                plot(falt,spos,aveAccep - rmsAccep, 'Marker','.','Color',...
                      color,'LineWidth',2,'LineStyle','--');
            end
        end
        if xy || ma, fprintf('\n'); end
        drawnow;
    end
end

title_text = inputdlg('Digite um Título para os Gráficos','Título',1);


if xy
    legend(pl(:,2),'show',cell_leg_text, 'Location','Best');
    title(fa,['DAXY - ' title_text{1}]);
end
if ex
    legend(pldp(:,2),'show',cell_leg_text, 'Location','Best');
    title(fdpa,['DAEX - ' title_text{1}]);
end
if ma
    legend(pllt(:,1),'show',cell_leg_text, 'Location','Best');
    lnls_drawlattice(the_ring,10, 0, true,0.2, false, falt);
    title(falt,['MA - ' title_text{1}]);
end


function pathnames = find_right_folders(paths)
    pathnames = {};
    for i=1:length(paths)
        path = paths{i};
        listing = dir(path);
        if any(strncmp({listing.name},'rms',3))
            pathnames = [pathnames,path];
            continue;
        end
        paths2 = {};
        for ii=1:length(listing)
            if any(strcmp(listing(ii).name,{'dynap_xy_out.txt',...
                                            'dynap_ex_out.txt',...
                                            'dynap_ma_out.txt'}))
                pathnames = [pathnames,path];
            else
                if listing(ii).isdir && ~any(strcmp(listing(ii).name,{'.','..'}));
                    paths2 = [paths2,fullfile(path,listing(ii).name)];
                end
            end
        end
        if ~isempty(paths2), pathnames = [pathnames, find_right_folders(paths2)];end;
    end
