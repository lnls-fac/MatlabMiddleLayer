function res = treat_raw_results(opt, genstoload)
    if ~exist(opt.folder, 'dir')
        error(['Folder ', opt.folder, 'do not exist in current directory']);
    end
    fol = [opt.folder,'/'];
    
   
    res = struct();
    
    if ~exist('genstoload', 'var')
        Gen = regexp(ls(fol, '-rt'), 'G[0-9]{3}', 'match');
        Gen = sort(Gen);
        for i=1:length(Gen)
            st = Gen{i};
            res.(st) = load([fol, st,'.mat']);
        end
    else
        for i=genstoload
            st = sprintf('G%03d', i);
            if exist([fol, st, '.mat'], 'file')
                res.(st) = load([fol, st, '.mat']);
            end
        end
    end
    
    if isempty(res)
        error('No data loaded.');
    end
    
    % remove bad results
    Ncut = opt.Ncut;
    Gen = fieldnames(res);
    Gs = [];
    ress = [];
    lens = zeros(1, length(Gen));
    for i=1:length(Gen)
        G = res.(Gen{i});
        id_keep = multiobjective.save_best_and_kill_worst(G.res, Ncut);
        G.res = G.res(:,id_keep);
        G.G = G.G(:,id_keep);
        res.(Gen{i}) = G;
        Gs = [Gs, G.G];
        ress = [ress, G.res];
        lens(i) = length(id_keep);
    end    
    
    % remove duplicated results
    lens = [1, cumsum(lens)];
    [~, I] = unique(Gs', 'rows', 'stable');
    for i=1:length(Gen)
        bo = I>=lens(i) & I<=lens(i+1);
        if isempty(bo)
            continue;
        end
        res.(Gen{i}).G = Gs(:, I(bo));
        res.(Gen{i}).res = ress(:, I(bo));
    end
end