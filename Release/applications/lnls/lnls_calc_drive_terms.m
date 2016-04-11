function [DT, S, Q] = lnls_calc_drive_terms(ring,twiss,n_per,Jx,Jy,delta)
% [DT, S, Q] = lnls_calc_drive_terms(ring,twiss,n_per,Jx,Jy,delta)

if ~exist('twiss','var'), twiss = calctwiss(ring,1:length(ring)); end
if ~exist('n_per','var'), n_per = 1; end
if ~exist('Jx','var'), Jx = 1; end
if ~exist('Jy','var'), Jy = 1; end
if ~exist('delta','var'), delta = 1; end

tunes = [twiss.mux(end), twiss.muy(end)];

%% sextupole contributions
sexts = findcells(ring,'PolynomB');
stren = getcellstruct(ring,'PolynomB',sexts,1,3);
sexts = sexts(stren ~= 0);
stren = stren(stren ~= 0) .* getcellstruct(ring,'Length',sexts);
S.indcs = sexts;
S.stren = stren;

betax = get_twiss_at_center(twiss.betax,sexts);
betay = get_twiss_at_center(twiss.betay,sexts);
etax  = get_twiss_at_center(twiss.etax,sexts);
mux   = get_twiss_at_center(twiss.mux,sexts);
muy   = get_twiss_at_center(twiss.muy,sexts);
mu    = [mux, muy];

%Harmonic (Geometric) Terms
S.h21000 = -( 1/8)*hijklm([2,1,0,0,0],betax,betay,etax,mu,Jx,Jy,delta).* AijklmN([2-1,0-0],tunes,n_per);
S.h30000 = -(1/24)*hijklm([3,0,0,0,0],betax,betay,etax,mu,Jx,Jy,delta).* AijklmN([3-0,0-0],tunes,n_per);
S.h10110 =  ( 1/4)*hijklm([1,0,1,1,0],betax,betay,etax,mu,Jx,Jy,delta).* AijklmN([1-0,1-1],tunes,n_per); 
S.h10200 =  ( 1/8)*hijklm([1,0,2,0,0],betax,betay,etax,mu,Jx,Jy,delta).* AijklmN([1-0,2-0],tunes,n_per); 
S.h10020 =  ( 1/8)*hijklm([1,0,0,2,0],betax,betay,etax,mu,Jx,Jy,delta).* AijklmN([1-0,0-2],tunes,n_per); 
S.h12000 = conj(S.h21000);
S.h03000 = conj(S.h30000);
S.h01110 = conj(S.h10110);
S.h01020 = conj(S.h10200);
S.h01200 = conj(S.h10020);
%Chromatic Terms
S.h11001 = -(1/2)*hijklm([1,1,0,0,1],betax,betay,etax,mu,Jx,Jy,delta).* AijklmN([1-1,0-0],tunes,n_per);
S.h00111 =  (1/2)*hijklm([0,0,1,1,1],betax,betay,etax,mu,Jx,Jy,delta).* AijklmN([0-0,1-1],tunes,n_per);
S.h20001 = -(1/4)*hijklm([2,0,0,0,1],betax,betay,etax,mu,Jx,Jy,delta).* AijklmN([2-0,0-0],tunes,n_per);
S.h00201 =  (1/4)*hijklm([0,0,2,0,1],betax,betay,etax,mu,Jx,Jy,delta).* AijklmN([0-0,2-0],tunes,n_per);
S.h10002 = -(1/2)*hijklm([1,0,0,0,2],betax,betay,etax,mu,Jx,Jy,delta).* AijklmN([1-0,0-0],tunes,n_per); 
S.h02001 = conj(S.h20001);
S.h00021 = conj(S.h00201);
S.h01002 = conj(S.h10002);

%driving terms:
DT.h21000 = S.h21000.' * stren;
DT.h30000 = S.h30000.' * stren;
DT.h10110 = S.h10110.' * stren;
DT.h10200 = S.h10200.' * stren; 
DT.h10020 = S.h10020.' * stren; 
DT.h12000 = S.h12000.' * stren;
DT.h03000 = S.h03000.' * stren;
DT.h01110 = S.h01110.' * stren;
DT.h01020 = S.h01020.' * stren;
DT.h01200 = S.h01200.' * stren;
DT.h11001 = S.h11001.' * stren;
DT.h00111 = S.h00111.' * stren;
DT.h20001 = S.h20001.' * stren;
DT.h00201 = S.h00201.' * stren;
DT.h10002 = S.h10002.' * stren;
DT.h02001 = S.h02001.' * stren;
DT.h00021 = S.h00021.' * stren;
DT.h01002 = S.h01002.' * stren;


%% quadrupole contributions
quads = findcells(ring,'PolynomB');
stren = getcellstruct(ring,'PolynomB',quads,1,2);
quads = quads(stren ~= 0);
stren = stren(stren ~= 0) .* getcellstruct(ring,'Length',quads);
Q.indcs = quads;
Q.stren = stren;

betax = get_twiss_at_center(twiss.betax,quads);
betay = get_twiss_at_center(twiss.betay,quads);
etax  = get_twiss_at_center(twiss.etax,quads);
mux   = get_twiss_at_center(twiss.mux,quads);
muy   = get_twiss_at_center(twiss.muy,quads);
mu    = [mux, muy];

%Chromatic Terms
Q.h11001 =  (1/4)*hijklm([1,1,0,0,0],betax,betay,etax,mu,Jx,Jy,delta)*delta .* AijklmN([1-1,0-0],tunes,n_per);
Q.h00111 = -(1/4)*hijklm([0,0,1,1,0],betax,betay,etax,mu,Jx,Jy,delta)*delta .* AijklmN([0-0,1-1],tunes,n_per);
Q.h20001 =  (1/8)*hijklm([2,0,0,0,0],betax,betay,etax,mu,Jx,Jy,delta)*delta .* AijklmN([2-0,0-0],tunes,n_per);
Q.h00201 = -(1/8)*hijklm([0,0,2,0,0],betax,betay,etax,mu,Jx,Jy,delta)*delta .* AijklmN([0-0,2-0],tunes,n_per);
Q.h10002 =  (1/2)*hijklm([1,0,0,0,1],betax,betay,etax,mu,Jx,Jy,delta)*delta .* AijklmN([1-0,0-0],tunes,n_per); 
Q.h02001 = conj(Q.h20001);
Q.h00021 = conj(Q.h00201);
Q.h01002 = conj(Q.h10002);


%driving terms:
DT.h11001 = DT.h11001 + Q.h11001.' * stren;
DT.h00111 = DT.h00111 + Q.h00111.' * stren;
DT.h20001 = DT.h20001 + Q.h20001.' * stren;
DT.h00201 = DT.h00201 + Q.h00201.' * stren;
DT.h10002 = DT.h10002 + Q.h10002.' * stren;
DT.h02001 = DT.h02001 + Q.h02001.' * stren;
DT.h00021 = DT.h00021 + Q.h00021.' * stren;
DT.h01002 = DT.h01002 + Q.h01002.' * stren;

function twis = get_twiss_at_center(twi,indcs)

twis = (twi(indcs) + twi(indcs+1)) / 2;


function hijklm = hijklm(vec,betax,betay,etax, mu,Jx,Jy,delta)

i = vec(1);
j = vec(2);
k = vec(3);
l = vec(4);
m = vec(5);
hijklm = (2*Jx*betax).^((i+j)/2).*(2*Jy*betay).^((k+l)/2).*(delta*etax).^m.*exp(1i*mu*[(i-j),(k-l)]');


function AijklmN = AijklmN(n,tunes,n_per)

AijklmN = 1;
if n_per ~= 1
    AijklmN = exp(1i*(n_per-1)*n*tunes/2).*sin(n_per*n*tunes/2)/sin(n*tunes/2);
end