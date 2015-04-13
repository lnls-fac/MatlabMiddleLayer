function lnls_at2tracyflat(ring, flat_name)
%lnls_at2tracyflat(ring,flat_name) gera um arquivo flat_file 
%com nome flat_name do tracy3 a partir do modelo do anel ring do AT.
%
%O c???digo ainda pode ser otimizado para ganho de velocidade.
%
%Ximenes - 2013-01-11 - Implementado elemento KickMap
%Fernando - 2012-08-22

if ~ischar(flat_name)
    error('o segundo argumento deve ser uma string')
end

%defini??????o dos tipos de dispositivos
marker    = -1;
drift     = 0;
mpole     = 1;
cavity    = 2;
corrector = 3;
thin_kick = 3;
%wiggler   = 4;
insertion = 6;

%defini??????o do PassMethod
meth_mpole     = 4;
meth_corrector = 4;
meth_thin_kick = 4;
meth_drift     = 0;
meth_cavity    = 0;
meth_marker    = 0;
meth_kicktable = 1;

%Organizar as famílias de acordo com a ordem que elas aparecem no modelo
ring = find_Families(ring);

[path flat_name ext] = fileparts(flat_name);

flat_name = fullfile(path,['flat_file_' flat_name ext]);
mfile = fopen(flat_name, 'w');

Ele.FamName = 'begin';
Ele.VChamber = ring{1}.VChamber;
prtName(mfile, 0, drift, meth_drift, Ele,0, 0);
fprintf(mfile, ' %23.16e\n', 0);

kicktable_saved = {};

for i = 1:length(ring)
     Fnum = ring{i}.Fnum;
     Knum = ring{i}.Knum;
    switch ring{i}.PassMethod
        case 'DriftPass'
            prtName(mfile, i, drift, meth_drift, ring{i},Knum, Fnum);
            fprintf(mfile, ' %23.16e\n', ring{i}.Length);
        case {'BndMPoleSymplectic4Pass','BndMPoleSymplectic4RadPass'}
            prtName(mfile, i, mpole, meth_mpole, ring{i},Knum, Fnum);
            [PdTpar PdTerr]=isskew(ring{i});
            fprintf(mfile, ' %23.16e %23.16e %23.16e %23.16e\n', -ring{i}.T1(1),...
                -ring{i}.T1(3), PdTpar, PdTerr);
            fprintf(mfile, ' %23.16e %23.16e %23.16e %23.16e %23.16e\n',...
                ring{i}.Length, ring{i}.BendingAngle/ring{i}.Length, ring{i}.EntranceAngle*(180/pi),...
                ring{i}.ExitAngle*(180/pi), ring{i}.FullGap);
            prtHOM(mfile, 1, ring{i});
            
        case {'StrMPoleSymplectic4Pass','StrMPoleSymplectic4RadPass'}
                prtName(mfile, i, mpole, meth_mpole, ring{i},Knum, Fnum);
                [PdTpar PdTerr]=isskew(ring{i});
                fprintf(mfile, ' %23.16e %23.16e %23.16e %23.16e\n', -ring{i}.T1(1),...
                    -ring{i}.T1(3), PdTpar, PdTerr);
                fprintf(mfile, ' %23.16e %23.16e %23.16e %23.16e %23.16e\n',...
                    ring{i}.Length, 0, 0, 0, 0);
                if isfield(ring{i},'K'),n_design=2;else n_design=3;end
                prtHOM(mfile, n_design, ring{i});
        case {'CavityPass' 'IdentityPass'}
            if isfield(ring{i},'Voltage')
                prtName(mfile, i, cavity, meth_cavity, ring{i},Knum, Fnum);
                fprintf(mfile, ' %23.16e %23.16e %d %23.16e\n', ring{i}.Voltage/ring{i}.Energy, ...
                2*pi*ring{i}.Frequency / 299792458, ring{i}.HarmNumber, ring{i}.Energy);
            else
                prtName(mfile, i, marker, meth_marker, ring{i},Knum, Fnum);
            end
        case 'CorrectorPass'
            if ring{i}.Length == 0
                prtName(mfile, i, corrector, meth_corrector, ring{i}, Knum, Fnum);
                fprintf(mfile, ' %23.16e %23.16e %23.16e\n', 0, 0, 0);
                fprintf(mfile, '  %2d %2d\n', 1,0);
                fprintf(mfile, '%3d %23.16e %23.16e\n', 1, -ring{i}.KickAngle(1), ring{i}.KickAngle(2));
            else
                if (ring{i}.KickAngle(1) ~= 0 || ring{i}.KickAngle(2) ~= 0)
                    error('corretor com comprimento não nulo está ligado');
                    return;
                end
                prtName(mfile, i, drift, meth_drift, ring{i},Knum, Fnum);
                fprintf(mfile, ' %23.16e\n', ring{i}.Length);
            end
        case 'ThinMPolePass'
            prtName(mfile, i, thin_kick, meth_thin_kick, ring{i}, Knum, Fnum);
            [PdTpar PdTerr]=isskew(ring{i});
            fprintf(mfile, ' %23.16e %23.16e %23.16e\n', -ring{i}.T1(1),...
                -ring{i}.T1(3), PdTerr);
            if ring{i}.PolynomB(2) ~= 0, n_design=2; else n_design=3;end
            prtHOM(mfile, n_design, ring{i});
        case 'LNLSThinEPUPass'
            prtName(mfile, i, insertion, meth_kicktable, ring{i}, Knum, Fnum);
            kicktable_filename = lower([ring{i}.FamName '.txt']);
            fprintf(mfile, ' 1.0 2 %s\n', kicktable_filename);
            kick_fullname = fullfile(path, kicktable_filename);
            if ~any(strcmpi(kicktable_saved, kicktable_filename))
                save_kicktable_file(ring{i}, kick_fullname);
                kicktable_saved{end+1} = kicktable_filename;
            end
%             if ~(exist(kick_fullname,'file') == 2);
%                 save_kicktable_file(ring{i}, kick_fullname);
%             end
        case 'LNLSThickEPUPass'
            prtName(mfile, i, insertion, meth_kicktable, ring{i}, Knum, Fnum);
            kicktable_filename = lower([ring{i}.FamName '.txt']);
            fprintf(mfile, ' 1.0 2 %s\n', kicktable_filename);
            kick_fullname = fullfile(path, kicktable_filename);
            if ~any(strcmpi(kicktable_saved, kicktable_filename))
                save_kicktable_file(ring{i}, kick_fullname);
                kicktable_saved{end+1} = kicktable_filename;
            end
%             if ~(exist(kick_fullname,'file') == 2);
%                 save_kicktable_file(ring{i}, kick_fullname);
%             end
        otherwise
            fprintf(mfile, 'prtmfile: unknown type\n');
            
    end
end
fclose(mfile);
end

function prtName(fp, i, type, method, Elem, Knum, Fnum)

try
    N=Elem.NumIntSteps;
catch
    N=0;
end
fprintf(fp, '%-15s %4ld %4ld %4d\n', Elem.FamName, Fnum, Knum, i);
fprintf(fp, ' %3d %3d %3d\n', type, method, N);
if isfield(Elem, 'VChamber')
    fprintf(fp, ' %23.16e %23.16e %23.16e %23.16e\n', -Elem.VChamber(1),...
        Elem.VChamber(1), -Elem.VChamber(2), Elem.VChamber(2));
else
    fprintf(fp, ' %23.16e %23.16e %23.16e %23.16e\n', 0, 0, 0, 0);
end

end

    

function ring = find_Families(ring)

Fam = {ring{1}.FamName};
ring{1}.Fnum = 1;
ring{1}.Knum = 1;
Knums = [1];
for j=2:length(ring)
    vec = strcmp(Fam,ring{j}.FamName);
    if ~any(vec)
        Fam{end+1}=ring{j}.FamName;
        ring{j}.Fnum = length(Fam);
        ring{j}.Knum = 1;
        Knums(end+1) = 1;
    else
        ind = find(vec,1);
        ring{j}.Fnum = ind;
        Knums(ind) = Knums(ind) + 1;
        ring{j}.Knum = Knums(ind);
    end
end
end

function [PdTpar PdTerr] = isskew(Elem)

R1 = Elem.R1;

theta = asin(R1(1,3));
if abs((theta - pi/4))>pi/2
    PdTpar = 45;
    PdTerr = (theta - pi/4)*180/pi;
else
    PdTpar = 0;
    PdTerr = theta*180/pi;
end
end

function prtHOM(fp, n_design, Elem)
nmpole = 0;
for i = 1:max(length(Elem.PolynomB),length(Elem.PolynomA))
    if ((Elem.PolynomB(i) ~= 0.0) || (Elem.PolynomA(i) ~= 0.0))
        nmpole = nmpole + 1;
    end
end

fprintf(fp, '  %2d %2d\n', nmpole,n_design);

for i = 1:max(length(Elem.PolynomB),length(Elem.PolynomA))
    if ((Elem.PolynomB(i) ~= 0.0) || (Elem.PolynomA(i) ~= 0.0))
        fprintf(fp, '%3d %23.16e %23.16e\n', i, Elem.PolynomB(i), Elem.PolynomA(i));
    end
end

end



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
fprintf(fp, ['%16.10E' endofline], elem.Length);
fprintf(fp, ['# Number of Horizontal Points' endofline] );
fprintf(fp, ['%i' endofline], elem.NumX);
fprintf(fp, ['# Number of Vertical Points' endofline] );
fprintf(fp, ['%i' endofline], elem.NumY);

% copy and paste do arquivo 'kickmap_save_kickmap_tables.m'

fprintf(fp,  '# Horizontal KickTable in T2m2\r\n');
fprintf(fp,  'START\r\n');
fprintf(fp, '%11s', ''); fprintf(fp, sep_char);
for i=1:length(posx)
    fprintf(fp, '%+22.15E', posx(i)/1000); fprintf(fp, sep_char);
end
fprintf(fp, '\r\n');
for i=1:length(posz)
    fprintf(fp, '%+22.15E', posz(i)/1000); fprintf(fp, sep_char);
    for j=1:length(posx)
        fprintf(fp, '%+22.15E', params.factor * dpsi_dx(i,j)); fprintf(fp, sep_char);
    end
    fprintf(fp, '\r\n');
end

fprintf(fp,  '# Vertical KickTable in T2m2\r\n');
fprintf(fp,  'START\r\n');
fprintf(fp, '%11s', ''); fprintf(fp, sep_char);
for i=1:length(posx)
    fprintf(fp, '%+22.15E', posx(i)/1000); fprintf(fp, sep_char);
end
fprintf(fp, '\r\n');
for i=1:length(posz)
    fprintf(fp, '%+22.15E', posz(i)/1000); fprintf(fp, sep_char);
    for j=1:length(posx)
        fprintf(fp, '%+22.15E', params.factor * dpsi_dz(i,j)); fprintf(fp, sep_char);
    end
    fprintf(fp, '\r\n');
end

fclose(fp);

end
