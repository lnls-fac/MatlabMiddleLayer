function analyze_results(r)
    show_summary_nominal(r.ring, r.indices, r.sim_anneal);

    coup_goal = show_summary_machines(r.rand_mach_coup, r.indices, 'Goal Coupling');
    coup_ini = show_summary_machines(r.rand_mach_coup_ids, r.indices, 'Uncorrected');
    coup_fin = show_summary_machines(r.rand_mach_coup_ids_fb, r.indices, 'Corrected');
    print_res_ang(r, coup_goal, coup_ini, coup_fin);
    print_res_sigy(r, coup_goal, coup_ini, coup_fin);


function print_res_ang(r, coup_goal, coup_ini, coup_fin)
    C = 180/pi;
    names = {'mia', 'mib', 'mip', 'mic', 'bl_all'};
    st = sprintf('%94s', 'Angle correction (before -> after, in °)');
    fprintf('\n\n%s\n\n', strjust(st, 'center'));
    fprintf('ID  ');
    for i=1:length(names)
        fprintf('%s||', strjust(sprintf('%16s', names{i}), 'center'));
    end
    fprintf('\n%s\n', repmat('-', 94, 1))
    ini_mean = cell(size(names));
    fin_mean = cell(size(names));
    for i=1:length(coup_goal)
        fprintf('%02d: ', i);
        for j=1:length(names)
            name = names{j};
            idx = r.indices.(name);
            dtilt_ini = coup_ini{i}.tilt(idx) - coup_goal{i}.tilt(idx);
            d_ini = mean(rms(dtilt_ini));
            fprintf(' %5.2f ->', C*d_ini);
            dtilt_fin = coup_fin{i}.tilt(idx) - coup_goal{i}.tilt(idx);
            d_fin = rms(dtilt_fin);
            fprintf(' %5.2f ||', C*d_fin);
            ini_mean{j} = [ini_mean{j}, d_ini];
            fin_mean{j} = [fin_mean{j}, d_fin];
        end
        fprintf('\n');
    end
    fprintf('%s\n', repmat('-', 94, 1))
    fprintf('    ');
    for j=1:length(names)
        fprintf(' %5.2f ->', C*mean(ini_mean{j}));
        fprintf(' %5.2f ||', C*mean(fin_mean{j}));
    end
    fprintf('\n');
    
    
function print_res_sigy(r, coup_goal, coup_ini, coup_fin)
    C = 1e6;
    names = {'mia', 'mib', 'mip', 'mic', 'bl_all'};
    st = sprintf('%94s', 'Impact on sigmay (before -> after, in um)');
    fprintf('\n\n%s\n\n', strjust(st, 'center'));
    fprintf('ID  ');
    for i=1:length(names)
        fprintf('%s||', strjust(sprintf('%16s', names{i}), 'center'));
    end
    fprintf('\n%s\n', repmat('-', 94, 1))
    ini_mean = cell(size(names));
    fin_mean = cell(size(names));
    for i=1:length(coup_goal)
        fprintf('%02d: ', i);
        for j=1:length(names)
            name = names{j};
            idx = r.indices.(name);
            dsigy_ini = coup_ini{i}.sigmas(2, idx) - coup_goal{i}.sigmas(2, idx);
            d_ini = mean(rms(dsigy_ini));
            fprintf(' %5.2f ->', C*d_ini);
            dsigy_fin = coup_fin{i}.sigmas(2, idx) - coup_goal{i}.sigmas(2, idx);
            d_fin = rms(dsigy_fin);
            fprintf(' %5.2f ||', C*d_fin);
            ini_mean{j} = [ini_mean{j}, d_ini];
            fin_mean{j} = [fin_mean{j}, d_fin];
        end
        fprintf('\n');
    end
    fprintf('%s\n', repmat('-', 94, 1))
    fprintf('    ');
    for j=1:length(names)
        fprintf(' %5.2f ->', C*mean(ini_mean{j}));
        fprintf(' %5.2f ||', C*mean(fin_mean{j}));
    end
    fprintf('\n');