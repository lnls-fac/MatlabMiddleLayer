function etax = calc_dispersion(machine)

dipole = findcells(machine, 'FamName', 'B');
dipole = dipole(1);

scrn = findcells(machine, 'FamName', 'Scrn');
scrn3 = scrn(3);

delta = 1e-8;

r_init_n = [0; 0; 0; 0; -delta; 0];
r_final_n = linepass(machine, r_init_n, dipole:scrn3);

r_init_p = [0; 0; 0; 0; +delta; 0];
r_final_p = linepass(machine, r_init_p, dipole:scrn3);

x_n = r_final_n(1, end);
x_p = r_final_p(1, end);

etax = (x_p - x_n) / 2 / delta;
end

