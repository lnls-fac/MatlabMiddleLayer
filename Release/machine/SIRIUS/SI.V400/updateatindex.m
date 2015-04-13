function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)
% 2012-07-10 Modificado para sirius3_lattice_e025 - Afonso


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
    % B1
    AO.b1.AT.ATType = 'BEND';
    AO.b1.AT.ATIndex = buildatindex(AO.b1.FamilyName, Indices.b1);
    AO.b1.Position = findspos(THERING, AO.b1.AT.ATIndex(:,1+floor(size(AO.b1.AT.ATIndex,2)/2)))';
      
catch
    warning('B1 family not found in the model.');
end

try
    % B2
    AO.b2.AT.ATType = 'BEND';
    AO.b2.AT.ATIndex = buildatindex(AO.b2.FamilyName, Indices.b2);
    AO.b2.Position = findspos(THERING, AO.b2.AT.ATIndex(:,1+floor(size(AO.b2.AT.ATIndex,2)/2)))';
      
catch
    warning('B2 family not found in the model.');
end

try
    % B3
    AO.b3.AT.ATType = 'BEND';
    AO.b3.AT.ATIndex = buildatindex(AO.b3.FamilyName, Indices.b3);
    AO.b3.Position = findspos(THERING, AO.b3.AT.ATIndex(:,1+floor(size(AO.b3.AT.ATIndex,2)/2)))';
      
catch
    warning('B3 family not found in the model.');
end

try
    % BC
    AO.bc.AT.ATType = 'BEND';
    AO.bc.AT.ATIndex = buildatindex(AO.bc.FamilyName, Indices.bc);
    AO.bc.Position = findspos(THERING, AO.bc.AT.ATIndex(:,1+floor(size(AO.bc.AT.ATIndex,2)/2)))';
      
catch
    warning('BC family not found in the model.');
end


try
    % QAF
    AO.qaf.AT.ATType = 'Quad';
    AO.qaf.AT.ATIndex = buildatindex(AO.qaf.FamilyName, Indices.qaf);
    AO.qaf.Position = findspos(THERING, AO.qaf.AT.ATIndex(:,1))';
catch
    warning('QAF family not found in the model.');
end

try
    % QAD
    AO.qad.AT.ATType = 'Quad';
    AO.qad.AT.ATIndex = buildatindex(AO.qad.FamilyName, Indices.qad);
    AO.qad.Position = findspos(THERING, AO.qad.AT.ATIndex(:,1))';
catch
    warning('QAD family not found in the model.');
end

try
    % QBF
    AO.qbf.AT.ATType = 'Quad';
    AO.qbf.AT.ATIndex = buildatindex(AO.qbf.FamilyName, Indices.qbf);
    AO.qbf.Position = findspos(THERING, AO.qbf.AT.ATIndex(:,1))';
catch
    warning('QBF family not found in the model.');
end

try
    % QBD2
    AO.qbd2.AT.ATType = 'Quad';
    AO.qbd2.AT.ATIndex = buildatindex(AO.qbd2.FamilyName, Indices.qbd2);
    AO.qbd2.Position = findspos(THERING, AO.qbd2.AT.ATIndex(:,1))';
catch
    warning('QBD2 family not found in the model.');
end

try
    % QBD1
    AO.qbd1.AT.ATType = 'Quad';
    AO.qbd1.AT.ATIndex = buildatindex(AO.qbd1.FamilyName, Indices.qbd1);
    AO.qbd1.Position = findspos(THERING, AO.qbd1.AT.ATIndex(:,1))';
catch
    warning('QBD1 family not found in the model.');
end

try
    % QF1
    AO.qf1.AT.ATType = 'Quad';
    AO.qf1.AT.ATIndex = buildatindex(AO.qf1.FamilyName, Indices.qf1);
    AO.qf1.Position = findspos(THERING, AO.qf1.AT.ATIndex(:,1))';
    % QF2
    AO.qf2.AT.ATType = 'Quad';
    AO.qf2.AT.ATIndex = buildatindex(AO.qf2.FamilyName, Indices.qf2);
    AO.qf2.Position = findspos(THERING, AO.qf2.AT.ATIndex(:,1))';
    % QF3
    AO.qf3.AT.ATType = 'Quad';
    AO.qf3.AT.ATIndex = buildatindex(AO.qf3.FamilyName, Indices.qf3);
    AO.qf3.Position = findspos(THERING, AO.qf3.AT.ATIndex(:,1))';
    % QF4
    AO.qf4.AT.ATType = 'Quad';
    AO.qf4.AT.ATIndex = buildatindex(AO.qf4.FamilyName, Indices.qf4);
    AO.qf4.Position = findspos(THERING, AO.qf4.AT.ATIndex(:,1))';
catch
    warning('QF1 QF2 QF3 QF4 families not found in the model.');
end

try
    % SA2
    AO.sa2.AT.ATType = 'Sext';
    AO.sa2.AT.ATIndex = buildatindex(AO.sa2.FamilyName, Indices.sa2);
    AO.sa2.Position = findspos(THERING, AO.sa2.AT.ATIndex(:,1))';
catch
    warning('SA2 family not found in the model.');
end

try
    % SA1
    AO.sa1.AT.ATType = 'Sext';
    AO.sa1.AT.ATIndex = buildatindex(AO.sa1.FamilyName, Indices.sa1);
    AO.sa1.Position = findspos(THERING, AO.sa1.AT.ATIndex(:,1))';
catch
    warning('SA1 family not found in the model.');
end


try
    % SD1
    AO.sd1.AT.ATType = 'Sext';
    AO.sd1.AT.ATIndex = buildatindex(AO.sd1.FamilyName, Indices.sd1);
    AO.sd1.Position = findspos(THERING, AO.sd1.AT.ATIndex(:,1))';
catch
    warning('SD1 family not found in the model.');
end

try
    % SF1
    AO.sf1.AT.ATType = 'Sext';
    AO.sf1.AT.ATIndex = buildatindex(AO.sf1.FamilyName, Indices.sf1);
    AO.sf1.Position = findspos(THERING, AO.sf1.AT.ATIndex(:,1))';
catch
    warning('SF1 family not found in the model.');
end

try
    % SD2
    AO.sd2.AT.ATType = 'Sext';
    AO.sd2.AT.ATIndex = buildatindex(AO.sd2.FamilyName, Indices.sd2);
    AO.sd2.Position = findspos(THERING, AO.sd2.AT.ATIndex(:,1))';
catch
    warning('SD2 family not found in the model.');
end

try
    % SD3
    AO.sd3.AT.ATType = 'Sext';
    AO.sd3.AT.ATIndex = buildatindex(AO.sd3.FamilyName, Indices.sd3);
    AO.sd3.Position = findspos(THERING, AO.sd3.AT.ATIndex(:,1))';
catch
    warning('SD3 family not found in the model.');
end


try
    % SF2
    AO.sf2.AT.ATType = 'Sext';
    AO.sf2.AT.ATIndex = buildatindex(AO.sf2.FamilyName, Indices.sf2);
    AO.sf2.Position = findspos(THERING, AO.sf2.AT.ATIndex(:,1))';
catch
    warning('SF2 family not found in the model.');
end

try
    % SB1
    AO.sb1.AT.ATType = 'Sext';
    AO.sb1.AT.ATIndex = buildatindex(AO.sb1.FamilyName, Indices.sb1);
    AO.sb1.Position = findspos(THERING, AO.sb1.AT.ATIndex(:,1))';
catch
    warning('SB1 family not found in the model.');
end

try
    % SB2
    AO.sb2.AT.ATType = 'Sext';
    AO.sb2.AT.ATIndex = buildatindex(AO.sb2.FamilyName, Indices.sb2);
    AO.sb2.Position = findspos(THERING, AO.sb2.AT.ATIndex(:,1))';
catch
    warning('SB2 family not found in the model.');
end

try
    % BPMx
    AO.bpmx.AT.ATType = 'X';
    AO.bpmx.AT.ATIndex = buildatindex(AO.bpmx.FamilyName, Indices.BPM);
    AO.bpmx.Position = findspos(THERING, AO.bpmx.AT.ATIndex(:,1))';   
catch
    warning('BPMx family not found in the model.');
end

try
    % BPMy
    AO.bpmy.AT.ATType = 'Y';
    AO.bpmy.AT.ATIndex = buildatindex(AO.bpmy.FamilyName, Indices.BPM);
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



% RF Cavity
try
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
catch
    warning('RF cavity not found in the model.');
end

try
    % SKEWCM
    AO.skewcm.AT.ATType = 'SkewCorrector';
    
    
    AO.skewcm.AT.ATIndex = [ ...
         AO.sd1.AT.ATIndex; ...
         AO.sf1.AT.ATIndex; ...
         AO.sa1.AT.ATIndex; ...
         AO.sa2.AT.ATIndex; ...
         AO.sd3.AT.ATIndex; ...
         AO.sd2.AT.ATIndex; ...
         AO.sf2.AT.ATIndex; ...
        ];
    [tmp idx] = sort(AO.skewcm.AT.ATIndex(:,1));
    AO.skewcm.AT.ATIndex = AO.skewcm.AT.ATIndex(idx,:);
    AO.skewcm.Position = findspos(THERING, AO.skewcm.AT.ATIndex(:,1))';   
    
catch
    warning('SKEWCM family not found in the model.');
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
