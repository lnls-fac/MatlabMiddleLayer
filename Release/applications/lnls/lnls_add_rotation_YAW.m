function new_ring = lnls_add_rotation_YAW(errors, indices, old_ring)

new_ring = old_ring;

for i=1:size(indices,1)
    ang = -errors(i);
%     if size(indices,2) ~= 1
%         disp('ok');
%     end
    len = sum(getcellstruct(new_ring, 'Length', indices(i,:)));
    for j=1:size(indices,2)
        idx = indices(i,j);
        if (j == 1)
            new_ring{idx}.T1 = new_ring{idx}.T1 + [-(len/2)*ang ang 0 0 0 0];
        end
        if (j == size(indices,2))
            new_ring{idx}.T2 = new_ring{idx}.T2 - [-(len/2)*ang ang 0 0 0 0];
        end
    end
end


% function new_ring = lnls_add_rotation_YAW(errors, indices, old_ring)
% 
% new_ring = old_ring;
% 
% for i=1:size(indices,1)
%     ang = -errors(i);
%     len = sum(getcellstruct(new_ring, 'Length', indices(i,:)));
%     new_error = [-(len/2)*ang ang 0 0 0 0];
%     idx = indices(i,1);
%     if (isfield(new_ring{idx},'T1') == 1); % checa se o campo T1 existe
%         new_ring{idx}.T1 = new_ring{idx}.T1 + new_error;
%     end
%     idx = indices(i,end);
%     if (isfield(new_ring{idx},'T2') == 1); % checa se o campo T1 existe
%         new_ring{idx}.T2 = new_ring{idx}.T2 - new_error;
%     end
% end
