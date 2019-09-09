function MD = SinglePulse(MD, point, flag_kckr, flag_error)

injkckr = findcells(MD.Ring, 'FamName', 'InjDpKckr');
flag_TbT = false;
PbP_Error = 0;

    if strcmp(flag_error, 'errorON')
        error_x_pulse = PbP_Error * lnls_generate_random_numbers(1, 1, 'norm', MD.Err.Sigma.Cutoff) * MD.Err.x_error_pulse;
        MD.Inj.R.offset_x = MD.Inj.R.offset_x_syst + error_x_pulse;

        error_xl_pulse = PbP_Error * lnls_generate_random_numbers(1, 1, 'norm', MD.Err.Sigma.Cutoff) * MD.Err.xl_error_pulse;
        MD.Inj.R.offset_xl =  MD.Inj.R.offset_xl_syst + error_xl_pulse;

        error_y_pulse = PbP_Error *lnls_generate_random_numbers(1, 1, 'norm', MD.Err.Sigma.Cutoff) * MD.Err.y_error_pulse;
        MD.Inj.R.offset_y = MD.Inj.R.offset_y_syst + error_y_pulse;

        error_yl_pulse = PbP_Error *lnls_generate_random_numbers(1, 1, 'norm', MD.Err.Sigma.Cutoff) * MD.Err.yl_error_pulse;
        MD.Inj.R.offset_yl = MD.Inj.R.offset_yl_syst + error_yl_pulse;

        if strcmp(flag_kckr, 'kickerON')
            error_kckr_pulse = PbP_Error * lnls_generate_random_numbers(1, 1, 'norm', MD.Err.Sigma.Cutoff) * MD.Err.kckr_error_pulse;
            MD.Inj.R.kckr = MD.Inj.R.kckr_syst + error_kckr_pulse;
            MD.Ring = lnls_set_kickangle(MD.Ring, MD.Inj.R.kckr, injkckr, 'x');
        end
        
        error_delta_pulse = PbP_Error * lnls_generate_random_numbers(1, 1, 'norm', MD.Err.Sigma.Cutoff) * MD.Err.delta_error_pulse;
        MD.Inj.R.delta = MD.Inj.R.delta_syst + error_delta_pulse;
        MD.Inj.R.phase = MD.Err.phase_offset;
    else
        MD.Inj.R.offset_x = MD.Inj.R0.offset_x0;
        MD.Inj.R.offset_xl =  MD.Inj.R0.offset_xl0;
        MD.Inj.R.offset_y = MD.Inj.R0.offset_y0;
        MD.Inj.R.offset_yl = MD.Inj.R0.offset_yl0;

        if strcmp(flag_kckr, 'kickerON')
            % Setting the kicker on
            MD.Ring = lnls_set_kickangle(MD.Ring, MD.Inj.R0.kckr0, injkckr, 'x');
        end

        % No energy errors
        MD.Inj.R.delta = 0;
        MD.Inj.R.delta_ave = 0;
        MD.Inj.R.phase = MD.Inj.R0.phase;
    end

    %   Initial offsets at injection point - nominal + syst. errors + jitter errors
    ROff = [MD.Inj.R.offset_x; MD.Inj.R.offset_xl; MD.Inj.R.offset_y; MD.Inj.R.offset_yl; MD.Inj.R.delta; MD.Inj.R.phase];

    % Twissss function at injection point
    Twiss.betax = MD.Inj.Twiss.betax0; Twiss.alphax = MD.Inj.Twiss.alphax0;
    Twiss.betay = MD.Inj.Twiss.betay0; Twiss.alphay = MD.Inj.Twiss.alphay0;
    Twiss.etax = MD.Inj.Twiss.etax0;   Twiss.etaxl = MD.Inj.Twiss.etaxl0;
    Twiss.etay = MD.Inj.Twiss.etay0;   Twiss.etayl = MD.Inj.Twiss.etayl0;

    % Generate particles
    if MD.Beam.NPart > 1
        R0 = lnls_generate_bunch(MD.Beam.emitx, MD.Beam.emity, MD.Beam.sigmae, MD.Beam.sigmaz, Twiss, MD.Beam.NPart, MD.Beam.Cutoff);
        R0 = bsxfun(@plus, R0, ROff);
    else
        R0 = ROff;
    end

    % % The beam energy is changed to simulate the dipoles adjusts
    % r_init(5, :) = (r_init(5, :) - param.delta_ave) / (1 + param.delta_ave);

    % if param.delta_ave ~= 0
    %     % To simulate dipoles adjusts changing the beam energy one has to consider that the BC energy is always fixed
    %     bc = findcells(machine, 'FamName', 'BC');
    %     theta0 = getcellstruct(machine, 'BendingAngle', bc);
    %     len = getcellstruct(machine, 'Length', bc);
    %     polyB_orig = getcellstruct(machine, 'PolynomB', bc);
    %     polyB_new = polyB_orig;
    %     dtheta = zeros(length(polyB_new), 1);

    %     for j = 1:length(polyB_orig)
    %         polyB_new{j} = polyB_orig{j} / (1 + param.delta_ave) ;
    %     end

    %     for j = 1:length(polyB_new)
    %         pb = polyB_new{j};
    %         dtheta(j) = theta0(j) ./ len(j) * (- param.delta_ave) / (1 + param.delta_ave);
    %         pb(1,1) = pb(1,1) - dtheta(j);
    %         polyB_new{j} = pb;
    %     end

    %     machine_new = setcellstruct(machine, 'PolynomB', bc, polyB_new);
    % else
    %     machine_new = machine;
    % end

    % Perform the tracking until the required point at the ring
    
    %%%%% FIRST TURN %%%%%%
    RP = linepass(MD.Ring(1:point), R0, 1:point+1);
    RP = reshape(RP, 6, [], point+1);       
    % Comparison with Vacuum Chamber at every point, lost particles are set as NaN
    RXY = SiComm.common.compares_vchamb(MD.Ring, RP([1,3], :, :), 1:point(end));
    RP([1,3], :, :) = RXY;
    MD.TrackPos = RP;
    MD.Efficiency = SiComm.common.calc_eff(MD.Beam.NPart, squeeze(RXY(:, :, end)));
    if MD.Efficiency < MD.Beam.Lost
        MD.Inj.CompletedTurns = 0;
    else
        MD.Inj.CompletedTurns = 1;
    end
    
    if MD.Inj.NTurns > 1
        flag_TbT = true;
        MD.RTurns = zeros(6, MD.Beam.NPart, (point+1) * MD.Inj.NTurns);
        MD.RTurns(:, :, 1:point+1) = RP;
        MD.TurnByTurn.Efficiency(1) = SiComm.common.calc_eff(MD.Beam.NPart, squeeze(RXY(:, :, end)));
        %%%%% TURNING OFF INJECTION KICKER %%%%%
        MD.Ring = lnls_set_kickangle(MD.Ring, 0, injkckr, 'x');
        %%%%% NTURNS %%%%%%%
        RInit = RP(:, :, end);
        for t = 2:MD.Inj.NTurns
            RFinal = linepass(MD.Ring, squeeze(RInit), 1:point+1);
            RFinal = reshape(RFinal, 6, [], point+1);
            RXY = SiComm.common.compares_vchamb(MD.Ring, RFinal([1,3], :, :), 1:point(end));
            MD.TurnByTurn.Efficiency(t) = SiComm.common.calc_eff(MD.Beam.NPart, squeeze(RXY(:, :, end)));
            RFinal([1,3], :, :) = RXY;
            MD.RTurns(:, :, (t-1)*point+t:t*point+t) = RFinal;
            RInit = RFinal(:, :, end);
            if MD.TurnByTurn.Efficiency(t) < MD.Beam.Lost
                break
            else
                MD.Inj.CompletedTurns = MD.Inj.CompletedTurns + 1;
            end
        end
    end
    
    % SiComm.scatplot(1e3 * squeeze(r_xy(1, :, point)), 1e3 * squeeze(r_xy(2, :, point)), 'circles', 2e-2, 2e3, 5, 1, 4);
    MD = SiComm.common.getBPMPos(MD, flag_TbT);
    MD = rmfield(MD, 'TrackPos');
    
end
