function tracy3_read_orbit_correction

NomeDiretorio = uigetdir( ['/home/ABTLUS/fernando.sa/redes_tracy/Sirius/Sirius_5ba/orb_cor/Sirius_5ba_14_2/'],...
...['/opt/tracy/'],...
'Escolha o diretorio em que esta o arquivo');
if (NomeDiretorio==0);
    return;
end;
%% Vertical Plane
NomeTot = fullfile(NomeDiretorio, 'vorbit.out');
header  = importdata(NomeTot, ' ',2);
s = header.data(1,:);
posv = 1e6*header.data(2:end,:);
figure
plot(s,posv);
box on; hold all;
title({'Vertical Plane'});
xlabel('s [m]');
ylabel('cody [um]');

meanv = mean(posv);
standevv = std(posv);

figure;
plot(s,standevv);
box on; hold all;
title({'Vertical Plane'});
xlabel('s [m]');
ylabel('cody [um]');

%% Horizontal Plane
NomeTot = fullfile(NomeDiretorio, 'horbit.out');
header  = importdata(NomeTot, ' ',2);
posh = 1e6*header.data(2:end,:);
figure
plot(s,posh);
box on; hold all;
title({'Horizontal Plane'});
xlabel('s [m]');
ylabel('codx [um]');

meanh = mean(posh);
standevh = std(posh);

figure;
plot(s, standevh);
box on; hold all;
title({'Horizontal Plane'});
xlabel('s [m]');
ylabel('codx [um]');


%% Read OrbScanFile.out file

NomeTot = fullfile(NomeDiretorio, 'OrbScanFile.out');
k = 0;
int = 0;
fileID = fopen(NomeTot);
while int < (length(posv(:,1))+1)
    k = k + 1;
    line = fgets(fileID);
    modk = mod(k,12);
    int = floor(k/12) + 1;
    switch modk
        case 2
            A = sscanf(line,'%*s %*s %*s %*s %*s %*s %f %*s %*s %*s %f');
            Orbit.Initial.BPMs.RMS.x(int) = A(1);
            Orbit.Initial.BPMs.RMS.y(int) = A(2);
        case 3
            A = sscanf(line,'%*s %*s %*s %*s %*s %*s %f %*s %*s %*s %f');
            Orbit.Initial.BPMs.MEAN.x(int) = A(1);
            Orbit.Initial.BPMs.MEAN.y(int) = A(2);
        case 4
            A = sscanf(line,'%*s %*s %*s %*s %*s %*s %f %*s %*s %*s %f');
            Orbit.Initial.BPMs.MAX.x(int) = A(1);
            Orbit.Initial.BPMs.MAX.y(int) = A(2);
        case 5
            A = sscanf(line,'%*s %*s %*s %*s %*s %*s %f %*s %*s %*s %f');
            Orbit.Initial.ALL.RMS.x(int) = A(1);
            Orbit.Initial.ALL.RMS.y(int) = A(2);
        case 6
            A = sscanf(line,'%*s %*s %*s %*s %*s %*s %f %*s %*s %*s %f');
            Orbit.Corrected.BPMs.RMS.x(int) = A(1);
            Orbit.Corrected.BPMs.RMS.y(int) = A(2);
        case 7
            A = sscanf(line,'%*s %*s %*s %*s %*s %*s %f %*s %*s %*s %f');
            Orbit.Corrected.BPMs.MEAN.x(int) = A(1);
            Orbit.Corrected.BPMs.MEAN.y(int) = A(2);
        case 8
            A = sscanf(line,'%*s %*s %*s %*s %*s %*s %f %*s %*s %*s %f');
            Orbit.Corrected.BPMs.MAX.x(int) = A(1);
            Orbit.Corrected.BPMs.MAX.y(int) = A(2);
        case 9
            A = sscanf(line,'%*s %*s %*s %*s %*s %*s %f %*s %*s %*s %f');
            Orbit.Corrected.ALL.RMS.x(int) = A(1);
            Orbit.Corrected.ALL.RMS.y(int) = A(2);
        case 10
            A = sscanf(line,'%*s %*s %*s %*s %*s %f %*s %*s %*s %f');
            CM.RMS.x(int) = A(1);
            CM.RMS.y(int) = A(2);
        case 11
            A = sscanf(line,'%*s %*s %*s %*s %*s %f %*s %*s %*s %f');
            CM.MEAN.x(int) = A(1);
            CM.MEAN.y(int) = A(2);
        case 0
            A = sscanf(line,'%*s %*s %*s %*s %*s %f %*s %*s %*s %f');
            CM.MAX.x(int) = A(1);
            CM.MAX.y(int) = A(2);
        case 1
    end
end
fclose(fileID);
assignin('base','CM',CM);
assignin('base','Orbit',Orbit);

%% Display results on the screen
fprintf('Valores nos BPMs\t\t\t  X\t\t\t  Y\n');
a = 1000*mean(abs(Orbit.Initial.BPMs.RMS.x));
b = 1000*mean(abs(Orbit.Initial.BPMs.RMS.y));
fprintf('RMS sem corrigir [um]\t\t%.2f\t\t%.2f\n',a,b);
a = 1000*mean(abs(Orbit.Initial.ALL.RMS.x));
b = 1000*mean(abs(Orbit.Initial.ALL.RMS.y));
fprintf('RMS ALL sem corrigir [um]\t%.2f\t\t%.2f\n',a,b);
a = 1000*mean(abs(Orbit.Initial.BPMs.MAX.x));
b = 1000*mean(abs(Orbit.Initial.BPMs.MAX.y));
fprintf('M�ximo sem corrigir [um]\t%.2f\t\t%.2f\n',a,b);
a = 1000*mean(abs(Orbit.Corrected.BPMs.RMS.x));
b = 1000*mean(abs(Orbit.Corrected.BPMs.RMS.y));
fprintf('RMS corrigido [um]\t\t\t%.2f\t\t%.2f\n',a,b);
a = 1000*mean(abs(Orbit.Corrected.ALL.RMS.x));
b = 1000*mean(abs(Orbit.Corrected.ALL.RMS.y));
fprintf('RMS ALL corrigido [um]\t\t%.2f\t\t%.2f\n',a,b);
a = 1000*mean(abs(Orbit.Corrected.BPMs.MAX.x));
b = 1000*mean(abs(Orbit.Corrected.BPMs.MAX.y));
fprintf('M�ximo corrigido [um]\t\t%.2f\t\t%.2f\n',a,b);
a = 1000*mean(abs(CM.RMS.x));
b = 1000*mean(abs(CM.RMS.y));
fprintf('RMS Corretoras [urad]\t\t%.2f\t\t%.2f\n',a,b);
a = 1000*mean(abs(CM.MAX.x));
b = 1000*mean(abs(CM.MAX.y));
fprintf('M�ximo Corretoras [urad]\t%.2f\t\t%.2f\n\n',a,b);
