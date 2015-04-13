function [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocofitparameters(FileName)
%BUILDLOCOFITPARAMETERS - ALS LOCO fit parameters
%
%  [LocoMeasData, BPMData, CMData, RINGData, FitParameters, LocoFlags] = buildlocoinput(FileName)



%%%%%%%%%%%%%%
% Input file %
%%%%%%%%%%%%%%
if nargin == 0
    [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat','Select a LOCO input file');
    if FilterIndex == 0 
        return;
    end
    FileName = [DirectoryName, FileName];
end

load(FileName);



%%%%%%%%%%%%%%%%%%%%%%
% Remove bad devices %
%%%%%%%%%%%%%%%%%%%%%%
RemoveHCMDeviceList = [];
RemoveVCMDeviceList = [];

RemoveHBPMDeviceList = [];
RemoveVBPMDeviceList = [];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function only works on the first iteration %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('BPMData','var') && length(BPMData)>1
    BPMData = BPMData(1);
end
if exist('CMData','var') && length(CMData)>1
    CMData = CMData(1);
end
if exist('FitParameters','var') && length(FitParameters)>1
    FitParameters = FitParameters(1);
end
if exist('LocoFlags','var') && length(LocoFlags)>1
    LocoFlags = LocoFlags(1);
end
if exist('LocoModel','var') && length(LocoModel)>1
    LocoModel = LocoModel(1);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure the start point in loaded in the AT model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(FitParameters)
    for i = 1:length(FitParameters.Params)
        RINGData = locosetlatticeparam(RINGData, FitParameters.Params{i}, FitParameters.Values(i));
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tune up a few parameters based on the MachineConfig %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    if isfield(LocoMeasData, 'MachineConfig')
        % Sextupoles
        Families = {'SF','SD','S1','S2','S3','S4','S5','S6'};
        for i = 1:length(Families)
            Family = Families{i};
            if all(MachineConfig.(Family).Setpoint.Data == 0)
                fprintf('   Turning %s family off in the LOCO model.\n', Family);
                ATIndex = findcells(RINGData.Lattice,'FamName',Family)';
                for j = 1:length(ATIndex)
                    RINGData.Lattice{ATIndex(j)}.PolynomB(3) = 0;
                end
            end
        end

        % Skew quadrupoles???
    end
catch
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocoFlags to change from the default %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocoFlags.Threshold = 1e-5;
% LocoFlags.OutlierFactor = 10;
% LocoFlags.SVmethod = 1e-2;
% LocoFlags.HorizontalDispersionWeight = 12.5;
% LocoFlags.VerticalDispersionWeight = 12.5;
% LocoFlags.AutoCorrectDelta = 'Yes';
% LocoFlags.Coupling = 'No';
% LocoFlags.Dispersion = 'No';
% LocoFlags.Normalize = 'Yes';
% LocoFlags.ResponseMatrixCalculatorFlag1 = 'Linear';
% LocoFlags.ResponseMatrixCalculatorFlag2 = 'FixedPathLength';
% LocoFlags.CalculateSigma = 'No';
% LocoFlags.SinglePrecision = 'Yes';

% CMData.FitKicks    = 'Yes';
% CMData.FitCoupling = 'No';
% 
% BPMData.FitGains    = 'Yes';
% BPMData.FitCoupling = 'No';


j = findrowindex(RemoveHCMDeviceList, LocoMeasData.HCM.DeviceList);
if ~isempty(j)
    irm = findrowindex(j(:),CMData.HCMGoodDataIndex(:));
    CMData.HCMGoodDataIndex(irm) = [];
end

j = findrowindex(RemoveVCMDeviceList, LocoMeasData.VCM.DeviceList);
if ~isempty(j)
    irm = findrowindex(j(:),CMData.VCMGoodDataIndex(:));
    CMData.VCMGoodDataIndex(irm) = [];
end


% BPMs to disable
j = findrowindex(RemoveHBPMDeviceList, LocoMeasData.HBPM.DeviceList);
if ~isempty(j)
    irm = findrowindex(j(:),BPMData.HBPMGoodDataIndex(:));
    BPMData.HBPMGoodDataIndex(irm) = [];
end

j = findrowindex(RemoveVBPMDeviceList, LocoMeasData.VBPM.DeviceList);
if ~isempty(j)
    irm = findrowindex(j(:),BPMData.VBPMGoodDataIndex(:));
    BPMData.VBPMGoodDataIndex(irm) = [];
end



%%%%%%%%%%%%%%%%%
% FitParameters %
%%%%%%%%%%%%%%%%%

% Individual magnets
% For each parameter which is fit in the model a numerical response matrix
% gradient needs to be determined.  The FitParameters data structure determines what
% parameter in the model get varied and how are they grouped.  For no parameter fits, set
% FitParameters.Params to an empty vector.
%     FitParameters.Params = parameter group definition (cell array for AT)
%     FitParameters.Values = Starting value for the parameter fit
%     FitParameters.Deltas = change in parameter value used to compute the gradient (NaN forces loco to choose, see auto-correct delta flag below)
%     FitParameters.FitRFFrequency = ('Yes'/'No') Fit the RF frequency?
%     FitParameters.DeltaRF = Change in RF frequency when measuring "dispersion".
%                             If the RF frequency is being fit the output is stored here.
%
% The FitParameters structure also contains the standard deviations of the fits:
%     LocoValuesSTD
%     FitParameters.DeltaRFSTD
%
% Note: FitParameters.DeltaRF is used when including dispersion in the response matrix.
%       LocoMeasData.DeltaRF is not used directly in loco.  Usually one would set
%       FitParameters.DeltaRF = LocoMeasData.DeltaRF as a starting point for the RF frequency.

FitParameters = [];
N = 0;

%%%%%%%%%%%%%%%%%%%
% Quadrupole Fits %
%%%%%%%%%%%%%%%%%%%
ModeCell = {'Fit by family (10 Fit Parameters)','Fit by magnet (Q5 in pairs)','No parameter setup','Q2 Only'};
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOFITPARAMETERS','PromptString',{'Fit Parameter Selection:','(Not including skew quadrupoles)'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [435 110], 'InitialValue', 2);
drawnow;
if OKFlag ~= 1
    ButtonName = 1;
end

switch ButtonName
    case 1 %'Fit by family'
       
        % Note: this is based on 5 quad families, 10 fit parameters
        Families = {'Q1','Q2','Q3','Q4','Q5'};

        for i = 1:length(Families)
            % K-values
            Family = Families{i};
            ATIndex = family2atindex(Family);
            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex([1 10 11 20 21 30 31 40], :),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',ATIndex(1,1));
            FitParameters.Deltas(N,1) = NaN;

            N = N + 1;
            FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex([2:9 12:19 22:29 32:39], :),'K');
            FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',ATIndex(1,1));
            FitParameters.Deltas(N,1) = NaN;
        end


    case 2 % Fit by magnet
        
        Families = {'Q1','Q2','Q3','Q4'};
        for i = 1:length(Families)
            Family = Families{i};

            % K-values
            ATIndex = family2atindex(Family);
            for loop = 1:size(ATIndex,1)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex(loop,:),'K');
                FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',ATIndex(loop,1));
                FitParameters.Deltas(N,1) = NaN;
            end
        end

        % Fit Q5 in pairs
        Families = {'Q5'};
        for i = 1:length(Families)
            Family = Families{i};

            % K-values - since the pairs are not always equal, do a proportional fit
            ATIndex = family2atindex(Family);
            for loop = 1:2:size(ATIndex,1)
                N = N + 1;
                k1 = getcellstruct(RINGData.Lattice,'K',ATIndex(loop,1));
                k2 = getcellstruct(RINGData.Lattice,'K',ATIndex(loop+1,1));
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex([loop loop+1],:),'cK', [1 k2/k1]);
                FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',ATIndex(loop,1));
                FitParameters.Deltas(N,1) = NaN;
            end
        end
        
    case 4 %'Q2 Only'
        Families = {'Q2'};
        for i = 1:length(Families)
            Family = Families{i};

            % K-values
            ATIndex = family2atindex(Family);
            for loop = 1:size(ATIndex,1)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex(loop,:),'K');
                FitParameters.Values(N,1) = getcellstruct(RINGData.Lattice,'K',ATIndex(loop,1));
                FitParameters.Deltas(N,1) = NaN;
            end
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sextupole Feed-Down Fits %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Fit quadrupoles at the sextupoles?????


%%%%%%%%%%%%%%%%%%%%%%%%
% Skew Quadrupole Fits %
%%%%%%%%%%%%%%%%%%%%%%%%
ModeCell = {'Fit skew quadrupoles at sextupole magnets', 'Do Not Fit Skew Quadrupoles'};
[ButtonName, OKFlag] = listdlg('Name','BUILDLOCOFITPARAMETERS','PromptString',{'Skew Quadrupole Fits?','Fit Parameter Selection:'}, 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [350 125], 'InitialValue', 2);
if OKFlag ~= 1
    ButtonName = 2;  % Default
end
switch ButtonName        
    case 1
        % Fit skew quadrupoles in the sextupoles
        Families = {'SF','SD'};

        for i = 1:length(Families)
            Family = Families{i};

            % S-values
            ATIndex = family2atindex(Family);
            for loop = 1:size(ATIndex,1)
                N = N + 1;
                FitParameters.Params{N} = mkparamgroup(RINGData.Lattice,ATIndex(loop,:),'s');
                FitParameters.Values(N,1) = 0;
                FitParameters.Deltas(N,1) = 0.5e-2;
            end
        end

    case 2
        % No skew fits so turn off coupling
        LocoFlags.Coupling  = 'No';
        BPMData.FitCoupling = 'No';
        CMData.FitCoupling  = 'No';
end


fprintf('\n');


% Starting point for the deltas (automatic delta determination does not work if starting value is 0)
%FitParameters.Deltas = 0.0001 * ones(size(FitParameters.Values));


% RF parameter fit setup (There is a flag to actually do the fit)
if isempty(LocoMeasData.DeltaRF)
    FitParameters.DeltaRF = 500;  % It's good to have something here so that LOCO will compute a model dispersion
else
    FitParameters.DeltaRF = LocoMeasData.DeltaRF;
end


% File check
[BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck({BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData});


% Save
save(FileName, 'LocoModel', 'FitParameters', 'BPMData', 'CMData', 'RINGData', 'LocoMeasData', 'LocoFlags');


