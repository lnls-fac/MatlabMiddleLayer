function r = calctwiss(varargin)
% r = calctwiss(varargin)
%
% calcula par?metros de twiss da rede.
% Inputs opcionais: 
% 1) the_ring, 
% 2) 'n+1' : calcula twiss no final do modelo tambem.
% 3) dp : calcula os parâmetros de twiss para o dado desvio de energia
% 4) elements : calcula os PT para os elementos especificados
%
% 2013-04-24 parametro 'n+1' adicional.
% 2011-??-?? versao original.


global THERING;

np1_flag = false;
elements = [];
the_ring = THERING;
dp = 0;
for i=1:length(varargin)
    if iscell(varargin{i})
        the_ring = varargin{i};
    elseif ischar(varargin{i})
        if strcmpi(varargin{i}, 'N+1')
            np1_flag = true;
        end
    elseif isnumeric(varargin{i})
        if length(varargin{i}) ==1
            dp = varargin{i};
        else
            elements = varargin{i};
        end
    end
end

if isempty(elements)
    if np1_flag
        elements = 1:(length(the_ring)+1);
    else
        elements = 1:length(the_ring);
    end
end

[TD, tune, chrom] = twissring(the_ring,dp,elements, 'chrom',1e-8);

for i=1:length(TD)
    the_ring{i}.Twiss = TD(i);
end

r.pos = cat(1,TD.SPos);

beta = cat(1, TD.beta);
r.betax = beta(:,1);
r.betay = beta(:,2);

alpha = cat(1, TD.alpha);
r.alphax = alpha(:,1);
r.alphay = alpha(:,2);

mu = cat(1, TD.mu);
r.mux = mu(:,1);
r.muy = mu(:,2);

disp = cat(1,TD.Dispersion);
r.etax  = disp(1:4:end);
r.etaxl = disp(2:4:end);
r.etay  = disp(3:4:end);
r.etayl = disp(4:4:end);

co = cat(1,TD.ClosedOrbit);
r.cox  = co(1:4:end);
r.coxp = co(2:4:end);
r.coy  = co(3:4:end);
r.coyp = co(4:4:end);

r.chromx = chrom(1);
r.chromy = chrom(2);

if isempty(varargin)
    THERING = the_ring;
else
    r.THERING = the_ring;
end






