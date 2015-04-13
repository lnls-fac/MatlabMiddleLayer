function calc_beamsize_increase
% Cálculo do aumento do tamanho efetivo devido a vibrações dos elementos magnéticos.

global THERING;

u = lnls_mks;

r.coupling = 0.5 * u.percent;

% VIBRAÇOES INDEPENDENTES
r.fams.H_QF.std  = 0.120 * u.L.um * 0;
r.fams.H_QD.std  = 0.120 * u.L.um * 0;
r.fams.H_QCF.std = 0.120 * u.L.um * 0;
r.fams.H_BO.std  = 0.500 * u.L.um * 0;
r.fams.H_BI.std  = 0.500 * u.L.um * 0;
r.fams.H_BC.std  = 0.500 * u.L.um * 0;

r.fams.V_QF.std  = 0.015 * u.L.um * 0;
r.fams.V_QD.std  = 0.015 * u.L.um * 0;
r.fams.V_QCF.std = 0.015 * u.L.um * 0;
r.fams.V_BO.std  = 0.015 * u.L.um * 0;
r.fams.V_BI.std  = 0.015 * u.L.um * 0;
r.fams.V_BC.std  = 1.500 * u.L.um * 0;


% VIBRAÇÔES DE BERÇOS
MC = [];
MC = [MC findcells(THERING, 'FamName', 'ML')];
MC = [MC findcells(THERING, 'FamName', 'MM')];
MC = [MC findcells(THERING, 'FamName', 'MS')];
MC = sort(MC);
for i=1:length(MC)
    
    % HORIZONTAL
    girder = ['H_GIRDER' num2str(i, '%02i')];
    if i < length(MC)
        r.fams.(girder).fam = MC(i):MC(i+1);
    else
        r.fams.(girder).fam = MC(i):length(THERING);
    end
    r.fams.(girder).nsg = length(r.fams.(girder).fam);
    r.fams.(girder).avg = 0;
    r.fams.(girder).std = 1.500 * u.L.um * 1;
    r.fams.(girder).err = 'H';
    
    % VERTICAL
    girder = ['V_GIRDER' num2str(i, '%02i')];
    if i < length(MC)
        r.fams.(girder).fam = MC(i):MC(i+1);
    else
        r.fams.(girder).fam = MC(i):length(THERING);
    end
    r.fams.(girder).nsg = length(r.fams.(girder).fam);
    r.fams.(girder).avg = 0;
    r.fams.(girder).std = 0.035 * u.L.um * 1;
    r.fams.(girder).err = 'V';
end
    





r.fams.H_QF.fam = {'QLF', 'QMF', 'QSF','QSFA','QSFB'};
r.fams.H_QF.nsg = 1;
r.fams.H_QF.avg = 0;
r.fams.H_QF.err = 'H';

r.fams.H_QD.fam = {'QLD1', 'QLD2', 'QMD1', 'QMD2', 'QSD1', 'QSD2','QSDA1','QSDA2','QSDB1','QSDB2'};
r.fams.H_QD.nsg = 1;
r.fams.H_QD.avg = 0;
r.fams.H_QD.err = 'H';

r.fams.H_QCF.fam = {'QCF1', 'QCF2', 'QCFA1', 'QCFA2', 'QCFA3', 'QCFA4'};
r.fams.H_QCF.nsg = 1;
r.fams.H_QCF.avg = 0;
r.fams.H_QCF.err = 'H';

r.fams.H_BO.fam = {'BO'};
r.fams.H_BO.avg = 0;
r.fams.H_BO.nsg = 32;
r.fams.H_BO.err = 'H';

r.fams.H_BI.fam = {'BI'};
r.fams.H_BI.avg = 0;
r.fams.H_BI.nsg = 16;
r.fams.H_BI.err = 'H';

r.fams.H_BC.fam = {'BC'};
r.fams.H_BC.avg = 0;
r.fams.H_BC.nsg = 44;
r.fams.H_BC.err = 'H';

r.fams.V_QF.fam = {'QLF', 'QMF', 'QSF','QSFA','QSFB'};
r.fams.V_QF.nsg = 1;
r.fams.V_QF.avg = 0;
r.fams.V_QF.err = 'V';

r.fams.V_QD.fam = {'QLD1', 'QLD2', 'QMD1', 'QMD2', 'QSD1', 'QSD2','QSDA1','QSDA2','QSDB1','QSDB2'};
r.fams.V_QD.nsg = 1;
r.fams.V_QD.avg = 0;
r.fams.V_QD.err = 'V';

r.fams.V_QCF.fam = {'QCF1', 'QCF2', 'QCFA1', 'QCFA2', 'QCFA3', 'QCFA4'};
r.fams.V_QCF.nsg = 1;
r.fams.V_QCF.avg = 0;
r.fams.V_QCF.err = 'V';

r.fams.V_BO.fam = {'BO'};
r.fams.V_BO.avg = 0;
r.fams.V_BO.nsg = 32;
r.fams.V_BO.err = 'V';

r.fams.V_BI.fam = {'BI'};
r.fams.V_BI.avg = 0;
r.fams.V_BI.nsg = 16;
r.fams.V_BI.err = 'V';

r.fams.V_BC.fam = {'BC'};
r.fams.V_BC.avg = 0;
r.fams.V_BC.nsg = 44;
r.fams.V_BC.err = 'V';





r = calc_beamsizes_increase(r);




function r = calc_beamsizes_increase(r0)

global THERING;

if isempty(THERING)
    sirius;
end

r = r0;

% elimina familias com vibração nula
famnames = fieldnames(r.fams);
for i=1:length(famnames)
    data = r.fams.(famnames{i});
    if (data.avg ~= 0) || (data.std ~= 0)
        fams.(famnames{i}) = data;
    end
end
r.fams = fams;


% controi lista com famílias
famnames = fieldnames(r.fams);
for i=1:length(famnames)
    data = r.fams.(famnames{i});
    if isempty(data.fam)
        r.famnames{i} = {famnames{i}};
    else
        r.famnames{i} = data.fam;
    end
end


for i=1:length(famnames)
    fam  = famnames{i};
    fams = r.famnames{i};
    if iscell(fams)
        r.fams.(fam).idx = [];
        for j=1:length(fams)
            r.fams.(fam).idx = [r.fams.(fam).idx findcells(THERING, 'FamName', fams{j})];
        end
    else
        r.fams.(fam).idx = fams;
    end
    r.fams.(fam).idx = reshape(r.fams.(fam).idx, r.fams.(fam).nsg, [])';
end

THERING0 = THERING;
r.optics = calctwiss;
r.optics.atsummary = atsummary;
r.optics.beamsizex = sqrt(r.optics.betax * r.optics.atsummary.naturalEmittance + (r.optics.etax * r.optics.atsummary.naturalEnergySpread).^2)';
r.optics.beamsizey = sqrt(r.optics.betay * r.optics.atsummary.naturalEmittance * r.coupling + (r.optics.etay * r.optics.atsummary.naturalEnergySpread).^2)';

setcavity('off');
setradiation('off');
r.the_ring = THERING;
THERING = THERING0;

r = calc_respm(r);
r = calc_avg_cod(r);
r = calc_std_cod(r);

s = findspos(THERING, 1:length(THERING));
C = findspos(THERING, length(THERING)+1);
sel = s <= (C/4);



famnames = fieldnames(r.fams);
Tx = zeros(1,length(THERING));
Ty = zeros(1,length(THERING));
for i=1:length(famnames)
    fam = famnames{i};
    Tx = Tx + r.fams.(fam).codx_std.^2;
    Ty = Ty + r.fams.(fam).cody_std.^2;
end

size0 = r.optics.beamsizex;
%size1 = sqrt(size0.^2 + Tx);
%sizex = 100 * (size1 - size0) ./ size0;
size1 = sqrt(Tx);
sizex = 100 * (size1) ./ size0;


size0 = r.optics.beamsizey;
%size1 = sqrt(size0.^2 + Ty);
%sizey = 100 * (size1 - size0) ./ size0;
size1 = sqrt(Ty);
sizey = 100 * (size1) ./ size0;

Yx = [];
Yy = [];
hfnames = {};
vfnames = {};
for i=1:length(famnames)
    fam = famnames{i};
    fna = strrep(fam, '_', '-');
    v1 = ((r.fams.(fam).codx_std.^2) ./ Tx) .* sizex;
    if (max(v1) > 0.02)
        hfnames{end+1} = fna;
        Yx = [Yx; v1];
    end
    v1 = ((r.fams.(fam).cody_std.^2) ./ Ty) .* sizey;
    if (max(v1) > 0.02)
        vfnames{end+1} = fna;
        Yy = [Yy; v1];
    end
end

figure;
h = area(s(sel), Yx(:,sel)');
set(h, 'LineStyle', 'none');
legend(hfnames);
xlabel('Position [m]');
ylabel('BeamSize Increment [%]');
title('Horizontal BeamSize Perturbation Budget');
hold all;
drawlattice(-1,0.5,gca, C/4);
hold off;

figure;
h = area(s(sel), Yy(:,sel)');
set(h, 'LineStyle', 'none');
legend(vfnames);
xlabel('Position [m]');
ylabel('BeamSize Increment [%]');
title('Vertical BeamSize Perturbation Budget');
hold all;
drawlattice(-1,0.5,gca, C/4);
hold off;



function r = calc_avg_cod(r0)

r = r0;
famnames = fieldnames(r.fams);
for i=1:length(famnames)
    fam = famnames{i};
    avg = r.fams.(fam).avg;
    avM = diag(avg * ones(1,size(r.fams.(fam).Rx,1)));
    cod = avM * r.fams.(fam).Rx;
    r.fams.(fam).codx_avg = sum(cod,1);
    avM = diag(avg * ones(1,size(r.fams.(fam).Ry,1)));
    cod = avM * r.fams.(fam).Ry;
    r.fams.(fam).cody_avg = sum(cod,1);
end

function r = calc_std_cod(r0)

r = r0;
famnames = fieldnames(r.fams);
for i=1:length(famnames)
    fam = famnames{i};
    avg = r.fams.(fam).avg;
    std = r.fams.(fam).std;
    rma = (r.fams.(fam).Rx) .^ 2;
    r.fams.(fam).codx_std = sqrt(sum(rma,1) * (std^2 - avg^2) + r.fams.(fam).codx_avg.^2);
    rma = (r.fams.(fam).Ry) .^ 2;
    r.fams.(fam).cody_std = sqrt(sum(rma,1) * (std^2 - avg^2) + r.fams.(fam).cody_avg.^2);
end



function r = calc_respm(r0)

r = r0;

famnames = fieldnames(r.fams);
lnls_create_waitbar('Calc respm...', 0.1, length(famnames));
for i=1:length(famnames)
    fam = famnames{i};
    idx = r.fams.(fam).idx;
    std = r.fams.(fam).std;
    for j=1:size(idx,1)
        the_ring = r.the_ring;
        errors = std * ones(size(idx(j,:)));
        if (r.fams.(fam).err == 'H')
            the_ring = lattice_errors_set_misalignmentX(errors, idx(j,:), the_ring);
        end
        if (r.fams.(fam).err == 'V')
            the_ring = lattice_errors_set_misalignmentY(errors, idx(j,:), the_ring);
        end
        cod = findorbit4(the_ring, 0, 1:length(the_ring));
        r.fams.(fam).Rx(j,:) = cod(1,:) / std;
        r.fams.(fam).Ry(j,:) = cod(3,:) / std;
    end
    lnls_update_waitbar(i);
end
lnls_delete_waitbar;


function new_ring = lattice_errors_set_misalignmentX(errors, indices, old_ring)

new_ring = old_ring;

for i=1:size(indices,1)
    new_error = [-errors(i) 0 0 0 0 0];
    for j=1:size(indices,2)
        idx = indices(i,j);
        if (isfield(new_ring{idx},'T1') == 1); % checa se o campo T1 existe
            new_ring{idx}.T1 = new_ring{idx}.T1 + new_error;
            new_ring{idx}.T2 = new_ring{idx}.T2 - new_error;
        end
    end
end


function new_ring = lattice_errors_set_misalignmentY(errors, indices, old_ring)

new_ring = old_ring;

for i=1:size(indices,1)
    new_error = [0 0 -errors(i) 0 0 0];
    for j=1:size(indices,2)
        idx = indices(i,j);
        if (isfield(new_ring{idx},'T1') == 1); % checa se o campo T1 existe
            new_ring{idx}.T1 = new_ring{idx}.T1 + new_error;
            new_ring{idx}.T2 = new_ring{idx}.T2 - new_error;
        end
    end
end

function new_ring = lattice_errors_set_excitation(errors, indices, old_ring)

new_ring = old_ring;


for i=1:size(indices,1)
    for j=1:size(indices,2)
        idx = indices(i,j);
        if isfield(new_ring{idx}, 'BendingAngle')
            rho = new_ring{idx}.Length / new_ring{idx}.BendingAngle;
            erro_ori = new_ring{idx}.PolynomB(1);
            new_ring{idx}.PolynomB(1) = erro_ori + errors(i) / rho;    % Ler 'BndMPoleSymplectic4Pass.c'!
        else
            for k=1:length(new_ring{idx}.PolynomA)
                new_ring{idx}.PolynomA(k) = (1 + errors(i)) * new_ring{idx}.PolynomA(k);
            end
            for k=1:length(new_ring{idx}.PolynomB)
                new_ring{idx}.PolynomB(k) = (1 + errors(i)) * new_ring{idx}.PolynomB(k);
            end
        end
        if isfield(new_ring{idx}, 'K')
            new_ring{idx}.K = (1 + errors(i)) * new_ring{idx}.K;
        end
    end
end
