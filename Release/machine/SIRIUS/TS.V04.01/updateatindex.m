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
    AO.B.AT.ATType = 'BEND';
    AO.B.AT.ATIndex = buildatindex(AO.B.FamilyName, Indices.B);
    AO.B.Position = findspos(THERING, AO.B.AT.ATIndex(:,1+floor(size(AO.B.AT.ATIndex,2)/2)))';
      
catch
    warning('B family not found in the model.');
end

try
    % EjeSeptF
    AO.EjeSeptF.AT.ATType = 'Septum';
    AO.EjeSeptF.AT.ATIndex = buildatindex(AO.EjeSeptF.FamilyName, Indices.EjeSeptF);
    AO.EjeSeptF.Position = findspos(THERING, AO.EjeSeptF.AT.ATIndex(:,1+floor(size(AO.EjeSeptF.AT.ATIndex,2)/2)))';
      
catch
    warning('EjeSeptF family not found in the model.');
end

try
    % EjeSeptG
    AO.EjeSeptG.AT.ATType = 'Septum';
    AO.EjeSeptG.AT.ATIndex = buildatindex(AO.EjeSeptG.FamilyName, Indices.EjeSeptG);
    AO.EjeSeptG.Position = findspos(THERING, AO.EjeSeptG.AT.ATIndex(:,1+floor(size(AO.EjeSeptG.AT.ATIndex,2)/2)))';
      
catch
    warning('EjeSeptG family not found in the model.');
end

try
    % InjSeptF
    AO.InjSeptF.AT.ATType = 'Septum';
    AO.InjSeptF.AT.ATIndex = buildatindex(AO.InjSeptF.FamilyName, Indices.InjSeptF);
    AO.InjSeptF.Position = findspos(THERING, AO.InjSeptF.AT.ATIndex(:,1+floor(size(AO.InjSeptF.AT.ATIndex,2)/2)))';
      
catch
    warning('InjSeptF family not found in the model.');
end

try
    % InjSeptG
    AO.InjSeptG.AT.ATType = 'Septum';
    AO.InjSeptG.AT.ATIndex = buildatindex(AO.InjSeptG.FamilyName, Indices.InjSeptG);
    AO.InjSeptG.Position = findspos(THERING, AO.InjSeptG.AT.ATIndex(:,1+floor(size(AO.InjSeptG.AT.ATIndex,2)/2)))';
      
catch
    warning('InjSeptG family not found in the model.');
end


try
    % QF1A
    AO.QF1A.AT.ATType = 'Quad';
    AO.QF1A.AT.ATIndex = buildatindex(AO.QF1A.FamilyName, Indices.QF1A);
    AO.QF1A.Position = findspos(THERING, AO.QF1A.AT.ATIndex(:,1))';
catch
    warning('QF1A family not found in the model.');
end
try
    % QF1B
    AO.QF1B.AT.ATType = 'Quad';
    AO.QF1B.AT.ATIndex = buildatindex(AO.QF1B.FamilyName, Indices.QF1B);
    AO.QF1B.Position = findspos(THERING, AO.QF1B.AT.ATIndex(:,1))';
catch
    warning('QF1B family not found in the model.');
end

try
    % QD2
    AO.QD2.AT.ATType = 'Quad';
    AO.QD2.AT.ATIndex = buildatindex(AO.QD2.FamilyName, Indices.QD2);
    AO.QD2.Position = findspos(THERING, AO.QD2.AT.ATIndex(:,1))';
catch
    warning('QD2 family not found in the model.');
end

try
    % QF2
    AO.QF2.AT.ATType = 'Quad';
    AO.QF2.AT.ATIndex = buildatindex(AO.QF2.FamilyName, Indices.QF2);
    AO.QF2.Position = findspos(THERING, AO.QF2.AT.ATIndex(:,1))';
catch
    warning('QF2 family not found in the model.');
end

try
    % QF3
    AO.QF3.AT.ATType = 'Quad';
    AO.QF3.AT.ATIndex = buildatindex(AO.QF3.FamilyName, Indices.QF3);
    AO.QF3.Position = findspos(THERING, AO.QF3.AT.ATIndex(:,1))';
catch
    warning('QF3 family not found in the model.');
end

try
    % QD4A
    AO.QD4A.AT.ATType = 'Quad';
    AO.QD4A.AT.ATIndex = buildatindex(AO.QD4A.FamilyName, Indices.QD4A);
    AO.QD4A.Position = findspos(THERING, AO.QD4A.AT.ATIndex(:,1))';
catch
    warning('QD4A family not found in the model.');
end
try
    % QF4
    AO.QF4.AT.ATType = 'Quad';
    AO.QF4.AT.ATIndex = buildatindex(AO.QF4.FamilyName, Indices.QF4);
    AO.QF4.Position = findspos(THERING, AO.QF4.AT.ATIndex(:,1))';
catch
    warning('QF4 family not found in the model.');
end
try
    % QD4B
    AO.QD4B.AT.ATType = 'Quad';
    AO.QD4B.AT.ATIndex = buildatindex(AO.QD4B.FamilyName, Indices.QD4B);
    AO.QD4B.Position = findspos(THERING, AO.QD4B.AT.ATIndex(:,1))';
catch
    warning('QD4B family not found in the model.');
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
    % CH
    AO.CH.AT.ATType = 'HCM';
    li = [];
    if isfield(Indices, 'CH'), li = [li Indices.CH]; end;
    if isfield(Indices, 'EjeSeptF'), li = [li Indices.EjeSeptF]; end;
    if isfield(Indices, 'InjSeptG'), li = [li Indices.InjSeptG]; end;
    AO.CH.AT.ATIndex = buildatindex(AO.CH.FamilyName, sort(li));
    AO.CH.Position = findspos(THERING, AO.CH.AT.ATIndex(:,1))';   
catch
    warning('CH family not found in the model.');
end


try
    % CV
    AO.CV.AT.ATType = 'VCM';
    li = [];
    if isfield(Indices, 'CV'), li = [li Indices.CV]; end;
    AO.CV.AT.ATIndex = buildatindex(AO.CV.FamilyName, sort(li));
    AO.CV.Position = findspos(THERING, AO.CV.AT.ATIndex(:,1))';   
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
