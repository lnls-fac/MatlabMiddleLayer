function sirius_plot_BSC(maquina,tipo,save_fig,e_spread)
%Funcao que faz o grafico do tamanho do feixe apenas no booster e anel de
%armazenmento.  +
%Antes de executar esse script e necessario rodar o camando
%sirius('versao') para carregar os caminhos no matlab
%variaveis de entrada:
%   maquina - string indicando a maquina que deseja fazer os grafico, pode
%    ser 'si' para o Anel de armazenamento, 'bo' para o booster e 'tb' ou
%    'ts' para as linhas de trasnporte linac-booster ou booster-anel.
%   tipo - fazer o grafico de todas as funcoes de twiss juntas (0) ou
%   separadas (1). O Default e fazer tudo junto.
%   coup - acoplamente betatron x-y.
%   save_fig - flag que indica o desejo de salvar a figure sempre em
%   formato svg.
%   e_spread - no caso das linhas de transporte o input do energy spread e
%   necessario.
%Para utilizar o script e necessario rodas ANTES um comamndo carregando a
%rede da maquina em questao -> sirius('maquina+versao'). Depois disso o
%script se encarrega de fazer o resto.



    %Carrega a rede e titulo da maquina desejada
    if strcmp(maquina,'si')==1
        [THERING titulo]=sirius_si_lattice;
        titulo=regexprep(titulo,'_','-');
        %quebra rede em segmentos de 10 cm
        THERING=lnls_refine_lattice(THERING,0.1);
        %Calcula parametros de twiss da rede
        twiss = calctwiss(THERING); 
        %Define inicio e fim para o grafico (1 periodo)
        mib = findcells(THERING,'FamName','mib');
        ini=1;
        fim=mib(1); 
        %Calcula dispersao de energia
        param=atsummary;
        e_spread=param.naturalEnergySpread;
    elseif strcmp(maquina,'bo')==1
        [THERING titulo]=sirius_bo_lattice;
        titulo=regexprep(titulo,'_','-');
        %Calcula parametros de twiss da rede
        twiss = calctwiss(THERING); 
        %Define inicio e fim para o grafico (5 periodos)
        mqf = findcells(THERING,'FamName','qf');
        ini=1;
        fim=mqf(6);
        %Calcula dispersao de energia
        param=atsummary;
        e_spread=param.naturalEnergySpread;
    elseif strcmp(maquina,'tb')==1
        [THERING titulo Twiss0]=sirius_tb_lattice;
        titulo=regexprep(titulo,'_','-');
        %Calcula parametros de twiss da rede
        twiss_tb = twissline(THERING,0.0,Twiss0,1:length(THERING)+1,'chrom'); 
        %Define inicio e fim para o grafico (linha de transporte completa)
        ini=1;
        fim=length(twiss_tb)-1;
        %Redefine a estrutura de twiss
        pos=cat(1,twiss_tb.SPos);
        twiss.pos=pos(2:length(pos));
        beta=cat(1,twiss_tb.beta);
        twiss.betax=beta(2:length(beta),1);
        twiss.betay=beta(2:length(beta),2);
        disp=[twiss_tb.Dispersion];
        twiss.etax=disp(1,2:length(disp))';
        % Define desvio de energia
        if ~exist('e_spread', 'var')
            e_spread=0;
        end;
    elseif strcmp(maquina,'ts')==1
        [THERING titulo Twiss0]=sirius_ts_lattice;
        titulo=regexprep(titulo,'_','-');
        %Calcula parametros de twiss da rede
        twiss_ts = twissline(THERING,0.0,Twiss0,1:length(THERING)+1,'chrom'); 
        %Define inicio e fim para o grafico (linha de transporte completa)
        ini=1;
        fim=length(twiss_ts)-1;
        %Redefine a estrutura de twiss
        pos=cat(1,twiss_ts.SPos);
        twiss.pos=pos(2:length(pos));
        beta=cat(1,twiss_ts.beta);
        twiss.betax=beta(2:length(beta),1);
        twiss.betay=beta(2:length(beta),2);
        disp=[twiss_ts.Dispersion];
        twiss.etax=disp(1,2:length(disp))';
        % Define desvio de energia
        if ~exist('e_spread', 'var')
            e_spread=0;
        end;
    else 
        fprinf('Maquina nao reconhecida');
        %break;
    end;
    
    if ~exist('tipo', 'var')
        tipo = 1;
    end;
    
    %Guarda tamanho da camara de vacuo
    Hap=getcellstruct(THERING,'VChamber',1:length(THERING),1);
    Vap=getcellstruct(THERING,'VChamber',1:length(THERING),2);
    
    %Calcula aceitancia
    Haccep=min(Hap.^2./twiss.betax);
    Vaccep=min(Vap.^2./twiss.betay);
    
    %Calcula beam stay clear
    HBSC=sqrt(Haccep*twiss.betax+e_spread^2*twiss.etax.^2)*1e3;
    VBSC=sqrt(Vaccep*twiss.betay+e_spread^2*twiss.etax.^2)*1e3;
    
    
    if tipo==0
        figure1=figure('Color',[1 1 1],'Position', [1 1 760 472]);
        axes('FontSize',14);
        xlabel({'s [m]'},'FontSize',14);
        ylabel({'Beam stay clear [mm]'},'FontSize',14);
        hold on;
        bx=plot(twiss.pos(ini:fim),HBSC(ini:fim),'LineWidth',1.5,'Color',[0 0 0.8]);
        by=plot(twiss.pos(ini:fim),VBSC(ini:fim),'LineWidth',1.5,'Color',[1 0 0]);
    
        %Creat grid
        grid 'on';
        box 'on';
        
        offset=min(min(abs(VBSC(ini:fim)),abs(HBSC(ini:fim))));
        top=max(max(abs(VBSC(ini:fim)),abs(HBSC(ini:fim))));
           
        %Faz grafico da rede
        Delta=(top+offset)*0.1/3;
        offset=offset-2*Delta;
        xlimit=[0 twiss.pos(fim)];
        if strcmp(maquina,'si')==1
            lnls_drawlattice(THERING,20,offset,1,Delta);     
            xlim(xlimit);
        elseif strcmp(maquina,'bo')==1
            lnls_drawlattice(THERING,10,offset,1,Delta); 
            xlim(xlimit);
        else
            lnls_drawlattice(THERING,1,offset,1,Delta);
            xlim(xlimit);
        end;
        offset=offset-2*Delta;
        ylim([offset top+2]);
    
        %Insere titulo e legenda
        title({['Beam Stay Clear - ' titulo]},'FontSize',16,'FontWeight','bold');
        legend([bx,by],'horizontal','vertical','Location','northwest','boxoff');        
    
        hold off;                
    else    
        xlimit=[0 twiss.pos(fim)];
    
        %Create Figure 
        figure1 = figure('Color',[1 1 1],'Position', [1 1 760 472]);  
        annotation('textbox', [0.3,0.88,0.1,0.1],...
           'FontSize',14,...
           'FontWeight','bold',...
           'LineStyle','none',...
           'String', ['Beam Stay Clear - ' titulo]);
       
        %Grafico dispersao horizontal
        subplot('position',[0.1 0.59 0.85 0.32],'FontSize',14);
        hold all;
        plot(twiss.pos(ini:fim),HBSC(ini:fim),'LineWidth',1.5,'Color',[0 0 0.8]);
        xlim(xlimit); ylim([0,1.1*max(HBSC)]);
        ylabel('Horizontal BSC [mm]', 'FontSize',14);
        %set(ylab, 'position', get(ylab,'position')+[0.6,0,0]);
        grid on;
        box on;

        %Grafico rede magnetica
        subplot('position',[0.1 0.48 0.85 0.03]);
        if strcmp(maquina,'si')==1
            lnls_drawlattice(THERING,20,0,1);
            xlim(xlimit);
            axis off;
        elseif strcmp(maquina,'bo')==1
            lnls_drawlattice(THERING,10,0,1);
            xlim(xlimit);
            axis off;
        else
            lnls_drawlattice(THERING,1,0,1);
            xlim(xlimit);
            axis off;
        end;

        %Grafico funcoes betatron
        subplot('position',[0.1 0.12 0.85 0.32],'FontSize',14);
        hold all;
        xlim(xlimit); ylim([0,1.1*max(VBSC)]);
        plot(twiss.pos(ini:fim),VBSC(ini:fim),'LineWidth',1.5,'Color',[1 0 0]);
        xlabel('s [m]', 'FontSize',14);
        ylabel({'Vertical BSC [mm]'},'FontSize',14);
        grid on;
        box on; 
    end;
    
    if ~exist('save_fig','var'), save_fig = false; end
    
    if save_fig
        %if strcmp(save_fig,'pdf')==1
        %    print('-dpdf',[maquina '_BSC.pdf']);
        %else
        %    print('-dpng',[maquina '_BSC.png']);
        plot2svg([maquina '_BSC.svg'],figure1);
        saveas(figure1, [maquina '_BSC']);
    end
   
end

