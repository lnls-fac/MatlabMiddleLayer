function [zmin zmax xmin xmax] = get_fmaps_boundingbox

% function [zmin zmax xmin xmax] = get_fmaps_boundingbox
%
% Retorna vetor com bounding box de todos os mapas habilitados (strength ~= 0).
% O bounding box ? definido no sistema de coordenadas global.
%
% OUTPUT
%   [zmin zmax xmin xmax] (mm) : bounding box.
%
% History:
%   2011-11-25: vers?o revisada e comentada (Ximenes).

fmaps = getappdata(0, 'FIELD_MAPS');
zmin = Inf;
zmax = -Inf;
xmin = Inf;
xmax = -Inf;
for i=1:length(fmaps)
    if fmaps{i}.strength == 0, continue; end;
    % considera cada vertice do retangulo do mapa retangular, transforma para sist. coord. fixo e obtem coords maximas em x e em z.
    r1l = [min(fmaps{i}.data.x); 0; min(fmaps{i}.data.z)]; % ponto inferior-esquerdo
    r2l = [min(fmaps{i}.data.x); 0; max(fmaps{i}.data.z)]; % ponto inferior-direito
    r3l = [max(fmaps{i}.data.x); 0; max(fmaps{i}.data.z)]; % ponto superior-direito
    r4l = [max(fmaps{i}.data.x); 0; max(fmaps{i}.data.z)]; % ponto superior-esquerdo
    Ry = fmaps{i}.Ry; T  = fmaps{i}.T;
    r1  = transf_coord_from_local_to_global(r1l, Ry, T);
    r2  = transf_coord_from_local_to_global(r2l, Ry, T);
    r3  = transf_coord_from_local_to_global(r3l, Ry, T);
    r4  = transf_coord_from_local_to_global(r4l, Ry, T);
    zmin = min([zmin r1(3) r2(3) r3(3) r4(3)]);
    zmax = max([zmax r1(3) r2(3) r3(3) r4(3)]);
    xmin = min([xmin r1(1) r2(1) r3(1) r4(1)]);
    xmax = max([xmax r1(1) r2(1) r3(1) r4(1)]);
end

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

