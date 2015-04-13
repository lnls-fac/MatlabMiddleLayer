function max_dx = global_tolerance

global THERING;

mode = 1;

deltaRF = 0; % kHz

% carrega modelo AT e modo de operação
try
    %setoperationalmode(mode);
    THERING{4461}.Frequency =  5.000045164986436e+008 + deltaRF * 1000;
catch
    sirius;
    %setoperationalmode(mode);
    THERING{4461}.Frequency =  5.000045164986436e+008 + deltaRF * 1000;
end

figure; 

% parâmetros do erro de deslocamento suave
n = [1 2 3];
sigma = 0.01;
r = calctwiss;
C = findspos(THERING,length(THERING)+1);

% gera curva de deslocamento e normaliza
Dn = 2*(rand(1,length(n))-0.5);
%Dn = [0.584414659119109   0.918984852785806   0.311481398313174];
for i=1:length(r.pos)
    s = r.pos(i);
    D(i) = sum(Dn .* sin((2*pi/C)*n*s));
end
D = (sigma/max(abs(D))) * D;

D = 0.1*D + sigma * ones(size(D));


% plota descolamento ao longo do anel
bpms = findcells(THERING, 'FamName', 'BPM');
scatter(r.pos(bpms), 1e3*D(bpms), 'filled');
hold all;
plot(r.pos, 1e3*D);
xlabel('Posição [m]');
ylabel('Deslocamento [mm]');


% introduz deslocamentos em todos os elementos
for i=1:length(r.pos)
    THERING{i}.T1 = [-D(i) 0 0 0 0 0];
    THERING{i}.T2 = [+D(i) 0 0 0 0 0];
end

% calcula COD (medida no sistema original, claro)
setcavity('on');
setradiation('off');
cod0 = findorbit6(THERING, 1:length(THERING));

% calcula COD medida no novo sistema de coordenadas (que passa no centro dos imãs e no centro dos BPMs)
cod1_x = cod0(1,:) - D;

% plota órbita fechada distorcida (no novo sistema de coordenadas)
hold all;
plot(r.pos, 1e3 * cod1_x);

max_dx = 1000 * max(abs(cod1_x));

fprintf('Máx deslocamento:  %5.3f cm\n', 100 * sigma);
fprintf('Máx desvio órbita: %5.3f cm\n', 100 * max(abs(cod0(1,:))));
fprintf('Máx desvio órbita medida pelos centros magnéticos: %5.3f mm\n', 1000 * max(abs(cod1_x)));
fprintf('Desvio médio de comprimento de órbita: %5.3f cm\n', mean(cod0(6,:)));