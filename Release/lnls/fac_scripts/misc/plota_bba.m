function p = plota_bba

p.data_dir = 'C:\Arq\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Optics';

data_files = {};
dirs = dir(p.data_dir);
for i=1:length(dirs);
    data_dir = dirs(i);
    if data_dir.isdir && ~strcmp(data_dir.name,'.') && ~strcmp(data_dir.name,'..')
        files = dir(fullfile(p.data_dir, data_dir.name));
        for j=1:length(files)
            if ~isempty(strfind(files(j).name, 'BPMOffset'))
                data_files{length(data_files)+1} = fullfile(p.data_dir, data_dir.name, files(j).name);
            end
        end
    end
end

p.evol_offset_h = [];
p.evol_offset_v = [];
data_files = sort(data_files);
for i=1:length(data_files)
    %fprintf('%s\n',data_files{i}); 
    p.data_files{i} = data_files{i};
    [pathstr, name, ext, versn] = fileparts(data_files{i});
    p.labels{i} = name;
    p.labels{i} = strrep(p.labels{i}, 'BPMOffset_', '');
    p.labels{i} = strrep(p.labels{i}, '.mat', '');
    p.labels{i} = strrep(p.labels{i}, '_', ' ');
    p.plot_labels{i} = int2str(i);
    fprintf('%03i  %s\n', i, p.labels{i});
    
    load(data_files{i});
    p.bba{i} = r;
    p.evol_offset_h = [p.evol_offset_h; r.offset(:,1)'];
    p.evol_offset_v = [p.evol_offset_v; r.offset(:,2)'];
end

for i=1:size(p.evol_offset_h,2)
%for i=1:3
    figure('Name', p.bba{1}.bpms{i});
    hold all;
    x = 1:length(p.bba);
    %plot(1000*p.evol_offset_h(:,i), '-bo', 'MarkerFaceColor', 'b');
    [AX,H1,H2] = plotyy(x, 1000*p.evol_offset_h(:,i), x, 1000*p.evol_offset_v(:,i));
    set(get(AX(1),'Ylabel'),'String','Offset Horizontal [ \mum ]'); 
    set(get(AX(2),'Ylabel'),'String','Offset Vertical [ \mum ]'); 
    set(H1,'LineStyle','-', 'Marker', 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
    set(H2,'LineStyle','-', 'Marker', 'o', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g');
    legend('Horizontal', 'Vertical');  
    xlabel('Número da Medida'); 
end


figure;
plot(p.evol_offset_h', '-o');
legend(p.labels);

figure;
plot(p.evol_offset_v', '-o');
legend(p.labels);
