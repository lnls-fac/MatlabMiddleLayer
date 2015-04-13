function r = sirius_symmetrize_simulation_optics(varargin)
%function r = sirius_symmetrize_simulation_optics(varargin)
%
% Ajuste de sintonia com simetrização do modelo AT.
%
% Exemplo
%
% r = sirius_symmetrize_simulation_optics([5.27 4.17], 'QuadElements', 'AllSymmetries');
%
% História
%
% 2011-08-03: Versão inicial (X.R.R.)


global THERING;

tunes = NaN;

% Look for flags
for i = length(varargin):-1:1
    if ischar(varargin{i})
        if any(strcmpi(varargin{i}, {'LowEmittance'}))
            knob_type = 'LowEmittanceTunes';
            constraints_function = @calc_constraints_LowEmittanceTunes;
        else
            error('Invalid string.');
        end
        
        
    elseif isnumeric(varargin{i}) && (length(varargin{i}) == 2)
        tunes = varargin{i};
    end
end

% cria lista de indices a elementos do modelo AT
IND.QLF  = findcells(THERING, 'FamName', 'QLF');
IND.QLD1 = findcells(THERING, 'FamName', 'QLD1');
IND.QLD2 = findcells(THERING, 'FamName', 'QLD2');
IND.QMF  = findcells(THERING, 'FamName', 'QMF');
IND.QMD1 = findcells(THERING, 'FamName', 'QMD1');
IND.QMD2 = findcells(THERING, 'FamName', 'QMD2');
IND.QSF  = findcells(THERING, 'FamName', 'QSF');
IND.QSD1 = findcells(THERING, 'FamName', 'QSD1');
IND.QSD2 = findcells(THERING, 'FamName', 'QSD2');
IND.QCF1 = findcells(THERING, 'FamName', 'QCF1');
IND.QCF2 = findcells(THERING, 'FamName', 'QCF2');
IND.QCFA1 = findcells(THERING, 'FamName', 'QCFA1');
IND.QCFA2 = findcells(THERING, 'FamName', 'QCFA2');
IND.QCFA3 = findcells(THERING, 'FamName', 'QCFA3');
IND.QCFA4 = findcells(THERING, 'FamName', 'QCFA4');
IND.QSDA1 = findcells(THERING, 'FamName', 'QSDA1');
IND.QSDA2 = findcells(THERING, 'FamName', 'QSDA2');
IND.QSFA = findcells(THERING, 'FamName', 'QSFA');
IND.QSD2 = findcells(THERING, 'FamName', 'QSD2');
IND.QSDB1 = findcells(THERING, 'FamName', 'QSDB1');
IND.QSFB = findcells(THERING, 'FamName', 'QSFB');
IND.QSDB2 = findcells(THERING, 'FamName', 'QSDB2');


% define quais parâmetros serão variados
if strcmpi(knob_type, 'LowEmittanceTunes')
    KNOBS = { ...
        IND.QLF; ...
        IND.QLD1; ...
        IND.QLD2; ...
        IND.QMF; ...
        IND.QMD1; ...
        IND.QMD2; ...
        [IND.QSF IND.QSFA IND.QSFB]; ...
        [IND.QSD1 IND.QSDA1 IND.QSDB1]; ...
        [IND.QSD2 IND.QSDA2 IND.QSDB2]; ...
        [IND.QCF1 IND.QCFA1 IND.QCFA4]; ...
        [IND.QCF2 IND.QCFA2 IND.QCFA3]; ...
        };
else
end


TR0 = THERING;

% calcula vetor residuo inicial
calctwiss;
if isnan(tunes), tunes = THERING{end}.Twiss.mu/(2*pi); end
v0 = constraints_function();
residue = ([tunes(:)' zeros(1,length(v0)-2)]' - v0);


% calcula matriz de variação do residuo
for i=1:length(KNOBS)
    dK = 0.001;
    THERING = TR0;
    K = getcellstruct(THERING, 'K', KNOBS{i});
    THERING = setcellstruct(THERING, 'K', KNOBS{i}, K + dK);
    THERING = setcellstruct(THERING, 'PolynomB', KNOBS{i}, K + dK, 1, 2);
    c = constraints_function();
    mm(:,i) = (c - v0)/dK;
end

% calcula pseudo inversa da matriz de variação do resíduo
[U,S,V] = svd(mm,'econ');

%sv = diag(S);
%sel = (sv ./ sv(1)) <= 0.01;
inv_S = inv(S);
%inv_S(sel) = 0;

pseudoinv_mm = (V*inv_S*U');
% calcula solução
deltaK = pseudoinv_mm * residue;


% ajusta modelo AT com nova sintonia
THERING = TR0;
for i=1:length(KNOBS)
    K = getcellstruct(THERING, 'K', KNOBS{i});
    THERING = setcellstruct(THERING, 'K', KNOBS{i}, K + deltaK(i));
    THERING = setcellstruct(THERING, 'PolynomB', KNOBS{i}, K + deltaK(i), 1, 2);
end

v0 = constraints_function();
residue2 = ([tunes(:)' zeros(1,length(v0)-2)]' - v0);

% retorna parâmetros
r.Indices = IND;
r.Knobs = KNOBS;
r.Residue1 = residue;
r.Residue2 = residue2;
r.DeltaK = deltaK;
r.TuneCorrMatrix = pseudoinv_mm(:,1:2);


