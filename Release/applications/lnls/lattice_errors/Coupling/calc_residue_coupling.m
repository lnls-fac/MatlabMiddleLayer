function v = calc_residue_coupling(Mxy, Myx, Dispy, bpms, hcms, vcms)

disp_weight = (length(hcms) + length(vcms))*10;
v = permute([Myx, Mxy, disp_weight * Dispy'],[2 1 3]); % para ficar ordenado por bpm
v = v(:);