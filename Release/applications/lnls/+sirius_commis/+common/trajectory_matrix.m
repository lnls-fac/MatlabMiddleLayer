function [m_corr_x, m_corr_y, m_sofb] = trajectory_matrix(fam, M_acc)


ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;
m_corr_x = zeros(length(bpm), length(ch));
m_corr_y = zeros(length(bpm), length(cv));

M_bpms_x = M_acc(1:2, 1:2, bpm);
M_bpms_y = M_acc(3:4, 3:4, bpm);

for j = 1:length(ch)
    ind_bpms_ch = bpm > ch(j);
    first = find(ind_bpms_ch);

    if ~isempty(first)
        first = first(1);
        trecho = first:length(bpm);
        M_ch = M_acc(1:2, 1:2, ch(j));
        for i=1:length(trecho)
            M_x = M_bpms_x(:, :, trecho(i)) / M_ch; 
            m_corr_x(trecho(i), j) = squeeze(M_x(1, 2, :));
        end
    end
end

for j = 1:length(cv)
    ind_bpms_cv = bpm > cv(j);
    first = find(ind_bpms_cv);

    if ~isempty(first)
        first = first(1);
        trecho = first:length(bpm);
        M_cv = M_acc(3:4, 3:4, cv(j));
        for i=1:length(trecho)
            M_y = M_bpms_y(:, :, trecho(i)) / M_cv; 
            m_corr_y(trecho(i), j) = squeeze(M_y(1, 2, :));
        end
    end
end

mxy = zeros(length(bpm), length(cv));
myx = zeros(length(bpm), length(ch));
m_sofb = [m_corr_x, mxy; myx, m_corr_y];
% m_sofb = [m_sofb, mrf];

end

