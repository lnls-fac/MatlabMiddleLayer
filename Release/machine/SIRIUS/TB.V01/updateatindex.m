function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)
% 2013-12-02 Init (ximenes)


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
    % bspec
    AO.bspec.AT.ATType = 'bspec';
    AO.bspec.AT.ATIndex = buildatindex(AO.bspec.FamilyName, Indices.bspec);
    AO.bspec.Position = findspos(THERING, AO.bspec.AT.ATIndex(:,1+floor(size(AO.bspec.AT.ATIndex,2)/2)))';
      
catch
    warning('bspec family not found in the model.');
end
try
    % bp
    AO.bp.AT.ATType = 'bp';
    AO.bp.AT.ATIndex = buildatindex(AO.bp.FamilyName, Indices.bp);
    AO.bp.Position = findspos(THERING, AO.bp.AT.ATIndex(:,1+floor(size(AO.bp.AT.ATIndex,2)/2)))';
      
catch
    warning('bp family not found in the model.');
end
try
    % bn
    AO.bn.AT.ATType = 'bn';
    AO.bn.AT.ATIndex = buildatindex(AO.bn.FamilyName, Indices.bn);
    AO.bn.Position = findspos(THERING, AO.bn.AT.ATIndex(:,1+floor(size(AO.bn.AT.ATIndex,2)/2)))';
      
catch
    warning('bn family not found in the model.');
end
try
    % bseptinj
    AO.bseptinj.AT.ATType = 'bseptinj';
    AO.bseptinj.AT.ATIndex = buildatindex(AO.bseptinj.FamilyName, Indices.bseptinj);
    AO.bseptinj.Position = findspos(THERING, AO.bseptinj.AT.ATIndex(:,1+floor(size(AO.bseptinj.AT.ATIndex,2)/2)))';
      
catch
    warning('bseptinj family not found in the model.');
end

try
    % qa1
    AO.qa1.AT.ATType = 'Quad';
    AO.qa1.AT.ATIndex = buildatindex(AO.qa1.FamilyName, Indices.qa1);
    AO.qa1.Position = findspos(THERING, AO.qa1.AT.ATIndex(:,1))';
catch
    warning('qa1 family not found in the model.');
end
try
    % qa2
    AO.qa2.AT.ATType = 'Quad';
    AO.qa2.AT.ATIndex = buildatindex(AO.qa2.FamilyName, Indices.qa2);
    AO.qa2.Position = findspos(THERING, AO.qa2.AT.ATIndex(:,1))';
catch
    warning('qa2 family not found in the model.');
end
try
    % qa3
    AO.qa3.AT.ATType = 'Quad';
    AO.qa3.AT.ATIndex = buildatindex(AO.qa2.FamilyName, Indices.qa2);
    AO.qa3.Position = findspos(THERING, AO.qa3.AT.ATIndex(:,1))';
catch
    warning('qa2 family not found in the model.');
end

try
    % qb1
    AO.qb1.AT.ATType = 'Quad';
    AO.qb1.AT.ATIndex = buildatindex(AO.qb1.FamilyName, Indices.qb1);
    AO.qb1.Position = findspos(THERING, AO.qb1.AT.ATIndex(:,1))';
catch
    warning('qb1 family not found in the model.');
end
try
    % qb2
    AO.qb2.AT.ATType = 'Quad';
    AO.qb2.AT.ATIndex = buildatindex(AO.qb2.FamilyName, Indices.qb2);
    AO.qb2.Position = findspos(THERING, AO.qb2.AT.ATIndex(:,1))';
catch
    warning('qb2 family not found in the model.');
end

try
    % qc1
    AO.qc1.AT.ATType = 'Quad';
    AO.qc1.AT.ATIndex = buildatindex(AO.qc1.FamilyName, Indices.qc1);
    AO.qc1.Position = findspos(THERING, AO.qc1.AT.ATIndex(:,1))';
catch
    warning('qc1 family not found in the model.');
end
try
    % qc2
    AO.qc2.AT.ATType = 'Quad';
    AO.qc2.AT.ATIndex = buildatindex(AO.qc2.FamilyName, Indices.qc2);
    AO.qc2.Position = findspos(THERING, AO.qc2.AT.ATIndex(:,1))';
catch
    warning('qc2 family not found in the model.');
end
try
    % qc3
    AO.qc3.AT.ATType = 'Quad';
    AO.qc3.AT.ATIndex = buildatindex(AO.qc3.FamilyName, Indices.qc3);
    AO.qc3.Position = findspos(THERING, AO.qc3.AT.ATIndex(:,1))';
catch
    warning('qc3 family not found in the model.');
end
try
    % qc4
    AO.qc4.AT.ATType = 'Quad';
    AO.qc4.AT.ATIndex = buildatindex(AO.qc4.FamilyName, Indices.qc4);
    AO.qc4.Position = findspos(THERING, AO.qc4.AT.ATIndex(:,1))';
catch
    warning('qc4 family not found in the model.');
end

try
    % qd1
    AO.qd1.AT.ATType = 'Quad';
    AO.qd1.AT.ATIndex = buildatindex(AO.qd1.FamilyName, Indices.qd1);
    AO.qd1.Position = findspos(THERING, AO.qd1.AT.ATIndex(:,1))';
catch
    warning('qd1 family not found in the model.');
end
try
    % qd2
    AO.qd2.AT.ATType = 'Quad';
    AO.qd2.AT.ATIndex = buildatindex(AO.qd2.FamilyName, Indices.qd2);
    AO.qd2.Position = findspos(THERING, AO.qd2.AT.ATIndex(:,1))';
catch
    warning('qd2 family not found in the model.');
end

try
    % qe1
    AO.qe1.AT.ATType = 'Quad';
    AO.qe1.AT.ATIndex = buildatindex(AO.qe1.FamilyName, Indices.qe1);
    AO.qe1.Position = findspos(THERING, AO.qe1.AT.ATIndex(:,1))';
catch
    warning('qe1 family not found in the model.');
end
try
    % qe2
    AO.qe2.AT.ATType = 'Quad';
    AO.qe2.AT.ATIndex = buildatindex(AO.qe2.FamilyName, Indices.qe2);
    AO.qe2.Position = findspos(THERING, AO.qe2.AT.ATIndex(:,1))';
catch
    warning('qe2 family not found in the model.');
end


try
    % BPMx
    AO.bpmx.AT.ATType = 'X';
    AO.bpmx.AT.ATIndex = buildatindex(AO.bpmx.FamilyName, Indices.bpm);
    AO.bpmx.Position = findspos(THERING, AO.bpmx.AT.ATIndex(:,1))';   
catch
    warning('bpmx family not found in the model.');
end

try
    % BPMy
    AO.bpmy.AT.ATType = 'Y';
    AO.bpmy.AT.ATIndex = buildatindex(AO.bpmy.FamilyName, Indices.bpm);
    AO.bpmy.Position = findspos(THERING, AO.bpmy.AT.ATIndex(:,1))';   
catch
    warning('bpmy family not found in the model.');
end

try
    % HCM
    AO.hcm.AT.ATType = 'hcm';
    li = [];
    if isfield(Indices, 'cm'), li = [li Indices.cm]; end;
    if isfield(Indices, 'hcm'), li = [li Indices.hcm]; end;
    AO.hcm.AT.ATIndex = buildatindex(AO.hcm.FamilyName, sort(li));
    AO.hcm.Position = findspos(THERING, AO.hcm.AT.ATIndex(:,1))';   
catch
    warning('HCM family not found in the model.');
end


try
    % VCM
    AO.vcm.AT.ATType = 'vcm';
    li = [];
    if isfield(Indices, 'cm'), li = [li Indices.cm]; end;
    if isfield(Indices, 'vcm'), li = [li Indices.vcm]; end;
    AO.vcm.AT.ATIndex = buildatindex(AO.vcm.FamilyName, sort(li));
    AO.vcm.Position = findspos(THERING, AO.vcm.AT.ATIndex(:,1))';   
catch
    warning('VCM family not found in the model.');
end





setao(AO);



% Set TwissData at the start of the storage ring
% try
%     % BTS twiss parameters at the input
%     TwissData.alpha = [0 0]';
%     TwissData.beta  = [15.6475 0.7037]';
%     TwissData.mu    = [0 0]';
%     TwissData.ClosedOrbit = [0 0 0 0]';
%     TwissData.dP = 0;
%     TwissData.dL = 0;
%     TwissData.Dispersion  = [0 0 0 0]';
%     
%     setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
% catch
%      warning('Setting the twiss data parameters in the MML failed.');
% end
