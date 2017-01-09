function lnls_plot_cod(default_path)


prompt = {'Submachine (bo/si)', 'COD unit (um/mm)', 'symmetry', 'plot title', 'corrected?(y/n)'};
defaultanswer = {'si', 'mm', '20', 'SI.V14.C03','n'};
answer = inputdlg(prompt,'Select submachine and trackcpp algorithms to run',1,defaultanswer);
if isempty(answer), return; end;
submachine = answer{1};
unit = answer{2};
symmetry = str2double(answer{3});
plot_title = answer{4};
if strcmpi(answer{5},'y'), corrected = true; else corrected = false; end
size_font = 16;

% selects file with random machines and loads it
if ~exist('default_path','var')
    default_path = fullfile(lnls_get_root_folder(), 'data','sirius',submachine);
end
[FileName,PathName,~] = uigetfile('*.mat','select matlab file with random machines', default_path);
if isnumeric(FileName)
    return
end
fname = fullfile(PathName, FileName);

r = load(fname); machine = r.machine;

% selects section of the lattice for the plot.
s = findspos(machine{1}, 1:length(machine{1}));
s_max = s(end)/symmetry;


% calcs closed-orbit, store them in matriz
if strcmpi(unit, 'um')
    factor = 1e6;
elseif strcmpi(unit, 'mm')
    factor = 1e3;
end
codrx = zeros(length(machine), length(machine{1}));
codry = zeros(length(machine), length(machine{1}));
codpx = zeros(length(machine), length(machine{1}));
codpy = zeros(length(machine), length(machine{1}));

try
    fam_data = sirius_si_family_data(machine{1});
    if isfield(fam_data, 'cvs')
        ch = 'chs';cv = 'cvs';
    else
        ch = 'ch';cv = 'cv';
    end
catch
    fam_data = sirius_bo_family_data(machine{1});
    ch = 'ch';cv = 'cv';
end

hcms = fam_data.(ch).ATIndex;
vcms = fam_data.(cv).ATIndex;

%hcms = fam_data.fch.ATIndex;
%vcms = fam_data.fcv.ATIndex;

bpms = fam_data.bpm.ATIndex;
kickx = zeros(length(machine), length(hcms));
kicky = zeros(length(machine), length(vcms));
sexts = findcells(machine{1},'PolynomB');
fprintf('Individual Machine Statistics: \n\n');
fprintf('%3s |   codx[um]    |   cody[um]    | max. kick [urad]\n', 'i');
fprintf('    | (max)  (std)  | (max)  (std)  |   x     y   \n');
for i=1:length(machine)
    if ~corrected
        machine{i} = lnls_set_kickangle(machine{i},0.0*hcms,hcms,'x');
        machine{i} = lnls_set_kickangle(machine{i},0.0*vcms,vcms,'y');
        machine{i} = turn_multipoles_off(machine{i}, sexts);
    end
    orb = findorbit4(machine{i}, 0, 1:length(machine{i}));
    codrx(i,:) = factor * orb(1,:);
    codry(i,:) = factor * orb(3,:);
    codpx(i,:) = orb(2,:);
    codpy(i,:) = orb(4,:);
    kickx(i,:) = lnls_get_kickangle(machine{i}, hcms,'x');
    kicky(i,:) = lnls_get_kickangle(machine{i}, vcms,'y');
    fprintf('%03i | %6.2f %6.2f | %6.2f %6.2f | %6.2f %6.2f \n', i, ...
        max(abs(codrx(i,:))), std(codrx(i,:)), ...
        max(abs(codry(i,:))), std(codry(i,:)), ...
        1e6*max(abs(kickx(i,:))), 1e6*max(abs(kicky(i,:))));
end
fprintf('\n\n Estimative of emsemble properties:\n\n');
fprintf('std (kickx, kicky) [urad]: (%.3f, %.3f)\n', 1e6*std(kickx(:)), 1e6*std(kicky(:)));
fprintf('max (kickx, kicky) [urad]: (%.3f, %.3f)\n', 1e6*max(abs(kickx(:))), 1e6*max(abs(kicky(:))));
[ma, ind] = max(std(codrx)); 
fprintf(['max(<x(s)^2>_E-<x(s)>_E^2) cod: %.3f ' unit ' @ s = %.2f (%s)\n'], ...
                            ma, mod(s(ind),s_max), machine{1}{ind}.FamName);
[ma, ind] = max(std(codry));
fprintf(['max(<y(s)^2>_E-<y(s)>_E^2) cod: %.3f ' unit ' @ s = %.2f (%s)\n'], ...
                            ma, mod(s(ind),s_max), machine{1}{ind}.FamName);
fprintf(['rms corrected cod @ all  (x,y) [' unit ']: (%.3f, %.3f)\n'], std(codrx(:)), std(codry(:)));
x = codrx(:,bpms); y = codry(:,bpms);
fprintf(['rms corrected cod @ bpms (x,y) [' unit ']: (%.3f, %.3f)\n'], std(x(:)), std(y(:)));

sel = (s <= s_max); 
s = s(sel);

% calcs stats
x = codrx(:,sel); x_std = std(x);
y = codry(:,sel); y_std = std(y);

f1 = figure;
set(f1, 'Position', [1 1 1000 350]);
axes('Parent',f1, 'FontSize',14,'Units','Pixels','Position',[80,55,900,260]);
hold all;
max_y = max(max(x));
min_y = min(min(y));
lnls_drawlattice(machine{1}, symmetry, min_y - 0.1 * (max_y-min_y), 1, 0.05 * (max_y-min_y)/2);

for i=1:size(x,1)
    plot(s, abs(x(i,:)),  'color', [0.5 0.5 1.0]);
    plot(s, -abs(y(i,:)), 'color', [1.0 0.5 0.5]);
end
plot(s, abs(x_std),  'color', [0 0 1], 'LineWidth', 3);
plot(s, -abs(y_std),  'color', [1 0 0], 'LineWidth', 3);
line([min(s) max(s)], [0 0], 'Color', [0,0,0]);
axis([min(s), max(s), (min_y - 0.1*(max_y-min_y) - 0.05 * (max_y-min_y)/2 - 0.05 * (max_y-min_y)), max_y]);
grid('on');
box('on');
xlabel('s [m]', 'FontSize', size_font); ylabel(['COD [' unit ']'], 'FontSize', size_font);
set(gca, 'FontSize', 15);
title(plot_title, 'FontSize', size_font);

function the_ring = turn_multipoles_off(the_ring0, idx)

the_ring = setcellstruct(the_ring0, 'MaxOrder', idx, 1);

% the_ring = the_ring0;
% for i=idx
%     PolyB = getcellstruct(the_ring, 'PolynomB', i);
%     PolyA = getcellstruct(the_ring, 'PolynomA', i);
%     PolyB{1}(3:end) = 0; PolyA{1}(3:end) = 0;
%     PolyB{1}(1) = 0; PolyA{1}(1) = 0;
%     the_ring = setcellstruct(the_ring, 'PolynomB', i, PolyB);
%     the_ring = setcellstruct(the_ring, 'PolynomA', i, PolyA);
% end
