function epu = epu_create(params)

cassette_separation = params.cassette_separation;
magnetic_gap = params.magnetic_gap;
nr_periods = params.nr_periods;
period = params.period;
block_separation = params.block_separation;
block_width  = params.block_width;
block_height = params.block_height;
block_length = (period/4) - block_separation;
phase_csd = params.phase_csd;
phase_cie = params.phase_cie;
chamfer0 = params.chamfer;
magnetization = params.magnetization;

epu.gap_upstream   = magnetic_gap;
epu.gap_downstream = magnetic_gap;
epu.phase_csd      = phase_csd;
epu.phase_cie      = phase_cie;
epu.chamfer        = chamfer0;

mags_CSD = {[0; 0; 1]; [0;  1; 0]; [0; 0; -1;]; [0; -1; 0]};
mags_CSE = {[0; 0; 1]; [0;  1; 0]; [0; 0; -1;]; [0; -1; 0]};
mags_CIE = {[0; 0; 1]; [0; -1; 0]; [0; 0; -1;]; [0;  1; 0]};
mags_CID = {[0; 0; 1]; [0; -1; 0]; [0; 0; -1;]; [0;  1; 0]};

% CSD
idx = 0;
posx = (block_width + cassette_separation) / 2;
posz = (block_height + magnetic_gap) / 2;
blocks = struct([]);
for i=1:nr_periods
    idx = idx + 1;
    posy = i * period + 0 * (period/4) + phase_csd;
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CSD{1};
    idx = idx + 1;
    posy = i * period + 1 * (period/4) + phase_csd;
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CSD{2};
    idx = idx + 1;
    posy = i * period + 2 * (period/4) + phase_csd;
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CSD{3};
    idx = idx + 1;
    posy = i * period + 3 * (period/4) + phase_csd;
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CSD{4};
end
epu.csd = blocks;


% CSE
idx = 0;
posx = -(block_width + cassette_separation) / 2;
posz = (block_height + magnetic_gap) / 2;
blocks = struct([]);
for i=1:nr_periods
    idx = idx + 1;
    posy = i * period + 0 * (period/4);
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CSE{1};
    idx = idx + 1;
    posy = i * period + 1 * (period/4);
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CSE{2};
    idx = idx + 1;
    posy = i * period + 2 * (period/4);
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CSE{3};
    idx = idx + 1;
    posy = i * period + 3 * (period/4);
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CSE{4};
end
epu.cse = blocks;

% CIE
idx = 0;
posx = -(block_width + cassette_separation) / 2;
posz = -(block_height + magnetic_gap) / 2;
blocks = struct([]);
for i=1:nr_periods
    idx = idx + 1;
    posy = i * period + 0 * (period/4) + phase_cie;
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CIE{1};
    idx = idx + 1;
    posy = i * period + 1 * (period/4) + phase_cie;
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CIE{2};
    idx = idx + 1;
    posy = i * period + 2 * (period/4) + phase_cie;
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CIE{3};
    idx = idx + 1;
    posy = i * period + 3 * (period/4) + phase_cie;
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CIE{4};
end
epu.cie = blocks;

% CID
idx = 0;
posx = (block_width + cassette_separation) / 2;
posz = -(block_height + magnetic_gap) / 2;
blocks = struct([]);
for i=1:nr_periods
    idx = idx + 1;
    posy = i * period + 0 * (period/4);
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CID{1};
    idx = idx + 1;
    posy = i * period + 1 * (period/4);
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CID{2};
    idx = idx + 1;
    posy = i * period + 2 * (period/4);
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CID{3};
    idx = idx + 1;
    posy = i * period + 3 * (period/4);
    blocks(idx).pos = [posx; posy; posz];
    blocks(idx).dim = [block_width; block_length; block_height];
    blocks(idx).mag = magnetization * mags_CID{4};
end
epu.cid = blocks;

% centraliza EPU na longitudinal
rotm = diag([1;1;1]);
pos = sum([epu.csd.pos] + [epu.cse.pos] + [epu.cie.pos] + [epu.cid.pos], 2) / (length(epu.csd) + length(epu.cse) + length(epu.cie) + length(epu.cid));
for i=1:length(epu.csd)
    epu.csd(i).pos(2) = epu.csd(i).pos(2) - pos(2); 
    epu.csd(i).rotc = [0;0;0];
    epu.csd(i).rotm = rotm;
end;
for i=1:length(epu.cse)
    epu.cse(i).pos(2) = epu.cse(i).pos(2) - pos(2); 
    epu.cse(i).rotc = [0;0;0];
    epu.cse(i).rotm = rotm;
end;
for i=1:length(epu.cie)
    epu.cie(i).pos(2) = epu.cie(i).pos(2) - pos(2);
    epu.cie(i).rotc = [0;0;0];
    epu.cie(i).rotm = rotm;
end;
for i=1:length(epu.cid)
    epu.cid(i).pos(2) = epu.cid(i).pos(2) - pos(2);
    epu.cid(i).rotc = [0;0;0];
    epu.cid(i).rotm = rotm;
end;

epu = epu_set_config(epu, epu.gap_upstream, epu.gap_downstream, epu.phase_csd, epu.phase_cie);

% adds chamfers to all blocks
if epu.chamfer>0
    epu = create_chamfers(epu);
end

% adiciona tag �nico aos blocos
epu = epu_set_tags_all_blocks_independent(epu);
    



function epu = create_chamfers(epu0)

epu = epu0;

if isfield(epu, 'csd'), epu = rmfield(epu, 'csd'); end;
if isfield(epu, 'cse'), epu = rmfield(epu, 'cse'); end;
if isfield(epu, 'cie'), epu = rmfield(epu, 'cie'); end;
if isfield(epu, 'cid'), epu = rmfield(epu, 'cid'); end;

%CSD
if isfield(epu0, 'csd')
    for i=1:length(epu0.csd)
        b0 = epu0.csd(i);
        b = b0;
        b = rmfield(b, 'dim');
        % main subblock
        sb.mag_factor = 1;
        sb.pos_delta  = [0 0 0]';
        sb.dim        = b0.dim;
        b.subblocks(1) = sb;
        % first chamfer
        sb.mag_factor = -1*0;
        sb.pos_delta  = [(b0.dim(1)-epu0.chamfer)/2 0 -(b0.dim(3)-epu0.chamfer)/2]';
        sb.dim        = [epu0.chamfer b0.dim(2) epu.chamfer]';
        b.subblocks(2) = sb;
        % second chamfer
        sb.mag_factor = -1*0;
        sb.pos_delta  = [-(b0.dim(1)-epu0.chamfer)/2 0 (b0.dim(3)-epu0.chamfer)/2]';
        sb.dim        = [epu0.chamfer b0.dim(2) epu.chamfer]';
        b.subblocks(3) = sb;
        % adds block to new epu
        epu.csd(i) = b;
    end
end

%CSE
if isfield(epu0, 'cse')
    for i=1:length(epu0.cse)
        b0 = epu0.cse(i);
        b = b0;
        b = rmfield(b, 'dim');
        % main subblock
        sb.mag_factor = 1;
        sb.pos_delta  = [0 0 0]';
        sb.dim        = b0.dim;
        b.subblocks(1) = sb;
        % first chamfer
        sb.mag_factor = -1*0;
        sb.pos_delta  = [(b0.dim(1)-epu0.chamfer)/2 0 (b0.dim(3)-epu0.chamfer)/2]';
        sb.dim        = [epu0.chamfer b0.dim(2) epu.chamfer]';
        b.subblocks(2) = sb;
        % second chamfer
        sb.mag_factor = -1*0;
        sb.pos_delta  = [-(b0.dim(1)-epu0.chamfer)/2 0 -(b0.dim(3)-epu0.chamfer)/2]';
        sb.dim        = [epu0.chamfer b0.dim(2) epu.chamfer]';
        b.subblocks(3) = sb;
        % adds block to new epu
        epu.cse(i) = b;
    end
end

%CIE
if isfield(epu0, 'cie')
    for i=1:length(epu0.cie)
        b0 = epu0.cie(i);
        b = b0;
        b = rmfield(b, 'dim');
        % main subblock
        sb.mag_factor = 1;
        sb.pos_delta  = [0 0 0]';
        sb.dim        = b0.dim;
        b.subblocks(1) = sb;
        % first chamfer
        sb.mag_factor = -1*0;
        sb.pos_delta  = [-(b0.dim(1)-epu0.chamfer)/2 0 (b0.dim(3)-epu0.chamfer)/2]';
        sb.dim        = [epu0.chamfer b0.dim(2) epu.chamfer]';
        b.subblocks(2) = sb;
        % second chamfer
        sb.mag_factor = -1*0;
        sb.pos_delta  = [(b0.dim(1)-epu0.chamfer)/2 0 -(b0.dim(3)-epu0.chamfer)/2]';
        sb.dim        = [epu0.chamfer b0.dim(2) epu.chamfer]';
        b.subblocks(3) = sb;
        % adds block to new epu
        epu.cie(i) = b;
    end
end

%CID
if isfield(epu0, 'cid')
    for i=1:length(epu0.cid)
        b0 = epu0.cid(i);
        b = b0;
        b = rmfield(b, 'dim');
        % main subblock
        sb.mag_factor = 1;
        sb.pos_delta  = [0 0 0]';
        sb.dim        = b0.dim;
        b.subblocks(1) = sb;
        % first chamfer
        sb.mag_factor = -1*0;
        sb.pos_delta  = [-(b0.dim(1)-epu0.chamfer)/2 0 -(b0.dim(3)-epu0.chamfer)/2]';
        sb.dim        = [epu0.chamfer b0.dim(2) epu.chamfer]';
        b.subblocks(2) = sb;
        % second chamfer
        sb.mag_factor = -1*0;
        sb.pos_delta  = [(b0.dim(1)-epu0.chamfer)/2 0 (b0.dim(3)-epu0.chamfer)/2]';
        sb.dim        = [epu0.chamfer b0.dim(2) epu.chamfer]';
        b.subblocks(3) = sb;
        % adds block to new epu
        epu.cid(i) = b;
    end
end

