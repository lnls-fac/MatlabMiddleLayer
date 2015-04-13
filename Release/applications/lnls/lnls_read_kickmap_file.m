function [posx posy kickx kicky id_length] = lnls_read_kickmap_file(file_name)

fp = fopen(file_name, 'r');

% HEADER 
tline = fgetl(fp);
tline = fgetl(fp);
tline = fgetl(fp); 
id_length = fscanf(fp, '%f');
tline = fgetl(fp);
nptsx = fscanf(fp, '%i');
tline = fgetl(fp);
nptsy = fscanf(fp, '%i');

posx  = zeros(nptsy,nptsx);
posy  = zeros(nptsy,nptsx);
kickx = zeros(nptsy,nptsx);
kicky = zeros(nptsy,nptsx);

% HORIZONTAL KICKMAP
tline = fgetl(fp);
tline = fgetl(fp);
posx = repmat(fscanf(fp, '%f', [1 nptsx]), nptsy, 1);
for j=1:nptsy
    posy(j,:) = fscanf(fp, '%f', 1);
    kickx(j,:) = fscanf(fp, '%f', nptsx);
end
tline = fgetl(fp);

% VERTICAL KICKMAP
tline = fgetl(fp);
tline = fgetl(fp);
posx = repmat(fscanf(fp, '%f', [1 nptsx]), nptsy, 1);
for j=1:nptsy
    posy(j,:) = fscanf(fp, '%f', 1);
    kicky(j,:) = fscanf(fp, '%f', nptsx);
end
tline = fgetl(fp);

fclose(fp);