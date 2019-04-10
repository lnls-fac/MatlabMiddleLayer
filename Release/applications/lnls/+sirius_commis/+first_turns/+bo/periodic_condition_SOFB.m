function periodic_condition_SOFB(n_bpm, n_sv, sum_lim, ring_size)

% sirius_commis.common.initializations();

v_prefix = getenv('VACA_PREFIX');
ioc_prefix = [v_prefix, 'BO-Glob:AP-SOFB:'];
% kicks_ch_pv = [ioc_prefix, 'KicksCH-Mon'];
% kicks_cv_pv = [ioc_prefix, 'KicksCV-Mon'];
% delta_kicks_ch_pv = [ioc_prefix, 'DeltaKicksCH-Mon'];
% delta_kicks_cv_pv = [ioc_prefix, 'DeltaKicksCV-Mon'];
bpmx_select_pv = [ioc_prefix, 'BPMXEnblList-SP'];
bpmy_select_pv = [ioc_prefix, 'BPMYEnblList-SP'];
orbx_pv = [ioc_prefix, 'SPassOrbX-Mon'];
orby_pv = [ioc_prefix, 'SPassOrbY-Mon'];
sum_pv = [ioc_prefix, 'SPassSum-Mon'];
n_sv_pv = [ioc_prefix, 'NrSingValues-SP'];
calc_kicks_pv = [ioc_prefix, 'CalcDelta-Cmd'];
apply_kicks_pv = [ioc_prefix, 'ApplyDelta-Cmd'];
corr_fact_ch_pv = [ioc_prefix, 'DeltaFactorCH-SP'];
corr_fact_cv_pv = [ioc_prefix, 'DeltaFactorCV-SP'];
buffer_pulse_pv = [ioc_prefix, 'SmoothNrPts-RB'];
ring_size_pv = [ioc_prefix, 'RingSize-SP'];
% reforbx_pv = [ioc_prefix, 'RefOrbX-SP'];
% reforby_pv = [ioc_prefix, 'RefOrbY-SP'];
    
tw = 0.1;
f_pulse = 0.5;
% tol1 = 0.5;
% tol2 = 0.95;
% n_corr = 1;
% n_corr_lim = 20;
fact_corr_x = 100;
fact_corr_y = 100;
buffer = getpv(buffer_pulse_pv) * f_pulse + 1;

setpv(ring_size_pv, ring_size);

fprintf('=================================================\n');
fprintf('COLLECTING PULSES\n');
fprintf('=================================================\n');
sleep(buffer)

int_bpm = getpv(sum_pv);

[bpm_select, int_bpm_ok] = selection_bpm(int_bpm, sum_lim, 5 * n_bpm);  

if sum(bpm_select) <= 1
     error('Only 1 BPM or none with good sum signal!')
end

n_bpm_select_old = sum(bpm_select);

while int_bpm_ok(end) < sum_lim
    
    setpv(bpmx_select_pv, double(bpm_select));
    setpv(bpmy_select_pv, double(bpm_select));
    sleep(tw);
    
    setpv(n_sv_pv, n_sv);
    setpv(calc_kicks_pv, 1);
    setpv(corr_fact_ch_pv, fact_corr_x);
    setpv(corr_fact_cv_pv, fact_corr_y);
    sleep(tw);
    setpv(apply_kicks_pv, 3);
    
    fprintf('=================================================\n');
    fprintf('COLLECTING PULSES\n');
    fprintf('=================================================\n');
    sleep(buffer);

    int_bpm = getpv(sum_pv);
    
    [bpm_select, int_bpm_ok] = selection_bpm(int_bpm, sum_lim, n_bpm * ring_size);
    
    n_bpm_select_new = sum(bpm_select);
    
    if n_bpm_select_new < n_bpm_select_old
        cancel_kicks(corr_fact_ch_pv, corr_fact_cv_pv, apply_kicks_pv, tw, 'xy')
    end
    
    n_sv = n_sv + 5;
end

fprintf('=================================================\n');
fprintf('CHECK IF THE BEAM REACHED TURN # %i\n', ring_size + 1);
fprintf('=================================================\n');

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

