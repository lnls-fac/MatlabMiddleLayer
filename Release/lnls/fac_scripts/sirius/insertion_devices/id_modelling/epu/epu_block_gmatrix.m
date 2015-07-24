function G  = epu_block_gmatrix(block, pos)

if isfield(block, 'subblocks')
    subblocks = block.subblocks;
else
    subblocks.mag_factor = 1;
    subblocks.pos_delta  = [0 0 0]';
    subblocks.dim        = block.dim;
end

G = zeros(3,3);
pos = block.rotc + block.rotm \ (pos - block.rotc);

for m=1:length(subblocks)
    
    ctr = block.pos + subblocks(m).pos_delta;
    dim = subblocks(m).dim;
    
    pl  = pos - ctr;

    r = [-pl - dim/2, -pl + dim/2];
    r(r==0) = 1e-12;
    
%     rx = [r(1,1),r(1,1),r(1,1),r(1,1),r(1,2),r(1,2),r(1,2),r(1,2)];
%     ry = [r(2,1),r(2,1),r(2,2),r(2,2),r(2,1),r(2,1),r(2,2),r(2,2)];
%     rz = [r(3,1),r(3,2),r(3,1),r(3,2),r(3,1),r(3,2),r(3,1),r(3,2)];
%     s1 = [1,-1,-1,1,-1,1,1,-1];
%     s2 = [-1,1,1,-1,1,-1,-1,1];
%     t = sqrt(rx .* rx + ry .* ry + rz .* rz);
%     qxx = s1 * atan(ry .* rz ./ (rx .* t))';
%     qxy = s2 * log(rz + t)';
%     qxz = s2 * log(ry + t)';
%     qyy = s1 * atan(rx .* rz ./ (ry .* t))';
%     qyz = s2 * log(rx + t)';
%     qzz = s1 * atan(ry .* rx ./ (rz .* t))';
    
    qxx = 0;
    qxy = 0;
    qxz = 0;
    qyy = 0;
    qyz = 0;
    qzz = 0;    
    for i=0:1
        for j=0:1
            for k=0:1
                rix = r(1,i+1);
                rjy = r(2,j+1);
                rkz = r(3,k+1);
                if bitand(i+j+k,1), s1=-1; else s1=1; end;
                if bitand(i+j+k+1,1), s2=-1; else s2=1; end;
                t = sqrt(rix * rix + rjy * rjy + rkz * rkz);
                qxx = qxx + s1 * atan(rjy * rkz / (rix * t));
                qxy = qxy + s2 * log(rkz + t);
                qxz = qxz + s2 * log(rjy + t);
                qyy = qyy + s1 * atan(rix * rkz / (rjy * t));
                qyz = qyz + s2 * log(rix + t);
                qzz = qzz + s1 * atan(rjy * rix / (rkz * t));
            end
        end
    end
    G = G + [ qxx, qxy, qxz; qxy, qyy, qyz; qxz, qyz, qzz] * subblocks(m).mag_factor;
end
G = block.rotm * G / (4*pi);



