function [Accp,ind] = lnls_calc_touschek_amp(the_ring)
% [Accp,ind] = lnls_calc_touschek_amp(the_ring)
%  Function lnls_calc_touschek_amp calculates the transverve linear energy
%  acceptance of the_ring, considering its twiss functions and vacuum
%  chamber.
% 
%  INPUT:   the_ring = model of the ring
%  OUTPUS: 
%    Accp   = energy acceptance along the ring;
%    ind    = indices of the ring where the vacuum chamber is defined and
%             the energy acceptance was calculated.


twi = calctwiss(the_ring,1:length(the_ring));
ind = findcells(the_ring,'VChamber');
cham = getcellstruct(the_ring,'VChamber',ind,1,1);

a = -(twi.etaxl./twi.etax.*twi.betax + twi.alphax);

Amp0  = abs((twi.etax.*sqrt((1+a.^2)./twi.betax))');
etax  = abs(repmat(twi.etax,fliplr(size(twi.etax))));
Amp0  = repmat(Amp0,fliplr(size(Amp0)));
betax = repmat(twi.betax,fliplr(size(twi.betax)));
Amp = etax + Amp0.*sqrt(betax);

Accp = min(repmat(cham,1,length(cham))./Amp(ind,ind));



