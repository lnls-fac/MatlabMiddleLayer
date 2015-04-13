{*** LNLS_AT2OPA ***}
 
 
{*** System Parameters ***}
energy = 3; { GeV }
dP     = 1e-010; 
CODeps = 1e-006; 
meth   = 4; { integration order }
 
{ ELEMENTS }
{ ======== }
IDDS   : drift, l =  3.000000, ax = 20.00, ay = 20.00;
qid1   : quadrupole, l =  0.227669, k = -1.123275, ax = 20.00, ay = 20.00;
l1     : drift, l =  0.171265, ax = 20.00, ay = 20.00;
s11    : sextupole, l =  0.117777, k = +0.000000, n = 10, ax = 20.00, ay = 20.00;
qif    : quadrupole, l =  0.498103, k = +1.949368, ax = 20.00, ay = 20.00;
l2     : drift, l =  0.203952, ax = 20.00, ay = 20.00;
qid2   : quadrupole, l =  0.250000, k = -0.629321, ax = 20.00, ay = 20.00;
l31    : drift, l =  0.170000, ax = 20.00, ay = 20.00;
s21    : sextupole, l =  0.137271, k = +0.000000, n = 10, ax = 20.00, ay = 20.00;
l32    : drift, l =  0.154741, ax = 20.00, ay = 20.00;
b1     : bending, l =  0.393419, t =    1.466025, k = -0.983538, t1 = +1.466025, t2 = +0.000000, gap = 0.00, k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, k2ex = 0.0000, ax = 20.00, ay = 14.00;
mb1    : marker, ax = 20.00, ay = 20.00;
lc11   : drift, l =  0.400000, ax = 20.00, ay = 20.00;
sd     : sextupole, l =  0.148090, k = +0.000000, n = 10, ax = 20.00, ay = 20.00;
lc12   : drift, l =  0.106200, ax = 20.00, ay = 20.00;
ls     : drift, l =  0.150000, ax = 20.00, ay = 20.00;
lc13   : drift, l =  0.170000, ax = 20.00, ay = 20.00;
qf1    : quadrupole, l =  0.298197, k = +2.454814, ax = 20.00, ay = 20.00;
DS     : drift, l =  0.170000, ax = 20.00, ay = 20.00;
sf     : sextupole, l =  0.177338, k = +0.000000, n = 10, ax = 20.00, ay = 20.00;
qf2    : quadrupole, l =  0.300000, k = +2.467807, ax = 20.00, ay = 20.00;
lc21   : drift, l =  0.171709, ax = 20.00, ay = 20.00;
s3     : sextupole, l =  0.141983, k = +0.000000, n = 10, ax = 20.00, ay = 20.00;
lc22   : drift, l =  0.200000, ax = 20.00, ay = 20.00;
b2     : bending, l =  0.606291, t =    2.032019, k = -0.895207, t1 = +0.000000, t2 = +2.032019, gap = 0.00, k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, k2ex = 0.0000, ax = 20.00, ay = 14.00;
mb2    : marker, ax = 20.00, ay = 20.00;
lc31   : drift, l =  0.150000, ax = 20.00, ay = 20.00;
s6     : sextupole, l =  0.140062, k = +0.000000, n = 10, ax = 20.00, ay = 20.00;
lc32   : drift, l =  0.170669, ax = 20.00, ay = 20.00;
qf3    : quadrupole, l =  0.300000, k = +3.103961, ax = 20.00, ay = 20.00;
s7     : sextupole, l =  0.123909, k = +0.000000, n = 10, ax = 20.00, ay = 20.00;
qf4    : quadrupole, l =  0.300000, k = +2.595299, ax = 20.00, ay = 20.00;
lc41   : drift, l =  0.170000, ax = 20.00, ay = 20.00;
s8     : sextupole, l =  0.139154, k = +0.000000, n = 10, ax = 20.00, ay = 20.00;
lc42   : drift, l =  0.229917, ax = 20.00, ay = 20.00;
b3     : bending, l =  0.406002, t =    1.303913, k = -0.998887, t1 = +0.651957, t2 = +0.651957, gap = 0.00, k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, k2ex = 0.0000, ax = 20.00, ay = 14.00;
DS0002 : drift, l =  0.130000, ax = 20.00, ay = 20.00;
bibc01 : bending, l =  0.062697, t =    0.700000, k = +0.000000, t1 = +0.700000, t2 = +0.000000, gap = 0.00, k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, k2ex = 0.0000, ax = 20.00, ay = 14.00;
mc     : marker, ax = 20.00, ay = 20.00;
mt     : marker, ax = 20.00, ay = 20.00;
END    : marker, ax = 20.00, ay = 20.00;

{ RING }
{ ==== }
anel: 
IDDS, qid1, l1, s11, l1, 
qif, l2, qid2, l31, s21, 
l32, b1, mb1, b1, lc11, 
sd, lc12, ls, lc13, qf1, 
DS, sf, DS, qf2, lc21, 
s3, lc22, b2, mb2, b2, 
lc31, s6, lc32, qf3, DS, 
s7, DS, qf4, lc41, s8, 
lc42, b3, DS0002, bibc01, mc, 
mc, bibc01, DS0002, b3, lc42, 
s8, lc41, qf4, DS, s7, 
DS, qf3, lc32, s6, lc31, 
b2, mb2, b2, lc22, s3, 
lc21, qf2, DS, sf, DS, 
qf1, lc13, ls, lc12, sd, 
lc11, b1, mb1, b1, mt, 
l32, s21, l31, qid2, l2, 
qif, l1, s11, l1, qid1, 
IDDS, END; 
CELL: anel, symmetry = 1;
end;
