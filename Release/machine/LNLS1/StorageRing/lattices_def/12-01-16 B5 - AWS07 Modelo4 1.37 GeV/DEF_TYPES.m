function TYPES = DEF_TYPES

QUAD_LENGTH     = '0.27';
QUAD_PASSMETHOD = 'QuadLinearPass';

%QF.STRENGTH   = '2.765162278976464';
QF.STRENGTH = '2.769902865309953';
QF.LENGTH     = QUAD_LENGTH;
QF.PASSMETHOD = QUAD_PASSMETHOD;
QF.TEMPLATE_ELEMENT = { ...
    'e1 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2];'; ...
    };

%QD.STRENGTH   = '-2.952792922637205';
QD.STRENGTH   = '-2.966971023597965';
QD.LENGTH     = QUAD_LENGTH;
QD.PASSMETHOD = QUAD_PASSMETHOD;
QD.TEMPLATE_ELEMENT = { ...
    'e1 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2];'; ...
    };

QFC.STRENGTH   = '1.961093182324501';
QFC.LENGTH     = QUAD_LENGTH;
QFC.PASSMETHOD = QUAD_PASSMETHOD;
QFC.COR_FAMN   = 'VCM';
QFC.COR_PASSM  = 'CorrectorPass';
QFC.TEMPLATE_ELEMENT = { ...
    'e1 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = corrector  (''COR_FAMN'', 0.00000, [0 0], ''COR_PASSM'');'; ...
    'e3 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2 e3];'; ...
    };

TYPES.MARKER.TYPENAME   = 'MARKER';
TYPES.MARKER.FAMNAME    = 'MARKER';
TYPES.MARKER.LENGTH     = '0';
TYPES.MARKER.PASSMETHOD = 'IdentityPass';
TYPES.MARKER.TEMPLATE_ELEMENT = { ...
    'e1 = marker(''FAMNAME'', ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };


%% QUADRUPOLE FAMILIES %%

TYPES.A2QF01 = QF;
TYPES.A2QF01.TYPENAME = 'A2QF01';
TYPES.A2QF01.FAMNAME  = 'A2QF01';
%TYPES.A2QF01.STRENGTH   = '2.765248531946330';

TYPES.A2QF03 = QF;
TYPES.A2QF03.TYPENAME = 'A2QF03';
TYPES.A2QF03.FAMNAME  = 'A2QF03';

TYPES.A2QF05 = QF;
TYPES.A2QF05.TYPENAME = 'A2QF05';
TYPES.A2QF05.FAMNAME  = 'A2QF05';

TYPES.A2QF07 = QF;
TYPES.A2QF07.TYPENAME = 'A2QF07';
TYPES.A2QF07.FAMNAME  = 'A2QF07';

TYPES.A2QF09 = QF;
TYPES.A2QF09.TYPENAME = 'A2QF09';
TYPES.A2QF09.FAMNAME  = 'A2QF09';
%TYPES.A2QF09.STRENGTH   = '2.772580790508343';

TYPES.A2QF11 = QF;
TYPES.A2QF11.TYPENAME = 'A2QF11';
TYPES.A2QF11.FAMNAME  = 'A2QF11';
%TYPES.A2QF11.STRENGTH   = '2.765157690172940';

TYPES.A2QD01 = QD;
TYPES.A2QD01.TYPENAME = 'A2QD01';
TYPES.A2QD01.FAMNAME  = 'A2QD01';
%TYPES.A2QD01.STRENGTH   = '-2.953063252735311';

TYPES.A2QD03 = QD;
TYPES.A2QD03.TYPENAME = 'A2QD03';
TYPES.A2QD03.FAMNAME  = 'A2QD03';

TYPES.A2QD05 = QD;
TYPES.A2QD05.TYPENAME = 'A2QD05';
TYPES.A2QD05.FAMNAME  = 'A2QD05';

TYPES.A2QD07 = QD;
TYPES.A2QD07.TYPENAME = 'A2QD07';
TYPES.A2QD07.FAMNAME  = 'A2QD07';

TYPES.A2QD09 = QD;
TYPES.A2QD09.TYPENAME = 'A2QD09';
TYPES.A2QD09.FAMNAME  = 'A2QD09';
%TYPES.A2QD09.STRENGTH   = '-2.975670943361592';

TYPES.A2QD11 = QD;
TYPES.A2QD11.TYPENAME = 'A2QD11';
TYPES.A2QD11.FAMNAME  = 'A2QD11';
%TYPES.A2QD11.STRENGTH   = '-2.952778814070184';

TYPES.A6QF01 = QFC;
TYPES.A6QF01.TYPENAME = 'A6QF01';
TYPES.A6QF01.FAMNAME  = 'A6QF01';

TYPES.A6QF02 = QFC;
TYPES.A6QF02.TYPENAME = 'A6QF02';
TYPES.A6QF02.FAMNAME  = 'A6QF02';


TYPES.SKEWQUAD.TYPENAME   = 'SKEWQUAD';
TYPES.SKEWQUAD.FAMNAME    = 'SKEWQUAD';
TYPES.SKEWQUAD.LENGTH     = '0.1';
TYPES.SKEWQUAD.STRENGTH   = '0';
TYPES.SKEWQUAD.PASSMETHOD = 'QuadLinearPass';
TYPES.SKEWQUAD.TEMPLATE_ELEMENT = { ...
    'e1 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2];'; ...
    };

TYPES.SKEWCORR.TYPENAME   = 'SKEWCORR';
TYPES.SKEWCORR.FAMNAME    = 'SKEWCORR';
TYPES.SKEWCORR.LENGTH     = '0.025';
TYPES.SKEWCORR.STRENGTH   = '0';
TYPES.SKEWCORR.PASSMETHOD = 'QuadLinearPass';
TYPES.SKEWCORR.TEMPLATE_ELEMENT = { ...
    'e1 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2];'; ...
    };

%% DIPOLES

TYPES.A12DI.TYPENAME   = 'A12DI';
TYPES.A12DI.FAMNAME    = 'BEND';
TYPES.A12DI.LENGTH     = '1.432';
TYPES.A12DI.PASSMETHOD = 'BndMPoleSymplectic4Pass';
TYPES.A12DI.TEMPLATE_ELEMENT = { ...
    'e1 = rbend(''FAMNAME'', LENGTH*(4/30),  (2*pi/12)*(4/30), (2*pi/12)/2, 0, 0, ''PASSMETHOD'');'; ...
    'e2 = marker(''RAD4G'', ''IdentityPass'');'; ...
    'e3 = rbend(''FAMNAME'', LENGTH*(11/30), (2*pi/12)*(11/30), 0, 0, 0, ''PASSMETHOD'');'; ...
    'e4 = marker(''RAD15G'', ''IdentityPass'');'; ...
    'e5 = rbend(''FAMNAME'', LENGTH*(15/30), (2*pi/12)*(15/30), 0, (2*pi/12)/2, 0, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2 e3 e4 e5];'; ...
    };


%% SEXTUPOLES %%

TYPES.A6SF.TYPENAME   = 'A6SF';
TYPES.A6SF.FAMNAME    = 'A6SF';
TYPES.A6SF.LENGTH     = '0.1';
TYPES.A6SF.STRENGTH   = '52.690335419566956';
TYPES.A6SF.PASSMETHOD = 'StrMPoleSymplectic4Pass';
TYPES.A6SF.TEMPLATE_ELEMENT = { ...
    'e1 = sextupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = marker(''SCENTER'', ''IdentityPass'');'; ...
    'e3 = sextupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2 e3];'; ...
    };

TYPES.A6SD01.TYPENAME   = 'A6SD01';
TYPES.A6SD01.FAMNAME    = 'A6SD01';
TYPES.A6SD01.LENGTH     = '0.1';
TYPES.A6SD01.STRENGTH   = '-34.696842207727805';
TYPES.A6SD01.PASSMETHOD = 'StrMPoleSymplectic4Pass';
TYPES.A6SD01.TEMPLATE_ELEMENT = { ...
    'e1 = sextupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = sextupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2];'; ...
    };

TYPES.A6SD02.TYPENAME   = 'A6SD02';
TYPES.A6SD02.FAMNAME    = 'A6SD02';
TYPES.A6SD02.LENGTH     = '0.1';
TYPES.A6SD02.STRENGTH   = '-34.619552516400347';
TYPES.A6SD02.PASSMETHOD = 'StrMPoleSymplectic4Pass';
TYPES.A6SD02.TEMPLATE_ELEMENT = { ...
    'e1 = sextupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = sextupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2];'; ...
    };


%% MARKERS

TYPES.MBEGIN.TYPENAME   = 'MBEGIN';
TYPES.MBEGIN.FAMNAME    = 'BEGIN';
TYPES.MBEGIN.LENGTH     = '0';
TYPES.MBEGIN.PASSMETHOD = 'IdentityPass';
TYPES.MBEGIN.TEMPLATE_ELEMENT = { ...
    'e1 = marker(''FAMNAME'', ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };

TYPES.ATR.TYPENAME   = 'ATR';
TYPES.ATR.FAMNAME    = 'ATR';
TYPES.ATR.LENGTH     = '0';
TYPES.ATR.PASSMETHOD = 'DriftPass';
TYPES.ATR.TEMPLATE_ELEMENT = {'drift(''FAMNAME'', LENGTH, ''PASSMETHOD'');';};

TYPES.LCENTER.TYPENAME   = 'LCENTER';
TYPES.LCENTER.FAMNAME    = 'LCENTER';
TYPES.LCENTER.LENGTH     = '0';
TYPES.LCENTER.PASSMETHOD = 'IdentityPass';
TYPES.LCENTER.TEMPLATE_ELEMENT = { ...
    'e1 = marker(''FAMNAME'', ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };


%% RF

TYPES.RF.TYPENAME   = 'RF';
TYPES.RF.FAMNAME    = 'RF';
TYPES.RF.LENGTH     = '0';
TYPES.RF.VOLTAGE    = '0.25e+6';
TYPES.RF.FREQUENCY  = '476065680';
TYPES.RF.HARMNUMBER = '148';
TYPES.RF.PASSMETHOD = 'CavityPass';
TYPES.RF.TEMPLATE_ELEMENT = { ...
    'e1 = rfcavity(''FAMNAME'', LENGTH, VOLTAGE, FREQUENCY, HARMNUMBER, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };



%% BPMS

TYPES.BPM.TYPENAME   = 'BPM';
TYPES.BPM.FAMNAME    = 'BPM';
TYPES.BPM.LENGTH     = '0';
TYPES.BPM.PASSMETHOD = 'IdentityPass';
TYPES.BPM.TEMPLATE_ELEMENT = { ...
    'e1 = marker(''FAMNAME'', ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };
	
	
%% INJECTION POINT
TYPES.INJECTION.TYPENAME   = 'INJECTION';
TYPES.INJECTION.FAMNAME    = 'INJECTION';
TYPES.INJECTION.LENGTH     = '0';
TYPES.INJECTION.PASSMETHOD = 'IdentityPass';
TYPES.INJECTION.TEMPLATE_ELEMENT = { ...
    'e1 = marker(''FAMNAME'', ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };
	
	
%% PSM

TYPES.PSM.TYPENAME   = 'PSM';
TYPES.PSM.FAMNAME    = 'PSM';
TYPES.PSM.LENGTH     = '0';
TYPES.PSM.PASSMETHOD = 'IdentityPass';
TYPES.PSM.TEMPLATE_ELEMENT = { ...
    'e1 = marker(''FAMNAME'', ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };


%% CORRECTORS

TYPES.ACH.TYPENAME   = 'ACH';
TYPES.ACH.FAMNAME    = 'HCM';
TYPES.ACH.LENGTH     = '0*0.081';
TYPES.ACH.PASSMETHOD = 'CorrectorPass';
TYPES.ACH.TEMPLATE_ELEMENT = { ...
    'e1 = corrector(''FAMNAME'', LENGTH, [0 0], ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };

TYPES.ACV.TYPENAME   = 'ACV';
TYPES.ACV.FAMNAME    = 'VCM';
TYPES.ACV.LENGTH     = '0*0.081';
TYPES.ACV.PASSMETHOD = 'CorrectorPass';
TYPES.ACV.TEMPLATE_ELEMENT = { ...
    'e1 = corrector(''FAMNAME'', LENGTH, [0 0], ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };

%% INJECTION KICKERS

TYPES.INJKICKER.TYPENAME   = 'INJKICKER';
TYPES.INJKICKER.FAMNAME    = 'INJKICKER';
TYPES.INJKICKER.LENGTH     = '0';
TYPES.INJKICKER.PASSMETHOD = 'CorrectorPass';
TYPES.INJKICKER.TEMPLATE_ELEMENT = { ...
    'e1 = corrector(''FAMNAME'', LENGTH, [0 0], ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };


%% INSERTION DEVICES

simplified_ids = false;

%% AWG01 - 2T STI WIGGLER
if simplified_ids
    
    TYPES.AWG01.TYPENAME   = 'AWG01';
    TYPES.AWG01.FAMNAME    = 'AWG01';
    TYPES.AWG01.LENGTH     = '2.7';
    TYPES.AWG01.PASSMETHOD = 'DriftPass';
    TYPES.AWG01.TEMPLATE_ELEMENT = { ...
        'e1 = drift(''FAMNAME'', LENGTH/2, ''PASSMETHOD'');'; ...
        'e2 = marker(''BEGIN'',''IdentityPass'');'; ...
        'e3 = drift(''FAMNAME'', LENGTH/2, ''PASSMETHOD'');'; ...
        'TYPENAME_element = [e1 e2 e3];'; ...
        };
    
else
    
    
    
    period  = 0.18;
    poles   = [0.5 repmat([-1 1],1,14) -0.5];
    field   = 2e-0;
    rho0    = (10/3) * (1.37 / field);
    rho     = 4 * rho0 / pi;
    lhe     = 4 * period / pi^2;
    ang     = lhe/rho;
    ldr     = (period/2) - 2*rho*sin(0.5*ang);
    
    len     = length(poles)*(lhe + ldr);
    TYPES.AWG01.LENGTH      = num2str(len, '%18.15f');
    TYPES.AWG01.TYPENAME    = 'AWG01';
    TYPES.AWG01.FAMNAME     = 'AWG01';
    TYPES.AWG01.LEN1        = num2str(lhe, '%18.15f');
    %TYPES.AWG01.LEN2        = num2str(ldr/2, '%18.15f');
    TYPES.AWG01.PASSMETHOD1 = 'BndMPoleSymplectic4Pass';
    TYPES.AWG01.PASSMETHOD2 = 'DriftPass';
    
    TYPES.AWG01.TEMPLATE_ELEMENT = {};
    idx = 0;
    strline = 'TYPENAME_element = [';
    for i=1:length(poles)
        rho0    = (10/3) * (1.37 / (poles(i)*field));
        rho     = 4 * rho0 / pi;
        this_angle     = lhe/rho;
        ldr     = (period/2) - 2*rho*sin(0.5*this_angle);
        idx = idx + 1;
        strline1 = ['e' int2str(idx) ' = drift(''FAMNAME'', ' num2str(ldr/2, '%18.15f') ', ''PASSMETHOD2'');'];
        TYPES.AWG01.TEMPLATE_ELEMENT{idx,1} = strline1; strline = [strline ' e' int2str(idx)];
        idx = idx + 1;
        strline2 = ['e' int2str(idx) ' = rbend(''FAMNAME'', LEN1, ' num2str(this_angle, '%18.15f') ','  num2str(this_angle/2, '%18.15f') ',' num2str(this_angle/2, '%18.15f'), ', 0, ''PASSMETHOD1'');'];
        TYPES.AWG01.TEMPLATE_ELEMENT{idx,1} = strline2; strline = [strline ' e' int2str(idx)];
        idx = idx + 1;
        strline1 = ['e' int2str(idx) ' = drift(''FAMNAME'', ' num2str(ldr/2, '%18.15f') ', ''PASSMETHOD2'');'];
        TYPES.AWG01.TEMPLATE_ELEMENT{idx,1} = strline1; strline = [strline ' e' int2str(idx)];
        if i==(length(poles)/2)
            idx = idx + 1;
            strline1 = ['e' int2str(idx) ' = marker(''BEGIN'', ''IdentityPass'');'];
            TYPES.AWG01.TEMPLATE_ELEMENT{idx,1} = strline1; strline = [strline ' e' int2str(idx)];
            idx = idx + 1;
            strline1 = ['e' int2str(idx) ' = marker(''LCENTER'', ''IdentityPass'');'];
            TYPES.AWG01.TEMPLATE_ELEMENT{idx,1} = strline1; strline = [strline ' e' int2str(idx)];
        end
    end
    strline = [strline '];'];
    idx = idx + 1; TYPES.AWG01.TEMPLATE_ELEMENT{idx,1} = strline;
    
end

%% AON11 - EPU
if simplified_ids
    
    TYPES.AON11.TYPENAME   = 'AON11';
    TYPES.AON11.FAMNAME    = 'AON11';
    TYPES.AON11.LENGTH     = '2.8';
    TYPES.AON11.PASSMETHOD = 'DriftPass';
    TYPES.AON11.TEMPLATE_ELEMENT = { ...
        'e1 = drift(''FAMNAME'', LENGTH/2, ''PASSMETHOD'');'; ...
        'e2 = marker(''AON11'',''IdentityPass'');'; ...
        'e3 = drift(''FAMNAME'', LENGTH/2, ''PASSMETHOD'');'; ...
        'TYPENAME_element = [e1 e2 e3];'; ...
        };
    
else
    
    
    period  = 0.05;
    poles   = [-0.5 repmat([-1 1],1,56) 0.5];
    field   = 0.48e-0;
    rho0    = (10/3) * (1.37 / field);
    rho     = 4 * rho0 / pi;
    lhe     = 4 * period / pi^2;
    ang     = lhe/rho;
    ldr     = (period/2) - 2*rho*sin(0.5*ang);
    
    len     = length(poles)*(lhe + ldr);
    TYPES.AON11.LENGTH      = num2str(len, '%18.15f');
    TYPES.AON11.TYPENAME    = 'AON11';
    TYPES.AON11.FAMNAME     = 'AON11';
    TYPES.AON11.LEN1        = num2str(lhe, '%18.15f');
    %TYPES.AON11.LEN2        = num2str(ldr/2, '%18.15f');
    TYPES.AON11.PASSMETHOD1 = 'BndMPoleSymplectic4Pass';
    TYPES.AON11.PASSMETHOD2 = 'DriftPass';
    
    TYPES.AON11.TEMPLATE_ELEMENT = {};
    idx = 0;
    strline = 'TYPENAME_element = [';
    for i=1:length(poles)
        rho0    = (10/3) * (1.37 / (poles(i)*field));
        rho     = 4 * rho0 / pi;
        this_angle     = lhe/rho;
        ldr     = (period/2) - 2*rho*sin(0.5*this_angle);
        idx = idx + 1;
        strline1 = ['e' int2str(idx) ' = drift(''FAMNAME'', ' num2str(ldr/2, '%18.15f') ', ''PASSMETHOD2'');'];
        TYPES.AON11.TEMPLATE_ELEMENT{idx,1} = strline1; strline = [strline ' e' int2str(idx)];
        idx = idx + 1;
        strline2 = ['e' int2str(idx) ' = rbend(''FAMNAME'', LEN1, ' num2str(this_angle, '%18.15f') ','  num2str(this_angle/2, '%18.15f') ',' num2str(this_angle/2, '%18.15f'), ', 0, ''PASSMETHOD1'');'];
        TYPES.AON11.TEMPLATE_ELEMENT{idx,1} = strline2; strline = [strline ' e' int2str(idx)];
        idx = idx + 1;
        strline1 = ['e' int2str(idx) ' = drift(''FAMNAME'', ' num2str(ldr/2, '%18.15f') ', ''PASSMETHOD2'');'];
        TYPES.AON11.TEMPLATE_ELEMENT{idx,1} = strline1; strline = [strline ' e' int2str(idx)];
        if i==(length(poles)/2)
            idx = idx + 1;
            strline1 = ['e' int2str(idx) ' = marker(''LCENTER'', ''IdentityPass'');'];
            TYPES.AON11.TEMPLATE_ELEMENT{idx,1} = strline1; strline = [strline ' e' int2str(idx)];
        end
    end
    strline = [strline '];'];
    idx = idx + 1; TYPES.AON11.TEMPLATE_ELEMENT{idx,1} = strline;
    
end


%% AWG01 - 4T SC WIGGLER

if simplified_ids
    
    
    TYPES.AWG09.TYPENAME   = 'AWG09';
    TYPES.AWG09.FAMNAME    = 'AWG09';
    TYPES.AWG09.LENGTH     = '1.1';
    TYPES.AWG09.PASSMETHOD = 'DriftPass';
    TYPES.AWG09.TEMPLATE_ELEMENT = { ...
        'e1 = drift(''FAMNAME'', LENGTH/2, ''PASSMETHOD'');'; ...
        'e2 = marker(''AWI09'',''IdentityPass'');'; ...
        'e3 = drift(''FAMNAME'', LENGTH/2, ''PASSMETHOD'');'; ...
        'TYPENAME_element = [e1 e2 e3];'; ...
        };
    
else
    
    period  = 0.06;
    %poles   = [-1/4 3/4 repmat([-1 1],1,7) -1 repmat([1 -1],1,8) 3/4 -1/4];
    poles   = [0.5 repmat([-1 1],1,16) -0.5];
    field   = 4.0e-0;
    rho0    = (10/3) * (1.37 / field);
    rho     = 4 * rho0 / pi;
    lhe     = 4 * period / pi^2;
    ang     = lhe/rho;
    ldr     = (period/2) - 2*rho*sin(0.5*ang);
    
    len     = length(poles)*(lhe + ldr);
    TYPES.AWG09.LENGTH      = num2str(len, '%18.15f');
    TYPES.AWG09.TYPENAME    = 'AWG09';
    TYPES.AWG09.FAMNAME     = 'AWG09';
    TYPES.AWG09.LEN1        = num2str(lhe, '%18.15f');
    %TYPES.AWG09.LEN2        = num2str(ldr/2, '%18.15f');
    TYPES.AWG09.PASSMETHOD1 = 'BndMPoleSymplectic4Pass';
    TYPES.AWG09.PASSMETHOD2 = 'DriftPass';
    
    TYPES.AWG09.TEMPLATE_ELEMENT = {};
    idx = 0;
    strline = 'TYPENAME_element = [';
    for i=1:length(poles)
        rho0    = (10/3) * (1.37 / (poles(i)*field));
        rho     = 4 * rho0 / pi;
        this_angle     = lhe/rho;
        ldr     = (period/2) - 2*rho*sin(0.5*this_angle);
        idx = idx + 1;
        strline1 = ['e' int2str(idx) ' = drift(''FAMNAME'', ' num2str(ldr/2, '%18.15f') ', ''PASSMETHOD2'');'];
        TYPES.AWG09.TEMPLATE_ELEMENT{idx,1} = strline1; strline = [strline ' e' int2str(idx)];
        idx = idx + 1;
        strline2 = ['e' int2str(idx) ' = rbend(''FAMNAME'', LEN1, ' num2str(this_angle, '%18.15f') ','  num2str(this_angle/2, '%18.15f') ',' num2str(this_angle/2, '%18.15f'), ', 0, ''PASSMETHOD1'');'];
        TYPES.AWG09.TEMPLATE_ELEMENT{idx,1} = strline2; strline = [strline ' e' int2str(idx)];
        idx = idx + 1;
        strline1 = ['e' int2str(idx) ' = drift(''FAMNAME'', ' num2str(ldr/2, '%18.15f') ', ''PASSMETHOD2'');'];
        TYPES.AWG09.TEMPLATE_ELEMENT{idx,1} = strline1; strline = [strline ' e' int2str(idx)];
        if i==(length(poles)/2)
            idx = idx + 1;
            strline1 = ['e' int2str(idx) ' = marker(''LCENTER'', ''IdentityPass'');'];
            TYPES.AWG09.TEMPLATE_ELEMENT{idx,1} = strline1; strline = [strline ' e' int2str(idx)];
        end
    end
    strline = [strline '];'];
    idx = idx + 1; TYPES.AWG09.TEMPLATE_ELEMENT{idx,1} = strline;
    
    
end



%% AWS07 


AWS07Data = [ ...
% AWS07_Modelo 4_-35_35mm_-950_950mm.txt @ 1.37 GeV
%    Length[m]        Angle[rad]       Dip[1/m]         Quad[1/m^2]      Sext[1/m^3]      Oct[1/m^4]       Deca[1/m^5]      Duodec[1/m^6]    ...
% ------------------------------------------------------------------------------------------------------------------------------------------------------------
% +7.9958630E-001, +1.0642243E-004, +0.0000000E+000, -9.6664202E-003, -6.8624040E-002, +7.2146498E-002, -6.9234338E+001, +3.2823316E+002, +4.1578082E+005; ... 
% ------------------------------------------------------------------------------------------------------------------------------------------------------------
+1.1550000E-001, -1.0863773E-004, -0.0000000E+000, +1.7407460E-006, +1.2635598E-002, -2.8711288E-005, -1.1767042E-001, +1.2393518E-002, +8.7317494E+001; ... 
+1.3800000E-001, -6.6017979E-004, -0.0000000E+000, +4.3351665E-005, +6.2990081E-002, +7.9633767E-005, +1.0823000E+000, -1.2642029E-002, -2.3536978E+001; ... 
+4.3484684E-002, -8.0003083E-004, -0.0000000E+000, +5.1153696E-004, +1.0954355E-001, +2.7851200E-003, +5.4588135E+000, +1.0619766E-001, +2.1669150E+002; ... 
+1.8662551E-002, -7.2560637E-004, -0.0000000E+000, +2.6024321E-003, +8.9944170E-002, +1.2016300E-002, +1.2796314E+001, -8.4540224E+000, -4.2817320E+003; ... 
+9.9261477E-003, -6.7290664E-004, -0.0000000E+000, +9.4316172E-003, +1.8215499E-002, +1.7057253E-001, +1.2791220E+002, -2.0611235E+002, -6.5817075E+004; ... 
+5.6573887E-003, -6.1170072E-004, -0.0000000E+000, +2.6848751E-002, -2.7615043E-001, +8.8006305E-001, -5.4017150E+001, -3.4655844E+002, +1.1816406E+006; ... 
+3.6732980E-003, -5.8313796E-004, -0.0000000E+000, +5.5956859E-002, -4.5277908E-001, +2.1084062E+000, -6.9121162E+003, +4.4247577E+003, +1.6666628E+007; ... 
+2.8874279E-003, -6.2535799E-004, -0.0000000E+000, +7.6103563E-002, -3.3365802E-001, -1.2584000E+001, -1.4853976E+004, +4.1881473E+004, +3.2724557E+007; ... 
%-- MAGNET EDGE --
+5.1225392E-004, -1.1094375E-004, -0.0000000E+000, +7.6103563E-002, -3.3365802E-001, -1.2584000E+001, -1.4853976E+004, +4.1881473E+004, +3.2724557E+007; ... 
+9.0280220E-003, -2.4246541E-003, -0.0000000E+000, -3.3335465E-004, -7.3660825E-001, -2.2810162E+000, -2.9952270E+003, +1.0836322E+004, +8.1529231E+006; ... 
+2.9815552E-003, -6.8096621E-004, -0.0000000E+000, -1.3929885E-001, -4.4086167E+000, +1.4571384E+001, +1.1433819E+004, -2.0582417E+004, -9.5484458E+006; ... 
+2.9461510E-003, -4.9923910E-004, -0.0000000E+000, -1.7214248E-001, -2.5290655E+000, +6.1472462E+000, +5.4197758E+003, -6.6223595E+003, -2.4050389E+006; ... 
+2.9501591E-003, -3.3392219E-004, -0.0000000E+000, -1.5118075E-001, -1.3961850E+000, +3.4990996E+000, +3.5953520E+003, -4.1570810E+003, -3.0211184E+006; ... 
+3.1231576E-003, -2.0762003E-004, -0.0000000E+000, -1.2401754E-001, -6.3260370E-001, +1.2931440E+000, +1.6088095E+003, -1.2004421E+003, -1.4328045E+006; ... 
+4.2238545E-003, -8.8942303E-005, -0.0000000E+000, -1.0420766E-001, -2.5765740E-001, +5.2133245E-001, +5.2318911E+002, -3.2911937E+002, -4.3479223E+005; ... 
+4.4296484E-003, +1.1255272E-004, -0.0000000E+000, -9.4606542E-002, -1.4127899E-001, +1.3004367E-001, +1.0627847E+002, +8.6285619E+001, -7.5995375E+004; ... 
+4.3188501E-003, +3.0618668E-004, -0.0000000E+000, -9.4906246E-002, -1.4803198E-001, +1.7168924E-001, +2.8834828E+001, -1.5792872E+002, -4.1751227E+004; ... 
+3.5413979E-003, +4.0602099E-004, -0.0000000E+000, -1.0131336E-001, -1.7626226E-001, -7.8431967E-002, -5.4403053E+001, +3.8663752E+002, +5.2410704E+004; ... 
+3.8143761E-003, +6.1661141E-004, -0.0000000E+000, -1.1164906E-001, -2.2010190E-001, +5.4587191E-002, -6.4565748E+001, +3.6014944E+001, +3.7908471E+004; ... 
+2.8395683E-003, +6.0078374E-004, -0.0000000E+000, -1.2192393E-001, -2.6052724E-001, -1.6849560E-001, -1.3256902E+002, +3.9373339E+002, +1.2402429E+005; ... 
+2.8521302E-003, +7.4629516E-004, -0.0000000E+000, -1.2738680E-001, -2.7517982E-001, -6.2022370E-001, -3.5424581E+002, +1.3210744E+003, +4.4710004E+005; ... 
+2.4758411E-003, +7.7881126E-004, -0.0000000E+000, -1.2558969E-001, -2.8870119E-001, -9.0365332E-001, -5.6789121E+002, +1.7955183E+003, +7.7008193E+005; ... 
+2.5899321E-003, +9.5742345E-004, -0.0000000E+000, -1.1611035E-001, -3.5362494E-001, -8.5745178E-001, -5.8415125E+002, +2.1400595E+003, +9.2613990E+005; ... 
+2.4799405E-003, +1.0627560E-003, -0.0000000E+000, -9.8171980E-002, -4.6151575E-001, -1.9085744E+000, -2.8085559E+002, +5.0164808E+003, +4.4298377E+005; ... 
+2.4611505E-003, +1.1963022E-003, -0.0000000E+000, -6.7244565E-002, -5.8929340E-001, +2.7481089E-001, -3.4405950E+002, +1.2945377E+003, +1.0694340E+006; ... 
+4.4336616E-003, +2.4033133E-003, -0.0000000E+000, -1.7419547E-002, -8.6145495E-001, +3.6251309E+000, +1.0217562E+003, -4.8756506E+003, -6.4381764E+005; ... 
%-- FIELDMAP CENTER --
+4.4336616E-003, +2.4033133E-003, -0.0000000E+000, -1.7419547E-002, -8.6145495E-001, +3.6251309E+000, +1.0217562E+003, -4.8756506E+003, -6.4381764E+005; ... 
+2.4611505E-003, +1.1963022E-003, -0.0000000E+000, -6.7244565E-002, -5.8929340E-001, +2.7481089E-001, -3.4405950E+002, +1.2945377E+003, +1.0694340E+006; ... 
+2.4799405E-003, +1.0627560E-003, -0.0000000E+000, -9.8171980E-002, -4.6151575E-001, -1.9085744E+000, -2.8085559E+002, +5.0164808E+003, +4.4298377E+005; ... 
+2.5899321E-003, +9.5742345E-004, -0.0000000E+000, -1.1611035E-001, -3.5362494E-001, -8.5745178E-001, -5.8415125E+002, +2.1400595E+003, +9.2613990E+005; ... 
+2.4758411E-003, +7.7881126E-004, -0.0000000E+000, -1.2558969E-001, -2.8870119E-001, -9.0365332E-001, -5.6789121E+002, +1.7955183E+003, +7.7008193E+005; ... 
+2.8521302E-003, +7.4629516E-004, -0.0000000E+000, -1.2738680E-001, -2.7517982E-001, -6.2022370E-001, -3.5424581E+002, +1.3210744E+003, +4.4710004E+005; ... 
+2.8395683E-003, +6.0078374E-004, -0.0000000E+000, -1.2192393E-001, -2.6052724E-001, -1.6849560E-001, -1.3256902E+002, +3.9373339E+002, +1.2402429E+005; ... 
+3.8143761E-003, +6.1661141E-004, -0.0000000E+000, -1.1164906E-001, -2.2010190E-001, +5.4587191E-002, -6.4565748E+001, +3.6014944E+001, +3.7908471E+004; ... 
+3.5413979E-003, +4.0602099E-004, -0.0000000E+000, -1.0131336E-001, -1.7626226E-001, -7.8431967E-002, -5.4403053E+001, +3.8663752E+002, +5.2410704E+004; ... 
+4.3188501E-003, +3.0618668E-004, -0.0000000E+000, -9.4906246E-002, -1.4803198E-001, +1.7168924E-001, +2.8834828E+001, -1.5792872E+002, -4.1751227E+004; ... 
+4.4296484E-003, +1.1255272E-004, -0.0000000E+000, -9.4606542E-002, -1.4127899E-001, +1.3004367E-001, +1.0627847E+002, +8.6285619E+001, -7.5995375E+004; ... 
+4.2238545E-003, -8.8942303E-005, -0.0000000E+000, -1.0420766E-001, -2.5765740E-001, +5.2133245E-001, +5.2318911E+002, -3.2911937E+002, -4.3479223E+005; ... 
+3.1231576E-003, -2.0762003E-004, -0.0000000E+000, -1.2401754E-001, -6.3260370E-001, +1.2931440E+000, +1.6088095E+003, -1.2004421E+003, -1.4328045E+006; ... 
+2.9501591E-003, -3.3392219E-004, -0.0000000E+000, -1.5118075E-001, -1.3961850E+000, +3.4990996E+000, +3.5953520E+003, -4.1570810E+003, -3.0211184E+006; ... 
+2.9461510E-003, -4.9923910E-004, -0.0000000E+000, -1.7214248E-001, -2.5290655E+000, +6.1472462E+000, +5.4197758E+003, -6.6223595E+003, -2.4050389E+006; ... 
+2.9815552E-003, -6.8096621E-004, -0.0000000E+000, -1.3929885E-001, -4.4086167E+000, +1.4571384E+001, +1.1433819E+004, -2.0582417E+004, -9.5484458E+006; ... 
+9.0280220E-003, -2.4246541E-003, -0.0000000E+000, -3.3335465E-004, -7.3660825E-001, -2.2810162E+000, -2.9952270E+003, +1.0836322E+004, +8.1529231E+006; ... 
+5.1225392E-004, -1.1094375E-004, -0.0000000E+000, +7.6103563E-002, -3.3365802E-001, -1.2584000E+001, -1.4853976E+004, +4.1881473E+004, +3.2724557E+007; ... 
%-- MAGNET EDGE --
+2.8874279E-003, -6.2535799E-004, -0.0000000E+000, +7.6103563E-002, -3.3365802E-001, -1.2584000E+001, -1.4853976E+004, +4.1881473E+004, +3.2724557E+007; ... 
+3.6732980E-003, -5.8313796E-004, -0.0000000E+000, +5.5956859E-002, -4.5277908E-001, +2.1084062E+000, -6.9121162E+003, +4.4247577E+003, +1.6666628E+007; ... 
+5.6573887E-003, -6.1170072E-004, -0.0000000E+000, +2.6848751E-002, -2.7615043E-001, +8.8006305E-001, -5.4017150E+001, -3.4655844E+002, +1.1816406E+006; ... 
+9.9261477E-003, -6.7290664E-004, -0.0000000E+000, +9.4316172E-003, +1.8215499E-002, +1.7057253E-001, +1.2791220E+002, -2.0611235E+002, -6.5817075E+004; ... 
+1.8662551E-002, -7.2560637E-004, -0.0000000E+000, +2.6024321E-003, +8.9944170E-002, +1.2016300E-002, +1.2796314E+001, -8.4540224E+000, -4.2817320E+003; ... 
+4.3484684E-002, -8.0003083E-004, -0.0000000E+000, +5.1153696E-004, +1.0954355E-001, +2.7851200E-003, +5.4588135E+000, +1.0619766E-001, +2.1669150E+002; ... 
+1.3800000E-001, -6.6017979E-004, -0.0000000E+000, +4.3351665E-005, +6.2990081E-002, +7.9633767E-005, +1.0823000E+000, -1.2642029E-002, -2.3536978E+001; ... 
+1.1550000E-001, -1.0863773E-004, -0.0000000E+000, +1.7407460E-006, +1.2635598E-002, -2.8711288E-005, -1.1767042E-001, +1.2393518E-002, +8.7317494E+001; ... 

];

% Normalize so that BendingAngle = 0
res = sum(AWS07Data(:,2));
dan = - res / size(AWS07Data,1);
AWS07Data(:,2) = AWS07Data(:,2) + dan;

if simplified_ids
    
    TYPES.AWS07.TYPENAME   = 'AWS07';
    TYPES.AWS07.FAMNAME    = 'AWS07';
    TYPES.AWS07.LENGTH     = num2str(sum(AWS07Data(:,1)));
    TYPES.AWS07.PASSMETHOD = 'DriftPass';
    TYPES.AWS07.TEMPLATE_ELEMENT = { ...
        'e1 = drift(''FAMNAME'', LENGTH/2, ''PASSMETHOD'');'; ...
        'e2 = marker(''AWI09'',''IdentityPass'');'; ...
        'e3 = drift(''FAMNAME'', LENGTH/2, ''PASSMETHOD'');'; ...
        'TYPENAME_element = [e1 e2 e3];'; ...
        };
    
else
    
    len                    = sum(AWS07Data(:,1));
    TYPES.AWS07.LENGTH      = num2str(len, '%18.15f');
    TYPES.AWS07.TYPENAME    = 'AWS07';
    TYPES.AWS07.FAMNAME     = 'AWS07';
    TYPES.AWS07.PASSMETHOD  = 'BndMPoleSymplectic4Pass';
    
    TYPES.AWS07.TEMPLATE_ELEMENT = {};
    idx = 0;
    strline = 'TYPENAME_element = [';
    for i=1:size(AWS07Data,1)
        
        if i==(size(AWS07Data,1)/2)+1
            idx = idx + 1;
            strline1 = ['e' int2str(idx) ' = marker(''LCENTER'', ''IdentityPass'');'];
            TYPES.AWS07.TEMPLATE_ELEMENT{idx,1} = strline1; strline = [strline ' e' int2str(idx)];
        end
        
        lengt   = AWS07Data(i,1);
        angle   = 1 * AWS07Data(i,2);
        a1      = 0;
        a2      = 0;
        PolyA   = '[0 0]';
        PolyB   = '[';
        for j=3:size(AWS07Data,2)
            PolyB = [PolyB num2str(1 * AWS07Data(i,j), '%18.15f') ' '];
        end
        PolyB = [PolyB ']'];
        Gap     = 0;
        FInt1   = 0;
        FInt2   = 0;
        
        idx = idx + 1;
        strline2 = ['e' int2str(idx) ' = rbend_sirius(''FAMNAME'', ' num2str(lengt, '%18.15f') ', ' num2str(angle, '%18.15f') ', ' num2str(a1, '%18.15f') ', ' num2str(a2, '%18.15f') ', ' num2str(Gap, '%18.15f') ', ' num2str(FInt1, '%18.15f') ', ' num2str(FInt2, '%18.15f') ', ' PolyA ', ' PolyB ',  ''PASSMETHOD'');'];
        TYPES.AWS07.TEMPLATE_ELEMENT{idx,1} = strline2; strline = [strline ' e' int2str(idx)];
        
    end
    strline = [strline '];'];
    idx = idx + 1; TYPES.AWS07.TEMPLATE_ELEMENT{idx,1} = strline;
      
end


%% SCRAPPER

TYPES.SCRAPPER.TYPENAME   = 'SCRAPPER';
TYPES.SCRAPPER.FAMNAME    = 'SCRAPPER';
TYPES.SCRAPPER.LENGTH     = '0';
TYPES.SCRAPPER.PASSMETHOD = 'IdentityPass';
TYPES.SCRAPPER.TEMPLATE_ELEMENT = { ...
    'e1 = marker(''FAMNAME'', ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };
