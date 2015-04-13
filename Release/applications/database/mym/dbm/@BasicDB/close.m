function a_f = close(a_f)
% CLOSE - close the connection to the database
%   close(f)

if a_f.ctx.readonly
  error('read only instance')
end

for i = 1:a_f.ctx.nParents
    a_f.ctx.parent{i} = close(a_f.ctx.parent{i});
end
mym(a_f.conInfo.id, 'close');
stop(a_f.timer);
clear(get(a_f.timer, 'Name'))
delete(a_f.timer);
a_f = [];