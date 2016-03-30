function [x,all_val] = svd_optimizer(x0, params)

if exist('stop','file'), delete 'stop'; end

if params.plot, 
    f =  figure('OuterPosition',[1,480,1920,600]);
    f2 =  figure('OuterPosition',[1,1,1300,480]);
    ax = axes('Parent',f,'Position',[0.05,0.1,0.9,0.85]);
    ay = axes('Parent',f2,'Position',[0.05,0.1,0.9,0.85]);
    drawnow;
end

Jac = calc_jacobian(x0, params.calc_residue);
all_val(:,1) = x0;
improved   = false;
x = x0;
mkrs = {'o','s','d','p','h'};
msz = 10;
for ii=1:length(params.svs_lst)
    sv = params.svs_lst(ii);
    mkr = mkrs{1+mod(ii-1,length(mkrs))};
    [res, obj,names] = params.calc_residue(x);
    if params.plot && sv == params.svs_lst(1)
        pl = plot(ax,res,'Marker','*','MarkerSize',4,'LineStyle','none','color','b');
        hold(ax,'all'); grid(ax,'on'); box(ax,'on');
        xlim(ax,[1,length(res)]); drawnow;
        set(ax,'XTick',1:length(res),'XTickLabel',names);
        
        pl2 = plot(ay,x,'Marker','*','MarkerSize',4,'LineStyle','none','color','b');
        hold(ay,'all'); grid(ay,'on'); box(ay,'on');
        xlim(ay,[1,length(x)]); drawnow;
    end
    old_obj    = obj*2;
    nr_iters   = 0;
    factor     = params.max_frac;
    fprintf('nr_svs: %2d\n',sv);
    fprintf('iter: %03d, residue: %8.3g, maxdk: %7.4g\n',nr_iters,obj,0);
    condition_2_continue = true;
    while condition_2_continue
        nr_iters = nr_iters + 1;
        iS = 1./Jac.S; iS(sv+1:end) = 0;
        dx = - factor*(Jac.V * diag(iS) * Jac.U') * res;
        new_x = x + dx;
        new_x = sign(new_x) .* min(abs(new_x),params.max_x);
        [new_res, new_obj] = params.calc_residue(new_x);
        if params.plot, set(pl,'YData',new_res); set(pl2,'YData',new_x); drawnow; end
        if (new_obj < obj)
            if params.plot
                cor = nr_iters/params.nr_iters*[0,0,1];
                plot(ax,new_res,'Marker',mkr,'MarkerSize',msz,'LineStyle','none',...
                    'Color',cor);
                ylim(ax,[min(new_res),max(new_res)]*1.2);
                plot(ay,new_x,'Marker',mkr,'MarkerSize',msz,'LineStyle','none',...
                    'Color',cor);
                ylim(ay,[min(new_x),max(new_x)]*1.2);
                drawnow;
            end
            res = new_res;
            old_obj = obj;
            obj = new_obj;
            all_val(:,end+1) = new_x;
            x = new_x;
            improved = true;
            factor = min([factor * 2, params.max_frac]);
            fprintf('iter: %03d, residue: %8.3g, maxdk: %7.4g\n',nr_iters,obj,max(abs(dx)));
            if params.update_Jac, Jac = calc_jacobian(new_x, params.calc_residue,false); end
        else
            factor = factor / 2;
        end
        if ((old_obj-obj)/old_obj < 0.001) || (factor < 0.001)
            if ~params.update_Jac && improved
                 Jac = calc_jacobian(new_x, params.calc_residue, true);
                 improved = false;
            else
                fprintf('Terminated due to lack of improvement\n');
                condition_2_continue = false;
            end
        end
        if (obj < params.tol);
            fprintf('Convergence achieved\n');
            condition_2_continue = false;
        end
        if (nr_iters >= params.nr_iters);
            fprintf('Maximum iteration number achieved\n');
            condition_2_continue = false;
        end
        if exist('stop','file'), return; end
    end
end
fprintf('\n')
