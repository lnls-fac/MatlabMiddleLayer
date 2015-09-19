function [Min, Mout] = uvxmatregul(matrix_filename_in, matrix_filename_out, wsh, wsv)

[Min, beam_energy, row_names, column_names] =  uvxmatload(matrix_filename_in);

bpmh = [1:5 7:25];
bpmv = 25 + bpmh;
corrh = 1:18;
corrv = 19:42;

Mh = Min(bpmh,corrh);
Mv = Min(bpmv,corrv);

[uh,sh,vh] = svd(Mh,'econ');
[uv,sv,vv] = svd(Mv,'econ');

Mh = uh*(sh.*diag(1./wsh))*vh';
Mv = uv*(sv*diag(1./wsv))*vv';

Mout = Min;
Mout(bpmh,corrh) = Mh;
Mout(bpmv,corrv) = Mv;

uvxmatsave(matrix_filename_out, Mout, beam_energy, row_names, column_names);