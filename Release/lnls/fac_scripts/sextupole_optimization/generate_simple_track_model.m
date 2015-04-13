function nr_sectors = generate_simple_track_model

global THERING;

% eliminates all IdentityPass elements and unsued correctors
ip_idx = findcells(THERING, 'PassMethod', 'IdentityPass');
cm_idx = findcells(THERING, 'KickAngle', [0 0]);
exclude_elements = sort([ip_idx cm_idx]);
THERING(exclude_elements) = [];

% converts non-used elements into drift spaces
qd1_idx = findcells(THERING, 'PassMethod', 'QuadLinearPass');
qd2_idx = findcells(THERING, 'K', 0);
qd_idx  = intersect(qd1_idx, qd2_idx);
THERING = setcellstruct(THERING, 'PassMethod', qd_idx, 'DriftPass');


% merges all adjacent equivalent elements
i = 1;
while (i <= length(THERING))
    if (i + 1 <= length(THERING))
        if (strcmpi(THERING{i+1}.PassMethod,'DriftPass') && strcmpi(THERING{i}.PassMethod, 'DriftPass'))
            THERING{i}.Length = THERING{i}.Length + THERING{i+1}.Length;
            THERING(i+1) = [];
        elseif ( ...
                strcmpi(THERING{i+1}.PassMethod,'StrMPoleSymplectic4Pass') && strcmpi(THERING{i}.PassMethod, 'StrMPoleSymplectic4Pass') && ...
                all(THERING{i+1}.PolynomA == THERING{i}.PolynomA) && all(THERING{i+1}.PolynomB == THERING{i}.PolynomB) ...
                )
            THERING{i}.Length = THERING{i}.Length + THERING{i+1}.Length;
            THERING(i+1) = [];
        else
            i = i + 1;
        end
    else
        i = i + 1;
    end
end


% if first and last elements are drifspaces creates equivalent DS in the
% beginning of THERING (usefull for identifying symmetries)
if (strcmpi(THERING{1}.PassMethod,'DriftPass') && (strcmpi(THERING{end}.PassMethod,'DriftPass')))
    THERING{1}.Length = THERING{1}.Length + THERING{end}.Length;
    THERING(end) = [];
end

% finds the symmetry of the lattice
lens = getcellstruct(THERING, 'Length', 1:length(THERING));
for nr_sectors=length(THERING)-1:-1:1
    if mod(length(THERING),nr_sectors) == 0
        lens_matrix = reshape(lens, length(THERING)/nr_sectors, nr_sectors);
        stdv = std(lens_matrix,0,2);
        if all(abs(stdv) < 1e-9)
            break;
        end;
    end
end
    
% return one symmetry cell
THERING((length(THERING)/nr_sectors)+1:end) = [];