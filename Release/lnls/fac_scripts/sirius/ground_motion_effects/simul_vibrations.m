function simul_vibrations

p.mode = 'AC20';
p.coupling = 1 * 0.01;
p.nr_machines = 100;

p.rmsx_withingirders = 20 * 1e-9; % m
p.rmsy_withingirders = 20 * 1e-9; % m

p.rmsx_withinmagnets = 0 * 1e-9; % m
p.rmsy_withinmagnets = 0 * 1e-9; % m

p.the_ring = sirius_lattice_girder3(p.mode);

%p.the_ring = single_segment_bc(p.the_ring);
p = find_girders(p);
p = calc_amplification_matrix(p);
p = calc_correlation_matrix(p);

function p = calc_correlation_matrix(p0)

p = p0;

p.error_x = zeros(1,length(p.the_ring));
p.error_y = zeros(1,length(p.the_ring));

% generates erros
for i=1:length(p.girders)
    for j=1:size(p.girders(i).idx, 1)
       
        % horizontal
        mux = normrnd(0, p.rmsx_withingirders);
        vax = normrnd(mux, p.rmsx_withinmagnets, 1, size(p.girders(i).idx, 2));
        p.girders(i).ampx_mu(j) = mux;
        p.girders(i).ampx_va(j,:) = vax;
        
        % vertical
        muy = normrnd(0, p.rmsy_withingirders);
        vay = normrnd(muy, p.rmsy_withinmagnets, 1, size(p.girders(i).idx, 2));
        p.girders(i).ampy_mu(j) = muy;
        p.girders(i).ampy_va(j,:) = vay;  
        
        p.error_x(p.girders(i).idx(j,:)) = vax;
        p.error_y(p.girders(i).idx(j,:)) = vay;
        
        fprintf([p.girders(i).name num2str(j, '(%03i)') ' - avgx:%+6.1f nm, stdx:%+6.1f nm, avgy:%+6.1f nm, stdy:%+6.1f nm\n'], 1e9*mux, 1e9*std(vax), 1e9*muy, 1e9*std(vay));  
        
    end
end

% applies errors to correlation matrix
p.Cx = p.error_x' * p.error_x;
p.Cy = p.error_y' * p.error_y;

function p = find_girders(p0)

p = p0;
p.girders = [];

% gets names of girders
fnames = unique(getcellstruct(p.the_ring, 'FamName', 1:length(p.the_ring)));
for i=1:length(fnames)
    if ~isempty(strfind(fnames{i}, 'girder'))
        p.girders(end+1).name = fnames{i};
    end
end

% gets indices of elements on each girder
for i=1:length(p.girders)
    idx = findcells(p.the_ring, 'FamName', p.girders(i).name);
    idx = reshape(idx, 2, [])';
    p.girders(i).idx = zeros(size(idx,1), idx(1,2)-idx(1,1)-1);
    for j=1:size(idx,1)
        p.girders(i).idx(j,:) = idx(j,1)+1:idx(j,2)-1;
    end
end

%% AUX FUNCTIONS

function p = calc_amplification_matrix(p0)

p = p0;

delta_pos = 1e-6;

cod0 = findorbit4(p.the_ring, 0, 1:length(p.the_ring));

Ax = zeros(length(p.the_ring), length(p.the_ring));
Ay = zeros(length(p.the_ring), length(p.the_ring));
lnls_create_waitbar('Calc respm...', 0.1, length(p.the_ring));
for i=1:length(p.the_ring)
    
    new_ring = p.the_ring;
    new_ring = lattice_errors_set_misalignmentX(delta_pos, i, new_ring);
    cod = findorbit4(new_ring, 0, 1:length(new_ring));
    Ax(i,:) = (cod(1,:) - cod0(1,:)) / delta_pos;
    
    new_ring = p.the_ring;
    new_ring = lattice_errors_set_misalignmentY(delta_pos, i, new_ring);
    cod = findorbit4(new_ring, 0, 1:length(new_ring));
    Ay(i,:) = (cod(3,:) - cod0(3,:)) / delta_pos;
    
    lnls_update_waitbar(i);
    
end
lnls_delete_waitbar;

p.Ax = Ax;
p.Ay = Ay;

function new_ring = single_segment_bc(the_ring)

bc = findcells(the_ring, 'FamName', 'bc');
bc = reshape(bc, 2, [])';
new_ring  = the_ring;
for i=1:size(bc,1)
    new_ring{bc(i,1)}.BendingAngle = 2 * new_ring{bc(i,1)}.BendingAngle;
    new_ring{bc(i,1)}.ExitAngle = new_ring{bc(i,1)}.EntranceAngle;
end
new_ring(bc(:,2)) = [];

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


    
    
