function [coupling, xlist] = lnls_calc_emittance_coupling(the_ring, xlist)

% arguments
if ~exist('xlist','var')
    xlist = 1e-3 * linspace(-0.1,0.1,10);
end

nr_turns = 30;

% calcs 4d closed orbit
the_ring = setcavity('off', the_ring);
the_ring = setradiation('off', the_ring);
cod = [findorbit4(the_ring, 0); 0; 0];

% calcs twiss
twiss = calctwiss(the_ring);

% does tracking (around closed orbit)
coupling = zeros(1,length(xlist));
for i=1:length(xlist)
    pos_init = cod + [xlist(i); 0; 1e-5*xlist(i); 0; 0; 0];
    traj = ringpass(the_ring, pos_init, nr_turns);
    dtraj = traj - repmat(cod, 1, nr_turns);
    [emitx, emity] = calc_emittances(dtraj, twiss, 1);
    coupling(i) = emity / emitx;
end



function [ex, ey] = calc_emittances(cod, twiss, idx)

alphax = twiss.alphax(idx);
betax  = twiss.betax(idx);
gammax = (1 + alphax^2)/betax;

alphay = twiss.alphay(idx);
betay  = twiss.betay(idx);
gammay = (1 + alphay^2)/betay;

x  = cod(1,:);
xl = cod(2,:);
y  = cod(3,:);
yl = cod(4,:);

ex = gammax * x.^2 + 2 * alphax * x .* xl + betax * xl.^2;
ey = gammay * y.^2 + 2 * alphay * y .* yl + betay * yl.^2;

