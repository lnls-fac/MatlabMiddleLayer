function p = tableParent(a_f, a_n, varargin)
% COLLPARENT - return an BasicDB object connected to the parent
%   p = tableParent(f, n) return the BasicDB objects connected to
%     the parent n of f.

if numel(a_f.ctx.parent)==0
  error('this collection has no parent')
end

p = a_f.ctx.parent{a_n};
if any(strcmp(varargin, 'WRITE_ENABLE'))
  p.ctx.readonly = false;
else
  p.ctx.readonly = true;
end