function new_ring = lnls_add_rotation_PITCH(errors, indices, old_ring)

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
            new_ring{idx}.T1 = new_ring{idx}.T1 + [0 0 -(len/2)*ang ang 0 0];
        end
        if (j == size(indices,2))
            new_ring{idx}.T2 = new_ring{idx}.T2 - [0 0 -(len/2)*ang ang 0 0];
        end
    end
end


% function new_ring = lnls_add_rotation_PITCH(errors, indices, old_ring)
% 
% new_ring = old_ring;
% 
% for i=1:size(indices,1)
%     ang = -errors(i);
%     for j=1:size(indices,2)
%         idx = indices(i,j);
%         len = new_ring{idx}.Length;
%         new_error = [0 0 -(len/2)*ang ang 0 0];
%         if (isfield(new_ring{idx},'T1') == 1); % checa se o campo T1 existe
%             new_ring{idx}.T1 = new_ring{idx}.T1 + new_error;
%             new_ring{idx}.T2 = new_ring{idx}.T2 - new_error;
%         end
%     end
% end
