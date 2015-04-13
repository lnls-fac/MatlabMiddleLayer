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

try
    AO.BPMx.AT.ATType = 'X';
    AO.BPMx.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';
    
    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = AO.BPMx.AT.ATIndex;
    AO.BPMy.Position = AO.BPMx.Position;
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

try
    
    AO.S2QD01.AT.ATType  = 'QUAD';
    AO.S2QD01.AT.ATIndex = buildatindex(AO.S2QD01.FamilyName, Indices.S2QD01);
    AO.S2QD01.Position   = findspos(THERING, AO.S2QD01.AT.ATIndex(:,1))';
    
    AO.S2QD07.AT.ATType  = 'QUAD';
    AO.S2QD07.AT.ATIndex = buildatindex(AO.S2QD07.FamilyName, Indices.S2QD07);
    AO.S2QD07.Position   = findspos(THERING, AO.S2QD07.AT.ATIndex(:,1))';
    
    AO.S2QF01.AT.ATType  = 'QUAD';
    AO.S2QF01.AT.ATIndex = buildatindex(AO.S2QF01.FamilyName, Indices.S2QF01);
    AO.S2QF01.Position   = findspos(THERING, AO.S2QF01.AT.ATIndex(:,1))';
    
    AO.S2QF02.AT.ATType  = 'QUAD';
    AO.S2QF02.AT.ATIndex = buildatindex(AO.S2QF02.FamilyName, Indices.S2QF02);
    AO.S2QF02.Position   = findspos(THERING, AO.S2QF02.AT.ATIndex(:,1))';
    
    AO.S2QF03.AT.ATType  = 'QUAD';
    AO.S2QF03.AT.ATIndex = buildatindex(AO.S2QF03.FamilyName, Indices.S2QF03);
    AO.S2QF03.Position   = findspos(THERING, AO.S2QF03.AT.ATIndex(:,1))';
    
    AO.S2QF04.AT.ATType  = 'QUAD';
    AO.S2QF04.AT.ATIndex = buildatindex(AO.S2QF04.FamilyName, Indices.S2QF04);
    AO.S2QF04.Position   = findspos(THERING, AO.S2QF04.AT.ATIndex(:,1))';
    
    AO.S2QF07.AT.ATType  = 'QUAD';
    AO.S2QF07.AT.ATIndex = buildatindex(AO.S2QF07.FamilyName, Indices.S2QF07);
    AO.S2QF07.Position   = findspos(THERING, AO.S2QF07.AT.ATIndex(:,1))';
    
    AO.S2QF08.AT.ATType  = 'QUAD';
    AO.S2QF08.AT.ATIndex = buildatindex(AO.S2QF08.FamilyName, Indices.S2QF08);
    AO.S2QF08.Position   = findspos(THERING, AO.S2QF08.AT.ATIndex(:,1))';
    
    AO.S2QF09.AT.ATType  = 'QUAD';
    AO.S2QF09.AT.ATIndex = buildatindex(AO.S2QF09.FamilyName, Indices.S2QF09);
    AO.S2QF09.Position   = findspos(THERING, AO.S2QF09.AT.ATIndex(:,1))';
    
    
catch
    warning('QUAD family not found in the model.');
end



try
    
    AO.S4SF.AT.ATType = 'SEXT';
    AO.S4SF.AT.ATIndex = buildatindex(AO.S4SF.FamilyName, Indices.S4SF);
    AO.S4SF.Position = findspos(THERING, AO.S4SF.AT.ATIndex(:,1))';
    
    AO.S4SD.AT.ATType = 'SEXT';
    AO.S4SD.AT.ATIndex = buildatindex(AO.S4SD.FamilyName, Indices.S4SD);
    AO.S4SD.Position = findspos(THERING, AO.S4SD.AT.ATIndex(:,1))';
    
catch
    warning('SEXT families not found in the model.');
end


try
    
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, Indices.BEND);
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex(:,1))';
    
catch
    warning('BEND family not found in the model.');
end


% RF Cavity
try
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
catch
    warning('RF cavity not found in the model.');
end

% Kickers
try
    AO.KICKER.AT.ATType = 'Kicker';
    AO.KICKER.AT.ATIndex = findcells(THERING,'KICKER')';
    AO.KICKER.AT.ATIndex = buildatindex(AO.KICKER.FamilyName, Indices.KICKER);
    AO.KICKER.Position = findspos(THERING, AO.KICKER.AT.ATIndex(:,1))';
catch
    warning('KICKER family not found in the model.');
end


setao(AO);



% Set TwissData at the start of the storage ring
try
    % BTS twiss parameters at the input
    TwissData.alpha = [0 0]';
    TwissData.beta  = [15.6475 0.7037]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0 0 0 0]';
    
    %setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
catch
     warning('Setting the twiss data parameters in the MML failed.');
end
