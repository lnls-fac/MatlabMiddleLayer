function r = lnls1_vary_skew_corrector
%Varre fonte A2QS05 e registra dimensões do feixe
%
%History: 
%
%2010-09-13: comentários iniciais no código.

lnls1_fast_orbcorr_on;
h = figure; 
values = linspace(-10,10,21);
values = linspace(-1,2,13);
values = linspace(-1,3,17);
nr_meas = 3;

r.current       = getdcct;

for i=1:length(values);
    
    setpv('SKEWCORR', values(i));
    pause(20); % correcao de orbita
    
    for j=1:nr_meas
        not_new_image = true;
        while not_new_image
            vdimh = getpv('ADFTAMH_AM');
            vdimv = getpv('ADFTAMV_AM');
            vangf = getpv('ADFANG_AM');
            if (j == 1) || (~(vdimh==dimh(j-1)) && ~(vdimv==dimv(j-1)) && ~(vangf==angf(j-1)))
                dimh(j) = vdimh;
                dimv(j) = vdimv;
                angf(j) = vangf;
                not_new_image = false;   
            else
                pause(0.5);
                drawnow;
            end
        end
    end
    
    r.a2qs05(i)     = values(i);
    r.dimh_mean(i)  = mean(dimh);
    r.dimh_sigma(i) = std(dimh,1);
    r.dimv_mean(i)  = mean(dimv);
    r.dimv_sigma(i) = std(dimv,1);
    r.angf_mean(i)  = mean(angf);
    r.angf_sigma(i) = std(angf,1);
    
    figure(h);
    errorbar(values(1:i), r.dimv_mean, r.dimv_sigma);
    
end

setpv('SKEWCORR', 0);



