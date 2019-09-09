function fixed_point(orbita6, maquina1_rf, C0, h, f0rf, T0)

r_i = orbita6/1.5;
dif = ones(6, 1);
while abs(mean(dif)) > 1e-16
    for i = 1:1000
        r_f(:, i) = linepass(maquina1_rf, r_i);
        r_f(6, i) = r_f(6, i) - C0*(h/(f0rf+7e3) - T0);
        r_i(:) = squeeze(r_f(:, i));
    end
    r_i = nanmean(r_f, 2);
    dif = orbita6 - r_i;
    m = mean(dif);
    fprintf('dif %e \n', m);
end