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
    % thinejesept
    AO.thinejesept.AT.ATType = 'Septum';
    AO.thinejesept.AT.ATIndex = buildatindex(AO.thinejesept.FamilyName, Indices.thinejesept);
    AO.thinejesept.Position = findspos(THERING, AO.thinejesept.AT.ATIndex(:,1+floor(size(AO.thinejesept.AT.ATIndex,2)/2)))';
      
catch
    warning('thinejesept family not found in the model.');
end

try
    % thickejesept
    AO.thickejesept.AT.ATType = 'Septum';
    AO.thickejesept.AT.ATIndex = buildatindex(AO.thickejesept.FamilyName, Indices.thickejesept);
    AO.thickejesept.Position = findspos(THERING, AO.thickejesept.AT.ATIndex(:,1+floor(size(AO.thickejesept.AT.ATIndex,2)/2)))';
      
catch
    warning('thickejesept family not found in the model.');
end

try
    % thininjsept
    AO.thininjsept.AT.ATType = 'Septum';
    AO.thininjsept.AT.ATIndex = buildatindex(AO.thininjsept.FamilyName, Indices.thininjsept);
    AO.thininjsept.Position = findspos(THERING, AO.thininjsept.AT.ATIndex(:,1+floor(size(AO.thininjsept.AT.ATIndex,2)/2)))';
      
catch
    warning('thininjsept family not found in the model.');
end

try
    % thickinjsept
    AO.thickinjsept.AT.ATType = 'Septum';
    AO.thickinjsept.AT.ATIndex = buildatindex(AO.thickinjsept.FamilyName, Indices.thickinjsept);
    AO.thickinjsept.Position = findspos(THERING, AO.thickinjsept.AT.ATIndex(:,1+floor(size(AO.thickinjsept.AT.ATIndex,2)/2)))';
      
catch
    warning('thickinjsept family not found in the model.');
end


try
    % qf1ah
    AO.qf1ah.AT.ATType = 'Quad';
    AO.qf1ah.AT.ATIndex = buildatindex(AO.qf1ah.FamilyName, Indices.qf1ah);
    AO.qf1ah.Position = findspos(THERING, AO.qf1ah.AT.ATIndex(:,1))';
catch
    warning('qf1ah family not found in the model.');
end
try
    % qf1bh
    AO.qf1bh.AT.ATType = 'Quad';
    AO.qf1bh.AT.ATIndex = buildatindex(AO.qf1bh.FamilyName, Indices.qf1bh);
    AO.qf1bh.Position = findspos(THERING, AO.qf1bh.AT.ATIndex(:,1))';
catch
    warning('qf1bh family not found in the model.');
end

try
    % qd2h
    AO.qd2h.AT.ATType = 'Quad';
    AO.qd2h.AT.ATIndex = buildatindex(AO.qd2h.FamilyName, Indices.qd2h);
    AO.qd2h.Position = findspos(THERING, AO.qd2h.AT.ATIndex(:,1))';
catch
    warning('qd2h family not found in the model.');
end

try
    % qf2h
    AO.qf2h.AT.ATType = 'Quad';
    AO.qf2h.AT.ATIndex = buildatindex(AO.qf2h.FamilyName, Indices.qf2h);
    AO.qf2h.Position = findspos(THERING, AO.qf2h.AT.ATIndex(:,1))';
catch
    warning('qf2h family not found in the model.');
end

try
    % qf3h
    AO.qf3h.AT.ATType = 'Quad';
    AO.qf3h.AT.ATIndex = buildatindex(AO.qf3h.FamilyName, Indices.qf3h);
    AO.qf3h.Position = findspos(THERING, AO.qf3h.AT.ATIndex(:,1))';
catch
    warning('qf3h family not found in the model.');
end

try
    % qd4ah
    AO.qd4ah.AT.ATType = 'Quad';
    AO.qd4ah.AT.ATIndex = buildatindex(AO.qd4ah.FamilyName, Indices.qd4ah);
    AO.qd4ah.Position = findspos(THERING, AO.qd4ah.AT.ATIndex(:,1))';
catch
    warning('qd4ah family not found in the model.');
end
try
    % qf4h
    AO.qf4h.AT.ATType = 'Quad';
    AO.qf4h.AT.ATIndex = buildatindex(AO.qf4h.FamilyName, Indices.qf4h);
    AO.qf4h.Position = findspos(THERING, AO.qf4h.AT.ATIndex(:,1))';
catch
    warning('qf4h family not found in the model.');
end
try
    % qd4bh
    AO.qd4bh.AT.ATType = 'Quad';
    AO.qd4bh.AT.ATIndex = buildatindex(AO.qd4bh.FamilyName, Indices.qd4bh);
    AO.qd4bh.Position = findspos(THERING, AO.qd4bh.AT.ATIndex(:,1))';
catch
    warning('qd4bh family not found in the model.');
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
    % CH
    AO.hcm.AT.ATType = 'HCM';
    li = [];
    if isfield(Indices, 'ch'), li = [li Indices.ch]; end;
    if isfield(Indices, 'thinejesept'), li = [li Indices.thinejesept]; end;
    if isfield(Indices, 'thickinjsept'), li = [li Indices.thickinjsept]; end;
    AO.ch.AT.ATIndex = buildatindex(AO.ch.FamilyName, sort(li));
    AO.ch.Position = findspos(THERING, AO.ch.AT.ATIndex(:,1))';   
catch
    warning('CH family not found in the model.');
end


try
    % CV
    AO.cv.AT.ATType = 'VCM';
    li = [];
    if isfield(Indices, 'cv'), li = [li Indices.cv]; end;
    AO.cv.AT.ATIndex = buildatindex(AO.cv.FamilyName, sort(li));
    AO.cv.Position = findspos(THERING, AO.cv.AT.ATIndex(:,1))';   
catch
    warning('CV family not found in the model.');
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
