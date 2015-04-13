function integrals = lnls_radiation_integrals_from_ids(ids)


twiss = calctwiss(the_ring);
for i=1:length(ids)
   length = ids(i).Length;
   period = ids(i).Period;
   Bx     = ids(i).Bx;
   By     = ids(i).By;
   idx    = ids(i).idx;
end
