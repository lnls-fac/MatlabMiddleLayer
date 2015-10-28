function ind_bba = get_bba_ind(the_ring, quad_idx)

% Determinando indices dos quadrupolos na rede
% mag_idx = findcells(the_ring,'K');
% dip_idx = findcells(the_ring,'BendingAngle');
% quad_idx = setdiff(mag_idx,dip_idx);

%determinando indice dos bpms na rede
bpm_idx = findcells(the_ring,'FamName','bpm');
%descobrindo qual a posicao dos elementos na rede
spos = findspos(the_ring,1:length(the_ring));
bpm_spos = spos(bpm_idx); % dos bpms
quad_spos = spos(quad_idx); % e dos quadrupolos
%determinando quais sao os quadrupolos mais proximos aos bpms
[~,In]=min(abs(repmat(bpm_spos,length(quad_idx),1) -repmat(quad_spos',1,length(bpm_idx))));
ind_bba = quad_idx(In);