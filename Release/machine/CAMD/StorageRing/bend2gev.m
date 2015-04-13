function GeVout = bend2gev(BENDin)
%BEND2GEV - Converts BEND current to beam energy
%  GeV = bend2gev(BEND)
%  
%  INPUTS
%  1. BEND = Bend magnet current [Amps]
%
%  OUTPUTS
%  1. GeV = Electron beam energy [GeV]


% ???
GeVout = getfamilydata('Energy');



% if nargin < 1
%     BENDin = getam('BEND', [1 1]);
% end
% 
% for ii = 1:length(BENDin)
%     BEND = BENDin(ii);
%     
%     
%     % Convert to energy
%     
%     % C coefficients have been scaled to convert between AT units and hardware units and also includes a DC term:
%     % c8 * I^8+ c7 * I^7+ c6 * I^6 + c5 * I^5 + c4 * I^4 + c3 * I^3 + c2 * I^2+c1*I + c0 = B or B' or B"
%     % C = [c8 c7 c6 c5 c4 c3 c2 c1 c0]
%     [C, Leff, MagnetType, A] = magnetcoefficients('BEND');
%     
%     B = C(8)*BEND + C(7)*BEND.^2 + C(6)*BEND.^3 + C(5)*BEND.^4 + C(4)*BEND.^5 + C(3)*BEND.^6 + C(2)*BEND.^7 + C(1)*BEND.^8;
%     % k(i,1) = polyval(C, Amps(i)) / brho;
%     
%     % k is fixed to be -0.31537858
%     k = -0.31537858;
%     
%     boverbprime = 0.392348;
%     bprime = B / boverbprime;
%     brho = bprime / k;
%     
%     % now return energy in GeV
%     GeV = brho / 3.33620907461447;
%     
%     
%     if size(BENDin,2) == 1
%         GeVout(ii,1) = GeV;
%     else
%         GeVout(1,ii) = GeV;
%     end
% 
% end
% 
% 
% % cur = BEND;
% % % Convert to energy
% % 
% % a7= 0.0137956;
% % a6=-0.0625519;
% % a5= 0.1156769;
% % a4=-0.1141570;
% % a3= 0.0652128;
% % a2=-0.0216472;
% % a1= 0.0038866;
% % a0= 0.0028901;
% % 
% % i0=700.;
% % c7=a7/(i0^7);
% % c6=a6/(i0^6);
% % c5=a5/(i0^5);
% % c4=a4/(i0^4);
% % c3=a3/(i0^3);
% % c2=a2/(i0^2);
% % c1=a1/i0;
% % c0=a0;
% % leff=1.5048;
% % 
% % 
% % % kl = (cur/brho)*(c0+c1*cur+c2*cur^2+c3*cur^3+c4*cur^4+c5*cur^5+c6*cur^6+c7*cur^7);
% % % k  = kl/Leff;
% % % k is fixed to be -0.31537858
% % k = -0.31537858;
% % 
% % BLeff = cur.*(c0+c1*cur+c2*cur.^2+c3*cur.^3+c4*cur.^4+c5*cur.^5+c6*cur.^6+c7*cur.^7);
% % field = BLeff / Leff;
% % 
% % boverbprime = 0.392348;
% % bprime = field / boverbprime;
% % brho = bprime / k;
% % 
% % % now return energy in GeV
% % GeV = brho / 3.33620907461447;
% 


