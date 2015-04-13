function r = lnls1_symmetrize_simulation_optics(varargin)
%function r = lnls1_symmetrize_simulation_optics(varargin)
%
% Ajuste de sintonia com simetrização do modelo AT.
%
% Exemplo
%
% r = lnls1_symmetrize_simulation_optics([5.27 4.17], 'QuadElements', 'AllSymmetries');
%
% História
%
% 2012-01-27: mudados modos de cálculo: SimpleTuneCorrectors. (XRR)
% 2011-05-02: modo 'SimpleTuneCorrectors' agora usa conjunto de constraints restrito às sintonias.
% 2011-04-27: adicionado modo 'SimpleTuneCorrectors' com QF e QD. Adicionada opção 'BEDI' para ajuste de etax do modo de baixa emitância
% 2011-04-04: Versão inicial (XRR)


global THERING;

tunes = NaN;
knob_type  = 'QuadElements';
constraints_function = @calc_constraints_AllSymmetries;
etax_lss     = 0;
eta_weight   = 20;
tunes_weight = 40;

% Look for flags
for i = length(varargin):-1:1
    if ischar(varargin{i})
        if any(strcmpi(varargin{i}, {'QuadFamilies','QuadFamily','Families','Family'}))
            knob_type = 'QuadFamilies';
        elseif any(strcmpi(varargin{i}, {'QuadFamiliesWithIDs'}))
            knob_type = 'QuadFamiliesWithIDs';
        elseif any(strcmpi(varargin{i}, {'QuadElements','QuadElement','Quad','Quads','Quadrupole','Quadrupoles'}))
            knob_type = 'QuadElements';
        elseif any(strcmpi(varargin{i}, {'TuneCorrectors','TuneCorrector'}))
            knob_type = 'TuneCorrectors';
        elseif any(strcmpi(varargin{i}, {'AWS07Quads','AWS07Quad'}))
            knob_type = 'AWS07Quads';
        elseif any(strcmpi(varargin{i}, {'SimpleTuneCorrectors','SimpleTuneCorrector'}))
            knob_type = 'SimpleTuneCorrectors';
        elseif any(strcmpi(varargin{i}, {'SimpleTuneEtaCorrectors','SimpleTuneEtaCorrector'}))
            knob_type = 'SimpleTuneEtaCorrectors';
        elseif any(strcmpi(varargin{i}, {'AllSymmetries','AllSymmetry'}))
            constraints_function = @calc_constraints_AllSymmetries;
        elseif any(strcmpi(varargin{i}, {'AllSymmetriesWithIDs'}))
            constraints_function = @calc_constraints_AllSymmetriesWithIDs;
        elseif any(strcmpi(varargin{i}, {'OnlyTunes','OnlyTune'}))
            constraints_function = @calc_constraints_OnlyTunes;
        elseif any(strcmpi(varargin{i}, {'SymmetryPoints','SymmetryPoint'}))
            constraints_function = @calc_constraints_SymmetryPoints;
        elseif any(strcmpi(varargin{i}, {'LSSSymmetries','LSSSymmetry'}))
            constraints_function = @calc_constraints_LSSSymmetries;
        elseif any(strcmpi(varargin{i}, {'BEDI'}))
            etax_lss = 0.579;
        elseif any(strcmpi(varargin{i}, {'BBY6T'}))
            etax_lss = 0;
        else
            error(['lnls1_symmetrize_simulation_optics: invalid string "' varargin{i} '"!']);
        end
        
        
    elseif isnumeric(varargin{i}) && (length(varargin{i}) == 2)
        tunes = varargin{i};
    end
end

% cria lista de indices a elementos do modelo AT
IND.A2QF01 = findcells(THERING, 'FamName', 'A2QF01');
IND.A2QF03 = findcells(THERING, 'FamName', 'A2QF03');
IND.A2QF05 = findcells(THERING, 'FamName', 'A2QF05');
IND.A2QF07 = findcells(THERING, 'FamName', 'A2QF07');
IND.A2QF09 = findcells(THERING, 'FamName', 'A2QF09');
IND.A2QF11 = findcells(THERING, 'FamName', 'A2QF11');
IND.A2QD01 = findcells(THERING, 'FamName', 'A2QD01');
IND.A2QD03 = findcells(THERING, 'FamName', 'A2QD03');
IND.A2QD05 = findcells(THERING, 'FamName', 'A2QD05');
IND.A2QD07 = findcells(THERING, 'FamName', 'A2QD07');
IND.A2QD09 = findcells(THERING, 'FamName', 'A2QD09');
IND.A2QD11 = findcells(THERING, 'FamName', 'A2QD11');
IND.A6QF01 = findcells(THERING, 'FamName', 'A6QF01');
IND.A6QF02 = findcells(THERING, 'FamName', 'A6QF02');

IND.AQF01A = IND.A2QF01(3:4);   IND.AQF01B = IND.A2QF01(1:2);
IND.AQD01A = IND.A2QD01(3:4);   IND.AQD01B = IND.A2QD01(1:2);
IND.AQF03A = IND.A2QF03(1:2);   IND.AQF03B = IND.A2QF03(3:4);
IND.AQD03A = IND.A2QD03(1:2);   IND.AQD03B = IND.A2QD03(3:4);
IND.AQF05A = IND.A2QF05(1:2);   IND.AQF05B = IND.A2QF05(3:4);
IND.AQD05A = IND.A2QD05(1:2);   IND.AQD05B = IND.A2QD05(3:4);
IND.AQF07A = IND.A2QF07(1:2);   IND.AQF07B = IND.A2QF07(3:4);
IND.AQD07A = IND.A2QD07(1:2);   IND.AQD07B = IND.A2QD07(3:4);
IND.AQF09A = IND.A2QF09(1:2);   IND.AQF09B = IND.A2QF09(3:4);
IND.AQD09A = IND.A2QD09(1:2);   IND.AQD09B = IND.A2QD09(3:4);
IND.AQF11A = IND.A2QF11(1:2);   IND.AQF11B = IND.A2QF11(3:4);
IND.AQD11A = IND.A2QD11(1:2);   IND.AQD11B = IND.A2QD11(3:4);
IND.AQF02A = IND.A6QF01(1:2);   IND.AQF02B = IND.A6QF02(1:2);
IND.AQF04A = IND.A6QF02(3:4);   IND.AQF04B = IND.A6QF01(3:4);
IND.AQF06A = IND.A6QF01(5:6);   IND.AQF06B = IND.A6QF02(5:6);
IND.AQF08A = IND.A6QF02(7:8);   IND.AQF08B = IND.A6QF01(7:8);
IND.AQF10A = IND.A6QF01(9:10);  IND.AQF10B = IND.A6QF02(9:10);
IND.AQF12A = IND.A6QF02(11:12); IND.AQF12B = IND.A6QF01(11:12);

IND.eta_weight   = eta_weight;
IND.tunes_weight = tunes_weight;

% define quais parâmetros serão variados
if strcmpi(knob_type, 'TuneCorrectors')
    QUADS = { ...
        [IND.AQF01A IND.AQF01B]; ...
        [IND.AQD01A IND.AQD01B]; ...
        [IND.AQF09A IND.AQF09B]; ...
        [IND.AQD09A IND.AQD09B]; ...
        [IND.AQF11A IND.AQF11B]; ...
        [IND.AQD11A IND.AQD11B]; ...
        [IND.AQF03A IND.AQF03B IND.AQF05A IND.AQF05B IND.AQF07A IND.AQF07B]; ...
        [IND.AQD03A IND.AQD03B IND.AQD05A IND.AQD05B IND.AQD07A IND.AQD07B]; ...
        };
elseif strcmpi(knob_type, 'SimpleTuneCorrectors')
    QUADS = { ...
        [IND.AQF01A IND.AQF01B IND.AQF09A IND.AQF09B IND.AQF11A IND.AQF11B IND.AQF03A IND.AQF03B IND.AQF05A IND.AQF05B IND.AQF07A IND.AQF07B]; ...
        [IND.AQD01A IND.AQD01B IND.AQD09A IND.AQD09B IND.AQD11A IND.AQD11B IND.AQD03A IND.AQD03B IND.AQD05A IND.AQD05B IND.AQD07A IND.AQD07B]; ...
        };
elseif strcmpi(knob_type, 'SimpleTuneEtaCorrectors')
    QUADS = { ...
        [IND.AQF01A IND.AQF01B IND.AQF09A IND.AQF09B IND.AQF11A IND.AQF11B IND.AQF03A IND.AQF03B IND.AQF05A IND.AQF05B IND.AQF07A IND.AQF07B]; ...
        [IND.AQD01A IND.AQD01B IND.AQD09A IND.AQD09B IND.AQD11A IND.AQD11B IND.AQD03A IND.AQD03B IND.AQD05A IND.AQD05B IND.AQD07A IND.AQD07B]; ...
        [IND.AQF02A IND.AQF04B IND.AQF06A IND.AQF08B IND.AQF10A IND.AQF12B IND.AQF02B IND.AQF04A IND.AQF06B IND.AQF08A IND.AQF10B IND.AQF12A]; ...
        };
elseif strcmpi(knob_type, 'AWS07Quads')
    QUADS = { ...
        [IND.AQF07A IND.AQF07B]; ...
        [IND.AQD07A IND.AQD07B]; ...
        [IND.AQF01A IND.AQF01B IND.AQF09A IND.AQF09B IND.AQF11A IND.AQF11B IND.AQF03A IND.AQF03B IND.AQF05A IND.AQF05B]; ...
        [IND.AQD01A IND.AQD01B IND.AQD09A IND.AQD09B IND.AQD11A IND.AQD11B IND.AQD03A IND.AQD03B IND.AQD05A IND.AQD05B]; ...
        %[IND.AQF02A IND.AQF04B IND.AQF06A IND.AQF08B IND.AQF10A IND.AQF12B IND.AQF02B IND.AQF04A IND.AQF06B IND.AQF08A IND.AQF10B IND.AQF12A]; ...
        };
elseif strcmpi(knob_type, 'QuadFamiliesWithIDs')
    QUADS = { ...
        [IND.AQF01A IND.AQF01B]; ...
        [IND.AQD01A IND.AQD01B]; ...
        [IND.AQF03A IND.AQF03B]; ...
        [IND.AQD03A IND.AQD03B]; ... 
        [IND.AQF05A IND.AQF05B]; ...
        [IND.AQD05A IND.AQD05B]; ... 
        [IND.AQF07A IND.AQF07B]; ...
        [IND.AQD07A IND.AQD07B]; ...
        [IND.AQF09A IND.AQF09B]; ...
        [IND.AQD09A IND.AQD09B]; ...
        [IND.AQF11A IND.AQF11B]; ...
        [IND.AQD11A IND.AQD11B]; ...
        [IND.AQF02A IND.AQF04B IND.AQF06A IND.AQF08B IND.AQF10A IND.AQF12B];   ...
        [IND.AQF02B IND.AQF04A IND.AQF06B IND.AQF08A IND.AQF10B IND.AQF12A]; ...
        };
elseif strcmpi(knob_type, 'QuadFamilies')
    QUADS = { ...
        [IND.AQF01A IND.AQF01B]; ...
        [IND.AQD01A IND.AQD01B]; ...
        [IND.AQF09A IND.AQF09B]; ...
        [IND.AQD09A IND.AQD09B]; ...
        [IND.AQF11A IND.AQF11B]; ...
        [IND.AQD11A IND.AQD11B]; ...
        [IND.AQF03A IND.AQF03B IND.AQF05A IND.AQF05B IND.AQF07A IND.AQF07B]; ...
        [IND.AQD03A IND.AQD03B IND.AQD05A IND.AQD05B IND.AQD07A IND.AQD07B]; ...
        [IND.AQF02A IND.AQF04B IND.AQF06A IND.AQF08B IND.AQF10A IND.AQF12B];   ...
        [IND.AQF02B IND.AQF04A IND.AQF06B IND.AQF08A IND.AQF10B IND.AQF12A]; ...
        };
else
    QUADS = {...
        IND.AQF01A; ...
        IND.AQF01B; ...
        IND.AQD01A; ...
        IND.AQD01B; ...
        IND.AQF09A; ...
        IND.AQF09B; ...
        IND.AQD09A; ...
        IND.AQD09B; ...
        IND.AQF11A; ...
        IND.AQF11B; ...
        IND.AQD11A; ...
        IND.AQD11B; ...
        IND.AQF03A; ...
        IND.AQF03B; ...
        IND.AQF05A; ...
        IND.AQF05B; ...
        IND.AQF07A; ...
        IND.AQF07B; ...
        IND.AQD03A; ...
        IND.AQD03B; ...
        IND.AQD05A; ...
        IND.AQD05B; ...
        IND.AQD07A; ...
        IND.AQD07B; ...
        IND.AQF02A; ...
        IND.AQF04B; ...
        IND.AQF06A; ...
        IND.AQF08B; ...
        IND.AQF10A; ...
        IND.AQF12B; ...
        IND.AQF02B; ...
        IND.AQF04A; ...
        IND.AQF06B; ... 
        IND.AQF08A; ... 
        IND.AQF10B; ...
        IND.AQF12A; ...
        };
end
IND.etax_lss = etax_lss;

TR0 = THERING;

% calcula vetor residuo inicial
calctwiss;
if isnan(tunes), tunes = THERING{end}.Twiss.mu/(2*pi); end
v0 = constraints_function(IND);
residue = ([tunes_weight*tunes(:)' zeros(1,length(v0)-2)]' - v0);


% calcula matriz de variação do residuo
for i=1:length(QUADS)
    dK = 0.001;
    THERING = TR0;
    K = getcellstruct(THERING, 'K', QUADS{i});
    THERING = setcellstruct(THERING, 'K', QUADS{i}, K + dK);
    THERING = setcellstruct(THERING, 'PolynomB', QUADS{i}, K + dK, 1, 2);
    c = constraints_function(IND);
    mm(:,i) = (c - v0)/dK;
end

% calcula pseudo inversa da matriz de variação do resíduo
[U,S,V] = svd(mm,'econ');
pseudoinv_mm = (V*inv(S)*U');
% calcula solução
deltaK = pseudoinv_mm * residue;


% ajusta modelo AT com nova sintonia
THERING = TR0;
for i=1:length(QUADS)
    K = getcellstruct(THERING, 'K', QUADS{i});
    THERING = setcellstruct(THERING, 'K', QUADS{i}, K + deltaK(i));
    THERING = setcellstruct(THERING, 'PolynomB', QUADS{i}, K + deltaK(i), 1, 2);
end

% retorna parâmetros
r.Indices = IND;
r.Quads = QUADS;
r.Residue = residue;
r.DeltaK = deltaK;
r.TuneCorrMatrix = pseudoinv_mm(:,1:2);


function r = calc_constraints_SymmetryPoints(IND)

global THERING;
LCENTER = findcells(THERING, 'FamName', 'LCENTER');
SCENTER = findcells(THERING, 'FamName', 'SCENTER');


calctwiss;
i=0;

i=i+1; r(i,1) = THERING{end}.Twiss.mu(1)/(2*pi);     % sintonia horizontal
i=i+1; r(i,1) = THERING{end}.Twiss.mu(2)/(2*pi);     % sintonia vertical


i=i+1; r(i,1) = THERING{LCENTER(1)}.Twiss.alpha(1);  % alphaX centro do TR01
i=i+1; r(i,1) = THERING{LCENTER(2)}.Twiss.alpha(1);  % alphaX centro do TR03
i=i+1; r(i,1) = THERING{LCENTER(3)}.Twiss.alpha(1);  % alphaX centro do TR05
i=i+1; r(i,1) = THERING{LCENTER(4)}.Twiss.alpha(1);  % alphaX centro do TR07
i=i+1; r(i,1) = THERING{LCENTER(5)}.Twiss.alpha(1);  % alphaX centro do TR09
i=i+1; r(i,1) = THERING{LCENTER(6)}.Twiss.alpha(1);  % alphaX centro do TR11

i=i+1; r(i,1) = THERING{LCENTER(1)}.Twiss.alpha(2); % alphaY centro do TR01
i=i+1; r(i,1) = THERING{LCENTER(2)}.Twiss.alpha(2); % alphaY centro do TR03
i=i+1; r(i,1) = THERING{LCENTER(3)}.Twiss.alpha(2); % alphaY centro do TR05
i=i+1; r(i,1) = THERING{LCENTER(4)}.Twiss.alpha(2); % alphaY centro do TR07
i=i+1; r(i,1) = THERING{LCENTER(5)}.Twiss.alpha(2); % alphaY centro do TR09
i=i+1; r(i,1) = THERING{LCENTER(6)}.Twiss.alpha(2); % alphaY centro do TR11

%return;

i=i+1; r(i,1) = THERING{SCENTER(1)}.Twiss.alpha(1);  % alphaX centro do TR02
i=i+1; r(i,1) = THERING{SCENTER(2)}.Twiss.alpha(1);  % alphaX centro do TR04
i=i+1; r(i,1) = THERING{SCENTER(3)}.Twiss.alpha(1);  % alphaX centro do TR06
i=i+1; r(i,1) = THERING{SCENTER(4)}.Twiss.alpha(1);  % alphaX centro do TR08
i=i+1; r(i,1) = THERING{SCENTER(5)}.Twiss.alpha(1);  % alphaX centro do TR10
i=i+1; r(i,1) = THERING{SCENTER(6)}.Twiss.alpha(1);  % alphaX centro do TR12

i=i+1; r(i,1) = THERING{SCENTER(1)}.Twiss.alpha(2);  % alphaY centro do TR02
i=i+1; r(i,1) = THERING{SCENTER(2)}.Twiss.alpha(2);  % alphaY centro do TR04
i=i+1; r(i,1) = THERING{SCENTER(3)}.Twiss.alpha(2);  % alphaY centro do TR06
i=i+1; r(i,1) = THERING{SCENTER(4)}.Twiss.alpha(2);  % alphaY centro do TR08
i=i+1; r(i,1) = THERING{SCENTER(5)}.Twiss.alpha(2);  % alphaY centro do TR10
i=i+1; r(i,1) = THERING{SCENTER(6)}.Twiss.alpha(2);  % alphaY centro do TR12


%{
i=i+1; r(i,1) = THERING{IND.AQF01A(1)}.Twiss.beta(1)-THERING{IND.AQF03A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQF03A(1)}.Twiss.beta(1)-THERING{IND.AQF05A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQF05A(1)}.Twiss.beta(1)-THERING{IND.AQF07A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQF07A(1)}.Twiss.beta(1)-THERING{IND.AQF09A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQF09A(1)}.Twiss.beta(1)-THERING{IND.AQF11A(1)}.Twiss.beta(1);

i=i+1; r(i,1) = THERING{IND.AQF01A(1)}.Twiss.beta(2)-THERING{IND.AQF03A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQF03A(1)}.Twiss.beta(2)-THERING{IND.AQF05A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQF05A(1)}.Twiss.beta(2)-THERING{IND.AQF07A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQF07A(1)}.Twiss.beta(2)-THERING{IND.AQF09A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQF09A(1)}.Twiss.beta(2)-THERING{IND.AQF11A(1)}.Twiss.beta(2);
%}

% 2012-01-22: comentados os constraints sobre AQDs para que a simetrizacao do anel com o AWS07 funcionasse. XRR

%{
i=i+1; r(i,1) = THERING{IND.AQD01A(1)}.Twiss.beta(1)-THERING{IND.AQD03A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQD03A(1)}.Twiss.beta(1)-THERING{IND.AQD05A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQD05A(1)}.Twiss.beta(1)-THERING{IND.AQD07A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQD07A(1)}.Twiss.beta(1)-THERING{IND.AQD09A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQD09A(1)}.Twiss.beta(1)-THERING{IND.AQD11A(1)}.Twiss.beta(1);

i=i+1; r(i,1) = THERING{IND.AQD01A(1)}.Twiss.beta(2)-THERING{IND.AQD03A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQD03A(1)}.Twiss.beta(2)-THERING{IND.AQD05A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQD05A(1)}.Twiss.beta(2)-THERING{IND.AQD07A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQD07A(1)}.Twiss.beta(2)-THERING{IND.AQD09A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQD09A(1)}.Twiss.beta(2)-THERING{IND.AQD11A(1)}.Twiss.beta(2);
%}

i=i+1; r(i,1) = THERING{LCENTER(1)}.Twiss.Dispersion(1) - IND.etax_lss;  % etax centro do TR01
i=i+1; r(i,1) = THERING{LCENTER(2)}.Twiss.Dispersion(1) - IND.etax_lss;  % etax centro do TR03
i=i+1; r(i,1) = THERING{LCENTER(3)}.Twiss.Dispersion(1) - IND.etax_lss;  % etax centro do TR05
i=i+1; r(i,1) = THERING{LCENTER(4)}.Twiss.Dispersion(1) - IND.etax_lss;  % etax centro do TR07
i=i+1; r(i,1) = THERING{LCENTER(5)}.Twiss.Dispersion(1) - IND.etax_lss;  % etax centro do TR09
i=i+1; r(i,1) = THERING{LCENTER(6)}.Twiss.Dispersion(1) - IND.etax_lss;  % etax centro do TR11

i=i+1; r(i,1) = THERING{LCENTER(1)}.Twiss.Dispersion(2);  % etaxl centro do TR01
i=i+1; r(i,1) = THERING{LCENTER(2)}.Twiss.Dispersion(2);  % etaxl centro do TR03
i=i+1; r(i,1) = THERING{LCENTER(3)}.Twiss.Dispersion(2);  % etaxl centro do TR05
i=i+1; r(i,1) = THERING{LCENTER(4)}.Twiss.Dispersion(2);  % etaxl centro do TR07
i=i+1; r(i,1) = THERING{LCENTER(5)}.Twiss.Dispersion(2);  % etaxl centro do TR09
i=i+1; r(i,1) = THERING{LCENTER(6)}.Twiss.Dispersion(2);  % etaxl centro do TR11

function r = calc_constraints_AllSymmetriesWithIDs(IND)

global THERING;
LCENTER = findcells(THERING, 'FamName', 'LCENTER');
SCENTER = findcells(THERING, 'FamName', 'SCENTER');


calctwiss;
i=0;

i=i+1; r(i,1) = IND.tunes_weight*THERING{end}.Twiss.mu(1)/(2*pi);     % sintonia horizontal
i=i+1; r(i,1) = IND.tunes_weight*THERING{end}.Twiss.mu(2)/(2*pi);     % sintonia vertical


i=i+1; r(i,1) = THERING{LCENTER(1)}.Twiss.alpha(1);  % alphaX centro do TR01
i=i+1; r(i,1) = THERING{LCENTER(2)}.Twiss.alpha(1);  % alphaX centro do TR03
i=i+1; r(i,1) = THERING{LCENTER(3)}.Twiss.alpha(1);  % alphaX centro do TR05
i=i+1; r(i,1) = THERING{LCENTER(4)}.Twiss.alpha(1);  % alphaX centro do TR07
i=i+1; r(i,1) = THERING{LCENTER(5)}.Twiss.alpha(1);  % alphaX centro do TR09
i=i+1; r(i,1) = THERING{LCENTER(6)}.Twiss.alpha(1);  % alphaX centro do TR11

i=i+1; r(i,1) = THERING{LCENTER(1)}.Twiss.alpha(2); % alphaY centro do TR01
i=i+1; r(i,1) = THERING{LCENTER(2)}.Twiss.alpha(2); % alphaY centro do TR03
i=i+1; r(i,1) = THERING{LCENTER(3)}.Twiss.alpha(2); % alphaY centro do TR05
i=i+1; r(i,1) = THERING{LCENTER(4)}.Twiss.alpha(2); % alphaY centro do TR07
i=i+1; r(i,1) = THERING{LCENTER(5)}.Twiss.alpha(2); % alphaY centro do TR09
i=i+1; r(i,1) = THERING{LCENTER(6)}.Twiss.alpha(2); % alphaY centro do TR11

i=i+1; r(i,1) = THERING{SCENTER(1)}.Twiss.alpha(1);  % alphaX centro do TR02
i=i+1; r(i,1) = THERING{SCENTER(2)}.Twiss.alpha(1);  % alphaX centro do TR04
i=i+1; r(i,1) = THERING{SCENTER(3)}.Twiss.alpha(1);  % alphaX centro do TR06
i=i+1; r(i,1) = THERING{SCENTER(4)}.Twiss.alpha(1);  % alphaX centro do TR08
i=i+1; r(i,1) = THERING{SCENTER(5)}.Twiss.alpha(1);  % alphaX centro do TR10
i=i+1; r(i,1) = THERING{SCENTER(6)}.Twiss.alpha(1);  % alphaX centro do TR12

i=i+1; r(i,1) = THERING{SCENTER(1)}.Twiss.alpha(2);  % alphaY centro do TR02
i=i+1; r(i,1) = THERING{SCENTER(2)}.Twiss.alpha(2);  % alphaY centro do TR04
i=i+1; r(i,1) = THERING{SCENTER(3)}.Twiss.alpha(2);  % alphaY centro do TR06
i=i+1; r(i,1) = THERING{SCENTER(4)}.Twiss.alpha(2);  % alphaY centro do TR08
i=i+1; r(i,1) = THERING{SCENTER(5)}.Twiss.alpha(2);  % alphaY centro do TR10
i=i+1; r(i,1) = THERING{SCENTER(6)}.Twiss.alpha(2);  % alphaY centro do TR12


TR01 = LCENTER(1);
TR03 = LCENTER(2);
TR05 = LCENTER(3);
TR07 = LCENTER(4);
TR09 = LCENTER(5);
TR11 = LCENTER(6);

TR02 = SCENTER(1);
TR04 = SCENTER(2);
TR06 = SCENTER(3);
TR08 = SCENTER(4);
TR10 = SCENTER(5);
TR12 = SCENTER(6);


i=i+1; r(i,1) = THERING{TR01}.Twiss.beta(1)-THERING{TR03}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{TR03}.Twiss.beta(1)-THERING{TR05}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{TR05}.Twiss.beta(1)-THERING{TR07}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{TR07}.Twiss.beta(1)-THERING{TR09}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{TR09}.Twiss.beta(1)-THERING{TR11}.Twiss.beta(1);

i=i+1; r(i,1) = THERING{TR03}.Twiss.beta(2)-THERING{TR05}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{TR05}.Twiss.beta(2)-THERING{TR07}.Twiss.beta(2);

i=i+1; r(i,1) = THERING{TR02}.Twiss.beta(1)-THERING{TR04}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{TR04}.Twiss.beta(1)-THERING{TR06}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{TR06}.Twiss.beta(1)-THERING{TR08}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{TR08}.Twiss.beta(1)-THERING{TR10}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{TR10}.Twiss.beta(1)-THERING{TR12}.Twiss.beta(1);

i=i+1; r(i,1) = THERING{TR02}.Twiss.beta(2)-THERING{TR04}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{TR04}.Twiss.beta(2)-THERING{TR06}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{TR06}.Twiss.beta(2)-THERING{TR08}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{TR08}.Twiss.beta(2)-THERING{TR10}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{TR10}.Twiss.beta(2)-THERING{TR12}.Twiss.beta(2);
%i=i+1; r(i,1) = THERING{TR12}.Twiss.beta(2)-THERING{TR02}.Twiss.beta(2);


i=i+1; r(i,1) = IND.eta_weight*(THERING{TR01}.Twiss.Dispersion(1) - IND.etax_lss);  % etax centro do TR01
i=i+1; r(i,1) = IND.eta_weight*(THERING{TR03}.Twiss.Dispersion(1) - IND.etax_lss);  % etax centro do TR03
i=i+1; r(i,1) = IND.eta_weight*(THERING{TR05}.Twiss.Dispersion(1) - IND.etax_lss);  % etax centro do TR05
i=i+1; r(i,1) = IND.eta_weight*(THERING{TR07}.Twiss.Dispersion(1) - IND.etax_lss);  % etax centro do TR07
i=i+1; r(i,1) = IND.eta_weight*(THERING{TR09}.Twiss.Dispersion(1) - IND.etax_lss);  % etax centro do TR09
i=i+1; r(i,1) = IND.eta_weight*(THERING{TR11}.Twiss.Dispersion(1) - IND.etax_lss);  % etax centro do TR11

i=i+1; r(i,1) = IND.eta_weight*THERING{TR01}.Twiss.Dispersion(2);  % etaxl centro do TR01
i=i+1; r(i,1) = IND.eta_weight*THERING{TR03}.Twiss.Dispersion(2);  % etaxl centro do TR03
i=i+1; r(i,1) = IND.eta_weight*THERING{TR05}.Twiss.Dispersion(2);  % etaxl centro do TR05
i=i+1; r(i,1) = IND.eta_weight*THERING{TR07}.Twiss.Dispersion(2);  % etaxl centro do TR07
i=i+1; r(i,1) = IND.eta_weight*THERING{TR09}.Twiss.Dispersion(2);  % etaxl centro do TR09
i=i+1; r(i,1) = IND.eta_weight*THERING{TR11}.Twiss.Dispersion(2);  % etaxl centro do TR11


function r = calc_constraints_AllSymmetries(IND)

global THERING;
LCENTER = findcells(THERING, 'FamName', 'LCENTER');
SCENTER = findcells(THERING, 'FamName', 'SCENTER');


calctwiss;
i=0;

i=i+1; r(i,1) = IND.tunes_weight*THERING{end}.Twiss.mu(1)/(2*pi);     % sintonia horizontal
i=i+1; r(i,1) = IND.tunes_weight*THERING{end}.Twiss.mu(2)/(2*pi);     % sintonia vertical


i=i+1; r(i,1) = THERING{LCENTER(1)}.Twiss.alpha(1);  % alphaX centro do TR01
i=i+1; r(i,1) = THERING{LCENTER(2)}.Twiss.alpha(1);  % alphaX centro do TR03
i=i+1; r(i,1) = THERING{LCENTER(3)}.Twiss.alpha(1);  % alphaX centro do TR05
i=i+1; r(i,1) = THERING{LCENTER(4)}.Twiss.alpha(1);  % alphaX centro do TR07
i=i+1; r(i,1) = THERING{LCENTER(5)}.Twiss.alpha(1);  % alphaX centro do TR09
i=i+1; r(i,1) = THERING{LCENTER(6)}.Twiss.alpha(1);  % alphaX centro do TR11

i=i+1; r(i,1) = THERING{LCENTER(1)}.Twiss.alpha(2); % alphaY centro do TR01
i=i+1; r(i,1) = THERING{LCENTER(2)}.Twiss.alpha(2); % alphaY centro do TR03
i=i+1; r(i,1) = THERING{LCENTER(3)}.Twiss.alpha(2); % alphaY centro do TR05
i=i+1; r(i,1) = THERING{LCENTER(4)}.Twiss.alpha(2); % alphaY centro do TR07
i=i+1; r(i,1) = THERING{LCENTER(5)}.Twiss.alpha(2); % alphaY centro do TR09
i=i+1; r(i,1) = THERING{LCENTER(6)}.Twiss.alpha(2); % alphaY centro do TR11

%return;

i=i+1; r(i,1) = THERING{SCENTER(1)}.Twiss.alpha(1);  % alphaX centro do TR02
i=i+1; r(i,1) = THERING{SCENTER(2)}.Twiss.alpha(1);  % alphaX centro do TR04
i=i+1; r(i,1) = THERING{SCENTER(3)}.Twiss.alpha(1);  % alphaX centro do TR06
i=i+1; r(i,1) = THERING{SCENTER(4)}.Twiss.alpha(1);  % alphaX centro do TR08
i=i+1; r(i,1) = THERING{SCENTER(5)}.Twiss.alpha(1);  % alphaX centro do TR10
i=i+1; r(i,1) = THERING{SCENTER(6)}.Twiss.alpha(1);  % alphaX centro do TR12

i=i+1; r(i,1) = THERING{SCENTER(1)}.Twiss.alpha(2);  % alphaY centro do TR02
i=i+1; r(i,1) = THERING{SCENTER(2)}.Twiss.alpha(2);  % alphaY centro do TR04
i=i+1; r(i,1) = THERING{SCENTER(3)}.Twiss.alpha(2);  % alphaY centro do TR06
i=i+1; r(i,1) = THERING{SCENTER(4)}.Twiss.alpha(2);  % alphaY centro do TR08
i=i+1; r(i,1) = THERING{SCENTER(5)}.Twiss.alpha(2);  % alphaY centro do TR10
i=i+1; r(i,1) = THERING{SCENTER(6)}.Twiss.alpha(2);  % alphaY centro do TR12


%{
i=i+1; r(i,1) = THERING{IND.AQF01A(1)}.Twiss.beta(1)-THERING{IND.AQF03A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQF03A(1)}.Twiss.beta(1)-THERING{IND.AQF05A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQF05A(1)}.Twiss.beta(1)-THERING{IND.AQF07A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQF07A(1)}.Twiss.beta(1)-THERING{IND.AQF09A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQF09A(1)}.Twiss.beta(1)-THERING{IND.AQF11A(1)}.Twiss.beta(1);

i=i+1; r(i,1) = THERING{IND.AQF01A(1)}.Twiss.beta(2)-THERING{IND.AQF03A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQF03A(1)}.Twiss.beta(2)-THERING{IND.AQF05A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQF05A(1)}.Twiss.beta(2)-THERING{IND.AQF07A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQF07A(1)}.Twiss.beta(2)-THERING{IND.AQF09A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQF09A(1)}.Twiss.beta(2)-THERING{IND.AQF11A(1)}.Twiss.beta(2);
%}

i=i+1; r(i,1) = THERING{IND.AQD01A(1)}.Twiss.beta(1)-THERING{IND.AQD03A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQD03A(1)}.Twiss.beta(1)-THERING{IND.AQD05A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQD05A(1)}.Twiss.beta(1)-THERING{IND.AQD07A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQD07A(1)}.Twiss.beta(1)-THERING{IND.AQD09A(1)}.Twiss.beta(1);
i=i+1; r(i,1) = THERING{IND.AQD09A(1)}.Twiss.beta(1)-THERING{IND.AQD11A(1)}.Twiss.beta(1);

i=i+1; r(i,1) = THERING{IND.AQD01A(1)}.Twiss.beta(2)-THERING{IND.AQD03A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQD03A(1)}.Twiss.beta(2)-THERING{IND.AQD05A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQD05A(1)}.Twiss.beta(2)-THERING{IND.AQD07A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQD07A(1)}.Twiss.beta(2)-THERING{IND.AQD09A(1)}.Twiss.beta(2);
i=i+1; r(i,1) = THERING{IND.AQD09A(1)}.Twiss.beta(2)-THERING{IND.AQD11A(1)}.Twiss.beta(2);

i=i+1; r(i,1) = IND.eta_weight*THERING{LCENTER(1)}.Twiss.Dispersion(1) - IND.etax_lss;  % etax centro do TR01
i=i+1; r(i,1) = IND.eta_weight*THERING{LCENTER(2)}.Twiss.Dispersion(1) - IND.etax_lss;  % etax centro do TR03
i=i+1; r(i,1) = IND.eta_weight*THERING{LCENTER(3)}.Twiss.Dispersion(1) - IND.etax_lss;  % etax centro do TR05
i=i+1; r(i,1) = IND.eta_weight*THERING{LCENTER(4)}.Twiss.Dispersion(1) - IND.etax_lss;  % etax centro do TR07
i=i+1; r(i,1) = IND.eta_weight*THERING{LCENTER(5)}.Twiss.Dispersion(1) - IND.etax_lss;  % etax centro do TR09
i=i+1; r(i,1) = IND.eta_weight*THERING{LCENTER(6)}.Twiss.Dispersion(1) - IND.etax_lss;  % etax centro do TR11

i=i+1; r(i,1) = IND.eta_weight*THERING{LCENTER(1)}.Twiss.Dispersion(2);  % etaxl centro do TR01
i=i+1; r(i,1) = IND.eta_weight*THERING{LCENTER(2)}.Twiss.Dispersion(2);  % etaxl centro do TR03
i=i+1; r(i,1) = IND.eta_weight*THERING{LCENTER(3)}.Twiss.Dispersion(2);  % etaxl centro do TR05
i=i+1; r(i,1) = IND.eta_weight*THERING{LCENTER(4)}.Twiss.Dispersion(2);  % etaxl centro do TR07
i=i+1; r(i,1) = IND.eta_weight*THERING{LCENTER(5)}.Twiss.Dispersion(2);  % etaxl centro do TR09
i=i+1; r(i,1) = IND.eta_weight*THERING{LCENTER(6)}.Twiss.Dispersion(2);  % etaxl centro do TR11

function r = calc_constraints_OnlyTunes(IND)

global THERING;
LCENTER = findcells(THERING, 'FamName', 'LCENTER');
SCENTER = reshape(findcells(THERING, 'FamName', 'A6SF'), 2, []);
SCENTER = SCENTER(2,:);


calctwiss;
i=0;

i=i+1; r(i,1) = THERING{end}.Twiss.mu(1)/(2*pi);     % sintonia horizontal
i=i+1; r(i,1) = THERING{end}.Twiss.mu(2)/(2*pi);     % sintonia vertical



function r = calc_constraints_LSSSymmetries(IND)

global THERING;
LCENTER = findcells(THERING, 'FamName', 'LCENTER');
SCENTER = findcells(THERING, 'FamName', 'SCENTER');

calctwiss;
i=0;

i=i+1; r(i,1) = THERING{end}.Twiss.mu(1)/(2*pi);     % sintonia horizontal
i=i+1; r(i,1) = THERING{end}.Twiss.mu(2)/(2*pi);     % sintonia vertical
i=i+1; r(i,1) = THERING{LCENTER(1)}.Twiss.alpha(1);  % alphaX centro do TR01
i=i+1; r(i,1) = THERING{LCENTER(2)}.Twiss.alpha(1);  % alphaX centro do TR03
i=i+1; r(i,1) = THERING{LCENTER(3)}.Twiss.alpha(1);  % alphaX centro do TR05
i=i+1; r(i,1) = THERING{LCENTER(4)}.Twiss.alpha(1);  % alphaX centro do TR07
i=i+1; r(i,1) = THERING{LCENTER(5)}.Twiss.alpha(1);  % alphaX centro do TR09
i=i+1; r(i,1) = THERING{LCENTER(6)}.Twiss.alpha(1);  % alphaX centro do TR11
i=i+1; r(i,1) = THERING{LCENTER(1)}.Twiss.alpha(2); % alphaY centro do TR01
i=i+1; r(i,1) = THERING{LCENTER(2)}.Twiss.alpha(2); % alphaY centro do TR03
i=i+1; r(i,1) = THERING{LCENTER(3)}.Twiss.alpha(2); % alphaY centro do TR05
i=i+1; r(i,1) = THERING{LCENTER(4)}.Twiss.alpha(2); % alphaY centro do TR07
i=i+1; r(i,1) = THERING{LCENTER(5)}.Twiss.alpha(2); % alphaY centro do TR09
i=i+1; r(i,1) = THERING{LCENTER(6)}.Twiss.alpha(2); % alphaY centro do TR11