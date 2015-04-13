function field = epu_field(epu, varargin)

if isempty(varargin)
    field = epu_field_registered_points(epu);
else
    field = epu_field_nonregistered_points(epu, varargin{1});
end

function field = epu_field_registered_points(epu)

for i=1:length(epu.registered_points)
    mag1 = epu_get_mag(epu, epu.registered_points{i}.tags);
    mag2 = reshape(mag1, [], 1);
    f = epu.registered_points{i}.gmatrix * mag2;
    field{i} = reshape(f, 3, []);
end

function field = epu_field_nonregistered_points(epu, pos)

field = zeros(size(pos));

for i=1:length(epu.csd)
    field = field + epu_block_field(epu.csd(i), pos);
end
for i=1:length(epu.cse)
    field = field + epu_block_field(epu.cse(i), pos);
end
for i=1:length(epu.cie)
    field = field + epu_block_field(epu.cie(i), pos);
end
for i=1:length(epu.cid)
    field = field + epu_block_field(epu.cid(i), pos);
end
