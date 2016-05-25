function [aper0,aper1] = lnls_chaos_indicator(ring, plane,pos,plota, offset)

if ~exist('pos','var'), pos = 0.0; end
if ~exist('plota','var'), plota = false; end
if ~exist('offset','var'), offset = [0;0;0;0;0;0]; end

nturns = 132 - 1;
offset([2,4]) = offset([2,4]) + 1e-6; % a small delta to exclude singularity;
if strcmpi(plane,'x')
    pos = 0.0;
    lim = 1.02;
    pl = 1;
    i = 0; j = 0;
    xi =  -6e-3;
    xf = -13e-3;
    expoent = 1;
    np = 351;
elseif strcmpi(plane,'y')
    pos = 0.0;
    lim = 1.02;
    pl = 3;
    i = 1; j = 0;
    xi = 2e-3;
    xf = 3e-3;
    expoent = 1;
    np = 351;
elseif strcmpi(plane,'ep')
    lim = 1.02;
    pl = 5;
    i = 0; j = 1;
    xi = 2e-2;
    xf = 5e-2;
    expoent = 1;
    np = 351;
elseif strcmpi(plane,'en')
    lim = 1.02;
    pl = 5;
    i = 1; j = 1;
    xi = -2e-2;
    xf = -5e-2;
    expoent = 1;
    np = 351;
end

% Shift the ring to the point where the tracking will be done:
spos = findspos(ring,1:length(ring));
[~,point] = min(abs(pos-spos));
ring = ring([point:end,1:point-1]);

% create the vector of initial conditions
x = linspace(0,1,np).^expoent;
x = xi + (xf-xi)*x;
dx = diff(x);

Rin = repmat(offset(:),1,length(x));
Rin(pl,:) = x;

Rou = [Rin, ringpass(ring,Rin,nturns)];
Rou = reshape(Rou,6,length(x),[]);
% x0  = reshape(Rou(1,:),[],nturns+1);
% xl = reshape(Rou(2,:),[],nturns+1);
% y  = reshape(Rou(3,:),[],nturns+1);
% yl = reshape(Rou(4,:),[],nturns+1);
% ind = ~isnan(x0(:,end));
% tunex = NaN*ones(1,size(Rin,2));
% tuney = NaN*ones(1,size(Rin,2));
% tunex(ind) = lnls_calcnaff(x0(ind,:), xl(ind,:));
% tuney(ind) = lnls_calcnaff(y(ind,:), yl(ind,:));

lambda  = diff(Rou,1,2);
lambda1  = squeeze(sum(lambda.*lambda,1));

mlam    = mean(lambda1,2)';
nmlam   = mlam ./ x(1:end-1).^4 / nturns^2 ./ dx.^2;
hfmlam   = mean(lambda1(:,1:end/2),2)';
hfnmlam  = 4*hfmlam ./ x(1:end-1).^4 / nturns^2 ./ dx.^2;

d2nmlam = diff(nmlam,2,2);
d2hfnmlam = diff(hfnmlam,2,2);

ind0 = find(isnan(mlam),1,'first'); if isempty(ind0), ind0 = length(x); end;
aper0 = x(ind0);

ind1 = find(nmlam./hfnmlam > lim,1,'first');if isempty(ind1), ind1 = length(x); end;
aper1  = x(min([ind1,ind0]));

if plota
%     figure('OuterPosition',[633*0,540*(1-0),633, 540]);
%     plot(x(1:end-2),d1nsqrtmlam); hold all; plot(x,[on*lim;-on*lim]); ylim(3*lim*[-1,1]);
    figure('OuterPosition',[633*1,540*(1-0),633, 540]);
    plot(x(1:end-3),d2nmlam);% hold all; plot(x,[on*lim;-on*lim]); ylim(3*lim*[-1,1]);
    figure('OuterPosition',[633*1,540*(1-1),633, 540]); plot(x(1:end-1),nmlam./hfnmlam);
%     figure('OuterPosition',[633*1,540*(1-1),633, 540]);
%     plot(x(1:end-4),d3nsqrtmlam); hold all; plot(x,[on*lim;-on*lim]/10); ylim(3*lim/10*[-1,1]);
    
%     figure('OuterPosition',[633*0,540*(1-1),633, 540]); plot(Rou(1,:),Rou(2,:),'.');hold all;plot(squeeze(Rou(1,1:ch,:)),squeeze(Rou(2,1:ch,:)),'.r');
%     figure('OuterPosition',[633*1,540*(1-1),633, 540]); plot(Rou(3,:),Rou(4,:),'.');hold all;plot(squeeze(Rou(3,1:ch,:)),squeeze(Rou(4,1:ch,:)),'.r');
    drawnow;
end

