function tracy3_momAccep_TousLT(the_ring, varargin)

n_calls = 1;
if nargin > 1
    n_calls = varargin{1};
end

twi = calctwiss(the_ring);
params.emit0 = 2.8e-10;
params.E     = 3e9;
params.N     = 100e-3/864/1.601e-19*1.72e-6;
params.sigE  = 0.833e-3;
params.sigS  = 3.0e-3;
params.K     = 0.01;
accepRF      = 0.05;

color = {'b','r','g','m','c','k','y'};
esp_lin = 5;
size_font = 24;
scrsz = get(0,'ScreenSize');
xi = scrsz(4)/6;
yi = scrsz(4)/10;
xf = xi + scrsz(4)*(2/3);
yf = yi + scrsz(4)*(2/3);


path = '/home/fac_files/data/sirius_tracy/';
pl = zeros(1,2*n_calls);
text_leg = cell(1,n_calls);
for i=1:n_calls
    path = uigetdir(path,'Em qual pasta estao os dados?');
    if (path==0);
        return
    end;
    % full_name = '/home/fac_files/data/sirius_tracy/sr/calcs/v500/ac10_5/test_momAccep_fun/tracy3/momAccept.out';
    
    [~, result] = system(['ls -la ' path ' | grep ''^d'' | grep rms | wc -l']);
    n_pastas = str2double(result);
    rms_mode = true;
    if n_pastas == 0
        rms_mode = false;
        n_pastas = 1;
    end
    
    text_leg(i) = inputdlg('Digite a legenda','Legenda',1);
    
    j=0;
    for k = 1:n_pastas
        pathname = path;
        if rms_mode, pathname = fullfile(path, sprintf('rms%02d',k)); end
        
        if exist(fullfile(pathname,'momAccept.out'),'file');
            [spos, accep(j+1,:,:), ~, ~] = tracy3_load_ma_data(pathname);
            j = j + 1;
        elseif exist(fullfile(pathname,'dynap_ma_out.txt'),'file');
            [spos, accep(j+1,:,:), ~, ~] = trackcpp_load_ma_data(pathname);
            j = j + 1;
        else
            fprintf('%-2d-%-3d: ma nao carregou\n',i,k);
        end
        
        Accep(1,:) = spos;
        Accep(2,:) = min(accep(j,1,:), accepRF);
        Accep(3,:) = max(accep(j,2,:), -accepRF);
        % não estou usando alguns outputs
        LT = lnls_tau_touschek_inverso(params,Accep,twi);
        lifetime(j) = 1/LT.AveRate/60/60; % em horas
    end
    
    aveAccep = squeeze(mean(accep,1))*100; % em %
    aveLT = mean(lifetime);
    if rms_mode; 
        rmsAccep = squeeze(std(accep,0,1))*100;
        rmsLT = std(lifetime);
    end
   
%     sLost = sLost(:)';
%     modSLost = mod(sLost,518.396/10);
    
    clear lifetime accep Accep
    %% exposicao dos resultados
    
    %imprime o tempo de vida
    fprintf('\n Configuração:        %-s  \n',upper(text_leg{i}));
    fprintf(' Tempo de vida médio: %10.5f h \n',aveLT);
    if rms_mode; fprintf(' Desvio Padrão:       %10.5f h \n',rmsLT); end;

    if i == 1
        f=figure('OuterPosition',[xi yi xf yf]);
        fa = axes('Parent',f,'YGrid','on','XGrid','on','FontSize',size_font);
        box(fa,'on');
        hold(fa,'all');
        xlim([0, 52])
        xlabel('Pos [m]','FontSize',size_font);
        ylabel('Momentum Acceptance [%]','FontSize',size_font);
    end
    pl([2*i-1, 2*i]) = plot(fa,spos,aveAccep, 'Marker','.','LineWidth',...
        esp_lin,'Color',color{i}, 'LineStyle','-');
    if rms_mode;
        plot(fa,spos,aveAccep + rmsAccep, 'Marker','.','Color', color{i},'LineWidth',2,'LineStyle','--');
        plot(fa,spos,aveAccep - rmsAccep, 'Marker','.','Color', color{i},'LineWidth',2,'LineStyle','--');
    end
    % [~, ele] = hdrload('MA_ele.txt');
    % plot(ele(:,1), ele(:,[2 4])*100,'r','Marker','.','DisplayName',{'elegantpos', 'elegantneg'});

%     f2=figure('OuterPosition',[xi yi xf yf]);
%     fb = axes('Parent',f2,'FontSize',size_font);
%     [n, xout] = hist(modSLost',12); bar(fb,xout,n);
%     xlim([0, 52]);
%     xlabel('Pos [m]','FontSize',size_font);
%     ylabel('Number of particles lost','FontSize',size_font);
%     title(fb,['Histograma - ' text_leg{i}]);
end

legend(pl(1:2:end),'show',text_leg, 'Location','Best');
title(fa,'Comparação de aberturas em momemtum');


