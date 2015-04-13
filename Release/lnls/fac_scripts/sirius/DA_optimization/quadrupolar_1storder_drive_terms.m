function chrom = quadrupolar_1storder_drive_terms(beta,eta,mu,SPos)

betax = beta(:,1);
etax  = eta(:,1);
betay = beta(:,2);

chrom(:,1) = -(1/4)*betax; %h11001
chrom(:,2) =  (1/4)*betay; %h00111
chrom(:,3) = -(1/2)*betax.^(1/2).*etax.*(exp(1i*mu*[2 0]')); %h10002
chrom(:,4) = -(1/8)*betax.*(exp(1i*mu*[4 0]')); %h20001
chrom(:,5) = (1/8)*betay.*(exp(1i*mu*[0 4]')); %h00201

chrom(:,6) = conj(chrom(:,3)); %h01002
chrom(:,7) = conj(chrom(:,4)); %h02001
chrom(:,8) = conj(chrom(:,5)); %h00021

function sext = sextupolar_1storder_drive_terms(sext,n_per,tunes)

indcs = 1:length(sext);
betax = getcellstruct(sext,'betax',indcs);
betay = getcellstruct(sext,'betay',indcs);
etax  = getcellstruct(sext,'etax',indcs);
mux = getcellstruct(sext,'mux',indcs);
muy = getcellstruct(sext,'muy',indcs);
mu = [mux, muy];

%Chromatic Terms
r.h11001 = -(1/2)*delta*hijklm([1,1,0,0,0],betax,betay,etax,mu,Jx,Jy,delta).* ...
                   AijklmN([1-1,0-0],tunes,n_per);
r.h00111 =  (1/2)*delta*hijklm([0,0,1,1,0],betax,betay,etax,mu,Jx,Jy,delta).* ...
                   AijklmN([0-0,1-1],tunes,n_per);
r.h20001 = -(1/4)*delta*hijklm([2,0,0,0,0],betax,betay,etax,mu,Jx,Jy,delta).* ...
                   AijklmN([2-0,0-0],tunes,n_per);
r.h00201 =  (1/4)*delta*hijklm([0,0,2,0,0],betax,betay,etax,mu,Jx,Jy,delta).* ...
                   AijklmN([0-0,2-0],tunes,n_per);
r.h10002 = -(1/2)*delta*hijklm([1,0,0,0,2],betax,betay,etax,mu,Jx,Jy,delta).* ...
                   AijklmN([1-0,0-0],tunes,n_per); 

r.h02001 = conj(r.h20001);
r.h00021 = conj(r.h00201);
r.h01002 = conj(r.h10002);

fields = fieldnames(r);
for i = 1:length(fields)
    sext = setcellstruct(sext,fields{i},indcs,r.(fields{i}));
end



function hijklm = hijklm(vec,betax,betay,etax, mu,Jx,Jy,delta)

i = vec(1);
j = vec(2);
k = vec(3);
l = vec(4);
m = vec(5);
hijklm = (2*Jx*betax).^((i+j)/2).*(2*Jy*betay).^((k+l)/2)*(delta*etax).^m.*exp(1i*mu*[(i-j),(k-l)]');


function AijklmN = AijklmN(n,tunes,n_per)

AijklmN = 1;
if n_per ~= 1
    AijklmN = exp(1i*(n_per-1)*n*tunes/2).*sin(n_per*n*tunes/2)/sin(n*tunes/2);
end