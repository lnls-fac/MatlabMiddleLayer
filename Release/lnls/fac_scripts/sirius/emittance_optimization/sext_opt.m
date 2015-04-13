function sext_opt

%the_ring     = define_5ba_e0p35;
the_ring     = define_max_iv;

twiss = calctwiss(the_ring);
sl = zeros(size(twiss.betax));
chrom0 = [-100;-70];
r1 = get_chroms(chrom0, twiss, sl);
r2 = get_dtunes(twiss, sl);
M = calc_respm(chrom0, twiss, sl);
best.tshift = Inf;
for i=1:size(M,2)
    for j=i:size(M,2)
        sl = zeros(size(twiss.betax));
        sM = M(1:2,[i j]);
        [U,S,V] = svd(sM,'econ');
        iS = pinv(S);
        dsl = - (V*iS*U') * chrom0;
        sl([i j]) = sl([i j]) + dsl;
        r2 = get_residue(chrom0, twiss, sl);
        tshift = calc_tuneshift(twiss, r2);
        if (max(abs(dsl)) < 1e4) && (abs(tshift(1)) < 0.1) && (abs(tshift(2)) < 0.1) && (abs(r2(2)) < 10) &&  (max(abs(tshift)) < max(abs(best.tshift)))
            fprintf('%03i %03i : %f %f %f %f,  %f\n', i, j, tshift, max(abs(dsl)));            
            best.tshift = tshift;
            best.chromx = r2(1);
            best.chromy = r2(2);
            best.axx = r2(3);
            best.ayy = r2(4);
            best.axy = r2(5);
            best.ij = [i j];
            best.sl = dsl;
            
        end
    end
end


clc;

while true
    
    c0 = chrom0;
    
    for j=1:3
        r0 = get_residue(c0, twiss, sl);
        M = calc_respm(c0, twiss, sl);
        [U,S,V] = svd(M,'econ');
        iS = pinv(S);
        for k=3:size(iS,1)
            iS(k,k) = 0;
        end
        dsl = - (V*iS*U') * r0;
        r1 = r0 + M * dsl;
        sl = sl + dsl;
        r2 = get_residue(c0, twiss, sl);
    end
    
    disp(i);
    disp([r0 r2]);
    
    
end

function tshift = calc_tuneshift(twiss, r2)

tshift(1) = abs(r2(1) * 0.03);
tshift(2) = abs(r2(2) * 0.03);
tshift(3) = abs(r2(3) * 0.015^2/twiss.betax(1)/2);
tshift(4) = abs(r2(4) * 0.005^2/twiss.betay(1)/2);

function M = calc_respm(chrom0, twiss, sl)

M = zeros(6,length(sl));

step = 0.01;
sl0 = sl;

for i=1:length(sl)
    sl(i) = sl(i) + (step/2);
    r2    = get_residue(chrom0, twiss, sl);
    sl(i) = sl(i) - 2*(step/2);
    r1    = get_residue(chrom0, twiss, sl);
    sl(i) = sl(i) + (step/2);
    M(:,i) = (r2 - r1) / step;
end


function r = get_residue(chrom0, twiss, sl)

r = zeros(6,1);

r(1:2,1) = 1 * get_chroms(chrom0, twiss, sl);
r(3:5,1) = 1 * get_dtunes(twiss, sl);
r(6,1)   = 1 * norm(sl) / sqrt(length(sl));

function r  = get_chroms(chrom0, twiss, sl)

SL = sl(:);
BX = twiss.betax; BX = BX(:);
BY = twiss.betay; BY = BY(:);
EX = twiss.etax; EX = EX(:);
CX =  (EX .* BX)' / 4 / pi;
CY = -(EX .* BY)' / 4 / pi;
r = chrom0 + [CX * SL; CY * SL];



function r = get_dtunes(twiss, sl)

SL  = sl(:);
BX  = twiss.betax; BX = BX(:);
BY  = twiss.betay; BY = BY(:);
mux = twiss.mux; mux = mux(:);
muy = twiss.muy; muy = muy(:);
tunex = mux(end) / 2 / pi;
tuney = muy(end) / 2 / pi;
n     = length(SL);
psix  = repmat(mux,1,n) - repmat(mux',n,1);
psiy  = repmat(muy,1,n) - repmat(muy',n,1);
BBxx  = repmat(BX.^(3/2),1,n) .* repmat((BX.^(3/2))',n,1);
BByy  = repmat(BX.^(1/2).*BY,1,n) .* repmat((BX.^(1/2).*BY)',n,1);
BB1xy = BByy;
BB2xy = repmat(BX.^(3/2),1,n) .* repmat((BX.^(1/2).*BY)',n,1);

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

axx = SL' * Mxx * SL;
ayy = SL' * Myy * SL;
axy = SL' * Mxy * SL;

r = [axx; ayy; axy];