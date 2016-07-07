function indicator = lnls_chaos_indicator(ring, plane, pos, plota, window, offset)

indicator = struct('aper_stb', [], 'aper_adr', [], 'aper_dif', [], ...
    'aper_win', [], 'adr', [], 'x_adr', [], 'dif', [], ...
    'tunex', [], 'tuney', [], 'x_dif', []);

if ~exist('pos','var'), pos = 0.0; end
if ~exist('plota','var'), plota = false; end
if ~exist('offset','var'), offset = [0;0;0;0;0;0]; end
if ~exist('window','var'), window = [-1 0 0; 0 -1 0; 1 0 0.5; 0 1 0.5]; end

if and(length(pos) > 1, size(offset,2) > 1)
    warning('Input of several pos and offset is not allowed, I will continue only with the first column of offset.');
    offset = offset(:,1);
end

if length(pos) > 1
    for i = 1:length(pos)
        aux = chaos_indicator(ring, plane, pos(i), plota, window, offset);
        indicator.aper_stb(i) = aux.aper_stb; indicator.aper_adr(i) = aux.aper_adr;
        indicator.aper_dif(i) = aux.aper_dif; indicator.aper_win(i) = aux.aper_win;
        indicator.nmlam(:,i) = aux.nmlam;
        indicator.adr(:,i) = aux.adr;
        indicator.dif(:,i) = aux.dif;
        indicator.tunex(:,i) = aux.tunes(:,1);
        indicator.tuney(:,i) = aux.tunes(:,2);
    end
else
    for i = 1:size(offset,2)
        aux = chaos_indicator(ring, plane, pos, plota, window, offset(:,i));
        indicator.aper_stb(i) = aux.aper_stb; indicator.aper_adr(i) = aux.aper_adr;
        indicator.aper_dif(i) = aux.aper_dif; indicator.aper_win(i) = aux.aper_win;
        indicator.adr(:,i) = aux.adr;
        indicator.dif(:,i) = aux.dif;
        indicator.tunex(:,i) = aux.tunes(:,1);
        indicator.tuney(:,i) = aux.tunes(:,2);
    end
end

indicator.x_adr = aux.x_adr;
indicator.x_dif = aux.x_dif;

end

function indicator = chaos_indicator(ring, plane, pos, plota, window, offset)

indicator = struct('aper_stb', 0, 'aper_adr', 0, 'aper_dif', 0, 'aper_win', 0,...
    'adr', [], 'x_adr', [], 'dif', [], 'tunes', [], 'x_dif', []);

n_adr = 7; %power of two number of turns to find the average distance ratio;
n_dif = 7; %power of two times two number of turns to find the diffusion;

n_adr = (2^n_adr + 6 - mod(2^n_adr,6)) - 1; %to satisfy naff conditions
n_dif = 2*(2^n_dif + 6 - mod(2^n_dif,6)) - 1; %to satisfy naff conditions

nturns = max(n_adr, n_dif);

ntunes = 2; % number of tunes used to calculate the diffusion;

expoent = 1; % exponential spacing between initial conditions
np = 351; % number of initial conditions

offset([2,4]) = offset([2,4]) + 1e-6; % a small delta to exclude singularity;

if strcmpi(plane,'x')
    lim_adr = 1.05;
    lim_dif = 1e-04;
    pl = 1;
    xi =  -6e-3;
    xf = -13e-3;
elseif strcmpi(plane,'y')
    lim_adr = 1.05;
    lim_dif = 1e-04;
    pl = 3;
    xi = 2e-3;
    xf = 3e-3;
elseif strcmpi(plane,'ep')
    lim_adr = 1.05;
    lim_dif = 1e-04;
    pl = 5;
    xi = 2e-2;
    xf = 5e-2;
elseif strcmpi(plane,'en')
    lim_adr = 1.05;
    lim_dif = 1e-04;
    pl = 5;
    xi = -2e-2;
    xf = -5e-2;
end

% create the vector of initial conditions
x = linspace(0,1,np).^expoent;
x = xi + (xf-xi)*x;
Rin = repmat(offset(:),1,length(x));
Rin(pl,:) = x;

% shift the ring to the point where the tracking will be done:
spos = findspos(ring,1:length(ring));
[~,point] = min(abs(pos-spos));
ring = ring([point:end,1:point-1]);

% tracking
Rou = [Rin, ringpass(ring,Rin,nturns)];
Rou = reshape(Rou,6,length(x),[]);

%-----------------Stability-----------------%

ind0 = find(isnan(Rou(1,:,end)),1,'first'); if isempty(ind0), ind0=length(x); end;
indicator.aper_stb = x(ind0);

%----------Average-Distance-Ratio-----------%

Rou_adr = Rou(:,:,1:n_adr+1);

x_dP = [0; 0; 0; 0];
for j=1:size(Rou_adr,2)
    x_dP = findorbit4(ring, Rou_adr(5,j,1),1,[x_dP; 0; 0]);
    Rou_adr(1:4,j,:) = Rou_adr(1:4,j,:) - repmat(x_dP, [1,1,size(Rou_adr,3)]);
end

delta_x = diff(Rou_adr,1,2);
exp2 = mean(delta_x.*delta_x,3);

delta_x = delta_x(:,:,1:end/2);
exp1 = mean(delta_x.*delta_x,3);

adr = sqrt(mean((exp2(1:4,:)./exp1(1:4,:)/4)));

ind1 = find(adr > lim_adr,1,'first'); if isempty(ind1), ind1 = length(x); end;
indicator.aper_adr  = x(min([ind1,ind0]));

indicator.adr = adr;
indicator.x_adr = x(1:end-1);

%----------------Diffusion------------------%

Rou_dif = Rou(:,:,1:n_dif+1);

x0  = reshape(Rou_dif(1,:),[],n_dif+1); % +1, because of initial condition
xl = reshape(Rou_dif(2,:),[],n_dif+1);
y0  = reshape(Rou_dif(3,:),[],n_dif+1);
yl = reshape(Rou_dif(4,:),[],n_dif+1);
ind = ~isnan(x0(:,end));

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
[~,indt1] = sort(ampl1,2,'descend');
for j = 1:size(x0,1)
    tune1(j,:) = tune1(j,indt1(j,:));
end

indicator.tunes = [tunex(:,1) tuney(:,1)];

tunex = NaN*ones(size(Rin,2),ntunes);
tuney = NaN*ones(size(Rin,2),ntunes);
amplx = NaN*ones(size(Rin,2),ntunes);
amply = NaN*ones(size(Rin,2),ntunes);
[tunex(ind,:) amplx(ind,:)] = lnls_calcnaff(x0(ind,end/2+1:end),...
    xl(ind,end/2+1:end),ntunes);
[tuney(ind,:) amply(ind,:)] = lnls_calcnaff(y0(ind,end/2+1:end),...
    yl(ind,end/2+1:end),ntunes);

tune2 = [tunex, tuney];
ampl2 = [amplx, amply];
[~,indt2] = sort(ampl2,2,'descend');
for j = 1:size(x0,1)
    tune2(j,:) = tune2(j,indt2(j,:));
end

dif_ind = sqrt(sum( (tune2(:,1:ntunes)-tune1(:,1:ntunes)).^2 ,2));

ind2 = find(dif_ind > lim_dif,1,'first'); if isempty(ind2), ind2 = length(x); end;
indicator.aper_dif  = x(min([ind2,ind0]));

indicator.dif = dif_ind;
indicator.x_dif = x;

%-------------------Window------------------%

tunex = lnls_calcnaff(x0(ind,:), xl(ind,:));
tuney = lnls_calcnaff(y0(ind,:), yl(ind,:));

C = window(:,[1,2]) * [tunex,tuney]';
idx = any(C > repmat(window(:,3),1,size(C,2)),1);
ind3 = find(idx > 0,1,'first'); if isempty(ind3), ind3 = length(x); end;

indicator.aper_win = x(min([ind3,ind0]));

%-------------------------------------------%

if plota
    figure('OuterPosition',[633*1,540*(1-1),633, 540]); plot(x(1:end-1),adr);
    str=sprintf('Plot of ADR (%d turns)', nturns); title(str)
    xlabel(plane)
    ylabel('adr')
    
    figure('OuterPosition',[633*1,540*(1-0),633, 540]);
    plot(x,dif_ind);
    str=sprintf('Plot of Diffusion (%d turns, %d tunes)', nturns, ntunes);
    title(str)
    xlabel(plane)
    ylabel('diffusion')
end
end