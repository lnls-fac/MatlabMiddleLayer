function tracy3_dynamic_aperture1(varargin)

fmapdpFlag = true;
default_dir = lnls_get_root_folder();
for i=1:length(varargin)
    if (ischar(varargin{i}) && strcmpi(varargin{i}, 'local_dir'))
        default_dir = pwd();
    else
        fmapdpFlag = varargin{i};
    end
end


% selects data folder
default_dir = fullfile(default_dir, 'data', 'sirius_tracy');
pathname = uigetdir(default_dir,'Em qual pasta estao os dados?');
if (pathname == 0);
    return
end



% gets number of random machines (= number of rms folders)
[~, result] = system(['ls ' pathname '| grep rms | wc -l']);
n_pastas = str2double(result);

% % creates figures or ploting dynapts
% f=figure;
% fa = axes('Parent',f,'YGrid','on','XGrid','on'); box(fa,'on'); hold(fa,'all');
% xlabel('x [mm]','FontSize',20); ylabel('z [mm]','FontSize',20);
% if(fmapdpFlag)
%     fdp=figure;
%     fdpa = axes('Parent',fdp,'YGrid','on','XGrid','on'); box(fdpa,'on'); hold(fdpa,'all');
%     xlabel('dp [%]','FontSize',20); ylabel('x [mm]','FontSize',20);
% end


% loops over random machine, loading and plotting data
fx_fmap = [ ];fy_fmap = [ ];
fx_fmapdp = [ ]; fy_fmapdp = [ ];
for i=1:n_pastas
    
    % -- FMAP --
    full_name = fullfile(pathname, ['rms', num2str(i, '%02i')], 'fmap.out');
 
%     try
%         dynapt    = tracy3_load_fmap_data(full_name);
%     catch
%         disp('fmap nao carregou');
%         continue;
%     end
%     
%   
%     
%     plot(fa,1000*dynapt(:,1),1000*dynapt(:,2));
%     title(fa,{full_name},'Interpreter','none','FontSize',30); drawnow;
%     
%     if (fmapdpFlag)
%         % -- FMAPDP --
%         full_name = fullfile(pathname, ['rms', num2str(i, '%02i')], 'fmapdp.out');
%         
%         try
%             dynapt    = tracy3_load_fmapdp_data(full_name);
%         catch
%             disp('fmapdp nao carregou');
%             continue;
%         end
%         plot(fdpa,100*dynapt(:,1),1000*dynapt(:,2));
%         title(fdpa,{full_name},'Interpreter','none','FontSize',30); drawnow;
%     end
    

    try
        [~, fmap] = hdrload(full_name);
    catch
        disp('fmap nao carregou');
    end
    
    % Agora, eu tenho que encontrar a DA
    %primeiro eu identifico quantos x e y existem
    npx = length(unique(fmap(:,1)));
    npy = size(fmap,1)/npx;
    %agora eu pego a coluna da frequencia x
    x = fmap(:,1);
    y = fmap(:,2);
    fx = fmap(:,3);
    fy = fmap(:,4);
    % e a redimensiono para que todos os valores calculados para x iguais
    %fiquem na mesma coluna:
    x = reshape(x,npy,npx);
    y = reshape(y,npy,npx);
    fx = reshape(fx,npy,npx);
    fy = reshape(fy,npy,npx);
    % vejo quais pontos sobreviveram.
    ind = fx ~= 0;
    if ~ exist('idx_fmap','var')
        idx_fmap = ind;
    else
        idx_fmap = idx_fmap + ind;
    end
    
    fx_fmap = [fx_fmap; fx(ind)];
    fy_fmap = [fy_fmap; fy(ind)];
    
    if (fmapdpFlag)
        full_name = fullfile(pathname, ['rms', num2str(i, '%02i')], 'fmapdp.out');
        try
            [~, fmapdp] = hdrload(full_name);
        catch
            disp('fmapdp nao carregou');
        end
        
        %primeiro eu identifico quantos x e y existem
        npe = length(unique(fmapdp(:,1)));
        npx = size(fmapdp,1)/npe;
        %agora eu pego a coluna da frequencia x
        en = fmapdp(:,1);
        xe = fmapdp(:,2);
        fxe = fmapdp(:,3);
        fye = fmapdp(:,4);
        % e a redimensiono para que todos os valores calculados para x iguais
        %fiquem na mesma coluna:
        en = reshape(en,npx,npe);
        xe = reshape(xe,npx,npe);
        fxe = reshape(fxe,npx,npe);
        fye = reshape(fye,npx,npe);
        % e vejo qual o primeiro valor nulo dessa frequencia, para identificar
        % a borda da DA
        inddp = fxe ~= 0;
        if ~ exist('idx_fmapdp','var')
            idx_fmapdp = inddp;
        else
            idx_fmapdp = idx_fmapdp + inddp;
        end
        
        fx_fmapdp = [fx_fmapdp; fxe(inddp)];
        fy_fmapdp = [fy_fmapdp; fye(inddp)];
        
    end
end
figure;
pcolor(1000*x, 1000*y, idx_fmap);
% contour(x, y, idx_fmap);
colormap('Hot'); shading('faceted');
xlabel('X [mm]'); ylabel('Y [mm]');
% hold on; 
figure;
pcolor(100*en, 1000*xe, idx_fmapdp);
colormap('Hot'); shading('faceted');
xlabel('\delta\epsilon [%]'); ylabel('X [mm]');

figure; plot(fx_fmap,fy_fmap,'.');
figure; plot(fx_fmapdp,fy_fmapdp,'.');


% view(2); grid on;
