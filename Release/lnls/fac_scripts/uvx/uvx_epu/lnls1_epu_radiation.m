function rad = lnls1_epu_radiation(epu, energy)

const = lnls_constants;

  % flux density
Np      = 56;
echarge = abs(const.q0);
alpha   = const.alpha;
dW_W    = 0.1/100;
e0      = const.E0/1000;
gamma   = energy / e0;
i0      = 0.1;

period     = 50;
amplitudes = lnls1_epu_field_amplitude(epu, period);
K          = calc_k(amplitudes, period);
kmod = sqrt(sum(K.^2));
vx = [1 0];
vz = [0 1];

e1 = (vx + 1i * vz)/sqrt(2);
e2 = (vx - 1i * vz)/sqrt(2);
theta0 = atan2(amplitudes(2), sign(epu.model.phase_csd) * amplitudes(1));
s = sin(theta0);
c = cos(theta0);
    
for h=1:5
    rad(h).harmonic = 2*(h-1) + 1;
    rad(h).gap_upstream     = epu.model.gap_upstream;
    rad(h).gap_downstream   = epu.model.gap_downstream;
    rad(h).phase_csd        = epu.model.phase_csd;
    rad(h).phase_cie        = epu.model.phase_cie;
    rad(h).field_amplitudes = amplitudes;
    rad(h).K                = K;
    rad(h).energy           = rad(h).harmonic * 949.63 * energy^2 / ((period/10) * ( 1 + 0.5*kmod^2));
    u  = rad(h).harmonic * kmod^2 * cos(2*theta0) / (4 * (1 + kmod^2/2));
    Jn = besseli((rad(h).harmonic-1)/2, u);
    Jp = besseli((rad(h).harmonic+1)/2, u);
    F = s * (Jn - Jp) * (1i * vx) - c * (Jn + Jp) * vz;
    % polarization
    rad(h).linear_polarization = (abs(vx*F')^2 - abs(vz*F')^2)/(abs(vx*F')^2 + abs(vz*F')^2);
    rad(h).circular_polarization = -(abs(conj(e1)*F')^2 - abs(conj(e2)*F')^2)/(abs(conj(e1)*F')^2 + abs(conj(e2)*F')^2);
    % flux
    sigmar  = sqrt((1 + 0.5 * kmod^2)/(2*rad(h).harmonic*Np)) / gamma;
    omega   = 2 * pi * sigmar^2;
    n0 = (i0/echarge)*alpha*dW_W*omega*gamma^2;
    rad(h).flux = n0 * Np^2 * (rad(h).harmonic * kmod / (1 + 0.5*kmod^2))^2 * (F*F');


end

function k = calc_k(amplitudes, period)

k = 0.934 * amplitudes * (period/10);