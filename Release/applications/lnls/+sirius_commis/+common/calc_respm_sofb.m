function [respm_sofb4D_traj, respm_sofb4D, respm_sofb6D] = calc_respm_sofb(acc)

flag_tb = false;
flag_bo = false;
flag_ts = false;
flag_si = false;
flag_cav = false;

if strcmp(acc, 'TB')
    flag_tb = true;
    sirius('TB')
    ring = sirius_tb_lattice();
    spect = findcells(ring, 'FamName', 'Spect');
    % bpm = findcells(ring, 'FamName', 'BPM');
    ring_new = ring(spect(end)+1:end);
    fam = sirius_tb_family_data(ring_new);
elseif strcmp(acc, 'BO')
    flag_bo = true;
    flag_cav = true;
    sirius('BO')
    ring = sirius_bo_lattice();
    inj_sept = findcells(ring, 'FamName', 'InjSept');
    ring_new = circshift(ring, [0, -(inj_sept - 1)]);
    fam = sirius_bo_family_data(ring_new);
    ring_new = setcavity('off', ring_new);
elseif strcmp(acc, 'TS')
    flag_ts = true;
elseif strcmp(acc, 'SI')
    flag_si = true;
    flag_cav = true;
    sirius('SI')
    ring = sirius_si_lattice();
    inj_sept = findcells(ring, 'FamName', 'InjSeptF');
    ring_new = circshift(ring, [0, -(inj_sept - 1)]);
    fam = sirius_si_family_data(ring_new);
    ring_new = setcavity('off', ring_new);
else
    error('Set the accelerator name: TB, BO, TS or SI')
end

if flag_cav
    ring_cav = setcavity('on', ring_new);
    respm6D = calc_respm_cod(ring_cav, fam.BPM.ATIndex, fam.CH.ATIndex, fam.CV.ATIndex);
    respm6D = respm6D.respm;
    respm_sofb6D = [respm6D.mxx, respm6D.mxy; respm6D.myx, respm6D.myy];
    df = 1e3;
    cav = findcells(ring_cav, 'Frequency');
    cav_struct = ring_cav(cav);
    f0 = cav_struct{1}.Frequency;
    fp = f0 + df;
    fm = f0 - df;
    ring_cavp = setcellstruct(ring_cav, 'Frequency', cav, fp);
    ring_cavm = setcellstruct(ring_cav, 'Frequency', cav, fm);

    % orbit0 = findorbit6(ring_cav, fam.BPM.ATIndex);
    orbitp = findorbit6(ring_cavp, fam.BPM.ATIndex);
    orbitm = findorbit6(ring_cavm, fam.BPM.ATIndex);

    dif_orbit = 1e6 * (orbitp - orbitm) ./ (2 * df);
    
    m_rf = [dif_orbit(1, :), dif_orbit(3, :)];
    respm_sofb6D = [respm_sofb6D, m_rf'];
    if flag_tb
        hdf5write('respm_sofb_TB6D.h5', '/Points', respm_sofb6D);
    elseif flag_bo
        hdf5write('respm_sofb_BO6D.h5', '/Points', respm_sofb6D);
    elseif flag_ts
        hdf5write('respm_sofb_TS6D.h5', '/Points', respm_sofb6D);
    elseif flag_si
        hdf5write('respm_sofb_SI6D.h5', '/Points', respm_sofb6D);
    end
end

[~, M4D] = findm44(ring_new, 0, 1:length(ring_new)+1);
[~, ~, respm_sofb4D_traj] = sirius_commis.common.trajectory_matrix(fam, M4D);

if flag_bo || flag_si
    respm4D = calc_respm_cod(ring_new, fam.BPM.ATIndex, fam.CH.ATIndex, fam.CV.ATIndex);
    respm4D = respm4D.respm;
    respm_sofb4D = [respm4D.mxx, respm4D.mxy; respm4D.myx, respm4D.myy];
    respm_sofb4D = [respm_sofb4D, zeros(2*length(fam.BPM.ATIndex), 1)];
else
    respm_sofb4D_traj = respm_sofb4D_traj(:, 1:end-1);
end

% dlmwrite('respm_sofb_bo4D.txt', respm_sofb4D, 'precision', 16);
% dlmwrite('respm_sofb_bo4D_traj.txt', respm_sofb4D_traj, 'precision', 16);

if flag_tb
        hdf5write('respm_sofb_TB4D_traj.h5', '/Points', respm_sofb4D_traj);
    elseif flag_bo
        hdf5write('respm_sofb_BO4D_traj.h5', '/Points', respm_sofb4D_traj);
        hdf5write('respm_sofb_BO4D.h5', '/Points', respm_sofb4D);
    elseif flag_ts
        hdf5write('respm_sofb_TS4D_traj.h5', '/Points', respm_sofb4D_traj);
    elseif flag_si
        hdf5write('respm_sofb_SI4D_traj.h5', '/Points', respm_sofb4D_traj);
        hdf5write('respm_sofb_SI4D.h5', '/Points', respm_sofb4D);
end
end

