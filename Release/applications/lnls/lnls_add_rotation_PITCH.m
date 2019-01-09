function ring = lnls_add_rotation_PITCH(errors, indices, ring)

% if indices is an 2D-array, transform it into a cellarray of vectors;
if isnumeric(indices)
    indices = mat2cell(indices, ones(1, size(indices,1)));
end

for i=1:length(indices)
    indcs = indices{i};
    ang = -errors(i); %positive angle follows right hand convention 
    len = sum(getcellstruct(ring, 'Length', indcs));
    idx = indcs(1);
    old_ang = ring{idx}.T1(4);
    ring{idx}.T1 = ring{idx}.T1 + [0, 0, -(len/2)*ang, ang, 0, 0];
    idx = indcs(end);
    ring{idx}.T2 = ring{idx}.T2 + [0, 0, -(len/2)*ang, -ang, 0, -(len/2)*((ang+old_ang)^2-old_ang^2)];
end


% function ring = lnls_add_rotation_PITCH(errors, indices, ring)
% 
% % if indices is an 2D-array, transform it into a cellarray of vectors;
% if isnumeric(indices)
%     indices = mat2cell(indices, ones(1, size(indices,1)));
% end
% 
% for i=1:length(indices)
%     indcs = indices{i};
%     ang = -errors(i); %positive angle follows right hand convention 
%     for j=1:length(indcs)
%         idx = indcs(j);
%         len = ring{idx}.Length;
%         new_error = [0 0 -(len/2)*ang ang 0 0];
%         if (isfield(ring{idx},'T1') == 1); % checa se o campo T1 existe
%             ring{idx}.T1 = ring{idx}.T1 + new_error;
%             ring{idx}.T2 = ring{idx}.T2 - new_error;
%         end
%     end
% end
