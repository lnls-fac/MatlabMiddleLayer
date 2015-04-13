function redemad8()

[file path] = uigetfile('*','Escolha o arquivo rede gerado pelo MAD8','D:\ARQ\Linhas de Transporte - Sirius\LTBA\MAD8\atual\print');

fid = fopen([path file], 'r+');
fid2 = fopen([path 'optics.txt'],'w+');

line = fgetl(fid);

while ischar(line)
    if strcmp(line(1),'1')
        fgetl(fid);fgetl(fid);fgetl(fid);fgetl(fid);
        fgetl(fid);fgetl(fid);fgetl(fid);
        line = fgetl(fid);
    elseif strcmp(line(2),'-')
        break;
    else
        fprintf(fid2,[line '\n']);
        line = fgetl(fid);
    end   
end

fclose(fid); fclose(fid2);


%% Falta debugar

% a= load([path 'optics.txt']);
% 
% fid = fopen([path 'optics2.txt'],'w+');
% selection = [1, 2, 4:7, 10:14];  
% for i=1:size(a,1)
%     fprintf(fid,'%6.3f \t',a(i,selection)); fprintf(fid, '\n');
% end
% 
% fclose(fid);