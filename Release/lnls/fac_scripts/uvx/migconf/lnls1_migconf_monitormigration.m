function lnls1_migconf_monitormigration
% Registra parâmetros de uma rampa para posterior análise e correções.
%
% Historico:
%
% 2010-09-16: comentarios iniciais no codigo (Ximenes R. Resende)

 rampa.time_stamp = [];
 rampa.corrente   = [];
 rampa.energia    = [];
 rampa.qf         = [];
 rampa.qd         = [];
 rampa.qfc        = [];
 rampa.sintonia   = [];
   

while true
    
    rampa.time_stamp = [rampa.time_stamp now];
    rampa.corrente   = [rampa.corrente getdcct];
    rampa.energia    = [rampa.energia getpv('BEND', 'Setpoint', [1 1], 'Physics')];
    rampa.qf         = [rampa.qf getpv('QF', 'Setpoint', 'Physics')];
    rampa.qd         = [rampa.qd getpv('QD', 'Setpoint', 'Physics')];
    rampa.qfc        = [rampa.qfc getpv('QFC', 'Setpoint', 'Physics')];
    rampa.sintonia   = [rampa.sintonia gettune];
    
    assignin('base', 'rampa', rampa);
    
    sleep(0.5);
    
end
    
    