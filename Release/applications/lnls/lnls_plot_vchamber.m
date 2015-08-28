function lnls_plot_vchamber(the_ring, smin, smax, y, dy, handle_cf)

global THERING;

% -- process arguments --
if ~exist('the_ring','var')
    the_ring = THERING;
end
spos = findspos(the_ring, 1:length(the_ring)+1);
if ~exist('smax','var')
    smax = spos(end);
end
if ~exist('smin','var')
    smin = 0;
end
if ~exist('y','var')
    y = 0;
end
if ~exist('conv','var')
    conv = 1;
end

hmax = [getcellstruct(the_ring, 'VChamber', 1:length(the_ring), 1, 1); the_ring{1}.VChamber(1)]';
vmax = [getcellstruct(the_ring, 'VChamber', 1:length(the_ring), 1, 2); the_ring{1}.VChamber(2)]';

spos = [spos; spos]; spos = reshape(spos(2:end), [], 1);
hmax = [hmax; hmax]; hmax = reshape(hmax(1:end-1), [], 1);
vmax = [vmax; vmax]; vmax = reshape(vmax(1:end-1), [], 1);

if exist('dy','var')
    dfx = max(hmax)-min(hmax);
    fx = y + (dy/dfx) * hmax;
    dfy = max(vmax)-min(vmax);
    fy = y - (dy/dfy) * vmax;
else
    fx = +1000*hmax + y;
    fy = -1000*vmax + y;
end

minf = min([fx;fy]); maxf = max([fx;fy]);

sel = (spos >= smin) & (spos <= smax);

if ~exist('handle_cf','var')
    figure;
end



if ~exist('handle_cf','var')
    plot(spos(sel), fx(sel), 'color', [0,0,0]);
    hold all;
    plot(spos(sel), fy(sel), 'color', [0,0,0]);
    xlabel('pos [m]');
    ylabel('hmax (positive), vmax (negative) [mm]');
    axis([smin,smax,minf,maxf]);
else
    figure(handle_cf);
    plot(spos(sel), fx(sel), 'color', [0,0,0]);
    hold all;
    plot(spos(sel), fy(sel), 'color', [0,0,0]);
end


