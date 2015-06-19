function lnls_AmpFactors_make_figures(res)
% function res = lnls_AmpFactors_make_figures(res)
%
% Interface to visualize the magnets, bpms and girders amplification
% factors calculated with the other functions in the same folder as this
% file.
%
% INPUT: cell array of structures. Each structure must have the fields
% defined by the lnls_AmpFactors_example.m function.
%
%
% See also lnls_AmpFactors_example lnls_AmpFactors_magnets
% lnls_AmpFactors_bpms lnls_AmpFactors_girders
% lnls_AmpFactors_make_txtSummary


% If the input is not a structure, turn it into one.
if ~iscell(res)
    res = {res};
end

% The fact that we generate a distribution with cuttoff = 1, makes our rms
% values of the errors smaller by the following amount:
cutoff_corr = 0.54;


% Create a figure and an axes for plots.
figure('Position',[984, 200, 882, 636]);
hax = axes('Units','pixels', 'Position',[100.8, 86.2, 741.2, 408.8],'FontSize',16);


% Popup to control the the effect on the ring of the selected error
string = {'orbx','orby','corx','cory','coup','betx','bety'};
efct_conv = [1e-6, 1e-6 , 1e-6 , 1e-6,pi/180, 1e-2 , 1e-2];
efct_unit = {'\mum','\mum','\murad','\murad','%','%','%'};
uicontrol('Style','text','Position',[647 607 70 20],'String','Effect');
ctrl.efct = uicontrol('Style', 'popup','String', string,'Position', [647 587 70 20]);

% Popup to control the points where amplification factors were averaged
string = {'empty'};
uicontrol('Style','text','Position',[764 607 100 20],'String','Points Avgd.');
ctrl.wre2clc = uicontrol('Style', 'popup','String', string,'Position', [764 587 100 20]);

% Popup to control the orbit correction system employed
sys_names = fieldnames(res{1});
sys_names = sys_names(~strcmp('name',sys_names));
uicontrol('Style','text','Position',[167.3 607 70 20],'String','System');
ctrl.sys = uicontrol('Style', 'popup','String', sys_names,...
    'Position', [167.3 587 70 20],'Callback', {@fun_sys,res});

% Popup to control the Configuration Selected
string = getcellstruct(res,'name',1:length(res));
uicontrol('Style','text','Position',[20 607 120 20],'String','Configuration');
ctrl.config = uicontrol('Style', 'popup','String', string,...
    'Position', [20 587 120 20],'Callback', {@fun_config,res});

% Popup to control the type of error whose effect on the ring will be shown
string = {'misx','misy','exci','roll'};
err_conv=[ 1e-6 , 1e-6 , 1e-2 , 1e-6];
err_unit={ 'um' , 'um' ,  '%' ,'urad'};
uicontrol('Style','text','Position',[401 607 69 20],'String','Error Type');
ctrl.err = uicontrol('Style', 'popup', 'String', string,...
                'Position', [405 587 63 20], 'Callback',{@fun_err});
uicontrol('Style','text','Position',[478 607 55 20],'String','Value');
ctrl.errVal = uicontrol('Style','edit','String','1.0','Position',[480 588 50 20]);
uicontrol('Style','text','Position',[537 607 54 20],'String','Unit');
ctrl.errUnit = uicontrol('Style','text','String',err_unit{1},'Position',[537 588 55 20]);

% Checkbox to control the type of elements to which the errors were applied
sys_names = fieldnames(res{1});
res_names = fieldnames(res{1}.(sys_names{2}).results);
uicontrol('Style','text','Position',[284.7 607 80 20],'String','Elements');
ctrl.res = zeros(1,length(res_names));
for ii=1:length(res_names)
    ctrl.res(ii) = uicontrol('Style', 'checkbox','String', res_names{ii},'Min',0,...
        'Max',1, 'Position', [284.7 587-20*(ii-1) 80 20]);
end


uicontrol('Style', 'pushbutton', 'String', 'Plot',...
    'Position', [579 544 50 20],'Callback', {@plot_curve,res});

uicontrol('Style', 'pushbutton', 'String', 'Clear',...
    'Position', [651 544 50 20],'Callback', @clear_plot);

uicontrol('Style', 'pushbutton', 'String', 'Figure',...
    'Position', [723 544 50 20],'Callback', @create_figure);


ctrl.sumsqr = [];
sumsqr = 0;
uicontrol('Style','text','Position',[700 20 64 20],'String','Total:');
ctrl.sumsqrT = uicontrol('Style','text','Position',[764 20 90 20],'String','0.0');


%% CallBack definition
    function fun_err(hObj,event)
        set(ctrl.errUnit,'string',err_unit{get(ctrl.err,'Value')});
    end

    function fun_config(hObj,event, res)
        
        val_conf = get(hObj,'Value');
        sys_names = fieldnames(res{val_conf});
        sys_names = sys_names(~strcmp('name',sys_names));
        set(ctrl.sys,'String',sys_names);
        
        val_sys = get(ctrl.sys,'Value');str_sys = get(ctrl.sys,'String');
        str_sys = str_sys{val_sys};
        set(ctrl.wre2clc,'Value',1);
        set(ctrl.wre2clc,'String',res{val_conf}.(str_sys).where2calclabels);
        
        delete(ctrl.res(:));
        res_names = fieldnames(res{val_conf}.(str_sys).results);
        ctrl.res = zeros(1,length(res_names));
        for i=1:length(res_names)
            ctrl.res(i) = uicontrol('Style', 'checkbox','String', res_names{i},'Min',0,...
                'Max',1, 'Position', [284.7 587-20*(i-1) 80 20]);
        end
    end

    function fun_sys(hObj,event,res)
        val_sys = get(hObj,'Value');str_sys = get(ctrl.sys,'String');
        str_sys = str_sys{val_sys};
        val_conf = get(ctrl.config,'Value');
        set(ctrl.wre2clc,'Value',1);
        set(ctrl.wre2clc,'String',res{val_conf}.(str_sys).where2calclabels);
        
        delete(ctrl.res(:));
        res_names = fieldnames(res{val_conf}.(str_sys).results);
        ctrl.res = zeros(1,length(res_names));
        for i=1:length(res_names)
            ctrl.res(i) = uicontrol('Style', 'checkbox','String', res_names{i},'Min',0,...
                'Max',1, 'Position', [284.7 587-20*(i-1) 80 20]);
        end
        
    end

    function plot_curve(hObj,event,res)
        val_conf = get(ctrl.config,'Value');str_conf = get(ctrl.config,'String');
        str_conf = str_conf{val_conf};
        
        val_sys = get(ctrl.sys,'Value'); str_sys = get(ctrl.sys,'String');
        str_sys = str_sys{val_sys};
        
        str_ele = '';
        for i=1:length(ctrl.res)
            if get(ctrl.res(i),'Value')
                str_ele = [str_ele,'.',get(ctrl.res(i),'String')];
            end
        end
        str_ele = str_ele(2:end);
        
        val_err = get(ctrl.err,'Value');str_err = get(ctrl.err,'String');
        str_err = str_err{val_err};
        
        val_efct = get(ctrl.efct,'Value');str_efct = get(ctrl.efct,'String');
        str_efct = str_efct{val_efct};
        
        val_clc = get(ctrl.wre2clc,'Value');str_clc = get(ctrl.wre2clc,'String');
        str_clc = str_clc{val_clc};
        
        str_errVal = get(ctrl.errVal,'String'); val_errVal = str2double(str_errVal);
        
        chil = get(hax,'Children');
        j=0;
        for i=1:length(chil)
            dispname = get(chil(i),'DisplayName');
            if ~isempty(dispname)
                j = j+1;
            end
        end
        
        hold(hax,'all');
        color = {'b','r','g','c','m','y','k'};
        cor = color{mod(j,length(color))+1};
        
        erro = [];
        pos = [];
        mrk = {'','o','+','x','*','s','d','^','v','>','<','p','h'};
        res_vals = get(ctrl.res,'Value');
        if iscell(res_vals),res_vals = cell2mat(res_vals)';end
        ind = logical(res_vals);
        if ~any(ind)
            fprintf('Please, select at least one type of element to plot.\n');
            return;
        end
        for i=1:length(ind)
            string = get(ctrl.res(i),'String');
            r = res{val_conf}.(str_sys).results.(string);
            if ind(i) && isfield(r,str_err) && isfield(r.(str_err),str_efct)
                data = r.(str_err).(str_efct)*val_errVal*err_conv(val_err)/efct_conv(val_efct)*cutoff_corr;
                if any(size(data)==1)
                    erro = [erro, data];
                    pos  = [pos, r.pos];
                    plot(hax,r.pos,data,[cor, mrk{i}],'MarkerSize',8,'LineStyle','none');
                else
                    erro = [erro data(val_clc,:)];
                    pos  = [pos, r.pos];
                    plot(hax,r.pos,data(val_clc,:),[cor, mrk{i}],'MarkerSize',8,'LineStyle','none');
                end
            end
        end
        if isempty(erro)
            fprintf('None of the elements has this type of error.\n');
            return;
        end
        [pos I] = sort(pos);
        erro = erro(I);
        
        sumsqri = sqrt(res{val_conf}.(str_sys).symmetry*sum(erro.^2));
        sumsqr = sqrt(sumsqr^2 + sumsqri^2);
        set(ctrl.sumsqrT,'String',sprintf('%9.4g',sumsqr));
        sumsqri = sprintf('%9.4g',sumsqri);
        ctrl.sumsqr(j+1) = uicontrol('Style','text','Position',[100+75*j 20 70 20],'String',sumsqri);
        
        % color = {'b','r','g','m','c'};
        string = [str_conf, '.', str_sys,'.',str_ele,'.', str_err, '.', ...
                  str_efct, '.', str_clc,'.',str_errVal,' --> ', sumsqri];
        plot(hax, pos, erro,'Color',cor, 'DisplayName',string,'LineWidth',2);
        ylabel(hax,[upper(str_efct), ' [',efct_unit{val_efct},']'],'FontSize',16);
        
        if isempty(chil)
            maxy = max(erro);
            lnls_drawlattice(res{val_conf}.(str_sys).the_ring,res{val_conf}.(str_sys).symmetry,-maxy/20,true,maxy/21,true,false,hax);
            %     xlim(hax,[0,findspos(res{val_conf}.(str_sys).the_ring)/res{val_conf}.(str_sys).symmetry]);
            ylim(hax,[-maxy/10, maxy]*1.05);
            set(hax,'XGrid','on','YGrid','on');
        end
        old_ylim = get(hax,'ylim');
        if old_ylim/1.05 < max(erro)
            ylim([old_ylim(1), max(erro)*1.05]);
        end
    end

    function clear_plot(hObj,event)
        hold(hax,'off');
        delete(ctrl.sumsqr(:));
        ctrl.sumsqr = [];
        sumsqr = 0;
        cla(hax)
        
    end

    function create_figure(hObj,event)
        
        a = figure('Position', [405 203 1000 600]);
        ax = copyobj(hax,a);
        set(ax,'FontSize',16, 'Units', 'Normalized');
        set(ax,'YGrid','on','XGrid','on', 'Position',[0.118 0.142 0.836 0.775], 'box','on');
        xlabel(ax,'Pos [m]','FontSize',16);
        val = get(ctrl.efct,'Value');string = get(ctrl.efct,'String');
        string = upper(string{val});
        ylabel(ax,[string,  ' [',efct_unit{val},']'],'FontSize',16);
        chil = get(ax,'Children');
        pl = [];
        text = {};
        for i=1:length(chil)
            dispname = get(chil(i),'DisplayName');
            if ~isempty(dispname)
                pl = [pl chil(i)];
                text = [text, {dispname}];
            end
        end
        if ~isempty(pl)
            legend(pl,'show',text,'Location','Best');
        end
        title(ax, 'Title','FontSize',16);
    end
end
