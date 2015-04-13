function f = saveobj(a_f)

if a_f.conInfo.secure
  error('secure mode set, cannot save')
end

f = a_f;
