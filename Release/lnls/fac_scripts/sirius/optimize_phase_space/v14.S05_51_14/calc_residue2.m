function [res,a] = calc_residue2(x, opt)

ring = opt.set_values(opt.ring,opt.knobs,x);
% ring = setcavity('on',ring);
% ring = setradiation('on',ring);

de = 0;
nturns = 200;
%Tune-shifts with amplitude and energy:
amps.x   =-(40:2:130)*1e-4;
amps.y   = (10:1:30)*1e-4;
amps.en1 =-(20:2:55)*1e-3;
amps.ep1 = (20:2:55)*1e-3;
amps.en2 =-(14:2:45)*1e-3;
amps.ep2 = (14:2:45)*1e-3;

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

len  = length(amps.en1);
Rin.en1 = [res_a*ones(1,len)+orb(1); zeros(1,len)+orb(2);...
          res_a*ones(1,len)+orb(3); zeros(1,len)+orb(4);...
          amps.en1 + orb(5);        zeros(1,len)+orb(6)];
anel.en1 = ring;
      
len  = length(amps.ep1);
Rin.ep1 = [res_a*ones(1,len)+orb(1); zeros(1,len)+orb(2);...
         res_a*ones(1,len)+orb(3); zeros(1,len)+orb(4);...
         amps.ep1 + orb(5);        zeros(1,len)+orb(6)];
anel.ep1 = ring;

maccep = findcells(ring,'FamName','calc_mom_accep');
ring = ring([maccep(6):end,1:maccep(6)-1]);
len  = length(amps.en2);
Rin.en2 = [res_a*ones(1,len)+orb(1); zeros(1,len)+orb(2);...
          res_a*ones(1,len)+orb(3); zeros(1,len)+orb(4);...
          amps.en2 + orb(5);        zeros(1,len)+orb(6)];
anel.en2 = ring;
      
len  = length(amps.ep2);
Rin.ep2= [res_a*ones(1,len)+orb(1); zeros(1,len)+orb(2);...
         res_a*ones(1,len)+orb(3); zeros(1,len)+orb(4);...
         amps.ep2 + orb(5);        zeros(1,len)+orb(6)];
anel.ep2 = ring;

%% Particle loss or tune outside the permited window
tunex_int = [0.2,0.3];
tuney_int = [0.1,0.2];
lost.ep2 = [];   lost.en2 = [];
lost.ep1 = [];   lost.en1 = [];
lost.y = [];     lost.x = [];
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
        res = -[1e-6,1e-3,1e-3];
        a = true;
        return
    end
    lost.(pl) = ind;
end

x = amps.x(lost.x);
y = amps.y(lost.y);
en1 = amps.en1(lost.en1);
ep1 = amps.ep1(lost.ep1);
en2 = amps.en2(lost.en2);
ep2 = amps.ep2(lost.ep2);
ar =  -x * y;
accep1 = min(abs([ep1,en1]));
accep2 = min(abs([ep2,en2]));
res = -[ar,accep1,accep2];
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


%% Calc Relative Lyapunov Indicator
Rou = [Rin,Rout];
Rou = reshape(Rou,6,size(Rin,2),[]);

% lam  = diff(Rou,1,2);
% lam2  = squeeze(sqrt(sum(lam.*lam,1)));
% % lam3  = lam2(:,2:end)./lam2(:,1:end-1);
% dlam2 = mean(diff(lam2,1,1),2);
% % dlam3 = mean(diff(lam3,1,1),2);
% ch1 = find(isnan(dlam2), 1, 'first')-1;
% if isempty(ch1), ch1 = size(Rin,2); end;
% ch2 = find(sign(dlam2) == -1, 1, 'first'); % maybe I should be a little less restrictive here.
% if isempty(ch2), ch2 = size(Rin,2); end;
% ch = min(ch1,ch2);

%new way
lam  = diff(Rou,1,2);
lam  = (squeeze(sqrt(sum(lam.*lam,1))));
mlam = mean(lam,2);
dlam = diff(mlam,1,1);
rdlam = dlam./mlam(1:end-1);
drdlam = diff(rdlam);
ch1 = find(isnan(dlam), 1, 'first')-1;
if isempty(ch1), ch1 = size(Rin,2); end;
ch2 = find(abs(drdlam) > 0.1,1,'first') + 3;
if isempty(ch2), ch2 = size(Rin,2); end;
ch = min(ch1,ch2);

%%Calc tunes
ind = 1:ch;
tunex = NaN*ones(1,size(Rin,2));
tuney = NaN*ones(1,size(Rin,2));
tunex(ind) = lnls_calcnaff(x(ind,:), xl(ind,:));
tuney(ind) = lnls_calcnaff(y(ind,:), yl(ind,:));