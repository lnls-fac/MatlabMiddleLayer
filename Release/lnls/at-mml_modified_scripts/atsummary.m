function r = atsummary(varargin)
%ATSUMMARY - Prints out the paramters of the current AT lattice
%  The parameters that come after the Synchrotron Integrals are
%  parameters that depend on the Integrals themselves. The equations to
%  calculate them were taken from [1].
%
%  [1] Alexander Wu Chao and Maury Tigner, Handbook of Accelerator Physics
%  and Engineering (World Scientific, Singapore, 1998), pp. 183-187. (or
%  187-190 in ed. 2)
%
%  See also ringpara

%  Written by Eugene Tan
%  Revised by Laurent S. Nadolski
%  Modified by Ximenes Resende (for more than one RF cavity)
%  2012-06-25: mudan�a de rho^3 para abs(rho^3) em I5!
%  2012-07-04: modified by Afonso Mukai (lifetime calculations)
%  2012-08-29: elementos dipolares refinados para calculo mais preciso das integrais de radia��o.


global THERING
if isempty(varargin)
    the_ring = THERING;
else
    the_ring = varargin{1};
end


const = lnls_constants;

% Refine dipole elements for better calculation of radiation integrals
max_length = 0.05;
idx = findcells(the_ring, 'BendingAngle');
BendFamilies = unique(getcellstruct(the_ring, 'FamName', idx));
the_ring = lnls_refine_lattice(the_ring, max_length, BendFamilies);

% Structure to store info
ind = findcells(the_ring,'Energy');
r.e0 = the_ring{ind(1)}.Energy/1e9;
r.circumference = findspos(the_ring, length(the_ring)+1);
r.revTime = r.circumference / const.c;
r.revFreq = const.c / r.circumference;
r.gamma = r.e0 / (const.E0/1000);
r.beta = sqrt(1 - 1/r.gamma);
[TD, r.tunes, r.chromaticity] = twissring(the_ring, 0, 1:length(the_ring)+1, 'chrom', 1e-8);
r.twiss.beta        = cat(1,TD.beta);
r.twiss.mu          = cat(1,TD.mu);
r.twiss.alpha       = cat(1,TD.alpha);
r.twiss.ClosedOrbit = [TD.ClosedOrbit]';
r.twiss.Dispersion  = [TD.Dispersion]';
r.twiss.SPos        = cat(1,TD.SPos);

r.compactionFactor = mcf(the_ring);

% For calculating the synchrotron integrals
temp  = cat(2,TD.Dispersion);
D_x   = temp(1,:)';
D_x_  = temp(2,:)';
beta  = cat(1, TD.beta);
alpha = cat(1, TD.alpha);
gamma = (1 + alpha.^2) ./ beta;
circ  = TD(length(the_ring)+1).SPos;

% Synchrotron integral calculation
r.integrals = [0.0 0.0 0.0 0.0 0.0 0.0];


for i = 1:length(the_ring),
    if isfield(the_ring{i}, 'BendingAngle') && isfield(the_ring{i}, 'EntranceAngle') && the_ring{i}.BendingAngle ~= 0
        rho = the_ring{i}.Length/the_ring{i}.BendingAngle;
        dispersion = 0.5*(D_x(i)+D_x(i+1));
        r.integrals(1) = r.integrals(1) + dispersion*the_ring{i}.Length/rho;
        r.integrals(2) = r.integrals(2) + the_ring{i}.Length/(rho^2);
        r.integrals(3) = r.integrals(3) + the_ring{i}.Length/abs(rho^3);
        % For general wedge magnets
        r.integrals(4) = r.integrals(4) + ...
            D_x(i)*tan(the_ring{i}.EntranceAngle)/rho^2 + ...
            (1 + 2*rho^2*the_ring{i}.PolynomB(2))*(D_x(i)+D_x(i+1))*the_ring{i}.Length/(2*rho^3) + ...
            D_x(i+1)*tan(the_ring{i}.ExitAngle)/rho^2;
        %         r.integrals(4) = r.integrals(4) + 2*0.5*(D_x(i)+D_x(i+1))*the_ring{i}.Length/rho^3;
        H1 = beta(i,1)*D_x_(i)*D_x_(i)+2*alpha(i)*D_x(i)*D_x_(i)+gamma(i)*D_x(i)*D_x(i);
        H0 = beta(i+1,1)*D_x_(i+1)*D_x_(i+1)+2*alpha(i+1)*D_x(i+1)*D_x_(i+1)+gamma(i+1)*D_x(i+1)*D_x(i+1);
        r.integrals(5) = r.integrals(5) + the_ring{i}.Length*(H1+H0)*0.5/abs(rho^3);
        %         if H1+H0 < 0
        %             fprintf('%f %i %s\n', H1+H0, i, the_ring{i}.FamName)
        %         end
        r.integrals(6) = r.integrals(6) + the_ring{i}.PolynomB(2)^2*dispersion^2*the_ring{i}.Length;
    end
    if isfield(the_ring{i}, 'Period')
        
    end
end


% Damping numbers
% Use Robinson's Theorem
r.damping(1) = 1 - r.integrals(4)/r.integrals(2);
r.damping(2) = 1;
r.damping(3) = 2 + r.integrals(4)/r.integrals(2);

r.radiation = 8.846e-5*r.e0.^4*r.integrals(2)/(2*pi);
r.naturalEnergySpread = sqrt(3.8319e-13*r.gamma.^2*r.integrals(3)/(2*r.integrals(2) + r.integrals(4)));
r.naturalEmittance = 3.8319e-13*(r.e0*1e3/const.E0).^2*r.integrals(5)/(r.damping(1)*r.integrals(2));

% Damping times
r.radiationDamping(1) = 1/(2113.1*r.e0.^3*r.integrals(2)*r.damping(1)/circ);
r.radiationDamping(2) = 1/(2113.1*r.e0.^3*r.integrals(2)*r.damping(2)/circ);
r.radiationDamping(3) = 1/(2113.1*r.e0.^3*r.integrals(2)*r.damping(3)/circ);

% Slip factor
r.etac = r.gamma^(-2) - r.compactionFactor;

cavind = findcells(the_ring,'HarmNumber');
if ~isempty(cavind)
    %freq = the_ring{cavind}.Frequency; % Original X.R.R. 2011-04-26
    %v_cav = the_ring{cavind}.Voltage;  % Original X.R.R. 2011-04-26
    freq  = mean(getcellstruct(the_ring, 'Frequency', cavind));
    v_cav = sum(getcellstruct(the_ring, 'Voltage', cavind)); 
else
    % Default
    v_cav = 2.5e6;
    L0_tot = findspos(THERING, length(THERING)+1);
    freq    = 864 * const.c / L0_tot;
    fprintf('!!!! no cavity in the lattice. using default parameters !!!!\n');
end
r.harmon = r.circumference/(const.c/freq); % Asring 499.654MHz RF
r.overvoltage = v_cav/(r.radiation*1e9); % Assuming 3e6 volt cavities.
% Assuming the harmon and overvoltage above.
% references:  H. Winick, "Synchrotron Radiation Sources: A Primer",
% World Scientific Publishing, Singapore, pp92-95. (1995)
% Wiedemann, pp290,350. Chao, pp189.
r.syncphase = pi - asin(1/r.overvoltage);
r.energyacceptance = sqrt(v_cav*sin(r.syncphase)*2*(sqrt(r.overvoltage^2-1) - acos(1/r.overvoltage))/(pi*r.harmon*abs(r.etac)*r.e0*1e9));
r.synctune = sqrt((r.etac*r.harmon*v_cav*cos(r.syncphase))/(2*pi*r.e0*1e9));
r.bunchlength = r.beta*const.c*abs(r.etac)*r.naturalEnergySpread/(r.synctune*r.revFreq*2*pi);
r.the_ring = the_ring;

% Lifetime and pressure - Afonso 2012-07-02
try
    AD = getad;
    [lifetime,pressure] = lnls_calcula_tau(r,AD,-1,-1);
    if(isnumeric(lifetime.total))
        r.lifetime = lifetime.total;
    elseif(isfield(r,'lifetime'))
        r = rmfield(r,'lifetime');
    end
    if(isnumeric(pressure.average))
        r.avgpressure = pressure.average;
    elseif(isfield(r,'pressure'))
        r = rmfield(r,'pressure');
    end
    lifetime.quantum   = num2str(lifetime.quantum,'%0.2g');
    lifetime.elastic   = num2str(lifetime.elastic,'%0.2f');
    lifetime.inelastic = num2str(lifetime.inelastic,'%0.2f');
    lifetime.touschek  = num2str(lifetime.touschek,'%0.2f');
    lifetime.total     = num2str(lifetime.total,'%0.2f');
    if(strcmp(pressure.average,'Not available'))
        presprofileinfo = '';
    else
        presprofileinfo = ['(''' AD.OpsData.PrsProfFile ''')'];
    end
    pressure.average   = num2str(pressure.average,'%0.2e');
    lifetime.calc =1;
catch
    lifetime.calc= 0;
end


if nargout == 0
    fprintf('\n');
    %fprintf('   ******** Summary for ''%s'' ********\n', GLOBVAL.LatticeFile);
    fprintf('   ******** AT Lattice Summary ********\n');
    fprintf('   Energy: \t\t\t%4.5f [GeV]\n', r.e0);
    fprintf('   Gamma: \t\t\t%4.5f \n', r.gamma);
    fprintf('   Circumference: \t\t%4.5f [m]\n', r.circumference);
    fprintf('   Revolution time: \t\t%4.5f [ns] (%4.5f [MHz]) \n', r.revTime*1e9,r.revFreq*1e-6);
    fprintf('   Betatron tune H: \t\t%4.5f (%4.5f [kHz])\n', r.tunes(1),abs(r.tunes(1)-round(r.tunes(1)))/r.revTime*1e-3);
    fprintf('                 V: \t\t%4.5f (%4.5f [kHz])\n', r.tunes(2),abs(r.tunes(2)-round(r.tunes(2)))/r.revTime*1e-3);
    fprintf('   Momentum Compaction Factor: \t%4.5f\n', r.compactionFactor);
    fprintf('   Chromaticity H: \t\t%+4.5f\n', r.chromaticity(1));
    fprintf('                V: \t\t%+4.5f\n', r.chromaticity(2));
    fprintf('   Synchrotron Integral 1: \t%4.5f [m]\n', r.integrals(1));
    fprintf('                        2: \t%4.5f [m^-1]\n', r.integrals(2));
    fprintf('                        3: \t%4.5f [m^-2]\n', r.integrals(3));
    fprintf('                        4: \t%4.5f [m^-1]\n', r.integrals(4));
    fprintf('                        5: \t%4.5f [m^-1]\n', r.integrals(5));
    fprintf('                        6: \t%4.5f [m^-1]\n', r.integrals(6));
    fprintf('   Damping Partition H: \t%4.5f\n', r.damping(1));
    fprintf('                     V: \t%4.5f\n', r.damping(2));
    fprintf('                     E: \t%4.5f\n', r.damping(3));
    fprintf('   Radiation Loss: \t\t%4.5f [keV]\n', r.radiation*1e6);
    fprintf('   Natural Energy Spread: \t%4.5f [%%]\n', 100*r.naturalEnergySpread);
    fprintf('   Natural Emittance: \t\t%4.5f [nm.rad]\n', 1e9*r.naturalEmittance);
    fprintf('   Radiation Damping H: \t%4.5f [ms]\n', r.radiationDamping(1)*1e3);
    fprintf('                     V: \t%4.5f [ms]\n', r.radiationDamping(2)*1e3);
    fprintf('                     E: \t%4.5f [ms]\n', r.radiationDamping(3)*1e3);
    fprintf('   Slip factor : \t%4.5f\n', r.etac);
    fprintf('\n');
    fprintf('   Assuming cavities Voltage: %4.5f [kV]\n', v_cav/1e3);
    fprintf('                   Frequency: %4.5f [MHz]\n', freq/1e6);
    fprintf('             Harmonic Number: %4.0f\n', r.harmon);
    fprintf('   Overvoltage factor: %4.5f\n', r.overvoltage);
    fprintf('   Synchronous Phase:  %4.5f [rad] (%4.5f [deg])\n', r.syncphase, r.syncphase*180/pi);
    fprintf('   Linear Energy Acceptance:  %4.5f %%\n', r.energyacceptance*100);
    fprintf('   Synchrotron Tune:   %4.5f (%4.5f kHz or %4.2f turns) \n', r.synctune, r.synctune/r.revTime*1e-3, 1/r.synctune);
    fprintf('   Bunch Length:       %4.5f [mm]\n', r.bunchlength*1e3);
    fprintf('\n');
    if lifetime.calc
        fprintf('           Number of Bunches: %4.0f\n', AD.NrBunches);
        fprintf('                    Coupling: %4.5f [%%]\n', 100*AD.Coupling);
        fprintf('                Beam Current: %4.5f [mA]\n', 1e3*AD.BeamCurrent);
        fprintf('   Lifetime Q:         %s [h]\n', lifetime.quantum);
        fprintf('   Lifetime E:         %s [h]\n', lifetime.elastic);
        fprintf('   Lifetime I:         %s [h]\n', lifetime.inelastic);
        fprintf('   Lifetime T:         %s [h]\n', lifetime.touschek);
        fprintf('   Total lifetime:     %s [h]\n', lifetime.total);
        fprintf('   Average pressure:   %s [mbar] %s\n', pressure.average, presprofileinfo);
        fprintf('   ************************************\n');
    end
end