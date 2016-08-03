function [Accep, tune] = lnls_calc_touschek_accep(ring,delta)
% [Accp,ind] = lnls_calc_touschek_accep(ring,delta)
%  Function lnls_calc_touschek_accep calculates the transverve linear energy
%  acceptance of the_ring, considering its twiss functions and vacuum
%  chamber.
%
%  INPUTS:
%   ring        = model of the ring;
%	delta (opt) = set with different energy deviation values to search,
%                 default is linspace(-0.055,0.055,50).
%                 If delta is singleton, then it uses the expansion
%                 around delta (do not calculate tune).
%
%  OUTPUS:
%	Accep.ind  = indices of the ring where the vacuum chamber is defined and
%                the energy acceptance was calculated;
%   Accep.s    = position in meters of each Accep.ind;
%   Accep.pos  = positive energy acceptance along the ring;
%   Accep.neg  = negative energy acceptance along the ring;
%   tune       = fractional part of the tunes for each value in delta.


if(~exist('delta','var')), delta = linspace(-0.055,0.055,50); end

Accep.ind = findcells(ring,'VChamber');
spos = findspos(ring,1:length(ring));
Accep.s = spos(Accep.ind);

[Accep.s, perm] = unique(Accep.s,'first');
Accep.ind = Accep.ind(perm);

cham_pos = getcellstruct(ring,'VChamber',Accep.ind,1,1);
cham_neg = -getcellstruct(ring,'VChamber',Accep.ind,1,1);

if(length(delta) == 1)
    twi = calctwiss(ring, Accep.ind, delta);
    
    H = ((twi.etax.^2+(twi.betax.*twi.etaxl+twi.alphax.*twi.etax).^2)./twi.betax)';
    
    H = repmat(H,fliplr(size(H)));
    etax  = abs(repmat(twi.etax,fliplr(size(twi.etax))));
    betax = repmat(twi.betax,fliplr(size(twi.betax)));
    
    Amp_pos = etax + sqrt(H.*betax);
    Accep.pos = min(repmat(cham_pos,1,length(cham_pos))./Amp_pos);
else
    % calculate acceptance for positive energy deviation
    delta_pos = delta(delta >= 0);
    if(~isempty(delta_pos))        
        Amp_pos = zeros(length(Accep.ind),length(Accep.ind),length(delta_pos));
        tune_pos = zeros(length(delta_pos),2);
        twi0 = my_calctwiss(ring, 0,Accep.ind);
        for j = 1:length(delta_pos)
            [twi, tune_pos(j,:)] = my_calctwiss(ring, delta_pos(j),Accep.ind);
            
            dcox = twi.cox - twi0.cox;
            dcoxp = twi.coxp - twi0.coxp;
            H = ((dcox.^2+(twi.betax.*dcoxp+twi.alphax.*dcox).^2)./twi.betax)';
            
            H = repmat(H,fliplr(size(H)));
            cox  = repmat(twi.cox,fliplr(size(twi.cox)));
            betax = repmat(twi.betax,fliplr(size(twi.betax)));
            
            Amp_pos(:,:,j) = cox + sqrt(H.*betax);
        end
        
        cham_pos = repmat(cham_pos, [1 size(Amp_pos,2) size(Amp_pos,3)]);
        ind_accp = Amp_pos > cham_pos;
        
        Accep.pos = zeros(1,size(Amp_pos,2));
        for j = 1:size(Amp_pos,2)
            [~, c] = find(squeeze(ind_accp(:,j,:)),1,'first');
            if isempty(c), c = size(Amp_pos,3); end
            Accep.pos(j) = delta_pos(min(c));
        end
    end
    
    % calculate acceptance for negative energy deviation
    delta_neg = delta(delta < 0);
    if(~isempty(delta_neg))        
        Amp_neg = zeros(length(Accep.ind),length(Accep.ind),length(delta_neg));
        tune_neg = zeros(length(delta_neg),2);
        twi0 = my_calctwiss(ring, 0,Accep.ind);
        for j = 1:length(delta_neg)
            [twi, tune_neg(j,:)] = my_calctwiss(ring, delta_neg(j),Accep.ind);
            
            dcox = twi.cox - twi0.cox;
            dcoxp = twi.coxp - twi0.coxp;
            H = ((dcox.^2+(twi.betax.*dcoxp+twi.alphax.*dcox).^2)./twi.betax)';
            
            H = repmat(H,fliplr(size(H)));
            cox  = repmat(twi.cox,fliplr(size(twi.cox)));
            betax = repmat(twi.betax,fliplr(size(twi.betax)));
            
            Amp_neg(:,:,j) = cox - sqrt(H.*betax);
        end
        
        cham_neg = repmat(cham_neg, [1 size(Amp_neg,2) size(Amp_neg,3)]);
        ind_accp = Amp_neg < cham_neg;
        
        Accep.neg = zeros(1,size(Amp_neg,2));
        for j = 1:size(Amp_neg,2)
            [~, c] = find(squeeze(ind_accp(:,j,:)),1,'last');
            if isempty(c), c = 1; end
            Accep.neg(j) = delta_neg(max(c));
        end
    end
    tune = [tune_neg; tune_pos];
    tune = tune - floor(tune);
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
