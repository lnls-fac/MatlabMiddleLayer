function epu = epu_register_points(epu0, points)


epu = epu0;

nrpts = size(points,2);

% list of all tags
p.tags = epu_get_tags_list(epu);
nrtags = length(p.tags);

p.points  = points;
nrpts = size(points,2);

p.gmatrix = zeros(3*nrpts,3*nrtags);

for j=1:length(p.tags)
    idx_block = (1 + (j-1)*3):((j-0)*3);
    blocks = epu_get_blocks_with_tag(epu, p.tags(j));
    for i=1:nrpts
        idx_point = (1+(i-1)*3):((i-0)*3);
        pos = p.points(:,i);
        
        g = zeros(3,3);
        for k=1:length(blocks.csd)
            g = g + epu_block_gmatrix(epu.csd(blocks.csd(k)),pos);
        end
        for k=1:length(blocks.cse)
            g = g + epu_block_gmatrix(epu.cse(blocks.cse(k)),pos);
        end
        for k=1:length(blocks.cie)
            g = g + epu_block_gmatrix(epu.cie(blocks.cie(k)),pos);
        end
        for k=1:length(blocks.cid)
            g = g + epu_block_gmatrix(epu.cid(blocks.cid(k)),pos);
        end
        p.gmatrix(idx_point,idx_block) = g;
    end
end


if isfield(epu, 'registered_points')
    epu.registered_points{length(epu.registered_points)+1} = p;
else
    epu.registered_points{1} = p;
end

return;



%CSD
if isfield(epu, 'csd')
    for j=1:length(epu.csd)
        tag_idx = find(epu.csd(j).tag == p.tags);
        m_j = 1+(tag_idx-1)*3;
        if ~isempty(tag_idx)
            for i=1:nrpts
                m_i = 1+(i-1)*3;
                pos = p.points(:,i);
                g = block_gmatrix(epu.csd(j),pos);
                p.gmatrix(m_i:(m_i+2), m_j:(m_j+2)) = p.gmatrix(m_i:(m_i+2), m_j:(m_j+2)) + g;
            end
        end
    end
end

%CSE
if isfield(epu, 'cse')
    for j=1:length(epu.cse)
        tag_idx = find(epu.cse(j).tag == p.tags);
        m_j = 1+(tag_idx-1)*3;
        if ~isempty(tag_idx)
            for i=1:nrpts
                m_i = 1+(i-1)*3;
                pos = p.points(:,i);
                g = block_gmatrix(epu.cse(j),pos);
                p.gmatrix(m_i:(m_i+2), m_j:(m_j+2)) = p.gmatrix(m_i:(m_i+2), m_j:(m_j+2)) + g;
            end
        end
    end
end

%CIE
if isfield(epu, 'cie')
    for j=1:length(epu.cie)
        tag_idx = find(epu.cie(j).tag == p.tags);
        m_j = 1+(tag_idx-1)*3;
        if ~isempty(tag_idx)
            for i=1:nrpts
                m_i = 1+(i-1)*3;
                pos = p.points(:,i);
                g = block_gmatrix(epu.cie(j),pos);
                p.gmatrix(m_i:(m_i+2), m_j:(m_j+2)) = p.gmatrix(m_i:(m_i+2), m_j:(m_j+2)) + g;
            end
        end
    end
end

%CID
if isfield(epu, 'cid')
    for j=1:length(epu.cid)
        tag_idx = find(epu.cid(j).tag == p.tags);
        m_j = 1+(tag_idx-1)*3;
        if ~isempty(tag_idx)
            for i=1:nrpts
                m_i = 1+(i-1)*3;
                pos = p.points(:,i);
                g = block_gmatrix(epu.cid(j),pos);
                p.gmatrix(m_i:(m_i+2), m_j:(m_j+2)) = p.gmatrix(m_i:(m_i+2), m_j:(m_j+2)) + g;
            end
        end
    end
end

if isfield(epu, 'registered_points')
    epu.registered_points{length(epu.registered_points)+1} = p;
else
    epu.registered_points{1} = p;
end