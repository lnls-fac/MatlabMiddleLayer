function amplitudes = lnls1_epu_field_amplitude(epu, period)


nr_periods = 8;
posy     = linspace(- nr_periods * period/2, nr_periods * period/2, 8 * nr_periods + 1);
pos      = zeros(3, length(posy));
pos(2,:) = posy;
field    = epu_field(epu.model, pos);
field    = field([1 3],:);

s = sin(2*pi*posy/period);
c = cos(2*pi*posy/period);
m = [s*s' s*c'; c*s' c*c'];
b = [s*field'; c*field'];
vec = m \ b;
amplitudes = sqrt(sum(vec.^2));
