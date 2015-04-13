function [M, Disp, tune] = get_matrix_disp(the_ring, bpms, hcms, vcms)

dim = get_dim(the_ring);

Disp  = calc_dispersion(the_ring,bpms, dim);
M = get_response_matrix(the_ring, bpms, hcms, vcms, dim);
[~, tune] = twissring(the_ring,0,1:length(the_ring)+1);