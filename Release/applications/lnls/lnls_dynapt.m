function r = lnls_dynapt(the_ring, varargin)
% r = lnls_dynapt(varargin)
%
% Calculo de separatriz da abertura dinamica
%
% Inputs 
%
% the_ring            : modelo da rede para o calculo da abertura dinamica
%  
% (struct):
% 'energy_deviation'  : vector com valores de desvio de anergia para calculo de abertura dinamica. Uma separatriz para cada elemento deste vetor;
% 'radius_resolution' : resolucao radial para calculo da separatriz.
% 'nr_turns'          : numero de voltas no tracking.
% 'points_angle'      : matriz com angulos no espaco XY para calculo da separatriz (uma linha para cada desvio de energia)
% 'points_radius'     : matriz com raios iniciais no espaco XY para calculo da separatriz (uma linha para cada desvio de energia)
% 'quiet_mode'        : caso seja true, nenhum display dos calculos sera feito.
%
% Output:
%
% 'points_radius'    : matrix com raios finais no espaco XY para calculo da separatriz (uma linha para cada desvio de energia)
% 'points_x'         : matrix com posicao horizontal dos pontos da separatriz no espaco XY (uma linha para cada desvio de energia)
% 'points_y'         : matrix com posicao vertical dos pontos da separatriz no espaco XY (uma linha para cada desvio de energia)
% 'da_area'          : vetor com areas das aberturas dinamicas (um elemento por valor de desvio de energia).
%
% Historia:
%
% 2012-01-24 Corrigido problema com valores default de points_angle points_radius (X.R.R.)
% 2011-08-26 Primeira versao organizada e comentada (X.R.R.)

%dbstop in lnls_dynapt at 106

if ~isempty(varargin)
    r = varargin{1};
else
    r = struct;
end

if ~isfield(r, 'energy_deviation')
    fprintf('lnls_dynapt: missing ''energy_deviation'' field! Using default value ...\n');
    r.energy_deviation = 0;
end
if ~isfield(r, 'radius_resolution')
    fprintf('lnls_dynapt: missing ''radius_resolution'' field! Using default value ...\n');
    r.radius_resolution = 0.25 / 1000;
end
if ~isfield(r, 'nr_turns')
    fprintf('lnls_dynapt: missing ''nr_turns'' field! Using default value ...\n');
    r.nr_turns = 512;
end
if ~isfield(r, 'points_angle')
    fprintf('lnls_dynapt: missing ''points_angle'' field! Using default value ...\n');
    r.points_angle = repmat(linspace(0,pi,21), length(r.energy_deviation), 1);
end
if ~isfield(r, 'points_radius')
    fprintf('lnls_dynapt: missing ''points_radius'' field! Using default value ...\n');
    r.points_radius = repmat((15/1000) * ones(size(r.points_angle)), length(r.energy_deviation), 1);
end

if isfield(r, 'quiet_mode') && r.quiet_mode 
    quiet_mode = true;
else
    quiet_mode = false;
end


% caso um novo conjunto de angulos seja especifica interpola r(theta) a
% partir da separatrix antiga
if isfield(r, 'new_points_angle')
    for i=1:length(r.energy_deviation)
        points_radius(i,:) = interp1(r.points_angle(i,:), r.points_radius(i,:), r.new_points_angle(i,:));
        points_angle(i,:) = r.new_points_angle(i,:);
    end
    r.points_radius = points_radius;
    r.points_angle = points_angle;
    r = rmfield(r, 'new_points_angle');
end
        
try
    r = rmfield(r, {'points_x','points_y'});
catch
end

for i=1:length(r.energy_deviation)
    if ~quiet_mode, fprintf('Energy Deviation %f %%\n', 100*r.energy_deviation(i)); end;
    r.points_radius(i,:) = update_radius(the_ring, r.points_angle(i,:), r.points_radius(i,:), r.radius_resolution, r.energy_deviation(i), r.nr_turns, quiet_mode);
    r.da_area(i) = get_dynapt_area(r.points_angle(i,:), r.points_radius(i,:));
    xy = get_points(r.points_angle(i,:), r.points_radius(i,:),r.energy_deviation(i));
    r.points_x(i,:) = xy(1,:);
    r.points_y(i,:) = xy(3,:);
end

function area = get_dynapt_area(angles, radius)

dangles = diff(angles);
r1 = radius(1:end-1);
r2 = radius(2:end);
area = 1e6 * sum(r1(:) .* r2(:) .* sin(dangles(:))/2);

function radius = update_radius(the_ring, angles, radius0, radius_tol, delta_energy, nr_turns, quiet_mode)

radius = radius0;

status = '?' * ones(1,length(angles));

r = radius(:);
idx = 1;
selection = 1:length(angles);
if ~quiet_mode, fprintf('----------------\n'); end;
while true
    drawnow;
    pause(0.01);
    
    if idx>1000
        fprintf('problem!\n');
    end
    
    if size(r,2) > 2
        inc = find(r(:,end) >= r(:,end-1));
        dec = find(r(:,end) <= r(:,end-1));
        status = ' ' * ones(1,length(angles));
        status(intersect(inc,selection)) = '+';
        status(intersect(dec,selection)) = '-'; 
    end
    if ~quiet_mode, fprintf('%03i: %03i | %s\n', idx, length(selection), char(status)); end;
    
    idx = idx + 1;
    p = get_points(angles, radius, delta_energy);
    rf = ringpass(the_ring, p(:,selection), nr_turns);
    drawnow; sleep(0);
    rf = rf(:,(end - length(selection) + 1):end);
    lossflag = any(~isfinite(rf));
    out_idx = find(lossflag);
    ins_idx = find(~lossflag);
    radius(selection(ins_idx)) = radius(selection(ins_idx)) + radius_tol;
    radius(selection(out_idx)) = radius(selection(out_idx)) - radius_tol;
    
    % pode ser que o raio seja menor que o delta...
    neg_set = radius < 0;
    radius(neg_set) = 0;
    
    if size(r,2)>=2
        not_selected = setdiff(1:length(angles), selection);
        radius(not_selected) = r(not_selected,end-1); 
    end;
    %plot_dynapt(angles, radius);
    %drawnow;
    r = [r radius(:)];
   
    if (size(r,2)>2)
        selection = find((r(:,end) ~= r(:,end-2)));
        if isempty(selection), break; end;
        %if (sum(abs(r(:,end) - r(:,end-2))) == 0), break; end;
    end
end
status = ' ' * ones(1,length(angles));
if ~quiet_mode
    fprintf('%03i: %03i | %s\n', idx, length(selection), char(status));
    fprintf('----------------\n')
end
radius = min(r(:,[end-1 end])');

function r = get_points(angles, radius, delta_energy)

r = zeros(6,length(angles));
r(1,:) = radius(:)' .* cos(angles(:)');
r(3,:) = radius(:)' .* sin(angles(:)');
r(5,:) = delta_energy;
