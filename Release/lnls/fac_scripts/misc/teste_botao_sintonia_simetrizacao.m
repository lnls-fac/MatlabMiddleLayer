function teste_botao_sintonia_simetrizacao

global THERING

r = lnls1_symmetrize_simulation_optics([5.19 4.17], 'QuadFamily', 'BEDI');
r = lnls1_symmetrize_simulation_optics([5.19 4.17], 'QuadFamily', 'BEDI');
r = lnls1_symmetrize_simulation_optics([5.19 4.17], 'QuadFamily', 'BEDI');
r = lnls1_symmetrize_simulation_optics([5.19 4.17], 'SimpleTuneCorrector', 'BEDI');
%r = lnls1_symmetrize_simulation_optics([5.19 4.17], 'QuadFamily', 'BEDI');
m = r.TuneCorrMatrix;

tune1 = gettune;
deltaTune = [0.02; 0.02];
dk = m * deltaTune;
for i=1:length(r.Quads)
    k1 = getcellstruct(THERING, 'K', r.Quads{i});
    k = k1 + dk(i);
    THERING = setcellstruct(THERING, 'K', r.Quads{i}, k);
    THERING = setcellstruct(THERING, 'PolynomB', r.Quads{i}, k, 1, 2);
end
tune2 = gettune;
disp(tune1);
disp(tune2);
