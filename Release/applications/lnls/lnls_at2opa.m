function lnls_at2opa(the_ring, file_name)

endofline = '\r\n';

dP         = 1e-10;
CODeps     = 1e-6;
meth       = 4;
interp     = 1; %linear

the_ring = change_names_sirius_dipoles(the_ring);

fp = fopen(file_name, 'w');
fprintf(fp, ['{*** LNLS_AT2OPA ***}' endofline]);
fprintf(fp, [' ' endofline]);
fprintf(fp, [' ' endofline]);
fprintf(fp, ['{*** System Parameters ***}' endofline]);
fprintf(fp, ['energy = ' num2str(the_ring{1}.Energy/1e9) '; { GeV }' endofline]);
fprintf(fp, ['dP     = ' num2str(dP) '; ' endofline]);
fprintf(fp, ['CODeps = ' num2str(CODeps) '; ' endofline]);
fprintf(fp, ['meth   = ' num2str(meth) '; { integration order }' endofline]);
fprintf(fp, [' ' endofline]);

ident = calc_identity(the_ring);
uident = unique(ident);
% define FamNames únicos.
all_famnames = {};
nr_kids      = [];
max_length   = 0;
for i=1:length(uident)
    famname = the_ring{uident(i)}.FamName;
    pos = find(strcmpi(famname, all_famnames));
    if ~isempty(pos)
        nr_kids(pos) = nr_kids(pos) + 1;
    else
        pos = length(nr_kids)+1;
        nr_kids(pos) = 1;
        all_famnames{pos} = famname;
    end
    if nr_kids(pos) == 1
        newFamName = the_ring{uident(i)}.FamName;
    else
        newFamName = [the_ring{uident(i)}.FamName num2str(nr_kids(pos), '%04i')];
    end
    max_length = max([max_length length(newFamName)]);
    the_ring{uident(i)}.FamName = newFamName;
end


% gera elementos
fprintf(fp, ['{ ELEMENTS }' endofline]);
fprintf(fp, ['{ ======== }' endofline]);
nr_elems = 0;
for j=1:length(uident)
   
    i = uident(j);
    FamName = the_ring{i}.FamName;
   
    if isfield(the_ring{i}, 'Frequency')
        fprintf(fp, ['%-' int2str(max_length) 's : cavity, voltage = %f, frequency = %f, harnum = %i;' endofline], FamName, the_ring{i}.Voltage, the_ring{i}.Frequency, the_ring{i}.HarmNumber);
        nr_elems = nr_elems + 1;
        continue;
    end
    
    if strcmpi(the_ring{i}.PassMethod, 'IdentityPass')
        fprintf(fp, ['%-' int2str(max_length) 's : marker, ax = 20.00, ay = 20.00;' endofline], FamName);
        nr_elems = nr_elems + 1;
        continue;
    end
    if strcmpi(the_ring{i}.PassMethod, 'DriftPass')
        fprintf(fp, ['%-' int2str(max_length) 's : drift, l = %9.6f, ax = 20.00, ay = 20.00;' endofline], FamName, the_ring{i}.Length);
        nr_elems = nr_elems + 1;
        continue;
    end
    if isfield(the_ring{i}, 'K') && ~isfield(the_ring{i}, 'BendingAngle')
        fprintf(fp, ['%-' int2str(max_length) 's : quadrupole, l = %9.6f, k = %+9.6f, ax = 20.00, ay = 20.00;' endofline], FamName, the_ring{i}.Length, the_ring{i}.K);
        nr_elems = nr_elems + 1;
        continue;
    end
    if isfield(the_ring{i}, 'PolynomB') && ~isfield(the_ring{i}, 'K') && ~isfield(the_ring{i}, 'BendingAngle')
        fprintf(fp, ['%-' int2str(max_length) 's : sextupole, l = %9.6f, k = %+9.6f, n = %i, ax = 20.00, ay = 20.00;' endofline], FamName, the_ring{i}.Length, the_ring{i}.PolynomB(3), the_ring{i}.NumIntSteps);
        nr_elems = nr_elems + 1;
        continue;
    end
    if strcmpi(the_ring{i}.PassMethod, 'CorrectorPass')
        fprintf(fp, ['%-' int2str(max_length) 's : corrector, horizontal, method = meth;' endofline], FamName);
        nr_elems = nr_elems + 1;
        continue;
    end
    if isfield(the_ring{i}, 'BendingAngle')
        fprintf(fp, ['%-' int2str(max_length) 's : bending, l = %9.6f, t = %11.6f, k = %+9.6f, t1 = %+9.6f, t2 = %+9.6f, gap = 0.00, k1in = 0.0000, k1ex = 0.0000, k2in = 0.0000, k2ex = 0.0000, ax = 20.00, ay = 14.00;' endofline],  FamName, the_ring{i}.Length, (180/pi)* the_ring{i}.BendingAngle, the_ring{i}.PolynomB(1,2), (180/pi)* the_ring{i}.EntranceAngle, (180/pi)* the_ring{i}.ExitAngle);
        nr_elems = nr_elems + 1;
        continue;
    end
    if isfield(the_ring{i}, 'XGrid')
        fprintf(fp, ['%-' int2str(max_length) 's : insertion, n = 1, scaling1 = 0, scaling2 = 1, method = %i,' endofline], FamName, interp);
        fprintf(fp, ['file2 = "' lower(['kicktable_' FamName '.txt']) '";' endofline]);
        save_kicktable_file(the_ring{i});
        nr_elems = nr_elems + 1;
        continue;
    end
        
    fprintf('missing: %s\n', FamName);
    
end
fprintf(fp, endofline);
if nr_elems ~= length(uident)
    fprintf(['%i ~= %i: not all AT elements have been converted to TracyIII...\n'], nr_elems, length(uident));
end
     
 
fprintf(fp, ['{ RING }' endofline]);
fprintf(fp, ['{ ==== }' endofline]);     
anel = ['anel: ' endofline];
for i=1:length(the_ring)-1
    anel = [anel the_ring{ident(i)}.FamName ', '];
    if mod(i,5) == 0
        anel = [anel endofline];
    end
end
anel = [anel the_ring{ident(end)}.FamName '; '];
fprintf(fp, [anel endofline]);

fprintf(fp, ['CELL: anel, symmetry = 1;' endofline]);
fprintf(fp, ['end;' endofline]);

fclose(fp);


function the_ring = change_names_sirius_dipoles(the_ring0)

the_ring = the_ring0;
bo = findcells(the_ring, 'FamName', 'bo');
bc = findcells(the_ring, 'FamName', 'bc');
bi = findcells(the_ring, 'FamName', 'bi');
bibc = sort([bc bi]);
nr_bo   = length(bo) / 40;
nr_bibc = length(bibc) / 40;
step = 1; idx = 1; 
for i=1:length(bo)
    FamName = ['bo' num2str(idx,'%02i')];
    the_ring{bo(i)}.FamName = FamName;
    idx = idx + step;
    if idx > nr_bo, idx = nr_bo; step = -1; end;
    if idx < 1, idx = 1; step = +1; end;
end
step = 1; idx = 1; 
for i=1:length(bibc)
    FamName = ['bibc' num2str(idx,'%02i')];
    the_ring{bibc(i)}.FamName = FamName;
    idx = idx + step;
    if idx > nr_bibc, idx = nr_bibc; step = -1; end;
    if idx < 1, idx = 1; step = +1; end;
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

function save_kicktable_file(elem)

endofline = '\r\n';
sep_char = ' ';

posx = 1000 * elem.XGrid(1,:);
posz = 1000 * elem.YGrid(:,1)';
dpsi_dx = elem.PxGrid;
dpsi_dz = elem.PyGrid;
params.factor = 1;

fname = lower(['kicktable_' elem.FamName '.txt']);
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
    fprintf(fp, '%+11.8f', posx(i)/1000); fprintf(fp, sep_char);
end
fprintf(fp, '\r\n');
for i=1:length(posz)
    fprintf(fp, '%+11.8f', posz(i)/1000); fprintf(fp, sep_char);
    for j=1:length(posx)
        fprintf(fp, '%+6.3E', params.factor * dpsi_dx(i,j)); fprintf(fp, sep_char);
    end
    fprintf(fp, '\r\n');
end

fprintf(fp,  '# Vertical KickTable in T2m2\r\n');
fprintf(fp,  'START\r\n');
fprintf(fp, '%11s', ''); fprintf(fp, sep_char);
for i=1:length(posx)
    fprintf(fp, '%+11.8f', posx(i)/1000); fprintf(fp, sep_char);
end
fprintf(fp, '\r\n');
for i=1:length(posz)
    fprintf(fp, '%+11.8f', posz(i)/1000); fprintf(fp, sep_char);
    for j=1:length(posx)
        fprintf(fp, '%+6.3E', params.factor * dpsi_dz(i,j)); fprintf(fp, sep_char);
    end
    fprintf(fp, '\r\n');
end

fclose(fp);


function lnls_at2tracy_orig(the_ring, file_name)

endofline = '\r\n';

dP         = 1e-10;
CODeps     = 1e-6;
meth       = 4;
bend_nsegs = 10;
quad_nsegs = 10;
sext_nsegs = 10;
kick_nsegs = 10;


fp = fopen(file_name, 'w');
fprintf(fp, ['{*** LNLS_AT2TRACY ***}' endofline]);
fprintf(fp, [' ' endofline]);
fprintf(fp, ['define lattice;' endofline]);
fprintf(fp, [' ' endofline]);
fprintf(fp, ['{*** System Parameters ***}' endofline]);
fprintf(fp, ['Energy = ' num2str(the_ring{1}.Energy/1e9) '; { GeV }' endofline]);
fprintf(fp, ['dP     = ' num2str(dP) '; ' endofline]);
fprintf(fp, ['CODeps = ' num2str(CODeps) '; ' endofline]);
fprintf(fp, ['meth   = ' num2str(meth) '; { integration order }' endofline]);
fprintf(fp, ['nbend  = ' num2str(bend_nsegs) '; { intergration order }' endofline]);
fprintf(fp, ['nquad  = ' num2str(quad_nsegs) '; { intergration order }' endofline]);
fprintf(fp, ['nsext  = ' num2str(sext_nsegs) '; { intergration order }' endofline]);
fprintf(fp, ['nkick  = ' num2str(kick_nsegs) '; { intergration order }' endofline]);
fprintf(fp, [' ' endofline]);


% define FamNames únicos.

all_famnames = {};
nr_kids      = [];
max_length   = 0;
for i=1:length(the_ring)
    famname = the_ring{i}.FamName;
    pos = find(strcmpi(famname, all_famnames));
    if ~isempty(pos)
        nr_kids(pos) = nr_kids(pos) + 1;
    else
        pos = length(nr_kids)+1;
        nr_kids(pos) = 1;
        all_famnames{pos} = famname;
    end
    newFamName = [the_ring{i}.FamName num2str(nr_kids(pos), '%04i')];
    max_length = max([max_length length(newFamName)]);
    the_ring{i}.FamName = newFamName;
end


% gera elementos
nr_elems = 0;
for i=1:length(the_ring)
   
    FamName = the_ring{i}.FamName;
   
    if isfield(the_ring{i}, 'Frequency')
        fprintf(fp, ['%-' int2str(max_length) 's : cavity, voltage = %f, frequency = %f, harnum = %i;' endofline], FamName, the_ring{i}.Voltage, the_ring{i}.Frequency, the_ring{i}.HarmNumber);
        nr_elems = nr_elems + 1;
        continue;
    end
    
    if strcmpi(the_ring{i}.PassMethod, 'IdentityPass')
        fprintf(fp, ['%-' int2str(max_length) 's : marker;' endofline], FamName);
        nr_elems = nr_elems + 1;
        continue;
    end
    if strcmpi(the_ring{i}.PassMethod, 'DriftPass')
        fprintf(fp, ['%-' int2str(max_length) 's : drift, l = %9.6f;' endofline], FamName, the_ring{i}.Length);
        nr_elems = nr_elems + 1;
        continue;
    end
    if isfield(the_ring{i}, 'K') && ~isfield(the_ring{i}, 'BendingAngle')
        fprintf(fp, ['%-' int2str(max_length) 's : quadrupole, l = %9.6f, k = %+9.6f, n = nquad, method = meth;' endofline], FamName, the_ring{i}.Length, the_ring{i}.K);
        nr_elems = nr_elems + 1;
        continue;
    end
    if isfield(the_ring{i}, 'PolynomB') && ~isfield(the_ring{i}, 'K') && ~isfield(the_ring{i}, 'BendingAngle')
        fprintf(fp, ['%-' int2str(max_length) 's : sextupole, l = %9.6f, k = %+9.6f, n = nsext, method = meth;' endofline], FamName, the_ring{i}.Length, the_ring{i}.PolynomB(3));
        nr_elems = nr_elems + 1;
        continue;
    end
    if strcmpi(the_ring{i}.PassMethod, 'CorrectorPass')
        fprintf(fp, ['%-' int2str(max_length) 's : corrector, horizontal, method = meth;' endofline], FamName);
        nr_elems = nr_elems + 1;
        continue;
    end
    if isfield(the_ring{i}, 'BendingAngle')
        fprintf(fp, ['%-' int2str(max_length) 's : multipole, l = %9.6f, t = %11.6f, n = nbend, method = meth, ' endofline],  FamName, the_ring{i}.Length, (180/pi)* the_ring{i}.BendingAngle);
        fprintf(fp, ['hom = (' endofline]);
        for j=1:length(the_ring{i}.PolynomB)-1
            fprintf(fp, ['%i, %+15.6E, %+15.6E, ' endofline], j, the_ring{i}.PolynomB(j), the_ring{i}.PolynomA(j)); 
        end
        fprintf(fp, ['%i, %+15.6E, %+15.6E' endofline], j+1, the_ring{i}.PolynomB(j), the_ring{i}.PolynomA(j)); 
        fprintf(fp, [');' endofline]);
        fprintf(fp, endofline);
        nr_elems = nr_elems + 1;
        continue;
    end
    if isfield(the_ring{i}, 'XGrid')
        fprintf(fp, ['%-' int2str(max_length) 's : insertion, n = %i, scaling1 = 0, scaling2 = 1, method = 3,' endofline], FamName);
        fprintf(fp, ['file2 = "' ['kicktable_' FamName '.txt'] '";' endofline]);
        save_kicktable_file(the_ring{i});
        nr_elems = nr_elems + 1;
        continue;
    end
        
    fprintf('missing: %s\n', FamName);
    
end
fprintf(fp, endofline);
if nr_elems ~= length(the_ring)
    fprintf(['%i ~= %i: not all AT elements have been converted to TracyIII...\n'], nr_elems, length(the_ring));
end
     
 
     
anel = ['anel: ' endofline];
for i=1:length(the_ring)-1
    anel = [anel the_ring{i}.FamName ', '];
    if mod(i,5) == 0
        anel = [anel endofline];
    end
end
anel = [anel the_ring{end}.FamName '; '];
fprintf(fp, [anel endofline]);

fprintf(fp, ['CELL: anel, symmetry = 1;' endofline]);
fprintf(fp, ['end;' endofline]);

fclose(fp);


