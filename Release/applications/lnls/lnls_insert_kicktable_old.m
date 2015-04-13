function the_ring = lnls_insert_kicktable_old(the_ring0, idx_pos, file_name, nsegs, strength, famname)

    
% reads kicktable
[posx posy kickx kicky id_length] = lnls_read_kickmap_file(file_name);

% calculates indices of elements in the location of insertion
idx_dws = idx_pos+1; while any(strcmpi(the_ring0{idx_dws}.PassMethod, {'IdentityPass', 'DriftPass'})), idx_dws = idx_dws + 1; end; idx_dws = idx_dws - 1;
idx_ups = idx_pos-1; while any(strcmpi(the_ring0{idx_ups}.PassMethod, {'IdentityPass', 'DriftPass'})), idx_ups = idx_ups - 1; end; idx_ups = idx_ups + 1;
lens_ups = getcellstruct(the_ring0, 'Length', idx_ups:idx_pos);
lens_dws = getcellstruct(the_ring0, 'Length', idx_pos:idx_dws);

% builds the id flanking drifts in the line
ups_drift = the_ring0{idx_ups};
dws_drift = the_ring0{idx_dws};
ups_drift.Length = sum(lens_ups) - (id_length/2);
dws_drift.Length = sum(lens_dws) - (id_length/2);
if (ups_drift.Length < 0) || (dws_drift.Length < 0)
    error(['there is no space to insert id ' file_name ' within the defined location!']);
end


% creates building block elements (drift and kick)
drift.FamName    = [famname '_drift'];
drift.Length     = id_length / (nsegs + 1);
drift.PassMethod = 'DriftPass';
drift.Energy     = the_ring0{idx_pos}.Energy;
kickm = epukick([famname '_kicktable'], size(posx,2), size(posx,1), posx, posy, kickx, kicky, 'LNLSThinEPUPass');
kickm = buildlat(kickm);
kickm = kickm{1};
kickm.Energy = the_ring0{idx_pos}.Energy;
kickm.PxGrid = strength * kickm.PxGrid / nsegs;
kickm.PyGrid = strength * kickm.PyGrid / nsegs;
kickm.NumIntSteps = 1;

% builds id segment
id = {};
for i=1:(2*nsegs+1)
    if rem(i,2)
        % DRIFT
        elem = drift;
        if i == (nsegs + 1)
            % MIDDLE DRIFT IS SPLIT AND MARKER INSERTED
            elem.Length = elem.Length/2;
            id = [id elem the_ring0{idx_pos} elem];
        else
            id = [id drift];
        end
    else
        % KICK
        if i == (nsegs + 1)
            % MIDDLE KICK IS SPLIT AND MARKER INSERTED
            elem.PxGrid = elem.PxGrid/2;
            elem.PyGrid = elem.PyGrid/2;
            id = [id elem the_ring0{idx_pos} elem];
        else
            id = [id kickm];
        end
        
    end
end

% finally builds lattice with id
the_ring = [the_ring0(1:(idx_ups-1)) ups_drift id dws_drift the_ring0((idx_dws+1):end)];



function the_ring = lnls_insert_kicktable_original(the_ring0, idx_pos, file_name, nsegs, strength)
% insere kicktable (que corresponde a metade do ID) no modelo AT

the_ring = the_ring0;

nsegs = 2*ceil(nsegs/2); % caso nsegs seja impar

% le kicktable e cria elemento AT
[posx posy kickx kicky id_length] = read_kickmap_file(file_name);

% ATEN??O!!!
% Os mapas de kick gerados de acordo com a implementa??o MATLAB da teoria de perturba??o de Elleaume est?o
% fornecendo um desvio de sintonia intrinsico um fator 2 menor que o valor esperado de acordo com express??es
% anal?ticas! verificar a origem de discrep?ncia... por enquanto o problema ? contornado multiplicando a tabela
% de kicks por um fator 2.
% strength = 2 * strength;


epu = epukick('id', size(posx,2), size(posx,1), posx, posy, kickx, kicky, 'LNLSThinEPUPass');
epu = buildlat(epu);
epu{1}.Energy = the_ring0{idx_pos}.Energy;
epu{1}.PxGrid = strength * epu{1}.PxGrid / nsegs;
epu{1}.PyGrid = strength * epu{1}.PyGrid / nsegs;

% procura lugar para inserir: idx1 (inser??o dowstream) e idx2 (inser??o upstream)
idx1 = idx_pos+1; while strcmpi(the_ring0{idx1}.PassMethod, 'IdentityPass'), idx1 = idx1 + 1; end;
if ~strcmpi(the_ring0{idx1}.PassMethod, 'DriftPass') || (the_ring0{idx1}.Length < (id_length/2))
    error('could not find a downstream place to insert half ID');
end
idx2 = idx_pos-1; if idx2==0, idx2 = length(the_ring0); end; while strcmpi(the_ring0{idx2}.PassMethod, 'IdentityPass'), idx2 = idx2 - 1; end;
if ~strcmpi(the_ring0{idx2}.PassMethod, 'DriftPass') || (the_ring0{idx2}.Length < (id_length/2))
    error('could not find an upstream place to insert half ID');
end


HDRIFT.FamName = 'id';
HDRIFT.Length  = (id_length / nsegs) / 2;
HDRIFT.PassMethod = 'DriftPass';
HDRIFT.Energy = the_ring0{idx_pos}.Energy;


if idx2 < idx1
    
    the_ring = the_ring0(1:idx2-1);
    
    USDrift = the_ring0{idx2};   
    USDrift.Length = USDrift.Length - (id_length/2);
    the_ring = [the_ring USDrift];
        
    for i=1:(nsegs/2)
        the_ring = [the_ring HDRIFT epu(1) HDRIFT];
    end

    the_ring = [the_ring the_ring0(idx2+1:idx1-1)];

    for i=1:(nsegs/2)
        the_ring = [the_ring HDRIFT epu(1) HDRIFT];
    end
    
    DSDrift = the_ring0{idx1};   
    DSDrift.Length = DSDrift.Length - (id_length/2);
    the_ring = [the_ring DSDrift];
    
    the_ring = [the_ring the_ring0(idx1+1:end)];

else
    
    the_ring = the_ring0(1:idx1-1);
       
    for i=1:(nsegs/2)
        the_ring = [the_ring HDRIFT epu(1) HDRIFT];
    end

    DSDrift = the_ring0{idx1};   
    DSDrift.Length = DSDrift.Length - (id_length/2);
    the_ring = [the_ring DSDrift];
    
    the_ring = [the_ring the_ring0(idx1+1:idx2-1)];

    USDrift = the_ring0{idx2};   
    USDrift.Length = USDrift.Length - (id_length/2);
    the_ring = [the_ring DSDrift];
    
    for i=1:(nsegs/2)
        the_ring = [the_ring HDRIFT epu(1) HDRIFT];
    end
    
    the_ring = [the_ring the_ring0(idx2+1:end)];
    
end







