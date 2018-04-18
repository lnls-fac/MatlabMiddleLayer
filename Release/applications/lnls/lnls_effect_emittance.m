%lnls_effect_emittance: defines the parameters of beam lines, returns new 
%struct with ring parameters due to the presence of IDs. The  function lnls_emit_ID_total
%performs the calculations of variations.
%
%INPUT  data_at: struct with storage ring parameters (atsummary)
%       phase: set the operational phase (0, 1 or 2)
%    
%
%OUTPUT data_at_new: new struct with parameters updated by the presence of IDs,
%depending on the phase chosen a different bunch length and maximum total
%current are set
%
%April, 2018 
%
%===============================================================================================

function [data_at_new] = lnls_effect_emittance(data_at,phase)

%Definition of beam lines parameters

st1  = struct('name','CARNAUBA','K','2.2','WaveLength','0.021','length','2.4','section','B');
st2  = struct('name','EMA','K','2.27','WaveLength','0.019','length','2.4','section','B');
st3  = struct('name','CATERETE','K','2.2','WaveLength','0.021','length','2.4','section','B');
st4  = struct('name','IPE','K','5.85','WaveLength','0.0525','length','3.6','section','B');
st5  = struct('name','SABIA','K','5.85','WaveLength','0.0525','length','3.6','section','B');
st6  = struct('name','MANACA','K','2','WaveLength','0.02','length','2.4','section','A');
st7  = struct('name','PGM++','K','5.95','WaveLength','0.0525','length','3.6','section','B');
st8  = struct('name','CARNAUBA','K','2.2','WaveLength','0.021','length','2.4','section','B');
st9  = struct('name','EMA','K','2.27','WaveLength','0.019','length','2.4','section','B');
st10 = struct('name','CATERETE','K','2.2','WaveLength','0.021','length','2.4','section','B');
st11 = struct('name','IPE','K','5.85','WaveLength','0.0525','length','3.6','section','B');
st12 = struct('name','SABIA','K','5.85','WaveLength','0.0525','length','3.6','section','B');
st13 = struct('name','MANACA','K','2','WaveLength','0.02','length','2.4','section','A');
st14 = struct('name','PGM++','K','5.95','WaveLength','0.0525','length','3.6','section','B');
st15 = struct('name','CARNAUBA','K','2.2','WaveLength','0.021','length','2.4','section','B');
st16 = struct('name','EMA','K','2.27','WaveLength','0.019','length','2.4','section','B');
st17 = struct('name','CATERETE','K','2.2','WaveLength','0.021','length','2.4','section','A');

ids_ph1 =  {st1;st2;st3;st4;st5;st6;st7};
ids_ph2 = {st1;st2;st3;st4;st5;st6;st7;st8;st9;st10;st11;st12;st13;st14;st15;st16;st17};

if phase == 0
    EmitF = data_at.naturalEmittance;
    EnSpF = data_at.naturalEnergySpread;
    data_at_new = data_at;
    return 
elseif phase == 1
    ids = ids_ph1;
    It_max = 100; %Maximum total current in mA
    %data1.naturalEmittance = 0.21e-9;
    %data1.naturalEnergySpread = 8.4e-4;
    data_at.bunchlength = 2.3e-3;
elseif phase == 2
    ids = ids_ph2;
    It_max = 350; 
    %data1.naturalEmittance = 0.15e-9;
    %data1.naturalEnergySpread = 8.3e-4;
    data_at.bunchlength = 11.6e-3;
else
    error('Invalid phase number');
end

[Emit,EnSp,Jx,Jy,Je,tx,ty,te] = lnls_emit_ID_total(data_at,ids,It_max);

data_at.naturalEnergySpread = EnSp(end);

%Emittance in [m.rad]
data_at.naturalEmittance = Emit(end); 

%Damping partition numbers
data_at.damping(1) = Jx; 
data_at.damping(2) = Jy;
data_at.damping(3) = Je;

%Damping times in seconds
data_at.radiationDamping(1) = tx; 
data_at.radiationDamping(2) = ty;
data_at.radiationDamping(3) = te;

data_at_new = data_at;




