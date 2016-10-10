function [par, fit] = lnls_calc_energy_dependent_optics(ring,energy,n, print, sdepend)

if ~exist('energy','var') || isempty(energy), energy = (-5:0.2:5)*1e-2; end;
if ~exist('n','var') || isempty(n), n = 6; end;
if ~exist('print','var'), print  = false; end;
if ~exist('sdepend','var'), sdepend = false; end

par.energy = energy;

if ~sdepend
    lene = length(energy);
    par.betax = zeros(1,lene);
    par.betay = zeros(1,lene);
    par.cox   = zeros(1,lene);
    par.coy   = zeros(1,lene);
    par.tunex = zeros(1,lene);
    par.tuney = zeros(1,lene);
    for i=1:lene,
        TD           = twissring(ring,energy(i));
        par.betax(i) = TD(1).beta(1);
        par.betay(i) = TD(1).beta(2);
        par.cox(i)   = TD(1).ClosedOrbit(1);
        par.coy(i)   = TD(1).ClosedOrbit(3);
        par.tunex(i) = acos((TD.M44(1,1)+TD.M44(2,2))/2)/2/pi;
        par.tuney(i) = acos((TD.M44(3,3)+TD.M44(4,4))/2)/2/pi;
    end
    
    fit = par;
    fields = fieldnames(fit);
    for i=1:length(fields)
        fld = fields{i};
        fit.(fld) = fit_pol(energy,par.(fld),n);
    end
    fit.en = energy;
    
    if print
        en = 100*energy;
        
        scsz = get(0,'ScreenSize'); szy = scsz(4);
        x=1920/3; y = scsz(4)/2;
        fntsz = 14;
        
        figure('OuterPosition',[1+0*x,szy-1*y,x,y]);
        axes('FontSize',fntsz); hold all; box on; grid on;
        ylabel('\beta_x, \beta_y [m]','FontSize',fntsz); xlabel('\delta [%]','FontSize',fntsz);
        plot(en,par.betax,'ob',en,par.betay,'or');
        plot(en,polyval(fit.betax,energy),'b',en,polyval(fit.betay,energy),'r');
        
        figure('OuterPosition',[1+1*x,szy-1*y,x,y]);
        axes('FontSize',fntsz); hold all; box on; grid on;
        ylabel('cod_x, cod_y [mm]','FontSize',fntsz); xlabel('\delta [%]','FontSize',fntsz);
        plot(en,1000*par.cox,'ob',en,1000*par.coy,'or');
        plot(en,1000*polyval(fit.cox,energy),'b',en,1000*polyval(fit.coy,energy),'r');
        
        figure('OuterPosition',[1+2*x,szy-1*y,x,y]);
        axes('FontSize',fntsz); hold all; box on; grid on;
        ylabel('\nu_x, \nu_y','FontSize',fntsz); xlabel('\delta [%]','FontSize',fntsz);
        plot(en,par.tunex,'ob',en,par.tuney,'or');
        plot(en,polyval(fit.tunex,energy),'b',en,polyval(fit.tuney,energy),'r');
    end
else
    lene = length(energy);
    lenr = length(ring);
    par.betax = zeros(lenr,lene);
    par.betay = zeros(lenr,lene);
    par.cox   = zeros(lenr,lene);
    par.coy   = zeros(lenr,lene);
    par.tunex = zeros(lenr,lene);
    par.tuney = zeros(lenr,lene);
    for i=1:lene,
        twi            = calctwiss(ring,energy(i));
        par.betax(:,i) = twi.betax;
        par.betay(:,i) = twi.betay;
        par.cox(:,i)   = twi.cox;
        par.mux(:,i)   = twi.mux;
        par.muy(:,i)   = twi.muy;
    end
    fit = 0;
    
    if print
        pos = twi.pos;
            
        scsz = get(0,'ScreenSize'); szy = scsz(4);
        x=1920/2; y = scsz(4)/2;
        fntsz = 14;
        
        figure('OuterPosition',[1+0*x,szy-1*y,x,y]);
        abetx = axes('FontSize',fntsz); hold all; box on; grid on;
        ylabel('\beta_x [m]','FontSize',fntsz); xlabel('pos [m]','FontSize',fntsz);
        
        figure('OuterPosition',[1+1*x,szy-1*y,x,y]);
        abety = axes('FontSize',fntsz); hold all; box on; grid on;
        ylabel('\beta_y [m]','FontSize',fntsz); xlabel('pos [m]','FontSize',fntsz);

        figure('OuterPosition',[1+0*x,szy-2*y,x,y]);
        amux = axes('FontSize',fntsz); hold all; box on; grid on;
        ylabel('\mu_x [m]','FontSize',fntsz); xlabel('pos [m]','FontSize',fntsz);
        
        figure('OuterPosition',[1+1*x,szy-2*y,x,y]);
        amuy = axes('FontSize',fntsz); hold all; box on; grid on;
        ylabel('\mu_y [m]','FontSize',fntsz); xlabel('pos [m]','FontSize',fntsz);

        figure('OuterPosition',[1+1/2*x,szy-3/2*y,x,y]);
        acox = axes('FontSize',fntsz); hold all; box on; grid on;
        ylabel('CO_x [mm]','FontSize',fntsz); xlabel('pos [m]','FontSize',fntsz);
        
        for i=1:lene
            plot(abetx,pos,par.betax(:,i),'Color',[(lene-i)/lene,0,i/lene]);
            plot(abety,pos,par.betay(:,i),'Color',[(lene-i)/lene,0,i/lene]);
            plot(amux,pos,par.mux(:,i),'Color',[(lene-i)/lene,0,i/lene]);
            plot(amuy,pos,par.muy(:,i),'Color',[(lene-i)/lene,0,i/lene]);
            plot(acox,pos,1000*par.cox(:,i),'Color',[(lene-i)/lene,0,i/lene]);
        end
    end
end

function py = fit_pol(x,y,n)

% Exclude unstable points:
ind = ~isnan(y(:));

% Use only the first contiguous points for fitting:
idx = find(diff(ind)==-1);
if numel(idx), ii = idx(1); else ii = length(ind); end
ind = ind(1:ii);

x  = x(ind); y = y(ind);
x  = x(:); y = y(:);

if n <=9,ord = sprintf('poly%1d',n); else ord = 'poly9'; end

try
    py = coeffvalues(fit(x,y,ord,'Robust','on'));
catch
    py = 1e15*ones(1,n+1);
end