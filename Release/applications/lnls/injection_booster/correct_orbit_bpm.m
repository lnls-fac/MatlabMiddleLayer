function machine = correct_orbit_bpm(M_acc, machine, param, n_part, n_pulse)
% initializations()

ch = findcells(machine, 'FamName', 'CH');
cv = findcells(machine, 'FamName', 'CV');
bpm = findcells(machine, 'FamName', 'BPM');
% [~, MS] = findm44(nominal_machine, 0, 1:length(nominal_machine));

theta_x = zeros(1, length(ch));
theta_y = zeros(1, length(cv));

corr_lim = 310e-6;
chute = 10e-6;
int_lim = 0.8;
pos_lim = param.sigma_bpm / int_lim;

eff1 = booster_turns(machine, 1, param, n_part);

if eff1 > 0.95
    return
end

[~, ~, ~, ~, r_bpm, int_bpm] = bo_pulses(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');

for i = 1:length(ch);
    fprintf('Corretoras %0.2i \n', i);
    ch_loop = ch(i);
    cv_loop = cv(i);
    
    bpm_x_ch = bpm( bpm > ch_loop);
    % bpm_x = bpm_x_ch(2);
    bpm_y = bpm( bpm > cv_loop);
    if length(bpm_y) > 1
        bpm_y = bpm_y(2);
    end
    
    int_bpm_x = (int_bpm(bpm == bpm_x_ch(1)) + int_bpm(bpm == bpm_x_ch(2)))/2;
    while int_bpm_x < int_lim
        theta_x(i) = theta_x(i) + chute;
        machine = lnls_set_kickangle(machine, theta_x(i), ch_loop, 'x');
        [~, ~, ~, ~, ~, int_bpm] = bo_pulses(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
        int_bpm_x = (int_bpm(bpm == bpm_x_ch(1)) + int_bpm(bpm == bpm_x_ch(2)))/2;
        if theta_x(i) > corr_lim - chute
            theta_x(i) = 0;
            while int_bpm_x < int_lim
                theta_x(i) = theta_x(i) - chute;
                machine = lnls_set_kickangle(machine, theta_x(i), ch_loop, 'x');
                [~, ~, ~, ~, ~, int_bpm] = bo_pulses(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
                int_bpm_x = (int_bpm(bpm == bpm_x_ch(1)) + int_bpm(bpm == bpm_x_ch(2)))/2;
                if abs(theta_x(i)) > corr_lim + chute
                    error('Serious problem on x plane')
                end
            end
        end
    end
    
    int_bpm_y = int_bpm(bpm == bpm_y);
    while int_bpm_y < int_lim
        theta_y(i) = theta_y(i) + chute;
        machine = lnls_set_kickangle(machine, theta_y(i), cv_loop, 'y');
        [~, ~, ~, ~, ~, int_bpm] = bo_pulses(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
        int_bpm_y = int_bpm(bpm == bpm_y);
        if theta_y(i) > corr_lim - chute
            theta_y(i) = 0;
            while int_bpm_y < int_lim
                theta_y(i) = theta_y(i) + chute;
                machine = lnls_set_kickangle(machine, theta_y(i), cv_loop, 'y');
                [~, ~, ~, ~, ~, int_bpm] = bo_pulses(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
                int_bpm_y = int_bpm(bpm == bpm_y);
                if abs(theta_y(i)) > corr_lim + chute
                    error('Serious problem on y plane')
                end
            end
        end
    end
    
    x_bpm = (r_bpm(1, bpm == bpm_x_ch(1)) + r_bpm(1, bpm == bpm_x_ch(2)))/2;
    y_bpm = r_bpm(2, bpm == bpm_y);
    
    M_bpm_x = M_acc(:, :, bpm_x_ch(2));
    M_bpm_y = M_acc(:, :, bpm_y);
    M_corr_x = M_acc(:, :, ch_loop);
    M_corr_y = M_acc(:, :, cv_loop);
    M_x = M_bpm_x / M_corr_x;  
    M_y = M_bpm_y / M_corr_y;  
    
    while abs(x_bpm) > pos_lim
        fprintf('Ajustando corretora horizontal %0.2i \n', i);
        theta_x(i) = theta_x(i) - x_bpm / M_x(1, 2);
        if abs(theta_x(i)) > corr_lim
            theta_x(i) = sign(theta_x(i)) * corr_lim;
        end
        machine = lnls_set_kickangle(machine, theta_x(i), ch_loop, 'x');
        [~, ~, ~, ~, r_bpm, ~] = bo_pulses(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
        fprintf('Corretora horizontal ajustada para %f urad \n', theta_x(i)*1e6);
        x_bpm = (r_bpm(1, bpm == bpm_x_ch(1)) + r_bpm(1, bpm == bpm_x_ch(2)))/2;
    end
    
    while abs(y_bpm) > pos_lim
        fprintf('Ajustando corretora vertical %0.2i \n', i);
        theta_y(i) = theta_y(i) - y_bpm / M_y(3, 4);
        if abs(theta_y(i)) > corr_lim
            theta_y(i) = sign(theta_y(i)) * corr_lim;
        end
        machine = lnls_set_kickangle(machine, theta_y(i), cv_loop, 'y');
        [~, ~, ~, ~, r_bpm, ~] = bo_pulses(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
        fprintf('Corretora vertical ajustada para %f urad \n', theta_y(i)*1e6);
        y_bpm = r_bpm(2, bpm == bpm_y);
    end
end

    
    
  
% multiple_pulses_turns(machine, param, n_part, n_pulse, 1)  
end

% function initializations()
% 
%     fprintf('\n<initializations> [%s]\n\n', datestr(now));
% 
%     % seed for random number generator
%     seed = 131071;
%     % fprintf('-  initializing random number generator with seed = %i ...\n', seed);
%     RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));
% 
% end


