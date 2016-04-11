function [res,a] = calc_residue2(x, opt)

ring = opt.set_values(opt.ring,opt.knobs,x);
% ring = setcavity('on',ring);
% ring = setradiation('on',ring);

de = 0;
nturns = 200;
%Tune-shifts with amplitude and energy:
amps.x   =-(40:2:130)*1e-4;
amps.y   = (10:2:30)*1e-4;
amps.en  =-(20:2:55)*1e-3;
amps.ep  = (20:2:55)*1e-3;

if strcmpi('on',getcavity(ring))
    orb = findorbit6(ring);
else
    orb = [findorbit4(ring,de);de;0];
end

res_a = 1e-4;
%%
len = length(amps.x);
Rin.x= [amps.x + orb(1);         zeros(1,len)+orb(2);...
        res_a*ones(1,len)+orb(3); zeros(1,len)+orb(4);...
        zeros(1,len)+orb(5);     zeros(1,len)+orb(6)];
anel.x = ring;
    
len  = length(amps.y);
Rin.y= [res_a*ones(1,len)+orb(1); zeros(1,len)+orb(2);...
         amps.y + orb(3);        zeros(1,len)+orb(4);...
        zeros(1,len) + orb(5);   zeros(1,len)+orb(6)];
anel.y = ring;
    
maccep = findcells(ring,'FamName','calc_mom_accep');
ring = ring([maccep(3):end,1:maccep(3)-1]);
len  = length(amps.en);
Rin.en = [res_a*ones(1,len)+orb(1); zeros(1,len)+orb(2);...
          res_a*ones(1,len)+orb(3); zeros(1,len)+orb(4);...
          amps.en + orb(5);        zeros(1,len)+orb(6)];
anel.en = ring;
      
len  = length(amps.ep);
Rin.ep= [res_a*ones(1,len)+orb(1); zeros(1,len)+orb(2);...
         res_a*ones(1,len)+orb(3); zeros(1,len)+orb(4);...
         amps.ep + orb(5);        zeros(1,len)+orb(6)];
anel.ep = ring;

%% Particle loss or tune outside the permited window
tunex_int = [0.2,0.3];
tuney_int = [0.1,0.2];
lost.ep = [];   lost.en = [];    lost.y = [];   lost.x = [];
pls = fieldnames(lost);
for i=1:length(pls)
    pl = pls{i};
    [tunex.(pl),tuney.(pl)] = get_frac_tunes(anel.(pl),Rin.(pl),nturns);
    loss = isnan(tunex.(pl));
    loss = loss | ...
        (tunex.(pl) < tunex_int(1) | tunex.(pl) > tunex_int(2)) | ...
        (tuney.(pl) < tuney_int(1) | tuney.(pl) > tuney_int(2));
    ind = find(diff(loss) == 1);
    if loss(1) == 0
        if isempty(ind)
            ind = length(loss);
        else
            ind = ind(1);
        end
    else
        res = -[1e-6,1e-3];
        a = true;
        return
    end
    lost.(pl) = ind;
end

x = amps.x(lost.x);
y = amps.y(lost.y);
en = amps.en(lost.en);
ep = amps.ep(lost.ep);
ar =  -x * y;
accep = min(abs([ep,en]));
res = -[ar,accep];
a = true;
function [tunex,tuney] = get_frac_tunes(ring,Rin,nturns)

% escolha do metodo para calculo das sintonias:
if ~exist('nturns','var'), nturns = 100; end

% ajuste do numero de voltas para que seja compativel com o naff
nt = nextpow2(nturns);
nturns = 2^nt + 6 - mod(2^nt,6);

Rout = ringpass(ring,Rin,nturns);
x  = reshape(Rout(1,:),[],nturns);
xl = reshape(Rout(2,:),[],nturns);
y  = reshape(Rout(3,:),[],nturns);
yl = reshape(Rout(4,:),[],nturns);

ind = ~isnan(x(:,end));
tunex = NaN*ind;
tuney = NaN*ind;
tunex(ind) = lnls_calcnaff(x(ind,:), xl(ind,:));
tuney(ind) = lnls_calcnaff(y(ind,:), yl(ind,:));