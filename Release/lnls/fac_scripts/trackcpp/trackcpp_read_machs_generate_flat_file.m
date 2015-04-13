function trackcpp_read_machs_generate_flat_file(archive_name,inicio)
%function tracy3_read_machines_generate_flat_file(archive_name)
%function tracy3_read_machines_generate_flat_file(archive_name,inicio)
%
% History
%
% 2013-05-01: Ximenes. Adicionei opção de browser pelo arquivo com máquinas aleatórias. Também adicionei rotina que shifta modelo do anel.
% 2012-??-??: Fernando. versão inicial.

if ~exist('archive_name','var')
    [FileName,path,~] = uigetfile('*.mat','select machines file',fullfile(pwd, ...
                            'cod_matlab', 'CONFIG_machines_cod_corrected.mat'));
    if isnumeric(path), return; end;
    machines = load(fullfile(path, FileName));
    cd(fullfile(path,'..','trackcpp'));
    %path = pwd;
else
    % path = '~/redes_tracy/Sirius/Sirius_v200/flat_files/AC10_test/orb_cor/';
    path = pwd;
    machines = load([path 'cod_matlab/' archive_name '.mat']);
end


[~, result] = system('ls | grep rms | wc -l');
n_pastas = str2double(result);
if(length(machines.machine) < n_pastas)
    error('inconsistent: either pwd not correct or n_pasts <> length(machines)');
elseif (length(machines.machine) > n_pastas)
    warning(['inconsistent: either pwd not correct or n_pasts <>' ...
             'length(machines). continuing...']);
end
n_pastas = min([n_pastas, length(machines.machine)]);

for i=1:n_pastas
    fprintf('machine #%03i...', i);
    flat_name = sprintf('rms%02d/flatfile_rms%02d.txt', i, i);
    full_name = flat_name;
    the_ring = machines.machine{i};
    the_ring = simplify_kicktables(the_ring);
    if exist('inicio','var')
        the_ring = start_at_first_element(the_ring, inicio);
    end
%     the_ring = modify_the_ring(machines.machine{i});
    lnls_at2flatfile(the_ring,full_name);
    fprintf('ok\n');
end

function the_ring = simplify_kicktables(the_ring_old)

the_ring = the_ring_old;
idx = findcells(the_ring, 'PxGrid');
for i = 1:length(idx)
    for j = i+1:length(idx)
        if any(the_ring{idx(j)}.XGrid ~= the_ring{idx(i)}.XGrid), continue; end;
        if any(the_ring{idx(j)}.YGrid ~= the_ring{idx(i)}.YGrid), continue; end;
        if any(the_ring{idx(j)}.PxGrid ~= the_ring{idx(i)}.PxGrid), continue; end;
        if any(the_ring{idx(j)}.PyGrid ~= the_ring{idx(i)}.PyGrid), continue; end;
        
        if length(the_ring{idx(j)}.FamName) < length(the_ring{idx(i)}.FamName)
            label = the_ring{idx(j)}.FamName;
        else
            label = the_ring{idx(i)}.FamName;
        end
        the_ring{idx(i)}.FamName = label;
        the_ring{idx(j)}.FamName = label;
    end
end



function the_ring = modify_the_ring(the_ring_old)

the_ring = the_ring_old;
idx = findcells(the_ring, 'FamName', 'IDm');
for i=1:length(idx)
    polyB = the_ring{idx(i)}.PolynomB;
    polyBnew = polyB .* (2*(rand(1,length(polyB)) - 0.5));
    the_ring{idx(i)}.PolynomB = polyBnew;
end


function the_ring = start_at_first_element(the_ring_old, famname)

idx = findcells(the_ring_old, 'FamName', famname);
the_ring = [the_ring_old(idx(1):end) the_ring_old(1:(idx(1)-1))];