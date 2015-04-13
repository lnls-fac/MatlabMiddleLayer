function r = lnls1_calc_beta_beating

global THERING;

% cria lista de indices a elementos do modelo AT
A2QD01 = findcells(THERING, 'FamName', 'A2QD01');
A2QD03 = findcells(THERING, 'FamName', 'A2QD03');
A2QD05 = findcells(THERING, 'FamName', 'A2QD05');
A2QD07 = findcells(THERING, 'FamName', 'A2QD07');
A2QD09 = findcells(THERING, 'FamName', 'A2QD09');
A2QD11 = findcells(THERING, 'FamName', 'A2QD11');

AQD01A = A2QD01(3:4);   AQD01B = A2QD01(1:2);
AQD03A = A2QD03(1:2);   AQD03B = A2QD03(3:4); 
AQD05A = A2QD05(1:2);   AQD05B = A2QD05(3:4); 
AQD07A = A2QD07(1:2);   AQD07B = A2QD07(3:4); 
AQD09A = A2QD09(1:2);   AQD09B = A2QD09(3:4); 
AQD11A = A2QD11(1:2);   AQD11B = A2QD11(3:4); 

SYMMETRY_POINTS = sort([ ...
    AQD01B(1) AQD01A(2)+1 ...
    AQD03B(1) AQD03A(2)+1 ...
    AQD05B(1) AQD05A(2)+1 ...
    AQD07B(1) AQD07A(2)+1 ...
    AQD09B(1) AQD09A(2)+1 ...
    AQD11B(1) AQD11A(2)+1 ...
    ]);

twiss = calctwiss;
r.tunex = twiss.mux(end)/(2*pi);
r.tuney = twiss.muy(end)/(2*pi);
r.betax = twiss.betax(SYMMETRY_POINTS);
r.betay = twiss.betay(SYMMETRY_POINTS);
r.betax_beating = 100*std(r.betax)/mean(r.betax);
r.betay_beating = 100*std(r.betay)/mean(r.betay);
