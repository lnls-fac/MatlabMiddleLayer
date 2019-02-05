function bba_data = bba_non_stored_beam(machine, n_mach, param, param_errors, n_part, n_pulse, M_acc, n_points, method)
    mili = 1e-3; micro = 1e-6;
    
    if n_mach == 1
        machine_cell = {machine};
        param_cell = {param};
    elseif n_mach > 1
        machine_cell = machine;
        param_cell = param;
    end
    
    off_bpm = cell(n_mach, 1);
    off_quad = cell(n_mach, 1);
    off_bba = cell(n_mach, 1);
    
    for j = 1:n_mach
        
        
        fprintf('================================================\n');
        fprintf('MACHINE NUMBER # %i / %i \n', j, n_mach);
        fprintf('================================================\n');
    
        machine = machine_cell{j};
        param = param_cell{j};
    
        fam = sirius_si_family_data(machine);
        ch = fam.CH.ATIndex;
        cv = fam.CV.ATIndex;
        bpm = fam.BPM.ATIndex;
        quads = fam.QN.ATIndex;
        % sexts = fam.SN.ATIndex;
        % sext_nocorr = setdiff(sexts, ch);
        % sext_nocorr = setdiff(sext_nocorr, cv);
        % machine = setcellstruct(machine, 'PassMethod', sext_nocorr, 'DriftPass');
        
        theta_x0 = lnls_get_kickangle(machine, ch, 'x')';
        theta_y0 = lnls_get_kickangle(machine, cv, 'y')';
        offset_bba_x = zeros(length(bpm), 1);
        offset_bba_y = offset_bba_x;
        erro_fitx = offset_bba_x;
        erro_fity = offset_bba_x;
        bpm_ok_x = zeros(length(bpm), 1);
        bpm_ok_y = bpm_ok_x;
        bba_ind = get_bba_ind(machine, bpm, quads);
    
        if strcmp(method, 'quad')
            flag_quad = true;
        else
            flag_quad = false;
        end

        for k = 1:length(bpm)
            if bba_ind(k) > bpm(k)
                trecho = machine(bpm(k)+1:bba_ind(k)-1);
            else
                trecho = machine(bba_ind(k)+1:bpm(k)-1);
            end
            pass = getcellstruct(trecho, 'PassMethod', 1:length(trecho));
            for p = 1:length(pass)
                if strcmp(pass{p}, 'DriftPass')
                    bpm_ok_x(k) = 1;
                    bpm_ok_y(k) = 1;
                else
                    break
                end
            end
        end
        
        [m_corr_x, m_corr_y] = sirius_commis.first_turns.si.trajectory_matrix(fam, M_acc);
        [~ , ind_best_x] = max(abs(m_corr_x), [], 2);
        [~ , ind_best_y] = max(abs(m_corr_y), [], 2);
        % [~, ind_best_x2] = max(abs(m_corr_x), [], 1);
    
        % m_corr_x(m_corr_x == 0) = NaN;
   
        % [~, ind_worst_x] = nanmin(abs(m_corr_x), [], 2);
        % [~, ind_worst_x2] = nanmin(abs(m_corr_x), [], 1);
   
        if ~mod(n_points, 2)
            n_points = n_points + 1;
        end
    
        % m_corr_x(isnan(m_corr_x)) = 0;

        delta_x = 2 * mili;
        delta_y = 2 * mili;
        corr_lim = 300 * micro;
        % polyB_Q14max = 3.72;
    
        for i = 1:length(bpm)
            if bpm_ok_x(i)
                mx(i) = m_corr_x(i, ind_best_x(i));
                if abs(mx(i)) < 10
                    bpm_ok_x(i) = 0;
                end
                my(i) = m_corr_y(i, ind_best_y(i));
                if abs(my(i)) < 10
                    bpm_ok_y(i) = 0;
                end
            end
        end
        
        fprintf('================================================\n');
        fprintf('HORIZONTAL BBA \n');
        fprintf('================================================\n');
    
    
        for i = 1:length(bpm)
            if bpm_ok_x(i)
                theta0 = theta_x0(ind_best_x(i));
                delta_theta = abs(delta_x / mx(i));
                theta_min = theta0 - delta_theta;
                theta_max = theta0 + delta_theta;
                if abs(theta_min) > corr_lim
                    theta_min = sign(theta_min) * corr_lim;
                    warning('on')
                    warning('CALCULATED CORRECTOR KICK GREATER THAN MAX, 300 um APPLIED')
                end
                if abs(theta_max) > corr_lim
                    theta_max = sign(theta_max) * corr_lim;
                    warning('CALCULATED CORRECTOR KICK GREATER THAN MAX, 300 um APPLIED')
                end
            
                dtheta_corr = linspace(theta_min, theta_max, n_points);  
            
                fprintf('================================================\n');
                fprintf('BPM NUMBER # %i / %i \n', sum(bpm_ok_x(1:i)), sum(bpm_ok_x));
                fprintf('================================================\n');
                
                % if sum(bpm_ok_x(1:i)) > 3
                %     break
                % end
            else
                continue
            end
         
            %if i > 1
            [xbpm, fmx] = bba_process(machine, param, param_errors, n_part, n_pulse, bba_ind, ind_best_x, dtheta_corr, i, n_points, fam, 'x', method);
            % else
            %     dtheta_kckr = linspace(param.kckr_sist * 0.95, param.kckr_sist * 1.05, n_points);
            %     [xbpm, fm] = bba_process(machine_in, param, param_errors, n_part, n_pulse, bba_ind, ind_best_x, dtheta_kckr, i, n_points, fam, 'x');
            % end
            if flag_quad
                [prblx, Sx, mux] = polyfit(xbpm, fmx, 2);
                % x_fit = [min(xbpm):1e-8:max(xbpm)];
                [~, deltax] = polyval(prblx, xbpm, Sx, mux);    
                % [~, i_min] = min(px);
                % offset_bba_x1(i) = x_fit(i_min);
                offset_bba_x(i) = - prblx(2) / 2 / prblx(1) * mux(2) + mux(1);
                erro_fitx(i) = mean(deltax);
                % hold off;
                % gcf(); plot(xbpm * 1e6, fmx, 'o', 'MarkerSize', 3 ,'MarkerEdgeColor','blue','MarkerFaceColor',[0 0 1]); hold all; plot(xbpm * 1e6, px, 'red', 'LineWidth', 2);
                % y = get(gca, 'ylim');
                % plot([offset_bba_x(i)*1e6 offset_bba_x(i)*1e6], y, 'blue', 'LineWidth', 2);
                % grid on;
                % drawnow();
            else
                for l = 1:size(xbpm, 2)
                    [linex, Sx, mux] = polyfit(xbpm(:, l), fmx(:, l), 1);
                    [~, deltax] = polyval(linex, xbpm(:, l), Sx, mux);
                    % gcf(); plot(xbpm(:, l)*1e6, fmx(:, l), 'o', 'MarkerSize', 3 ,'MarkerEdgeColor','blue','MarkerFaceColor',[0 0 1]); hold on; plot(xbpm(:, l)*1e6, px, 'LineWidth', 2);
                    % grid on;
                    crossx(l) = - linex(2) / linex(1) * mux(2) + mux(1);
                    ang_coefx(l) = linex(1) / mux(2);
                    erro_linex(l) = mean(deltax);
                end
                offset_bba_x(i) = sum(abs(ang_coefx) .* crossx)/ sum(abs(ang_coefx));
                erro_fitx(i) = sum(abs(ang_coefx) .* erro_linex)/ sum(abs(ang_coefx));
            end    
        end
        
        fprintf('================================================\n');
        fprintf('VERTICAL BBA \n');
        fprintf('================================================\n');
    
    
        for i = 1:length(bpm)
            if bpm_ok_y(i)
                theta0 = theta_y0(ind_best_y(i));
                delta_theta = abs(delta_y / my(i));
                theta_min = theta0 - delta_theta;
                theta_max = theta0 + delta_theta;
                if abs(theta_min) > corr_lim
                    theta_min = sign(theta_min) * corr_lim;
                    warning('on')
                    warning('CALCULATED CORRECTOR KICK GREATER THAN MAX, 300 um APPLIED')
                end
                if abs(theta_max) > corr_lim
                    theta_max = sign(theta_max) * corr_lim;
                    warning('CALCULATED CORRECTOR KICK GREATER THAN MAX, 300 um APPLIED')
                end
                
                dtheta_corr = linspace(theta_min, theta_max, n_points);
                
                fprintf('================================================\n');
                fprintf('BPM NUMBER # %i / %i \n', sum(bpm_ok_y(1:i)), sum(bpm_ok_y));
                fprintf('================================================\n');
                
                % if sum(bpm_ok_y(1:i)) > 3
                %     break
                % end
            else
                continue
            end
    
            %if i > 1
            [ybpm, fmy] = bba_process(machine, param, param_errors, n_part, n_pulse, bba_ind, ind_best_y, dtheta_corr, i, n_points, fam, 'y', method);
            % else
            %     dtheta_kckr = linspace(param.kckr_sist * 0.95, param.kckr_sist * 1.05, n_points);
            %     [xbpm, fm] = bba_process(machine_in, param, param_errors, n_part, n_pulse, bba_ind, ind_best_x, dtheta_kckr, i, n_points, fam, 'x');
            % end
            if flag_quad
                [prbly, Sy, muy] = polyfit(ybpm, fmy, 2);
                [~, deltay] = polyval(prbly, ybpm, Sy, muy);    
                offset_bba_y(i) = - prbly(2) / 2 / prbly(1) * muy(2) + muy(1);
                erro_fity(i) = mean(deltay);
            else
                for l = 1:size(ybpm, 2)
                    [liney, Sy, muy] = polyfit(ybpm(:, l), fmy(:, l), 1);
                    [~, deltay] = polyval(liney, ybpm(:, l), Sy, muy);
                    % gcf(); plot(ybpm(:, l)*1e6, fmy(:, l), 'o', 'MarkerSize', 3 ,'MarkerEdgeColor','blue','MarkerFaceColor',[0 0 1]); hold on; plot(ybpm(:, l)*1e6, py, 'LineWidth', 2);
                    % grid on;
                    crossy(l) = -liney(2) / liney(1) * muy(2) + muy(1);
                    ang_coefy(l) = liney(1) / muy(2);
                    erro_liney(l) = mean(deltay);
                end
                offset_bba_y(i) = sum(abs(ang_coefy) .* crossy)/ sum(abs(ang_coefy));
                erro_fity(i) = sum(abs(ang_coefy) .* erro_liney)/ sum(abs(ang_coefy));
            end
            % figure; plot(ybpm*1e6, fmy, 'o', 'MarkerSize', 3 ,'MarkerEdgeColor','blue','MarkerFaceColor',[0 0 1]); hold on; plot(ybpm*1e6, py, 'LineWidth', 2);
            % drawnow();
        end
        
    
        offset_bba = [offset_bba_x, offset_bba_y];
        erro_fit = [erro_fitx, erro_fity];
    
        % T1x = getcellstruct(machine_in, 'T1', bba_ind, 1, 1);
        % T2x = getcellstruct(machine_in, 'T2', bba_ind, 1, 1);
        % offset_quadx = (T2x - T1x) / 2;
        offset_quadx = getcellstruct(machine, 'T2', bba_ind, 1, 1);
        % T1y = getcellstruct(machine_in, 'T1', bba_ind, 1, 3);
        % T2y = getcellstruct(machine_in, 'T2', bba_ind, 1, 3);
        % offset_quady = (T2y - T1y) / 2;
        offset_quady = getcellstruct(machine, 'T2', bba_ind, 1, 3);
        offset_quad = [offset_quadx, offset_quady];
    
        offset_bpm = getcellstruct(machine, 'Offsets', bpm);
        offset_bpm = cell2mat(offset_bpm);
    
        off_bpm{j} = offset_bpm;
        off_quad{j} = offset_quad;
        off_bba{j} = offset_bba;
        error_fitting{j} = erro_fit;
    end
    
    bba_data.off_bba = off_bba;
    bba_data.off_bpm = off_bpm;
    bba_data.off_quad = off_quad;
    bba_data.erro_fit = error_fitting;
    
    if flag_quad
        save bba_quadratic_fit.mat bba_data
    else
        save bba_linear_fit.mat bba_data
    end
end
function [r_bpm, fm] = bba_process(machine_in, param, param_errors, n_part, n_pulse, bba_ind, ind_best, dtheta_corr, n_bpm, n_points, fam, plane, method)

if strcmp(plane, 'x')
    flag_x = true;
elseif strcmp(plane, 'y')
    flag_x = false;
end

if strcmp(method, 'quad')
    flag_quad = true;
else
    flag_quad = false;
end

if flag_x
    corr = fam.CH.ATIndex;
else
    corr = fam.CV.ATIndex;
end

bpm = fam.BPM.ATIndex;
int_min = 0.5;
polyB = getcellstruct(machine_in, 'PolynomB', bba_ind(n_bpm), 1, 2);

bpm_bba = bpm(bpm > bba_ind(n_bpm));
[~, ind_bpm_bba] = intersect(bpm, bpm_bba);

if flag_quad
    fm = zeros(n_points, 1);
    r_bpm = zeros(n_points, 1);
else
    fm = zeros(n_points, length(ind_bpm_bba));
    r_bpm = zeros(n_points, length(ind_bpm_bba));
end

for ii = 1:n_points
        if n_bpm > 1
            machine1 = lnls_set_kickangle(machine_in, dtheta_corr(ii) , corr(ind_best(n_bpm)), plane);
        else
            param.kckr_sist = dtheta_corr(ii);
            machine1 = machine_in;
        end
        
        machine2 = setcellstruct(machine1, 'PolynomB', bba_ind(n_bpm), polyB * 0.95, 1, 2);
        machine1 = setcellstruct(machine1, 'PolynomB', bba_ind(n_bpm), polyB * 1.05, 1, 2);
        % [~, r_bpm1, int_bpm1, ~, ~, ~] = sirius_commis.first_turns.si.multiple_pulse_turn(machine1, 1, param, param_errors, n_part, n_pulse, n_turns);
        % [~, r_bpm2, int_bpm2, ~, ~, ~] = sirius_commis.first_turns.si.multiple_pulse_turn(machine2, 1, param, param_errors, n_part, n_pulse, n_turns);
        % param.orbit = findorbit4(machine1, 0, 1:length(machine1));
        [~, ~, ~, r_bpm1, int_bpm1] = sirius_commis.injection.si.multiple_pulse(machine1, param, param_errors, n_part, n_pulse, length(machine_in), 'on', 'diag');
        % param.orbit = findorbit4(machine2, 0, 1:length(machine2));
        [~, ~, ~, r_bpm2, int_bpm2] = sirius_commis.injection.si.multiple_pulse(machine2, param, param_errors, n_part, n_pulse, length(machine_in), 'on', 'diag');
        % orbit1 = findorbit4(machine1, 0, bpm);
        % orbit2 = findorbit4(machine2, 0, bpm);
        % r_bpm1 = orbit1(1, :);
        % r_bpm2 = orbit2(1, :);
        % int_bpm1 = ones(length(bpm), 1);
        % int_bpm2 = int_bpm1;
        
        fprintf('================================================\n');
        fprintf('CORRECTOR CHANGE NUMBER # %i / %i \n', ii, n_points);
        fprintf('================================================\n');
        
        
        % if mean(int_bpm1) < int_min || mean(int_bpm2) < int_min
        %     fm(ii) = NaN;
        %     r_bpm(ii) = NaN;
        %     continue
        % end
        % if n_corr == 1
            
        %     n_corr = 0;
        % end
        
        bpm_bba = bpm(int_bpm1 > int_min & int_bpm2 > int_min & bpm > bba_ind(n_bpm));
        [~, ind_bpm_bba] = intersect(bpm, bpm_bba);
            
        if flag_quad   
            if flag_x
                fm(ii) = nansum((r_bpm1(1, ind_bpm_bba) - r_bpm2(1, ind_bpm_bba)).^2);
                r_bpm(ii) = r_bpm1(1, n_bpm);
            else
                fm(ii) = nansum((r_bpm1(2, ind_bpm_bba) - r_bpm2(2, ind_bpm_bba)).^2);
                r_bpm(ii) = r_bpm1(2, n_bpm);
            end
        else
            if flag_x
                fm(ii, :) = r_bpm1(1, ind_bpm_bba') - r_bpm2(1, ind_bpm_bba');
                r_bpm(ii, :) = r_bpm1(1, ind_bpm_bba);
            else
                fm(ii, :) = r_bpm1(2, ind_bpm_bba') - r_bpm2(2, ind_bpm_bba');
                r_bpm(ii, :) = r_bpm1(2, ind_bpm_bba);
            end
        end
end
end

