% ibs_phases: write in file and plot final values of horizontal and vertical
% emittances and energy spread in function of current per bunch in
% operation phases 1 and 2. The calculations take into account the effect
% of IBS (using CIMP and Bane models) and also consider the changes in
% natural emittance and natural energy spread due to IDs. 
%
%INPUT: data_atsum: struct with ring parameters (atsummary)
%       I         : Current per bunch vector    [A]
%       Obs.: Since the horizontal axis is in log scale, it is recommended to
% give as input a current per bunch vector generated with logspace function
% for better quality graphics.
%       K         : Coupling between vertical and horizontal emittances [%]
%       p         : 'plot' plots graphics of quantities versus current beam
%       per bunch at different phases
%       s         : 'save' saves four .txt files related to the operational
%       phases 1 and 2 for two models CIMP and Bane. These files contains
%       the current per bunch vector, vertical and horizontal emittances,
%       energy spread and bunch length.
%
%
% April, 2018 
%==========================================================================

function ibs_phases(data_atsum,I,K,s,p)

% If there is no argument for coupling, set K=3%
if(~exist('K','var'))
    K = 3; 
end

K = K/100; %Coupling inputs are in [%]

nint = length(I);


%Save .txt files
if(exist('s','var'))
    if(strcmp(s,'save'))
        flag_save = true;
    else
        error('Invalid argument.');
    end
else
    flag_save = false;
end

%Plot graphics with Matlab

if(exist('p','var'))
    if(strcmp(p,'plot'))
        flag_plot = true;
    else
        error('Invalid argument.');
    end
else
    flag_plot = false;
end

%Phase 0
%emitCIMP_ph0 = zeros(nint,4);
%emitBANE_ph0 = zeros(nint,4);
%[emitCIMP_ph0,emitBANE_ph0,~] = ibs_id(data_atsum,I,K,0);

%Phase 1
emitCIMP_ph1 = zeros(nint,4);
emitBANE_ph1 = zeros(nint,4);
[emitCIMP_ph1,emitBANE_ph1] = ibs_id(data_atsum,I,K,1);

%Phase 2
emitCIMP_ph2 = zeros(nint,4);
emitBANE_ph2 = zeros(nint,4);
[emitCIMP_ph2,emitBANE_ph2] = ibs_id(data_atsum,I,K,2);

if(flag_save)
%Writes on files .dat, Current [mA], Horizonal Emittance [nm.rad], Vertical
%Emittance [pm.rad], Energy Spread [%]

fileCIMP1 = fopen('ibs_phase1_CIMP_plot.txt','w');
fprintf(fileCIMP1,'%6s \t\t %6s \t %6s \t %6s \t %6s \r\n','I [mA]','Ex [nm.rad]', 'Ey [pm.rad]', 'Energy Spread [%]','Bunch Length [mm]');
fprintf(fileCIMP1,'%-6.6f \t %-6.6f \t %-6.6f \t %-6.6f \t\t %-6.6f \r\n',[I'.*1e3,emitCIMP_ph1(:,1).*1e9,emitCIMP_ph1(:,2).*1e12,emitCIMP_ph1(:,3)*100,emitCIMP_ph1(:,4)*1e3].');
fclose(fileCIMP1);

fileBANE1 = fopen('ibs_phase1_BANE_plot.txt','w');
fprintf(fileBANE1,'%6s \t\t %6s \t %6s \t %6s \t %6s \r\n','I [mA]','Ex [nm.rad]', 'Ey [pm.rad]', 'Energy Spread [%]','Bunch Length [mm]');
fprintf(fileBANE1,'%-6.6f \t %-6.6f \t %-6.6f \t %-6.6f \t\t %-6.6f \r\n',[I'.*1e3,emitBANE_ph1(:,1).*1e9,emitBANE_ph1(:,2).*1e12,emitBANE_ph1(:,3).*100,emitBANE_ph1(:,4)*1e3].');
fclose(fileBANE1);

fileCIMP2 = fopen('ibs_phase2_CIMP_plot.txt','w');
fprintf(fileCIMP2,'%6s \t\t %6s \t %6s \t %6s \t %6s \r\n','I [mA]','Ex [nm.rad]', 'Ey [pm.rad]', 'Energy Spread [%]','Bunch Length [mm]');
fprintf(fileCIMP2,'%-6.6f \t %-6.6f \t %-6.6f \t %-6.6f \t\t %-6.6f \r\n',[I'.*1e3,emitCIMP_ph2(:,1).*1e9,emitCIMP_ph2(:,2).*1e12,emitCIMP_ph2(:,3)*100,emitCIMP_ph2(:,4)*1e3].');
fclose(fileCIMP2);

fileBANE2 = fopen('ibs_phase2_BANE_plot.txt','w');
fprintf(fileBANE2,'%6s \t\t %6s \t %6s \t %6s \t %6s \r\n','I [mA]','Ex [nm.rad]', 'Ey [pm.rad]', 'Energy Spread [%]','Bunch Length [mm]');
fprintf(fileBANE2,'%-6.6f \t %-6.6f \t %-6.6f \t %-6.6f \t\t %-6.6f \r\n',[I'.*1e3,emitBANE_ph2(:,1).*1e9,emitBANE_ph2(:,2).*1e12,emitBANE_ph2(:,3).*100,emitBANE_ph2(:,4)*1e3].');
fclose(fileBANE2);

end

if(flag_plot)
I(:) = I(:)*1000; %Beam current [mA]
I_min = I(1);
I_max = I(end);

f_min = 0.95;
f_max = 1.05;

emitCIMP_ph1(:,1) = emitCIMP_ph1(:,1) * 1e9;
emitCIMP_ph1(:,2) = emitCIMP_ph1(:,2) * 1e12;
emitCIMP_ph1(:,3) = emitCIMP_ph1(:,3) * 1e2;
emitCIMP_ph1(:,4) = emitCIMP_ph1(:,4) * 1e3;

emitCIMP_ph2(:,1) = emitCIMP_ph2(:,1) * 1e9;
emitCIMP_ph2(:,2) = emitCIMP_ph2(:,2) * 1e12;
emitCIMP_ph2(:,3) = emitCIMP_ph2(:,3) * 1e2;
emitCIMP_ph2(:,4) = emitCIMP_ph2(:,4) * 1e3;

emitBANE_ph1(:,1) = emitBANE_ph1(:,1) * 1e9;
emitBANE_ph1(:,2) = emitBANE_ph1(:,2) * 1e12;
emitBANE_ph1(:,3) = emitBANE_ph1(:,3) * 1e2;
emitBANE_ph1(:,4) = emitBANE_ph1(:,4) * 1e3;

emitBANE_ph2(:,1) = emitBANE_ph2(:,1) * 1e9;
emitBANE_ph2(:,2) = emitBANE_ph2(:,2) * 1e12;
emitBANE_ph2(:,3) = emitBANE_ph2(:,3) * 1e2;
emitBANE_ph2(:,4) = emitBANE_ph2(:,4) * 1e3;

figure;
semilogx(I,emitCIMP_ph1(:,1),'color',[0.0 0.0 1.0]);
title('Final Horizontal Emittance versus Beam Current per bunch');
xlabel('I [mA]');
ylabel('\epsilon_x [nm rad]');
axis([I_min I_max 0.14 0.45]);
grid on
hold on

semilogx(I,emitCIMP_ph2(:,1),'color',[1.0 0.0 0.0]);

semilogx(I,emitBANE_ph1(:,1),'--','color',[0.0 0.0 1.0]);

semilogx(I,emitBANE_ph2(:,1),'--','color',[1.0 0.0 0.0]);

legend('Phase 1 - CIMP','Phase 2 - CIMP','Phase 1 - BANE','Phase 2 - BANE','location','northwest');
hold off


figure;
semilogx(I,emitCIMP_ph1(:,2),'color',[0.0 0.0 1.0]);
title('Final Vertical Emittance versus Beam Current per bunch');
xlabel('I [mA]');
ylabel('\epsilon_y [pm rad]');
axis([I_min I_max 4 13.5]);
grid on
hold on

semilogx(I,emitCIMP_ph2(:,2),'color',[1.0 0.0 0.0]);

semilogx(I,emitBANE_ph1(:,2),'--','color',[0.0 0.0 1.0]);

semilogx(I,emitBANE_ph2(:,2),'--','color',[1.0 0.0 0.0]);

legend('Phase 1 - CIMP','Phase 2 - CIMP','Phase 1 - BANE','Phase 2 - BANE','location','northwest');
hold off

figure;
semilogx(I,emitCIMP_ph1(:,3),'color',[0.0 0.0 1.0]);
title('Energy Spread versus Beam Current per bunch');
xlabel('I [mA]');
ylabel('\sigma_E/E_0 [%]');
axis([I_min I_max 0.08 0.115]);
grid on
hold on

semilogx(I,emitCIMP_ph2(:,3),'color',[1.0 0.0 0.0]);

semilogx(I,emitBANE_ph1(:,3),'--','color',[0.0 0.0 1.0]);

semilogx(I,emitBANE_ph2(:,3),'--','color',[1.0 0.0 0.0]);

legend('Phase 1 - CIMP','Phase 2 - CIMP','Phase 1 - BANE','Phase 2 - BANE','location','northwest');
hold off
end


