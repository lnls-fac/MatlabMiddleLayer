function [aper2,aper3,diff_ind,tunes,x] = lnls_diffusion_indicator(ring,...
    plane, pos, plota, window, offset)

if ~exist('pos','var'), pos = 0.0; end
if ~exist('plota','var'), plota = false; end
if ~exist('offset','var'), offset = [0;0;0;0;0;0]; end
if ~exist('window','var'), window = [-1 0 0; 0 -1 0; 1 0 0.5; 0 1 0.5]; end

%number of tunes used to calculate the diffusion
ntunes = 2;

%diffusion algorithm requires 2 times nturns and "-1" for the initial
%condition;
n = 7;
nturns = 2*(2^n + 6 - mod(2^n,6)) - 1;

expoent = 1;
np = 351;

offset([2,4]) = offset([2,4]) + 1e-6; % a small delta to exclude singularity;
if strcmpi(plane,'x')
    lim_dif = 1e-04;
    pl = 1;
    xi =  -6e-3;
    xf = -13e-3;
elseif strcmpi(plane,'y')
    lim_dif = 1e-04;
    pl = 3;
    xi = 2e-3;
    xf = 3e-3;
elseif strcmpi(plane,'ep')
    lim_dif = 1e-04;
    pl = 5;
    xi = 2e-2;
    xf = 5e-2;
elseif strcmpi(plane,'en')
    lim_dif = 1e-04;
    pl = 5;
    xi = -2e-2;
    xf = -5e-2;
end
    
% Shift the ring to the point where the tracking will be done:
spos = findspos(ring,1:length(ring));
[~,point] = min(abs(pos-spos));
ring = ring([point:end,1:point-1]);

% create the vector of initial conditions
x = linspace(0,1,np).^expoent;
x = xi + (xf-xi)*x;
Rin = repmat(offset(:),1,length(x));
Rin(pl,:) = x;

Rou = [Rin, ringpass(ring,Rin,nturns)];
Rou = reshape(Rou,6,length(x),[]);

x0  = reshape(Rou(1,:),[],nturns+1); % +1, because of initial condition
xl = reshape(Rou(2,:),[],nturns+1);
y0  = reshape(Rou(3,:),[],nturns+1);
yl = reshape(Rou(4,:),[],nturns+1);
ind = ~isnan(x0(:,end));

%--------Diffusion--------%

tunex = NaN*ones(size(Rin,2),ntunes);
tuney = NaN*ones(size(Rin,2),ntunes);
amplx = NaN*ones(size(Rin,2),ntunes);
amply = NaN*ones(size(Rin,2),ntunes);
[tunex(ind,:) amplx(ind,:)] = lnls_calcnaff(x0(ind,1:end/2),...
    xl(ind,1:end/2),ntunes);
[tuney(ind,:) amply(ind,:)] = lnls_calcnaff(y0(ind,1:end/2),...
    yl(ind,1:end/2),ntunes);

tune1 = [tunex, tuney];
ampl1 = [amplx, amply];
[~,ind1] = sort(ampl1,2,'descend');
for j = 1:size(x0,1)
    tune1(j,:) = tune1(j,ind1(j,:));
end

tunex = NaN*ones(size(Rin,2),ntunes);
tuney = NaN*ones(size(Rin,2),ntunes);
amplx = NaN*ones(size(Rin,2),ntunes);
amply = NaN*ones(size(Rin,2),ntunes);
[tunex(ind,:) amplx(ind,:)] = lnls_calcnaff(x0(ind,end/2+1:end),...
    xl(ind,end/2+1:end),ntunes);
[tuney(ind,:) amply(ind,:)] = lnls_calcnaff(y0(ind,end/2+1:end),...
    yl(ind,end/2+1:end),ntunes);

tunes = [tunex(:,1) tuney(:,1)];

tune2 = [tunex, tuney];
ampl2 = [amplx, amply];
[~,ind2] = sort(ampl2,2,'descend');
for j = 1:size(x0,1)
    tune2(j,:) = tune2(j,ind2(j,:));
end

diff_ind = sqrt(sum( (tune2(:,1:ntunes)-tune1(:,1:ntunes)).^2 ,2));

if plota
    figure('OuterPosition',[633*1,540*(1-0),633, 540]);
    plot(x,diff_ind);
    str=sprintf('Plot of Diffusion (%d turns, %d tunes)', nturns, ntunes);
    title(str)
    xlabel(plane)
    ylabel('diffusion')
end

ind0 = max(find(isnan(x0(:,end)),1,'first')-1,1); if isempty(ind0), ind0=length(x); end;
%aper0 = x(ind0);

ind2 = find(diff_ind > lim_dif,1,'first');if isempty(ind2), ind2 = length(x); end;
aper2  = x(min([ind2,ind0]));

%---------Window---------%

tunex = lnls_calcnaff(x0(ind,:), xl(ind,:));
tuney = lnls_calcnaff(y0(ind,:), yl(ind,:));

% for j = 1:size(x0(ind,:),1)
%     if any(window(:,[1 2])*[tunex(j); tuney(j)] > window(:,3))
%         break;
%     end
% end

C = window(:,[1,2]) * [tunex,tuney]';
idx = any(C > repmat(window(:,3),1,size(C,2)),1);
ind3 = find(idx > 0,1,'first'); if isempty(ind3), ind3 = length(x); end;
aper3 = x(min([ind3,ind0]));

%------------------------%

end
