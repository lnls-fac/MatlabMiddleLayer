function [m_h, m_v, ch, cv] = sirius_ts_measposang_corrmat_2(thering, flag_corr)

fam = sirius_ts_family_data(thering);

if strcmp(flag_corr, 'CH-Sept')
    ch = {fam.CH.ATIndex(end), fam.InjSeptF.ATIndex};
elseif strcmp(flag_corr, 'Sept-Sept')
    ch = {fam.InjSeptG.ATIndex(1,:), fam.InjSeptG.ATIndex(2,:), ...
          fam.InjSeptF.ATIndex};
else
    error('Set flag_corr CH-Sept or Sept-Sept')
end

cv = {fam.CV.ATIndex(end-1), fam.CV.ATIndex(end)};
kick = 1e-5;

i_init = ch{1};
i_end = length(thering);
m_h_aux = zeros(2,length(ch));
for i=1:length(ch)
    r1 = lnls_set_kickangle(thering, +kick/2, ch{i}, 'x');
    p1 = linepass(r1(i_init:i_end), [0,0,0,0,0,0]');
    r2 = lnls_set_kickangle(thering, -kick/2, ch{i}, 'x');
    p2 = linepass(r2(i_init:i_end), [0,0,0,0,0,0]');
    m_h_aux(:,i) = (p1([1,2]) - p2([1,2]))/kick;
end
if strcmp(flag_corr, 'Sept-Sept')
    m_h = [[m_h_aux(1, 1)+m_h_aux(1, 2), m_h_aux(1, 3)]; ...
           [m_h_aux(2, 1)+m_h_aux(2, 2), m_h_aux(2, 3)]];
else
    m_h = m_h_aux;
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
