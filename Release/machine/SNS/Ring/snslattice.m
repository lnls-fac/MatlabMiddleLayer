function [BPMx, BPMy, HCM, VCM, QF, QD, SkewQuad, SF, SD, BEND] = snslattice

% SNS lattice
L0 = 248.029999;      % design length [m]
C0 = 299792458;       % speed of light [m/s]
HarmNumber = 1;
Energy = 1.783272e9;


clear global FAMLIST GLOBVAL
global THERING
THERING = [];


% Convert MAD survey file to AT
%       NAME  - a string array of 8-character element names
%       TYPE  - an integer array of element types:
%       1 = Drift                (DRFT)
%       2 = Bend                 (SBND)
%       3 = Quadrupole           (QUAD)
%       4 = Sextupole            (SEXT)
%       5 = Linear acceleration  (ACCL)
%       6 = Horizontal corrector (HKIC)
%       7 = Vertical corrector   (VKIC)
%       8 = H/V corrector        (KICK)
%       9 = Horizontal BPM       (HMON)
%      10 = Vertical BPM         (VMON)
%      11 = H/V BPM              (MONI)
%      12 = Marker point         (MARK)
%MADFile = 'twiss.out';      % Skew quads not split, hence BPMs are not in the correct position
MADFile = 'all_elem.dat';    % Split skew quads ()
[THERING, Twiss] = readmad(MADFile);


% % Add a starting marker
% ElemData.FamName = 'SECTOR';
% ElemData.FamName = 'INITIAL';
% ElemData.Length = 0;
% ElemData.PassMethod = 'IdentityPass';
% ElemData.MADType = 'MARK';
% THERING = [{ElemData} THERING];

Spos = findspos(THERING, 1:length(THERING)+1);


% Shift the ring
j = find(Spos > 10, 1);
THERING = [THERING(j:end) THERING(1:j-1)];
Twiss.Alpha = Twiss.Alpha([(j:end) (1:j-1)]);
Twiss.Beta = Twiss.Beta([(j:end) (1:j-1)]);
Twiss.Mu = Twiss.Mu([(j:end) (1:j-1)]);
Twiss.d = Twiss.d([(j:end) (1:j-1)]);
Twiss.dp = Twiss.dp([(j:end) (1:j-1)]);
Twiss.a = Twiss.a([(j:end) (1:j-1)]);
Twiss.Px = Twiss.Px([(j:end) (1:j-1)]);
Twiss.y = Twiss.y([(j:end) (1:j-1)]);
Twiss.Py = Twiss.Py([(j:end) (1:j-1)]);
Twiss.s = Twiss.s([(j:end) (1:j-1)]);


% RF SYSTEM
% Length			length[m]
% Voltage			peak voltage (V)
% Frequency		    RF frequency [Hz]
% HarmNumber		Harmonic Number
% PassMethod		name of the function on disk to use for tracking
THERING{end+1}.FamName = 'CAV';
THERING{end}.MADType = 'RFCA';
THERING{end}.Length = 0;
THERING{end}.Voltage = 1.2e+6;
THERING{end}.Frequency = HarmNumber*C0/L0;  %1.098e6;  % HarmNumber*C0/L0 = 1.208694e6;  %  MHz
THERING{end}.HarmNumber = HarmNumber;
THERING{end}.PhaseLag = 0;
THERING{end}.PassMethod = 'CavityPass';


% End on a marker
THERING{end+1}.FamName = 'EndOfRing';
THERING{end}.MADType = 'MARK';
THERING{end}.Length = 0;
THERING{end}.PassMethod = 'IdentityPass';


Spos = findspos(THERING, 1:length(THERING)+1);

Sector = 1;
QFDev = 0;
QDDev = 0;
SkewQuadDev = 0;
SFDev = 0;
SDDev = 0;
SXDev = 0;
BendDev = 0;
BPMxDev = 0;
BPMyDev = 0;
HCMDev = 0;
VCMDev = 0;

QF.DeviceList = [];
QD.DeviceList = [];
SkewQuad.DeviceList = [];
SF.DeviceList = [];
SD.DeviceList = [];
SX.DeviceList = [];
BEND.DeviceList = [];
BPMx.DeviceList = [];
BPMy.DeviceList = [];
HCM.DeviceList = [];
VCM.DeviceList = [];

QF.N = [];
QD.N = [];
SkewQuad.N = [];
SF.N = [];
SD.N = [];
SX.N = [];
BEND.N = [];
BPMx.N = [];
BPMy.N = [];
HCM.N = [];
VCM.N = [];

BEND.ATIndex = [];

    
NN = length(THERING);
iWarn = 0;
SkewCounter = 0;

fprintf('   %d of %d elements of THERING included in this MML.\n', NN, length(THERING));

SectorLast = 1;
for i = 1:NN
    if Spos(i) < L0/4
        Sector = 1;
    elseif Spos(i) < L0/2
        Sector = 2;
    elseif Spos(i) < 3*L0/4
        Sector = 3;
    else
        Sector = 4;
    end
    if Sector > SectorLast
        SectorLast = Sector;
        QFDev = 0;
        QDDev = 0;
        SkewQuadDev = 0;
        SFDev = 0;
        SDDev = 0;
        SXDev = 0;
        BendDev = 0;
        BPMxDev = 0;
        BPMyDev = 0;
        HCMDev = 0;
        VCMDev = 0;
    end

    THERING{i}.MADName = THERING{i}.FamName;
    
    if strcmpi(THERING{i}.MADType, 'DRIF')
        % Drift
        THERING{i}.FamName = 'DRIFT';
        
    elseif strcmpi(THERING{i}.MADType, 'SBEN')
        % BEND
        %         if BendDev > 0
        %             Spos(i), Spos(BEND.ATIndex(end)), THERING{BEND.ATIndex(end)}.Length
        %             abs(Spos(i) - (Spos(BEND.ATIndex(end))+THERING{BEND.ATIndex(end)}.Length))
        %         end
        %if BendDev == 0 || (Sector==4 && BendDev>=9) || abs(Spos(i) - (Spos(BEND.ATIndex(end))+THERING{BEND.ATIndex(end)}.Length)) > 1e-6
        if Spos(i) < 230
            if BendDev == 0 || abs(Spos(i) - (Spos(BEND.ATIndex(end))+THERING{BEND.ATIndex(end)}.Length)) > 1e-6
                BEND.N = strvcat(BEND.N, THERING{i}.FamName);
                THERING{i}.FamName = 'BEND';
                BendDev = BendDev + 1;
                BEND.DeviceList = [BEND.DeviceList; Sector BendDev];
                BEND.ATIndex = [BEND.ATIndex; i];
            else
                THERING{i}.FamName = 'SplitBEND';
            end
        end
        
    elseif strcmpi(THERING{i}.MADType, 'QUAD')
        % Quadrupole
        if findstr(THERING{i}.MADName,'QSC')
            if strcmpi(MADFile, 'all_elem.dat')
                % Skews are split in 3
                SkewCounter = SkewCounter + 1;
                if SkewCounter == 1
                    SkewQuad.N = strvcat(SkewQuad.N, THERING{i}.FamName);
                    THERING{i}.FamName = 'SkewQuad';
                    SkewQuadDev = SkewQuadDev + 1;
                    SkewQuad.DeviceList(end+1,:) = [Sector SkewQuadDev];
                end
                if SkewCounter == 3
                    SkewCounter = 0;
                end
            else
                %fprintf('SkewQuad %s (#%d) L=%.1f (%.1f m)\n', THERING{i}.FamName, i, THERING{i}.Length, Spos(i));
                SkewQuad.N = strvcat(SkewQuad.N, THERING{i}.FamName);
                SkewQuadDev = SkewQuadDev + 1;
                SkewQuad.DeviceList(end+1,:) = [Sector SkewQuadDev];
            end
            THERING{i}.FamName = 'SkewQuad';
            
            % I'm not sure about this???
            % readmad seems to puts the k in .K and PolynomB when it should be .PolynomA
            THERING{i}.PolynomA(2) = THERING{i}.K;
            THERING{i}.K = 0;
            THERING{i}.PolynomB(2) = 0;
        elseif THERING{i}.K >= 0
            %fprintf('QF %s (#%d) L=%.1f (%.1f m)\n', THERING{i}.FamName, i, THERING{i}.Length, Spos(i));
            %THERING{i}.PolynomB
            %THERING{i}.PolynomA
            QF.N = strvcat(QF.N, THERING{i}.FamName);
            THERING{i}.FamName = 'QF';
            QFDev = QFDev + 1;
            QF.DeviceList(end+1,:) = [Sector QFDev];
        elseif THERING{i}.K < 0
            %fprintf('QD %s (#%d) L=%.1f (%.1f m)\n', THERING{i}.FamName, i, THERING{i}.Length, Spos(i));
            QD.N = strvcat(QD.N, THERING{i}.FamName);
            THERING{i}.FamName = 'QD';
            QDDev = QDDev + 1;
            QD.DeviceList(end+1,:) = [Sector QDDev];
        else
            fprintf('%s %s (#%d) L=%.1f (%.1f m) is off\n', THERING{i}.MADType, THERING{i}.FamName, i, THERING{i}.Length, Spos(i));
        end

    elseif strcmpi(THERING{i}.MADType, 'SEXT')
        % Sextupole
        if THERING{i}.PolynomB(3) >= 0
            SF.N = strvcat(SF.N, THERING{i}.FamName);
            THERING{i}.FamName = 'SF';
            SFDev = SFDev + 1;
            SF.DeviceList(end+1,:) = [Sector SFDev];
        elseif THERING{i}.PolynomB(3) < 0
            SD.N = strvcat(SD.N, THERING{i}.FamName);
            THERING{i}.FamName = 'SD';
            SDDev = SDDev + 1;
            SD.DeviceList(end+1,:) = [Sector SDDev];
        else
            fprintf('Unknown sextupole %s (#%d) is off\n', THERING{i}.MADType, i);
            %error('Unknown sextupole');            
        end

    elseif strcmpi(THERING{i}.MADType, 'RFCA')
        % Cavity
        THERING{i}.FamName = 'CAV';
        THERING{i}.HarmNumber = HarmNumber;

    elseif strcmpi(THERING{i}.MADType, 'LCAV')
        % Cavity with focusing
        THERING{i}.FamName = 'CAV';

    elseif strcmpi(THERING{i}.MADType, 'HKIC')
        %  6 = Horizontal corrector (HKIC)
        HCM.N = strvcat(HCM.N, THERING{i}.FamName);
        THERING{i}.FamName = 'HCM';
        HCMDev = HCMDev + 1;
        HCM.DeviceList = [HCM.DeviceList; Sector HCMDev];
        
    elseif strcmpi(THERING{i}.MADType, 'VKIC')
        %  7 = Vertical corrector   (VKIC)
        VCM.N = strvcat(VCM.N, THERING{i}.FamName);
        THERING{i}.FamName = 'VCM';
        VCMDev = VCMDev + 1;
        VCM.DeviceList = [VCM.DeviceList; Sector VCMDev];
        
    elseif strcmpi(THERING{i}.MADType, 'KICK')
        %  8 = H/V corrector        (KICK)
        HCM.N = strvcat(HCM.N, THERING{i}.FamName);
        VCM.N = strvcat(VCM.N, THERING{i}.FamName);

        THERING{i}.FamName = 'COR';
        HCMDev = HCMDev + 1;
        HCM.DeviceList = [HCM.DeviceList; Sector HCMDev];

        VCMDev = VCMDev + 1;
        VCM.DeviceList = [VCM.DeviceList; Sector VCMDev];
        
    elseif strcmpi(THERING{i}.MADType, 'HMON')
        %  9 = Horizontal BPM       (HMON)
        BPMx.N = strvcat(BPMx.N, THERING{i}.FamName);
        THERING{i}.FamName = 'BPM';
        BPMxDev = BPMxDev + 1;
        BPMx.DeviceList = [BPMx.DeviceList; Sector BPMxDev];
        
    elseif strcmpi(THERING{i}.MADType, 'VMON')
        % 10 = Vertical BPM         (VMON)
        BPMy.N = strvcat(BPMy.N, THERING{i}.FamName);
        THERING{i}.FamName = 'BPM';
        BPMyDev = BPMyDev + 1;
        BPMy.DeviceList = [BPMy.DeviceList; Sector BPMyDev];
        
    elseif strcmpi(THERING{i}.MADType, 'MONI')
        % 11 = H/V BPM              (MONI)
        BPMx.N = strvcat(BPMx.N, THERING{i}.FamName);
        BPMy.N = strvcat(BPMy.N, THERING{i}.FamName);

        THERING{i}.FamName = 'BPM';
        BPMxDev = BPMxDev + 1;
        BPMx.DeviceList = [BPMx.DeviceList; Sector BPMxDev];

        BPMyDev = BPMyDev + 1;
        BPMy.DeviceList = [BPMy.DeviceList; Sector BPMyDev];
        
    elseif strcmpi(THERING{i}.MADType, 'MARK')
        % 12 = Marker point         (MARK)
    else
        % Not sure what it is
        fprintf('   Warning:  element %d, unknown MAD type "%s" for FamNam "%s"\n', i, THERING{i}.MADType, THERING{i}.FamName);
    end
end

% Remove MSI31 from the device list
HCM.DeviceList(end-1,:) = [];
HCM.N(end-1,:) = [];

% Cut THERING
%THERING = THERING(4:NN);

clear global FAMLIST GLOBVAL


% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);


% Compute total length and RF frequency
fprintf('   L0 = %.6f m  (design length %f m)\n', Spos(end), L0);
fprintf('   RF = %.6f MHz \n', HarmNumber*C0/Spos(end)/1e6);


