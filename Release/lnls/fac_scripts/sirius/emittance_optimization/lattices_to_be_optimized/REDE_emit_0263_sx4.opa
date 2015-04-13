{ ..08 - troca trecho sextupolo\opa betax mais alto\rede_emit_0263_sx4.opa }
 
{----- global parameters (units: gev, m, rad) -------------------------------}
 
 
energy = 3.000000;
 
    betax   = 13.0213809; alphax  = 0.0000000;
    etax    = 0.0000078; etaxp   = 0.0000000;
    betay   = 2.7640808; alphay  = 0.0000000;
    etay    = 0.0000000; etayp   = 0.0000000;
    orbitx  = 0.0000000000; orbitxp = 0.0000000000;
    orbity  = 0.0000000000; orbityp = 0.0000000000;
    orbitdpp= 0.0000000000;
 
{----- table of elements (units: m, m^-2, deg, t; mm, mrad) ---------------- }
{      conventions: quadrupole: k>0 horizontally focusing                    }
{                   sextupole : k=m*l, m:=bpoletip/r^2/(b*rho)               }
 
li       : drift, l = 3.000000, ax = 20.00, ay = 14.00;
l1       : drift, l = 0.171265, ax = 20.00, ay = 14.00;
l2       : drift, l = 0.203952, ax = 20.00, ay = 14.00;
l31      : drift, l = 0.170000, ax = 20.00, ay = 14.00;
l32      : drift, l = 0.154741, ax = 20.00, ay = 14.00;
lc11     : drift, l = 0.400000, ax = 20.00, ay = 14.00;
lc12     : drift, l = 0.106200, ax = 20.00, ay = 14.00;
lc13     : drift, l = 0.170000, ax = 20.00, ay = 14.00;
lc21     : drift, l = 0.171709, ax = 20.00, ay = 14.00;
lc22     : drift, l = 0.200000, ax = 20.00, ay = 14.00;
lc31     : drift, l = 0.150000, ax = 20.00, ay = 14.00;
lc32     : drift, l = 0.170669, ax = 20.00, ay = 14.00;
lc41     : drift, l = 0.170000, ax = 20.00, ay = 14.00;
ls       : drift, l = 0.150000, ax = 20.00, ay = 14.00;
lc42     : drift, l = 0.229917, ax = 20.00, ay = 14.00;
lq       : drift, l = 0.170000, ax = 20.00, ay = 14.00;
lb       : drift, l = 0.130000, ax = 20.00, ay = 14.00;
mb1      : marker, ax = 20.00, ay = 14.00;
mb2      : marker, ax = 20.00, ay = 14.00;
mc       : marker, ax = 20.00, ay = 14.00;
mq1      : marker, ax = 20.00, ay = 14.00;
mq2      : marker, ax = 20.00, ay = 14.00;
mi       : marker, ax = 20.00, ay = 14.00;
mt       : marker, ax = 20.00, ay = 14.00;
qif      : quadrupole, l = 0.500000, k = 1.965590, ax = 20.00, ay = 14.00;
qid1     : quadrupole, l = 0.250000, k = -1.192041, ax = 20.00, ay = 14.00;
qid2     : quadrupole, l = 0.250000, k = -0.592217, ax = 20.00, ay = 14.00;
qf1      : quadrupole, l = 0.300000, k = 2.483034, ax = 20.00, ay = 14.00;
qf2      : quadrupole, l = 0.300000, k = 2.475179, ax = 20.00, ay = 14.00;
qf3      : quadrupole, l = 0.300000, k = 3.149987, ax = 20.00, ay = 14.00;
qf4      : quadrupole, l = 0.300000, k = 2.585392, ax = 20.00, ay = 14.00;
b1e      : bending, l = 0.392974, t = 1.350000, k = -0.935110, 
           t1 = 1.350000, t2 = 0.000000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
b1s      : bending, l = 0.392974, t = 1.350000, k = -0.935110, 
           t1 = 0.000000, t2 = 1.350000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
b2e      : bending, l = 0.611293, t = 2.100000, k = -0.935110, 
           t1 = 2.100000, t2 = 0.000000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
b2s      : bending, l = 0.611293, t = 2.100000, k = -0.935110, 
           t1 = 0.000000, t2 = 2.100000, gap = 0.00, 
           k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, 
           k2ex = 0.0000, ax = 20.00, ay = 14.00;
b3       : bending, l = 0.407529, t = 1.400000, k = -0.935110, 
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
sd       : sextupole, l = 0.150000, k = -53.792340, n =1, 
           ax = 20.00, ay = 20.00;
sf       : sextupole, l = 0.150000, k = 133.623901, n =1, 
           ax = 20.00, ay = 20.00;
s11      : sextupole, l = 0.150000, k = 38.369922, n =1, 
           ax = 20.00, ay = 20.00;
s21      : sextupole, l = 0.150000, k = -63.917160, n =1, 
           ax = 20.00, ay = 20.00;
s12      : sextupole, l = 0.150000, k = 49.817814, n =1, 
           ax = 20.00, ay = 20.00;
s22      : sextupole, l = 0.150000, k = -89.675042, n =1, 
           ax = 20.00, ay = 20.00;
s3       : sextupole, l = 0.150000, k = -120.603316, n =1, 
           ax = 20.00, ay = 20.00;
s6       : sextupole, l = 0.150000, k = -150.052741, n =1, 
           ax = 20.00, ay = 20.00;
s7       : sextupole, l = 0.150000, k = 343.518839, n =1, 
           ax = 20.00, ay = 20.00;
s8       : sextupole, l = 0.150000, k = -378.879759, n =1, 
           ax = 20.00, ay = 20.00;
 
{----- table of segments ----------------------------------------------------}
 
disp_ins : b1e, mb1, b1s, lc11, sd, lc12, ls, lc13, qf1, lq, sf, lq,
           qf2, lc21, s3, lc22, b2e, mb2, b2s, lc31, s6, lc32, qf3, lq, s7,
           lq, qf4, lc41, s8, lc42, b3, lb, bce, mc;
disp_cen : mc, bcs, lb, b3, lc42, s8, lc41, qf4, lq, s7, lq, qf3,
           lc32, s6, lc31, b2e, mb2, b2s, lc22, s3, lc21, qf2, lq, sf, lq,
           qf1, lc13, ls, lc12, sd, lc11, b1e, mb1, b1s;
ins      : mi, li, qid1, l1, s11, l1, qif, l2, qid2, l31, s21, l32;
hsup_ins : ins, disp_ins;
hsup_cen : disp_cen, mt, -ins;
sup      : hsup_ins, hsup_cen;
anel     : sup, nper=20;
 
{ ..08 - troca trecho sextupolo\opa betax mais alto\rede_emit_0263_sx4.opa }
