function r = lnls1_dc_bump_to_kick_amplitude

% pega nomes dos arquivos
pathstr = fileparts(mfilename('fullpath'));

[FileName,PathName,~] = uigetfile('*.orb','Selecione arquivo com órbita de injeção',pathstr);
r.injection_orb_fname = fullfile(PathName,FileName);
r.injection_orb = get_orbit(r.injection_orb_fname);

[FileName,PathName,~] = uigetfile('*.orb','Selecione arquivo com órbita de alta energia',pathstr);
r.users_orb_fname = fullfile(PathName,FileName);
r.users_orb = get_orbit(r.users_orb_fname);

% inicializa estruturas do MML
global THERING;
cdir = pwd;
cd('C:\Arq\MatlabMiddleLayer\Release\mml\');
setpathlnls('LNLS1', 'StorageRing', 'lnls1_link');
cd(cdir);
clear cdir;
setoperationalmode(2);
%setpv('A6SF',0);
%setpv('A6SD01',0);
%setpv('A6SD02',0);

r.kickers_idx = findcells(THERING, 'FamName', 'INJKICKER');
bpms_idx = findcells(THERING, 'FamName', 'BPM');
kickers_pos = findspos(THERING, r.kickers_idx);
bpms_pos = findspos(THERING, bpms_idx);


% matriz resposta dos kickers
init_cod = [findorbit4(THERING, 0); 0; 0];
delta_kick = 0.000002;
M = zeros(length(bpms_idx), length(r.kickers_idx));
for i=1:length(r.kickers_idx)
    idx1 = r.kickers_idx(i);
    init_kick = THERING{idx1}.KickAngle(1);
    cod1 = linepass(THERING, init_cod(:,1), 1:length(THERING));
    THERING{idx1}.KickAngle(1) = init_kick + delta_kick;
    cod2 = linepass(THERING, init_cod(:,1), 1:length(THERING));
    M(:,i) = (cod2(1,bpms_idx) - cod1(1,bpms_idx))' / delta_kick;
    THERING{idx1}.KickAngle(1) = init_kick;
end

% constroi vetor com bump a ser gerado
dif_orb = r.injection_orb(:,1) - r.users_orb(:,1);
bump = zeros(size(r.injection_orb,1),1);
r.bpms_in_bump_idx = (bpms_pos > min(kickers_pos)) & (bpms_pos < max(kickers_pos));
bump(r.bpms_in_bump_idx) = dif_orb(r.bpms_in_bump_idx);
bump = bump(:)/1000;

% calcula kicks
r.kick = M \ bump;

% implementa kicks
for i=1:length(r.kickers_idx)
    idx1 = r.kickers_idx(i);
    THERING{idx1}.KickAngle(1) = init_kick + r.kick(i);  
end

% calcula orbita fechada com kick
r.cod = findorbit4(THERING, 0, bpms_idx);
plot(bpms_pos, 1000*r.cod(1,:))
hold all;
scatter(bpms_pos(r.bpms_in_bump_idx), 1000*bump(r.bpms_in_bump_idx), 'filled');
xlabel('Posição [m]');
ylabel('Órbita horizontal [mm]');

% calcula voltagem nos kicks
r.kickers_voltage = getpv('KICKER');



    

function r = get_orbit(fname)

fp = fopen(fname, 'r');
for i=1:25
    line = fgetl(fp);
    r(i,:) = sscanf(line, '%f %f');
end
fclose(fp);

