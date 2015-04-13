function lnls_frequency_mapdp(the_ring,emax,xmax,ne_points,nx_points,scaling)

if ~exist('scaling','var'), scaling = 'linear';end

emax = abs(emax); xmax = abs(xmax);

en = linspace(-emax,emax,ne_points);
x = linspace(-xmax,1e-8,nx_points);
nturns = 500;
nt = nextpow2(nturns);
nturns = 2^nt + 6 - mod(2^nt,6);


switch scaling
    case 'linear'
    case 'sqrt'
        n=2;
        en = sign(en).*emax^((n-1)/n) * abs(en).^(1/n);
        x =  sign(x ).*xmax^((n-1)/n) * abs(x ).^(1/n);
    case 'log'
        n=1.0;
        en = sign(en).*emax*log(1 + (exp(n)-1) * abs(en)/emax)/n;
        x =  sign(x ).*xmax*log(1 + (exp(n)-1) * abs(x )/xmax)/n;
    otherwise
        error('Variable error: scaling must take ''linear'', ''sqrt'' or ''log'' values.');
end

the_ring = setradiation('off',the_ring);
the_ring = setcavity('off',the_ring);

num_part = nx_points*ne_points;

[EN,X] = meshgrid(en,x);

Rin = zeros(6,num_part);
Rin(1,:) = reshape(X,1,[]);
Rin(3,:) = 5e-4*ones(1,numel(EN));
Rin(5,:) = reshape(EN,1,[]);

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

fp = fopen('fmapdp.out','w');
fprintf(fp,'%15.7g    %15.7g    %15.7g    %15.7g    %15.7g    %15.7g\n',...
             [EN(:)';   X(:)';    nux2;     nuy2;     dnux;     dnuy]);
fclose(fp);