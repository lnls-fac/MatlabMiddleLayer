function G  = epu_block_gmatrix(block, pos)

if isfield(block, 'subblocks')
    subblocks = block.subblocks;
else
    subblocks.mag_factor = 1;
    subblocks.pos_delta  = [0 0 0]';
    subblocks.dim        = block.dim;
end

G = zeros(3,3);

if ~isfield('block','rotc'), block.rotc = [0;0;0]; end;
if ~isfield('block','rotm'), block.rotm = diag([1;1;1]); end;

pos = block.rotc + block.rotm \ (pos - block.rotc);


for m=1:length(subblocks)
    
    ctr = block.pos + subblocks(m).pos_delta;
    dim = subblocks(m).dim;
    
    pl  = pos - ctr;
    qxx = 0;
    qxy = 0;
    qxz = 0;
    qyy = 0;
    qyz = 0;
    qzz = 0;
    r(:,1) = -pl - dim/2;
    r(:,2) = -pl + dim/2;
    
    for i=0:1
        for j=0:1
            for k=0:1
                rix = r(1,i+1);
                rjy = r(2,j+1);
                rkz = r(3,k+1);
                if (rix == 0), rix = 1e-12; end;
                if (rjy == 0), rjy = 1e-12; end;
                if (rkz == 0), rkz = 1e-12; end;
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
    G0 = [ ...
        qxx qxy qxz; ...
        qxy qyy qyz; ...
        qxz qyz qzz; ...
        ];
    G = G + G0 * subblocks(m).mag_factor;
end
G = G / (4*pi);

G = block.rotm * G;



