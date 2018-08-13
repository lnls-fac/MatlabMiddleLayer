function res = treat_raw_results(opt)
    if ~exist(opt.folder, 'dir')
        error(['Folder ', opt.folder, 'do not exist in current directory']);
    end
    fol = [opt.folder,'/'];
    
    res = struct();

    Gen = regexp(ls(fol, '-rt'), 'G[0-9]{3}', 'match');
    Gen = sort(Gen);
    for i=1:length(Gen)
        st = Gen{i};
        res.(st) = load([fol, st,'.mat']);
    end
    
    % remove bad results
    Ncut = opt.Ncut;
    Gen = fieldnames(res);
    for i=1:length(Gen)
        G = res.(Gen{i});
        id_keep = multiobjective.save_best_and_kill_worst(G.res, Ncut);
        G.res = G.res(:,id_keep);
        G.G = G.G(:,id_keep);
        res.(Gen{i}) = G;
    end    
    
    % remove duplicated results
    for i=1:length(Gen)
        G = res.(Gen{i}).G;
        [~, I] = unique(G', 'rows', 'stable');
        res.(Gen{i}).G = G(:,I);
        res.(Gen{i}).res = res.(Gen{i}).res(:,I);
        for ii=i+1:length(Gen)
            G2 = res.(Gen{ii}).G;
            ind = [];
            for j=1:size(G,2)
                ind = [ind, find(all(G(:,j) == G2))];
            end
            res.(Gen{ii}).G(:, ind) = [];
            res.(Gen{ii}).res(:,ind) = [];
        end
    end
    % transform indices to fields
    for i=1:length(Gen)
        G = res.(Gen{i}).G;
        if isempty(G)
            res = rmfield(res, Gen{i});
            continue;
        end
        for j=1:size(G,2)
            res.indcs.(Gen{i}).(sprintf('I%03d',j)) = G(:,j);
        end
    end
end