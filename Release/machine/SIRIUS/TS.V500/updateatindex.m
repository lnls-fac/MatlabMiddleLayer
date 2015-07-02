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
    % BEND
    AO.bend.AT.ATType = 'bend';
    AO.bend.AT.ATIndex = buildatindex(AO.bend.FamilyName, Indices.bend);
    AO.bend.Position = findspos(THERING, AO.bend.AT.ATIndex(:,1+floor(size(AO.bend.AT.ATIndex,2)/2)))';
      
catch
    warning('BEND family not found in the model.');
end

try
    % qa1
    AO.qf01a.AT.ATType = 'Quad';
    AO.qf01a.AT.ATIndex = buildatindex(AO.qf01a.FamilyName, Indices.qf01a);
    AO.qf01a.Position = findspos(THERING, AO.qf01a.AT.ATIndex(:,1))';
catch
    warning('qf01 family not found in the model.');
end
try
    % qf01b
    AO.qf01b.AT.ATType = 'Quad';
    AO.qf01b.AT.ATIndex = buildatindex(AO.qf01b.FamilyName, Indices.qf01b);
    AO.qf01b.Position = findspos(THERING, AO.qf01b.AT.ATIndex(:,1))';
catch
    warning('qf01b family not found in the model.');
end

try
    % qd02
    AO.qd02.AT.ATType = 'Quad';
    AO.qd02.AT.ATIndex = buildatindex(AO.qd02.FamilyName, Indices.qd02);
    AO.qd02.Position = findspos(THERING, AO.qd02.AT.ATIndex(:,1))';
catch
    warning('qd02 family not found in the model.');
end

try
    % qf02
    AO.qf02.AT.ATType = 'Quad';
    AO.qf02.AT.ATIndex = buildatindex(AO.qf02.FamilyName, Indices.qf02);
    AO.qf02.Position = findspos(THERING, AO.qf02.AT.ATIndex(:,1))';
catch
    warning('qf02 family not found in the model.');
end

try
    % qd03
    AO.qd03.AT.ATType = 'Quad';
    AO.qd03.AT.ATIndex = buildatindex(AO.qd03.FamilyName, Indices.qd03);
    AO.qd03.Position = findspos(THERING, AO.qd03.AT.ATIndex(:,1))';
catch
    warning('qd03 family not found in the model.');
end

try
    % qf03
    AO.qf03.AT.ATType = 'Quad';
    AO.qf03.AT.ATIndex = buildatindex(AO.qf03.FamilyName, Indices.qf03);
    AO.qf03.Position = findspos(THERING, AO.qf03.AT.ATIndex(:,1))';
catch
    warning('qf03 family not found in the model.');
end

try
    % qd04a
    AO.qd04a.AT.ATType = 'Quad';
    AO.qd04a.AT.ATIndex = buildatindex(AO.qd04a.FamilyName, Indices.qd04a);
    AO.qd04a.Position = findspos(THERING, AO.qd04a.AT.ATIndex(:,1))';
catch
    warning('qd04a family not found in the model.');
end
try
    % qf04
    AO.qf04.AT.ATType = 'Quad';
    AO.qf04.AT.ATIndex = buildatindex(AO.qf04.FamilyName, Indices.qf04);
    AO.qf04.Position = findspos(THERING, AO.qf04.AT.ATIndex(:,1))';
catch
    warning('qf04 family not found in the model.');
end
try
    % qd04b
    AO.qd04b.AT.ATType = 'Quad';
    AO.qd04b.AT.ATIndex = buildatindex(AO.qd04b.FamilyName, Indices.qd04b);
    AO.qd04b.Position = findspos(THERING, AO.qd04b.AT.ATIndex(:,1))';
catch
    warning('qd04b family not found in the model.');
end

try
    % BPMx
    AO.bpmx.AT.ATType = 'X';
    AO.bpmx.AT.ATIndex = buildatindex(AO.bpmx.FamilyName, Indices.bpm);
    AO.bpmx.Position = findspos(THERING, AO.bpmx.AT.ATIndex(:,1))';   
catch
    warning('BPMx family not found in the model.');
end

try
    % BPMy
    AO.bpmy.AT.ATType = 'Y';
    AO.bpmy.AT.ATIndex = buildatindex(AO.bpmy.FamilyName, Indices.bpm);
    AO.bpmy.Position = findspos(THERING, AO.bpmy.AT.ATIndex(:,1))';   
catch
    warning('BPMy family not found in the model.');
end

try
    % HCM
    AO.hcm.AT.ATType = 'HCM';
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
    AO.vcm.AT.ATType = 'VCM';
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
