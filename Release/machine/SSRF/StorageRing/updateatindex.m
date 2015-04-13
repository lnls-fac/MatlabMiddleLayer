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
    AO.BPMx.AT.ATType = 'X';
    AO.BPMx.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex(:,1))';

    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex(:,1))';
catch
    fprintf('   BPM family not found in the model.\n');
end

try
    % Horizontal correctors
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.HVC);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex)';

    % Vertical correctors
    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = AO.HCM.AT.ATIndex;
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
catch
    fprintf('   COR family not found in the model.\n');
end


try
    AO.Q1.AT.ATType = 'QUAD';
    ATIndex = sort([Indices.Q1(:); Indices.Q1L(:)]);
    %AO.Q1.AT.ATIndex  = sort(ATIndex);
    AO.Q1.AT.ATIndex = buildatindex(AO.Q1.FamilyName, ATIndex);
    AO.Q1.Position = findspos(THERING, AO.Q1.AT.ATIndex(:,1))';
catch
    fprintf('   Q1 family not found in the model.\n');
end


try
    AO.Q2.AT.ATType = 'QUAD';
    try
        ATIndex = sort([Indices.Q2L(:); Indices.Q2(:)]);
    catch
        ATIndex = sort([Indices.Q2LH(:); Indices.Q2H(:)]);
    end
    %AO.Q2.AT.ATIndex  = sort(ATIndex);
    AO.Q2.AT.ATIndex = buildatindex(AO.Q2.FamilyName, ATIndex);
    AO.Q2.Position = findspos(THERING, AO.Q2.AT.ATIndex(:,1))';
catch
    fprintf('   Q2 family not found in the model.\n');
end


try
    AO.Q3.AT.ATType = 'QUAD';
    ATIndex = sort([Indices.Q3L(:); Indices.Q3(:)]);
    %AO.Q3.AT.ATIndex  = sort(ATIndex);
    AO.Q3.AT.ATIndex = buildatindex(AO.Q3.FamilyName, ATIndex);
    AO.Q3.Position = findspos(THERING, AO.Q3.AT.ATIndex(:,1))';
catch
    fprintf('   Q3 family not found in the model.\n');
end

try
    AO.Q4.AT.ATType = 'QUAD';
    ATIndex = sort([Indices.Q4L(:); Indices.Q4(:)]);
    %AO.Q4.AT.ATIndex  = sort(ATIndex);
    AO.Q4.AT.ATIndex = buildatindex(AO.Q4.FamilyName, ATIndex);
    AO.Q4.Position = findspos(THERING, AO.Q4.AT.ATIndex(:,1))';
catch
    fprintf('   Q4 family not found in the model.\n');
end

try
    AO.Q5.AT.ATType = 'QUAD';
    ATIndex = sort([Indices.Q5L(:); Indices.Q5(:)]);
    %AO.Q5.AT.ATIndex  = sort(ATIndex);
    AO.Q5.AT.ATIndex = buildatindex(AO.Q5.FamilyName, ATIndex);
    AO.Q5.Position = findspos(THERING, AO.Q5.AT.ATIndex(:,1))';
catch
    fprintf('   Q5 family not found in the model.\n');
end


try
    AO.SF.AT.ATType = 'SEXT';
    AO.SF.AT.ATIndex = buildatindex(AO.SF.FamilyName, Indices.SF);
    AO.SF.Position = findspos(THERING, AO.SF.AT.ATIndex(:,1))';

    AO.SD.AT.ATType = 'SEXT';
    AO.SD.AT.ATIndex = buildatindex(AO.SD.FamilyName, Indices.SD);
    AO.SD.Position = findspos(THERING, AO.SD.AT.ATIndex(:,1))';
catch
    fprintf('   SF or SD families not found in the model.\n');
end


try
    AO.S1.AT.ATType = 'SEXT';
    ATIndex = sort(Indices.S1(:));
    AO.S1.AT.ATIndex = buildatindex(AO.S1.FamilyName, ATIndex);
    AO.S1.Position = findspos(THERING, AO.S1.AT.ATIndex(:,1))';

    AO.S2.AT.ATType = 'SEXT';
    ATIndex = sort(Indices.S2(:));
    AO.S2.AT.ATIndex = buildatindex(AO.S2.FamilyName, ATIndex);
    AO.S2.Position = findspos(THERING, AO.S2.AT.ATIndex(:,1))';

    AO.S3.AT.ATType = 'SEXT';
    ATIndex = sort(Indices.S3(:));
    AO.S3.AT.ATIndex = buildatindex(AO.S3.FamilyName, ATIndex);
    AO.S3.Position = findspos(THERING, AO.S3.AT.ATIndex(:,1))';

    AO.S4.AT.ATType = 'SEXT';
    ATIndex = sort(Indices.S4(:));
    AO.S4.AT.ATIndex = buildatindex(AO.S4.FamilyName, ATIndex);
    AO.S4.Position = findspos(THERING, AO.S4.AT.ATIndex(:,1))';

    AO.S5.AT.ATType = 'SEXT';
    ATIndex = sort(Indices.S5(:));
    AO.S5.AT.ATIndex = buildatindex(AO.S5.FamilyName, ATIndex);
    AO.S5.Position = findspos(THERING, AO.S5.AT.ATIndex(:,1))';

    AO.S6.AT.ATType = 'SEXT';
    ATIndex = sort(Indices.S6(:));
    AO.S6.AT.ATIndex = buildatindex(AO.S6.FamilyName, ATIndex);
    AO.S6.Position = findspos(THERING, AO.S6.AT.ATIndex(:,1))';
catch
    fprintf('   S1 to S6 families not found in the model.\n');
end


% try
%     AO.SFM.AT.ATType = 'SEXT';
%     ATIndex = sort([Indices.S1(:); Indices.S3(:); Indices.S5(:); ]);
%     AO.SFM.AT.ATIndex = buildatindex(AO.SFM.FamilyName, ATIndex);
%     AO.SFM.Position = findspos(THERING, AO.SFM.AT.ATIndex(:,1))';
%     
%     AO.SDM.AT.ATType = 'SEXT';
%     ATIndex = sort([Indices.S2(:); Indices.S4(:); Indices.S6(:); ]);
%     AO.SDM.AT.ATIndex = buildatindex(AO.SDM.FamilyName, ATIndex);
%     AO.SDM.Position = findspos(THERING, AO.SDM.AT.ATIndex(:,1))';
% catch
%     fprintf('   SFM or SDM families not found in the model.\n');
% end


try
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = findcells(THERING,'FamName','BB')';
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex)';
catch
    fprintf('   BEND family not found in the model.\n');
end


try
    %RF Cavity
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1));
catch
    fprintf('   RF cavity not found in the model.\n');
    AO.RF.Position = 0;
end


setao(AO);



% Set TwissData at the start of the storage ring
try
    
    % BTS twiss parameters at the input 
    TwissData.alpha = [0 0]';
    TwissData.beta  = [16.0145 8.0019]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0 0 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;

catch
     warning('Setting the twiss data parameters in the MML failed.');
end


