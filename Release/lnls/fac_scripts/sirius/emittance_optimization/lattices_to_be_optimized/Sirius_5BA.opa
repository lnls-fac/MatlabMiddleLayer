{ d:\arq\lnls\sirius\otica\sirius_5ba\opa\e_660pm\sirius_5ba.opa }
 
{----- global parameters (units: gev, m, rad) -------------------------------}
 
 
energy = 3.000000;
 
    betax   = 12.5039567; alphax  = 0.0000000;
    etax    = 0.0000015; etaxp   = 0.0000000;
    betay   = 0.9368601; alphay  = 0.0000000;
    etay    = 0.0000000; etayp   = 0.0000000;
    orbitx  = 0.0000000000; orbitxp = 0.0000000000;
    orbity  = 0.0000000000; orbityp = 0.0000000000;
    orbitdpp= 0.0000000000;
 
{----- table of elements (units: m, m^-2, deg, t; mm, mrad) ---------------- }
{      conventions: quadrupole: k>0 horizontally focusing                    }
{                   sextupole : k=m*l, m:=bpoletip/r^2/(b*rho)               }
 
li       : drift, l = 3.000000, ax = 20.00, ay = 20.00;
l1       : drift, l = 0.074439, ax = 20.00, ay = 20.00;
l2       : drift, l = 0.036053, ax = 20.00, ay = 20.00;
l3       : drift, l = 0.030930, ax = 20.00, ay = 20.00;
lc1      : drift, l = 0.734370, ax = 20.00, ay = 20.00;
lc2      : drift, l = 0.399732, ax = 20.00, ay = 20.00;
lc3      : drift, l = 0.649883, ax = 20.00, ay = 20.00;
lq       : drift, l = 0.075000, ax = 20.00, ay = 20.00;
lb       : drift, l = 0.130000, ax = 20.00, ay = 20.00;
l10      : drift, l = 0.100000, ax = 20.00, ay = 20.00;
mb1      : marker, ax = 20.00, ay = 20.00;
mb2      : marker, ax = 20.00, ay = 20.00;
mq       : marker, ax = 20.00, ay = 20.00;
mc       : marker, ax = 20.00, ay = 20.00;
mi       : marker, ax = 20.00, ay = 20.00;
qif      : quadrupole, l = 0.500000, k = 2.804941, ax = 20.00, ay = 20.00;
qid1     : quadrupole, l = 0.250000, k = -2.004515, ax = 20.00, ay = 20.00;
qid2     : quadrupole, l = 0.250000, k = -2.632355, ax = 20.00, ay = 20.00;
qf1      : quadrupole, l = 0.250000, k = 2.931431, ax = 20.00, ay = 20.00;
qf2      : quadrupole, l = 0.250000, k = 2.465566, ax = 20.00, ay = 20.00;
qf4      : quadrupole, l = 0.250000, k = 2.996834, ax = 20.00, ay = 20.00;
b1e      : bending, l = 0.327479, t = 1.125000, k = -0.700000, 
           t1 = 1.125000, t2 = 0.000000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
b1s      : bending, l = 0.327479, t = 1.125000, k = -0.700000, 
           t1 = 0.000000, t2 = 1.125000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
b2e      : bending, l = 0.654957, t = 2.250000, k = -0.700000, 
           t1 = 2.250000, t2 = 0.000000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
b2s      : bending, l = 0.654957, t = 2.250000, k = -0.700000, 
           t1 = 0.000000, t2 = 2.250000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
b3       : bending, l = 0.451193, t = 1.550000, k = -0.700000, 
           t1 = 0.775000, t2 = 0.775000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
bce      : bending, l = 0.062697, t = 0.700000, k = 0.000000, 
           t1 = 0.700000, t2 = 0.000000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
bcs      : bending, l = 0.062697, t = 0.700000, k = 0.000000, 
           t1 = 0.000000, t2 = 0.700000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
sd       : sextupole, l = 0.150000, k = -119.740776, n =1, 
           ax = 20.00, ay = 20.00;
sf       : sextupole, l = 0.150000, k = 140.941890, n =1, 
           ax = 20.00, ay = 20.00;
s1       : sextupole, l = 0.150000, k = 116.002003, n =1, 
           ax = 20.00, ay = 20.00;
s2       : sextupole, l = 0.150000, k = -141.084518, n =1, 
           ax = 20.00, ay = 20.00;
s3       : sextupole, l = 0.150000, k = 17.336712, n =1, 
           ax = 20.00, ay = 20.00;
 
{----- table of segments ----------------------------------------------------}
 
disp_ins : b1e, mb1, b1s, l10, l10, l10, sd, lc1, qf1, lq, sf, lq,
           qf2, lc2, sd, l10, b2e, mb2, b2s, l10, sd, lc2, qf2, lq, sf, lq,
           qf4, lc3, b3, lb, bce, mc;
disp_cen : mc, bcs, lb, b3, lc3, qf4, lq, sf, lq, qf2, lc2, sd, l10,
           b2e, mb2, b2s, l10, sd, lc2, qf2, lq, sf, lq, qf1, lc1, sd, l10,
           l10, l10, b1e, mb1, b1s;
ins      : mi, li, qid1, l1, s1, l1, qif, l2, s2, l2, qid2, l3, s3,
           l3;
hsup_ins : ins, disp_ins;
hsup_cen : disp_cen, -ins;
sup      : hsup_ins, hsup_cen;
anel     : sup, nper=20;
 
{ d:\arq\lnls\sirius\otica\sirius_5ba\opa\e_660pm\sirius_5ba.opa }
