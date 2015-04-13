function lnls_frequency_map(the_ring,xmax,ymax,nx_points,ny_points,scaling)

if ~exist('scaling','var'), scaling = 'linear';end

xmax = abs(xmax); ymax = abs(ymax);

x = linspace(-xmax,1e-8,nx_points);
y = linspace(1e-8,ymax,ny_points);
nturns = 500;
nt = nextpow2(nturns);
nturns = 2^nt + 6 - mod(2^nt,6);


switch scaling
    case 'linear'
    case 'sqrt'
        n=2;
        x = sign(x).*xmax^((n-1)/n) * abs(x).^(1/n);
        y = sign(y).*ymax^((n-1)/n) * abs(y).^(1/n);
    case 'log'
        n=1.0;
        x = sign(x).*xmax*log(1 + (exp(n)-1) * abs(x)/xmax)/n;
        y = sign(y).*ymax*log(1 + (exp(n)-1) * abs(y)/ymax)/n;
    otherwise
        error('Variable error: scaling must take ''linear'', ''sqrt'' or ''log'' values.');
end

the_ring = setradiation('off',the_ring);
the_ring = setcavity('off',the_ring);

num_part = ny_points*nx_points;

[X,Y] = meshgrid(x,y);

Rin = zeros(6,num_part);
Rin(1,:) = reshape(X,1,[]);
Rin(3,:) = reshape(Y,1,[]);

Rout = ringpass(the_ring,Rin,nturns);

x_out  = reshape(Rout(1,:),num_part,[]);
xl_out = reshape(Rout(2,:),num_part,[]);
y_out  = reshape(Rout(3,:),num_part,[]);
yl_out = reshape(Rout(4,:),num_part,[]);
not_lost = ~any(isnan(x_out'));

%calc naff
nux1 = zeros(1,num_part);
nuy1 = zeros(1,num_part);

nux1(not_lost) = lnls_calcnaff(x_out(not_lost,:),xl_out(not_lost,:));
nuy1(not_lost) = lnls_calcnaff(y_out(not_lost,:),yl_out(not_lost,:));


Rin = Rout(:,(end-num_part+1):end);

Rout = ringpass(the_ring,Rin,nturns,'reuse');

x_out  = reshape(Rout(1,:),num_part,[]);
xl_out = reshape(Rout(2,:),num_part,[]);
y_out  = reshape(Rout(3,:),num_part,[]);
yl_out = reshape(Rout(4,:),num_part,[]);
not_lost = ~any(isnan(x_out'));

%calc naff
nux2 = zeros(1,num_part);
nuy2 = zeros(1,num_part);

nux2(not_lost) = lnls_calcnaff(x_out(not_lost,:),xl_out(not_lost,:));
nuy2(not_lost) = lnls_calcnaff(y_out(not_lost,:),yl_out(not_lost,:));

dnux = nux2-nux1;
dnuy = nuy2-nuy1;

fp = fopen('fmap.out','w');
fprintf(fp,'%15.7g    %15.7g    %15.7g    %15.7g    %15.7g    %15.7g\n',...
             [X(:)';   Y(:)';    nux2;     nuy2;     dnux;     dnuy]);
fclose(fp);