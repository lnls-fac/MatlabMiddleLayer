%lnls_import_pressure_profile(data_at,file,q_acc): Import the pressure
%profile file which contains the values of pressure simulated for various
%accumulated charges and over 1/20 of the ring. This function uses the
%periodicity of pressure to extend the pressure profile over the whole
%ring. Adjustments to match the coordinate system from Vacuum Group with
%Accelerator Physics Group were made.
%
%Input - the_ring : ring model from atsummary
%        Last model used: SI.V22.04
%        file    : file name .txt which contains the pressure profile
%        Last version used - 'sirius_pressure_profile_2018.txt'
%        q_acc   : accumulated charge to choose the simulated pressure
%(10000 Ah or more is recommended because it tends to the stationary condition)
%        
%Output - s_P    : longitudinal position [m]
%         P      : pressure [mbar]
%==========================================================================
%29 May, 2018 - Murilo Barbosa Alves
%==========================================================================
function [s_P, P] = lnls_import_pressure_profile(the_ring, file, q_acc)
P_file = importdata(file);
P_data = P_file.data;

if q_acc <= 10;
    P = P_data(:,2);
elseif q_acc > 10 && q_acc < 10000;
   q = [10, 100, 1000, 10000];
   P = interp1(q,P_data(:,2:5)',q_acc)';   
elseif q_acc >= 10000;
    P = P_data(:,5);
end

sym = 20; %The section corresponds to 1/20 of the ring

%The pressure values begins at the end of dipole B1
b_init = findcells(the_ring,'FamName','B1_edge');
the_ring = circshift(the_ring, [0, -b_init(end)+1]);

%Beginning of at model to match origin of reference frames (center of
%straight section)
mk_strt = findcells(the_ring, 'FamName', 'start');
s = findspos(the_ring, [mk_strt, length(the_ring)+1]);
s_0 = s(1);

%Make the position vector
L = s(2);
Sz = length(P);
L_part = L/sym;
s_P = linspace(L_part/Sz, L_part, Sz)';

%Interpolation of pressure to obtain the value at the origin
p0 = interp1(s_P, P, s_0);

%Adjust origin and extends the pressure over the ring
%Shows explicity that the last value is equal to the first value of
%pressure
idx = s_P > s_0;
strt = find(idx,1);
%strt = strt(1);
P = [p0; P(idx, 1); P(~idx, 1)];
P = repmat(P, sym, 1);
P = [P; p0];

aux_vec = linspace(0,sym-1,sym)*L_part;
s_P = [0; s_P - s_P(1) + s_P(strt) - s_0];
s_P = reshape(bsxfun(@plus,s_P, aux_vec),[],1);
s_P = [s_P; L];