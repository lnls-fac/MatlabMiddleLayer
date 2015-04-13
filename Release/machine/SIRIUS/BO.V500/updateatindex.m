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
    % BD
    AO.B.AT.ATType = 'BEND';
    AO.B.AT.ATIndex = buildatindex(AO.B.FamilyName, Indices.B);
    AO.B.Position = findspos(THERING, AO.B.AT.ATIndex(:,1));
catch
    warning('B family not found in the model.');
end

try
    % QD
    AO.QD.AT.ATType = 'QUAD';
    AO.QD.AT.ATIndex = buildatindex(AO.QD.FamilyName, Indices.QD);
    AO.QD.Position = findspos(THERING, AO.QD.AT.ATIndex(:,1));
catch
    warning('QD family not found in the model.');
end

try
    % QF
    AO.QF.AT.ATType = 'QUAD';
    AO.QF.AT.ATIndex = buildatindex(AO.QF.FamilyName, Indices.QF);
    AO.QF.Position = findspos(THERING, AO.QF.AT.ATIndex(:,1));
catch
    warning('QF family not found in the model.');
end

try
    % SD
    AO.SD.AT.ATType = 'SEXT';
    AO.SD.AT.ATIndex = buildatindex(AO.SD.FamilyName, Indices.SD);
    AO.SD.Position = findspos(THERING, AO.SD.AT.ATIndex(:,1));
catch
    warning('SD family not found in the model.');
end

try
    % SF
    AO.SF.AT.ATType = 'SEXT';
    AO.SF.AT.ATIndex = buildatindex(AO.SF.FamilyName, Indices.SF);
    AO.SF.Position = findspos(THERING, AO.SF.AT.ATIndex(:,1));
catch
    warning('SF family not found in the model.');
end

try
    % BPMx
    AO.BPMx.AT.ATType = 'X';
    AO.BPMx.AT.ATIndex = buildatindex(AO.BPMx.FamilyName, Indices.BPM);
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex(:,1))';   
catch
    warning('BPMx family not found in the model.');
end

try
    % BPMy
    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = buildatindex(AO.BPMy.FamilyName, Indices.BPM);
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex(:,1))';   
catch
    warning('BPMy family not found in the model.');
end

try
    % HCM
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.HCM);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';   
catch
    warning('HCM family not found in the model.');
end

try
    % VCM
    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, Indices.VCM);
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';   
catch
    warning('VCM family not found in the model.');
end



% RF Cavity
try
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
catch
    warning('RF cavity not found in the model.');
end


setao(AO);
