function epu = epu_create_from_file(varargin)

epu.fnames.csd   = 'CSD@GAP22PHASE0.txt';
epu.fnames.cse   = 'CSE@GAP22PHASE0.txt';
epu.fnames.cie   = 'CIE@GAP22PHASE0.txt';
epu.fnames.cid   = 'CID@GAP22PHASE0.txt';

gap_upstream0   = 22;
gap_downstream0 = 22;
phase_csd0      = 0;
phase_cie0      = 0;

epu.csd = read_cassette(epu.fnames.csd);
epu.cse = read_cassette(epu.fnames.cse);
epu.cie = read_cassette(epu.fnames.cie);
epu.cid = read_cassette(epu.fnames.cid);


epu.gap_upstream   = gap_upstream0;
epu.gap_downstream = gap_downstream0;
epu.phase_csd      = phase_csd0;
epu.phase_cie      = phase_cie0;

epu = epu_set_config(epu, epu.gap_upstream, epu.gap_downstream, epu.phase_csd, epu.phase_cie);


epu.chamfer = 6;
% adds chamfers to all blocks
if epu.chamfer>0
    epu = create_chamfers(epu);
end

% adiciona tag único aos blocos
epu = epu_set_tags_all_blocks_independent(epu);
    


function blocks = read_cassette(fname)

% lê dados do arquivo texto
idx = 0;
blocks = struct([]);
fid = fopen(fname, 'r');
while ~feof(fid)
    tline = lower(strrep(fgetl(fid), ' ', ''));
    if ~isempty(strfind(tline, 'index')), idx = idx + 1; end;
    if ~isempty(strfind(tline, '{x,y,z}')), blocks(idx).pos = sscanf(tline, '{x,y,z}={%f,%f,%f}'); end;
    if ~isempty(strfind(tline, '{wx,wy,wz}')), blocks(idx).dim = sscanf(tline, '{wx,wy,wz}={%f,%f,%f}'); end;
    if ~isempty(strfind(tline, '{mx,my,mz}')), blocks(idx).mag = sscanf(tline, '{mx,my,mz}={%f,%f,%f}'); end;
end
fclose(fid);

% ordena blocos com posições longitudinais crescentes
pos = [blocks.pos];
[~, idx] = sort(pos(2,:));
blocks = blocks(idx);




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

