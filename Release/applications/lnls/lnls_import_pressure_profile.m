%lnls_import_pressure_profile(data_at,file,q_acc): Import the pressure
%profile file which contains the values of pressure simulated for various
%accumulated charges and over 1/20 of the ring. This function uses the
%periodicity of pressure to extend the pressure profile over the whole
%ring. Adjustments to match the coordinate system from Vacuum Group with
%Accelerator Physics Group were made. 
%
%Input - data_at : struct with ring parameters (atsummary)
%        file    : file name .txt which contains the pressure profile 
%        Last version - 'sirius_pressure_profile_2018.txt'
%        q_acc   : accumulated charge to choose the simulated pressure
%        values (10000 Ah is recommended because it reachs stationary condition)
%
%Output - s      : longitudinal position [m]
%         P      : pressure [mbar]
%==========================================================================
%25 May, 2018 - Murilo Barbosa Alves
%==========================================================================
function [s,P] = lnls_import_pressure_profile(data_at,file,q_acc)

P_file = importdata(file);
P_data = P_file.data;

if q_acc == 10;
  press = P_data(:,2);
  elseif q_acc==100;
    press = P_data(:,3);
  elseif q_acc==1000;
    press = P_data(:,4);
  elseif q_acc==10000;
    press = P_data(:,5);
  else
    error('Invalid accumulated charge value, available values are 10, 100, 1000 and 10000');
end

L_part   = data_at.circumference/20;
s_p = [L_part/100:L_part/100:L_part];
s_p = s_p';

%The position where the B1 dipole begins
b_init = findcells(data_at.the_ring,'FamName','calc_mom_accep');
b_init = b_init(1,1);
s_0 = findspos(data_at.the_ring,b_init);
%Interpolation of pressure to obtain the value at the origin
p0 = interp1(s_p,press,s_0);
%Extends the position and the pressure taken from the pressure profile file over the whole ring
add = [s_p(end,1)-s_0+L_part/100:L_part/100:L_part]';
P0 = [p0;press(20:end,1);press(1:19,1)];
P=P0;
s0 = [0;s_p(20:end,1)-s_0;add];
s = s0;

for j=1:19;
    s = [s;s0+j*L_part];
end

while length(P)<1920
    P = [P;P0];
end

%Just setting the last values equal to the initial values
s = [s;s(end)+s(102)-s(101)];
P = [P;p0];

save 'sirius_pressure_profile_2018.mat' s P