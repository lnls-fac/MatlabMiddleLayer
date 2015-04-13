function field = interpolate_field(r)
% function field = interpolate_field(r)
%
% returns interpolated field at point 'r'
%
% INPUT
%   r: point in space where field is to be interpolated. units: [m]
%
% OUTPUT
%   field: interpolated field. units: [T]
%
% History:
%   2013-05-17: new version
%   2011-11-25: versao revisada e comentada (Ximenes).


% recupera dados da ?rea appdata com info sobre campo e feixe
fmaps  = getappdata(0, 'FIELD_MAPS');

% loop sobre todos mapas de campo na mem?ria
field = zeros(3,1);
for i=1:length(fmaps)
    
    fmap = fmaps{i};
    
    % parametros de posicionamento e escala do mapa de campo
    str   = fmap.strength; if (str == 0), continue; end;
    Ry = fmap.Ry; T = fmap.T; %%% parameters that specifi
    
    % checks limits of fieldmap
    data  = fmaps{fmap.data_index}.data;
    rl = transf_coord_from_global_to_local(r, Ry, T); % transforma posicao r do sistema fixo para o sistema do mapa em particular
    if (rl(3) < min(data.z)) || (rl(3) > max(data.z))
        continue; % ponto fora do mapa: considera campo nulo.
    end
    if (rl(1) < min(data.x)) || (rl(1) > max(data.x))
        fprintf('interpolating out of fieldmap: local r = (%f, %f, %f)\n', rl);
        continue; % ponto fora do mapa: considera campo nulo.
    end
    
    % interpola campo (no sistema de coord. local do mapa
    bl([1 2 3],1) = 0;
    x = rl(1);
    y = rl(2);
    z = rl(3);
    
%      bl(2,1) = (22.6956*x.^2 + 1.9024*x - 1.09848)./(1+exp((z + x^2 -1.150/2)/0.001));
%      bl(1,1) = 0; bl(3,1) = 0;
    for k=1:length(data.fderivs)
        if (k == 1), factor = 1; else factor = y^(k-1)/(k-1); end;
        bl(1,1) = bl(1,1) + str * interp2(data.gx, data.gz, data.fderivs{k}.bx, x, z, '*linear') * factor;
        bl(2,1) = bl(2,1) + str * interp2(data.gx, data.gz, data.fderivs{k}.by, x, z, '*linear') * factor;
        bl(3,1) = bl(3,1) + str * interp2(data.gx, data.gz, data.fderivs{k}.bz, x, z, '*linear') * factor;
    end
    
%     % interpola campo (no sistema de coord. local do mapa
%     bl(1,1) = str * interp2(data.gx, data.gz, data.bx, rl(1), rl(3), '*linear');
%     bl(2,1) = str * interp2(data.gx, data.gz, data.by, rl(1), rl(3), '*linear');
%     bl(3,1) = str * interp2(data.gx, data.gz, data.bz, rl(1), rl(3), '*linear');
%     
    
    
    b = transf_coord_from_local_to_global(bl, Ry, 0*T); % transforma vetor campo de volta para o sistema de coord. fixo
    if any(isnan(b))
        b = [0;0;0]; % caso aconteca alguma extrapolacao zera contribuicao (isto nao devera ser executado devido aos condicionais acima...)
    end
    
    field = field + b; % soma contribuicao do mapa ao campo total no ponto
end



function v_local = transf_coord_from_global_to_local(v_global, Ry, T)

% function v_local = transf_coord_from_global_to_local(v_global, Ry, T)
%
% Transforma vetor do sistema de coordenadas global para o local do mapa definido
% por um vetor de transla??o e uma matriz de rota??o tridimensional.
%
% INPUT
%   v_global : vetor no sistema de coordenadas global.
%   Ry       : matriz de rota??o 3D
%   T        : vetor de transla??o 3D
%
% OUTPUT
%   v_local  : vetor original expresso no sistema de coordenadas local do mapa de campo
%
% Obs:
%   Esta fun??o transforma vetores gerais (de posi??o, campo, etc). 
%   Os tr?s vetores: v_local, v_global e T t?m naturalmente a mesma dimens?o.
%
% History:
%   2011-11-25: vers?o revisada e comentada (Ximenes).

v_local = Ry * (v_global - T);

function v_global = transf_coord_from_local_to_global(v_local, Ry, T)

% function v_global = transf_coord_from_local_to_global(v_local, Ry, T)
%
% Transforma vetor do sistema de coordenadas local do mapa definido
% por um vetor de transla??o e uma matriz de rota??o tridimensional
% para o sistema de coordenadas global (fixo).
%
% INPUT
%   v_local  : vetor no sistema de coordenadas local.
%   Ry       : matriz de rota??o 3D
%   T        : vetor de transla??o 3D
%
% OUTPUT
%   v_global  : vetor original expresso no sistema de coordenadas global
%
% Obs:
%   Esta fun??o transforma vetores gerais (de posi??o, campo, etc). 
%   Os tr?s vetores: v_local, v_global e T t?m naturalmente a mesma dimens?o.
%
% History:
%   2011-11-25: vers?o revisada e comentada (Ximenes).

v_global = Ry \ v_local + T;


