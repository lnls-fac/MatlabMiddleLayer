function [m_h, m_v, ch, cv] = sirius_tb_measposang_corrmat(thering, flag_corr)

data = sirius_tb_family_data(thering);
chv = data.CHV.ATIndex;

% It is possible to use the last CH or the Injection Septum to calculate 
% the PosAng correction matrix.
if strcmp(flag_corr, 'CH-CH')
    ch = {chv(end-1), chv(end)};
elseif strcmp(flag_corr, 'CH-Sept')
    ch = {chv(end-1), data.InjSept.ATIndex};
else
    error('Set flag_corr CH-CH or CH-Sept')
end

cv = {chv(end-1), chv(end)};

kick = 1e-5;

i_init = ch{1};
i_end = length(thering);
m_h = zeros(2,2);
for i=1:length(ch)
    r1 = lnls_set_kickangle(thering, +kick/2, ch{i}, 'x');
    p1 = linepass(r1(i_init:i_end), [0,0,0,0,0,0]');
    r2 = lnls_set_kickangle(thering, -kick/2, ch{i}, 'x');
    p2 = linepass(r2(i_init:i_end), [0,0,0,0,0,0]');
    m_h(:,i) = (p1([1,2]) - p2([1,2]))/kick;
end

i_init = cv{1};
i_end = length(thering);
m_v = zeros(2,2);
for i=1:length(cv)
    r1 = lnls_set_kickangle(thering, +kick/2, cv{i}, 'y');
    p1 = linepass(r1(i_init:i_end), [0,0,0,0,0,0]');
    r2 = lnls_set_kickangle(thering, -kick/2, cv{i}, 'y');
    p2 = linepass(r2(i_init:i_end), [0,0,0,0,0,0]');
    m_v(:,i) = (p1([3,4]) - p2([3,4]))/kick;
end

end