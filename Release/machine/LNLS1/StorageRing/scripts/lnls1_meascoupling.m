function r = lnls1_meascoupling(nr_points)
%Mede acoplamento do anel através de separação mínima entre sintonias.
%
%História: 
%
%2010-09-13: comentários iniciais no código.
%
% function r = lnls1_meascoupling(nr_points)
%
% A função 'lnls1_meascoupling' mede o coeficiente de acoplamento 
% através da separação mínima de sintonias. Para isto o script varia as forças nos
% quadrupolos focalizadores de defocalizadores de modo a gerar uma inversão da parte
% fracionária das sintonias.
%
% Parâmetros de Entrada:
%
% nr_points: número de pontos na varredura das forças quadrupolares para invsersão de sintonia.
%
% Parâmetros de Saída:
%
% r.tunes  : matrix com sintonias medidas durante a varredura. Primeira coluna corresponde à sintonia
%            horizontal e a segunda à vertical.
% r.qf_set : matrix com valores da corrente das fontes dos quadrupolos focalizadores
% r.qd_set : matrix com valores da corrente das fontes dos quadrupolos defocalizadores
% r.timestamp_init  : instante do início da medida.
% r.timestamp_final : instante do final da medida.
% r.machineconfig_init  : estrutura com todos os setpoints no início da medida.
% r.machineconfig_final : estrutura com todos os setpoints no final da medida.
%
% obs: a correção de órbita é ligada automaticamente antes da medida.

lnls1_fast_orbcorr_on;

fd = getfamilydata('TUNE');
if strcmpi(fd.Monitor.Mode,'Online')
    sp_wait = 3;
else
    sp_wait = 0;
end

tunes = gettune;
DeltaTune = [tunes(2)-tunes(1); tunes(1)-tunes(2)];
tuneresp = gettuneresp;
DeltaAmps = inv(tuneresp) * DeltaTune;
quad_families = {'QF', 'QD'}; 

originalSP = getsp(quad_families);

nr_supplies_qf = length(originalSP{1});
nr_supplies_qd = length(originalSP{2});

steps  = linspace(0,1,nr_points);
for i=1:length(steps)
    sp_set{i} = [originalSP{1} + DeltaAmps(1) * ones(nr_supplies_qf,1) * steps(i) originalSP{2} + DeltaAmps(2) * ones(nr_supplies_qd,1) * steps(i)]; 
end

fprintf('Varredura de Sintonias...\n');
r.tunes = [];
r.machineconfig_init = getmachineconfig;
r.timestamp_init= clock;
for i=1:nr_points
    setsp(quad_families{1}, sp_set{i}(:,1));
    setsp(quad_families{2}, sp_set{i}(:,2));
    sleep(sp_wait);
    r.qf_set{i} = sp_set{i}(:,1);
    r.qd_set{i} = sp_set{i}(:,2);
    r.tunes(i,:) = sort(gettune, 'descend');
    fprintf('ponto #%i: %f %f %f\n', i, r.tunes(i,1), r.tunes(i,2), r.tunes(i,1)-r.tunes(i,2)); 
end
setsp(quad_families{1}, originalSP{1});
setsp(quad_families{2}, originalSP{2});
r.machineconfig_final = getmachineconfig;
r.timestamp_final = clock;
sleep(sp_wait);

r.nr_points = nr_points;
r.quad_families = quad_families;
r.delta_amps = DeltaAmps;
