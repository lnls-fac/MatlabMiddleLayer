function [x, y, x1, y1] = lnls_calc_physical_acceptance(the_ring, idx, nrpts)
% (x,y)   : physical acceptance
% (x1,y1) : physical aperture at element 'idx'

accx = getcellstruct(the_ring, 'VChamber', 1:length(the_ring), 1, 1);
accy = getcellstruct(the_ring, 'VChamber', 1:length(the_ring), 1, 2);
n    = getcellstruct(the_ring, 'VChamber', 1:length(the_ring), 1, 3);
t    = calctwiss(the_ring);

betax = t.betax;
betay = t.betay;
x1min  = min(sqrt(betax(idx)) * accx ./ sqrt(t.betax));
x      = linspace(-x1min,x1min,nrpts)';

y = Inf * ones(size(x))';
for i=1:length(betax)
    xgrid  = sqrt(betax(i)) * x / sqrt(betax(idx));
    ygrid  = accy(i) * (1 - (xgrid / accx(i)).^n(i)) .^ (1/n(i));
    y1grid = sqrt(betay(idx)) * ygrid / sqrt(betay(i));
    y      = min([y; y1grid']);
end
y = real(y');

x1  = linspace(-accx(idx), accx(idx), nrpts)';
y1  = accy(idx) * (1 - (x1 / accx(idx)).^n(idx)) .^ (1/n(idx));
