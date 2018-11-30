function M_resp = calc_respm_first_turn(ring, type)

[~, M_acc] = findm44(ring, 0, 1:length(ring));

if strcmp(type, 'si')
    injsept = findcells(ring, 'FamName', 'InjSeptF');
    ring = circshift(ring, [0, -(injsept - 1)]);
    fam = sirius_si_family_data(ring);
elseif strcmp(type, 'bo')
    injsept = findcells(ring, 'FamName', 'InjSept');
    ring = circshift(ring, [0, -(injsept - 1)]);
    fam = sirius_bo_family_data(ring);
end

bpm = fam.BPM.ATIndex;
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;

mxx = zeros(length(bpm), length(ch));
myy = zeros(length(bpm), length(cv));
mxy = zeros(length(bpm), length(cv));
myx = zeros(length(bpm), length(ch));

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
            mxx(trecho(i), j) = squeeze(M_x(1, 2, :));
        end
    end

    ind_bpms_cv = bpm > cv(j);
    first = find(ind_bpms_cv);

    if ~isempty(first)
        first = first(1);
        trecho = first:length(bpm);
        M_cv = M_acc(3:4, 3:4, cv(j));
        for i=1:length(trecho)
            M_y = M_bpms_y(:, :, trecho(i)) / M_cv; 
            myy(trecho(i), j) = squeeze(M_y(1, 2, :));
        end
    end

m_rf = zeros(2 * length(bpm), 1);

M_resp = [[mxx, mxy; myx, myy], m_rf];

end
end

