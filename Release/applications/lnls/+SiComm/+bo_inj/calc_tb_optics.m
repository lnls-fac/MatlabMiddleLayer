function calc_tb_optics()
    sirius('TB')
    % Lattice with gradient added at septum
    tb_lattice = sirius_tb_lattice_sept();
    
    % Booster optics at injection point
    TD.Dispersion = [0.293505142477652, 0.069387251695544, 0, 0]';
    % Invert signal of ds to perform reverse propagation
    TD.Dispersion(2) = -TD.Dispersion(2);
    TD.beta = [14.862153708188764, 7.926776530246586]';
    TD.alpha = [-3.452278560066768, 1.426353021465548]';
    % Invert signal of ds to perform reverse propagation
    TD.alpha = - TD.alpha;
    TD.mu = [0, 0]';
    TD.ClosedOrbit = [0.0, 0.0, 0.0, 0.0]';
    TD.SPos = 0;
    TD.ElemIndex = 1;
    
    bInjS = findcells(tb_lattice, 'FamName', 'bInjS');
    eInjS = findcells(tb_lattice, 'FamName', 'eInjS');
    % Reverse propagation to determine the optics at septum entrance
    % considering the gradient to match Booster optics
    twi = twissline(tb_lattice(bInjS:eInjS), 0, TD, 'chrom', 1e-8);
    
    twi.mu = [0, 0];
    twi.ClosedOrbit = [0.0, 0.0, 0.0, 0.0]';
    twi.ElemIndex = 1;
    twi.SPos = 0;
    twi.alpha = - twi.alpha;
    twi.Dispersion(2) = -twi.Dispersion(2);
    % save twi_rev_sept.mat twi
    fprintf('================================== \n')
    fprintf('OPTICS AT BOOSTER SEPTUM BEGINNING \n')
    fprintf('================================== \n')
    fprintf('Beta X %f m | Beta Y %f m \n', twi.beta(1), twi.beta(2)); 
    fprintf('Alpha X %f | Alpha Y %f \n', twi.alpha(1), twi.alpha(2));
    fprintf('Eta X %f m  | Eta Xl %f \n', twi.Dispersion(1), twi.Dispersion(2));
    
    % Uses that condition to re-propagate and check the difference from
    % Booster optics
    twi_inj_bo = twissline(tb_lattice(bInjS:eInjS), 0, twi, 'chrom', 1e-8);
    
    fprintf('========================================== \n')
    fprintf('DIFFERENCES OF OPTICS AT BOOSTER INJECTION \n')
    fprintf('========================================== \n')
    fprintf('Diff Beta X %f %%\n', (TD.beta(1) - twi_inj_bo.beta(1))/TD.beta(1)*100);
    fprintf('Diff Beta Y %f %%\n', (TD.beta(2) - twi_inj_bo.beta(2))/TD.beta(2)*100);
    fprintf('Diff Alpha X %f %%\n', (TD.alpha(1) + twi_inj_bo.alpha(1))/TD.alpha(1)*100);
    fprintf('Diff Alpha Y %f %%\n', (TD.alpha(2) + twi_inj_bo.alpha(2))/TD.alpha(2)*100);
    fprintf('Diff Eta X %f %%\n', (TD.Dispersion(1) - twi_inj_bo.Dispersion(1))/TD.Dispersion(1)*100);
    fprintf('Diff Eta Xl %f %% \n', (TD.Dispersion(2) + twi_inj_bo.Dispersion(2))/TD.Dispersion(2)*100);    
end

