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
    % spec
    AO.spec.AT.ATType = 'BEND';
    AO.spec.AT.ATIndex = buildatindex(AO.spec.FamilyName, Indices.spec);
    AO.spec.Position = findspos(THERING, AO.spec.AT.ATIndex(:,1+floor(size(AO.spec.AT.ATIndex,2)/2)))';
      
catch
    warning('spec family not found in the model.');
end
try
    % dipl
    AO.dipl.AT.ATType = 'BEND';
    AO.dipl.AT.ATIndex = buildatindex(AO.dipl.FamilyName, Indices.dipl);
    AO.dipl.Position = findspos(THERING, AO.dipl.AT.ATIndex(:,1+floor(size(AO.dipl.AT.ATIndex,2)/2)))';
      
catch
    warning('dipl family not found in the model.');
end
try
    % injsept
    AO.injsept.AT.ATType = 'Septum';
    AO.injsept.AT.ATIndex = buildatindex(AO.injsept.FamilyName, Indices.injsept);
    AO.injsept.Position = findspos(THERING, AO.injsept.AT.ATIndex(:,1+floor(size(AO.injsept.AT.ATIndex,2)/2)))';
      
catch
    warning('septin family not found in the model.');
end


try
    % q1al
    AO.q1al.AT.ATType = 'Quad';
    AO.q1al.AT.ATIndex = buildatindex(AO.q1al.FamilyName, Indices.q1al);
    AO.q1al.Position = findspos(THERING, AO.q1al.AT.ATIndex(:,1))';
catch
    warning('q1al family not found in the model.');
end

try
    % q1bl
    AO.q1bl.AT.ATType = 'Quad';
    AO.q1bl.AT.ATIndex = buildatindex(AO.q1bl.FamilyName, Indices.q1bl);
    AO.q1bl.Position = findspos(THERING, AO.q1bl.AT.ATIndex(:,1))';
catch
    warning('q1bl family not found in the model.');
end

try
    % q1cl
    AO.q1cl.AT.ATType = 'Quad';
    AO.q1cl.AT.ATIndex = buildatindex(AO.q1cl.FamilyName, Indices.q1cl);
    AO.q1cl.Position = findspos(THERING, AO.q1cl.AT.ATIndex(:,1))';
catch
    warning('q1cl family not found in the model.');
end

try
    % qd2l
    AO.qd2l.AT.ATType = 'Quad';
    AO.qd2l.AT.ATIndex = buildatindex(AO.qd2l.FamilyName, Indices.qd2l);
    AO.qd2l.Position = findspos(THERING, AO.qd2l.AT.ATIndex(:,1))';
catch
    warning('qd2l family not found in the model.');
end

try
    % qf2l
    AO.qf2l.AT.ATType = 'Quad';
    AO.qf2l.AT.ATIndex = buildatindex(AO.qf2l.FamilyName, Indices.qf2l);
    AO.qf2l.Position = findspos(THERING, AO.qf2l.AT.ATIndex(:,1))';
catch
    warning('qf2l family not found in the model.');
end

try
    % qd3al
    AO.qd3al.AT.ATType = 'Quad';
    AO.qd3al.AT.ATIndex = buildatindex(AO.qd3al.FamilyName, Indices.qd3al);
    AO.qd3al.Position = findspos(THERING, AO.qd3al.AT.ATIndex(:,1))';
catch
    warning('qd3al family not found in the model.');
end

try
    % qf3al
    AO.qf3al.AT.ATType = 'Quad';
    AO.qf3al.AT.ATIndex = buildatindex(AO.qf3al.FamilyName, Indices.qf3al);
    AO.qf3al.Position = findspos(THERING, AO.qf3al.AT.ATIndex(:,1))';
catch
    warning('qf3al family not found in the model.');
end

try
    % qf3bl
    AO.qf3bl.AT.ATType = 'Quad';
    AO.qf3bl.AT.ATIndex = buildatindex(AO.qf3bl.FamilyName, Indices.qf3bl);
    AO.qf3bl.Position = findspos(THERING, AO.qf3bl.AT.ATIndex(:,1))';
catch
    warning('qf3bl family not found in the model.');
end

try
    % qd3bl
    AO.qd3bl.AT.ATType = 'Quad';
    AO.qd3bl.AT.ATIndex = buildatindex(AO.qd3bl.FamilyName, Indices.qd3bl);
    AO.qd3bl.Position = findspos(THERING, AO.qd3bl.AT.ATIndex(:,1))';
catch
    warning('qd3bl family not found in the model.');
end

try
    % qf4l
    AO.qf4l.AT.ATType = 'Quad';
    AO.qf4l.AT.ATIndex = buildatindex(AO.qf4l.FamilyName, Indices.qf4l);
    AO.qf4l.Position = findspos(THERING, AO.qf4l.AT.ATIndex(:,1))';
catch
    warning('qf4l family not found in the model.');
end

try
    % qd4l
    AO.qd4l.AT.ATType = 'Quad';
    AO.qd4l.AT.ATIndex = buildatindex(AO.qd4l.FamilyName, Indices.qd4l);
    AO.qd4l.Position = findspos(THERING, AO.qd4l.AT.ATIndex(:,1))';
catch
    warning('qd4l family not found in the model.');
end

try
    % qf5l
    AO.qf5l.AT.ATType = 'Quad';
    AO.qf5l.AT.ATIndex = buildatindex(AO.qf5l.FamilyName, Indices.qf5l);
    AO.qf5l.Position = findspos(THERING, AO.qf5l.AT.ATIndex(:,1))';
catch
    warning('qf5l family not found in the model.');
end

try
    % qd5l
    AO.qd5l.AT.ATType = 'Quad';
    AO.qd5l.AT.ATIndex = buildatindex(AO.qd5l.FamilyName, Indices.qd5l);
    AO.qd5l.Position = findspos(THERING, AO.qd5l.AT.ATIndex(:,1))';
catch
    warning('qd5l family not found in the model.');
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
    % CH
    AO.ch.AT.ATType = 'HCM';
    li = [];
    if isfield(Indices, 'ch'), li = [li Indices.ch]; end;
    if isfield(Indices, 'hcm'), li = [li Indices.hcm]; end;
    % Remove linac corrector
    li = sort(li);
    li = li(2:end);
    AO.ch.AT.ATIndex = buildatindex(AO.ch.FamilyName, li);
    AO.ch.Position = findspos(THERING, AO.ch.AT.ATIndex(:,1))';   
catch
    warning('CH family not found in the model.');
end


try
    % CV
    AO.cv.AT.ATType = 'VCM';
    li = [];
    if isfield(Indices, 'cv'), li = [li Indices.cv]; end;
    if isfield(Indices, 'vcm'), li = [li Indices.vcm]; end;
    % Remove linac corrector
    li = sort(li);
    li = li(2:end);
    AO.cv.AT.ATIndex = buildatindex(AO.cv.FamilyName, li);
    AO.cv.Position = findspos(THERING, AO.cv.AT.ATIndex(:,1))';   
catch
    warning('CV family not found in the model.');
end


setao(AO);




