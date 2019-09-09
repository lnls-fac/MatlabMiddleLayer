function [xhystr, fhystr] = pso_optics_bo(boinj, param, param_err, fam_tb, niter)
    quads = set_quads(fam_tb);
    nquad = length(quads);
    % 10 TB quadrupoles + PosAng X and Y + Kicker
    dim = nquad;
    
    w = 0.7984;
    c1 = 1.49618;
    c2 =  c1;
    
    npart = 10 + 2 * round(sqrt(dim));
    k_max = 1;
    % dr_max = 0*500e-6;
        
    self.upper_limits = k_max .* ones(1, dim);
    self.lower_limits = -k_max .* ones(1, dim);
    % self.upper_limits(nquad+1:end) = dr_max .* ones(1, 5);
    % self.lower_limits(nquad+1:end) = -dr_max .* ones(1, 5);
    
    dlim = self.upper_limits - self.lower_limits;
       
    for d = 1:dim    
        for i = 1:npart-1
            x0(i, d) = dlim(d) * rand() + self.lower_limits(d);
            v0(i, d) = 0;
            pbest(i, d) = x0(i, d);
        end
    end
    x0(npart, :) = zeros(1, dim);
    % x0(npart, nquad+1:end) = [-0.001530308464829,-0.003000000000000,0.000903508669571,-0.001731329498844,0.002075658545458]';
    v0(npart, :) = 0;
    pbest(npart, :) = x0(npart, :);
    
    for i = 1:npart
        f_old(i) = fig_merit(boinj, param, param_err, quads, squeeze(x0(i, :)));
    end
    
    [~, imin] = min(f_old);
    gbest = repmat(squeeze(x0(imin, :)), npart, 1);
    fprintf('Best Figure of Merit %f \n', min(f_old) * 100)
    xhystr = zeros(niter+1, dim);
    fhystr = zeros(1, niter+1);
    fhystr(1) = min(f_old) * 100;
    xhystr(1, :) = squeeze(pbest(imin, :));
    
    for k = 1:niter
       for i = 1:npart
          r1 = rand();
          r2 = rand();
          v_ind(i, :) = pbest(i, :) - x0(i, :);
          v_col(i, :) = gbest(i, :) - x0(i, :);
          v0(i, :) = w .* v0(i, :) + (c1 * r1) .* v_ind(i, :) + (c2 * r2) .* v_col(i, :);
          x0(i, :) = x0(i, :) + v0(i, :);
          x0(i, :) = set_lim(self, x0(i, :));
          f_new(i) = fig_merit(boinj, param, param_err, quads, squeeze(x0(i, :)));

          if f_new(i) < f_old(i)
             pbest(i, :) = x0(i, :);
             f_old(i) = f_new(i);
          end
       end
       
       [~, imin] = min(f_new);
       gbest = repmat(squeeze(pbest(imin, :)), npart, 1);
       fprintf('Iteraction number %i \n', k)
       fprintf('Best Figure of Merit %f \n', min(f_old) * 100)
       fhystr(k+1) = min(f_old) * 100;
       xhystr(k+1, :) = squeeze(pbest(imin, :));
    end
    figure; plot(fhystr, '-o');
end

function quad = set_quads(fam_tb)
    quad = zeros(1, 10);
    % quad = zeros(1, 4);
    quad(1) = fam_tb.QD1.ATIndex;
    quad(2) = fam_tb.QF1.ATIndex;
    quad(3) = fam_tb.QD2A.ATIndex;
    quad(4) = fam_tb.QF2A.ATIndex;
    quad(5) = fam_tb.QF2B.ATIndex;
    quad(6) = fam_tb.QD2B.ATIndex;
    quad(7) = fam_tb.QF3.ATIndex;
    quad(8) = fam_tb.QD3.ATIndex;
    quad(9) = fam_tb.QF4.ATIndex;
    quad(10) = fam_tb.QD4.ATIndex;
end

function v_out = set_lim(self, v_in)
    v_out = v_in;
    up = v_in > self.upper_limits;
    down = v_in < self.lower_limits;
    v_out(up) = self.upper_limits(up);
    v_out(down) = self.lower_limits(down);    
end

function eff = fig_merit(boinj, param, param_err, quads, x0)

    for i = 1:length(quads)
       boinj{quads(i)}.PolynomB(1, 2) = boinj{quads(i)}.PolynomB(1, 2) + x0(i);
    end

    twi_bo.Dispersion = [0.293505142477652, 0.069387251695544, 0, 0]';
    twi_bo.beta = [14.862153708188764, 7.926776530246586]';
    twi_bo.alpha = [-3.452278560066768, 1.426353021465548]';

    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 2.71462, 4.69925]';
    IniCond.alpha = [ -2.34174, 1.04009]';
    IniCond.mu = [0, 0]';
    IniCond.ClosedOrbit = [0.0, 0.0, 0.0, 0.0]';
    IniCond.SPos = 0;
    IniCond.ElemIndex = 1;
    
    sept = findcells(boinj, 'FamName', 'InjSept');

    twi_pso = twissline(boinj(1:sept(end)), 0, IniCond, 'chrom');
    
    dif.beta = twi_bo.beta - twi_pso.beta';
    dif.alpha = twi_bo.alpha - twi_pso.alpha';
    dif.Dispersion = twi_bo.Dispersion - twi_pso.Dispersion;
    b = sum(dif.beta .* dif.beta);
    a = sum(dif.alpha .* dif.alpha);
    n = sum(dif.Dispersion .* dif.Dispersion);

    eff = sqrt(b + a + n);
end