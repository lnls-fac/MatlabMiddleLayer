function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)
%
% History
%
% 2011-04-27: missing BEND family setup was added (Ximenes)


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
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, Indices.BEND);
    AO.BEND.Position   = findspos(THERING, AO.BEND.AT.ATIndex(:,3))';
catch
    warning('BEND family not found in the model.');
end

try
    AO.BPMx.AT.ATType = 'X';
    AO.BPMx.AT.ATIndex = Indices.BPM(:); 
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';
    
    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = AO.BPMx.AT.ATIndex;
    AO.BPMy.Position = AO.BPMx.Position;
catch
    warning('BPM family not found in the model.');
end

try
    % Horizontal correctors are at every AT corrector
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.HCM);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';

    % Not all correctors are vertical correctors
    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, Indices.VCM);
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end

try
    
    AO.A2QF01.AT.ATType  = 'QUAD';
    AO.A2QF01.AT.ATIndex = buildatindex(AO.A2QF01.FamilyName, Indices.A2QF01);
    AO.A2QF01.Position   = findspos(THERING, AO.A2QF01.AT.ATIndex(:,2))';
    
    AO.A2QF03.AT.ATType  = 'QUAD';
    AO.A2QF03.AT.ATIndex = buildatindex(AO.A2QF03.FamilyName, Indices.A2QF03);
    AO.A2QF03.Position   = findspos(THERING, AO.A2QF03.AT.ATIndex(:,2))';
    
    AO.A2QF05.AT.ATType  = 'QUAD';
    AO.A2QF05.AT.ATIndex = buildatindex(AO.A2QF05.FamilyName, Indices.A2QF05);
    AO.A2QF05.Position   = findspos(THERING, AO.A2QF05.AT.ATIndex(:,2))';
    
    AO.A2QF07.AT.ATType  = 'QUAD';
    AO.A2QF07.AT.ATIndex = buildatindex(AO.A2QF07.FamilyName, Indices.A2QF07);
    AO.A2QF07.Position   = findspos(THERING, AO.A2QF07.AT.ATIndex(:,2))';
    
    AO.A2QF09.AT.ATType  = 'QUAD';
    AO.A2QF09.AT.ATIndex = buildatindex(AO.A2QF09.FamilyName, Indices.A2QF09);
    AO.A2QF09.Position   = findspos(THERING, AO.A2QF09.AT.ATIndex(:,2))';
    
    AO.A2QF11.AT.ATType  = 'QUAD';
    AO.A2QF11.AT.ATIndex = buildatindex(AO.A2QF11.FamilyName, Indices.A2QF11);
    AO.A2QF11.Position   = findspos(THERING, AO.A2QF11.AT.ATIndex(:,2))';
    
   
    
    AO.A2QD01.AT.ATType  = 'QUAD';
    AO.A2QD01.AT.ATIndex = buildatindex(AO.A2QD01.FamilyName, Indices.A2QD01);
    AO.A2QD01.Position   = findspos(THERING, AO.A2QD01.AT.ATIndex(:,2))';
    
    AO.A2QD03.AT.ATType  = 'QUAD';
    AO.A2QD03.AT.ATIndex = buildatindex(AO.A2QD03.FamilyName, Indices.A2QD03);
    AO.A2QD03.Position   = findspos(THERING, AO.A2QD03.AT.ATIndex(:,2))';
    
    AO.A2QD05.AT.ATType  = 'QUAD';
    AO.A2QD05.AT.ATIndex = buildatindex(AO.A2QD05.FamilyName, Indices.A2QD05);
    AO.A2QD05.Position   = findspos(THERING, AO.A2QD05.AT.ATIndex(:,2))';
    
    AO.A2QD07.AT.ATType  = 'QUAD';
    AO.A2QD07.AT.ATIndex = buildatindex(AO.A2QD07.FamilyName, Indices.A2QD07);
    AO.A2QD07.Position   = findspos(THERING, AO.A2QD07.AT.ATIndex(:,2))';
    
    AO.A2QD09.AT.ATType  = 'QUAD';
    AO.A2QD09.AT.ATIndex = buildatindex(AO.A2QD09.FamilyName, Indices.A2QD09);
    AO.A2QD09.Position   = findspos(THERING, AO.A2QD09.AT.ATIndex(:,2))';
    
    AO.A2QD11.AT.ATType  = 'QUAD';
    AO.A2QD11.AT.ATIndex = buildatindex(AO.A2QD11.FamilyName, Indices.A2QD11);
    AO.A2QD11.Position   = findspos(THERING, AO.A2QD11.AT.ATIndex(:,2))';
    
    AO.A6QF01.AT.ATType  = 'QUAD';
    AO.A6QF01.AT.ATIndex = buildatindex(AO.A6QF01.FamilyName, Indices.A6QF01);
    AO.A6QF01.Position   = findspos(THERING, AO.A6QF01.AT.ATIndex(:,2))';
    
    AO.A6QF02.AT.ATType  = 'QUAD';
    AO.A6QF02.AT.ATIndex = buildatindex(AO.A6QF02.FamilyName, Indices.A6QF02);
    AO.A6QF02.Position   = findspos(THERING, AO.A6QF02.AT.ATIndex(:,2))';
    
    AO.QF.AT.ATType      = 'QUAD';
    AO.QF.AT.ATIndex     = [AO.A2QF01.AT.ATIndex(1,:); AO.A2QF03.AT.ATIndex; AO.A2QF05.AT.ATIndex; AO.A2QF07.AT.ATIndex; AO.A2QF09.AT.ATIndex; AO.A2QF11.AT.ATIndex; AO.A2QF01.AT.ATIndex(2,:)];
    AO.QF.Position       = findspos(THERING, AO.QF.AT.ATIndex(:,2))';
    
    AO.QD.AT.ATType      = 'QUAD';
    AO.QD.AT.ATIndex     = [AO.A2QD01.AT.ATIndex(1,:); AO.A2QD03.AT.ATIndex; AO.A2QD05.AT.ATIndex; AO.A2QD07.AT.ATIndex; AO.A2QD09.AT.ATIndex; AO.A2QD11.AT.ATIndex; AO.A2QD01.AT.ATIndex(2,:)];
    AO.QD.Position       = findspos(THERING, AO.QD.AT.ATIndex(:,2))';
   
    AO.QFC.AT.ATType       = 'QUAD';
    AO.QFC.AT.ATIndex      = [AO.A6QF01.AT.ATIndex; AO.A6QF02.AT.ATIndex];
    [AO.QFC.Position, idx] = sort([AO.A6QF01.Position; AO.A6QF02.Position]);
    AO.QFC.AT.ATIndex      = AO.QFC.AT.ATIndex(idx, :);
    
   
    
    
catch
    warning('QUAD family not found in the model.');
end


try 
    
    AO.QUADSHUNT.AT.ATType  = 'Shunt';
    AO.QUADSHUNT.AT.ATIndex = [ AO.A2QF01.AT.ATIndex(1,:); ... % AQF01B
                                AO.A2QD01.AT.ATIndex(1,:); ... % AQD01B
                                AO.A6QF01.AT.ATIndex(1,:); ... % AQF02A
                                AO.A6QF02.AT.ATIndex(1,:); ... % AQF02B
                                AO.A2QD03.AT.ATIndex(1,:); ... % AQD03A
                                AO.A2QF03.AT.ATIndex(1,:); ... % AQF03A
                                AO.A2QF03.AT.ATIndex(2,:); ... % AQF03B
                                AO.A2QD03.AT.ATIndex(2,:); ... % AQD03B
                                AO.A6QF02.AT.ATIndex(2,:); ... % AQF04A
                                AO.A6QF01.AT.ATIndex(2,:); ... % AQF04B
                                AO.A2QD05.AT.ATIndex(1,:); ... % AQD05A
                                AO.A2QF05.AT.ATIndex(1,:); ... % AQF05A
                                AO.A2QF05.AT.ATIndex(2,:); ... % AQF05B
                                AO.A2QD05.AT.ATIndex(2,:); ... % AQD05B
                                AO.A6QF01.AT.ATIndex(3,:); ... % AQF06A
                                AO.A6QF02.AT.ATIndex(3,:); ... % AQF06B
                                AO.A2QD07.AT.ATIndex(1,:); ... % AQD07A
                                AO.A2QF07.AT.ATIndex(1,:); ... % AQF07A
                                AO.A2QF07.AT.ATIndex(2,:); ... % AQF07B
                                AO.A2QD07.AT.ATIndex(2,:); ... % AQD07B
                                AO.A6QF02.AT.ATIndex(4,:); ... % AQF08A
                                AO.A6QF01.AT.ATIndex(4,:); ... % AQF08B
                                AO.A2QD09.AT.ATIndex(1,:); ... % AQD09A
                                AO.A2QF09.AT.ATIndex(1,:); ... % AQF09A
                                AO.A2QF09.AT.ATIndex(2,:); ... % AQF09B
                                AO.A2QD09.AT.ATIndex(2,:); ... % AQD09B
                                AO.A6QF01.AT.ATIndex(5,:); ... % AQF10A
                                AO.A6QF02.AT.ATIndex(5,:); ... % AQF10B
                                AO.A2QD11.AT.ATIndex(1,:); ... % AQD11A
                                AO.A2QF11.AT.ATIndex(1,:); ... % AQF11A
                                AO.A2QF11.AT.ATIndex(2,:); ... % AQF11B
                                AO.A2QD11.AT.ATIndex(2,:); ... % AQD11B
                                AO.A6QF02.AT.ATIndex(6,:); ... % AQF12A
                                AO.A6QF01.AT.ATIndex(6,:); ... % AQF12B
                                AO.A2QD01.AT.ATIndex(2,:); ... % AQD01A
                                AO.A2QF01.AT.ATIndex(2,:); ... % AQF01A
                              ];
    AO.QUADSHUNT.Position =  findspos(THERING, AO.QUADSHUNT.AT.ATIndex(:,2))';
                            
catch
    warning('QUADSHUNT family not found in the model.');
end


try
    
    AO.A6SF.AT.ATType = 'SEXT';
    AO.A6SF.AT.ATIndex = buildatindex(AO.A6SF.FamilyName, Indices.A6SF);
    AO.A6SF.Position = findspos(THERING, AO.A6SF.AT.ATIndex(:,2))';
    
    AO.A6SD01.AT.ATType = 'SEXT';
    AO.A6SD01.AT.ATIndex = buildatindex(AO.A6SD01.FamilyName, Indices.A6SD01);
    AO.A6SD01.Position = findspos(THERING, AO.A6SD01.AT.ATIndex(:,2))';
    
    AO.A6SD02.AT.ATType = 'SEXT';
    AO.A6SD02.AT.ATIndex = buildatindex(AO.A6SD02.FamilyName, Indices.A6SD02);
    AO.A6SD02.Position = findspos(THERING, AO.A6SD02.AT.ATIndex(:,2))';  
    
    AO.SF.AT.ATType = 'SEXT';
    AO.SF.AT.ATIndex = buildatindex(AO.SF.FamilyName, Indices.A6SF);
    AO.SF.Position = findspos(THERING, AO.SF.AT.ATIndex(:,2))';
    
    AO.SD.AT.ATType  = 'SEXT';
    AO.SD.AT.ATIndex = [AO.A6SD01.AT.ATIndex; AO.A6SD02.AT.ATIndex];
    [AO.SD.Position, idx] = sort([AO.A6SD01.Position; AO.A6SD02.Position]);
    AO.SD.AT.ATIndex      = AO.SD.AT.ATIndex(idx, :);
    
   
catch
    warning('SEXT families not found in the model.');
end


try
    AO.A2QS05.AT.ATType = 'SKEWQUAD';
    AO.A2QS05.AT.ATIndex = buildatindex(AO.A2QS05.FamilyName, Indices.SKEWQUAD);
    AO.A2QS05.Position = findspos(THERING, AO.A2QS05.AT.ATIndex(:,2))';
catch
    warning('Skew quadrupole family not found in the model.');
end

%{
try
    AO.ID.AT.ATType = 'ID';
    AO.ID.AT.ATIndex = buildatindex(AO.ID.FamilyName, Indices.ID);
    AO.ID.Position = findspos(THERING, AO.ID.AT.ATIndex(:,2))';
catch
    warning('ID family not found in the model.');
end
%}

try
    AO.AON11.AT.ATType = 'IDGap';
    AO.AON11.AT.ATIndex = buildatindex(AO.AON11.FamilyName, Indices.AON11);
    AO.AON11.Position = mean(findspos(THERING, AO.AON11.AT.ATIndex(:)));
    AO.AON11.PhaseAM.AT.ATType = 'IDPhase';
    AO.AON11.PhaseAM.AT.ATIndex = AO.AON11.AT.ATIndex;
    AO.AON11.PhaseSP.AT.ATType = 'IDPhase';
    AO.AON11.PhaseSP.AT.ATIndex = AO.AON11.AT.ATIndex;
catch
    warning('AON11 family not found in the model.');
end

try
    AO.AWG01.AT.ATType = 'IDGap';
    AO.AWG01.AT.ATIndex = buildatindex(AO.AWG01.FamilyName, Indices.AWG01);
    AO.AWG01.Position = mean(findspos(THERING, AO.AWG01.AT.ATIndex(:)));
catch
    warning('AWG01 family not found in the model.');
end

try
    AO.AWG09.AT.ATType = 'IDField';
    AO.AWG09.AT.ATIndex = buildatindex(AO.AWG09.FamilyName, Indices.AWG09);
    AO.AWG09.Position = mean(findspos(THERING, AO.AWG09.AT.ATIndex(:)));
catch
    warning('AWG09 family not found in the model.');
end



try
    AO.SKEWCORR.AT.ATType  = 'SKEWCORR';
    AO.SKEWCORR.AT.ATIndex = buildatindex(AO.SKEWCORR.FamilyName, Indices.SKEWCORR);
    AO.SKEWCORR.Position   = findspos(THERING, AO.SKEWCORR.AT.ATIndex(:,2))'; 
catch
    warning('Skew corrector family not found in the model.');
end


% RF Cavity
try
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
catch
    warning('RF cavity not found in the model.');
end

% Injection Kickers
try
    AO.KICKER.AT.ATType = 'Kicker';
    AO.KICKER.AT.ATIndex = findcells(THERING,'INJKICKER')';
    AO.KICKER.AT.ATIndex = buildatindex(AO.KICKER.FamilyName, Indices.INJKICKER);
    AO.KICKER.Position = findspos(THERING, AO.KICKER.AT.ATIndex(:,1))';
catch
    warning('KICKER family not found in the model.');
end


setao(AO);



% Set TwissData at the start of the storage ring
try
    % BTS twiss parameters at the input
    TwissData.alpha = [0 0]';
    TwissData.beta  = [15.6475 0.7037]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0 0 0 0]';
    
    %setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
catch
     warning('Setting the twiss data parameters in the MML failed.');
end
