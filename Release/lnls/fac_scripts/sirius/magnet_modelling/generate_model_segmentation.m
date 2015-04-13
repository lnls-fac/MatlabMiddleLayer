function r = generate_model_segmentation(traj, model_len, monomials, load_flag, config_path)


fname = fullfile(config_path, 'model_segmentation.mat');
changed_state = false;

x = NaN;
if exist(fname,'file') && strcmpi(load_flag, 'load')
    load(fname);
elseif exist(fname,'file') && strcmpi(load_flag, 'load_return')
    load(fname);
    plot_multipoles(traj, model_len, r, monomials);
    return;
else
    r.s = [0 model_len]; x = NaN;
    changed_state = true;
end

% s = linspace(0, model_len, 20);
% r = auto_gen_integ_multipoles(traj, s, 100);


while true
    
    [~, errors, integ_multipoles, stray_multipoles] = plot_multipoles(traj, model_len, r, monomials);
    fprintf('%02i | %8.3f mm | ', length(r.s)-1, x); fprintf('%5.2f ', errors); fprintf(' | '); fprintf('%5.2f ', 100*abs(stray_multipoles ./ integ_multipoles)); fprintf('\n');
     
    % gets input from fernando et al.
    try
        [x,~,button] = ginput(1);
    catch
        break;
    end
    x = round(x); % multiples of 1mm
    
    % does corresponding action.
    if (button == 1)
        if isempty(find(x/1000 == r.s, 1))
            r.s = sort([r.s x/1000]);
            %r = auto_gen_integ_multipoles(traj, r.s, 300);
            changed_state = true;
        end
    elseif (button == 3) && (length(r.s) > 1)
        [~, idx] = min(abs(r.s - x/1000));
        x = 1000*r.s(idx); 
        if (idx > 1) % does not erase s=0 segmentation line.
            r.s(idx) = [];
            changed_state = true;
        end
    elseif (button == 2)
       break;    
    end
    
end
drawnow;

[by_polynom, ~, ~, stray_multipoles] = calc_model_by_polynom(traj, r.s);

r.by_polynom = by_polynom;
r.stray_integ_multipoles = stray_multipoles;
if ~changed_state, return; end;
if exist(fname, 'file')
    movefile(fname, strrep(fname, '.mat', ['_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.mat']));
end
save(fname,'r');

function r = auto_gen_integ_multipoles(traj, s, nr_trials)

max_s = max(s);
r.s = s;
[by_polynom errors integ_multipoles stray_multipoles] = calc_model_by_polynom(traj, r.s);
for i=1:nr_trials
    r_new.s = sort(r.s .* (1+ 0.01*2*(rand(size(r.s))-0.5)));
    r_new.s = (max_s / max(r_new.s)) * r_new.s;
    [new_by_polynom new_errors new_integ_multipoles new_stray_multipoles] = calc_model_by_polynom(traj, r_new.s);
    if max(new_errors) < max(errors)
        r = r_new;
        errors = new_errors;
    end
end




function [by_polynom errors integ_multipoles stray_multipoles] = plot_multipoles(traj, model_len, r, monomials)

s = traj.s;
dip = traj.by_polynom(:,1);
quad = traj.by_polynom(:,2);
sext = traj.by_polynom(:,3);

sel = sort([1; find((abs(dip) <= 0.001 * max(abs(dip))))]);
s_max = max([1000 * s(sel(1)) 1000*model_len]);
min_dip = min(dip);
max_dip = max(dip);
min_quad = min(quad);
max_quad = max(quad);
min_sext = min(sext);
max_sext = max(sext);
delta_dip = max_dip - min_dip;
delta_quad = max_quad - min_quad;
delta_sext = max_sext - min_sext;
min_dip = min_dip - 0.1 * delta_dip;
max_dip = max_dip + 0.1 * delta_dip;
min_quad = min_quad - 0.1 * delta_quad;
max_quad = max_quad + 0.1 * delta_quad;
min_sext = min_sext - 0.1 * delta_sext;
max_sext = max_sext + 0.1 * delta_sext;

for i=1:1+max(monomials)
    labels{i} = [int2str(2*i) '-pole field [T/m^{' int2str(i-1) '}]'];
end
labels(1:6) = {
    'dipolar field [T]', ...
    'quadrupolar field [T/m]', ...
    'sextupolar field [T/m^{2}]', ...
    'octupolar field [T/m^{3}]', ...
    'decapolar field [T/m^{4}]', ...
    'duodecapolar field [T/m^{5}]', ...
};

[by_polynom errors integ_multipoles stray_multipoles] = calc_model_by_polynom(traj, r.s);

% plots current segmentation model (dipole)
subplot(3,1,1); hold off; plot([0 0],[0 0], 'Color', [1 1 1]); hold on;
line([0 max_dip],[0 0], 'Color', [0 0 0], 'LineWidth', 2);
plot(1000*s, dip, 'Color', [0 0 1], 'LineWidth', 3);
for i=1:length(r.s)-1
    line(1000*[r.s(i) r.s(i)], [0 by_polynom(i,1)], 'Color', [0 1 0]);
    line(1000*[r.s(i) r.s(i+1)], [by_polynom(i,1) by_polynom(i,1)], 'Color', [0 1 0]);
    line(1000*[r.s(i+1) r.s(i+1)], [by_polynom(i,1) 0], 'Color', [0 1 0]);
    line(1000*[r.s(i+1) r.s(i)], [0 0], 'Color', [0 1 0]);
end
%if ~isempty(r.s), line(1000*[r.s(end) r.s(end)], [min_dip max_dip], 'Color', [1 0 0]); end;
line(1000 * [model_len model_len], [min_dip max_dip], 'Color', [1 0 0]);
xlabel('long. pos [mm]'); ylabel(labels{1+monomials(1)}); axis([0 s_max min_dip max_dip]);

% plots current segmentation model (quadrupole)
subplot(3,1,2); hold off; plot([0 0],[0 0], 'Color', [1 1 1]); hold on;
line([0 max_quad],[0 0], 'Color', [0 0 0], 'LineWidth', 2);
plot(1000*s, quad, 'Color', [0 0 1], 'LineWidth', 3);
for i=1:length(r.s)-1
    line(1000*[r.s(i) r.s(i)], [0 by_polynom(i,2)], 'Color', [0 1 0]);
    line(1000*[r.s(i) r.s(i+1)], [by_polynom(i,2) by_polynom(i,2)], 'Color', [0 1 0]);
    line(1000*[r.s(i+1) r.s(i+1)], [by_polynom(i,2) 0], 'Color', [0 1 0]);
    line(1000*[r.s(i+1) r.s(i)], [0 0], 'Color', [0 1 0]);
end
%if ~isempty(r.s), line(1000*[r.s(end) r.s(end)], [min_quad max_quad], 'Color', [1 0 0]); end;
line(1000 * [model_len model_len], [min_quad max_quad], 'Color', [1 0 0]);
xlabel('long. pos [mm]');ylabel(labels{1+monomials(2)}); axis([0 s_max min_quad max_quad]);

% plots current segmentation model (sextupole)
subplot(3,1,3); hold off; plot([0 0],[0 0], 'Color', [1 1 1]); hold on;
line([0 max_sext],[0 0], 'Color', [0 0 0], 'LineWidth', 2);
plot(1000*s, sext, 'Color', [0 0 1], 'LineWidth', 3);
for i=1:length(r.s)-1
    line(1000*[r.s(i) r.s(i)], [0 by_polynom(i,3)], 'Color', [0 1 0]);
    line(1000*[r.s(i) r.s(i+1)], [by_polynom(i,3) by_polynom(i,3)], 'Color', [0 1 0]);
    line(1000*[r.s(i+1) r.s(i+1)], [by_polynom(i,3) 0], 'Color', [0 1 0]);
    line(1000*[r.s(i+1) r.s(i)], [0 0], 'Color', [0 1 0]);
end
%if ~isempty(r.s), line(1000*[r.s(end) r.s(end)], [min_sext max_sext], 'Color', [1 0 0]); end;
line(1000 * [model_len model_len], [min_sext max_sext], 'Color', [1 0 0]);
xlabel('long. pos [mm]'); ylabel(labels{1+monomials(3)}); axis([0 s_max min_sext max_sext]);

set(gcf, 'Name','model_segmentation');
