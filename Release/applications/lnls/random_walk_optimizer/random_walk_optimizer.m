function [x, all_val] = random_walk_optimizer(x0, params)

if exist('stop','file'), delete 'stop'; end

if params.plot, 
    f =  figure('OuterPosition',[1,480,1920,600]);
    f2 =  figure('OuterPosition',[1,1,1300,480]);
    ax = axes('Parent',f,'Position',[0.05,0.1,0.9,0.85]);
    ay = axes('Parent',f2,'Position',[0.05,0.1,0.9,0.85]);
end
    
[res, obj,names] = params.calc_residue(x0);

if params.plot
    pl = plot(ax,res,'Marker','*','MarkerSize',4,'LineStyle','none','color','b');
    hold(ax,'all'); grid(ax,'on'); box(ax,'on');
    xlim(ax,[1,length(res)]); drawnow;
    set(ax,'XTick',1:length(res),'XTickLabel',names);
    
    pl2 = plot(ay,x0,'Marker','*','MarkerSize',4,'LineStyle','none','color','b');
    hold(ay,'all'); grid(ay,'on'); box(ay,'on');
    xlim(ay,[1,length(x0)]); drawnow;
end
fprintf('iter: %03d, residue: %8.3g, maxdk: %7.4g\n',0,obj,0)
error = params.error;
num_not_impr = 0;
all_val(:,1) = x0;
x = x0;
for ii=1:params.nr_iters
    num_not_impr = num_not_impr + 1;
    dx = (rand(length(x),1)-0.5)*error;
    new_x = x + dx;
    [new_res, new_obj] = params.calc_residue(new_x);
    if params.plot, set(pl,'YData',new_res); set(pl2,'YData',new_x); drawnow; end
    if (new_obj < obj)
        num_not_impr = 0;
        obj = new_obj;
        all_val(:,end+1) = new_x;
        if params.plot
            cor = nr_iters/params.nr_iters*[0,0,1];
            plot(ax,new_res,'Marker','o','MarkerSize',10,'LineStyle','none',...
                'Color',cor);
            ylim(ax,[min(new_res),max(new_res)]*1.2);
            plot(ay,new_x,'Marker','o','MarkerSize',10,'LineStyle','none',...
                'Color',cor);
            ylim(ay,[min(new_x),max(new_x)]*1.2);
            drawnow;
        end
        x = new_x;
        fprintf('iter: %03d, residue: %8.3g, maxdk: %7.3g\n',ii,obj,max(abs(dx)));
    end
    if num_not_impr >= params.num_not_impr
        error = error*params.error_factor;
        fprintf('error decreased: %8.3g \n', error);
        num_not_impr = 0;
    end
    if (obj < params.tol);
        fprintf('Convergence achieved\n');
        break;
    end
    drawnow;
    if exist('stop','file'), return; end
end
fprintf('\n')
