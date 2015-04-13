function r = lnls_twiss(ring, pos)
% Calcula parametros de twiss no modelo 'ring' na posição 'pos' (spline).
%
% História:
%
% 2010-09-16: comentários no código.


twiss = twissring(ring, 0, 1:length(ring)+1);
v_mu = cat(1,twiss.mu);
v_beta = cat(1,twiss.beta);
v_pos = cat(1,twiss.SPos);

[v_pos, vI, vJ] = unique(v_pos);
v_mu = v_mu(vI,:);
v_beta = v_beta(vI,:);

r.betax = spline(v_pos, v_beta(:,1), pos);
r.betay = spline(v_pos, v_beta(:,2), pos);
r.phix  = spline(v_pos, v_mu(:,1), pos);
r.phiy  = spline(v_pos, v_mu(:,2), pos);
