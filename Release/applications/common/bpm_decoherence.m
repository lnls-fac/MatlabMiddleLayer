function centroid = bpm_decoherence(Xin, Nturn, Npart)
%BPM_DECOHERENCE - Simulate the beam decoherence using multiparticle
%tracking
% INPUTS
%  1/ Xin - Initial coordinates
%  2/ Nturn - number of turns
%  3/ Npart - number of particles
%

% todo flag with Amplitude, 'Energy' in vargin

global THERING
DisplayFlag = 1;
AmplitudeFlag =1;
EnergyFlag =1;

sigmaX  = 1100e-6; % m
sigmaPx = 76e-6;
sigmaZ  = 10e-6; % m
sigmaPz = 10e-6;
sigmaE  = 6.14104e-04;
Xdistrib  = randn(1, Npart)*sigmaX;
Pxdistrib = randn(1, Npart)*sigmaPx;
Zdistrib  = randn(1, Npart)*sigmaZ;
Pzdistrib = randn(1, Npart)*sigmaPz;
Edistrib  = randn(1, Npart)*sigmaE;

X0 = repmat(Xin,1,Npart);
if AmplitudeFlag
    X0(1,:) = X0(1,:) + Xdistrib;
    X0(2,:) = X0(2,:) + Pxdistrib;
    X0(3,:) = X0(3,:) + Zdistrib;
    X0(4,:) = X0(4,:) + Pzdistrib;
end

if EnergyFlag
    X0(5,:) = X0(5,:) + Edistrib;
end

[Xout, LOSS]  = ringpass(THERING, X0, Nturn);
if LOSS
    fprintf('Unstable/n')
end

XoutR = reshape(Xout,6,Npart,Nturn);

centroid(:,:) = squeeze(mean(XoutR(:,:,:),2));

%%
if DisplayFlag
    figure
    clf; axes;
    subplot(2,2,1)
    hold all;
    for k =1:Npart,
        plot(squeeze(XoutR(1,k,:))*1e3, squeeze(XoutR(2,k,:))*1e3, '.', 'MarkerSize', 1);
    end
    xlabel('x (mm)'); ylabel('px (mrad)');
    title(sprintf('%d particles', Npart))

    subplot(2,2,2)
    plot(centroid(1,:)*1e3, centroid(2,:)*1e3, 'k.', 'MarkerSize', 1);
    title('Centroid')
    xlabel('x (mm)'); ylabel('px (mrad)')

    subplot(2,2,3)
    plot(centroid(1,:)*1e3, 'k.');
    title('Centroid')
    xlabel('turn #'); ylabel('x(mm)');
    axis tight

    subplot(2,2,4)
    plot(centroid(3,:)*1e3, 'k.');
    title('Centroid')
    xlabel('turn #'); ylabel('y(mm)');
    axis tight
end