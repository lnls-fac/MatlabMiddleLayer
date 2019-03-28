function [R_c, R_b] = calc_gains(goal_respm, respm_modelo, corr_gain, bpm_gain)
    e1 = [1, 0; 0, 0];
    e2 = [0, 0; 0, 1];
    od = [0, 1; -1, 0];
    At_b = zeros(3, 3);
    Bt_b = zeros(3, 1);
    At_c = zeros(3, 3);
    Bt_c = zeros(3, 1);
    n_bpm = size(goal_respm, 1)/2;
    n_ch = (size(goal_respm, 2) - 1)/2;
    n_cv = size(goal_respm, 2) - 1 - n_ch;
    R_b = zeros(2, 2, n_bpm);
    R_c = zeros(2, 2, n_ch + n_cv);
    
    if corr_gain
            for j = 1:(size(goal_respm, 2)-1)
                if j <= (size(goal_respm, 2)-1) / 2
                    range = 1:n_bpm;
                    ax = 1; ay = 0;
                else
                    range = n_bpm+1:2*n_bpm;
                    ax = 0; ay = 1;
                end
                    for i = range
                        goal_v_corr = [ax * goal_respm(i,j); ay * goal_respm(i,j)];
                        model_v_corr = [ax * respm_modelo(i,j); ay * respm_modelo(i,j)];
                    
                        a_c = e1 * goal_v_corr; b_c = e2 * goal_v_corr; c_c = od * goal_v_corr;
                        ab_c = dot(a_c, b_c); ac_c = dot(a_c, c_c); bc_c = dot(b_c, c_c);
                        At_c(1, :) = At_c(1, :) + [dot(a_c, a_c), ab_c, ac_c];
                        At_c(2, :) = At_c(2, :) + [ab_c, dot(b_c, b_c), bc_c];
                        At_c(3, :) = At_c(3, :) + [ac_c, bc_c, dot(c_c, c_c)];
                        Bt_c = Bt_c + [dot(a_c, model_v_corr) ; dot(b_c, model_v_corr) ; dot(c_c, model_v_corr)];
                    end
                            
                    if det(At_c) == 0
                       if any(At_c(:, 1))
                          r_c = Bt_c ./ At_c(:, 1);
                          r_c(isnan(r_c)) = 0;
                       else
                          r_c = Bt_c ./ At_c(:, 2);
                          r_c(isnan(r_c)) = 0;
                       end
                    else
                       r_c = linsolve(At_c, Bt_c);
                    end
                    
                    if r_c(1) == 0 || isinf(r_c(1))
                       r_c(1) = 1;
                    end
                    
                    if r_c(2) == 0 || isinf(r_c(2))
                       r_c(2) = 1;
                    end
                    
                    R_c(:, :, j) = [r_c(1), r_c(3); -r_c(3), r_c(2)];
                    At_c = zeros(3, 3);
                    Bt_c = zeros(3, 1);
            end
    end
    
    if bpm_gain
        for i = 1:n_bpm
            for j = 1:size(goal_respm, 2)-1
                goal_v = [goal_respm(i,j); goal_respm(i+n_bpm,j)];
                model_v = [respm_modelo(i,j); respm_modelo(i+n_bpm,j)];
                a = e1 * goal_v; b = e2 * goal_v; c = od * goal_v;
                ab = dot(a, b); ac = dot(a, c); bc = dot(b, c);
                At_b(1, :) = At_b(1, :) + [dot(a, a) , ab, ac];
                At_b(2, :) = At_b(2, :) + [ab , dot(b, b), bc];
                At_b(3, :) = At_b(3, :) + [ac , bc, dot(c, c)];
                Bt_b = Bt_b + [dot(a, model_v) ; dot(b, model_v) ; dot(c, model_v)];
            end

            if det(At_b) == 0
                r = Bt_b ./ At_b(:, 1);
                r(isnan(r)) = 0;
            else  
                r = linsolve(At_b, Bt_b);
            end
            if r(1) == 0
               r(1) = 1;
            end
            if r(2) == 0
               r(2) = 1;
            end
            R_b(:, :, i) = [r(1), r(3); -r(3), r(2)];
        end
    end
end