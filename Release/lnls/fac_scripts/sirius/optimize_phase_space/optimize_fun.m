function  [res, val, ring] = optimize_fun(ring, vec, opt, chr)

%first, lets build our extended vector;
extvec = [];
for ii = 1:length(opt.fam)
    extvec = [extvec vec(ii)*ones(1,opt.size(ii))];
end

% lets apply our vector to the ring
ring = setcellstruct(ring, 'PolynomB', opt.ind, extvec, 3);

% now, lets correct the chromaticity
ring = fitchrom2(ring,chr.value,chr.fam{1},chr.fam{2});
val = zeros(1,length(chr.fam));
for ii = 1:length(chr.fam)
    val(ii) = ring{chr.ind{ii}(1)}.PolynomB(3);
end

nturns = 1000;
nt = nextpow2(nturns);
nturns = 2^nt + 6 - mod(2^nt,6);
x_amps = -[0.1, 6.1:0.2:12]*1e-3;
y_amps = ones(1,length(x_amps))*1e-5;
other  = zeros(1,length(x_amps));
rin = [x_amps; other; y_amps; other; other; other];
rout = ringpass(ring,rin,nturns);

% Tentativa de aumentar a abertura
res = sum(isnan(rout(end,(end-length(x_amps)+1):end)));

e_amps = [-5.1:0.2:-2.1, 2.1:0.2:5.1]*1e-2;
x_amps = 1e-5*ones(1,length(e_amps));
y_amps = 1e-5*ones(1,length(e_amps));
other  = zeros(1,length(x_amps));
rin = [x_amps; other; y_amps; other; e_amps; other];
rout = ringpass(ring,rin,nturns);

res = res + sum(isnan(rout(end,(end-length(e_amps)+1):end)));


% % tentativa de diminuir o tuneshift
% coordx  = reshape(rout(1,:),length(rin(1,:)),nturns);
% coordxl = reshape(rout(2,:),length(rin(1,:)),nturns);
% coordy  = reshape(rout(3,:),length(rin(1,:)),nturns);
% coordyl = reshape(rout(4,:),length(rin(1,:)),nturns);
% tunex = lnls_calcnaff(coordx, coordxl);
% tuney = lnls_calcnaff(coordy, coordyl);
% 
% diffx = tunex(2:(length(x_amps)-1)) - tunex(1);
% diffy = tuney(2:(length(x_amps)-1)) - tuney(1);
% res = 5*sum(sqrt(diffx.^2 + diffy.^2));
    