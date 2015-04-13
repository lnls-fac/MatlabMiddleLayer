{ d:\arq\lnls\sirius\otica\sirius_5ba\tuney mais alto\opa\sirius_5ba.opa }
 
{----- global parameters (units: gev, m, rad) -------------------------------}
 
 
energy = 3.000000;
 
    betax   = 12.4471776; alphax  = 0.0000000;
    etax    = -0.0000013; etaxp   = 0.0000000;
    betay   = 1.5439588; alphay  = 0.0000000;
    etay    = 0.0000000; etayp   = 0.0000000;
    orbitx  = 0.0000000000; orbitxp = 0.0000000000;
    orbity  = 0.0000000000; orbityp = 0.0000000000;
    orbitdpp= 0.0000000000;
 
{----- table of elements (units: m, m^-2, deg, t; mm, mrad) ---------------- }
{      conventions: quadrupole: k>0 horizontally focusing                    }
{                   sextupole : k=m*l, m:=bpoletip/r^2/(b*rho)               }
 
li       : drift, l = 3.000000, ax = 20.00, ay = 20.00;
l1       : drift, l = 0.075000, ax = 20.00, ay = 20.00;
l2       : drift, l = 0.075000, ax = 20.00, ay = 20.00;
l3       : drift, l = 0.150000, ax = 20.00, ay = 20.00;
lc1      : drift, l = 0.849399, ax = 20.00, ay = 20.00;
lc2      : drift, l = 0.397449, ax = 20.00, ay = 20.00;
lc3      : drift, l = 0.387282, ax = 20.00, ay = 20.00;
lq       : drift, l = 0.075000, ax = 20.00, ay = 20.00;
lb       : drift, l = 0.130000, ax = 20.00, ay = 20.00;
l10      : drift, l = 0.100000, ax = 20.00, ay = 20.00;
mb1      : marker, ax = 20.00, ay = 20.00;
mb2      : marker, ax = 20.00, ay = 20.00;
mq       : marker, ax = 20.00, ay = 20.00;
mc       : marker, ax = 20.00, ay = 20.00;
mi       : marker, ax = 20.00, ay = 20.00;
qif      : quadrupole, l = 0.500000, k = 2.414531, ax = 20.00, ay = 20.00;
qid1     : quadrupole, l = 0.250000, k = -2.030806, ax = 20.00, ay = 20.00;
qid2     : quadrupole, l = 0.250000, k = -1.725198, ax = 20.00, ay = 20.00;
qf1      : quadrupole, l = 0.250000, k = 2.702293, ax = 20.00, ay = 20.00;
qf2      : quadrupole, l = 0.250000, k = 2.787999, ax = 20.00, ay = 20.00;
qf4      : quadrupole, l = 0.250000, k = 3.034447, ax = 20.00, ay = 20.00;
b1e      : bending, l = 0.327479, t = 1.125000, k = -0.779402, 
           t1 = 1.125000, t2 = 0.000000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
b1s      : bending, l = 0.327479, t = 1.125000, k = -0.779402, 
           t1 = 0.000000, t2 = 1.125000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
b2e      : bending, l = 0.654957, t = 2.250000, k = -0.779402, 
           t1 = 2.250000, t2 = 0.000000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
b2s      : bending, l = 0.654957, t = 2.250000, k = -0.779402, 
           t1 = 0.000000, t2 = 2.250000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
b3       : bending, l = 0.451193, t = 1.550000, k = -0.779402, 
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
sd       : sextupole, l = 0.150000, k = -104.055818, n =1, 
           ax = 20.00, ay = 20.00;
sf       : sextupole, l = 0.150000, k = 108.952742, n =1, 
           ax = 20.00, ay = 20.00;
s1       : sextupole, l = 0.150000, k = 92.496179, n =1, 
           ax = 20.00, ay = 20.00;
s2       : sextupole, l = 0.150000, k = -144.456921, n =1, 
           ax = 20.00, ay = 20.00;
s3       : sextupole, l = 0.150000, k = 56.153141, n =1, 
           ax = 20.00, ay = 20.00;
s4       : sextupole, l = 0.150000, k = 0.000000, n =1, 
           ax = 20.00, ay = 20.00;
s5       : sextupole, l = 0.150000, k = 0.000000, n =1, 
           ax = 20.00, ay = 20.00;
s6       : sextupole, l = 0.150000, k = 183.072328, n =1, 
           ax = 20.00, ay = 20.00;
o1       : multipole, n = 4, k = 0.000, ax = 20.00, ay = 20.00;
o2       : multipole, n = 4, k = 0.000, ax = 20.00, ay = 20.00;
o3       : multipole, n = 4, k = 0.000, ax = 20.00, ay = 20.00;
 
{----- table of segments ----------------------------------------------------}
 
disp_ins : b1e, mb1, b1s, l10, l10, sd, lc1, qf1, lq, sf, lq, qf2,
           lc2, sd, l10, b2e, mb2, b2s, l10, sd, lc2, qf2, lq, s6, lq, qf4,
           lc3, sd, l10, b3, lb, bce, mc;
disp_cen : mc, bcs, lb, b3, l10, sd, lc3, qf4, lq, s6, lq, qf2, lc2,
           sd, l10, b2e, mb2, b2s, l10, sd, lc2, qf2, lq, sf, lq, qf1, lc1,
           sd, l10, l10, b1e, mb1, b1s;
ins      : mi, li, qid1, l1, s1, l1, qif, l2, s2, l2, qid2, l3, s3,
           l3;
hsup_ins : ins, disp_ins;
hsup_cen : disp_cen, -ins;
sup      : hsup_ins, hsup_cen;
anel     : sup, nper=20;
 
{ d:\arq\lnls\sirius\otica\sirius_5ba\tuney mais alto\opa\sirius_5ba.opa }
