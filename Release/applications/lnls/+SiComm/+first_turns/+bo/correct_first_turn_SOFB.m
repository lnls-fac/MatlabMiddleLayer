function correct_first_turn_SOFB(bpm, n_sv, sum_min)

% v_prefix = getenv('VACA_PREFIX');
ioc_prefix = ['BO-Glob:AP-SOFB:'];
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
pv_name.buffer_pulse = [ioc_prefix, 'SmoothNrPts-SP'];

% inj_sept = findcells(ring, 'FamName', 'InjSept');
% ring = circshift(ring, [0, -(inj_sept -1)]);
% family = sirius_bo_family_data(ring);
% bpm = fam.BPM.ATIndex;
tw = 0.1;
f_pulse = 0.5;
tol1 = 0.5;
tol2 = 0.95;
n_corr = 1;
n_corr_lim = 20;
fact_corr_x = 100;
fact_corr_y = 100;
buffer = getpv(pv_name.buffer_pulse) * f_pulse;

if isnan(buffer)
    error('Problem getting Number of Orbits for Smoothing PV')
end

setpv(pv_name.n_sv, n_sv)

fprintf('=================================================\n');
fprintf('COLLECTING PULSES\n');
fprintf('=================================================\n');
sleep(buffer);

int_bpm = getpv(pv_name.sum);
if all(isnan(int_bpm))
   error('Problem getting SinglePass Sum PV')
end

ind_bad = find(int_bpm < sum_min * tol2);

if ~isempty(ind_bad)
    bpm_int_ok = bpm(1:ind_bad(1)-1);
else
    bpm_int_ok = bpm;
end

[~, ind_ok_bpm] = intersect(bpm, bpm_int_ok);
bpm_select = false(length(bpm), 1);
bpm_select(ind_ok_bpm) = 1;
int_bpm_ok = int_bpm(bpm_select);
int_bpm_bad = int_bpm(~bpm_select);
int_init_ok = nanmean(int_bpm_ok);
int_final_ok = int_init_ok / tol1;

if sum(bpm_select) == 1
   error('Only 1 BPM with good sum signal!')
end

if ~isempty(int_bpm_bad)
    int_init_bad = nanmean(int_bpm_bad);
else
    int_init_bad = 0;
end

int_final_bad = int_init_bad / tol1;
param_ok = true;
param_bad = true;
fake = true;

while fake % (param_ok || param_bad) && int_bpm(end) < sum_min
    int_init_ok = int_final_ok;
    int_init_bad = int_final_bad;

    setpv(pv_name.bpmx_select, double(bpm_select'));
    setpv(pv_name.bpmy_select, double(bpm_select'));
    sleep(tw);

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
    if all(isnan(int_bpm))
        error('Problem getting SinglePass Sum PV')
    end

    ind_bad = find(int_bpm < sum_min * tol2);

    if ~isempty(ind_bad)
        bpm_int_ok = bpm(1:ind_bad(1)-1);
    else
        bpm_int_ok = bpm;
    end

    [~, ind_ok_bpm] = intersect(bpm, bpm_int_ok);
    bpm_select = false(length(bpm), 1);
    bpm_select(ind_ok_bpm) = 1;
    int_bpm_ok = int_bpm(bpm_select);
    int_bpm_bad = int_bpm(~bpm_select);
    int_final_ok = nanmean(int_bpm_ok);

    param_ok = int_final_ok >= int_init_ok * tol1;

    if ~isempty(int_bpm_bad)
        int_final_bad = nanmean(int_bpm_bad);
        param_bad = int_final_bad >= int_init_bad * tol1;
    else
        int_final_bad = 0;
        param_bad = false;
    end

    if sum(bpm_select) == 1
       error('Only 1 BPM with good sum signal!')
    end

    if n_corr > n_corr_lim
        cancel_kicks(pv_name.corr_fact_ch, pv_name.corr_fact_cv, pv_name.apply_kicks, tw, 'xy')
        n_sv = n_sv - 1;
        setpv(pv_name.n_sv, n_sv)
        fprintf('=================================================\n');
        fprintf('COLLECTING PULSES\n');
        fprintf('=================================================\n');
        sleep(buffer)
        int_bpm = getpv(pv_name.sum);
        % eff_lim = int_bpm(1);
        if all(isnan(int_bpm))
            error('Problem getting SinglePass Sum PV')
        end
        warning('Number of Singular Values reduced')
       if n_sv <= 1
           error('Number of Singular Values is 1!')
       end
    end
    n_corr = n_corr + 1;
end

fprintf('=================================================\n');
fprintf('FIRST TURN!!! \n');
fprintf('=================================================\n');

bpm_select = ones(length(bpm), 1);
setpv(pv_name.bpmx_select, bpm_select');
setpv(pv_name.bpmy_select, bpm_select');
sleep(tw);

x_bpm = getpv(pv_name.orbx);
y_bpm = getpv(pv_name.orby);
rms_orbit_x_bpm_old = nanstd(x_bpm);
rms_orbit_y_bpm_old = nanstd(y_bpm);

if isnan(rms_orbit_x_bpm_old) || isnan(rms_orbit_y_bpm_old)
    error('Problem getting SinglePass Orbit PV')
end

eff_ft_init = mean(int_bpm);
n_tsv = n_sv;
k = 1;
n_inc = 0;
stop_x = false; stop_y = false;
sv_change = false;
inc_x = true; inc_y = true;
rms_orbit_x_bpm_new = rms_orbit_x_bpm_old;
rms_orbit_y_bpm_new = rms_orbit_y_bpm_old;

while inc_x || inc_y
    fprintf('=================================================\n');
    fprintf('TRAJECTORY RMS REDUCTION \n');
    fprintf('=================================================\n');

    if ~sv_change
        if ~stop_x
            rms_orbit_x_bpm_old = rms_orbit_x_bpm_new;
        end
        if ~stop_y
            rms_orbit_y_bpm_old = rms_orbit_y_bpm_new;
        end
    end
    setpv(pv_name.n_sv, n_tsv)
    sleep(tw)
    setpv(pv_name.calc_kicks, 1);
    sleep(tw);

    if inc_x && inc_y
        fprintf('HORIZONTAL AND VERTICAL CORRECTION \n');
        setpv(pv_name.corr_fact_ch, fact_corr_x);
        sleep(tw);
        setpv(pv_name.corr_fact_cv, fact_corr_y);
        sleep(tw);
        setpv(pv_name.apply_kicks, 3);
        fprintf('=================================================\n');
        fprintf('COLLECTING PULSES\n');
        fprintf('=================================================\n');
        sleep(buffer);
    elseif inc_x
        fprintf('HORIZONTAL CORRECTION \n');
        setpv(pv_name.corr_fact_ch, fact_corr_x);
        sleep(tw);
        % setpv(corr_fact_cv_pv, 0);
        % sleep(tw);
        setpv(pv_name.apply_kicks, 0);
        fprintf('=================================================\n');
        fprintf('COLLECTING PULSES\n');
        fprintf('=================================================\n');
        sleep(buffer);
    elseif inc_y
        fprintf('VERTICAL CORRECTION \n');
        % setpv(corr_fact_ch_pv, 0);
        % sleep(tw);
        setpv(pv_name.corr_fact_cv, fact_corr_y);
        sleep(tw);
        setpv(pv_name.apply_kicks, 1);
        fprintf('=================================================\n');
        fprintf('COLLECTING PULSES\n');
        fprintf('=================================================\n');
        sleep(buffer);
    end

    x_bpm = getpv(pv_name.orbx);
    y_bpm = getpv(pv_name.orby);
    int_bpm = getpv(pv_name.sum);
    rms_orbit_x_bpm_new = nanstd(x_bpm);
    rms_orbit_y_bpm_new = nanstd(y_bpm);

    if nanmean(int_bpm) < tol1 * eff_ft_init
        cancel_kicks(pv_name.corr_fact_ch, pv_name.corr_fact_cv, pv_name.apply_kicks, tw)
        fprintf('IT IS NOT POSSIBLE TO REDUCE TRAJECTORY RMS WITHOUT LOSING FIRST TURN \n');
        return
    end

    if ~stop_x
        inc_x = rms_orbit_x_bpm_new < rms_orbit_x_bpm_old / tol2;
        if ~inc_x
            cancel_kicks(pv_name.corr_fact_ch, pv_name.corr_fact_cv, pv_name.apply_kicks, tw, 'x')
            stop_x = true;
        end
    end

    if ~stop_y
        inc_y = rms_orbit_y_bpm_new < rms_orbit_y_bpm_old / tol2;
        if ~inc_y
            cancel_kicks(pv_name.corr_fact_ch, pv_name.corr_fact_cv, pv_name.apply_kicks, tw, 'y')
            stop_y = true;
        end
    end

    if ~inc_x && ~inc_y
        if n_inc == 0
            fprintf('FIRST TURN CORRECTION IS DONE!\n');
            return
        else
            n_tsv = n_sv + k * 5;
            inc_x = true; inc_y = true;
            stop_x = false; stop_y = false;
            k = k+1;
            n_inc = 0;
            sv_change = true;
            fprintf('Number of Singular Values: %i \n', n_tsv);
            continue
        end
    end
    n_inc = n_inc + 1;
    sv_change = false;
end
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
