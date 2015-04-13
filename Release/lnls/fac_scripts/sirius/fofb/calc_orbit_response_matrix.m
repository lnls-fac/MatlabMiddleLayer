function respm = calc_orbit_response_matrix(the_ring, hcm_ind, vcm_ind, bpm_ind, flags)

delta_kick = 0.0001;

the_ring_original = the_ring;

% horizontal
Mxx = zeros(length(bpm_ind), length(hcm_ind));
Myx = zeros(length(bpm_ind), length(hcm_ind));
for i=1:length(hcm_ind)
    the_ring = the_ring_original;
    the_ring{hcm_ind(i)}.KickAngle(1) = the_ring{hcm_ind(i)}.KickAngle(1) + delta_kick / 2;
    orbp = calc_closed_orbit(the_ring, flags);
    the_ring = the_ring_original;
    the_ring{hcm_ind(i)}.KickAngle(1) = the_ring{hcm_ind(i)}.KickAngle(1) - delta_kick / 2;
    orbn = calc_closed_orbit(the_ring, flags);
    Mxx(:,i) = (orbp(1,bpm_ind) - orbn(1,bpm_ind)) / delta_kick;
    Myx(:,i) = (orbp(3,bpm_ind) - orbn(3,bpm_ind)) / delta_kick;
end
    
% vertical
Mxy = zeros(length(bpm_ind), length(vcm_ind));
Myy = zeros(length(bpm_ind), length(vcm_ind));
for i=1:length(vcm_ind)
    the_ring = the_ring_original;
    the_ring{vcm_ind(i)}.KickAngle(2) = the_ring{vcm_ind(i)}.KickAngle(2) + delta_kick / 2;
    orbp = calc_closed_orbit(the_ring, flags);
    the_ring = the_ring_original;
    the_ring{vcm_ind(i)}.KickAngle(2) = the_ring{vcm_ind(i)}.KickAngle(2) - delta_kick / 2;
    orbn = calc_closed_orbit(the_ring, flags);
    Mxy(:,i) = (orbp(1,bpm_ind) - orbn(1,bpm_ind)) / delta_kick;
    Myy(:,i) = (orbp(3,bpm_ind) - orbn(3,bpm_ind)) / delta_kick;
end


respm.Mxx = Mxx;
respm.Myx = Myx;
respm.Mxy = Mxy;
respm.Myy = Myy;

[U,S,V] = svd(Mxx, 'econ');
respm.Ux = U;
respm.Sx = diag(S);
respm.Vx = V;

[U,S,V] = svd(Myy, 'econ');
respm.Uy = U;
respm.Sy = diag(S);
respm.Vy = V;


