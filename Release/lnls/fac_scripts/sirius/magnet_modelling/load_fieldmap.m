function load_fieldmap(file_name, type)

fmaps{1}.fname = file_name;
fmaps{1}.data_index = 1;
[fmaps{1}.data fmaps{1}.magnet] = read_fieldmap_from_file(file_name);

% define posicionamento default no sistema de coordenadas
fmaps{1}.strength = 1;
fmaps{1}.shift_z  = 0;
fmaps{1}.shift_x  = 0;
fmaps{1}.angle_y  = 0;
fmaps{1}.T        = [0;0;0];
fmaps{1}.Ry       = [1 0 0; 0 1 0; 0 0 1];

setappdata(0, 'FIELD_MAPS', fmaps);

% for the case of combined correctors
if exist('type','var') && any(strcmpi(type, {'VCM','HCM'}))
    modify_fieldmap_for_correctors(type);
    fmaps = getappdata(0, 'FIELD_MAPS');
elseif exist('type','var') && strcmpi(type, 'invert')
    fmaps{1}.data.bx = -fmaps{1}.data.bx; fmaps{1}.data.by = -fmaps{1}.data.by; fmaps{1}.data.bz = -fmaps{1}.data.bz;
    setappdata(0, 'FIELD_MAPS', fmaps);
end

% plot field
data = fmaps{1}.data;
x = data.x;
z = data.z;
[~,idx_z0] = min(abs(z));

if ~exist('type','var') || ~strcmpi(type, 'suppress_plot')
    figure; plot(1000*x, data.by(idx_z0,:)); xlabel('Pos X [mm]'); ylabel('By [T]'); title('Transverse Rolloff of By');
    set(gcf, 'Name','transverse_rolloff_of_by')
    [~,idx_x0] = min(abs(x));
    figure; plot(1000*z, data.by(:,idx_x0)); xlabel('Pos Z [mm]'); ylabel('By [T]'); title('Longitudinal Rolloff of By');
    set(gcf, 'Name','longitudinal_rolloff_of_by')

    figure; plot(1000*x, data.bx(idx_z0,:)); xlabel('Pos X [mm]'); ylabel('Bx [T]'); title('Transverse Rolloff of Bx');
    set(gcf, 'Name','transverse_rolloff_of_bx')
    [~,idx_x0] = min(abs(x));
    figure; plot(1000*z, data.bx(:,idx_x0)); xlabel('Pos Z [mm]'); ylabel('Bx [T]'); title('Longitudinal Rolloff of Bx');
    set(gcf, 'Name','longitudinal_rolloff_of_bx')
    
    % prints by field roll-off
    pos = 10; % [mm]
    [~,idx] = min(abs(x - pos/1000));
    by0 = data.by(idx_z0, idx_x0);
    by  = data.by(idx_z0, idx);
    rolloff = 100 * (by - by0)/abs(by0);
    fprintf('by(x) roll-off @ %f mm: %f %%\n', pos, rolloff);

end
    



function [fmap magnet] = read_fieldmap_from_file(file_name)
%
% reads fieldmap and builds data structure for field interpolation.
%
% History:
%
% 2013-05-16    new version - units: T and m.
% 2011-02-13    init version (ximenes)

if ~exist('file_name','var') || isempty(file_name) || ~exist(file_name, 'file')
    [FileName,PathName,FilterIndex] = uigetfile('*.txt','select file with fieldmap');
    if isnumeric(FileName)
        fmap = []; magnet = [];
        return;
    end
    file_name = fullfile(PathName,FileName);
end

fp = fopen(file_name);
data = fgetl(fp); magnet.label         = strtrim(strrep(strrep(data, 'Nome_do_Mapa:', ''), '\t', ''));
data = fgetl(fp); magnet.timestamp     = strtrim(strrep(strrep(data, 'Data_Hora:', ''), '\t', ''));
data = fgetl(fp); magnet.fname         = strtrim(strrep(strrep(data, 'Nome_do_Arquivo:', ''), '\t', ''));
data = fgetl(fp); magnet.nr_submagnets = str2double(strtrim(strrep(strrep(data, 'Numero_de_Imas:', ''), '\t', '')));
data = fgetl(fp);
for i=1:magnet.nr_submagnets
    data = fgetl(fp); submagnet.label   = strtrim(strrep(strrep(data, 'Nome_do_Ima:', ''), '\t', ''));
    % tinha um problema aqui, originalmente o script procurava os campos
    % Gap e Gap_Controle, mas o mapa de campo possui o campo Bore Diameter
    % para quadrupolos. resolvi dessa maneira, mas precisamos discutir se
    % não há modo melhor de fazer isso.
    % Voltei a como era antigamente (em acordo com a Priscila - Ximenes
    % 2014-03-26
%     if strncmpi(magnet.label,'dipolo',6)
%         data = fgetl(fp); submagnet.gap     = 0.001 * str2double(strtrim(strrep(strrep(data, 'Gap[mm]:', ''), '\t', ''))); 
%         data = fgetl(fp); submagnet.cgap    = 0.001 * str2double(strtrim(strrep(strrep(data, 'Gap_Controle[mm]:', ''), '\t', ''))); 
%     else
%         data = fgetl(fp); submagnet.bore     = 0.001 * str2double(strtrim(strrep(strrep(data, 'Bore Diameter[mm]:', ''), '\t', '')));
%     end
    if strncmpi(magnet.label,'dipolo',6)
        data = fgetl(fp); submagnet.gap     = 0.001 * str2double(strtrim(strrep(strrep(data, 'Gap[mm]:', ''), '\t', ''))); 
        data = fgetl(fp); submagnet.cgap    = 0.001 * str2double(strtrim(strrep(strrep(data, 'Gap_Controle[mm]:', ''), '\t', ''))); 
    else
        data = fgetl(fp); submagnet.bore    = 0.001 * str2double(strtrim(strrep(strrep(data, 'Gap[mm]:', ''), '\t', ''))); 
        data = fgetl(fp); submagnet.cgap    = 0.001 * str2double(strtrim(strrep(strrep(data, 'Gap_Controle[mm]:', ''), '\t', ''))); 
    end
    data = fgetl(fp); submagnet.length  = 0.001 * str2double(strtrim(strrep(strrep(data, 'Comprimento[mm]:', ''), '\t', ''))); 
    data = fgetl(fp); submagnet.current = str2double(strtrim(strrep(strrep(data, 'Corrente[A]:', ''), '\t', '')));
    data = fgetl(fp); submagnet.shift_z = 0.001 * str2double(strtrim(strrep(strrep(data, 'Centro_Posicao_z[mm]:', ''), '\t', ''))); 
    data = fgetl(fp); submagnet.shift_x = 0.001 * str2double(strtrim(strrep(strrep(data, 'Centro_Posicao_x[mm]:', ''), '\t', ''))); 
    data = fgetl(fp); submagnet.angle_y = (pi/180) * str2double(strtrim(strrep(strrep(data, 'Rotacao[graus]:', ''), '\t', '')));
    data = fgetl(fp);
    magnet.submagnets(i) = submagnet;
end
data = fgetl(fp);
data = fgetl(fp);
data = fscanf(fp, '%f\t\t%f\t\t%f\t\t%f %f %f');
fclose(fp);
data = reshape(data,6,[]);
data([1 2 3],:) = data([1 2 3],:) / 1000;

if magnet.nr_submagnets == 1
    magnet.length = magnet.submagnets(1).length;
    % também tive que alterar aqui. Fernando-2014-03-05
    if strncmpi(magnet.label,'dipolo',6)
        magnet.gap    = magnet.submagnets(1).gap;
    else
        magnet.bore   = magnet.submagnets(1).bore;
    end
end
    
% 1. gera vetores x, y e z com posi??es dos pontos no grid 3D do mapa
% 2. gera tensores gx, gy e gz com posi??e destes pontos para serem
%    usados nas fun??es de interpola??o.
% 3. gera tabelas bx, by e bz 3D para interpola??o.
r.npts   = size(data,2);
npts_x = length(unique(data(1,:)));
r.x = data(1,1:npts_x);
r.y = unique(data(2,:));
r.z = data(3,1:npts_x:r.npts);
r.bx = reshape(data(4,:), [length(r.x) length(r.z)]);
r.by = reshape(data(5,:), [length(r.x) length(r.z)]);
r.bz = reshape(data(6,:), [length(r.x) length(r.z)]);

% sort in X
[r.x idx] = sort(r.x);
r.bx = r.bx(idx,:);
r.by = r.by(idx,:);
r.bz = r.bz(idx,:);
% sort in Z
[r.z idx] = sort(r.z);
r.bx = r.bx(:,idx);
r.by = r.by(:,idx);
r.bz = r.bz(:,idx);

[r.gx, r.gz] = meshgrid(r.x, r.z);

% b(i,j) = B(x_j,z_i)
% cada componente de campo mapeado ? representada por uma matriz cujas
% colunas fornecem o campo mapeado longitudinalmente (z) para uma determinada
% coordenada transversal (x).
r.bx = r.bx';
r.by = r.by';
r.bz = r.bz';

fmap = r;


function modify_fieldmap_for_correctors(type)

fmaps = getappdata(0, 'FIELD_MAPS');
fprintf('!!! COMBINED CORRECTORS !!!\n');
if strcmpi(type, 'VCM')
    fmaps{1}.data.by = fmaps{1}.data.bx;    
end
fmaps{1}.data.bx = 0 * fmaps{1}.data.bx;
setappdata(0, 'FIELD_MAPS', fmaps);
