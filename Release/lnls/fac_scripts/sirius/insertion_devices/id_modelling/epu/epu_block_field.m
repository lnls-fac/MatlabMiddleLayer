function field  = epu_block_field(block, pos)

field = zeros(size(pos));
for n=1:size(pos,2)
    g = epu_block_gmatrix(block, pos(:,n));
    field(:,n) = g * block.mag;
end