function [tunex,tuney,px,py,amps] = lnls_calc_tune_shifts(ring,print,amps, npols, de)
% [tunex,tuney,px,py,amps] = lnls_calc_tune_shifts(ring,amps)
%
% Plota os espacos de fase horizontal e vertical e monta o diagrama de
% tuneshifts com as amplitudes horizontal e vertical:
% 
% ring = modelo do anel para o qual os calculos serao feitos;
% amps = struct with horizontal amplitudes
%   x = vetor com as amplitudes horizontais para as quais o calculo sera
%       realizado [m];
%   y = vetor com as amplitudes verticais para as quais o calculo sera
%       realizado [m];
%
% Como padrao, a funcao usa o algoritmo NAFF para os calculos de sintonia.
% Por isso, o numero real de voltas usado sera tal que satisfaca a seguinte
% formula nt = mod(2^nextpow2(nturns),6)==0

if ~exist('print','var'), print = false; end
if ~exist('amps','var'), amps = struct(); end
if ~isfield(amps,'x'), amps.x = -(1:2:80)*1e-4; end
if ~isfield(amps,'y'), amps.y = (1:25)*1e-4; end
if ~exist('npols','var'), npols = struct(); end
if ~isfield(npols,'x'), npols.x = 3; end
if ~isfield(npols,'y'), npols.y = 3; end
if ~exist('de','var'), de = 0; end

if strcmpi('on',getcavity(ring))
    orb = findorbit6(ring);
else
    orb = [findorbit4(ring,de);de;0];
end

%%
% faz o tracking nas amplitudes horizontais especificadas no input, setando
% a posicao vertical inicial para 1e-5 para evitar singularidades do mapa
% de transferencia e tornar possivel a obtencao da sintonia vertical
amps.x = amps.x(:);
len = length(amps.x);
Rin  = [amps.x'+orb(1);          zeros(1,len)+orb(2);...
        1e-5*ones(1,len)+orb(3); repmat(orb(4:6),1,len)];

[tunex.x,tuney.x,amps.Jx,~] = get_frac_tunes(ring,Rin);
[px.x,py.x] = fit_pol(amps.Jx,tunex.x,tuney.x,npols.x,tunex.x(1),tuney.x(1));

%%
% a mesma coisa que foi feita para a horizontal eh repetida para vertical
amps.y = amps.y(:);
len  = length(amps.y);
Rin  = [1e-5*ones(1,len)+orb(1); zeros(1,len)+orb(2);
        amps.y'+orb(3);          repmat(orb(4:6),1,len)];

[tunex.y,tuney.y,~,amps.Jy] = get_frac_tunes(ring,Rin);
[px.y,py.y] = fit_pol(amps.Jy,tunex.y,tuney.y,npols.y,tunex.x(1),tuney.y(1));

%% Agora, temos que determinar a parte inteira da sintonia

% [~, tunes] = twissring(ring, 0, 1:length(ring)+1);
% if mod(tunes(1),1)>0.5
%     tunex.y = ceil(tunes(1)) - tunex.y;
%     tunex.x = ceil(tunes(1)) - tunex.x;
% else
%     tunex.y = floor(tunes(1)) + tunex.y;
%     tunex.x = floor(tunes(1)) + tunex.x;
% end
% if mod(tunes(2),1)>0.5
%     tuney.y = ceil(tunes(2)) - tuney.y;
%     tuney.x = ceil(tunes(2)) - tuney.x;
% else
%     tuney.y = floor(tunes(2)) + tuney.y;
%     tuney.x = floor(tunes(2)) + tuney.x;
% end

%% Alguns gráficos (apenas para debug e ajuste dos parâmetros)

if print
    scsz = get(0,'ScreenSize'); szy = scsz(4);
    x=1920/3; y = scsz(4)/2;
    fntsz = 14;
    
    figure('OuterPosition',[1+0*x,szy-1*y,x,y]);
    axes('FontSize',fntsz); hold all; box on; grid on;
    ylabel('\nu_x, \nu_y','FontSize',fntsz); xlabel('J_x [mm.mrad]','FontSize',fntsz);
    plot(1e6*amps.Jx,tunex.x,'ob',1e6*amps.Jx,tuney.x,'or');
    plot(1e6*amps.Jx,polyval(px.x,amps.Jx),'b',1e6*amps.Jx,polyval(py.x,amps.Jx),'r');
    
    figure('OuterPosition',[1+1*x,szy-1*y,x,y]);
    axes('FontSize',fntsz); hold all; box on; grid on;
    ylabel('\nu_x, \nu_y','FontSize',fntsz); xlabel('J_y [mm.mrad]','FontSize',fntsz);
    plot(1e6*amps.Jy,tunex.y,'ob',1e6*amps.Jy,tuney.y,'or');
    plot(1e6*amps.Jy,polyval(px.y,amps.Jy),'b',1e6*amps.Jy,polyval(py.y,amps.Jy),'r');
end

function [tunex,tuney,Jx,Jy] = get_frac_tunes(ring,Rin,nturns)

% escolha do metodo para calculo das sintonias:
meth = 'naff';

% ajuste do numero de voltas para que seja compativel com o naff
if ~exist('nturns','var'), nturns = 100; end

nt = nextpow2(nturns);
nturns = 2^nt + 6 - mod(2^nt,6);

Rout = [Rin,ringpass(ring,Rin,nturns)];
x  = reshape(Rout(1,:),[],nturns+1);
xl = reshape(Rout(2,:),[],nturns+1);
y  = reshape(Rout(3,:),[],nturns+1);
yl = reshape(Rout(4,:),[],nturns+1);

ind = ~isnan(x(:,end));
tunex = NaN*ind;
tuney = NaN*ind;
Jx    = NaN*ind;
Jy    = NaN*ind;
if strcmp(meth,'fft')
    tunex(ind) = intfft(x(ind,:)')';
    tuney(ind) = intfft(y(ind,:)')';
else
    tunex(ind) = lnls_calcnaff(x(ind,:), xl(ind,:));
    tuney(ind) = lnls_calcnaff(y(ind,:), yl(ind,:));
end

Jx(ind) = lnls_fit_ellipse_area(x(ind,:),xl(ind,:))/pi;
Jy(ind) = lnls_fit_ellipse_area(y(ind,:),yl(ind,:))/pi;


function [py1,py2] = fit_pol(x,y1,y2,n, y1_0,y2_0)

% Exclude unstable points:
ind = ~isnan(y1(:,end));

% Use only the first contiguous points for fitting:
idx = find(diff(ind)==-1);
if numel(idx), ii = idx(1); else ii = length(ind); end
ind = ind(1:ii);

x  = x(ind); y1 = y1(ind); y2 = y2(ind);

if n <=9,ord = sprintf('poly%1d',n); else ord = 'poly9'; end

try
    py1 = coeffvalues(fit(x,y1,ord,'Robust','on','Exclude',excludedata(x,y1,'range',y1_0 + [-0.1 0.1])));
catch
    py1 = 1e15*ones(1,n+1);
end
try
    py2 = coeffvalues(fit(x,y2,ord,'Robust','on','Exclude',excludedata(x,y2,'range',y2_0 + [-0.1 0.1])));
catch
    py2 = 1e15*ones(1,n+1);
end
