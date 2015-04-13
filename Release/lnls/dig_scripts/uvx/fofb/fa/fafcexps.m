function [fadata_array, corr_iddata, bpm_iddata] = fafcexps(fadata, start, npts_exp, npts_interval)

i = 1;

fadata_array{i} = facutdata(fadata, start + (0:npts_exp-1),[],[]);
[corr_iddata{i}, bpm_iddata{i}] = fa2iddata(fadata_array{i});
i=i+1;

for j=1:42
    fadata_array{i} = facutdata(fadata, j*(npts_exp +npts_interval) + start + (0:npts_exp-1),[],j);
    [corr_iddata{i}, bpm_iddata{i}] = fa2iddata(fadata_array{i});
    i=i+1;
end