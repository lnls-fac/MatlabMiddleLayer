function sirius_plot_twiss(maquina,tipo,save_fig)
%Funcao que faz o grafico dos parametros de twiss 
% Antes de executar esse script e necessario rodar o camando
% sirius('versao') para carregar os caminhos no matlab
%variaveis de entrada:
%   maquina - string indicando a maquina que deseja fazer os grafico, pode
%    ser 'si' para o Anel de armazenamento, 'bo' para o booster e 'tb' ou
%    'ts' para as linhas de trasnporte linac-booster ou booster-anel.
%   tipo - fazer o grafico de todas as funcoes de twiss juntas (0) ou
%   separadas (1). O Default e fazer tudo junto.
%   save_fig - flag que indica o desejo de salvar a figure sempre em
%   formato svg.
%Para utilizar o script e necessario rodas ANTES um comamndo carregando a
%rede da maquina em questao -> sirius('maquina+versao'). Depois disso o
%scripet se encarrega de fazer o resto.



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
    elseif strcmp(maquina,'bo')==1
        [THERING titulo]=sirius_bo_lattice;
        titulo=regexprep(titulo,'_','-');
        %quebra rede em segmentos de 10 cm
        THERING=lnls_refine_lattice(THERING,0.1);
        %Calcula parametros de twiss da rede
        twiss = calctwiss(THERING); 
        %Define inicio e fim para o grafico (5 periodos)
        mqf = findcells(THERING,'FamName','qf');
        ini=1;
        fim=mqf(10);
    elseif strcmp(maquina,'tb')==1
        [THERING titulo Twiss0]=sirius_tb_lattice;
        titulo=regexprep(titulo,'_','-');
        %Calcula parametros de twiss da rede
        twiss_tb = twissline(THERING,0.0,Twiss0,1:length(THERING)+1,'chrom'); 
        %Define inicio e fim para o grafico (linha de transporte completa)
        ini=1;
        fim=length(twiss_tb);
        %Redefine a estrutura de twiss
        twiss.pos=cat(1,twiss_tb.SPos);
        beta=cat(1,twiss_tb.beta);
        twiss.betax=beta(:,1);
        twiss.betay=beta(:,2);
        disp=[twiss_tb.Dispersion];
        twiss.etax=disp(1,:)';
    elseif strcmp(maquina,'ts')==1
        [THERING titulo Twiss0]=sirius_ts_lattice;
        titulo=regexprep(titulo,'_','-');
        %Calcula parametros de twiss da rede
        twiss_ts = twissline(THERING,0.0,Twiss0,1:length(THERING)+1,'chrom'); 
        %Define inicio e fim para o grafico (linha de transporte completa)
        ini=1;
        fim=length(twiss_ts);
        %Redefine a estrutura de twiss
        twiss.pos=cat(1,twiss_ts.SPos);
        beta=cat(1,twiss_ts.beta);
        twiss.betax=beta(:,1);
        twiss.betay=beta(:,2);
        disp=[twiss_ts.Dispersion];
        twiss.etax=disp(1,:)';
    else 
        fprintf('Maquina nao reconhecida');
        %break;
    end;
    
    if ~exist('tipo', 'var'), tipo = 1; end;
    
    if tipo==0
        figure1=figure('Color',[1 1 1],'Position', [1 1 760 472]);
        axes('FontSize',14);
        xlabel({'s [m]'},'FontSize',14);
        ylabel({'\beta [m]'},'FontSize',14);
        hold on;
        bx=plot(twiss.pos(ini:fim),twiss.betax(ini:fim),'LineWidth',1.5,'Color',[0 0 0.8]);
        by=plot(twiss.pos(ini:fim),twiss.betay(ini:fim),'LineWidth',1.5,'Color',[1 0 0]);
    
        %Creat grid
        grid 'on';
        
        offset=min(min(abs(twiss.betay(ini:fim)),abs(twiss.betax(ini:fim))));
        top=max(max(abs(twiss.betay(ini:fim)),abs(twiss.betax(ini:fim))));
           
        %Faz grafico da rede
        Delta=(top+offset)*0.1/3;
        offset=-offset-2*Delta;
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
    
        %Define eixo y original
        ax1 = findall(figure1,'type','axes');
    
        %Define eixo y secund?rio
        ax2 = axes('Parent',figure1,'Position',get(ax1(1),'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none','XTickLabel',[],'XColor','k','YColor','g','FontSize', 14);
        linkaxes([ax1(1) ax2],'x');
        hold on
        ex=plot(ax2,twiss.pos(ini:fim),twiss.etax(ini:fim),'LineWidth',1.5,'Color',[0 1 0]);
        ylabel(ax2,{'\eta_x [m]'},'FontSize',14,'Rot',-90);
        set(get(ax2,'YLabel'),'Position',get(get(ax2,'YLabel'),'Position')+[0.8 0 0]);
        
        %Redefine extremos para casar escala com o eixo esquerdo
        y2max=max(twiss.etax);
        y2min=min(twiss.etax);
        Deltay2=y2max-y2min;
        y1max=max(max(twiss.betax),max(twiss.betay));
        y1min=min(min(twiss.betax),min(twiss.betay));
        Deltay1= y1max-y1min;
        y1lim=get(ax1,'ylim');
        Dmin=abs((y1lim(1)-y1min)/Deltay1*Deltay2);
        Dmax=abs((y1lim(2)-y1max)/Deltay1*Deltay2);
        ylim(ax2,[(y2min-Dmin) (y2max+Dmax)])
        y1ticks=get(ax1,'YTick');
        Dticks=(y2min-Dmin)+abs((y1ticks-y1lim(1))/Deltay1*Deltay2);
        set(ax2,'Ytick',Dticks);
        set(ax2,'YTickLabel',sprintf('%1.2f|',Dticks));
        
        
    
        %Insere titulo e legenda
        title({['Twiss functions - ' titulo]},'FontSize',16,'FontWeight','bold');
        legend([bx,by],'\beta_x','\beta_y','Location','northwest','boxoff');        
    
        hold off;                
    else    
        xlimit=[0 twiss.pos(fim)];
    
        %Create Figure 
        figure1 = figure('Color',[1 1 1],'Position', [1 1 760 472]);  
        annotation('textbox', [0.3,0.88,0.1,0.1],...
           'FontSize',14,...
           'FontWeight','bold',...
           'LineStyle','none',...
           'String', ['Twiss Functions - ' titulo]);
       
        %Grafico dispersao horizontal
        subplot('position',[0.1 0.66 0.85 0.26],'FontSize',14);
        hold all;
        plot(twiss.pos(ini:fim),100*twiss.etax(ini:fim),'LineWidth',1.5,'Color',[0 1 0]);
        xlim(xlimit); ylim([-0.1, 105*max(twiss.etax)]);
        ylabel('\eta_x [cm]', 'FontSize',14);
%         set(ylab, 'position', get(ylab,'position')+[0.6,0,0]);
        grid on;
        box on;

        %Grafico rede magnetica
        subplot('position',[0.1 0.57 0.85 0.03]);
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
        subplot('position',[0.1 0.12 0.85 0.42],'FontSize',14);
        hold all;
        xlim(xlimit);
        bx=plot(twiss.pos(ini:fim),twiss.betax(ini:fim),'LineWidth',1.5,'Color',[0 0 0.8]);
        by=plot(twiss.pos(ini:fim),twiss.betay(ini:fim),'LineWidth',1.5,'Color',[1 0 0]);
        xlabel('s [m]', 'FontSize',14);
        ylabel({'\beta [m]'},'FontSize',14);
        legend('\beta_x','\beta_y','Location','northeast');
        legend('boxoff');
        grid on;
        box on; 
    end;
    
    if ~exist('save_fig','var'), save_fig = false;end

    if save_fig
        %if strcmp(save_fig,'pdf')==1
        %    print('-dpdf',[maquina 'twiss.pdf']);
        %else
        %    print('-dpng',[maquina 'twiss.png']);
        plot2svg([maquina '_twiss.svg'],figure1);
        saveas(figure1, [maquina '_twiss']);
    end
   
end

