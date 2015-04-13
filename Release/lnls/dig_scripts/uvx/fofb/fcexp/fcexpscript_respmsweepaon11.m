function [aon11_gap_phase, tunes] = fcexpscript_respmsweepaon11

deltarf = 1e-3; % MHz
gap_vel = 60;
phase_vel = 30;

aon11_gap_phase = [[repmat(22,9,1); repmat(26,9,1); repmat(29,9,1); repmat(33, 9,1)] ...
                   repmat([-25; -15; -10; -5; 0; 5; 10; 15; 25], 4,1) ];

switch2online;

aon11_gap0 = getpv('AON11GAP_SP');
aon11_phase0 = getpv('AON11FASE_SP');
aon11_gapv0 = getpv('AON11VGAP_SP');
aon11_phasev0 = getpv('AON11VFASE_SP');

setpv('AON11VGAP_SP', gap_vel);
setpv('AON11VFASE_SP', phase_vel);

tunes = zeros(size(aon11_gap_phase,1), 2);

lnls1_fast_orbcorr_enable_excitation;

for i=1:size(aon11_gap_phase,1)
    lnls1_fast_orbcorr_on;

    % Move AON11 undulator gap
    aon11_gap_sp = getpv('AON11GAP_SP');
    aon11_gap_am = getpv('AON11GAP_AM');
    if aon11_gap_sp ~= aon11_gap_phase(i,1)
        setpv('AON11GAP_SP', aon11_gap_phase(i,1));
        while true
            aon11_gap_prev = aon11_gap_am;
            pause(3.5);
            aon11_gap_am = getpv('AON11GAP_AM');
            if aon11_gap_prev == aon11_gap_am
                break;
            end
        end
    end
    
    % Move AON11 undulator phase
    aon11_phase_sp = getpv('AON11FASE_SP');
    aon11_phase_am = getpv('AON11FASE_AM');
    if aon11_phase_sp ~= aon11_gap_phase(i,2)
        setpv('AON11FASE_SP', aon11_gap_phase(i,2));
        while true
            aon11_phase_prev = aon11_phase_am;
            pause(3.5);
            aon11_phase_am = getpv('AON11FASE_AM');
            if aon11_phase_prev == aon11_phase_am
                break;
            end
        end
    end
    
    % Store measured betatron tunes
    tunes(i,:) = gettune;
    
    % Response matrix measurement
    uvxcorrectorbit;
    fcexprespmsin(500+i);
    fcwaitbuffer;

    % Response matrix measurement using the sine method
    uvxcorrectorbit;
    fcexprespm(600+i);
    fcwaitbuffer;
    
    % Dispersion orbit measurement (steps on RF frequency)
    uvxcorrectorbit;
    fcexpmarker(700+i);
    uvxrfresp;
    fcexpmarker(800+i);
end

lnls1_fast_orbcorr_disable_excitation;

getpv('AON11GAP_SP', aon11_gap0);
getpv('AON11FASE_SP', aon11_phase0);
getpv('AON11VGAP_SP', aon11_gapv0);
getpv('AON11VFASE_SP', aon11_phasev0);
