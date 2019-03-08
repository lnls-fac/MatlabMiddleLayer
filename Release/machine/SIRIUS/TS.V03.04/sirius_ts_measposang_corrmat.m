function [m_h, m_v, ch, cv] = sirius_ts_measposang_corrmat(thering)

ch_index = findcells(thering, 'FamName', 'CH');
cv_index = findcells(thering, 'FamName', 'CV');
ch = {ch_index(end), findcells(thering, 'FamName', 'InjSeptF')};
cv = {cv_index(end-1), cv_index(end)};

kick = 1e-5;

i_init = ch{1};
i_end = length(thering);
m_h = zeros(2,2);
for i=1:length(ch)
    r1 = lnls_set_kickangle(thering, +kick/2, ch{i}, 'x');
    p1 = linepass(r1(i_init:i_end), [0,0,0,0,0,0]');
    r2 = lnls_set_kickangle(thering, -kick/2, ch{i}, 'x');
    p2 = linepass(r2(i_init:i_end), [0,0,0,0,0,0]');
    m_h(:,i) = -(p2([1,2]) - p1([1,2]))/kick;
end

i_init = cv{1};
i_end = length(thering);
m_v = zeros(2,2);
for i=1:length(cv)
    r1 = lnls_set_kickangle(thering, +kick/2, cv{i}, 'y');
    p1 = linepass(r1(i_init:i_end), [0,0,0,0,0,0]');
    r2 = lnls_set_kickangle(thering, -kick/2, cv{i}, 'y');
    p2 = linepass(r2(i_init:i_end), [0,0,0,0,0,0]');
    m_v(:,i) = -(p2([3,4]) - p1([3,4]))/kick;
end

end