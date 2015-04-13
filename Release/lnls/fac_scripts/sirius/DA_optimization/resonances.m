p = 1:300;

ring_size = 10;
periods = [16,8,12,14];
order = 1;

figure;
axes;
hold all;
for nper = periods;
    nu = ring_size/nper/order*p;
    nux = nu(nu >45 & nu < 52 & ~logical(mod(nu,0.5)<0.05) &  logical(mod(nu,1)<0.5) );
    nuy = nu(nu >10 & nu < 20 & ~logical(mod(nu,0.5)<0.05) &  logical(mod(nu,1)<0.5));
    [nux,nuy] = meshgrid(nux,nuy);
    plot(nux(:),nuy(:),'.');
    fprintf('%d :\n',nper);
    fprintf('\t%7.4f, %7.4f\n',[nux(:),nuy(:)]');
end
