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
    AO.bend.AT.ATType = 'BEND';
    AO.bend.AT.ATIndex = buildatindex(AO.bend.FamilyName, Indices.bend);
    AO.bend.Position = findspos(THERING, AO.bend.AT.ATIndex(:,1+floor(size(AO.bend.AT.ATIndex,2)/2)))';
      
catch
    warning('BEND family not found in the model.');
end

try
    % septex
    AO.septex.AT.ATType = 'Septum';
    AO.septex.AT.ATIndex = buildatindex(AO.septex.FamilyName, Indices.septex);
    AO.septex.Position = findspos(THERING, AO.septex.AT.ATIndex(:,1+floor(size(AO.septex.AT.ATIndex,2)/2)))';
      
catch
    warning('septex family not found in the model.');
end

try
    % septing
    AO.septing.AT.ATType = 'Septum';
    AO.septing.AT.ATIndex = buildatindex(AO.septing.FamilyName, Indices.septing);
    AO.septing.Position = findspos(THERING, AO.septing.AT.ATIndex(:,1+floor(size(AO.septing.AT.ATIndex,2)/2)))';
      
catch
    warning('septing family not found in the model.');
end

try
    % septinf
    AO.septinf.AT.ATType = 'Septum';
    AO.septinf.AT.ATIndex = buildatindex(AO.septinf.FamilyName, Indices.septinf);
    AO.septinf.Position = findspos(THERING, AO.septinf.AT.ATIndex(:,1+floor(size(AO.septinf.AT.ATIndex,2)/2)))';
      
catch
    warning('septinf family not found in the model.');
end

try
    % qf1a
    AO.qf1a.AT.ATType = 'Quad';
    AO.qf1a.AT.ATIndex = buildatindex(AO.qf1a.FamilyName, Indices.qf1a);
    AO.qf1a.Position = findspos(THERING, AO.qf1a.AT.ATIndex(:,1))';
catch
    warning('qf1a family not found in the model.');
end
try
    % qf1b
    AO.qf1b.AT.ATType = 'Quad';
    AO.qf1b.AT.ATIndex = buildatindex(AO.qf1b.FamilyName, Indices.qf1b);
    AO.qf1b.Position = findspos(THERING, AO.qf1b.AT.ATIndex(:,1))';
catch
    warning('qf1b family not found in the model.');
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
    % qf2
    AO.qf2.AT.ATType = 'Quad';
    AO.qf2.AT.ATIndex = buildatindex(AO.qf2.FamilyName, Indices.qf2);
    AO.qf2.Position = findspos(THERING, AO.qf2.AT.ATIndex(:,1))';
catch
    warning('qf2 family not found in the model.');
end

try
    % qf3
    AO.qf3.AT.ATType = 'Quad';
    AO.qf3.AT.ATIndex = buildatindex(AO.qf3.FamilyName, Indices.qf3);
    AO.qf3.Position = findspos(THERING, AO.qf3.AT.ATIndex(:,1))';
catch
    warning('qf3 family not found in the model.');
end

try
    % qd4a
    AO.qd4a.AT.ATType = 'Quad';
    AO.qd4a.AT.ATIndex = buildatindex(AO.qd4a.FamilyName, Indices.qd4a);
    AO.qd4a.Position = findspos(THERING, AO.qd4a.AT.ATIndex(:,1))';
catch
    warning('qd4a family not found in the model.');
end
try
    % qf4
    AO.qf4.AT.ATType = 'Quad';
    AO.qf4.AT.ATIndex = buildatindex(AO.qf4.FamilyName, Indices.qf4);
    AO.qf4.Position = findspos(THERING, AO.qf4.AT.ATIndex(:,1))';
catch
    warning('qf4 family not found in the model.');
end
try
    % qd4b
    AO.qd4b.AT.ATType = 'Quad';
    AO.qd4b.AT.ATIndex = buildatindex(AO.qd4b.FamilyName, Indices.qd4b);
    AO.qd4b.Position = findspos(THERING, AO.qd4b.AT.ATIndex(:,1))';
catch
    warning('qd4b family not found in the model.');
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
