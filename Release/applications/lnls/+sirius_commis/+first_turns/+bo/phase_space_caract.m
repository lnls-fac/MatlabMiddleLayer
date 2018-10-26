function [n_v, r] = phase_space_caract(machine, n_turns, n_points, mode)

machine = setcavity('on', machine);
machine = setradiation('on', machine);

energy_max = 2e-2;
phase_max = 0.3;
alpha = 7.21025937429492e-4;

cavity_ind = findcells(machine, 'Frequency');
cavity = machine{cavity_ind};
f_rf0 = cavity.Frequency;

V0 = cavity.Voltage;    
machine{cavity_ind}.Voltage = V0 * 2;

L0 = findspos(machine, length(machine)+1); % design length [m]
C0 = 299792458; % speed of light [m/s]
T0 = L0/C0;
h = cavity.HarmNumber;

energy_pass = -linspace(-energy_max, energy_max, n_points);
phase_pass = linspace(-phase_max, phase_max, n_points);

df = - alpha * energy_pass * f_rf0;
f_rf = f_rf0 + df;

[E, Phi] = meshgrid(energy_pass, phase_pass);

if strcmp(mode, 'frequency')
    % IN THIS CASE WHEN THE BEAM ENERGY IS EQUAL THE RING ENERGY BUT THE RF
    % FREQUENCY (RF ENERGY, THEREFORE) IS DIFFERENT FROM RING ENERGY

    %CARE MUST BE TAKEN BECAUSE RING PASS WITH CAVITYPASS METHOD DOES NOT
    %CONSIDER THE RIGHT FIXED POINT IN THE TRACKING WHEN THE RF FREQUENCY IS
    %NOT THE NOMINAL, AT EACH TURN A PHASE MUST BE ADDED TO COMPENSATE THE
    %DIFFERENCE BETWEEN THE FREQUENCIES.
    nn_v = zeros(n_points, n_points);
    r = zeros(n_points, 6, n_points, n_turns);

    for j = 1:n_points
        machine{cavity_ind}.Frequency = f_rf(j);
        dphi = C0*(h/f_rf(j) - T0);
        [nn_v(j, :), r(j, :, :, :)] = comp(machine, E, phase_pass, n_turns, n_points, 'freq', j, dphi);
    end
    
    n_v = reshape(nn_v', n_points^2, 1);
    
    % THIS CASE WHEN THE RF ENERGY AND RING ENERGY MATCHES BUT THE BEAM IS
    % INJECTED WITH ENERGY DEVIATION
elseif strcmp(mode, 'energy')
    [n_v, r] = comp(machine, E, Phi, n_turns, n_points, mode, 1);
end

sirius_commis.first_turns.bo.plot_phase_space_caract(n_v, energy_pass, phase_pass, n_turns);

end

function [n_voltas, r_f] = comp(machine, E, Phi, n_turns, n_points, freq, ind, dphi)
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    VChamb = VChamb([1, 2], 1);
    
    if ~exist('dphi', 'var')
        dphi = 0;
    end
      
    if strcmp(freq, 'freq')
        r_i = zeros(6, n_points);
        r_i(6, :) = Phi(:);
        r_f = zeros(6, n_points, n_turns);
        for i = 1:n_turns
            if ind == 1 && i == 1
                r_f(:, :, i) = linepass(machine, r_i);
            else
                r_f(:, :, i) = linepass(machine, r_i, 'reuse');
            end
            % ADDING A PHASE FIX THE PROBLEM IN RINGPASS WHEN RF FREQUENCY 
            % IS DIFFERENT FROM NOMINAL RF FREQUENCY
            r_f(6, :, i) = r_f(6, :, i) - dphi; 
            r_i = squeeze(r_f(:, :, i));
        end
        r_f_xy = squeeze(r_f([1,3], :, :));
        ind = isnan(r_f_xy) | abs(r_f_xy) > [18e-3; 18e-3]; % VChamb;
        or = ind(1, :, :) | ind(2, :, :);
        or6 = repmat(or, 6, 1);
        r_f(or6) = NaN;    
        or2 = squeeze(or)';
        or3 = cumsum(or2, 1);
        n_voltas = n_turns - sum(or3>=1);
    else
        r_i = zeros(6, n_points^2);
        r_i(5, :) = E(:);
        r_i(6, :) = Phi(:);
        r_f = ringpass(machine, r_i, n_turns);
        r_f = reshape(r_f, 6, n_points^2, n_turns);
        
        r_f_xy = squeeze(r_f([1,3], :));
        ind = isnan(r_f_xy) | abs(r_f_xy) > VChamb;
        ind = repmat(ind, 3, 1);
        r_f(ind) = NaN;
        n_voltas = sum(~isnan(r_f(1,:)));
    end
end
