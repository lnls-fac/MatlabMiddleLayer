function [Tilt, Eta, EpsX, EpsY, Ratio, ENV, DP, DL, sigmas] = calccoupling(the_ring,complete)
%CALCCOUPLING - Calculates the coupling and tilt of the AT model
%  [Tilt, Eta, EpsX, EpsY, EmittanceRatio, ENV, DP, DL, BeamSize] = calccoupling
%
%  INPUTS
%  1. the_ring - model of the ring, if not supplied THERING is called
%  2. complete - a flag indicating if Emittances and Ratio will be
%                calculated (default: true)
%
%  OUTPUTS
%  1. Tilt - Tilts of the emittance ellipse [radian]
%  2. Eta - Dispersion
%  3. EpsX - Horzontal emittance
%  4. EpsY - Vertical  emittance
%  5. EmittanceRatio - median(EpsY) / median(EpsX)
%  6-8. ENV, DP, DL - Output of ohmienvelope
%
%  NOTES
%  1. If there are no outputs, the coupling information will be plotted.
%  2. It can be helpful the draw the lattice on top of a plot (hold on; drawlattice(Offset, Height);)
%  3. Whenever using the MML and AT together the AT indexes must be matched to what
%     is in the MML.  Whenever changing THERING use updateatindex to sync the MML.

%  Written by James Safranek
%  2018/06/06 - change emittance estimator to median. (Fernando de Sá)
global THERING
if ~exist('the_ring','var')
    the_ring = THERING;
end
if ~exist('complete','var')
    complete = true;
end

[the_ring, ~, ~, ~, ~, ATIndex, ~] = setradiation('On', the_ring);

the_ring = setcavity('On', the_ring);

[ENV, DP, DL] = ohmienvelope(the_ring, ATIndex', 1:length(the_ring)+1);

sigmas = cat(2, ENV.Sigma);
Tilt = cat(2, ENV.Tilt);

% Fix imaginary data
% ohmienvelope seems to return complex when very close to zero
if ~isreal(sigmas(1,:))
    % Sigma is positive so this should be ok
    sigmas(1,:) = abs(sigmas(1,:));
end
if ~isreal(sigmas(2,:))
    % Sigma is positive so this should be ok
    sigmas(2,:) = abs(sigmas(2,:));
end

if nargout ==0 || complete
    [TwissData, ~, ~]  = twissring(the_ring, 0, 1:length(the_ring)+1, 'chrom');
    
    % Calculate tilts
    Beta = cat(1,TwissData.beta);
    spos = cat(1,TwissData.SPos);
    
    Eta = cat(2,TwissData.Dispersion);
    EpsX = (sigmas(1,:).^2-Eta(1,:).^2*DP^2)./Beta(:,1)';
    EpsY = (sigmas(2,:).^2-Eta(3,:).^2*DP^2)./Beta(:,2)';
    
%     EpsX0 = mean(EpsX);
%     EpsY0 = mean(EpsY);
    EpsX0 = median(EpsX);  % changed here (Fernando).
    EpsY0 = median(EpsY);
    Ratio = EpsY0 / EpsX0;
end

if nargout == 0
    L0 = findspos(the_ring, length(the_ring)+1);
    % RMS tilt
    TiltRMS = norm(Tilt)/sqrt(length(Tilt));
    EtaY = Eta(3,:);
    fprintf('   RMS Tilt = %f [degrees]\n', (180/pi) * TiltRMS);
    fprintf('   RMS Vertical Dispersion = %f [m]\n', norm(EtaY)/sqrt(length(EtaY)));
    fprintf('   Mean Horizontal Emittance = %f [nm rad]\n', 1e9*EpsX0);
    fprintf('   Mean Vertical   Emittance = %f [nm rad]\n', 1e9*EpsY0);
    fprintf('   Emittance Ratio = %f%% \n', 100*Ratio);
    
    %figure(1);
    gcf;
    clf reset;
    subplot(2,2,1);
    plot(spos, Tilt*180/pi, '-')
    set(gca,'XLim',[0 spos(end)])
    ylabel('Tilt [degrees]');
    title(sprintf('Rotation Angle of the Beam Ellipse  (RMS = %f)', (180/pi) * TiltRMS));
    xlabel('s - Position [m]');

    %figure(2);
    subplot(2,2,3);
    [AX, H1, H2] = plotyy(spos, 1e6*sigmas(1,:), spos, 1e6*sigmas(2,:));

    %set(H1,'Marker','.')
    set(AX(1),'XLim',[0 spos(end)]);
    %set(H2,'Marker','.')
    set(AX(2),'XLim',[0 spos(end)]);
    title('Principal Axis of the Beam Ellipse');
    set(get(AX(1),'Ylabel'), 'String', 'Horizontal [\mum]'); 
    set(get(AX(2),'Ylabel'), 'String', 'Vertical [\mum]'); 
    xlabel('s - Position [m]');
    
    FontSize = get(get(AX(1),'Ylabel'),'FontSize');

    %figure(3);
    subplot(2,2,2);    
    plot(spos, 1e9 * EpsX);
    title('Horizontal Emittance');
    ylabel(sprintf('\\fontsize{16}\\epsilon_x  \\fontsize{%d}[nm rad]', FontSize));
    xlabel('s - Position [m]');
    xaxis([0 L0]);
    
    %figure(4);
    subplot(2,2,4);
    plot(spos, 1e9 * EpsY);
    title('Vertical Emittance');
    ylabel(sprintf('\\fontsize{16}\\epsilon_y  \\fontsize{%d}[nm rad]', FontSize));
    xlabel('s - Position [m]');
    xaxis([0 L0]);
   
    h = addlabel(.75, 0, sprintf('     Emittance Ratio = %f%% ', 100*Ratio), 10);
    set(h,'HorizontalAlignment','Center');
    
    orient landscape;
end

