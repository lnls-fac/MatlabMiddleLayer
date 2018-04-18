%lnls_emit_ID_total: calculates the variation on horizontal emittance and
%energy spread due to the presence of insertions devices (IDs) on the sto-
%rage ring. The function also evaluates the effective emittance, the energy
%lost due to radiation emission and the power.
%
%INPUT: data1: scruct which contains ring parameters (atsummary)
%              - naturalEmittance      [m.rad]
%              - naturalEnergySpread
%              - e0                    [GeV]
%              - damping                 
%              - integrals             (radiation integrals)
%              - twiss
%       bl: cell of struct which contais IDs parameters
%              - K
%              - WaveLength            [m]
%              - length                [m]
%              - section 
%       I: beam current                [mA]
%
%OUTPUT: Emit: final horizontal emittance [m.rad]
%        EnSp: final energy spread 
%
%April, 2018 
%
%==========================================================================

function [Emit,EnSp,Jx,Jy,Je,tx,ty,te] = lnls_emit_ID_total(data1,bl,I)

nbeam = size(bl); 
nbeam = nbeam(1,1); %total number of IDs

EmitNat = data1.naturalEmittance; %Natural emittance in m.rad
EnSpNat = data1.naturalEnergySpread;
E0 = data1.e0; %Nominal energy in GeV
T_rev = data1.revTime;
I20 = data1.integrals(1,2);
I30 = data1.integrals(1,3);
I40 = data1.integrals(1,4);
I50 = data1.integrals(1,5);
Jx0 = 1 - I40/I20;
Je0 = 2 + I40/I20;

CrEmit0 = I50/(I20*Jx0); %zero current emittance criteria
CrEnSp0 = I30/(I20*Je0); %zero current energy spread criteria

mia = findcells(data1.the_ring,'FamName','mia');
mib = findcells(data1.the_ring,'FamName','mib');
mip = findcells(data1.the_ring,'FamName','mip');

%Takes from atsummary the values of twiss parameters on the given marker 
etaxA = data1.twiss.Dispersion(mia(1),1);
etaxB = data1.twiss.Dispersion(mib(1),1);
etaxP = data1.twiss.Dispersion(mip(1),1);
betaxA = data1.twiss.beta(mia(1),1);
betaxB = data1.twiss.beta(mib(1),1);
betaxP = data1.twiss.beta(mip(1),1);

I2w = zeros(nbeam,1);
I3w = zeros(nbeam,1);
I4w = zeros(nbeam,1);
I5w = zeros(nbeam,1);
DifI = zeros(nbeam,1);
SumI = zeros(nbeam,1);
CrEmit = zeros(nbeam,1);
CrEnSp = zeros(nbeam,1);
Emit = zeros(nbeam,1);
EnSp = zeros(nbeam,1);
Emit_eff = zeros(nbeam,1);
U0 = zeros(nbeam,1);
P = zeros(nbeam,1);
Ut = zeros(nbeam,1);
Pt = zeros(nbeam,1);

for i=1:nbeam

  K = bl{i}.K; 
  K = str2num(K);
  lambda = bl{i}.WaveLength; %Wave length [m]
  lambda = str2num(lambda);
  L = bl{i}.length; %ID length [m]
  L = str2num(L);
  type = bl{i}.section; %type of straight section (A, B or P)

  B_ID = K/(0.934*100*lambda); %ID field [T]
  N = L/lambda;
  rho = E0/(0.29979*B_ID); %radius [m]
  fw = lambda/(2*pi*rho); %fraction w

  if isequal(type,'A')
    betax = betaxA;
    etax = etaxA;
  elseif isequal(type,'B')
    betax = betaxB;
    etax = etaxB;
  elseif isequal(type,'P')
    betax = betaxP;
    etax = etaxP;
  else
    error('Invalid type of straight section on beam line number %f',i);
  end

  I2w(i) = L/2/(rho)^2;
  I3w(i) = 8*N*fw/3/rho^2;
  I4w(i) = L/2/pi/rho^3*(8*etax/3 + 4*lambda^2/15/2/pi/rho);
  I5w(i) = 8*N*fw/3/rho^2*(betax*fw^2/5 + etax^2/betax + etax*fw^2/5/betax/rho^3);
  DifI(i) = I2w(i) - I4w(i);
  SumI(i) = 2*I2w(i) + I4w(i);

  CrEmit(i) = I5w(i)/DifI(i)/CrEmit0;
  CrEnSp(i) = I3w(i)/SumI(i)/CrEnSp0;

  Emit(i) = EmitNat*(1+sum(I5w)/I50)/(1+sum(DifI)/(I20 - I40));
  EnSp(i) = EnSpNat*sqrt((1+sum(I3w)/I30)/(1+sum(SumI)/(2*I20 + I40)));
  
  Emit_eff(i) = Emit(i)*sqrt(1+(etax*EnSp(i)/100)^2/betax/Emit(i)); %Effective emittance [m.rad]
  
  
  U0(i) = 0.633*E0^2*B_ID^2*L/1e6; %Energy radiated on ID number i [GeV]
  Ut(i) =  sum(U0); %Energy radiated by the IDs [GeV]
  P(i) = U0(i)*I/1000; %Power of ID number i [GW] (Current in [mA])
  Pt(i) =  sum(P); %Power due to IDs [GeV]
end

I4 = I40 + sum(I4w);
I2 = I20 + sum(I2w);

U0t = data1.radiation + sum(U0); %Total energy bending + wigglers [GeV]

%New damping partition numbers
Jx = 1 - I4/I2;
Je = 2 + I4/I2;
Jy = 1;

%New damping times [s]
tx = 2*E0*T_rev/Jx/U0t;
ty = 2*E0*T_rev/Jy/U0t;
te = 2*E0*T_rev/Je/U0t;



