function [Accep, tune_pos, tune_neg, pol] = lnls_calc_touschek_accep(ring,delta,plota,pos)
% [Accp, tune_pos, tune_neg] = lnls_calc_touschek_accep(ring,delta)
%  Function lnls_calc_touschek_accep calculates the transverve linear energy
%  acceptance of the_ring, considering its twiss functions and vacuum
%  chamber.
%
%  INPUTS:
%   ring        = model of the ring;
%	delta (opt) = set with different energy deviation values to search,
%                 default is linspace(1e-6,0.065,60).
%                 If delta is singleton, then it uses the expansion
%                 around delta (do not calculate tune).
%   plota (opt) = boolean to decide if plot acceptance. Default is false.
%   pos (opt)   = positions for which we want pol (see OUTPUTS: pol).
%
%  OUTPUTS:
%	Accep.ind  = indices of the ring where the vacuum chamber is defined and
%                the energy acceptance was calculated;
%   Accep.s    = position in meters of each Accep.ind;
%   Accep.pos  = positive energy acceptance along the ring;
%   Accep.neg  = negative energy acceptance along the ring;
%   tune       = fractional part of the tunes for each value in delta.
%   pol        = struct with fields .betax, alphax, .cox and .coxp
%                containing fitting polinomials (in delta) for each 'pos'.


if(~exist('delta','var') || isempty(delta)), delta = linspace(1e-6,0.065,60); end
if(~exist('plota','var')), plota = false; end
if(exist('pos','var')), 
    flag  = true;
    betax_pos  = zeros(length(pos),length(delta));
    betax_neg  = zeros(length(pos),length(delta));
    alphax_pos = zeros(length(pos),length(delta));
    alphax_neg = zeros(length(pos),length(delta));    
    cox_pos    = zeros(length(pos),length(delta));
    cox_neg    = zeros(length(pos),length(delta));
    coxp_pos   = zeros(length(pos),length(delta));
    coxp_neg   = zeros(length(pos),length(delta));
else
    flag = false;
end

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
    
    if(~any(delta > 0)), error('delta must be a positive vector.'); end

    tune_pos = zeros(length(delta),2);
    tune_neg = zeros(length(delta),2);
    
    H_p_ind = Inf*ones(length(Accep.ind),length(delta));
    H_n_ind = Inf*ones(length(Accep.ind),length(delta));
    A_pos = zeros(length(delta),1);
    A_neg = zeros(length(delta),1);
    A_phys = zeros(length(delta),1);
    
    for j = 1:length(delta)
        [twi_pos, tune_pos(j,:)] = my_calctwiss(ring, delta(j),Accep.ind);
        [twi_neg, tune_neg(j,:)] = my_calctwiss(ring, -delta(j),Accep.ind);
        
        if(flag)
            ind_pos = dsearchn(Accep.s',pos');
            betax_pos(:,j)  = twi_pos.betax(ind_pos);
            betax_neg(:,j)  = twi_neg.betax(ind_pos);
            alphax_pos(:,j) = twi_pos.alphax(ind_pos);
            alphax_neg(:,j) = twi_neg.alphax(ind_pos);
            cox_pos(:,j)    = twi_pos.cox(ind_pos);
            cox_neg(:,j)    = twi_neg.cox(ind_pos);
            coxp_pos(:,j)   = twi_pos.coxp(ind_pos);
            coxp_neg(:,j)   = twi_neg.coxp(ind_pos);
        end
        
        if( any(imag(tune_pos(j,:))) || any(imag(tune_neg(j,:))))
            tune_pos(j,:) = [NaN NaN];
            tune_neg(j,:) = [NaN NaN];
        else
            % positive energies
            dcox = twi_pos.cox - twi0.cox;
            dcoxp = twi_pos.coxp - twi0.coxp;
            H = ((dcox.^2+(twi_pos.betax.*dcoxp+twi_pos.alphax.*dcox).^2)./twi_pos.betax)';
            
            A_loc = min((VC_pos - twi_pos.cox).^2, (VC_neg - twi_pos.cox).^2);
            A_pos(j) = min(A_loc./twi_pos.betax);
            H_p_ind(:,j) = H;
            
            % negative energies
            dcox = twi_neg.cox - twi0.cox;
            dcoxp = twi_neg.coxp - twi0.coxp;
            H = ((dcox.^2+(twi_neg.betax.*dcoxp+twi_neg.alphax.*dcox).^2)./twi_neg.betax)';
            
            A_loc = min((VC_pos - twi_neg.cox).^2, (VC_neg - twi_neg.cox).^2);
            A_neg(j) = min(A_loc./twi_neg.betax);
            H_n_ind(:,j) = H;
                     
            % amplitudes
            if j == 1
                A_phys(j) = min([A_pos(j), A_neg(j)]);
            else
                A_phys(j) = min([A_pos(j), A_neg(j), A_phys(j-1)]);
            end
        end
    end
    
    [sel c_p] = max( repmat(A_phys,1,length(Accep.s))' < H_p_ind, [], 2);
    c_p = c_p + (~sel)*(length(delta)-1);
    Accep.pos = delta(c_p);
    
    [sel c_n] = max( repmat(A_phys,1,length(Accep.s))' < H_n_ind, [], 2);
    c_n = c_n + (~sel)*(length(delta)-1);
    Accep.neg = -delta(c_n);
    
    if(flag)
        n_deg = 6;
        for k = 1:length(pos);
            pol.betax(k,:) = fit_pol([-fliplr(delta(1:c_n)) delta(1:c_p)],...
                [fliplr(betax_neg(k,1:c_n)) betax_pos(k,1:c_p)], n_deg);
            pol.alphax(k,:) = fit_pol([-fliplr(delta(1:c_n)) delta(1:c_p)],...
                [fliplr(alphax_neg(k,1:c_n)) alphax_pos(k,1:c_p)], n_deg);
            pol.cox(k,:) = fit_pol([-fliplr(delta(1:c_n)) delta(1:c_p)],...
                [fliplr(cox_neg(k,1:c_n)) cox_pos(k,1:c_p)], n_deg);
            pol.coxp(k,:) = fit_pol([-fliplr(delta(1:c_n)) delta(1:c_p)],...
                [fliplr(coxp_neg(k,1:c_n)) coxp_pos(k,1:c_p)], n_deg);
        end
    end
    
    tune_neg = tune_neg - floor(tune_neg);
    tune_pos = tune_pos - floor(tune_pos);
end

if plota
    figure; hold on; grid on; box on;
    title('Energy Acceptance')
    xlabel('Pos [m]')
    ylabel('$\delta\ [\%]$','interpreter','latex')
    plot(Accep.s, 100*[Accep.pos; Accep.neg], 'b')
    
    figure; hold on; grid on; box on;
    title('Physical Aperture')
    xlabel('$\delta\ [\%]$','interpreter','latex')
    ylabel('A_{phys} [um]')
    plot(100*[-fliplr(delta), delta],1e6*[fliplr(A_neg'), A_pos'], 'b');
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
%twi.coy  = co(3:4:end);
%twi.coyp = co(4:4:end);


function py = fit_pol(x,y,n)

% Exclude unstable points:
ind = ~isnan(y(:));

% Use only the first contiguous points for fitting:
idx = find(diff(ind)==-1);
if numel(idx), ii = idx(1); else ii = length(ind); end
ind = ind(1:ii);

x  = x(ind); y = y(ind);
x  = x(:); y = y(:);

if n <=9,ord = sprintf('poly%1d',n); else ord = 'poly9'; end

try
    py = coeffvalues(fit(x,y,ord,'Robust','on'));
catch
    py = 1e15*ones(1,n+1);
end
