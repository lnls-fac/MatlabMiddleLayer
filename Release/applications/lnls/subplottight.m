function h = subplottight(n, m, i, varargin)
    lb = 0.05;
    rb = 0.02;
    ub = 0.02;
    bb = 0.05;
    hs = 0.08;
    vs = 0.08;
    
    if mod(length(varargin), 2)
        error('Varargin wrong size');
    end
    narg = floor(length(varargin)/2);
    for ii=1:narg
        name = varargin{2*ii-1};
        val = varargin{2*ii};
        if ~ischar(name)
            error('Argument must be string');
        end
        if strncmpi('top', name, 3)
            ub = val;
        elseif strncmpi('bottom', name, 3)
            bb = val;
        elseif strncmpi('left', name, 3)
            lb = val;
        elseif strncmpi('right', name, 3)
            rb = val;
        elseif strncmpi('hspace', name, 3)
            hs = val;
        elseif strncmpi('vspace', name, 3)
            vs = val;
        end
    end

    [c,r] = ind2sub([m n], i);
    xi = (c(1)-1)/m;
    yi = 1 - r(1)/n;
    xf = c(end)/m;
    yf = 1 - (r(end)-1)/n;
    if c(1) == 1
        xi = xi + lb;
    else
        xi = xi + hs/2;
    end
    if r(1) == 1
        yf = yf - ub;
    else
        yf = yf - vs/2;
    end
    if c(end) == m
        xf = xf - rb;
    else
        xf = xf - hs/2;
    end
    if r(end) == n
        yi = yi + bb;
    else
        yi = yi + vs/2;
    end
    ax = subplot('Position', [xi, yi, (xf-xi), (yf-yi)]);
    if(nargout > 0)
      h = ax;
    end
end