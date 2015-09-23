function lnls_plot_horizontal_vchamber(the_ring, smin, smax, y, dy, handle_cf)

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

hmax = [getcellstruct(the_ring, 'VChamber', 1:length(the_ring), 1, 1); the_ring{end}.VChamber(1)]';

spos = [spos; spos]; spos = reshape(spos(2:end), [], 1);
hmax = [hmax; hmax]; hmax = reshape(hmax(1:end-1), [], 1);

if exist('dy','var')
    dfx = max(hmax)-min(hmax);
    fx = y + (dy/dfx) * hmax;
else
    fx = +1000*hmax + y;
end

minf = min(-fx); maxf = max(fx);

sel = (spos >= smin) & (spos <= smax);

if ~exist('handle_cf','var')
    figure;
end



if exist('handle_cf','var')
    figure(handle_cf); 
end
plot(spos(sel), fx(sel), 'color', [0,0,0]);
hold all;
plot(spos(sel), -fx(sel), 'color', [0,0,0]);


