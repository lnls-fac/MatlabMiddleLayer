function ring = lnls_add_rotation_YAW(errors, indices, ring)

% if indices is an 2D-array, transform it into a cellarray of vectors;
if isnumeric(indices)
    indices = mat2cell(indices, ones(1, size(indices,1)));
end

for i=1:length(indices)
    indcs = indices{i};
    ang = -errors(i); %positive angle follows right hand convention 
    len = sum(getcellstruct(ring, 'Length', indices(i,:)));
    idx = indcs(1);
    old_ang = ring{idx}.T1(2);
    ring{idx}.T1 = ring{idx}.T1 + [-(len/2)*ang, ang, 0, 0, 0, 0];
    idx = indcs(end);
    ring{idx}.T2 = ring{idx}.T2 + [-(len/2)*ang,-ang, 0, 0, 0, -(len/2)*((ang+old_ang)^2-old_ang^2)];
end


% function ring = lnls_add_rotation_YAW(errors, indices, ring)
% 
% if indices is an 2D-array, transform it into a cellarray of vectors;
% if isnumeric(indices)
%     indices = mat2cell(indices, ones(1, size(indices,1)));
% end
% 
% for i=1:length(indices)
%     indcs = indices{i};
%     ang = -errors(i); %positive angle follows right hand convention 
%     len = sum(getcellstruct(ring, 'Length', indices(i,:)));
%     for j=1:leng(indcs)
%         idx = indcs(j);
% for i=1:size(indices,1)
%     ang = -errors(i);
%     len = sum(getcellstruct(ring, 'Length', indices(i,:)));
%     new_error = [-(len/2)*ang ang 0 0 0 0];
%     idx = indices(i,1);
%     if (isfield(ring{idx},'T1') == 1); % checa se o campo T1 existe
%         ring{idx}.T1 = ring{idx}.T1 + new_error;
%     end
%     idx = indices(i,end);
%     if (isfield(ring{idx},'T2') == 1); % checa se o campo T1 existe
%         ring{idx}.T2 = ring{idx}.T2 - new_error;
%     end
% end
