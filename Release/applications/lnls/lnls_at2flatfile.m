function lnls_at2flatfile(lattice, filename)
%lnls_at2flatfile(lattice, filename) gera um arquivo flatfile 
%com nome 'filename' a partir do modelo do 'lattice' do AT.
%
%
%Ximenes - 2014-08-27

cts = lnls_constants;
L = findspos(lattice, length(lattice)+1);
rv_freq = cts.c / L;
idx = findcells(lattice, 'Frequency');
if isempty(idx)
    h = NaN;
else
    h = round(lattice{idx(1)}.Frequency / rv_freq);
end

energy   = lattice{1}.Energy;
pmethods = unique(getcellstruct(lattice, 'PassMethod', 1:length(lattice)));
if strcmpi('CavityPass',pmethods)
    cavity_on = 'true';
else
    cavity_on = 'false';
end
if strcmpi('StrMPoleSymplectic4RadPass',pmethods)
    radiation_on = 'true';
else
    radiation_on = 'false';
end

EOL = '\r\n';
CLFMT = '%-15s ';
DBLFMT = '%+.17E ';

fp = fopen(filename, 'w');

fprintf(fp, ['# Lattice flatfile generated with lnls_at2flatfile',EOL]);
fprintf(fp, '\n');
fprintf(fp, ['%% energy %f eV',EOL], energy);
fprintf(fp, ['%% harmonic_number %i ',EOL], h);
fprintf(fp, ['%% cavity_on %s ',EOL], cavity_on);
fprintf(fp, ['%% radiation_on %s ',EOL], radiation_on);
fprintf(fp, ['%% vchamber_on %s ',EOL], 'false');
fprintf(fp, EOL);

for i=1:length(lattice)
    fprintf(fp, ['### %04i ###',EOL],i-1);
    fprintf(fp, CLFMT, 'fam_name'); fprintf(fp, ['%s',EOL], lattice{i}.FamName);
    fprintf(fp, CLFMT, 'length'); fprintf(fp, [DBLFMT, EOL], lattice{i}.Length);
    fprintf(fp, CLFMT, 'pass_method'); fprintf(fp, ['%s', EOL], get_passmethod(lattice{i}));
    if isfield(lattice{i}, 'NumIntSteps'), fprintf(fp, CLFMT, 'nr_steps'); fprintf(fp, ['%i',EOL], lattice{i}.NumIntSteps); end;
    if isfield(lattice{i}, 'PolynomA')
        [PolyA, PolyB] = calc_polynoms(lattice{i});
        if (~isempty(PolyA) && any(PolyA ~= 0)), fprintf(fp, CLFMT, 'polynom_a'); print_polynom(fp, PolyA, DBLFMT, EOL); end;
        if (~isempty(PolyB) && any(PolyB ~= 0)), fprintf(fp, CLFMT, 'polynom_b'); print_polynom(fp, PolyB, DBLFMT, EOL); end;
    end
    if isfield(lattice{i}, 'Voltage')
        fprintf(fp, CLFMT, 'voltage'); fprintf(fp, [DBLFMT, EOL], lattice{i}.Voltage);
    end
    if isfield(lattice{i}, 'Frequency')
        fprintf(fp, CLFMT, 'frequency'); fprintf(fp, [DBLFMT, EOL], lattice{i}.Frequency);
    end
    if isfield(lattice{i}, 'PhaseLag')
        fprintf(fp, CLFMT, 'phase_lag'); fprintf(fp, [DBLFMT, EOL], lattice{i}.PhaseLag);
    end
    if isfield(lattice{i}, 'BendingAngle')
        fprintf(fp, CLFMT, 'angle'); fprintf(fp, [DBLFMT, EOL], lattice{i}.BendingAngle);
        fprintf(fp, CLFMT, 'angle_in'); fprintf(fp, [DBLFMT, EOL], lattice{i}.EntranceAngle);
        fprintf(fp, CLFMT, 'angle_out'); fprintf(fp, [DBLFMT, EOL], lattice{i}.ExitAngle);
    end
    if isfield(lattice{i}, 'FullGap')
        fprintf(fp, CLFMT, 'gap'); fprintf(fp, [DBLFMT, EOL], lattice{i}.FullGap);
    end
    if isfield(lattice{i}, 'FringeInt1')
        fprintf(fp, CLFMT, 'fint_in'); fprintf(fp, [DBLFMT, EOL], lattice{i}.FringeInt1);
    end
    if isfield(lattice{i}, 'FringeInt2')
        fprintf(fp, CLFMT, 'fint_out'); fprintf(fp, [DBLFMT, EOL], lattice{i}.FringeInt2);
    end
    if isfield(lattice{i}, 'KickAngle')
        fprintf(fp, CLFMT, 'hkick'); fprintf(fp, [DBLFMT, EOL], lattice{i}.KickAngle(1));
        fprintf(fp, CLFMT, 'vkick'); fprintf(fp, [DBLFMT, EOL], lattice{i}.KickAngle(2));
    end
    if isfield(lattice{i}, 'VChamber')
        fprintf(fp, CLFMT, 'hmax'); fprintf(fp, [DBLFMT, EOL], abs(lattice{i}.VChamber(1)));
        fprintf(fp, CLFMT, 'vmax'); fprintf(fp, [DBLFMT, EOL], abs(lattice{i}.VChamber(2)));
    end
    if isfield(lattice{i}, 'T1')
        fprintf(fp, CLFMT, 't_in'); fprintf(fp, [DBLFMT, ' '], lattice{i}.T1); fprintf(fp, EOL);
    end
    if isfield(lattice{i}, 'T2')
        fprintf(fp, CLFMT, 't_out'); fprintf(fp, [DBLFMT, ' '], lattice{i}.T2); fprintf(fp, EOL);
    end
    if isfield(lattice{i}, 'R1')
        fprintf(fp, CLFMT, 'rx|r_in'); fprintf(fp, [DBLFMT, ' '], lattice{i}.R1(1,:)); fprintf(fp, EOL);
        fprintf(fp, CLFMT, 'px|r_in'); fprintf(fp, [DBLFMT, ' '], lattice{i}.R1(2,:)); fprintf(fp, EOL);
        fprintf(fp, CLFMT, 'ry|r_in'); fprintf(fp, [DBLFMT, ' '], lattice{i}.R1(3,:)); fprintf(fp, EOL);
        fprintf(fp, CLFMT, 'py|r_in'); fprintf(fp, [DBLFMT, ' '], lattice{i}.R1(4,:)); fprintf(fp, EOL);
        fprintf(fp, CLFMT, 'de|r_in'); fprintf(fp, [DBLFMT, ' '], lattice{i}.R1(5,:)); fprintf(fp, EOL);
        fprintf(fp, CLFMT, 'dl|r_in'); fprintf(fp, [DBLFMT, ' '], lattice{i}.R1(6,:)); fprintf(fp, EOL);
    end
    if isfield(lattice{i}, 'R2')
        fprintf(fp, CLFMT, 'rx|r_out'); fprintf(fp, [DBLFMT, ' '], lattice{i}.R2(1,:)); fprintf(fp, EOL);
        fprintf(fp, CLFMT, 'px|r_out'); fprintf(fp, [DBLFMT, ' '], lattice{i}.R2(2,:)); fprintf(fp, EOL);
        fprintf(fp, CLFMT, 'ry|r_out'); fprintf(fp, [DBLFMT, ' '], lattice{i}.R2(3,:)); fprintf(fp, EOL);
        fprintf(fp, CLFMT, 'py|r_out'); fprintf(fp, [DBLFMT, ' '], lattice{i}.R2(4,:)); fprintf(fp, EOL);
        fprintf(fp, CLFMT, 'de|r_out'); fprintf(fp, [DBLFMT, ' '], lattice{i}.R2(5,:)); fprintf(fp, EOL);
        fprintf(fp, CLFMT, 'dl|r_out'); fprintf(fp, [DBLFMT, ' '], lattice{i}.R2(6,:)); fprintf(fp, EOL);
    end
    if isfield(lattice{i}, 'PxGrid')
        [pathstr, ~, ~] = fileparts(filename);
        kicktable_filename = fullfile(pathstr, [lattice{i}.FamName, '.txt']);
        if ~exist(kicktable_filename,'file'),
            save_kicktable_file(lattice{i}, kicktable_filename, EOL, DBLFMT);
        end

    end
    fprintf(fp, EOL);
end

fclose(fp);

function passmethod = get_passmethod(element)

if isfield(element, 'Frequency') || strcmpi(element.PassMethod, 'CavityPass')
    passmethod = 'cavity_pass';
elseif strcmpi(element.PassMethod, 'IdentityPass')
    passmethod = 'identity_pass';
elseif strcmpi(element.PassMethod, 'DriftPass')
    passmethod = 'drift_pass';
elseif strcmpi(element.PassMethod, 'CorrectorPass')
    passmethod = 'corrector_pass';
elseif strcmpi(element.PassMethod, 'LNLSThickEPUPass')
    passmethod = 'kicktable_pass';    
elseif any(strcmpi(element.PassMethod, {'BndMPoleSymplectic4Pass','BndMPoleSymplectic4RadPass'}))
    passmethod = 'bnd_mpole_symplectic4_pass';
elseif any(strcmpi(element.PassMethod, {'StrMPoleSymplectic4Pass','StrMPoleSymplectic4RadPass'}))
    passmethod = 'str_mpole_symplectic4_pass';
else
    error('passmethod not defined');
end

% template <typename T> Status::type pm_cavity_pass                (Pos<T> &pos, const Element &elem, const Accelerator& accelerator);
% template <typename T> Status::type pm_thinquad_pass              (Pos<T> &pos, const Element &elem, const Accelerator& accelerator);
% template <typename T> Status::type pm_thinsext_pass              (Pos<T> &pos, const Element &elem, const Accelerator& accelerator);
% template <typename T> Status::type pm_kicktable_pass             (Pos<T> &pos, const Element &elem, const Accelerator& accelerator);


function print_polynom(fp, polynom, DBLFMT, EOL)

for i=1:length(polynom)
    if polynom(i) ~= 0
        fprintf(fp, ['%i ', DBLFMT], i-1, polynom(i));
    end
end
fprintf(fp, EOL);

function [PolynomA, PolynomB] = calc_polynoms(element)

selA = (element.PolynomA ~= 0);
selB = (element.PolynomB ~= 0);
order = max([find(selB, 1, 'last') find(selA, 1, 'last')]);
PolynomA = zeros(1,order);
PolynomB = zeros(1,order);
PolynomA(selA) = element.PolynomA(selA);
PolynomB(selB) = element.PolynomB(selB);

function save_kicktable_file(elem, fname, EOL, DBLFMT)


sep_char = ' ';
test_string = sprintf(DBLFMT,1.2e-3);
leng_str = sprintf('%%%ds',length(test_string));

posx = 1000 * elem.XGrid(1,:);
posz = 1000 * elem.YGrid(:,1)';
dpsi_dx = 1 * elem.PxGrid;
dpsi_dz = 1 * elem.PyGrid;
params.factor = 1;

%fname = lower(['kicktable_' elem.FamName '.txt']);
fp = fopen(fname, 'w');
fprintf(fp, ['# ', elem.FamName, ' KICKMAP', EOL] );
fprintf(fp, ['# Author: lnls_at2tracy @ LNLS, Date: ', datestr(now), EOL] );
fprintf(fp, ['# ID Length [m]', EOL] );
fprintf(fp, ['%.17E', EOL], elem.Length);
fprintf(fp, ['# Number of Horizontal Points', EOL] );
fprintf(fp, ['%i' EOL], elem.NumX);
fprintf(fp, ['# Number of Vertical Points', EOL] );
fprintf(fp, ['%i' EOL], elem.NumY);

% copy and paste do arquivo 'kickmap_save_kickmap_tables.m'

fprintf(fp,  ['# Horizontal KickTable in T2m2',EOL]);
fprintf(fp,  ['START',EOL]);
fprintf(fp, leng_str, '');
fprintf(fp, [sep_char,DBLFMT], posx/1000); 
fprintf(fp, EOL);
for i=1:length(posz)
    fprintf(fp, DBLFMT, posz(i)/1000);
    fprintf(fp, [sep_char,DBLFMT], params.factor * dpsi_dx(i,:));
    fprintf(fp, EOL);
end

fprintf(fp,  ['# Vertical KickTable in T2m2', EOL]);
fprintf(fp,  ['START', EOL]);
fprintf(fp, leng_str, '');
fprintf(fp, [sep_char,DBLFMT], posx/1000); 
fprintf(fp, EOL);
for i=1:length(posz)
    fprintf(fp, DBLFMT, posz(i)/1000);
    fprintf(fp, [sep_char,DBLFMT], params.factor * dpsi_dz(i,:));
    fprintf(fp, EOL);
end

fclose(fp);

