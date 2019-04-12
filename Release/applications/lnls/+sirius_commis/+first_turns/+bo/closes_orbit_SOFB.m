function [machine, count_turns] = closes_orbit_SOFB(machine, param, param_errors, n_part, n_pulse, n_sv, n_turns)

% sirius_commis.common.initializations();

fam = sirius_bo_family_data(machine);
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;

machine = setcellstruct(machine, 'PolynomB', fam.SD.ATIndex, 0, 1, 3);
machine = setcellstruct(machine, 'PolynomB', fam.SF.ATIndex, 0, 1, 3);

theta_x0 = lnls_get_kickangle(machine, ch, 'x')';
theta_y0 = lnls_get_kickangle(machine, cv, 'y')';
theta_x = theta_x0;
theta_y = theta_y0;
gr_mach_x = zeros(length(ch), 1);
gr_mach_y = zeros(length(cv), 1);
n_bpm = length(bpm);
n_bpm_turns = n_bpm * n_turns;
% bpm_idx = [1:1:n_bpm_turns];
% rxy_bpm = zeros(1, n_bpm_turns);

[count_turns, ~, ~,  ~, ~, ~, ~, r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);

corr_lim = 5*300e-6;
tw = 0.1;

eff_lim = 0.10;

n_cor = 1;
% n_fcod = true;
inc_x = true; inc_y = true;
% ft_data.error = false;

% int_bpm = squeeze(int_bpm);
% int_bpm = reshape(int_bpm', n_bpm_turns, 1);
% lost = find(int_bpm > eff_lim);

% rx = squeeze(r_bpm(:, 1, :));
% ry = squeeze(r_bpm(:, 2, :));

% rxx = reshape(rx', n_bpm_turns, 1);
% ryy = reshape(ry', n_bpm_turns, 1);

% ref_orbitx = repmat(rxx(1:n_bpm), n_turns, 1);
% ref_orbity = repmat(ryy(1:n_bpm), n_turns, 1);
% ref_orbit = [ref_orbitx; ref_orbity];
    int_bpm = squeeze(int_bpm);
    int_bpm = reshape(int_bpm', n_bpm_turns, 1);
    % if int_bpm(50) < eff_lim
    %     return
    % end
    rx = squeeze(r_bpm(:, 1, :));
    ry = squeeze(r_bpm(:, 2, :));

    rxx = reshape(rx', n_bpm_turns, 1);
    ryy = reshape(ry', n_bpm_turns, 1);

    bpm_select = int_bpm > eff_lim;
    bpm_ext = zeros(1, n_bpm_turns);
    bpm_ext(1:length(bpm_select)) = bpm_select;
    r_bpm_turn = [rxx; ryy];
    
    ref_old_ft(1,:) = r_bpm_turn(1:50)'.*1e6;
    ref_old_ft(2,:) = r_bpm_turn(251:300)'.*1e6;
    
    if sum(sum(isnan(ref_old_ft))) > 0 || int_bpm(50) < eff_lim
        ref_old_ft = 0.* ref_old_ft;
        ref_old_ft(isnan(ref_old_ft)) = 0;
    end
    
    ct_old = count_turns;
    
    theta_x_ft = lnls_get_kickangle(machine, ch, 'x');
    theta_y_ft = lnls_get_kickangle(machine, cv, 'y');
    ref_set = 0;   
    
    
while count_turns < n_turns %int_bpm(end) < eff_lim    
    
    if n_cor == 1
        [r_bpm_turn, bpm_ext] = reshape_ringsize(int_bpm, n_bpm_turns, r_bpm, eff_lim);
    end
    
    ref_old(1,:) = r_bpm_turn(1:50)'.*1e6;
    ref_old(2,:) = r_bpm_turn(251:300)'.*1e6;
    
    if count_turns < 1
        [delta_ch, delta_cv] = calc_kicks(r_bpm_turn, n_sv, tw, bpm_ext, count_turns+1, 0.* ref_old_ft, n_cor);
    else
        [delta_ch, delta_cv] = calc_kicks(r_bpm_turn, n_sv, tw, bpm_ext, count_turns+1, ref_old_ft, n_cor);
    end
        
    % rmsx = rms(delta_ch);
    % rmsy = rms(delta_cv);
    
    % delta_ch(abs(delta_ch) > rmsx) = 0;
    % delta_cv(abs(delta_cv) > rmsy) = 0;
    
    % if ref_new ~= ref_old_ft
    %     ref_old_ft = ref_new;
    % end
    % kicks = [theta_x; theta_y; 0] + [delta_ch'; delta_cv'; 0];
    % theta_x = kicks(1:length(ch));
    % theta_y = kicks(length(ch)+1:end-1);
    % figure; plot(theta_x.*1e6, '-o'); hold on; plot((theta_x + delta_ch').*1e6, '-o'); legend('Kick', 'Kick + Delta Kick'); title('CH');
    % figure; plot(theta_y.*1e6, '-o'); hold on; plot((theta_y + delta_cv').*1e6, '-o'); legend('Kick', 'Kick + Delta Kick'); title('CV');
    theta_x = theta_x + delta_ch';
    theta_y = theta_y + delta_cv';
    
    % theta_x(theta_x > rms(theta_x)) = theta_x(theta_x > rms(theta_x))/2;
    % theta_y(theta_y > rms(theta_y)) = theta_y(theta_y > rms(theta_y))/2;
        
    over_kick_x = abs(theta_x) > corr_lim;
    if any(over_kick_x)
        warning('Horizontal corrector kick greater than maximum')
        gr_mach_x(over_kick_x) = 1;
        theta_x(over_kick_x) =  sign(theta_x(over_kick_x)) * corr_lim;
    end
    
    over_kick_y = abs(theta_y) > corr_lim;
    if any(over_kick_y)
        warning('Vertical corrector kick greater than maximum')
        gr_mach_y(over_kick_y) = 1;
        theta_x(over_kick_y) =  sign(theta_x(over_kick_y)) * corr_lim;
    end
      
    if inc_x 
        machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
    end
    
    if inc_y
        machine = lnls_set_kickangle(machine, theta_y, cv, 'y');
    end
       
    
    [count_turns, ~, ~,  ~, ~, ~, ~, r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);
    
    [r_bpm_turn, bpm_ext, int_bpm] = reshape_ringsize(int_bpm, n_bpm_turns, r_bpm, eff_lim);
    
    if int_bpm(50) > 0.30 && ~ref_set
        ref_old_ft(1,:) = r_bpm_turn(1:50)'.*1e6;
        ref_old_ft(2,:) = r_bpm_turn(251:300)'.*1e6;
        ref_set = 1;
    end
    
    ct_new = count_turns;
    
    if ct_new < ct_old
        %{
        if ct_new < 1
            theta_x = theta_x_ft';
            theta_y = theta_y_ft';
        else
            theta_x = theta_x - delta_ch';
            theta_y = theta_y - delta_cv';
        end
        %}
        machine = lnls_set_kickangle(machine, theta_x_ft, ch, 'x');
        machine = lnls_set_kickangle(machine, theta_y_ft, cv, 'y');
        [count_turns, ~, ~,  ~, ~, ~, ~, r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);
        n_sv = n_sv - 1;
        % continue
    elseif ct_new > ct_old
        theta_x_ft = theta_x;
        theta_y_ft = theta_y;
        ct_old = ct_new;
    end
        
    if n_cor > 25
       n_sv = n_sv - 20;
       theta_x = theta_x - delta_ch';
       theta_y = theta_y - delta_cv';
       machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
       machine = lnls_set_kickangle(machine, theta_y, cv, 'y');
       n_cor = 1;
       warning('Number of Singular Values increased!')
       % if n_sv <= 1
           warning('Problems in Singular Values')
           ft_data.machine = machine;
           ft_data.error = true;
           ft_data.n_svd = n_sv;
           return
       % end
    end
    n_cor = n_cor + 1;
    n_sv = n_sv + 2;
end
end

function [delta_ch, delta_cv, ref_old] = calc_kicks(r_bpm, n_sv, tw, bpm_select, n_turns, ref_old, n_iter)
    v_prefix = getenv('VACA_PREFIX');
    ioc_prefix = [v_prefix, 'BO-Glob:AP-SOFB:'];
    delta_kicks_ch_pv = [ioc_prefix, 'DeltaKickCH-Mon'];
    delta_kicks_cv_pv = [ioc_prefix, 'DeltaKickCV-Mon'];
    bpmx_select_pv = [ioc_prefix, 'BPMXEnblList-SP'];
    bpmy_select_pv = [ioc_prefix, 'BPMYEnblList-SP'];
    orbx_pv = [ioc_prefix, 'OfflineOrbX-SP'];
    orby_pv = [ioc_prefix, 'OfflineOrbY-SP'];
    n_sv_pv = [ioc_prefix, 'NrSingValues-SP'];
    calc_kicks_pv = [ioc_prefix, 'CalcDelta-Cmd'];
    ring_size_pv = [ioc_prefix, 'RingSize-SP'];
    reforbx_pv = [ioc_prefix, 'RefOrbX-SP'];
    reforby_pv = [ioc_prefix, 'RefOrbY-SP'];
    
    setpv(ring_size_pv, n_turns);
    sleep(tw);

    if exist('bpm_select', 'var')
        setpv(bpmx_select_pv, bpm_select);
        sleep(tw);
        setpv(bpmy_select_pv, bpm_select);
        sleep(tw);
    end

    setpv(n_sv_pv, n_sv);
    sleep(tw);
    r_bpm(isnan(r_bpm)) = 0;
    
    %{
    if n_iter == 1
        refx = r_bpm(1:50)'.*1e6;
        refy = r_bpm(251:300)'.*1e6;
        
        refx = prevent_nan(refx);
        refy = prevent_nan(refy);
        
        setpv(reforbx_pv, refx);
        sleep(tw);
        setpv(reforby_pv, refy);
        sleep(tw);
    end
    %}
    
    setpv(reforbx_pv, 0.*ref_old(1,:));
    sleep(tw);
    setpv(reforby_pv, 0.*ref_old(2,:));
    sleep(tw);
    
    
    x_bpm = r_bpm(1:size(r_bpm)/2)' .* 1e6;
    y_bpm = r_bpm(size(r_bpm)/2+1:end)' .* 1e6;
    
    x_bpm = prevent_nan(x_bpm);
    y_bpm = prevent_nan(y_bpm);
    
    setpv(orbx_pv, x_bpm);
    setpv(orby_pv, y_bpm); 
    
%{
    if n_turns > 1
        refx = r_bpm(1:50)'.*1e6;
        refy = r_bpm(251:300)'.*1e6;
        
        refx = prevent_nan(refx);
        refy = prevent_nan(refy);
        
        if true % rms(refx) < rms(ref_old(1, :))  
            setpv(reforbx_pv, refx);
            sleep(tw);
            ref_old(1,:) = refx;
        else
            setpv(reforbx_pv, ref_old(1, :));
            sleep(tw);
        end
        if true % rms(refy) < rms(ref_old(2, :))
            setpv(reforby_pv, refy);
            sleep(tw);
            ref_old(2,:) = refy;
        else
            setpv(reforbx_pv, ref_old(2, :));
            sleep(tw);
        end
    end
%}  
    sleep(tw);
    setpv(calc_kicks_pv, 1);
    sleep(tw);
    
    delta_ch = getpv(delta_kicks_ch_pv) .* 1e-6;
    delta_cv = getpv(delta_kicks_cv_pv) .* 1e-6;
end

function [r_bpm_turn, bpm_ext, int_bpm] = reshape_ringsize(int_bpm, n_bpm_turns, r_bpm, eff_lim)
    int_bpm = squeeze(int_bpm);
    int_bpm = reshape(int_bpm', n_bpm_turns, 1);
    % lost = find(int_bpm > eff_lim);

    rx = squeeze(r_bpm(:, 1, :));
    ry = squeeze(r_bpm(:, 2, :));

    rxx = reshape(rx', n_bpm_turns, 1);
    ryy = reshape(ry', n_bpm_turns, 1);

    % ref_orbitx = repmat(rxx(1:n_bpm), n_turns, 1);
    % ref_orbity = repmat(ryy(1:n_bpm), n_turns, 1);
    % ref_orbit = [ref_orbitx; ref_orbity];

    % rxx(int_bpm < eff_lim) = 0;
    % ryy(int_bpm < eff_lim) = 0;
    bpm_select = int_bpm > eff_lim;
    bpm_ext = zeros(1, n_bpm_turns);
    bpm_ext(1:length(bpm_select)) = bpm_select;
    r_bpm_turn = [rxx; ryy];
end

function v_out = prevent_nan(v_in)
v_out = v_in;
if sum(isnan(v_in)) > 0
    v_out(isnan(v_in)) = 0; 
end
end
        
