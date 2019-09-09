function eff_twiss_plot(eff_twiss, twiss, plane)
% Plots graphics using the output of
% sirius_commis.injection.bo.twiss_inj_eff which is the input eff_twiss
% - twiss: twiss function in eff_twiss, 'beta', 'alpha' or 'eta'
% - plane: 'x' horizontal or 'y' vertical twiss function (Note: for dispersion
% 'eta', the 'y' corresponds to the derivative of horizontal dispersion
%
% See also: sirius_commis.injection.bo.twiss_inj_eff

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
    
for k = 1:length(eff_twiss)
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

eff_mach = zeros(length(eff_twiss), length(eff_twiss{1, 1}.tx)); 

for j = 1:length(eff_twiss)
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

