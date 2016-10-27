function [Accep, info] = lnls_calc_touschek_accep(ring,delta,plota,flag_dyn,info_in)
% [Accp, tune_pos, tune_neg] = lnls_calc_touschek_accep(ring,delta)
%  Function lnls_calc_touschek_accep calculates the transverve linear energy
%  acceptance of the_ring, considering its twiss functions and vacuum
%  chamber.
%
%  INPUTS:
%   ring        = model of the ring;
%	delta (opt) = set with positive energy deviation values to search,
%                 default is linspace(1e-6,0.065,60).
%                 If delta is singleton, then it uses the expansion
%                 around delta (do not calculate tune).
%   plota (opt) = boolean to decide if plot acceptance. Default is false.
%
%  OUTPUTS:
%	Accep.ind  = indices of the ring where the vacuum chamber is defined and
%                the energy acceptance was calculated;
%   Accep.s    = position in meters of each Accep.ind;
%   Accep.pos  = positive energy acceptance along the ring;
%   Accep.neg  = negative energy acceptance along the ring;
%   tune       = fractional part of the tunes for each value in delta.

if(~exist('delta','var') || isempty(delta)), delta = linspace(1e-6,0.065,60); end
if(~exist('plota','var')), plota = false; end
if(~exist('flag_dyn','var')), flag_dyn = true; end

% if(exist('pos','var')),
%     flag_pol = true;
%     betax_pos  = zeros(length(pos),length(delta));
%     betax_neg  = zeros(length(pos),length(delta));
%     alphax_pos = zeros(length(pos),length(delta));
%     alphax_neg = zeros(length(pos),length(delta));
%     cox_pos    = zeros(length(pos),length(delta));
%     cox_neg    = zeros(length(pos),length(delta));
%     coxp_pos   = zeros(length(pos),length(delta));
%     coxp_neg   = zeros(length(pos),length(delta));
% else
%     flag_pol = false;
% end

const = lnls_constants;

Accep.ind = findcells(ring,'VChamber');
spos = findspos(ring,1:length(ring));
Accep.s = spos(Accep.ind);

[Accep.s, perm] = unique(Accep.s,'first');
Accep.ind = Accep.ind(perm);

VC_pos = getcellstruct(ring,'VChamber',Accep.ind,1,1);
VC_neg = -getcellstruct(ring,'VChamber',Accep.ind,1,1);

if(length(delta) == 1)
    twi = calctwiss(ring, Accep.ind, delta);
    
    H = ((twi.etax.^2+(twi.betax.*twi.etaxl+twi.alphax.*twi.etax).^2)./twi.betax)';
    
    H = repmat(H,fliplr(size(H)));
    etax  = abs(repmat(twi.etax,fliplr(size(twi.etax))));
    betax = repmat(twi.betax,fliplr(size(twi.betax)));
    
    Amp_pp = etax + sqrt(H.*betax);
    Accep.pos = min(repmat(VC_pos,1,length(VC_pos))./Amp_pp);
else
    twi0 = my_calctwiss(ring, 0, Accep.ind);
    
    if(any(delta < 0)), error('delta must be a positive vector.'); end

    tune_p = zeros(length(delta),2);
    tune_n = zeros(length(delta),2);
    
    H_p = Inf*ones(length(Accep.ind),length(delta));
    H_n = Inf*ones(length(Accep.ind),length(delta));
    Aphys_p = zeros(length(delta),1);
    Aphys_n = zeros(length(delta),1);
    A_p = zeros(length(delta),1);
    A_n = zeros(length(delta),1);
    
    %% Calculate physical aperture
    if ~( exist('info_in','var') && isstruct(info_in) && isfield(info_in,'twi_p') && ...
            isfield(info_in,'twi_p') && isfield(info_in,'H_p') && isfield(info_in,'H_n') && ...
            isfield(info_in,'Aphys_p') && isfield(info_in,'Aphys_n') )
        for j = 1:length(delta)
            [twi_p(j), tune_p(j,:)] = my_calctwiss(ring, delta(j),Accep.ind);
            [twi_n(j), tune_n(j,:)] = my_calctwiss(ring, -delta(j),Accep.ind);
            if( any(imag(tune_p(j,:))) || any(imag(tune_n(j,:))))
                tune_p(j,:) = [NaN NaN];
                tune_n(j,:) = [NaN NaN];
%                 if(flag_pol)
%                     ind_pos = dsearchn(Accep.s',pos');
%                     betax_pos(:,j)  = twi_pos.betax(ind_pos);
%                     betax_neg(:,j)  = twi_neg.betax(ind_pos);
%                     alphax_pos(:,j) = twi_pos.alphax(ind_pos);
%                     alphax_neg(:,j) = twi_neg.alphax(ind_pos);
%                     cox_pos(:,j)    = twi_pos.cox(ind_pos);
%                     cox_neg(:,j)    = twi_neg.cox(ind_pos);
%                     coxp_pos(:,j)   = twi_pos.coxp(ind_pos);
%                     coxp_neg(:,j)   = twi_neg.coxp(ind_pos);
%                 end
            else
                % positive energies
                dcox = twi_p(j).cox - twi0.cox;
                dcoxp = twi_p(j).coxp - twi0.coxp;
                H = ((dcox.^2+(twi_p(j).betax.*dcoxp+twi_p(j).alphax.*dcox).^2)./twi_p(j).betax)';
                
                H_p(:,j) = H;
                A_loc = min((VC_pos - twi_p(j).cox).^2, (VC_neg - twi_p(j).cox).^2);
                Aphys_p(j) = min(A_loc./twi_p(j).betax);
                
                % negative energies
                dcox = twi_n(j).cox - twi0.cox;
                dcoxp = twi_n(j).coxp - twi0.coxp;
                H = ((dcox.^2+(twi_n(j).betax.*dcoxp+twi_n(j).alphax.*dcox).^2)./twi_n(j).betax)';
                
                H_n(:,j) = H;
                A_loc = min((VC_pos - twi_n(j).cox).^2, (VC_neg - twi_n(j).cox).^2);
                Aphys_n(j) = min(A_loc./twi_n(j).betax);
            end
        end
    else
        twi_p   = info_in.twi_p;
        twi_n   = info_in.twi_n;
        H_p     = info_in.H_p;
        H_n     = info_in.H_n;
        Aphys_p = info_in.Aphys_p;
        Aphys_n = info_in.Aphys_n;
    end
    
    %% Calculate Dynamic Aperture
    if isstruct(flag_dyn) || flag_dyn
        
        if isfield(flag_dyn, 'n_turns'), n_turns = flag_dyn.n_turns;
        else n_turns = 131; end
        if isfield(flag_dyn, 'H'), H = flag_dyn.H;
        else H = linspace(0, 4e-6, 30); end
        if isfield(flag_dyn, 'ep'), ep = flag_dyn.ep;
        else ep = linspace(0.02, 0.06, 20); end
        if isfield(flag_dyn, 'en'), en = flag_dyn.en;
        else en = -ep; end
        
        ring_6d = setcavity('on',ring);
        ring_6d = setradiation('on',ring_6d);
        
        circumference = findspos(ring, length(ring)+1);
        revFreq = const.c / circumference;
        ind_cav = findcells(ring,'FamName', 'cav');
        ring_6d{ind_cav}.Frequency = ring_6d{ind_cav}.HarmNumber*revFreq;
        
        beta_p = zeros(1, length(delta)); beta_n = beta_p;
        orb4d_p = zeros(length(delta), 4); orb4d_n = orb4d_p;
        
        for j = 1:length(delta)
            beta_p(j) = twi_p(j).betax(1);
            orb4d_p(j,:) = [twi_p(j).cox(1), twi_p(j).coxp(1), ...
                            twi_p(j).coy(1), twi_p(j).coyp(1)];
            
            beta_n(j) = twi_n(j).betax(1);
            orb4d_n(j,:) = [twi_n(j).cox(1), twi_n(j).coxp(1), ...
                            twi_n(j).coy(1), twi_n(j).coyp(1)];
        end
        beta_p = interp1(delta,beta_p,ep);
        orb4d_p = interp1(delta,orb4d_p,ep)';
        
        beta_n = interp1(-delta,beta_n,en);
        orb4d_n = interp1(-delta,orb4d_n,en)';

        orb6d = findorbit6(ring_6d);
        
        %---negative-energies---%
        [H0,EN] = meshgrid(H,en);
        H0 = H0(:); % transform into column vector
        EN = EN(:);
        Xl = sqrt( H0./repmat(beta_n,1,length(H))' );
        
        Rin = zeros(6, length(H0));
        Rin(1:4,:) = repmat(orb4d_n,1,length(H));
        Rin(2,:) = Rin(2,:) + Xl';
        Rin(3,:) = Rin(3,:) + 1e-5;
        Rin(5,:) = orb6d(5) + EN';
        Rin(6,:) = orb6d(6);
        
        Rou_n = [Rin,ringpass(ring_6d,Rin,n_turns)];
        Rou_n = reshape(Rou_n , 6, length(en), length(H), []);
        
        H_0 = repmat(H, length(en), []);
        lost = isnan( squeeze(Rou_n(1,:,:,end)) );
        
        [a_max, ind_dyn] = max(lost, [], 2);
        ind_dyn = max(ind_dyn - a_max + (~a_max)*(length(H)-1), 1);
        
        Adyn_n = zeros(1, length(en));
        for j = 1:length(en)
            Adyn_n(j) = H_0(j,ind_dyn(j));
        end
        Adyn_n = interp1(en,Adyn_n,-delta)';
        
        %---positive-energies---%
        [H0,EP] = meshgrid(H,ep);
        H0 = H0(:);
        EP = EP(:);
        Xl = sqrt( H0./repmat(beta_p,1,length(H))' );
        
        Rin = zeros(6, length(H0));
        Rin(1:4,:) = repmat(orb4d_p,1,length(H));
        Rin(2,:) = Rin(2,:) + Xl';
        Rin(3,:) = Rin(3,:) + 1e-5;
        Rin(5,:) = orb6d(5) + EP';
        Rin(6,:) = orb6d(6);
        
        Rou_p = [Rin,ringpass(ring_6d,Rin,n_turns)];
        Rou_p = reshape(Rou_p , 6, length(en), length(H), []);
        
        H_0 = repmat(H, length(ep), []);
        lost = isnan( squeeze(Rou_p(1,:,:,end)) );
        
        [a_max, ind_dyn] = max(lost, [], 2);
        ind_dyn = max(ind_dyn - a_max + (~a_max)*(length(H)-1), 1);
        
        Adyn_p = zeros(1, length(ep));
        for j = 1:length(ep)
            Adyn_p(j) = H_0(j,ind_dyn(j));
        end
        Adyn_p = interp1(ep,Adyn_p,delta)';
    else
        if ~( exist('info_in', 'var') && isstruct(info_in) && ...
                isfield(info_in,'Adyn_p_p') && isfield(info_in,'Adyn_p_n') )
            Adyn_p = Inf*ones(length(delta),1);
            Adyn_n = Inf*ones(length(delta),1);
        else
            Adyn_p = info_in.Adyn_p;
            Adyn_n = info_in.Adyn_n;
        end
    end
    
    %% Calculate Aperture and Acceptance
    A_p(1) = min([Aphys_p(1), Aphys_n(1), Adyn_p(1)]);
    for j = 2:length(delta)
        A_p(j) = min([Aphys_p(j), Aphys_n(j), Adyn_p(j), A_p(j-1)]);
    end
    
    A_n(1) = min([Aphys_p(1), Aphys_n(1), Adyn_n(1)]);
    for j = 2:length(delta)
        A_n(j) = min([Aphys_p(j), Aphys_n(j), Adyn_n(j), A_n(j-1)]);
    end
    
    [sel c_p] = max( repmat(A_p,1,length(Accep.s))' < H_p, [], 2);
    c_p = c_p + (~sel)*(length(delta)-1);
    Accep.pos = delta(c_p);
    
    [sel c_n] = max( repmat(A_n,1,length(Accep.s))' < H_n, [], 2);
    c_n = c_n + (~sel)*(length(delta)-1);
    Accep.neg = -delta(c_n);
    
    %     if(flag_pol)
    %         n_deg = 6;
    %         for k = 1:length(pos);
    %             pol.betax(k,:) = fit_pol([-fliplr(delta(1:c_n)) delta(1:c_p)],...
    %                 [fliplr(betax_neg(k,1:c_n)) betax_pos(k,1:c_p)], n_deg);
    %             pol.alphax(k,:) = fit_pol([-fliplr(delta(1:c_n)) delta(1:c_p)],...
    %                 [fliplr(alphax_neg(k,1:c_n)) alphax_pos(k,1:c_p)], n_deg);
    %             pol.cox(k,:) = fit_pol([-fliplr(delta(1:c_n)) delta(1:c_p)],...
    %                 [fliplr(cox_neg(k,1:c_n)) cox_pos(k,1:c_p)], n_deg);
    %             pol.coxp(k,:) = fit_pol([-fliplr(delta(1:c_n)) delta(1:c_p)],...
    %                 [fliplr(coxp_neg(k,1:c_n)) coxp_pos(k,1:c_p)], n_deg);
    %         end
    %     end
    
    info.delta = delta;
    info.twi_p = twi_p;
    info.twi_n = twi_n;
    info.A_p = A_p;
    info.A_n = A_n;
    info.Aphys_p = Aphys_p;
    info.Aphys_n = Aphys_n;
    info.Adyn_p = Adyn_p;
    info.Adyn_n = Adyn_n;
    info.H_p = H_p;
    info.H_n = H_n;
    % info.pol = pol;
    info.tune_n = tune_n - floor(tune_n);
    info.tune_p = tune_p - floor(tune_p);
end

if plota
    figure; hold on; grid on; box on;
    title('Energy Acceptance')
    xlabel('Pos [m]')
    ylabel('$\delta\ [\%]$','interpreter','latex')
    plot(Accep.s, 100*[Accep.pos; Accep.neg], 'b')
    
    figure; hold on; grid on; box on;
    title('Energy Aperture')
    xlabel('$\delta\ [\%]$','interpreter','latex')
    ylabel('A [um]')
    plot(100*[-fliplr(delta), delta],1e6*[fliplr(Aphys_n'), Aphys_p'], 'b', 'LineWidth', 2);
    plot(100*[-fliplr(delta), delta],1e6*[fliplr(Adyn_n'),  Adyn_p'],  'm', 'LineWidth', 2);
    plot(100*[-fliplr(delta), delta],1e6*[fliplr(A_n'),  A_p'],  '--r');
    
    if isstruct(flag_dyn) || flag_dyn
        
        lost_turn_p = zeros(length(ep),length(H));
        lost_turn_n = zeros(length(ep),length(H));
        for i = 1:length(H)
            for j = 1:length(ep)
                turn = find(isnan(Rou_p(1,j,i,:)),1,'first');
                if isempty(turn), turn = NaN; end
                lost_turn_p(j,i) = turn;
                
                turn = find(isnan(Rou_n(1,j,i,:)),1,'first');
                if isempty(turn), turn = NaN; end
                lost_turn_n(j,i) = turn;
            end
        end
        norm = max(max(max(lost_turn_p,lost_turn_n)));
        r_p = reshape((lost_turn_p-1)/norm,1,[])';
        r_n = reshape((lost_turn_n-1)/norm,1,[])';
        
        figure; hold on; box on; grid on;
        title(sprintf('max = %d',norm));
        scatter(reshape(EP,1,[])', reshape(H0,1,[])', 12, [r_p, 1-r_p, 4*r_p.*(1-r_p)], 'filled');
        scatter(reshape(EN,1,[])', reshape(H0,1,[])', 12, [r_n, 1-r_n, 4*r_n.*(1-r_n)], 'filled');
        
        lost_turn_col = lost_turn_p(:);
        cdf = zeros(1,norm);
        for j = 1:norm, cdf(j) = sum(lost_turn_col>=j); end
        
        lost_turn_col = lost_turn_n(:);
        for j = 1:norm, cdf(j) = cdf(j) + sum(lost_turn_col>=j); end
        
        figure; box on; grid on; plot(cdf/cdf(1));
        info.cdf = cdf;
    end
end


function [twi, tune] = my_calctwiss(ring, delta, ind)
[TD, tune] = twissring(ring,delta,ind);

twi.pos = cat(1,TD.SPos);

beta = cat(1, TD.beta);
twi.betax = beta(:,1);
%twi.betay = beta(:,2);

alpha = cat(1, TD.alpha);
twi.alphax = alpha(:,1);
%twi.alphay = alpha(:,2);

% mu = cat(1, TD.mu);
% twi.mux = mu(:,1);
% twi.muy = mu(:,2);

co = cat(1,TD.ClosedOrbit);
twi.cox  = co(1:4:end);
twi.coxp = co(2:4:end);
twi.coy  = co(3:4:end);
twi.coyp = co(4:4:end);


% function py = fit_pol(x,y,n)
% 
% % Exclude unstable points:
% ind = ~isnan(y(:));
% 
% % Use only the first contiguous points for fitting:
% idx = find(diff(ind)==-1);
% if numel(idx), ii = idx(1); else ii = length(ind); end
% ind = ind(1:ii);
% 
% x  = x(ind); y = y(ind);
% x  = x(:); y = y(:);
% 
% if n <=9,ord = sprintf('poly%1d',n); else ord = 'poly9'; end
% 
% try
%     py = coeffvalues(fit(x,y,ord,'Robust','on'));
% catch
%     py = 1e15*ones(1,n+1);
% end
