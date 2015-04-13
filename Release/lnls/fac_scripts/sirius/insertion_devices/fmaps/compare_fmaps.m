function r = compare_fmaps(folder1, folder2)

ModeString = '';
if ~isempty(strfind(folder1, 'SiriusB1LE')), ModeString = 'SiriusB1LE'; end;
if ~isempty(strfind(folder1, 'SiriusB1HY')), ModeString = 'SiriusB1HY'; end;
if ~exist('folder2','var')
    folder2 = fullfile(ModeString,'bare'); 
end;

data = importdata(fullfile(folder1, 'fmap.out'), ' ', 3);
fmap = data.data;
x1   = unique(fmap(:,1));
y1   = unique(fmap(:,2));
nux1  = reshape(fmap(:,3), length(y1), []);
nuy1  = reshape(fmap(:,4), length(y1), []);
dnux1 = reshape(fmap(:,5), length(y1), []);
dnuy1 = reshape(fmap(:,6), length(y1), []);
dnu1  = log10(sqrt(dnux1.^2 + dnuy1.^2));

data = importdata(fullfile(folder2, 'fmap.out'), ' ', 3);
fmap = data.data;
x2   = unique(fmap(:,1));
y2   = unique(fmap(:,2));
nux2  = reshape(fmap(:,3), length(y2), []);
nuy2  = reshape(fmap(:,4), length(y2), []);
dnux2 = reshape(fmap(:,5), length(y2), []);
dnuy2 = reshape(fmap(:,6), length(y2), []);
dnu2  = log10(sqrt(dnux2.^2 + dnuy2.^2));


figure; hold all;
xlabel('PosX [mm]');
ylabel('PosY [mm]');

[X,Y] = meshgrid(x1,flipud(y1));
surf(1000*X,1000*Y,dnu1);
[X,Y] = meshgrid(x2,flipud(y2));
surf(1000*X,-1000*Y,dnu2);
plot([-20 20],[0 0], 'w-', 'LineWidth', 3);
plot([-20 20],[0 0], 'k-', 'LineWidth', 1);

view([0 0 1]);
shading flat;
colorbar;
axis([-20 20 -5 5]);
caxis([-10 -2]);
grid on;

text(14.5,-4.5, [' ' upper(folder2) ' '] , 'BackgroundColor', [1 0.7 0.7], 'Color', [0 0 0], 'EdgeColor',[0 0 0], 'FontWeight', 'bold');
text(-19,4.5, [' ' upper(folder1) ' '] , 'BackgroundColor', [1 0.7 0.7], 'Color', [0 0 0], 'EdgeColor',[0 0 0], 'FontWeight', 'bold');