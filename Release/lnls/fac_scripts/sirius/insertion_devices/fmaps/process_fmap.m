function process_fmap(folder)

% gera *.txt para FreqMap.exe

data = importdata(fullfile(folder, 'fmap.out'), ' ', 3);
fmap = data.data;

x     = unique(fmap(:,1));
y     = unique(fmap(:,2));
nux   = reshape(fmap(:,3), length(y), []);
nuy   = reshape(fmap(:,4), length(y), []);
dnux  = reshape(fmap(:,5), length(y), []);
dnuy  = reshape(fmap(:,6), length(y), []);
dnu   = log10(sqrt(dnux.^2 + dnuy.^2));
[X,Y] = meshgrid(x,flipud(y));

fp = fopen(fullfile(folder, 'fmap.txt'), 'w');
deltax = (x(end) - x(1))/(length(x)-1);
deltay = (y(end) - y(1))/(length(y)-1);
for j=1:length(x)
    for i=1:length(y)
        if (dnu(i,j) ~= -Inf)
            fprintf(fp, '%i %i %f %f %f %f %f %f %f\r\n', j, i, x(j), y(i), deltax, -deltay, nux(i,j), nuy(i,j), dnu(i,j));
        end
    end
end
fclose(fp);
