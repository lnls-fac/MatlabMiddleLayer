function [aper2,aper3,diff_ind,x] = lnls_diffusion_indicator(ring, plane, pos, plota, window, offset)

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

offset([2,4]) = offset([2,4]) + 1e-6; % a small delta to exclude singularity;
if strcmpi(plane,'x')
    pos = 0.0;
    lim = 1e-5;
    pl = 1;
    xi =  -6e-3;
    xf = -13e-3;
    expoent = 1;
    np = 351;
elseif strcmpi(plane,'y')
    pos = 0.0;
    lim = 5e-5;
    pl = 3;
    xi = 2e-3;
    xf = 3e-3;
    expoent = 1;
    np = 351;
elseif strcmpi(plane,'ep')
    lim = 2e-5;
    pl = 5;
    xi = 2e-2;
    xf = 5e-2;
    expoent = 1;
    np = 351;
elseif strcmpi(plane,'en')
    lim = 2e-5;
    pl = 5;
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
Rin = repmat(offset(:),1,length(x));
Rin(pl,:) = x;

Rou = [Rin, ringpass(ring,Rin,nturns)];
Rou = reshape(Rou,6,length(x),[]);

x0  = reshape(Rou(1,:),[],nturns+1); % +1, because of initial condition
xl = reshape(Rou(2,:),[],nturns+1);
y0  = reshape(Rou(3,:),[],nturns+1);
yl = reshape(Rou(4,:),[],nturns+1);
ind = ~isnan(x0(:,end));

%-----OLD-WAY-----%
% tunex = NaN*ones(size(Rin,2),2);
% tuney = NaN*ones(size(Rin,2),2);
% amplx = NaN*ones(size(Rin,2),2);
% amply = NaN*ones(size(Rin,2),2);
% [tunex(ind,:) amplx(ind,:)] = lnls_calcnaff(x0(ind,1:end/2), xl(ind,1:end/2),2);
% [tuney(ind,:) amply(ind,:)] = lnls_calcnaff(y0(ind,1:end/2), yl(ind,1:end/2),2);
% 
% tune1 = [tunex, tuney];
% ampl1 = [amplx, amply];
% [~,ind1] = sort(ampl1,2,'descend');
% for j=1:length(x0)
%     tune1(j,:) = tune1(j,ind1(j,:));
% end
% 
% tunex = NaN*ones(size(Rin,2),2);
% tuney = NaN*ones(size(Rin,2),2);
% amplx = NaN*ones(size(Rin,2),2);
% amply = NaN*ones(size(Rin,2),2);
% [tunex(ind,:) amplx(ind,:)] = lnls_calcnaff(x0(ind,end/2+1:end), xl(ind,end/2+1:end),2);
% [tuney(ind,:) amply(ind,:)] = lnls_calcnaff(y0(ind,end/2+1:end), yl(ind,end/2+1:end),2);
% 
% tune2 = [tunex, tuney];
% ampl2 = [amplx, amply];
% [~,ind2] = sort(ampl2,2,'descend');
% for j=1:length(x0)
%     tune2(j,:) = tune2(j,ind2(j,:));
% end
% 
% diff_ind = sqrt( (tune2(:,1)-tune1(:,1)).^2 + (tune2(:,2)-tune1(:,2)).^2 );
% 
% if plota
%     figure('OuterPosition',[633*1,540*(1-0),633, 540]);
%     plot(x,diff_ind);
% end
% 
% ind0 = find(diff_ind > lim,1,'first');if isempty(ind0), ind0 = length(x); end;
% aper2  = x(ind0);
% 
% aper3 = 0;
%-----OLD-WAY-----%



%--------Diffusion--------%

tunex = NaN*ones(size(Rin,2),ntunes);
tuney = NaN*ones(size(Rin,2),ntunes);
amplx = NaN*ones(size(Rin,2),ntunes);
amply = NaN*ones(size(Rin,2),ntunes);
[tunex(ind,:) amplx(ind,:)] = lnls_calcnaff(x0(ind,1:end/2), xl(ind,1:end/2),ntunes);
[tuney(ind,:) amply(ind,:)] = lnls_calcnaff(y0(ind,1:end/2), yl(ind,1:end/2),ntunes);

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
[tunex(ind,:) amplx(ind,:)] = lnls_calcnaff(x0(ind,end/2+1:end), xl(ind,end/2+1:end),ntunes);
[tuney(ind,:) amply(ind,:)] = lnls_calcnaff(y0(ind,end/2+1:end), yl(ind,end/2+1:end),ntunes);

tune2 = [tunex, tuney];
ampl2 = [amplx, amply];
[~,ind2] = sort(ampl2,2,'descend');
for j = 1:size(x0,1)
    tune2(j,:) = tune2(j,ind2(j,:));
end

diff_ind = sqrt(sum(tune2(:,1:ntunes)-tune1(:,1:ntunes),2).^2);

if plota
    figure('OuterPosition',[633*1,540*(1-0),633, 540]);
    plot(x,diff_ind);
    str=sprintf('Plot of Diffusion (%d turns, %d tunes)', nturns, ntunes);
    title(str)
    xlabel(plane)
    ylabel('diffusion')
end

ind0 = find(diff_ind > lim,1,'first');if isempty(ind0), ind0 = length(x); end;
aper2  = x(ind0);

%---------Window---------%

tunex = lnls_calcnaff(x0(ind,:), xl(ind,:));
tuney = lnls_calcnaff(y0(ind,:), yl(ind,:));

for j = 1:size(x0(ind,:),1)
    if window(:,[1 2])*[tunex(j); tuney(j)] > window(:,end)
        break;
    end
end

aper3 = x(j);

%------------------------%

end
