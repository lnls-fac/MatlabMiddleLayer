function correct_orbit_SOFB(bpm, n_sv, n_turns)

% v_prefix = getenv('VACA_PREFIX');
ioc_prefix = ['BO-Glob:AP-SOFB:'];
% kicks_ch_pv = [ioc_prefix, 'KicksCH-Mon'];
% kicks_cv_pv = [ioc_prefix, 'KicksCV-Mon'];
% delta_kicks_ch_pv = [ioc_prefix, 'DeltaKicksCH-Mon'];
% delta_kicks_cv_pv = [ioc_prefix, 'DeltaKicksCV-Mon'];
bpmx_select_pv = [ioc_prefix, 'BPMXEnblList-SP'];
bpmy_select_pv = [ioc_prefix, 'BPMYEnblList-SP'];
orbx_pv = [ioc_prefix, 'OrbitMultiTurnX-Mon'];
orby_pv = [ioc_prefix, 'OrbitMultiTurnY-Mon'];
sum_pv = [ioc_prefix, 'OrbitsMultiTurnSum-Mon'];
n_sv_pv = [ioc_prefix, 'NumSingValues-SP'];
calc_kicks_pv = [ioc_prefix, 'CalcCorr-Cmd'];
apply_kicks_pv = [ioc_prefix, 'ApplyCorr-Cmd'];
corr_fact_ch_pv = [ioc_prefix, 'CorrFactorCH-SP'];
corr_fact_cv_pv = [ioc_prefix, 'CorrFactorCV-SP'];
buffer_pulse_pv = [ioc_prefix, 'OrbitSmoothNPnts-SP'];
multi_turn_acq = [ioc_prefix, 'OrbitMultiTurnIdx-SP'];

% inj_sept = findcells(ring, 'FamName', 'InjSept');
% ring = circshift(ring, [0, -(inj_sept -1)]);
% family = sirius_bo_family_data(ring);
% bpm = fam.BPM.ATIndex;
tw = 0.1;
f_pulse = 1/2;
tol1 = 0.8;
tol2 = 0.95;
n_corr = 1;
n_corr_lim = 20;
fact_corr_x = 0;
fact_corr_y = 0;
buffer = getpv(buffer_pulse_pv) * f_pulse + 1;

if isnan(buffer)
    error('Problem getting Number of Orbits for Smoothing PV')
end

setpv(n_sv_pv, n_sv)
setpv(multi_turn_acq, n_turns);

fprintf('=================================================\n');
fprintf('COLLECTING PULSES\n');
fprintf('=================================================\n');
sleep(buffer);

int_turns = getpv(sum_pv);
int_bpm_turns = int_turns(1:n_turns * length(bpm));
int_bpm_turns = reshape(int_bpm_turns, length(bpm), n_turns);
% ind_bad = find(int_bpm_turns < sum_min * tol2);

bpm_select = ones(length(bpm), 1);
setpv(bpmx_select_pv, bpm_select');
setpv(bpmy_select_pv, bpm_select');
sleep(tw);

x_bpm = getpv(orbx_pv);
y_bpm = getpv(orby_pv);
rms_orbit_x_bpm_old = nanstd(x_bpm);
rms_orbit_y_bpm_old = nanstd(y_bpm);

if isnan(rms_orbit_x_bpm_old) || isnan(rms_orbit_y_bpm_old)
    error('Problem getting SinglePass Orbit PV')
end

eff_init = mean(int_bpm_turns, 1);
eff_final = eff_init;
n_tsv = n_sv;
k = 1;
n_inc = 0;
stop_x = false; stop_y = false;
sv_change = false;
inc_x = true; inc_y = true;
rms_orbit_x_bpm_new = rms_orbit_x_bpm_old;
rms_orbit_y_bpm_new = rms_orbit_y_bpm_old;

while (inc_x || inc_y) || mean(eff_init) <= mean(eff_final) / tol1
    fprintf('=================================================\n');
    fprintf('TRAJECTORY RMS REDUCTION \n');
    fprintf('=================================================\n');
    eff_init = eff_final;

    if ~sv_change
        if ~stop_x
            rms_orbit_x_bpm_old = rms_orbit_x_bpm_new;
        end
        if ~stop_y
            rms_orbit_y_bpm_old = rms_orbit_y_bpm_new;
        end
    end
    setpv(n_sv_pv, n_tsv)
    sleep(tw)
    setpv(calc_kicks_pv, 1);
    sleep(tw);
    
    if inc_x && inc_y
        fprintf('HORIZONTAL AND VERTICAL CORRECTION \n');
        setpv(corr_fact_ch_pv, fact_corr_x);
        sleep(tw);
        setpv(corr_fact_cv_pv, fact_corr_y);
        sleep(tw);
        setpv(apply_kicks_pv, 3);
        fprintf('=================================================\n');
        fprintf('COLLECTING PULSES\n');
        fprintf('=================================================\n');
        sleep(buffer);
    elseif inc_x
        fprintf('HORIZONTAL CORRECTION \n');
        setpv(corr_fact_ch_pv, fact_corr_x);
        sleep(tw);
        % setpv(corr_fact_cv_pv, 0);
        % sleep(tw);
        setpv(apply_kicks_pv, 0);
        fprintf('=================================================\n');
        fprintf('COLLECTING PULSES\n');
        fprintf('=================================================\n');
        sleep(buffer);
    elseif inc_y
        fprintf('VERTICAL CORRECTION \n');
        % setpv(corr_fact_ch_pv, 0);
        % sleep(tw);
        setpv(corr_fact_cv_pv, fact_corr_y);
        sleep(tw);
        setpv(apply_kicks_pv, 1);
        fprintf('=================================================\n');
        fprintf('COLLECTING PULSES\n');
        fprintf('=================================================\n');
        sleep(buffer);
    end
    
    x_bpm = getpv(orbx_pv);
    y_bpm = getpv(orby_pv);
    int_turns = getpv(sum_pv);
    int_bpm_turns = int_turns(1:n_turns * length(bpm));
    int_bpm_turns = reshape(int_bpm_turns, length(bpm), n_turns);
    eff_final = mean(int_bpm_turns, 1);
    rms_orbit_x_bpm_new = nanstd(x_bpm);
    rms_orbit_y_bpm_new = nanstd(y_bpm);
    
    if ~stop_x
        inc_x = rms_orbit_x_bpm_new < rms_orbit_x_bpm_old / tol2;
        if ~inc_x
            cancel_kicks(corr_fact_ch_pv, corr_fact_cv_pv, apply_kicks_pv, tw, 'x')
            stop_x = true;
        end
    end
    
    if ~stop_y
        inc_y = rms_orbit_y_bpm_new < rms_orbit_y_bpm_old / tol2;
        if ~inc_y
            cancel_kicks(corr_fact_ch_pv, corr_fact_cv_pv, apply_kicks_pv, tw, 'y')
            stop_y = true;
        end
    end
    
    if ~inc_x && ~inc_y
        if n_inc == 0
            fprintf('FIRST TURN CORRECTION IS DONE!\n');
            return
        else
            n_tsv = n_sv + k * 10;
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
        
