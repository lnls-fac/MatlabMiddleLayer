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
    % BEND
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
    tmp = buildatindex(AO.QF.FamilyName, Indices.QF)';
    tmp = circshift(tmp(:),1);
    AO.QF.AT.ATIndex = reshape(tmp, 2, [])';
    AO.QF.Position = findspos(THERING, AO.QF.AT.ATIndex(:,1));
catch
    warning('QF family not found in the model.');
end

try
    % QS
    AO.QS.AT.ATType = 'QUAD';
    AO.QS.AT.ATIndex = buildatindex(AO.QS.FamilyName, Indices.QS);
    AO.QS.Position = findspos(THERING, AO.QS.AT.ATIndex(:,1));
catch
    warning('QS family not found in the model.');
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
    AO.CH.AT.ATType = 'HCM';
    AO.CH.AT.ATIndex = buildatindex(AO.CH.FamilyName, Indices.CH);
    AO.CH.Position = findspos(THERING, AO.CH.AT.ATIndex(:,1))';
catch
    warning('HCM family not found in the model.');
end

try
    % VCM
    AO.CV.AT.ATType = 'VCM';
    AO.CV.AT.ATIndex = buildatindex(AO.CV.FamilyName, Indices.CV);
    AO.CV.Position = findspos(THERING, AO.CV.AT.ATIndex(:,1))';
catch
    warning('VCM family not found in the model.');
end

try
    % RF Cavity
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
catch
    warning('RF cavity not found in the model.');
end

% DCCT
try
    AO.DCCT.AT.ATType = 'DCCT';
    AO.DCCT.AT.ATIndex = findcells(THERING, 'FamName', 'DCCT')';
    AO.DCCT.Position = findspos(THERING, AO.DCCT.AT.ATIndex(:,1))';
catch
    warning('DCCT not found in the model.');
end


setao(AO);
