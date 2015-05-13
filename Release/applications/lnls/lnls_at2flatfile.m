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
h = round(lattice{idx(1)}.Frequency / rv_freq);

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


fp = fopen(filename, 'w');

fprintf(fp, '# Lattice flatfile generated with lnls_at2flatfile\n');
fprintf(fp, '\n');
fprintf(fp, '%% energy %f eV\n', energy);
fprintf(fp, '%% harmonic_number %i \n', h);
fprintf(fp, '%% cavity_on %s \n', cavity_on);
fprintf(fp, '%% radiation_on %s \n', radiation_on);
fprintf(fp, '%% vchamber_on %s \n', 'false');
fprintf(fp, '\n');

column_format = '%-15s ';
double_format = '%+.17E ';
for i=1:length(lattice)
    fprintf(fp, '### %04i ###\r\n',i-1);
    fprintf(fp, column_format, 'fam_name'); fprintf(fp, '%s\r\n', lattice{i}.FamName);
    fprintf(fp, column_format, 'length'); fprintf(fp, [double_format, '\r\n'], lattice{i}.Length);
    fprintf(fp, column_format, 'pass_method'); fprintf(fp, ['%s', '\r\n'], get_passmethod(lattice{i}));
    if isfield(lattice{i}, 'NumIntSteps'), fprintf(fp, column_format, 'nr_steps'); fprintf(fp, '%i\r\n', lattice{i}.NumIntSteps); end;
    if isfield(lattice{i}, 'PolynomA')
        [PolyA, PolyB] = calc_polynoms(lattice{i});
        if (~isempty(PolyA) && any(PolyA ~= 0)), fprintf(fp, column_format, 'polynom_a'); print_polynom(fp, PolyA, double_format); end;
        if (~isempty(PolyB) && any(PolyB ~= 0)), fprintf(fp, column_format, 'polynom_b'); print_polynom(fp, PolyB, double_format); end;
    end
    if isfield(lattice{i}, 'Voltage')
        fprintf(fp, column_format, 'voltage'); fprintf(fp, [double_format, '\r\n'], lattice{i}.Voltage);
    end
    if isfield(lattice{i}, 'Frequency')
        fprintf(fp, column_format, 'frequency'); fprintf(fp, [double_format, '\r\n'], lattice{i}.Frequency);
    end
    if isfield(lattice{i}, 'BendingAngle')
        fprintf(fp, column_format, 'angle'); fprintf(fp, [double_format, '\r\n'], lattice{i}.BendingAngle);
        fprintf(fp, column_format, 'angle_in'); fprintf(fp, [double_format, '\r\n'], lattice{i}.EntranceAngle);
        fprintf(fp, column_format, 'angle_out'); fprintf(fp, [double_format, '\r\n'], lattice{i}.ExitAngle);
    end
    if isfield(lattice{i}, 'FullGap')
        fprintf(fp, column_format, 'gap'); fprintf(fp, [double_format, '\r\n'], lattice{i}.FullGap);
    end
    if isfield(lattice{i}, 'FringeInt1')
        fprintf(fp, column_format, 'fint_in'); fprintf(fp, [double_format, '\r\n'], lattice{i}.FringeInt1);
    end
    if isfield(lattice{i}, 'FringeInt2')
        fprintf(fp, column_format, 'fint_out'); fprintf(fp, [double_format, '\r\n'], lattice{i}.FringeInt2);
    end
    if isfield(lattice{i}, 'KickAngle')
        fprintf(fp, column_format, 'hkick'); fprintf(fp, [double_format, '\r\n'], lattice{i}.KickAngle(1));
        fprintf(fp, column_format, 'vkick'); fprintf(fp, [double_format, '\r\n'], lattice{i}.KickAngle(2));
    end
    if isfield(lattice{i}, 'VChamber')
        fprintf(fp, column_format, 'hmax'); fprintf(fp, [double_format, '\r\n'], abs(lattice{i}.VChamber(1)));
        fprintf(fp, column_format, 'vmax'); fprintf(fp, [double_format, '\r\n'], abs(lattice{i}.VChamber(2)));
    end
    if isfield(lattice{i}, 'T1')
        fprintf(fp, column_format, 't_in'); fprintf(fp, [double_format, ' '], lattice{i}.T1); fprintf(fp, '\r\n');
    end
    if isfield(lattice{i}, 'T2')
        fprintf(fp, column_format, 't_out'); fprintf(fp, [double_format, ' '], lattice{i}.T2); fprintf(fp, '\r\n');
    end
    if isfield(lattice{i}, 'R1')
        fprintf(fp, column_format, 'rx|r_in'); fprintf(fp, [double_format, ' '], lattice{i}.R1(1,:)); fprintf(fp, '\r\n');
        fprintf(fp, column_format, 'px|r_in'); fprintf(fp, [double_format, ' '], lattice{i}.R1(2,:)); fprintf(fp, '\r\n');
        fprintf(fp, column_format, 'ry|r_in'); fprintf(fp, [double_format, ' '], lattice{i}.R1(3,:)); fprintf(fp, '\r\n');
        fprintf(fp, column_format, 'py|r_in'); fprintf(fp, [double_format, ' '], lattice{i}.R1(4,:)); fprintf(fp, '\r\n');
        fprintf(fp, column_format, 'de|r_in'); fprintf(fp, [double_format, ' '], lattice{i}.R1(5,:)); fprintf(fp, '\r\n');
        fprintf(fp, column_format, 'dl|r_in'); fprintf(fp, [double_format, ' '], lattice{i}.R1(6,:)); fprintf(fp, '\r\n');
    end
    if isfield(lattice{i}, 'R2')
        fprintf(fp, column_format, 'rx|r_out'); fprintf(fp, [double_format, ' '], lattice{i}.R2(1,:)); fprintf(fp, '\r\n');
        fprintf(fp, column_format, 'px|r_out'); fprintf(fp, [double_format, ' '], lattice{i}.R2(2,:)); fprintf(fp, '\r\n');
        fprintf(fp, column_format, 'ry|r_out'); fprintf(fp, [double_format, ' '], lattice{i}.R2(3,:)); fprintf(fp, '\r\n');
        fprintf(fp, column_format, 'py|r_out'); fprintf(fp, [double_format, ' '], lattice{i}.R2(4,:)); fprintf(fp, '\r\n');
        fprintf(fp, column_format, 'de|r_out'); fprintf(fp, [double_format, ' '], lattice{i}.R2(5,:)); fprintf(fp, '\r\n');
        fprintf(fp, column_format, 'dl|r_out'); fprintf(fp, [double_format, ' '], lattice{i}.R2(6,:)); fprintf(fp, '\r\n');
    end
    if isfield(lattice{i}, 'PxGrid')
        [pathstr, ~, ~] = fileparts(filename);
        kicktable_filename = fullfile(pathstr, [lattice{i}.FamName, '.txt']);
        save_kicktable_file(lattice{i}, kicktable_filename);
    end
    fprintf(fp, '\r\n');
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


function print_polynom(fp, polynom, double_format)

for i=1:length(polynom)
    if polynom(i) ~= 0
        fprintf(fp, ['%i ', double_format], i-1, polynom(i));
    end
end
fprintf(fp, '\r\n');

function [PolynomA, PolynomB] = calc_polynoms(element)

selA = (element.PolynomA ~= 0);
selB = (element.PolynomB ~= 0);
order = max([find(selB, 1, 'last') find(selA, 1, 'last')]);
PolynomA = zeros(1,order);
PolynomB = zeros(1,order);
PolynomA(selA) = element.PolynomA(selA);
PolynomB(selB) = element.PolynomB(selB);

function save_kicktable_file(elem, fname)

endofline = '\r\n';
sep_char = ' ';

posx = 1000 * elem.XGrid(1,:);
posz = 1000 * elem.YGrid(:,1)';
dpsi_dx = 1 * elem.PxGrid;
dpsi_dz = 1 * elem.PyGrid;
params.factor = 1;

%fname = lower(['kicktable_' elem.FamName '.txt']);
fp = fopen(fname, 'w');
fprintf(fp, ['# ' elem.FamName ' KICKMAP' endofline] );
fprintf(fp, ['# Author: lnls_at2tracy @ LNLS, Date: ' datestr(now) endofline] );
fprintf(fp, ['# ID Length [m]' endofline] );
fprintf(fp, ['%.17E' endofline], elem.Length);
fprintf(fp, ['# Number of Horizontal Points' endofline] );
fprintf(fp, ['%i' endofline], elem.NumX);
fprintf(fp, ['# Number of Vertical Points' endofline] );
fprintf(fp, ['%i' endofline], elem.NumY);

% copy and paste do arquivo 'kickmap_save_kickmap_tables.m'

fprintf(fp,  '# Horizontal KickTable in T2m2\r\n');
fprintf(fp,  'START\r\n');
fprintf(fp, '%11s', ''); fprintf(fp, sep_char);
for i=1:length(posx)
    fprintf(fp, '%+.17E', posx(i)/1000); fprintf(fp, sep_char);
end
fprintf(fp, '\r\n');
for i=1:length(posz)
    fprintf(fp, '%+.17E', posz(i)/1000); fprintf(fp, sep_char);
    for j=1:length(posx)
        fprintf(fp, '%+.17E', params.factor * dpsi_dx(i,j)); fprintf(fp, sep_char);
    end
    fprintf(fp, '\r\n');
end

fprintf(fp,  '# Vertical KickTable in T2m2\r\n');
fprintf(fp,  'START\r\n');
fprintf(fp, '%11s', ''); fprintf(fp, sep_char);
for i=1:length(posx)
    fprintf(fp, '%+.17E', posx(i)/1000); fprintf(fp, sep_char);
end
fprintf(fp, '\r\n');
for i=1:length(posz)
    fprintf(fp, '%+.17E', posz(i)/1000); fprintf(fp, sep_char);
    for j=1:length(posx)
        fprintf(fp, '%+.17E', params.factor * dpsi_dz(i,j)); fprintf(fp, sep_char);
    end
    fprintf(fp, '\r\n');
end

fclose(fp);

