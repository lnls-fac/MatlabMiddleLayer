function lnls_twiss_save2file(the_ring, fname)

twiss = calctwiss(the_ring);
pos   = findspos(the_ring, 1:length(the_ring));
len   = getcellstruct(the_ring, 'Length', 1:length(the_ring));
ats   = atsummary(the_ring);

fp = fopen(fname, 'w');
fprintf(fp, '#I1  %+.6e\n', ats.integrals(1));
fprintf(fp, '#I2  %+.6e\n', ats.integrals(2));
fprintf(fp, '#I3  %+.6e\n', ats.integrals(3));
fprintf(fp, '#I4  %+.6e\n', ats.integrals(4));
fprintf(fp, '#I5  %+.6e\n', ats.integrals(5));
fprintf(fp, '#I6  %+.6e\n', ats.integrals(6));
fprintf(fp, '#MCF %+.6e\n', ats.compactionFactor);
for i=1:length(pos)
    fprintf(fp, '%20s %25s %.6e %.6e ', the_ring{i}.FamName, the_ring{i}.PassMethod, pos(i), len(i));
    fprintf(fp, '%.4e %.4e %+.4e %+.4e %+.4e ', twiss.mux(i), twiss.betax(i), twiss.alphax(i), twiss.etax(i), twiss.etaxl(i));
    fprintf(fp, '%.4e %.4e %+.4e %+.4e %+.4e ', twiss.muy(i), twiss.betay(i), twiss.alphay(i), twiss.etay(i), twiss.etayl(i));
    fprintf(fp, '\n');
end





