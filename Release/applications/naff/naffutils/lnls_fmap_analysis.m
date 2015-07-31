function lnls_fmap_analysis

data.path = pwd;
data.maptypes = {'fmap','fmapdp'};
data.fmap.fname   = 'fmap.out';
data.fmapdp.fname = 'fmapdp.out';

%% Creation of the Figure

handle.fig     = figure('Position',[100, 100, 1600, 850],'ToolBar','figure');
%axes
handle.ax_freq = axes('Units','Pixels','Position',[100, 515,1170,325],'FontSize',16);
handle.ax_real = axes('Units','Pixels','Position',[100, 100,1170,325],'FontSize',16);

%tune properties
handle.halfTunex = uicontrol('Style', 'checkbox','String', 'Above 0.5?','Min',0,...
    'Max',1, 'Position', [1360 780 100 20],'Callback',{@tune_callBack});
handle.halfTuney = uicontrol('Style', 'checkbox','String', 'Above 0.5?','Min',0,...
    'Max',1, 'Position', [1360 760 100 20],'Callback',{@tune_callBack});
handle.intTunex  = uicontrol('Style','edit','String','48',...
    'Position',[1320 780 40 20],'Callback',{@tune_callBack});
handle.intTuney  = uicontrol('Style','edit','String','13',...
    'Position',[1320 760 40 20],'Callback',{@tune_callBack});
uicontrol('Style','text','Position',[1280 780 40 20],'String','Qx:');
uicontrol('Style','text','Position',[1280 760 40 20],'String','Qy:');

%buttons related to data loading
uicontrol('Style', 'pushbutton', 'String', 'LOAD DATA',...
    'Position', [1320 820 100 20],'Callback', {@loadData_callBack});
handle.maptype = uicontrol('Style', 'popup', 'String', data.maptypes,...
    'Position', [1480 760 100 20], 'Callback',{@maptype_callBack});
handle.diffusion = uicontrol('Style','checkbox','String','Diffusion','Min',0,...
    'Max',1,'Position',[1480 780 100 20],'Callback',{@diffusion_callBack});
uicontrol('Style', 'pushbutton', 'String', 'REPLOT',...
    'Position', [1480 820 80 20],'Callback', {@replot_callBack});

% Pick points in the graphics
uicontrol('Style', 'pushbutton', 'String', 'PICK',...
    'Position', [1490 630 50 20],'Callback', {@pick_callBack});
handle.pick_color = uicontrol('Style','pushbutton','Position',[1490 690 50 20],...
    'String','Color', 'BackgroundColor','r','Callback', {@pick_color_callBack});
handle.pick_fill  = uicontrol('Style', 'checkbox','String', 'fill','Min',0,...
    'Max',1, 'Position', [1490 670 50 20]);
uicontrol('Style','text','String','Size:','Position',[1490 650 30 20]);
handle.pick_size  = uicontrol('Style','edit','String','8','Position',[1520 650 20 20]);
handle.pickx = uicontrol('Style','text','Position',[1315 690 120 20],'String','x  =         ');
handle.picky = uicontrol('Style','text','Position',[1315 670 120 20],'String','y  =         ');
handle.pickfx= uicontrol('Style','text','Position',[1315 650 120 20],'String','fx =         ');
handle.pickfy= uicontrol('Style','text','Position',[1315 630 120 20],'String','fy =         ');

% Resonances
% Individual resonances
handle.resx  = uicontrol('Style','edit','String','1','Position',[1310 520 40 20]);
uicontrol('Style','text','String','* Qx  + ','Position',[1350 520 60 20]);
handle.resy  = uicontrol('Style','edit','String','1','Position',[1410 520 40 20]);
uicontrol('Style','text','String','* Qy  = ','Position',[1450 520 60 20]);
handle.resO  = uicontrol('Style','edit','String','0','Position',[1510 520 40 20]);
uicontrol('Style', 'pushbutton', 'String', 'PLOT',...
    'Position', [1400 495 50 20],'Callback', {@res_plot_indiv_callBack});

%resonances by order
uicontrol('Style','text','String','Periodicity :','Position',[1365 425 100 20]);
handle.resPeri  = uicontrol('Style','edit','String','1','Position',[1465 425 40 20]);
uicontrol('Style', 'pushbutton', 'String', 'CLEAR',...
    'Position', [1410 315 50 20],'Callback', {@res_clear_callBack});

for ii=1:16
    res_str = sprintf('%02d',ii);
    xpos = 1355 + (mod(ii-1,4))*40;
    ypos =  400 - (floor((ii-1)/4))*20;
    uicontrol('Style','checkbox','String',res_str,'Min',0,'Tag','Res',...
    'Max',1,'Position',[xpos ypos 40 20],'Callback',{@res_callBack});
end

%Create Figure
uicontrol('Style', 'pushbutton', 'String', 'CREATE FIGURE',...
    'Position', [1390 195 100 20],'Callback', {@create_figure_callBack});

%% Call Back functions
    function tune_callBack(hObj,event)
        prepareData();
        plotData();
    end
    function loadData_callBack(hObj, event)
        loadData();
        prepareData();
        plotData();
    end
    function replot_callBack(hObj, event)
        prepareData();
        plotData();
    end
    function pick_callBack(hObj, event)
        disp('Left mouse button picks points.')
        disp('Right mouse button picks last point.')
        hold on
        button = 1;
        n=0;
        set(hObj,'Enable','off');
        while button == 1
            maptype = data.(data.maptypes{get(handle.maptype,'Value')});
            [xi,yi,button] = ginput(1);
            n = n+1;
            [dp1, i1]=min((maptype.fx - xi).^2 + (maptype.fy - yi).^2);
            [dp2, i2]=min((maptype.x  - xi).^2 + (maptype.y -  yi).^2);
            if (dp1 < dp2), i3 = i1; else i3 =i2;  end
            
            color = get(handle.pick_color,'BackgroundColor');
            if get(handle.pick_fill,'Value'), fill = color; else fill = 'none';end
            msize  = str2double(get(handle.pick_size,'String'));
            plot(handle.ax_real,maptype.x(i3), maptype.y(i3), 'o',...
                'Color',color,'MarkerSize',msize, 'MarkerFaceColor',fill);
            plot(handle.ax_freq,maptype.fx(i3),maptype.fy(i3),'o',...
                'Color',color,'MarkerSize',msize, 'MarkerFaceColor',fill);
            
            print_value(maptype.x(i3),maptype.y(i3),maptype.fx(i3),maptype.fy(i3));
        end
        set(hObj,'Enable','on');
    end
    function pick_color_callBack(hObj,event)
        h = uisetcolor;
        if (size(h,2) ~=1)
            set(hObj,'BackgroundColor',h);
        end
    end
    function maptype_callBack(hObj,event)
        if ~isfield(data.(data.maptypes{get(hObj,'Value')}),'dados')
            set(hObj,'Value',mod(get(hObj,'Value')+1,2));
            wait(errordlg('No data found for this option.'));
        else
            if get(handle.diffusion,'Value') && ~isfield(data.(data.maptypes{get(hObj,'Value')}),'xgrid')
                set(handle.diffusion,'Value',0);
            end
            plotData();
        end
    end
    function diffusion_callBack(hObj,event)
        if isfield(data.(data.maptypes{get(handle.maptype,'Value')}),'xgrid');
            plotData();
        else
            set(hObj,'Value',0);
            wait(errordlg('No Diffusion data in this file.'));
        end
    end
    function res_clear_callBack(hObj, event)
        set(findobj(get(handle.fig,'Children'),'Tag','Res'),'Value',0);
        curr_lim_x=get(handle.ax_freq,'Xlim');
        curr_lim_y=get(handle.ax_freq,'Ylim');
        plotData();
        set(handle.ax_freq,'Xlim',curr_lim_x);
        set(handle.ax_freq,'Ylim',curr_lim_y);
    end
    function res_plot_indiv_callBack(hObj, event)
        resx = str2double(get(handle.resx,'String'));
        resy = str2double(get(handle.resy,'String'));
        resO = str2double(get(handle.resO,'String'));
        plot_reson(handle.ax_freq,resx,resy,resO,...
            [get(handle.ax_freq,'Xlim'), get(handle.ax_freq,'Ylim')]);
    end
    function res_callBack(hObj, event)
        if ~get(hObj,'Value'), return; end
        
        order    = str2double(get(hObj,'String'));
        period   = str2double(get(handle.resPeri,'String'));
        ax       = handle.ax_freq;
        cur_lims = [get(ax,'Xlim'), get(ax,'Ylim')];

        [k, tab] =reson(order,period,cur_lims, ax);
        if (k ~=0)
            % Force the first coefficient to be positive
            ind = tab(:,1) < 0;
            tab(ind,:) = -tab(ind,:);
            % If the first coefficient is zero, force the second positive
            ind = (tab(:,2) < 0) & (tab(:,1) == 0);
            tab(ind,:)=-tab(ind,:);
            
            %Find the greatest commom divisor of the three coefficients
            greatCommDiv =gcd(gcd(tab(:,1),tab(:,2)),gcd(tab(:,2),tab(:,3)));
            tab = tab./repmat(greatCommDiv,1,3);
            tab = unique(tab,'rows');
            fprintf('\nOrder: %2d\n',order);
            fprintf('\t%02d * Qx  +  %02d * Qy  =  %03d\n',tab');
        end
    end
    function create_figure_callBack(hObj, event)
        a = figure('Position', [680 149 1019 831]);
        freq = copyobj(handle.ax_freq,a);
        set(freq,'Units','normalized','Position',[0.1 0.589 0.805 0.381],'FontSize',20);        
        real = copyobj(handle.ax_real,a);
        set(real,'Units','normalized','Position',[0.1 0.089 0.805 0.405],'FontSize',20);
        colorbar('peer',freq, [0.932 0.0862 0.023 0.879], 'FontSize',20);
    end

%% Useful Functions
    function loadData()
        path = uigetdir(data.path,'Em qual pasta estao os dados?');
        if ~path, return; end;
        maptypes = data.maptypes;
        found_any = false;
        for i=1:length(maptypes)
            maptype.fname = data.(maptypes{i}).fname;
            if exist(fullfile(path,maptype.fname),'file')
                found_any = true;
                data.path = path;
                [~, dados]=hdrload(fullfile(path,maptype.fname));
                
                %ordena os dados para pcolor funcionar corretamente.
                [~, ind] = sort(dados(:,2)); dados = dados(ind,:);
                [~, ind] = sort(dados(:,1)); dados = dados(ind,:);
                maptype.dados = dados;
                data.(maptypes{i}) = maptype;
            end
            clear maptype;
        end
        if ~found_any
            uiwait(errordlg('No input data found'));
            loadData();
            return;
        end
    end
    function prepareData()
        maptypes = data.maptypes;
        for i=1:length(maptypes)
            maptype = data.(maptypes{i});
            data.path = path;
            dados = maptype.dados;
            y = dados(:,2)*1e3;
            if i == 1, x = dados(:,1)*1e3; %% x in mm
            else       x = dados(:,1)*1e2; end %% energy in %
            
            intNux = str2double(get(handle.intTunex,'String'));
            intNuy = str2double(get(handle.intTuney,'String'));
            
            indx    = (dados(:,3) ~= 0);
            if get(handle.halfTunex,'Value'), fx = intNux + (1 - abs(dados(:,3)));
            else fx = intNux + dados(:,3);
            end
            if get(handle.halfTuney,'Value'), fy = intNuy + (1 - abs(dados(:,4)));
            else fy = intNuy + dados(:,4); end
            
            maptype.fx = fx(indx);    maptype.fy = fy(indx);
            maptype.x  = x(indx);     maptype.y  = y(indx);
            if size(dados,2) == 6;
                %%% Data for color printing
                ny = sum(x==x(1));    nx = size(x,1)/ny;
                dfx=dados(:,5);       dfy=dados(:,6);
                
                xgrid   = reshape(x,ny,nx);   ygrid   = reshape(y,ny,nx);
                fxgrid  = reshape(fx,ny,nx);  fygrid  = reshape(fy,ny,nx);
                dfxgrid = reshape(dfx,ny,nx); dfygrid = reshape(dfy,ny,nx);
                diffu   = log10(sqrt(dfxgrid.^2 + dfygrid.^2));
                %% saturation
                ind        = isinf(diffu);
                diffu(ind) = NaN;
                diffumax   = -2;   diffumin   = -10;
                diffu(diffu < diffumin) = diffumin; % very stable
                diffu(diffu > diffumax) = diffumax; %chaotic
                
                maptype.diffu  = diffu;
                maptype.fxgrid = fxgrid; maptype.fygrid = fygrid;
                maptype.xgrid  = xgrid;  maptype.ygrid  = ygrid;
            end
            data.(maptypes{i}) = maptype;
        end
    end
    function plotData()
        switch data.maptypes{get(handle.maptype,'Value')};
            case 'fmap', strx = 'x [mm]'; stry = 'y [mm]'; maptype = data.fmap;
            case 'fmapdp', strx = 'dp [%]'; stry = 'x [mm]'; maptype = data.fmapdp;
        end
        
        % Tune graphic
        ax = handle.ax_freq;
        cla(ax);
        if get(handle.diffusion,'Value'),
            mesh(ax, maptype.fxgrid,maptype.fygrid, maptype.diffu,'Marker','.',...
                'MarkerSize',5.0,'FaceColor','none','LineStyle','none','Tag','fspace');
            view(ax,2);
        else
            plot(ax,maptype.fx,maptype.fy,'kd','MarkerSize',5.0,'MarkerFaceColor','k','Tag','fspace');
        end
        grid(ax,'on'); hold(ax,'all');  box(ax,'on');
        xlabel(ax,'\nu_x');
        ylabel(ax,'\nu_z');
        axis(ax, [min(maptype.fx) max(maptype.fx) min(maptype.fy) max(maptype.fy)]);
        
        % Real space graphic
        ax = handle.ax_real;
        cla(ax);
        if get(handle.diffusion,'Value')
            pcolor(ax,maptype.xgrid,maptype.ygrid,maptype.diffu);
            shading(ax,'flat');
        else
            plot(ax,maptype.x,maptype.y,'kd','MarkerSize',5.0,'MarkerFaceColor','k','Tag','cspace');
        end
        xlabel(ax,strx); ylabel(ax,stry);
        axis(ax,[min(maptype.x) max(maptype.x) min(maptype.y) max(maptype.y)]);
        grid(ax,'on'); hold(ax,'all');  box(ax,'on');
    end
    function print_value(x,y,fx,fy)
        form = '% 8.4f';
        switch data.maptypes{get(handle.maptype,'Value')}
            case 'fmap', strx ='x  ='; stry ='y  =';
            case 'fmapdp', strx ='dp ='; stry ='x  =';
        end
        set(handle.pickx, 'String',sprintf([strx,   form],x));
        set(handle.picky, 'String',sprintf([stry,   form],y));
        set(handle.pickfx,'String',sprintf(['fx = ',form],fx));
        set(handle.pickfy,'String',sprintf(['fz = ',form],fy));
    end
end