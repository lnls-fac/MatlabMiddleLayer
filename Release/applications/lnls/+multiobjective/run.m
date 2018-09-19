function run(opt)
    if ~exist(opt.folder, 'dir')
        mkdir(opt.folder);
    end
    fol = [opt.folder,'/'];
    cont = opt.continue;
    arb_ini = opt.arbitrary_initial;
    
    setappdata(0, 'stop_now', 0);
    Nid = opt.Nid;
    Ncut = opt.Ncut;
    NG = opt.NG;
    Nobj = opt.Nobj;
    Strt = 2;
    
    if ~isfield(opt, 'objective_max_values')
        opt.objective_max_values = inf*ones(Nobj, 1);
    end
    obj_max = opt.objective_max_values;
    
    if cont
        Gen = regexp(ls(fol, '-rt'), 'G[0-9]{3}', 'match');
        Gen = sort(Gen);
        cont = ~isempty(Gen);
        r_ini = load([fol,Gen{end}, '.mat']);
        G = r_ini.G;
        res = r_ini.res;
        Strt = str2double(Gen{end}(2:end)) + 1;
    end
    
    if ~cont
        config0 = multiobjective.remove_repeated(opt.config0);
        sz = size(config0,2);
        if sz < Nid
            Gn = zeros(size(config0,1), Nid);
            Gn(:, 1:sz) = config0;
            for i=sz+1:Nid
                ind = config0(:, randi(sz));
                if arb_ini
                    Gn(:,i) = opt.random_change(ind, opt.objective_data);
                else
                    Gn(:,i) = opt.small_change(ind, opt.objective_data);
                end
            end
        else
            Gn = config0;
        end
        
        Gn = multiobjective.remove_repeated(Gn);
        resn = zeros(Nobj, size(Gn,2));
        for i=1:size(Gn,2)
            resn(:,i) = opt.objective_fun(Gn(:,i), opt.objective_data);
        end
        id_keep = multiobjective.save_best_and_kill_worst(resn, Ncut, obj_max);
        G = Gn(:,id_keep);
        res = resn(:,id_keep);
        save([fol,'G001.mat'], 'G', 'res');
        opt.print_info('G001', G, res);
    end
       
    for i=Strt:NG
        sz = size(G,2);
        Gn = zeros(size(G,1), sz + Nid);
        Gn(:,1:sz) = G;
        for ii=1:Nid
            ind = G(:, randi(sz));
            Gn(:, sz+ii) = opt.small_change(ind, opt.objective_data);
        end
        Gn = multiobjective.remove_repeated(Gn);
        resn = zeros(Nobj, size(Gn,2));
        resn(:,1:sz) = res;
        for ii=sz+1:size(Gn,2)
            resn(:, ii) = opt.objective_fun(Gn(:, ii), opt.objective_data);
        end
        id_keep = multiobjective.save_best_and_kill_worst(resn, Ncut, obj_max);
        G = Gn(:,id_keep);
        res = resn(:,id_keep);
        st = sprintf('G%03d', i);
        save([fol, st, '.mat'], 'G', 'res');
        opt.print_info(st, G, res);
        if getappdata(0, 'stop_now')
            fprintf('Interruped by user at generation %03d\n', i);
            break;
        end
    end
end