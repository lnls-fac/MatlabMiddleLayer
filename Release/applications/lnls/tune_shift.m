function [points tunes] = tune_shift(p1, p2, nr_pts)
%function [points tunes] = tune_shift(p1, p2, nr_pts)

global THERING;

nr_turns  = 512;
small_pos = 0.01 * 1e-8;

ringpassptr = @myringpass;
    
for i=1:nr_pts
    points(i,:) = [small_pos 0 small_pos 0 0 0] + p1 + (i-1) * (p2 - p1) / (nr_pts - 1);
    traj = ringpassptr(THERING, points(i,:)', nr_turns);
    if ~any(isnan(traj))
        tunes(i,:) = get_tunes2(traj);
    else
        tunes(i,:) = [NaN NaN];
    end
end


function nu = get_tunes2(r0)

   %{
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

return;

%}


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



function r = myringpass(RING, p0, nr_turns)

physical_limit = 0.100;

r = [];
p = p0;
for i=1:nr_turns
    p = linepass(RING, p);
    if (any(isnan(p)) || any(abs(p([1 3])) >= physical_limit))
        for j=i:nr_turns
            r = [r NaN*[1 1 1 1 1 1]'];
        end
        break; 
    else
        r = [r p];
    end
    
end
  


