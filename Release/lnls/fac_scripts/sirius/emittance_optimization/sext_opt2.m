function sext_opt2

global THERING;
%the_ring     = define_max_iv;
the_ring     = define_mba5;

THERING = the_ring;

the_ring = improve_sextupoles(the_ring);

%sxt_idx = 1:length(the_ring);
sxt_idx = findcells(the_ring, 'PolynomB');
% sxt =getcellstruct(the_ring, 'PolynomB', sxt_idx, 1, 3);
% sxt_idx = sxt_idx(sxt ~= 0);
S0 = getcellstruct(the_ring, 'PolynomB', sxt_idx, 1, 3);
the_ring = setcellstruct(the_ring, 'PolynomB', sxt_idx, 0, 1, 3);

twiss = calctwiss(the_ring);

sl = zeros(size(twiss.betax));
chrom0 = [twiss.chromx; twiss.chromy];


bx  = twiss.betax(sxt_idx); bx = bx(:);
by  = twiss.betay(sxt_idx); by = by(:);
ex  = twiss.etax(sxt_idx); ex = ex(:);
mux = twiss.mux(sxt_idx); mux = mux(:);
muy = twiss.muy(sxt_idx); muy = muy(:);
tunex = twiss.mux(end) / 2 / pi;
tuney = twiss.muy(end) / 2 / pi;
n     = length(sxt_idx);

cx =   (bx .* ex)' / 4 / pi;
cy = - (by .* ex)' / 4 / pi;
C = [cx; cy];


psix  = repmat(mux,1,n) - repmat(mux',n,1);
psiy  = repmat(muy,1,n) - repmat(muy',n,1);
BBxx  = repmat(bx.^(3/2),1,n) .* repmat((bx.^(3/2))',n,1);
BByy  = repmat(bx.^(1/2).*by,1,n) .* repmat((bx.^(1/2).*by)',n,1);
BB1xy = BByy;
BB2xy = repmat(bx.^(3/2),1,n) .* repmat((bx.^(1/2).*by)',n,1);

%%% S.Y.Lee
c1 = 3*(pi*tunex - abs(psix));
c2 = pi*tunex - abs(psix);
Mxx    = BBxx .* (cos(c1)/sin(3*pi*tunex) + 3 * cos(c2)/sin(pi*tunex)) / 64 / pi;
c1 = 2*(pi*tuney - abs(psiy)) + (pi*tunex - abs(psix));
c2 = 2*(pi*tuney - abs(psiy)) - (pi*tunex - abs(psix));
c3 = pi*tunex - abs(psix);
Myy    = BByy .* (cos(c1)/sin(pi*(2*tuney+tunex)) + cos(c2)/sin(pi*(2*tuney-tunex)) + 3 * cos(c3) / sin(pi*tunex)) / 64 / pi;
c1 = 2*(pi*tuney - abs(psiy)) + (pi*tunex - abs(psix));
c2 = 2*(pi*tuney - abs(psiy)) - (pi*tunex - abs(psix));
c3 = pi*tunex - abs(psix);
Mxy = (BB1xy .* (cos(c1)/sin(pi*(2*tuney+tunex)) + cos(c2)/sin(pi*(2*tuney-tunex))) - 2 * BB2xy .* cos(c3) / sin(pi*tunex)) / 32 / pi;

[V,D] = eig(Mxx);
[Q,R] = qr(V); 
DD = Q'*Mxx*Q;
[d idx] = sort(abs(diag(DD)));
d = diag(DD);
D = diag(d(idx));
Q = Q(:,idx);

df = Mxx * Q(:,1) - D(1,1) * Q(:,1);

M = C*Q;
clc;


M0 = M; 


%M0(:,11:end) = 0;

iter = 0;
while true
[U,S,V] = svd(M0,'econ');
iS = pinv(S);
dX = -(V*iS*U')*chrom0;

chrom = chrom0 + M*dX;

dS = Q*dX;
axy = (dS' * Mxy * dS);
ayy = (dS' * Myy * dS);
axx1 = dX' * D * dX;
axx2 = (dS' * Mxx * dS);
fprintf('%03i: %+E %+E,  %+E %+E %+E\n' , iter, chrom, axx1, ayy, axy);
plot(twiss.pos(sxt_idx), dS);

v = (D * dX) .* dX;
[m idx] = max(abs(v));
M0(:,idx) = 0;
iter = iter + 1;
end



    


for i=2:size(M,2)
    M0 = M;
    M0(:,i:end) = 0;
    [U,S,V] = svd(M0,'econ');
    iS = pinv(S);
    dX = -(V*iS*U')*chrom0;
    
    %chrom = chrom0 + M*dX;
    
    dS = Q*dX;
   
    axx1 = dX' * D * dX;
    axx2 = (dS' * Mxx * dS);
    
    fprintf('%i %+E %+E\n', i, axx1, axx2);
    
    plot(twiss.pos, dS);
    
end





function the_ring = improve_sextupoles(the_ring0)


r.the_ring = the_ring0;




% sextupole indices
r.idx = findcells(r.the_ring, 'PolynomB');
sst = getcellstruct(r.the_ring, 'PolynomB', r.idx, 1, 3);
r.idx = r.idx(sst ~= 0);
%r.idx = 1:length(r.the_ring);

S = getcellstruct(r.the_ring, 'PolynomB', r.idx, 1, 3);
uS = unique(S);
for i=1:length(uS)
    sel = (S == uS(i));
    r.knobs{i} = r.idx(find(sel));
end

twiss = calctwiss(r.the_ring);

bx  = twiss.betax(r.idx); bx = bx(:);
by  = twiss.betay(r.idx); by = by(:);
ex  = twiss.etax(r.idx); ex = ex(:);
mux = twiss.mux(r.idx); mux = mux(:);
muy = twiss.muy(r.idx); muy = muy(:);
tunex = twiss.mux(end) / 2 / pi;
tuney = twiss.muy(end) / 2 / pi;
n     = length(r.idx);

cx =   (bx .* ex)' / 4 / pi;
cy = - (by .* ex)' / 4 / pi;
r.C = [cx; cy];



r.h11001   =  (-2 * ex .* bx)' / 4;
r.h00111   = -(-2 * ex .* by)' / 4;
r.h21000_r = -(bx.^(3/2) .* cos(2*mux))' / 8 / sin(pi*tunex);
r.h21000_i = -(bx.^(3/2) .* sin(2*muy))' / 8 / sin(pi*tunex);
r.h30000_r = -(bx.^(3/2) .* cos(3*mux))' / 24 / sin(3*pi*tunex);
r.h30000_i = -(bx.^(3/2) .* sin(3*muy))' / 24 / sin(3*pi*tunex);
r.h10110_r = +(bx.^(1/2) .* by .* cos(mux))' / 4 / sin(pi*tunex);
r.h10110_i = +(bx.^(1/2) .* by .* sin(muy))' / 4 / sin(pi*tunex);
r.h10020_r = +(bx.^(1/2) .* by .* cos(mux-2*muy))' / 8 / sin(pi*(tunex-2*tuney));
r.h10020_i = +(bx.^(1/2) .* by .* sin(mux-2*muy))' / 8 / sin(pi*(tunex-2*tuney));
r.h10200_r = +(bx.^(1/2) .* by .* cos(mux+2*muy))' / 8 / sin(pi*(tunex+2*tuney));
r.h10200_i = +(bx.^(1/2) .* by .* sin(mux+2*muy))' / 8 / sin(pi*(tunex+2*tuney));
r.chrom0_x = twiss.chromx;
r.chrom0_y = twiss.chromy;


psix  = repmat(mux,1,n) - repmat(mux',n,1);
psiy  = repmat(muy,1,n) - repmat(muy',n,1);
BBxx  = repmat(bx.^(3/2),1,n) .* repmat((bx.^(3/2))',n,1);
BByy  = repmat(bx.^(1/2).*by,1,n) .* repmat((bx.^(1/2).*by)',n,1);
BB1xy = BByy;
BB2xy = repmat(bx.^(3/2),1,n) .* repmat((bx.^(1/2).*by)',n,1);

%%% S.Y.Lee
c1 = 3*(pi*tunex - abs(psix));
c2 = pi*tunex - abs(psix);
r.Mxx    = BBxx .* (cos(c1)/sin(3*pi*tunex) + 3 * cos(c2)/sin(pi*tunex)) / 64 / pi;
c1 = 2*(pi*tuney - abs(psiy)) + (pi*tunex - abs(psix));
c2 = 2*(pi*tuney - abs(psiy)) - (pi*tunex - abs(psix));
c3 = pi*tunex - abs(psix);
r.Myy    = BByy .* (cos(c1)/sin(pi*(2*tuney+tunex)) + cos(c2)/sin(pi*(2*tuney-tunex)) + 3 * cos(c3) / sin(pi*tunex)) / 64 / pi;
c1 = 2*(pi*tuney - abs(psiy)) + (pi*tunex - abs(psix));
c2 = 2*(pi*tuney - abs(psiy)) - (pi*tunex - abs(psix));
c3 = pi*tunex - abs(psix);
r.Mxy = (BB1xy .* (cos(c1)/sin(pi*(2*tuney+tunex)) + cos(c2)/sin(pi*(2*tuney-tunex))) - 2 * BB2xy .* cos(c3) / sin(pi*tunex)) / 32 / pi;






r.max_x = 0.001;
r = calc_chi2(r);

brpt = 20000;
iter = 0;
while true
    r0 = r;
    r  = new_sextupole_set(r);
    iter = iter + 1;
    r  = calc_chi2(r);
    if (r.chi2 > r0.chi2)
        r = r0;
    else
        fprintf('%04i: %f\n', iter, r.chi2);
        setappdata(0, 'r',r); 
    end
    if iter > brpt
        disp('ok');
    end
end

function r = calc_chi2(r0)

r = r0;
% x = r.max_x;
% while true
% t = ringpass(r.the_ring, [x 0 0 0 0 0]', 2000);
% if any(isnan(t(:))), break; end;
% x = x + 0.0001;
% end

S = getcellstruct(r.the_ring, 'PolynomB', r.idx, 1, 3);
L = getcellstruct(r.the_ring, 'Length', r.idx);

axx = S' * r.Mxx * S;
axy = S' * r.Mxy * S;
ayy = S' * r.Myy * S;
%r.cro = r.C * S;


cx0 = 25.69;
cy0 = 10.7684;
res = [ ...
    1000*(cx0 + r.h11001*(S.*L)); ...
    1000*(cy0 + r.h00111*(S.*L)); ...
    norm([r.h21000_r*(S.*L), r.h21000_i*(S.*L)]); ...
    norm([r.h30000_r*(S.*L), r.h30000_i*(S.*L)]);...
    norm([r.h10110_r*(S.*L), r.h10110_i*(S.*L)]); ...
    norm([r.h10020_r*(S.*L), r.h10020_i*(S.*L)]); ...
    norm([r.h10200_r*(S.*L), r.h10200_i*(S.*L)]); ...
%     
%     r.h21000_i*(S.*L); ...
%     r.h30000_r*(S.*L); ...
%     r.h30000_i*(S.*L); ...
%     r.h10110_r*(S.*L); ...
%     r.h10110_i*(S.*L); ...
%     r.h10020_r*(S.*L); ...
%     r.h10020_i*(S.*L); ...
%     r.h10200_r*(S.*L); ...
%     r.h10200_i*(S.*L); ...
    0*axx; ...
    0*ayy; ...
    0*axy; ...
    0*sqrt((S.*L)'*(S.*L)/length(S))
    ];

% r.dtune_axx = axx * 0.010^2/ 2 / 12.7;
% r.dtune_ayy = 1*ayy * 0.005^2/ 2 / 1.1;
% r.dtune_cx   = 1*r.cro(1) * 0.03;
% r.dtune_cy   = 1*r.cro(2) * 0.03;
% r.s_rms      = max(abs(r.S));
% r.chi2 = max(abs([r.dtune_axx / 0.1,  r.dtune_ayy / 0.1,  r.dtune_cx / 0.1,  r.dtune_cy / 0.1,  r.s_rms / 100]));

r.res = res;
r.chi2 = norm(res);

%r.chi2 = x;

function r = new_sextupole_set(r0)

r = r0;

S = getcellstruct(r.the_ring, 'PolynomB', r.idx, 1, 3);
p = randi(length(S));
rn = 0.5 * 2 * (rand - 0.5);
nV = S(p) + rn;

% S(p) = r.S(p) + rn;
% r.the_ring = setcellstruct(r.the_ring, 'PolynomB', r.idx, r.S, 1, 3);

for i=1:length(r.knobs)
    if ~isempty(find(r.idx(p) == r.knobs{i}))
        r.the_ring = setcellstruct(r.the_ring, 'PolynomB', r.knobs{i}, nV, 1, 3);
    end
end







