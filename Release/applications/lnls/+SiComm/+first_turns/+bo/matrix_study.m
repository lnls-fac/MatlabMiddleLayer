function m11_tl_turn = matrix_study(THERING, bo_fam, n_turns)

    for k = 2:n_turns
        mcorr_turns = sirius_commis.first_turns.bo.calc_respm_tracking_nturns(THERING, bo_fam, k);
        clear m11_tl
        m11_tl = mcorr_turns(1, 10);

        for i = 1:k-1
            m11_tl = m11_tl + mcorr_turns(50 * i + 1, 10);
        end

        m11_tl_turn(k) = m11_tl / k;
        
        fprintf('N turns %i \n', i);
    end
end