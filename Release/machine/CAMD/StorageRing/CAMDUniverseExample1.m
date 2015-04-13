
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CAMD Universe Example - Dave's Low Alpha Lattice %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load Weishi's Data
WeishiData = getuniverse;


AlphaBound     = 1e-15;
EmittanceBound = 1e-7;


% Search on emittance
i = find(WeishiData.Emittance < EmittanceBound);  


% Add a search on low alpha
j = find(WeishiData.Alpha0(i) < AlphaBound);


% Add a search on BetaX & BetaY
k = find(WeishiData.BetaXB1(i(j)) < 3 & WeishiData.BetaYB1(i(j)) < 10); 



%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load into the AT Model %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% switch to simulate mode (or use 'Model' everywhere)
switch2sim;

% Load an AT lattice
camdat;
updateatindex;
setradiation off;
setcavity off;

iLatticeVector = i(j(k));
iLatticeVector = iLatticeVector(:)';
fprintf('   %d lattices found\n', length(iLatticeVector));


% The last one looks interesting  (466760 466769 466823 look good)
% Comment this line to look at all the solutions
%iLatticeVector = iLatticeVector(end);


% Inspect the remaining solutions manually
h = figure;
for iLattice = iLatticeVector

    % Set quadrupoles
    setsp('QF',  WeishiData.QF(iLattice),  'Physics');
    setsp('QD',  WeishiData.QD(iLattice),  'Physics');
    setsp('QFA', WeishiData.QFA(iLattice), 'Physics');


    % Zero the sextupoles and skew quadrupoles
    setsp('SF', 0, 'Physics');
    setsp('SD', 0, 'Physics');

    
    figure(h);
    plottwiss;
    %modeltwiss('Beta', 'DrawLattice');

    %figure(2);
    %modeltwiss('Eta', 'DrawLattice');

    if iLattice ~= iLatticeVector(end)
        fprintf('\n   This is lattice #%d\n   Hit <return> to continue.\n', iLattice);
        pause;
    end
end
