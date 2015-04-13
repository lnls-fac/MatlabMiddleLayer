function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)


global THERING


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded

AO = getao;

% BPMS
try
    AO.BPMx.AT.ATType  = 'X';
    AO.BPMx.AT.ATIndex = findcells(THERING, 'FamName', 'BPM')';
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';
catch
    warning('BPMx family not found in the model.');
end

try
    AO.BPMy.AT.ATType  = 'Y';
    AO.BPMy.AT.ATIndex = findcells(THERING, 'FamName', 'BPM')';
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';
catch
    warning('BPMy family not found in the model.');
end


% CORRECTORS
try
    AO.HCM.AT.ATType  = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, 'HCM');
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex)';
catch
    warning('HCM family not found in the model.');
end

try
    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, 'VCM');
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex)';
catch
    warning('VCM family not found in the model.');
end


% QUADRUPOLES
try
    AO.QF.AT.ATType = 'QUAD';
    AO.QF.AT.ATIndex = buildatindex(AO.QF.FamilyName, 'QF');
    AO.QF.Position = findspos(THERING, AO.QF.AT.ATIndex(:,1))';
catch
    warning('QF family not found in the model.');
end

try
    AO.QD.AT.ATType = 'QUAD';
    AO.QD.AT.ATIndex = buildatindex(AO.QD.FamilyName, 'QD');
    AO.QD.Position = findspos(THERING, AO.QD.AT.ATIndex(:,1))';
catch
    warning('QD family not found in the model.');
end

try
    AO.QFA.AT.ATType = 'QUAD';
    AO.QFA.AT.ATIndex = buildatindex(AO.QFA.FamilyName, 'QFA');
    AO.QFA.Position = findspos(THERING, AO.QFA.AT.ATIndex(:,1))';
catch
    warning('QFA family not found in the model.');
end


% SEXTUPOLES
try
    AO.SF.AT.ATType = 'SEXT';
    AO.SF.AT.ATIndex = buildatindex(AO.SF.FamilyName, 'SF');
    AO.SF.Position = findspos(THERING, AO.SF.AT.ATIndex(:,1))';
    
    AO.SD.AT.ATType = 'SEXT';
    AO.SD.AT.ATIndex = buildatindex(AO.SD.FamilyName, 'SD');
    AO.SD.Position = findspos(THERING, AO.SD.AT.ATIndex(:,1))';
catch
    warning('Sextupole families not found in the model.');
end

% BEND
try
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, 'BEND');
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex(:,1))';
catch
    warning('BEND family not found in the model.');
end

% RF
try
    AO.RF.AT.ATType = 'RF';
    AO.RF.AT.ATIndex = findcells(THERING,'FamName','RF')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(1))';
catch
    warning('RF family not found in the model.');
end

setao(AO);



% Set TwissData at the start of the storage ring
try
    
    % BTS twiss parameters at the input 
    TwissData.alpha = [0 0]';
    TwissData.beta  = [13.5920  6.9918]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0 0 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;

catch
     warning('Setting the twiss data parameters in the MML failed.');
end

