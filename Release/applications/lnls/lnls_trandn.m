function r = lnls_trandn(size, ncutoff)
% gera vetor [1..size] com erro gaussiano aleatorio truncado em ncutoff sigmas
r=randn(1,size);
r=r(r<ncutoff & r>-ncutoff);
while (length(r) < size)
    r1=randn(1,size);
    r1=r1(r1<ncutoff & r1>-ncutoff);
    r=[r, r1];
end
r = r(1:size);
