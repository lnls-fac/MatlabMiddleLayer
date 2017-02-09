% a partir do modelo THERING obtem os Ks calibrados pelo LOCO e calcula
% deltas necessarios para simetrizacao da ótica, trazendo as familias em
% QF, QD e QFC para os valores médios

function lnls1_lowalpha_symm()

switch2sim

qf  = getpv('QF', 'Physics');
qd  = getpv('QD', 'Physics');
qfc = getpv('QFC', 'Physics');
qf_mean  = mean(qf);
qd_mean  = mean(qd);
qfc_mean = mean(qfc);
delta_qf  = qf_mean - qf;
delta_qd  = qd_mean - qd;
delta_qfc = qfc_mean - qfc;
a2qf01_delta = delta_qf(1);
a2qf03_delta = delta_qf(2);
a2qf05_delta = delta_qf(4);
a2qf07_delta = delta_qf(6);
a2qf09_delta = delta_qf(8);
a2qf11_delta = delta_qf(10);
a2qd01_delta = delta_qd(1);
a2qd03_delta = delta_qd(2);
a2qd05_delta = delta_qd(4);
a2qd07_delta = delta_qd(6);
a2qd09_delta = delta_qd(8);
a2qd11_delta = delta_qd(10);
a6qf01_delta = delta_qfc(1);
a6qf02_delta = delta_qfc(2);

%% implementa delta na maquina real
switch2online;

nr_steps = 10;
for i=1:nr_steps
    steppv('A2QF01', a2qf01_delta / nr_steps, 'Physics');
    steppv('A2QF03', a2qf03_delta / nr_steps, 'Physics');
    steppv('A2QF05', a2qf05_delta / nr_steps, 'Physics');
    steppv('A2QF07', a2qf07_delta / nr_steps, 'Physics');
    steppv('A2QF09', a2qf09_delta / nr_steps, 'Physics');
    steppv('A2QF11', a2qf11_delta / nr_steps, 'Physics');
    steppv('A2QD01', a2qd01_delta / nr_steps, 'Physics');
    steppv('A2QD03', a2qd03_delta / nr_steps, 'Physics');
    steppv('A2QD05', a2qd05_delta / nr_steps, 'Physics');
    steppv('A2QD07', a2qd07_delta / nr_steps, 'Physics');
    steppv('A2QD09', a2qd09_delta / nr_steps, 'Physics');
    steppv('A2QD11', a2qd11_delta / nr_steps, 'Physics');
    steppv('A6QF01', a6qf01_delta / nr_steps, 'Physics');
    steppv('A6QF02', a6qf02_delta / nr_steps, 'Physics');   
end
