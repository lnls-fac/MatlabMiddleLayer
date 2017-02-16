function r = lnls1_symmetrize_optics2(locoModel, tunes)

global THERING

% lnls1_set_server('','','');
lnls1;

THERING = locoModel;

if ~exist('tunes', 'var')
    twiss = calctwiss(locoModel);
    tunes = [twiss.mux(end) twiss.muy(end)] / 2 / pi;
end

quads_loco = get_quad_data;
type = 'QuadFamilies';
lnls1_symmetrize_simulation_optics(tunes, type, 'AllSymmetries');
lnls1_symmetrize_simulation_optics(tunes, type, 'AllSymmetries');
lnls1_symmetrize_simulation_optics(tunes, type, 'AllSymmetries');
plotbeta;
quads_symm = get_quad_data;

for i=1:length(quads_loco)
    dK{i} = quads_symm{i}.K - quads_loco{i}.K;
    dA{i} = physics2hw(quads_symm{i}.FamName, 'Setpoint',quads_symm{i}.K) - physics2hw(quads_loco{i}.FamName, 'Setpoint',quads_loco{i}.K);
end

switch2online;
nr_steps = 10;
for j=1:nr_steps
    fprintf('passo %02i\n', j);
    for i=1:length(quads_loco)
        da = dA{i}(1);
        steppv(quads_loco{i}.FamName, da/nr_steps);
    end
    sleep(1.0);
end;


function quads = get_quad_data

global THERING

quad_fams =  {'A2QF01','A2QF03','A2QF05','A2QF07','A2QF09','A2QF11','A2QD01','A2QD03','A2QD05','A2QD07','A2QD09','A2QD11','A6QF01','A6QF02'};
for i=1:length(quad_fams)
    quads{i}.FamName = quad_fams{i};
    quads{i}.ATIndex = getfamilydata(quad_fams{i}, 'AT', 'ATIndex');
    quads{i}.K       = getcellstruct(THERING, 'K', quads{i}.ATIndex(:,1));
end


function r = lnls1_symmetrize_optics_failed(tunex, tuney, betax, betay, etax, etay, aon11_field, awg01_field, awg09_field)

aon11_field = 0.54;
awg01_field = 2.0;
awg09_field = 3.8;

[r.betax r.betay r.etax r.etay] = load_optics_measurements(...
    '/opt/MatlabMiddleLayer/Release/machine/LNLS1/StorageRingData/User/Optics/2013-06-14/beta_2013-06-14_15-38-50.mat', ...
    '/opt/MatlabMiddleLayer/Release/machine/LNLS1/StorageRingData/User/Optics/2013-06-14/Disp_2013-06-14_15-38-50.mat' ...
    );

lnls1_set_server('','','');
lnls1;

% gets quadrupole indices
r.quads_idx = {};
idx = getfamilydata('QF', 'AT', 'ATIndex');   for i=1:size(idx,1), r.quads_idx{end+1} = idx(i,:); end;
idx = getfamilydata('QD', 'AT', 'ATIndex');   for i=1:size(idx,1), r.quads_idx{end+1} = idx(i,:); end;
idx = getfamilydata('QFC', 'AT', 'ATIndex');  for i=1:size(idx,1), r.quads_idx{end+1} = idx(i,:); end;
for i=1:length(r.quads_idx)-1
    for j=i+1:length(r.quads_idx)
        if min(r.quads_idx{j}) < min(r.quads_idx{i})
            tmp = r.quads_idx{i}; r.quads_idx{i} = r.quads_idx{j}; r.quads_idx{j} = tmp;
        end
    end
end

% gets bpm indices
r.bpms_idx = getfamilydata('BPMx', 'AT', 'ATIndex');


% sets insertion devices fields on the model
lnls1_set_id_field('AON11', aon11_field);
lnls1_set_id_field('AWG01', awg01_field);
lnls1_set_id_field('AWG09', awg09_field);

% symmetrizes optics
for i=1:1
    lnls1_symmetrize_simulation_optics([5.27 4.17], 'QuadFamilies', 'AllSymmetries');
    figure; plotbeta; drawnow;
    %h = msgbox('Click "OK" to continue...','modal'); uiwait(h);
end
close('all');

tw = calctwiss; r.tunex = tw.mux(end)/2/pi; r.tuney = tw.muy(end)/2/pi;

residue = calc_residue(r);
M = calc_M(r);

figure; 
[U,S,V] = svd(M,'econ');
iS = 1./diag(S); 
iS(20:end) = 0; 
iS = diag(iS);
dK = -(V*iS*U') * residue;
setdK(r, dK);
residue2 = calc_residue(r);


function setdK(p, dK)

global THERING

for i=1:length(p.quads_idx)
    idx = p.quads_idx{i};
    K = getcellstruct(THERING, 'K', idx);
    THERING = setcellstruct(THERING, 'K', idx, K + dK(i));
    THERING = setcellstruct(THERING, 'PolynomB', idx, K + dK(i), 1, 2);  
end




function M = calc_M(p)

global THERING
TR0 = THERING;

step_K = 0.001;
for i=1:length(p.quads_idx)
    
    idx = p.quads_idx{i};
    
    THERING = TR0;
    K = getcellstruct(THERING, 'K', idx);
    THERING = setcellstruct(THERING, 'K', idx, K + step_K/2);
    THERING = setcellstruct(THERING, 'PolynomB', idx, K + step_K/2, 1, 2);
    residue_p = calc_residue(p);
    
    THERING = TR0;
    K = getcellstruct(THERING, 'K', idx);
    THERING = setcellstruct(THERING, 'K', idx, K - step_K/2);
    THERING = setcellstruct(THERING, 'PolynomB', idx, K - step_K/2, 1, 2);
    residue_n = calc_residue(p);
    
    M(:,i) = (residue_p - residue_n) / step_K;
    
end

THERING = TR0;


function residue = calc_residue(p)



r = calctwiss;

residue = [];
% tunes
dr = [r.mux(end)/2/pi - p.tunex; r.muy(end)/2/pi - p.tuney]; residue = [residue; dr(:)];
% betax
for i=1:length(p.quads_idx)
    idx = max(p.quads_idx{i});
    residue = [residue; r.betax(idx) - p.betax(i)];
end
% betay
for i=1:length(p.quads_idx)
    idx = max(p.quads_idx{i});
    residue = [residue; r.betay(idx) - p.betay(i)];
end
% etax
dr = r.etax(p.bpms_idx) - p.etax; residue = [residue; dr(:)];
% etay
dr = r.etay(p.bpms_idx) - p.etay; residue = [residue; dr(:)];


function [betax betay etax etay] = load_optics_measurements(fname_beta, fname_eta)


% loads betax and betay from data (quads in data should be ordered as the model)
if ~exist('fname_beta','var')
    [FileName, PathName, ~] = uigetfile('*.mat','Selects file with beta measurements','');
    if isnumeric(FileName), return; end;
    fname_beta = fullfile(PathName,FileName);
end
load(fname_beta); disp(fname_beta);
for i=1:length(Data)
    betax(i,1) = Data(i).beta(1);
    betay(i,1) = Data(i).beta(2);
end

% loads etax and etay from data (quads in data should be ordered as the model)
% loads betax and betay from data (quads in data should be ordered as the model)
if ~exist('fname_eta','var')
    [FileName, PathName, ~] = uigetfile('*.mat','Selects file with beta measurements',fname_beta);
    if isnumeric(FileName), return; end;
    fname_eta = fullfile(PathName,FileName);
end
load(fname_eta); disp(fname_eta);
etax = BPMxDisp.Data;
etay = BPMyDisp.Data;

    











