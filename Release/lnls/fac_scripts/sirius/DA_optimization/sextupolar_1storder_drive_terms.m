function sext = sextupolar_1storder_drive_terms(sext,n_per,tunes)

indcs = 1:length(sext);
betax = getcellstruct(sext,'betax',indcs);
betay = getcellstruct(sext,'betay',indcs);
etax  = getcellstruct(sext,'etax',indcs);
mux = getcellstruct(sext,'mux',indcs);
muy = getcellstruct(sext,'muy',indcs);
mu = [mux, muy];

%Harmonic (Geometric) Terms
r.h21000 = -( 1/8)*hijklm([2,1,0,0,0],betax,betay,etax,mu,Jx,Jy,delta) .* ...
                   AijklmN([2-1,0-0],tunes,n_per);
r.h30000 = -(1/24)*hijklm([3,0,0,0,0],betax,betay,etax,mu,Jx,Jy,delta) .* ...
                   AijklmN([3-0,0-0],tunes,n_per);
r.h10110 =  ( 1/4)*hijklm([1,0,1,1,0],betax,betay,etax,mu,Jx,Jy,delta) .* ...
                   AijklmN([1-0,1-1],tunes,n_per); 
r.h10200 =  ( 1/8)*hijklm([1,0,2,0,0],betax,betay,etax,mu,Jx,Jy,delta) .* ...
                   AijklmN([1-0,2-0],tunes,n_per); 
r.h10020 =  ( 1/8)*hijklm([1,0,0,2,0],betax,betay,etax,mu,Jx,Jy,delta) .* ...
                   AijklmN([1-0,0-2],tunes,n_per); 

r.h12000 = conj(r.h21000);
r.h03000 = conj(r.h30000);
r.h01110 = conj(r.h10110);
r.h01020 = conj(r.h10200);
r.h01200 = conj(r.h10020);

%Chromatic Terms
r.h11001 = -(1/2)*hijklm([1,1,0,0,1],betax,betay,etax,mu,Jx,Jy,delta).* ...
                   AijklmN([1-1,0-0],tunes,n_per);
r.h00111 =  (1/2)*hijklm([0,0,1,1,1],betax,betay,etax,mu,Jx,Jy,delta).* ...
                   AijklmN([0-0,1-1],tunes,n_per);
r.h20001 = -(1/4)*hijklm([2,0,0,0,1],betax,betay,etax,mu,Jx,Jy,delta).* ...
                   AijklmN([2-0,0-0],tunes,n_per);
r.h00201 =  (1/4)*hijklm([0,0,2,0,1],betax,betay,etax,mu,Jx,Jy,delta).* ...
                   AijklmN([0-0,2-0],tunes,n_per);
r.h10002 = -(1/2)*hijklm([1,0,0,0,2],betax,betay,etax,mu,Jx,Jy,delta).* ...
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
