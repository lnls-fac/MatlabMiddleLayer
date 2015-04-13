function lnls1_fittune(tunes, nrpts, perc)
%LNLS1_FITTUNE - ajusta sintonia, inclusive cruzando inteiros.
%
% Exemplo:
%   lnls1_fittune([5.27 2.17], 30, 0.2);

global THERING;

if ~exist('nrpts', 'var')
    nrpts = 30;
end
if ~exist('perc', 'var')
    perc = 0.2;
end

qf0 = mean(getpv('QF', 'Physics'));
qd0 = mean(getpv('QD', 'Physics'));
f = linspace(1 - perc, 1 + perc, nrpts);

c = 0;
found = false;
lnls_create_waitbar('Varrendo QF e QD', 0.10, nrpts*nrpts);
for i=1:length(f)
    for j=1:length(f)
        
        c = c + 1;
        lnls_update_waitbar(c);
        
        qf = f(i) * qf0;
        qd = f(j) * qd0;
        setpv('QF', 'Physics', qf);
        setpv('QD', 'Physics', qd);
        m = findm44(THERING, 0);
        trace_x = trace(m(1:2,1:2));
        trace_y = trace(m(3:4,3:4));
        if (trace_x < -2), continue; end;
        if (trace_x > +2), continue; end;
        if (trace_y < -2), continue; end;
        if (trace_y > +2), continue; end;
        r = atsummary;
        if (floor(r.tunes(1)) ~= floor(tunes(1))), continue; end;
        if (floor(r.tunes(2)) ~= floor(tunes(2))), continue; end;
        fract1 = tunes - floor(tunes);
        fract2 = r.tunes - floor(r.tunes);
        if ((fract1(1) < 0.5) && (fract2(1) > 0.5)), continue; end;
        if ((fract1(1) > 0.5) && (fract2(1) < 0.5)), continue; end;
        if ((fract1(2) < 0.5) && (fract2(2) > 0.5)), continue; end;
        if ((fract1(2) > 0.5) && (fract2(2) < 0.5)), continue; end;
        
        found = true;
        break;
        
    end
    
    if found, break; end;
    
end
lnls_delete_waitbar;

lnls1_symmetrize_simulation_optics(tunes, 'SimpleTuneCorrectors', 'AllSymmetries');
lnls1_symmetrize_simulation_optics(tunes, 'SimpleTuneCorrectors', 'AllSymmetries');

