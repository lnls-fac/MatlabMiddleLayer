function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)


global THERING


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded


% Sort by family first (findcells is linear and slow)
Indices = atindex(THERING);


AO = getao;


% BPM
try
    AO.BPMx.AT.ATType = 'X';
    AO.BPMx.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';

    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';
catch
    warning('BPM family not found in the model.');
end

try
    % Horizontal correctors are at every AT corrector
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.HCM);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';

    % Not all correctors are vertical correctors
    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, Indices.VCM);
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end


% QUADRUPOLES
try
    AO.Q1.AT.ATType = 'QUAD';
    AO.Q1.AT.ATIndex = buildatindex(AO.Q1.FamilyName, Indices.Q1);
    AO.Q1.Position = findspos(THERING, AO.Q1.AT.ATIndex(:,1))';

    AO.Q2.AT.ATType = 'QUAD';
    AO.Q2.AT.ATIndex = buildatindex(AO.Q2.FamilyName, Indices.Q2);
    AO.Q2.Position = findspos(THERING, AO.Q2.AT.ATIndex(:,1))';

    AO.Q3.AT.ATType = 'QUAD';
    AO.Q3.AT.ATIndex = buildatindex(AO.Q3.FamilyName, Indices.Q3);
    AO.Q3.Position = findspos(THERING, AO.Q3.AT.ATIndex(:,1))';

    AO.Q4.AT.ATType = 'QUAD';
    AO.Q4.AT.ATIndex = buildatindex(AO.Q4.FamilyName, Indices.Q4);
    AO.Q4.Position = findspos(THERING, AO.Q4.AT.ATIndex(:,1))';

    AO.Q5.AT.ATType = 'QUAD';
    AO.Q5.AT.ATIndex = buildatindex(AO.Q5.FamilyName, Indices.Q5);
    AO.Q5.Position = findspos(THERING, AO.Q5.AT.ATIndex(:,1))';

    AO.CQS.AT.ATType = 'SKEWQUAD';
    AO.CQS.AT.ATIndex = buildatindex(AO.CQS.FamilyName, Indices.CQS);
    AO.CQS.Position = findspos(THERING, AO.CQS.AT.ATIndex(:,1))';
catch
    warning('Quadrupole family not found in the model.');
end


% SEXTUPOLES
try
    % S1
    AO.S1.AT.ATType = 'SEXT';
    AO.S1.AT.ATIndex = buildatindex(AO.S1.FamilyName, Indices.S1);
    AO.S1.Position = findspos(THERING, AO.S1.AT.ATIndex(:,1))';

    % S2
    AO.S2.AT.ATType = 'SEXT';
    AO.S2.AT.ATIndex = buildatindex(AO.S2.FamilyName, Indices.S2);
    AO.S2.Position = findspos(THERING, AO.S2.AT.ATIndex(:,1))';

    % S3
    AO.S3.AT.ATType = 'SEXT';
    AO.S3.AT.ATIndex = buildatindex(AO.S3.FamilyName, Indices.S3);
    AO.S3.Position = findspos(THERING, AO.S3.AT.ATIndex(:,1))';
    
    % S4
    AO.S4.AT.ATType = 'SEXT';
    AO.S4.AT.ATIndex = buildatindex(AO.S4.FamilyName, Indices.S4);
    AO.S4.Position = findspos(THERING, AO.S4.AT.ATIndex(:,1))';
catch
    warning('Sextupole families not found in the model.');
end


% BEND
try
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, Indices.BEND(:));
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex(:,1))';
catch
    warning('BEND family not found in the model.');
end


% RF Cavity
try
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING, 'Frequency');
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(1,1))';
catch
    warning('RF cavity not found in the model.');
end


setao(AO);



% Set TwissData at the start of the storage ring
try   
    % BTS twiss parameters at the input 
    TwissData.alpha = [0 0]';
    TwissData.beta  = [19.1131 3.1781]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0 0 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
catch
     warning('Setting the twiss data parameters in the MML failed.');
end

