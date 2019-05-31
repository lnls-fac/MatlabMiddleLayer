function multiturn_correction_SOFB(n_sv, sum_lim, ring_size, closes_orbit)
    v_prefix = ''; % getenv('VACA_PREFIX');
    ioc_prefix = [v_prefix, 'BO-Glob:AP-SOFB:'];
    % kicks_ch_pv = [ioc_prefix, 'KicksCH-Mon'];
    % kicks_cv_pv = [ioc_prefix, 'KicksCV-Mon'];
    % delta_kicks_ch_pv = [ioc_prefix, 'DeltaKicksCH-Mon'];
    % delta_kicks_cv_pv = [ioc_prefix, 'DeltaKicksCV-Mon'];
    pv_name.bpmx_select = [ioc_prefix, 'BPMXEnblList-SP'];
    pv_name.bpmy_select = [ioc_prefix, 'BPMYEnblList-SP'];
    pv_name.orbx = [ioc_prefix, 'SPassOrbX-Mon'];
    pv_name.orby = [ioc_prefix, 'SPassOrbY-Mon'];
    pv_name.sum = [ioc_prefix, 'SPassSum-Mon'];
    pv_name.n_sv = [ioc_prefix, 'NrSingValues-SP'];
    pv_name.calc_kicks = [ioc_prefix, 'CalcDelta-Cmd'];
    pv_name.apply_kicks = [ioc_prefix, 'ApplyDelta-Cmd'];
    pv_name.corr_fact_ch = [ioc_prefix, 'DeltaFactorCH-SP'];
    pv_name.corr_fact_cv = [ioc_prefix, 'DeltaFactorCV-SP'];
    pv_name.buffer_pulse = [ioc_prefix, 'SmoothNrPts-RB'];
    pv_name.ring_size = [ioc_prefix, 'RingSize-SP'];
    pv_name.reforbx = [ioc_prefix, 'RefOrbX-SP'];
    pv_name.reforby = [ioc_prefix, 'RefOrbY-SP'];

    n_bpm = 50;

    if ~exist('closes_orbit', 'var')
      closes_orbit = false;
    end

    if ~exist('ring_size', 'var')
      ring_size = 1;
    end

    while ring_size < 5
        setpv(pv_name.ring_size, ring_size);
        n_sv = corr_loop(sum_lim, n_sv, n_bpm, pv_name, closes_orbit, ring_size);
        ring_size = ring_size + 1;
    end
end

function n_sv = corr_loop(sum_lim, n_sv, n_bpm, pv_name, closes_orbit, ring_size)
    f_pulse = 0.5;
    buffer = getpv(pv_name.buffer_pulse) * f_pulse;
    fcorr_x = 100;
    fcorr_y = 100;
    t_wait = 0.1;

    fprintf('=================================================\n');
    fprintf('COLLECTING PULSES\n');
    fprintf('=================================================\n');
    sleep(buffer)

    int_bpm = getpv(pv_name.sum);

    bpm_select = selection_bpm(int_bpm, sum_lim, 5 * n_bpm);

    if sum(bpm_select) <= 1
        error('Only 1 BPM or none with good sum signal!')
    end

    n_bpm_select_old = sum(bpm_select);

    while int_bpm(n_bpm * ring_size) < sum_lim
        x_bpm = getpv(pv_name.orbx);
        y_bpm = getpv(pv_name.orby);

        setpv(pv_name.bpmx_select, double(bpm_select));
        setpv(pv_name.bpmy_select, double(bpm_select));
        sleep(t_wait);

        setpv(pv_name.n_sv, n_sv);

        if closes_orbit && ring_size > 1
          setpv(pv_name.reforbx, x_bpm(1:n_bpm))
          setpv(pv_name.reforby, y_bpm(1:n_bpm))
        end

        setpv(pv_name.calc_kicks, 1);
        setpv(pv_name.corr_fact_ch, fcorr_x);
        setpv(pv_name.corr_fact_cv, fcorr_y);
        sleep(t_wait);
        setpv(pv_name.apply_kicks, 3);

        fprintf('=================================================\n');
        fprintf('COLLECTING PULSES\n');
        fprintf('=================================================\n');
        sleep(buffer);

        int_bpm = getpv(pv_name.sum);

        bpm_select = selection_bpm(int_bpm, sum_lim, n_bpm * ring_size);

        n_bpm_select_new = sum(bpm_select);

        if n_bpm_select_new < n_bpm_select_old
            cancel_kicks(pv_name.corr_fact_ch, pv_name.corr_fact_cv, pv_name.apply_kicks, t_wait, 'xy')
        else
            n_bpm_select_old = n_bpm_select_new;
        end

        n_sv = n_sv + 5;
        fprintf('=================================================\n');
        fprintf('%i SINGULAR VALUES \n', n_sv);
        fprintf('=================================================\n');
    end

    fprintf('=================================================\n');
    fprintf('BEAM AT TURN # %i\n', ring_size + 1);
    fprintf('=================================================\n');
end

function bpm_select = selection_bpm(int_bpm, sum_lim, n_bpm)
    bpm_select = true(1, n_bpm);
    non_select = find(int_bpm < sum_lim, 1, 'first');
    if ~isempty(non_select)
        bpm_select(non_select:end) = false;
    end
    % int_bpm_ok = int_bpm(bpm_select);
end

function cancel_kicks(corr_fact_ch_pv, corr_fact_cv_pv, apply_kicks_pv, tw, plane)

    if strcmp(plane, 'xy')
        setpv(corr_fact_ch_pv, 0);
        setpv(corr_fact_cv_pv, 0);
        sleep(tw);
    elseif strcmp(plane, 'x')
        setpv(corr_fact_ch_pv, 0);
        sleep(tw);
    elseif strcmp(plane, 'y')
        setpv(corr_fact_cv_pv, 0);
        sleep(tw);
    end

    setpv(apply_kicks_pv, 1);
end
