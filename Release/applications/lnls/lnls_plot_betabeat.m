function lnls_plot_betabeat(default_path, the_ring_fname, mach_fname)

prompt = {'Submachine (bo/si)', 'symmetry', 'plot title'};
defaultanswer = {'si', '10', 'V03-C03'};
answer = inputdlg(prompt,'Select submachine and trackcpp algorithms to run',1,defaultanswer);
if isempty(answer), return; end;
submachine = answer{1};
symmetry = str2double(answer{2});
plot_title = answer{3};
size_font = 16;

if ~exist('default_path','var'),
    default_path = fullfile(lnls_get_root_folder(), 'data','sirius',submachine);
end
if ~exist('config_fname','var') || ~exist(the_ring_fname, 'file')
    [FileName,PathName,~] = uigetfile('*.mat','Select mat file with the nominal ring used', default_path);
    if isnumeric(FileName), return; end
    the_ring_fname = fullfile(PathName, FileName);
    default_path = PathName;
end
if ~exist('mach_fname','var') || ~exist(mach_fname, 'file')
    [FileName,PathName,~] = uigetfile('*.mat','Select matlab file with random machines',default_path);
    if isnumeric(FileName), return; end
    mach_fname = fullfile(PathName, FileName);
end

% carrega dados de arquivos
data = load(the_ring_fname); the_ring  = data.the_ring;
data = load(mach_fname); mach  = data.machine;


% selects section of the lattice for the plot.
s = findspos(the_ring, 1:length(the_ring));
s_max = s(end)/symmetry;
sel = (s <= s_max); 
s = s(sel);


f1 = figure;
set(f1, 'Position', [1 1 1000 350]);
h1 = axes('Parent',f1, 'FontSize',14);
hold on;

dbetax = zeros(length(mach), length(mach{1}));
dbetay = zeros(length(mach), length(mach{1}));
twiss0 = calctwiss(the_ring);
fprintf('Individual Machine Statistics: \n\n');
fprintf('%3s | dbetax [%%]   | dbetay [%%]   \n', 'i');
fprintf('    | (max)  (std)  | (max)  (std)  \n');
for i=1:length(mach)
    twiss = calctwiss(mach{i});
    dbetax(i,:) = 100*(abs(twiss.betax - twiss0.betax))./twiss0.betax;
    dbetay(i,:) = 100*(abs(twiss.betay - twiss0.betay))./twiss0.betay;
    plot(h1, s, dbetax(i,sel), 'Color', [0.5 0.5 1]);
    plot(h1, s, -dbetay(i,sel), 'Color', [1 0.5 0.5]);
    fprintf('%03i | %6.2f %6.2f | %6.2f %6.2f \n', i, ...
        max(dbetax(i,:)), sqrt(lnls_meansqr(dbetax(i,:))), ...
        max(dbetay(i,:)), sqrt(lnls_meansqr(dbetay(i,:))));
end
fprintf('\n\n Estimative of emsemble properties:\n\n');
fprintf('std (dbetax, dbetay) [%%]: (%.3f, %.3f)\n', sqrt(lnls_meansqr(dbetax(:))), sqrt(lnls_meansqr(dbetay(:))));
fprintf('max (dbetax, dbetay) [%%]: (%.3f, %.3f)\n', max(dbetax(:)), max(dbetay(:)));

plot(h1, s,  sqrt(lnls_meansqr(dbetax(:,sel))), 'Color', [0 0 1.0], 'LineWidth', 3);
plot(h1, s, -sqrt(lnls_meansqr(dbetay(:,sel))), 'Color', [1.0 0 0], 'LineWidth', 3);
line([min(s) max(s)], [0 0], 'Color', [0,0,0]);
annotation('textbox', [0.75 0.87 0.05 0.05],'String',{'Horizontal'},'FontSize',16,'FontWeight','bold','FitBoxToText','off','LineStyle','none');
annotation('textbox',[0.75 0.30 0.05 0.05],'String',{'Vertical'},'FontSize',16,'FontWeight','bold','FitBoxToText','off','LineStyle','none');
max_y =  max(dbetax(:)); min_y = -max(dbetay(:));
lnls_drawlattice(the_ring, symmetry, min_y - 0.1 * (max_y-min_y), 1, 0.05 * (max_y-min_y)/2);
axis([min(s), max(s), (min_y - 0.1*(max_y-min_y) - 0.05 * (max_y-min_y)/2 - 0.05 * (max_y-min_y)), max_y]);
grid('on'); box('on');
xlabel('s [m]', 'FontSize', size_font); ylabel('\delta \beta/\beta [%]', 'FontSize', size_font);
set(gca, 'FontSize', 15);
title(plot_title, 'FontSize', size_font);

