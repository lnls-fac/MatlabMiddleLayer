function eff_twiss_plot(eff_twiss, n_mach, twiss, plane)

figure; 

flag_x = false;

if strcmp(twiss, 'beta') && strcmp(plane, 'x')
    name = 'Beta x [m]';
    flag_x = true;
elseif strcmp(twiss, 'beta') && strcmp(plane, 'y')
    name = 'Beta y [m]';
elseif strcmp(twiss, 'alpha') && strcmp(plane, 'x')
    name = 'Alpha x';
    flag_x = true;
elseif strcmp(twiss, 'alpha') && strcmp(plane, 'y')
    name = 'Alpha y';
elseif strcmp(twiss, 'eta') && strcmp(plane, 'x')
    name = 'Dispersion x [m]';
    flag_x = true;
elseif strcmp(twiss, 'eta') && strcmp(plane, 'y')
    name = 'Dispersion x derivative';
else
    error('Set the twiss function and the plane')
end
    
for k = 1:n_mach
    gcf();
    
    if flag_x
        plot(eff_twiss{k, 1}.tx, 100 * eff_twiss{k, 1}.eff_x, '--c');
    else
        plot(eff_twiss{k, 1}.ty, 100 * eff_twiss{k, 1}.eff_y, '--c');
    end
    
    hold all; 
end

xlabel(name);
ylabel('Efficiency [%]'); 
grid on; 

eff_mach = zeros(n_mach, length(eff_twiss{1, 1}.tx)); 

for j = 1:n_mach
    if flag_x
        eff_mach(j, :) = eff_twiss{j,1}.eff_x; 
    else
        eff_mach(j, :) = eff_twiss{j,1}.eff_y; 
    end        
end

if flag_x
    plot(eff_twiss{1,1}.tx, mean(eff_mach, 1) * 100, 'r', 'LineWidth', 3);
else
    plot(eff_twiss{1,1}.ty, mean(eff_mach, 1) * 100, 'r', 'LineWidth', 3);
end
end

