{*** LNLS_AT2OPA ***}
 
 
{*** System Parameters ***}
energy = 3; { GeV }
dP     = 1e-010; 
CODeps = 1e-006; 
meth   = 4; { integration order }
 
{ ELEMENTS }
{ ======== }
IDDS   : drift, l =  3.000000, ax = 20.00, ay = 20.00;
qid1   : quadrupole, l =  0.246054, k = -1.869664, ax = 20.00, ay = 20.00;
l1     : drift, l =  0.502662, ax = 20.00, ay = 20.00;
qif    : quadrupole, l =  0.503118, k = +2.250260, ax = 20.00, ay = 20.00;
l2     : drift, l =  0.523557, ax = 20.00, ay = 20.00;
qid2   : quadrupole, l =  0.188728, k = -1.061586, ax = 20.00, ay = 20.00;
l3     : drift, l =  0.150032, ax = 20.00, ay = 20.00;
b1     : bending, l =  0.373692, t =    1.338659, k = -0.869427, t1 = +0.000000, t2 = +1.338659, gap = 0.00, k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, k2ex = 0.0000, ax = 20.00, ay = 14.00;
mb1    : marker, ax = 20.00, ay = 20.00;
lc1    : drift, l =  0.998983, ax = 20.00, ay = 20.00;
qf1    : quadrupole, l =  0.295902, k = +2.053240, ax = 20.00, ay = 20.00;
DS     : drift, l =  0.245000, ax = 20.00, ay = 20.00;
mq1    : marker, ax = 20.00, ay = 20.00;
qf2    : quadrupole, l =  0.298979, k = +3.051198, ax = 20.00, ay = 20.00;
lc2    : drift, l =  0.477674, ax = 20.00, ay = 20.00;
b2     : bending, l =  0.601034, t =    2.153058, k = -0.994886, t1 = +0.000000, t2 = +2.153058, gap = 0.00, k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, k2ex = 0.0000, ax = 20.00, ay = 14.00;
mb2    : marker, ax = 20.00, ay = 20.00;
lc3    : drift, l =  0.475827, ax = 20.00, ay = 20.00;
qf3    : quadrupole, l =  0.300297, k = +3.141081, ax = 20.00, ay = 20.00;
mq2    : marker, ax = 20.00, ay = 20.00;
qf4    : quadrupole, l =  0.305099, k = +2.544536, ax = 20.00, ay = 20.00;
lc4    : drift, l =  0.546117, ax = 20.00, ay = 20.00;
b3     : bending, l =  0.367524, t =    1.316565, k = -0.999237, t1 = +0.658282, t2 = +0.658282, gap = 0.00, k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, k2ex = 0.0000, ax = 20.00, ay = 14.00;
DS0002 : drift, l =  0.130000, ax = 20.00, ay = 20.00;
bibc01 : bending, l =  0.062697, t =    0.700000, k = +0.000000, t1 = +0.700000, t2 = +0.000000, gap = 0.00, k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, k2ex = 0.0000, ax = 20.00, ay = 14.00;
mc     : marker, ax = 20.00, ay = 20.00;
mt     : marker, ax = 20.00, ay = 20.00;
END    : marker, ax = 20.00, ay = 20.00;

{ RING }
{ ==== }
anel: 
IDDS, qid1, l1, qif, l2, 
qid2, l3, b1, mb1, b1, 
lc1, qf1, DS, mq1, DS, 
qf2, lc2, b2, mb2, b2, 
lc3, qf3, DS, mq2, DS, 
qf4, lc4, b3, DS0002, bibc01, 
mc, mc, bibc01, DS0002, b3, 
lc4, qf4, DS, mq2, DS, 
qf3, lc3, b2, mb2, b2, 
lc2, qf2, DS, mq1, DS, 
qf1, lc1, b1, mb1, b1, 
mt, l3, qid2, l2, qif, 
l1, qid1, IDDS, END; 
CELL: anel, symmetry = 1;
end;
