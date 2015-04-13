function f = loadobj(a_f)

class_name = class(a_f);
f = eval([class_name '(a_f)']);
f.ctx = a_f.ctx;