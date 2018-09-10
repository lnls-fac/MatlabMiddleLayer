function coupling = lnls_calc_coupling(ring, complete)
    [ring, ~, ~, ~, ~, idx_rad, ~] = setradiation('On', ring);
    ring = setcavity('On', ring);
    if ~exist('complete', 'var')
        complete = false;
    end
    
    idx_rad = idx_rad';
    
    n_ele = length(ring);

    [MRING, MS, orbit] = findm66(ring, 1:n_ele+1);

    B = cell(1,n_ele); % B{i} is the diffusion matrix of the i-th element
    BATEXIT = B;             % BATEXIT{i} is the cumulative diffusion matrix from 
                             % element 0 to the end of the i-th element

    % calculate Radiation-Diffusion matrix B for elements with radiation
    for i = idx_rad
       B{i} = findmpoleraddiffmatrix(ring{i},orbit(:,i));
    end

    % Calculate cumulative Radiation-Diffusion matrix for the ring
    BCUM = zeros(6,6); % Cumulative diffusion matrix of the entire ring

    % Calculate 6-by-6 linear transfer matrix in each element
    % near the equilibrium orbit 
    for i = 1:n_ele
       M =  MS(:,:,i+1)/MS(:,:,i);
       if ~isempty(B{i})
           BCUM = M*BCUM*M' + B{i};
       else
           BCUM = M*BCUM*M';
       end
       BATEXIT{i} = BCUM;
    end

    AA =  inv(MRING);
    BB = -MRING';
    CC = -inv(MRING)*BCUM;
    R = lyap(AA,BB,CC);     % Envelope matrix at the ring entrance

    REFPTS = 1:length(ring)+1;
    NRX = length(REFPTS);
    Rs = zeros(NRX, size(R, 1), size(R, 2));
    Rs(1,:,:) = R;

    for i=2:NRX
        ELEM = REFPTS(i);
        Rs(i,:,:) = MS(:,:,ELEM)*R*MS(:,:,ELEM)'+BATEXIT{ELEM-1};
    end
    
    tilt = zeros(1, NRX);
    tiltl = zeros(1, NRX);
    sigmas = zeros(2, NRX);

    sigd = Rs(:,5,5);

    nx = Rs(:,1,5) ./ sigd;
    nxl = Rs(:,2,5) ./ sigd;
    xxb = Rs(:,1,1) - nx .* nx .* sigd;
    xlxlb = Rs(:,2,2) - nxl .* nxl .* sigd;
    xxlb = Rs(:,1,2) - nx .* nxl .* sigd;
    emix = sqrt(xxb .* xlxlb - xxlb .* xxlb);
    
    ny = Rs(:,3,5) ./ sigd;
    nyl = Rs(:,4,5) ./ sigd;
    yyb = Rs(:,3,3) - ny .* ny .* sigd;
    ylylb = Rs(:,4,4) - nyl .* nyl .* sigd;
    yylb = Rs(:,3,4) - ny .* nyl .* sigd;
    emiy = sqrt(yyb .* ylylb - yylb .* yylb);
    for i=1:length(Rs)
        R = squeeze(Rs(i,:,:));
        [U, DR] = eig(R([1 3], [1 3]));
        tilt(i) = asin((U(2,1)-U(1,2))/2);
        sigmas(1, i) = sqrt(DR(1,1));
        sigmas(2, i) = sqrt(DR(2,2));

        [U, ~] = eig(R([2 4],[2 4]));
        tiltl(i) = asin((U(2,1)-U(1,2))/2);
    end
    coupling.sigmas = real(sigmas);
    coupling.tilt = tilt;
    coupling.tiltl = tiltl;
    coupling.emit_x = mean(emix);
    coupling.emit_y = mean(emiy);
    coupling.emit_ratio = coupling.emit_y / coupling.emit_x;
    
    if complete
        [TwissData, ~, ~]  = twissring(ring, 0, 1:n_ele+1, 'chrom');

        DP = Rs(1,5,5);
        Beta = cat(1, TwissData.beta);
        betax = Beta(:,1);
        betay = Beta(:,2);
        Eta = cat(2, TwissData.Dispersion);
        etax = Eta(1,:)';
        etay = Eta(3,:)';
        pos = cat(1, TwissData.SPos);

        sig1 = sigmas(1,:)';
        sig2 = sigmas(2,:)';
        EpsX = (sig1.*sig1 - etax.*etax*DP) ./ betax;
        EpsY = (sig2.*sig2 - etay.*etay*DP) ./ betay;
        
        sigx = Rs(:,1,1);
        sigy = Rs(:,3,3);
        EpsX2 = (sigx - etax.*etax*DP) ./ betax;
        EpsY2 = (sigy - etay.*etay*DP) ./ betay;

        figure('Position', [100, 100, 1000, 1000]);
        ax1 = axes('FontSize',  16);
        subplot(2, 1, 1, ax1);
        plot(ax1, pos, EpsX*1e9, 'LineWidth', 2);
        hold(ax1, 'all');
        plot(ax1, pos, EpsX2*1e9, 'LineWidth', 2);
        plot(ax1, pos, emix*1e9, 'LineWidth', 2);
        legend(ax1,...
            {'Twiss - Normal Planes', 'Twiss - X and Y Planes', 'Envelope Matrix'},...
            'FontSize', 16, 'Location', 'best');
        xlim(ax1, [0, pos(end)]);
        xlabel(ax1, 'Pos [m]', 'FontSize', 16);
        ylabel(ax1, 'Emit X [nm.rad]', 'FontSize', 16);
        
        ax2 = axes('FontSize',  16);
        subplot(2, 1, 2, ax2);
        plot(ax2, pos, EpsY*1e12, 'LineWidth', 2);
        hold(ax2, 'all');
        plot(ax2, pos, EpsY2*1e12, 'LineWidth', 2);
        plot(ax2, pos, emiy*1e12, 'LineWidth', 2);
        legend(ax2,...
            {'Twiss - Normal Planes', 'Twiss - X and Y Planes', 'Envelope Matrix'},...
            'FontSize', 16, 'Location', 'best');
        xlim(ax2, [0, pos(end)]);
        xlabel(ax2, 'Pos [m]', 'FontSize', 16);
        ylabel(ax2, 'Emit Y [pm.rad]', 'FontSize', 16);
    end
    
