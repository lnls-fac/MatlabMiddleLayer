function r = calc_tune_spread(p)

global THERING;

r.tune0 = p.tune0;
    
r.tunes = [];
r.unstable_points = [];
r.stable_points = [];
r.rms     = 0;
r.fitness = 0;

ringpassptr = @myringpass;

set_sextupole_values(p);

for i = 1:size(p.points, 1)
    traj = ringpassptr(THERING, p.points(i,:)', p.nr_turns);
    if ~any(isnan(traj))
        r.stable_points = [r.stable_points; p.points(i,:)];
        r.tunes = [r.tunes; get_tunes(traj)];
    else
        r.unstable_points = [r.unstable_points; p.points(i,:)];
    end
end

if size(r.tunes,1) > floor(size(p.points,1)/2)
    r.rms  = sqrt((sum((r.tunes(:,1) - r.tune0(1)).^2) + sum((r.tunes(:,2) - r.tune0(2)).^2))/size(r.tunes, 1));
    if r.rms == 0
        r.fitness = 0;
    else
        r.fitness = size(r.tunes,1) / r.rms;
    end
end


function nu = get_tunes(r0)

ft = abs(fft(r0(1,:)));
tt = linspace(0,1,size(r0,2));
[sv iv] = sort(ft, 'descend');
tt = tt(iv);
idx = find(tt <= 1/size(r0, 2));
tt(idx) = [];
nu(1) = tt(1);

ft = abs(fft(r0(3,:)));
tt = linspace(0,1,size(r0,2));
[sv iv] = sort(ft, 'descend');
tt = tt(iv);
idx = find(tt <= 1/size(r0, 2));
tt(idx) = [];
nu(2) = tt(1);

%return;


r = r0([1 2],:);
r(1,:) = 1e-4 * r(1,:) / max(abs(r(1,:)));
r(2,:) = 1e-4 * r(2,:) / max(abs(r(2,:)));
freqs = abs(calcnaff(r(1,:), r(2,:), 1)/(2*pi));
idx = find(freqs > 0.001);
nu(1, 1) = freqs(idx(1));
    
r = r0([3 4],:);
r(1,:) = 1e-4 * r(1,:) / max(abs(r(1,:)));
r(2,:) = 1e-4 * r(2,:) / max(abs(r(2,:)));
freqs = abs(calcnaff(r(1,:), r(2,:), 1)/(2*pi));
idx = find(freqs > 0.001);
nu(1, 2) = freqs(idx(1));