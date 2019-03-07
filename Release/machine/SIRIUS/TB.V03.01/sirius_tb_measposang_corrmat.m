function [m_h, m_v, ch, cv] = sirius_tb_measposang_corrmat(thering)

data = sirius_tb_family_data(thering);
chv = data.CHV.ATIndex;
ch = {chv(end-1), data.InjSept.ATIndex};
cv = {chv(end-1), chv(end)};

kick = 1e-5;

i_init = ch{1};
i_end = length(thering);
m_h = zeros(2,2);
for i=1:length(ch)
    thering = lnls_set_kickangle(thering, +kick/2, ch{i}, 'x');
    p1 = linepass(thering(i_init:i_end), [0,0,0,0,0,0]');
    thering = lnls_set_kickangle(thering, -kick/2, ch{i}, 'x');
    p2 = linepass(thering(i_init:i_end), [0,0,0,0,0,0]');
    m_h(:,i) = -(p2([1,2]) - p1([1,2]))/kick;
end

i_init = cv{1};
i_end = length(thering);
m_v = zeros(2,2);
for i=1:length(cv)
    thering = lnls_set_kickangle(thering, +kick/2, cv{i}, 'y');
    p1 = linepass(thering(i_init:i_end), [0,0,0,0,0,0]');
    thering = lnls_set_kickangle(thering, -kick/2, cv{i}, 'y');
    p2 = linepass(thering(i_init:i_end), [0,0,0,0,0,0]');
    m_v(:,i) = -(p2([3,4]) - p1([3,4]))/kick;
end

end