function optimize_sirius_emittance_new

clear global FAMLIST;
clc;
RandStream.setDefaultStream(RandStream('mt19937ar','seed', 131071));

try 
    rmappdata(0, 'opt');
catch
end;
opt = getappdata(0, 'opt');
if isempty(opt)
    if exist('OPT.mat','file')
        load('OPT.mat');
    else 
        %opt.the_ring     = define_max_iv;
        %opt.the_ring     = define_mba5;
        %opt.the_ring     = define_5ba_e0p35;
        %opt.the_ring       = define_5ba_e0p4; opt.knobs_function = @knobs_5ba_1; 
        opt.the_ring       = define_5ba_0263_sx4; opt.knobs_function = @knobs_5ba_0263_sx4; 
    end
end

% parâmetro de controle da otimização
opt.stepsize_len = 0.01 * 1;
opt.stepsize_fld = 0.01 * 1;
opt.stepsize_grd = 0.01 * 1;
opt.stepsize_sxt = 0.01 * 1;
opt.energy       = 3;
opt.nr_cells     = 20;
opt.length_id_ss = 6.0; 
opt.max_field    = 0.7;
opt.max_bendg    = 10.0;
opt.max_bends    = 5.0;
opt.max_quadg    = 32.0;
opt.max_quads    = 50.0;
opt.max_sexts    = 2000;
opt.coupling     = 0.1 / 100;


% componentes do chi2
opt.chi2.goal_values.naturalEmittance.wgh = 3;
opt.chi2.goal_values.circunference.wgh    = 3;
opt.chi2.goal_values.max_betax.wgh        = 1;
opt.chi2.goal_values.max_betay.wgh        = 1;
opt.chi2.goal_values.etax.wgh             = 1;
opt.chi2.goal_values.betax.wgh            = 1;
opt.chi2.goal_values.betay.wgh            = 1;
opt.chi2.goal_values.chromx.wgh           = 1;
opt.chi2.goal_values.chromy.wgh           = 1;
opt.chi2.goal_values.axx.wgh              = 0;
opt.chi2.goal_values.axy.wgh              = 0;
opt.chi2.goal_values.ayy.wgh              = 0;
opt.chi2.goal_values.S_rms.wgh            = 1;

opt.chi2.goal_values.naturalEmittance.min = 0;
opt.chi2.goal_values.naturalEmittance.max = 0;
opt.chi2.goal_values.naturalEmittance.scl = 0.5e-9;
opt.chi2.goal_values.circunference.min = 0;
opt.chi2.goal_values.circunference.max = 580;
opt.chi2.goal_values.circunference.scl = 10;
opt.chi2.goal_values.max_betax.min = 0;
opt.chi2.goal_values.max_betax.max = 35;
opt.chi2.goal_values.max_betax.scl = 3;
opt.chi2.goal_values.max_betay.min = 0;
opt.chi2.goal_values.max_betay.max = 35;
opt.chi2.goal_values.max_betay.scl = 3;
opt.chi2.goal_values.etax.min = 0;
opt.chi2.goal_values.etax.max = 0;
opt.chi2.goal_values.etax.scl = 0.001;
opt.chi2.goal_values.betax.min = 12;
opt.chi2.goal_values.betax.max = 12;
opt.chi2.goal_values.betax.scl = 1.0;
opt.chi2.goal_values.betay.min = 0;
opt.chi2.goal_values.betay.max = 2;
opt.chi2.goal_values.betay.scl = 0.2;
opt.chi2.goal_values.chromx.min = 0;
opt.chi2.goal_values.chromx.max = 0;
opt.chi2.goal_values.chromx.scl = 1;
opt.chi2.goal_values.chromy.min = 0;
opt.chi2.goal_values.chromy.max = 0;
opt.chi2.goal_values.chromy.scl = 1;
opt.chi2.goal_values.axx.min = 0;
opt.chi2.goal_values.axx.max = 0;
opt.chi2.goal_values.axx.scl = 10;
opt.chi2.goal_values.axy.min = 0;
opt.chi2.goal_values.axy.max = 0;
opt.chi2.goal_values.axy.scl = 10;
opt.chi2.goal_values.ayy.min = 0;
opt.chi2.goal_values.ayy.max = 0;
opt.chi2.goal_values.ayy.scl = 10;
opt.chi2.goal_values.S_rms.min = 0;
opt.chi2.goal_values.S_rms.max = 30;
opt.chi2.goal_values.S_rms.scl = 5;

% procedimentos iniciais
%opt = simplify_lattice(opt); % agrupo drifts
opt = initialization(opt);
opt = identity_elements(opt);
opt = calc_optics(opt);
opt = close_ring(opt);
opt = calc_chi2(opt);

opt.the_ring_original = opt.the_ring;
optimize_sirius_plot_solution(opt);

% rotina principal de otimização
iter = 0;
print_summary_line(opt,iter);
while true
    opt0 = opt;
    opt = vary_parameter(opt);
    iter = iter + 1;
    if (opt.chi2.value > opt0.chi2.value)
        opt = opt0;
    else
        print_summary_line(opt,iter);
        setappdata(0, 'opt', opt);
    end  
end

function print_summary_line(opt,iter)

str = [ ...
    num2str(iter, '%05i') ...
    '   ' ...
    num2str(opt.chi2.this_values.naturalEmittance / 1e-9, 'emit:%f') ...
    num2str(opt.chi2.this_values.circunference, ', circ:%f') ...
    num2str([opt.chi2.this_values.max_betax opt.chi2.this_values.max_betay], ', max_beta:%f,%f') ...
    num2str([opt.chi2.this_values.chromx opt.chi2.this_values.chromy], ', chroms:%+f,%+f') ...
    num2str(1000*opt.chi2.this_values.etax, ', etaxs:%+f') ...
    num2str(opt.chi2.value, ', chi2:%E') ...
    ];   

%     num2str([opt.chi2.this_values.axx opt.chi2.this_values.ayy opt.chi2.this_values.axy], ', dtunes:%+E,%+E,%+E') ...

fprintf([str '\n']);
    


function opt = vary_parameter(opt0)

opt  = opt0;
p_len = opt.stepsize_len;
p_fld = opt.stepsize_fld;
p_grd = opt.stepsize_grd;
p_sxt = opt.stepsize_sxt;

opt.knobs.len_idx = find(opt.knobs.len_flg);
opt.knobs.fld_idx = find(opt.knobs.fld_flg);
opt.knobs.grd_idx = find(opt.knobs.grd_flg);
opt.knobs.sxt_idx = find(opt.knobs.sxt_flg);

while true
    
    the_ring = opt.the_ring;
    
    while true
        type = randi(4,1,1);
        switch type
            case 1
                if ~isempty(opt.knobs.len_idx)
                    elem = opt.knobs.len_idx(randi(length(opt.knobs.len_idx),1,1));
                    step = 2*(rand - 0.5) * (p_len) * opt.the_ring{elem}.Length;
                    oval = opt.the_ring{elem}.Length;
                    nval = oval + step;
                    allsame = opt.fam_constraints.len(opt.fam_constraints.len == opt.fam_constraints.len(elem));
                    ovals = getcellstruct(opt.the_ring, 'Length', allsame)';
                    nvals = ovals + step;
                    if any(nvals > opt.knobs.len_max(allsame)) || any(nvals < opt.knobs.len_min(allsame)), continue; end;
                    opt.the_ring = setcellstruct(opt.the_ring, 'Length', allsame, nvals);
                    
%                     if ~isempty(opt.knobs.len_max(elem)) && (nval > opt.knobs.len_max(elem)), continue; end;
%                     if ~isempty(opt.knobs.len_min(elem)) && (nval < opt.knobs.len_min(elem)), continue; end;
%                     opt.the_ring{elem}.Length = nval;
                    
                    
                    
                    
                    
%                     % family constraints
%                     if isfield(opt.fam_constraints, 'len')
%                         for m=1:length(opt.fam_constraints.len)
%                             idx = opt.fam_constraints.len{m};
%                             opt.the_ring = setcellstruct(opt.the_ring, 'Length', idx, nval);
%                         end
%                     end
                    
                    % para garantir campo constante
                    if isfield(opt.the_ring{elem}, 'BendingAngle')
                        oa = opt.the_ring{elem}.BendingAngle;
                        na = (nval/oval) * oa;
                        opt.the_ring{elem}.BendingAngle = na;
                        opt.the_ring{elem}.EntranceAngle = opt.the_ring{elem}.EntranceAngle * (na/oa);
                        opt.the_ring{elem}.ExitAngle = opt.the_ring{elem}.ExitAngle * (na/oa);
                    end
                    
                    
                    break;
                end
            case 2
                if ~isempty(opt.knobs.fld_idx)
                    elem = opt.knobs.fld_idx(randi(length(opt.knobs.fld_idx),1,1));
                    oa = opt.the_ring{elem}.BendingAngle; %%%% adicional
                    step = 2*(rand - 0.5) * (p_fld) * opt.max_field;
                    oval = opt.b_rho * opt.the_ring{elem}.BendingAngle / opt.the_ring{elem}.Length;
                    nval = oval + step;
                    if ~isempty(opt.knobs.fld_max(elem)) && (nval > opt.knobs.fld_max(elem)), continue; end;
                    if ~isempty(opt.knobs.fld_min(elem)) && (nval < opt.knobs.fld_min(elem)), continue; end;
                    ang = sqrt(nval * opt.the_ring{elem}.Length / opt.b_rho); % entender melhor...
                    opt.the_ring{elem}.BendingAngle = ang;
                    opt.the_ring{elem}.EntranceAngle = opt.the_ring{elem}.EntranceAngle * (nval/oval);
                    opt.the_ring{elem}.ExitAngle = opt.the_ring{elem}.ExitAngle * (nval/oval);
                    if isfield(opt.the_ring{elem}, 'BendingAngle') %%%% resolver
                        na = ang;
                        opt.the_ring{elem}.Length = (na/oa) * opt.the_ring{elem}.Length;
                    end
                    break;
                end
            case 3
                if ~isempty(opt.knobs.grd_idx)
                    elem = opt.knobs.grd_idx(randi(length(opt.knobs.grd_idx),1,1));
                    step = 2*(rand - 0.5) * (p_sxt) * opt.max_quadg;
                    oval = opt.b_rho * opt.the_ring{elem}.K;
                    nval = oval + step;
                    if ~isempty(opt.knobs.grd_max(elem)) && (nval > opt.knobs.grd_max(elem)), continue; end;
                    if ~isempty(opt.knobs.grd_min(elem)) && (nval < opt.knobs.grd_min(elem)), continue; end;
                    K = nval / opt.b_rho;
                    opt.the_ring{elem}.K = K;
                    opt.the_ring{elem}.PolynomB(1,2) = K;
%                     if isfield(opt.fam_constraints, 'grd')
%                         for m=1:length(opt.fam_constraints.grd)
%                             idx = opt.fam_constraints.grd{m};
%                             opt.the_ring = setcellstruct(opt.the_ring, 'K', idx, K);
%                             opt.the_ring = setcellstruct(opt.the_ring, 'PolynomB', idx, K, 1, 2);
%                         end
%                     end
                    break;
                end
            case 4
                if ~isempty(opt.knobs.sxt_idx)
                    elem = opt.knobs.sxt_idx(randi(length(opt.knobs.sxt_idx),1,1));
                    step = 2*(rand - 0.5) * (p_grd) * (opt.knobs.sxt_max(elem) - opt.knobs.sxt_min(elem));
                    oval = opt.b_rho * opt.the_ring{elem}.PolynomB(3);
                    nval = oval + step;
                    if ~isempty(opt.knobs.sxt_max(elem)) && (nval > opt.knobs.sxt_max(elem)), continue; end;
                    if ~isempty(opt.knobs.sxt_min(elem)) && (nval < opt.knobs.sxt_min(elem)), continue; end;
                    S = nval / opt.b_rho;
                    opt.the_ring{elem}.PolynomB(1,3) = S;
                    break;
                end
        end
    end
    
    % propaga mudanças para elementos idênticos
    if isfield(opt, 'identical_elements')
        for i=1:length(opt.identical_elements)
            elems = opt.identical_elements{i};
            if any(elem == elems)
                for j=1:length(elems)
                    opt.the_ring{elems(j)} = opt.the_ring{elem};
                end
                break;
            end
        end
    end
    
    opt = close_ring(opt);
    opt = calc_optics(opt);
    if isfield(opt.optics, 'betax') && (opt.chi2.this_values.naturalEmittance >= 0) && all(opt.chi2.this_values.radiationDamping >= 0)
        opt = calc_chi2(opt);
        break;
    else
        opt.the_ring = the_ring;
    end
    
end

function opt = calc_chi2(opt0)

opt = opt0;

fnames = fieldnames(opt.chi2.goal_values);
weights  = zeros(size(fnames));
chi2     = zeros(size(fnames));
for i=1:length(fnames)
    pg = opt.chi2.goal_values.(fnames{i});
    pt = opt.chi2.this_values.(fnames{i});
    weights(i) = (10^pg.wgh - 1);
    if (pt > pg.max) || (pt < pg.min)
        chi2(i) = ((pt - pg.max) / pg.scl)^2;
    end
end
opt.chi2.value = sqrt(sum(weights .* chi2) / sum(weights));




function opt = close_ring(opt0)

opt = opt0;

% renormaliza angulos de modo a fechar anel.
bends = findcells(opt.the_ring, 'BendingAngle');
len = getcellstruct(opt.the_ring, 'Length', 1:length(opt.the_ring));
fixed = find(~opt.knobs.len_flg); fixed = intersect(fixed, bends);
trial = find(opt.knobs.len_flg); trial = intersect(trial, bends);
if ~isempty(trial)
    if ~isempty(fixed), ang_fixed = getcellstruct(opt.the_ring, 'BendingAngle', fixed); else ang_fixed = []; end;
    ang_trial = getcellstruct(opt.the_ring, 'BendingAngle', trial); 
    len_trial = getcellstruct(opt.the_ring, 'Length', trial);
    rho_trial = len_trial ./ ang_trial;
    fld_trial = opt.b_rho ./ rho_trial;
    sel = find(abs(fld_trial) > opt.max_field);
    fld_trial(sel) = fld_trial(sel) .* (opt.max_field ./ fld_trial(sel));
    rho_trial = opt.b_rho ./ fld_trial;
    new_ang_trial = len_trial ./ rho_trial;
    new_ang_trial = new_ang_trial * ((2*pi/opt.nr_cells - sum(ang_fixed))/sum(new_ang_trial));
    opt.the_ring = setcellstruct(opt.the_ring, 'BendingAngle', trial, new_ang_trial);
    a = getcellstruct(opt.the_ring, 'EntranceAngle', trial);
    new_a = a .* (new_ang_trial ./ ang_trial); sel = (ang_trial == 0); new_a(sel) = 0;
    opt.the_ring = setcellstruct(opt.the_ring, 'EntranceAngle', trial, new_a);
    a = getcellstruct(opt.the_ring, 'ExitAngle', trial);
    new_a = a .* (new_ang_trial ./ ang_trial); sel = (ang_trial == 0); new_a(sel) = 0;
    opt.the_ring = setcellstruct(opt.the_ring, 'ExitAngle', trial, new_a);
end




opt.chi2.this_values.circunference = opt.nr_cells * sum(len);

function opt = initialization(opt0)

opt = opt0;
[opt.beta opt.gamma opt.b_rho] = lnls_beta_gamma(opt.energy);
opt = trim_driftspaces(opt);

opt = opt.knobs_function(opt);

opt.knobs.len_flg([1, end-2, end]) = false;
opt.knobs.fld_flg([1, end-2, end]) = false;
opt.knobs.grd_flg([1, end-2, end]) = false;
opt.knobs.sxt_flg([1, end-2, end]) = false;


function opt = knobs_5ba_1(opt0)

opt = opt0;

alles = 1:length(opt.the_ring);
bends = findcells(opt.the_ring, 'BendingAngle');
quads = findcells(opt.the_ring, 'K'); quads = setdiff(quads, bends);
mrkrs = findcells(opt.the_ring, 'PassMethod', 'IdentityPass');
dspcs = findcells(opt.the_ring, 'PassMethod', 'DriftPass');
sexts = setdiff(alles, [bends quads mrkrs dspcs]);

opt.knobs.len_flg(bends) = false;
opt.knobs.fld_flg(bends) = false;
opt.knobs.grd_flg(bends) = true;
opt.knobs.sxt_flg(bends) = false;
opt.knobs.len_max(bends) = NaN;
opt.knobs.len_min(bends) = NaN;
opt.knobs.fld_max(bends) =  opt.max_field;
opt.knobs.fld_min(bends) = -opt.max_field;
opt.knobs.grd_max(bends) =  opt.max_bendg;
opt.knobs.grd_min(bends) = -opt.max_bendg;
opt.knobs.sxt_max(bends) =  opt.max_bends;
opt.knobs.sxt_min(bends) = -opt.max_bends;

opt.knobs.len_flg(quads) = true;
opt.knobs.fld_flg(quads) = false;
opt.knobs.grd_flg(quads) = true;
opt.knobs.sxt_flg(quads) = false;
opt.knobs.len_max(quads) = NaN;
opt.knobs.len_min(quads) = NaN;
opt.knobs.grd_max(quads) =  opt.max_quadg;
opt.knobs.grd_min(quads) = -opt.max_quadg;
opt.knobs.sxt_max(quads) =  opt.max_quads;
opt.knobs.sxt_min(quads) = -opt.max_quads;

opt.knobs.len_flg(sexts) = true;
opt.knobs.fld_flg(sexts) = false;
opt.knobs.grd_flg(sexts) = false;
opt.knobs.sxt_flg(sexts) = false;
opt.knobs.len_max(sexts) = NaN;
opt.knobs.len_min(sexts) = NaN;
opt.knobs.sxt_max(sexts) =  opt.max_sexts;
opt.knobs.sxt_min(sexts) = -opt.max_sexts;

% campo dos BC não alterados
bc = findcells(opt.the_ring, 'FamName', 'bc');
opt.knobs.len_flg(bc) = false;
opt.knobs.fld_flg(bc) = false;
opt.knobs.grd_flg(bc) = false;
opt.knobs.sxt_flg(bc) = false;

% distância mínima entre elementos (para inserção de sextupolos)
tr = [];
tr = [tr, findcells(opt.the_ring, 'FamName', 'l1')];
tr = [tr, findcells(opt.the_ring, 'FamName', 'l2')];
tr = [tr, findcells(opt.the_ring, 'FamName', 'l3')];
tr = [tr, findcells(opt.the_ring, 'FamName', 'lc1')];
tr = [tr, findcells(opt.the_ring, 'FamName', 'lc2')];
tr = [tr, findcells(opt.the_ring, 'FamName', 'lc3')];
tr = [tr, findcells(opt.the_ring, 'FamName', 'lc4')];
opt.knobs.len_min(tr) = 0.47;



opt.fam_constraints.len = {};
opt.fam_constraints.grd = {};

% mesmo gradiente de dipolos
b1 = findcells(opt.the_ring, 'FamName', 'b1');
b2 = findcells(opt.the_ring, 'FamName', 'b2');
b3 = findcells(opt.the_ring, 'FamName', 'b3');
opt.fam_constraints.grd{end+1} = [b1 b2 b3];

% mesmo comprimento dos quads na familias;
qid1 = findcells(opt.the_ring, 'FamName', 'qid1');
qid2 = findcells(opt.the_ring, 'FamName', 'qid2');
opt.fam_constraints.len{end+1} = [qid1 qid2];
qif  = findcells(opt.the_ring, 'FamName', 'qif');
opt.fam_constraints.len{end+1} = qif;
qf1 = findcells(opt.the_ring, 'FamName', 'qf1');
qf2 = findcells(opt.the_ring, 'FamName', 'qf2');
qf3 = findcells(opt.the_ring, 'FamName', 'qf3');
qf4 = findcells(opt.the_ring, 'FamName', 'qf4');
opt.fam_constraints.len{end+1} = [qf1 qf2 qf3 qf4];

function opt = knobs_5ba_0263_sx4(opt0)

opt = opt0;

alles = 1:length(opt.the_ring);
bends = findcells(opt.the_ring, 'BendingAngle');
quads = findcells(opt.the_ring, 'K'); quads = setdiff(quads, bends);
mrkrs = findcells(opt.the_ring, 'PassMethod', 'IdentityPass');
dspcs = findcells(opt.the_ring, 'PassMethod', 'DriftPass');
sexts = setdiff(alles, [bends quads mrkrs dspcs]);

% zera sextupolos
opt.the_ring = setcellstruct(opt.the_ring, 'PolynomB', sexts, 0, 1, 3);

opt.knobs.len_flg(bends) = true;
opt.knobs.fld_flg(bends) = true;
opt.knobs.grd_flg(bends) = true;
opt.knobs.sxt_flg(bends) = false;
opt.knobs.len_max(bends) = NaN;
opt.knobs.len_min(bends) = NaN;
opt.knobs.fld_max(bends) =  opt.max_field;
opt.knobs.fld_min(bends) = -opt.max_field;
opt.knobs.grd_max(bends) =  opt.max_bendg;
opt.knobs.grd_min(bends) = -opt.max_bendg;
opt.knobs.sxt_max(bends) =  opt.max_bends;
opt.knobs.sxt_min(bends) = -opt.max_bends;

opt.knobs.len_flg(quads) = true;
opt.knobs.fld_flg(quads) = false;
opt.knobs.grd_flg(quads) = true;
opt.knobs.sxt_flg(quads) = false;
opt.knobs.len_max(quads) = NaN;
opt.knobs.len_min(quads) = NaN;
opt.knobs.grd_max(quads) =  opt.max_quadg;
opt.knobs.grd_min(quads) = -opt.max_quadg;
opt.knobs.sxt_max(quads) =  opt.max_quads;
opt.knobs.sxt_min(quads) = -opt.max_quads;

opt.knobs.len_flg(sexts) = true;
opt.knobs.fld_flg(sexts) = false;
opt.knobs.grd_flg(sexts) = false;
opt.knobs.sxt_flg(sexts) = false;
opt.knobs.len_max(sexts) = NaN;
opt.knobs.len_min(sexts) = NaN;
opt.knobs.sxt_max(sexts) =  opt.max_sexts;
opt.knobs.sxt_min(sexts) = -opt.max_sexts;

% campo dos BC não alterados
bc = findcells(opt.the_ring, 'FamName', 'bc');
opt.knobs.len_flg(bc) = false;
opt.knobs.fld_flg(bc) = false;
opt.knobs.grd_flg(bc) = false;
opt.knobs.sxt_flg(bc) = false;


% elementos idênticos
id = calc_identity(opt.the_ring);
opt.fam_constraints.len = id;
opt.fam_constraints.fld = id;
opt.fam_constraints.grd = id;
opt.fam_constraints.sxt = id;


% vinculos adicionais

% mesmo gradiente de dipolos
b1 = findcells(opt.the_ring, 'FamName', 'b1');
b2 = findcells(opt.the_ring, 'FamName', 'b2');
b3 = findcells(opt.the_ring, 'FamName', 'b3');
opt.fam_constraints.grd([b1 b2 b3]) = opt.fam_constraints.grd(b1(1));

% mesmo comprimento dos quads nas familias;
qid1 = findcells(opt.the_ring, 'FamName', 'qid1');
qid2 = findcells(opt.the_ring, 'FamName', 'qid2');
opt.fam_constraints.len([qid1 qid2]) = opt.fam_constraints.len(qid1(1));

qf1 = findcells(opt.the_ring, 'FamName', 'qf1');
qf2 = findcells(opt.the_ring, 'FamName', 'qf2');
qf3 = findcells(opt.the_ring, 'FamName', 'qf3');
qf4 = findcells(opt.the_ring, 'FamName', 'qf4');
opt.fam_constraints.len([qf1 qf2 qf3 qf4]) = opt.fam_constraints.len(qf1(1));

function opt = trim_driftspaces(opt0)

opt = opt0;

% retira drifts da rede original e adicionar drifts de IDs com comprimentos de acordo com parâmetro de input.
i1=1; while any(strcmpi(opt.the_ring{i1}.PassMethod, {'DriftPass', 'IdentityPass'})), i1=i1+1; end;
i2=length(opt.the_ring); while any(strcmpi(opt.the_ring{i2}.PassMethod, {'DriftPass', 'IdentityPass'})), i2=i2-1; end;
ds = [drift('IDDS', opt.length_id_ss/2, 'DriftPass') marker('END', 'IdentityPass')];
dspace = buildlat(ds);
opt.the_ring = [dspace(1), opt.the_ring(i1:i2), dspace(1), dspace(2)];
opt.the_ring = setcellstruct(opt.the_ring, 'Energy', 1:length(opt.the_ring), 1e9*opt.energy);

% transforma driftspace em sextupolos nulas (para efeito de calculo de parametros da dinâmica não linear)
% for i=2:length(opt.the_ring)-2
%     if strcmpi(opt.the_ring{i}.PassMethod, 'DriftPass')
%         ds = sextupole(opt.the_ring{i}.FamName, opt.the_ring{i}.Length, 0, 'StrMPoleSymplectic4Pass');
%         dspace = buildlat(ds);
%         opt.the_ring{i} = dspace{1};
%     end
% end

return

function opt = calc_optics(opt0)

opt = opt0;

if isfield(opt, 'optics'), opt = rmfield(opt, 'optics'); end;
[M44, tmp] = findm44(opt.the_ring, 0, 1:length(opt.the_ring)+1,[0 0 0 0 0 0]');

opt.optics.M44 = M44;
opt.optics.tracex = M44(1,1) + M44(2,2);
opt.optics.tracey = M44(3,3) + M44(4,4);

if (opt.optics.tracex >= 2) || (opt.optics.tracey >= 2) || ...
        (opt.optics.tracex <= -2) || (opt.optics.tracey <= -2)
    return;
end

opt = calc_atsummary(opt);
opt = calc_sextupoles(opt);

function opt = calc_atsummary(opt0)

opt = opt0;

const = lnls_constants;
the_ring = opt.the_ring;

% Structure to store info
r.e0 = opt.energy;
r.circumference = opt.nr_cells * findspos(the_ring, length(the_ring)+1);
r.revTime = r.circumference / const.c;
r.revFreq = const.c / r.circumference;
r.gamma = opt.gamma;
r.beta = sqrt(1 - 1/r.gamma);
[TD, r.tunes, r.chromaticity] = twissring(the_ring, 0, 1:length(the_ring)+1, 'chrom', 1e-8);
r.twiss.beta        = cat(1,TD.beta);
r.twiss.mu          = cat(1,TD.mu);
r.twiss.alpha       = cat(1,TD.alpha);
r.twiss.ClosedOrbit = [TD.ClosedOrbit]';
r.twiss.Dispersion  = [TD.Dispersion]';
r.twiss.SPos        = cat(1,TD.SPos);

% For calculating the synchrotron integrals
temp  = cat(2,TD.Dispersion);
D_x   = temp(1,:)';
D_x_  = temp(2,:)';
beta  = cat(1, TD.beta);
alpha = cat(1, TD.alpha);
gamma = (1 + alpha.^2) ./ beta;
circ  = TD(length(the_ring)+1).SPos;

opt.optics.etax  = D_x;
opt.optics.betax = beta(:,1);
opt.optics.betay = beta(:,2);
opt.optics.mux = r.twiss.mu(:,1);
opt.optics.muy = r.twiss.mu(:,2);

opt.chi2.this_values.max_betax = max(opt.optics.betax);
opt.chi2.this_values.max_betay = max(opt.optics.betay);
opt.chi2.this_values.etax   = D_x(1);
opt.chi2.this_values.betax  = opt.optics.betax(1);
opt.chi2.this_values.betay  = opt.optics.betay(1);
opt.chi2.this_values.chromx = r.chromaticity(1);
opt.chi2.this_values.chromy = r.chromaticity(2);



% Synchrotron integral calculation
r.integrals = [0.0 0.0 0.0 0.0 0.0 0.0];

for i = 1:length(the_ring),
    if isfield(the_ring{i}, 'BendingAngle') && isfield(the_ring{i}, 'EntranceAngle')
        rho = the_ring{i}.Length/the_ring{i}.BendingAngle;
        dispersion = 0.5*(D_x(i)+D_x(i+1));
        r.integrals(1) = r.integrals(1) + dispersion*the_ring{i}.Length/rho;
        r.integrals(2) = r.integrals(2) + the_ring{i}.Length/(rho^2);
        r.integrals(3) = r.integrals(3) + the_ring{i}.Length/(rho^3);
        % For general wedge magnets
        r.integrals(4) = r.integrals(4) + ...
            D_x(i)*tan(the_ring{i}.EntranceAngle)/rho^2 + ...
            (1 + 2*rho^2*the_ring{i}.PolynomB(2))*(D_x(i)+D_x(i+1))*the_ring{i}.Length/(2*rho^3) + ...
            D_x(i+1)*tan(the_ring{i}.ExitAngle)/rho^2;
        %         r.integrals(4) = r.integrals(4) + 2*0.5*(D_x(i)+D_x(i+1))*the_ring{i}.Length/rho^3;
        H1 = beta(i,1)*D_x_(i)*D_x_(i)+2*alpha(i)*D_x(i)*D_x_(i)+gamma(i)*D_x(i)*D_x(i);
        H0 = beta(i+1,1)*D_x_(i+1)*D_x_(i+1)+2*alpha(i+1)*D_x(i+1)*D_x_(i+1)+gamma(i+1)*D_x(i+1)*D_x(i+1);
        r.integrals(5) = r.integrals(5) + the_ring{i}.Length*(H1+H0)*0.5/abs(rho^3);
        %         if H1+H0 < 0
        %             fprintf('%f %i %s\n', H1+H0, i, the_ring{i}.FamName)
        %         end
        r.integrals(6) = r.integrals(6) + the_ring{i}.PolynomB(2)^2*dispersion^2*the_ring{i}.Length;
    end
end

r.integrals(1) = opt.nr_cells * r.integrals(1);
r.integrals(2) = opt.nr_cells * r.integrals(2);
r.integrals(3) = opt.nr_cells * r.integrals(3);
r.integrals(4) = opt.nr_cells * r.integrals(4);
r.integrals(5) = opt.nr_cells * r.integrals(5);
r.integrals(6) = opt.nr_cells * r.integrals(6);

% Damping numbers
% Use Robinson's Theorem
r.damping(1) = 1 - r.integrals(4)/r.integrals(2);
r.damping(2) = 1;
r.damping(3) = 2 + r.integrals(4)/r.integrals(2);

r.radiation = 8.846e-5*r.e0.^4*r.integrals(2)/(2*pi);
r.naturalEnergySpread = sqrt(3.8319e-13*r.gamma.^2*r.integrals(3)/(2*r.integrals(2) + r.integrals(4)));
r.naturalEmittance = 3.8319e-13*(r.e0*1e3/const.E0).^2*r.integrals(5)/(r.damping(1)*r.integrals(2));

% Damping times
r.radiationDamping(1) = 1/(2113.1*r.e0.^3*r.integrals(2)*r.damping(1)/circ);
r.radiationDamping(2) = 1/(2113.1*r.e0.^3*r.integrals(2)*r.damping(2)/circ);
r.radiationDamping(3) = 1/(2113.1*r.e0.^3*r.integrals(2)*r.damping(3)/circ);

opt.chi2.this_values.naturalEmittance = r.naturalEmittance;
opt.chi2.this_values.naturalEnergySpread = r.naturalEnergySpread;
opt.chi2.this_values.radiationDamping = r.radiationDamping;

function opt = calc_sextupoles(opt0)

opt = opt0;

bends = findcells(opt.the_ring, 'BendingAngle');
quads = findcells(opt.the_ring, 'K'); quads = setdiff(quads, bends);
sexts = findcells(opt.the_ring, 'PolynomB'); sexts = setdiff(sexts, [bends quads]);
  
bx  = opt.optics.betax(sexts); bx = bx(:);
by  = opt.optics.betay(sexts); by = by(:);
ex  = opt.optics.etax(sexts);  ex = ex(:);
mux = opt.optics.mux(sexts); mux = mux(:);
muy = opt.optics.muy(sexts); muy = muy(:);
tunex = opt.optics.mux(end) / 2 / pi;
tuney = opt.optics.muy(end) / 2 / pi;
n     = length(sexts);

% cromaticidade

sd = findcells(opt.the_ring, 'FamName', 'sd');
sf = findcells(opt.the_ring, 'FamName', 'sf');
bx1  = opt.optics.betax([sd sf]); bx1 = bx1(:);
by1  = opt.optics.betay([sd sf]); by1 = by1(:);
ex1  = opt.optics.etax([sd sf]);  ex1 = ex1(:);
cx1 =   (bx1 .* ex1)' / 4 / pi;
cy1 = - (by1 .* ex1)' / 4 / pi;
bx2  = opt.optics.betax([sd+1 sf+1]); bx2 = bx2(:);
by2  = opt.optics.betay([sd+1 sf+1]); by2 = by2(:);
ex2  = opt.optics.etax([sd+1 sf+1]);  ex2 = ex2(:);
cx2 =   (bx2 .* ex2)' / 4 / pi;
cy2 = - (by2 .* ex2)' / 4 / pi;
cx  = 0.5*(cx1 + cx2);
cy  = 0.5*(cy1 + cy2);
M  = [cx; cy];
[U,S,V] = svd(M,'econ');
iS = pinv(S);
crom0 = [opt.chi2.this_values.chromx; opt.chi2.this_values.chromy];
dS = - (V*iS*U') * crom0;
opt.chi2.this_values.S_rms = sqrt(sum(dS.^2)/length(dS));

% tune shift dependente de amplitude
psix  = repmat(mux,1,n) - repmat(mux',n,1);
psiy  = repmat(muy,1,n) - repmat(muy',n,1);
BBxx  = repmat(bx.^(3/2),1,n) .* repmat((bx.^(3/2))',n,1);
BByy  = repmat(bx.^(1/2).*by,1,n) .* repmat((bx.^(1/2).*by)',n,1);
BB1xy = BByy;
BB2xy = repmat(bx.^(3/2),1,n) .* repmat((bx.^(1/2).*by)',n,1);

%%% S.Y.Lee
c1 = 3*(pi*tunex - abs(psix));
c2 = pi*tunex - abs(psix);
Mxx    = BBxx .* (cos(c1)/sin(3*pi*tunex) + 3 * cos(c2)/sin(pi*tunex)) / 64 / pi;
c1 = 2*(pi*tuney - abs(psiy)) + (pi*tunex - abs(psix));
c2 = 2*(pi*tuney - abs(psiy)) - (pi*tunex - abs(psix));
c3 = pi*tunex - abs(psix);
Myy    = BByy .* (cos(c1)/sin(pi*(2*tuney+tunex)) + cos(c2)/sin(pi*(2*tuney-tunex)) + 3 * cos(c3) / sin(pi*tunex)) / 64 / pi;
c1 = 2*(pi*tuney - abs(psiy)) + (pi*tunex - abs(psix));
c2 = 2*(pi*tuney - abs(psiy)) - (pi*tunex - abs(psix));
c3 = pi*tunex - abs(psix);
Mxy = (BB1xy .* (cos(c1)/sin(pi*(2*tuney+tunex)) + cos(c2)/sin(pi*(2*tuney-tunex))) - 2 * BB2xy .* cos(c3) / sin(pi*tunex)) / 32 / pi;



    
S   = getcellstruct(opt.the_ring, 'PolynomB', sexts, 1, 3); S = 2*S(:);
len = getcellstruct(opt.the_ring, 'Length', sexts);
%opt.chi2.this_values.S_rms = sqrt(sum((S .* len).^2) / length(sxt_idx));
opt.chi2.this_values.axx = S' * Mxx * S;
opt.chi2.this_values.axy = S' * Mxy * S;
opt.chi2.this_values.ayy = S' * Myy * S;


% nat_chrom = [opt.optics.chromx; opt.optics.chromy];
% % opt.IntS_rms = opt.nr_cells * max(abs(nat_chrom));
% % return;
% 
% bx = opt.optics.betax;
% by = opt.optics.betay;
% ex = opt.optics.etax;
% fx =   bx .* ex / 4 / pi;
% fy = - by .* ex / 4 / pi;
% 
% bends = findcells(opt.the_ring, 'BendingAngle');
% quads = findcells(opt.the_ring, 'K');
% quads = setdiff(quads, bends);
% 
% % sel = quads;
% % sel = [11    13    15    19    21    23    32  34    36    40    42    44];
% sel = 2:(length(opt.the_ring)-2);
% % sel = setdiff(sel,bends);
%  
% 
% M(1,:) = 0.5*(fx(sel) + fx(1+sel));
% M(2,:) = 0.5*(fy(sel) + fy(1+sel));
% [U,S,V] = svd(M,'econ');
% iS = pinv(S);
% IntS = - 0.5 * (V*iS*U') * nat_chrom;
% 
% S = IntS ./ getcellstruct(opt.the_ring, 'Length', sel);
% % opt.IntS_rms = max(abs(S));
% % opt.the_ring_chrom = opt.the_ring;
% % for i=1:length(sel)
% %     if strcmpi(opt.the_ring_chrom{sel(i)}.PassMethod, 'DriftSpace');
% %         opt.the_ring_chrom{sel(i)}.K = 0;
% %         opt.the_ring_chrom{sel(i)}.MaxOrder = 3;
% %         opt.the_ring_chrom{sel(i)}.NumIntSteps = 10;
% %         opt.the_ring_chrom{sel(i)}.PolynomA = zeros(1,4);
% %         opt.the_ring_chrom{sel(i)}.PolynomB = zeros(1,4);
% %         opt.the_ring_chrom{sel(i)}.R1 = zeros(6,6);
% %         opt.the_ring_chrom{sel(i)}.R2 = zeros(6,6);
% %         opt.the_ring_chrom{sel(i)}.T1 = zeros(1,6);
% %         opt.the_ring_chrom{sel(i)}.T2 = zeros(1,6);
% %         opt.the_ring_chrom{sel(i)}.PassMethod = 'StrMPoleSymplectic4Pass';
% %         opt.Energy = opt.energy * 1e9;
% %     end
% % end
% % opt.the_ring_chrom = setcellstruct(opt.the_ring_chrom, 'PolynomB', sel, S, 1, 3);
% 
% 
% %chrom = nat_chrom + M * IntS;
% 
% opt.IntS_rms = sqrt(sum(IntS.^2)/length(IntS));

return


function opt = identity_elements(opt0)

opt = opt0;

id = calc_identity(opt.the_ring);
uid = unique(id);
for i=1:length(uid)
    sel = (id == uid(i));
    opt.identical_elements{i} = find(sel);
end

function r = calc_identity(the_ring)

r = 1:length(the_ring);
for i=2:length(r)
    %disp(i);
    for j=1:i-1
        if are_the_same(the_ring{i}, the_ring{j})
            r(i) = r(j);
            break;
        end
    end
end
function r = are_the_same(e1, e2)

r = false;


if ~strcmpi(e1.FamName, e2.FamName), return; end;
if (e1.Length ~= e2.Length), return; end;
if ~strcmpi(e1.PassMethod, e2.PassMethod), return; end;

if isfield(e1, 'PolynomB')
    if isfield(e2, 'PolynomB')
        if any(e1.PolynomB ~= e2.PolynomB), return; end;
    else
        return;
    end
end

if isfield(e1, 'PolynomA')
    if isfield(e2, 'PolynomA')
        if any(e1.PolynomA ~= e2.PolynomA), return; end;
    else
        return;
    end
end

if isfield(e1, 'MaxOrder')
    if isfield(e2, 'MaxOrder')
        if any(e1.MaxOrder ~= e2.MaxOrder), return; end;
    else
        return;
    end
end

if isfield(e1, 'NumIntSteps')
    if isfield(e2, 'NumIntSteps')
        if any(e1.NumIntSteps ~= e2.NumIntSteps), return; end;
    else
        return;
    end
end

if isfield(e1, 'R1')
    if isfield(e2, 'R1')
        if any(e1.R1 ~= e2.R1), return; end;
    else
        return;
    end
end

if isfield(e1, 'R2')
    if isfield(e2, 'R2')
        if any(e1.R2 ~= e2.R2), return; end;
    else
        return;
    end
end


if isfield(e1, 'T1')
    if isfield(e2, 'T1')
        if any(e1.T1 ~= e2.T1), return; end;
    else
        return;
    end
end

if isfield(e1, 'T2')
    if isfield(e2, 'T2')
        if any(e1.T2 ~= e2.T2), return; end;
    else
        return;
    end
end


if isfield(e1, 'NumX')
    if isfield(e2, 'NumX')
        if any(e1.NumX ~= e2.NumX), return; end;
    else
        return;
    end
end

if isfield(e1, 'NumY')
    if isfield(e2, 'NumY')
        if any(e1.NumY ~= e2.NumY), return; end;
    else
        return;
    end
end

if isfield(e1, 'PxGrid')
    if isfield(e2, 'PxGrid')
        if any(e1.PxGrid ~= e2.PxGrid), return; end;
    else
        return;
    end
end

if isfield(e1, 'PyGrid')
    if isfield(e2, 'PyGrid')
        if any(e1.PyGrid ~= e2.PyGrid), return; end;
    else
        return;
    end
end

if isfield(e1, 'XGrid')
    if isfield(e2, 'XGrid')
        if any(e1.PxGrid ~= e2.PxGrid), return; end;
    else
        return;
    end
end

if isfield(e1, 'YGrid')
    if isfield(e2, 'YGrid')
        if any(e1.PyGrid ~= e2.PyGrid), return; end;
    else
        return;
    end
end


r = true;

