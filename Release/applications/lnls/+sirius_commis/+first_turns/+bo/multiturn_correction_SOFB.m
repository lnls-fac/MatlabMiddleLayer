function multiturn_correction_SOFB(n_bpm, n_sv, sum_lim, ring_size, closes_orbit)

v_prefix = getenv('VACA_PREFIX');
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

if ~exist('closes_orbit', 'var')
  closes_orbit = false;
end

while ring_size < 5
    corr_loop(sum_lim, n_sv, n_bpm, pv_name, closes_orbit, ring_size)
    ring_size = ring_size + 1;
end

    function corr_loop(sum_lim, n_sv, n_bpm, pv_name, closes_orbit, ring_size)
        f_pulse = 0.5;
        buffer = getpv(pv_name.buffer_pulse) * f_pulse;
        fact_corr_x = 100;
        fact_corr_y = 100;
        tw = 0.1;
        setpv(pv_name.ring_size, ring_size);
        
        fprintf('=================================================\n');
        fprintf('COLLECTING PULSES\n');
        fprintf('=================================================\n');
        sleep(buffer)

        int_bpm = getpv(pv_name.sum);

        [bpm_select, int_bpm_ok] = selection_bpm(int_bpm, sum_lim, 5 * n_bpm);

        if sum(bpm_select) <= 1
            error('Only 1 BPM or none with good sum signal!')
        end
        
        n_bpm_select_old = sum(bpm_select);
       
        while int_bpm_ok(end) < sum_lim
            x_bpm = getpv(pv_name.orbx);
            y_bpm = getpv(pv_name.orby);

            setpv(pv_name.bpmx_select, double(bpm_select));
            setpv(pv_name.bpmy_select, double(bpm_select));
            sleep(tw);

            setpv(pv_name.n_sv, n_sv);

            if closes_orbit
              setpv(pv_name.reforbx, x_bpm(1:n_bpm))
              setpv(pv_name.reforby, y_bpm(1:n_bpm))
            end

            setpv(pv_name.calc_kicks, 1);
            setpv(pv_name.corr_fact_ch, fact_corr_x);
            setpv(pv_name.corr_fact_cv, fact_corr_y);
            sleep(tw);
            setpv(pv_name.apply_kicks, 3);

            fprintf('=================================================\n');
            fprintf('COLLECTING PULSES\n');
            fprintf('=================================================\n');
            sleep(buffer);

            int_bpm = getpv(pv_name.sum);

            [bpm_select, int_bpm_ok] = selection_bpm(int_bpm, sum_lim, n_bpm * ring_size);

            n_bpm_select_new = sum(bpm_select);

            if n_bpm_select_new < n_bpm_select_old
                cancel_kicks(pv_name.corr_fact_ch, pv_name.corr_fact_cv, pv_name.apply_kicks, tw, 'xy')
            else
                n_bpm_select_old = n_bpm_select_new;
            end

            n_sv = n_sv + 5;
        end

        fprintf('=================================================\n');
        fprintf('BEAM AT TURN # %i\n', ring_size + 1);
        fprintf('=================================================\n');
    end
end

function [bpm_select, int_bpm_ok] = selection_bpm(int_bpm, sum_lim, n_bpm)
    bpm_select = true(1, n_bpm);
    bpm_select(int_bpm < sum_lim) = 0;
    non_select = find(bpm_select == 0, 1, 'first');
    if ~isempty(non_select)
        bpm_select(non_select:end) = 0;
    end
    int_bpm_ok = int_bpm(bpm_select);
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
