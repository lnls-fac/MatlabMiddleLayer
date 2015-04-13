function [pos vel] = lnls_build_ref_orbit(the_ring, FamName)
%
% build reference trajectory from model's benging angles
%
% Algorithm: for each model element
%
% Input: 
%   r     : [x;z] initial position
%   t     : initial tangential vector
%   ang   : deflection angle of element
%   len   : element length
%  FamName: family data of elements used to define origin (average)
%
% Output:
%
% If Drift (BendingAngle == 0),
%   
%   r   = r + len * t
%
% else
%
%   n   = R(pi/2) * t
%   rho = len / ang
%   rc  = r - rho * n
%
%   r   = rc + R(ang) * rho * n
%   t   = R(ang) * t

local_pos = [0; 0]; local_vel = [0; 1];
pos = zeros(2,length(the_ring)); vel = zeros(2,length(the_ring));
for i=1:length(the_ring)
    ele = the_ring{i};
    pos(:,i) = local_pos; vel(:,i) = local_vel;
    %plot(pos(2,:),pos(1,:));
    local_len = ele.Length;
    if isfield(ele, 'BendingAngle')
        local_ang = -ele.BendingAngle;
    else
        local_ang = 0;
    end
    if (local_ang == 0)
        local_pos = local_pos + local_vel * local_len;
    else
        local_n    = [0 1; -1 0] * local_vel;
        local_rho  = abs(local_len / local_ang);
        local_vrho = local_rho * local_n;
        local_rc   = local_pos - local_vrho;
        local_mr   = [cos(local_ang) sin(local_ang); -sin(local_ang) cos(local_ang)] ;
        local_pos  = local_rc + local_mr * local_vrho;
        local_vel  = local_mr * local_vel;
    end
end

if exist('FamName', 'var')
    idx = findcells(the_ring, 'FamName', FamName);
    r_center = mean(pos(:,idx),2);
    pos = pos - repmat(r_center, 1, size(pos,2));
end
