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
% AWS07_Modelo 3_-35_35mm_-950_950mm.txt @ 1.37 GeV
%    Length[m]        Angle[rad]       Dip[1/m]         Quad[1/m^2]      Sext[1/m^3]      Oct[1/m^4]       Deca[1/m^5]      Duodec[1/m^6]    ...
% ------------------------------------------------------------------------------------------------------------------------------------------------------------
% +7.9827648E-001, -8.4567769E-018, -2.2692657E-006, -8.7837410E-003, -8.6107842E-003, +8.3522853E-002, +1.1358494E+002, -1.2669297E+002, -1.3946996E+005; ... 
% ------------------------------------------------------------------------------------------------------------------------------------------------------------
+2.3100000E-001, -5.1574038E-004, -2.8427064E-006, +1.3040297E-005, +3.2652914E-002, -6.4368069E-005, +2.4296925E-001, -1.4431704E-003, +3.9853910E+001; ... 
+5.5500000E-002, -7.2392655E-004, -2.8427064E-006, +2.6229785E-004, +1.0430067E-001, +1.3139786E-003, +4.4494938E+000, -7.9347354E-002, -4.9642944E+001; ... 
+2.3582843E-002, -7.1023210E-004, -2.8427064E-006, +1.4940794E-003, +9.7455197E-002, +4.2770271E-003, +6.7309552E+000, +1.8810696E-001, -4.7255749E+002; ... 
+1.1491578E-002, -6.2046148E-004, -2.8427064E-006, +5.6408000E-003, +7.4387321E-002, +2.7784078E-002, +6.9885424E+001, -4.1727315E+001, -9.2133444E+004; ... 
+6.8350977E-003, -5.9292266E-004, -2.8427064E-006, +1.6726274E-002, +1.1350219E-002, +1.7316570E-001, +2.4742358E+002, -2.0816899E+002, -2.1572902E+005; ... 
+3.9584228E-003, -5.1044851E-004, -2.8427064E-006, +3.8491297E-002, -1.9379048E-001, +8.2124029E-001, +1.0177333E+003, -1.2715809E+003, -1.1456741E+006; ... 
+2.9743033E-003, -5.2340815E-004, -2.8427064E-006, +6.3967376E-002, -4.1410548E-001, +1.2681371E+000, +1.5259359E+003, -1.4787585E+003, -1.4338886E+006; ... 
+1.7944711E-003, -4.0644926E-004, -2.8427064E-006, +6.9137179E-002, -6.1686832E-001, +1.1603717E+000, +2.2341828E+003, -7.9885536E+002, -1.9254325E+006; ... 
%-- MAGNET EDGE --
+1.4158809E-003, -3.2069825E-004, -2.8427064E-006, +6.9137179E-002, -6.1686832E-001, +1.1603717E+000, +2.2341828E+003, -7.9885536E+002, -1.9254325E+006; ... 
+8.8280259E-003, -2.2999286E-003, -2.8427064E-006, -1.4759136E-002, -4.3694930E-001, +2.6091247E+000, +2.9856223E+003, -5.0094751E+003, -3.6871261E+006; ... 
+2.9354623E-003, -6.1446892E-004, -2.8427064E-006, -1.4310100E-001, -2.3463099E-001, +2.2976507E+000, +2.3705477E+003, -2.5577728E+003, -2.8519345E+006; ... 
+2.8677829E-003, -4.3503232E-004, -2.8427064E-006, -1.5962720E-001, -6.2311361E-002, +5.9666533E-001, +5.5457540E+002, +1.5567262E+002, -4.8945638E+005; ... 
+2.9142716E-003, -2.9036761E-004, -2.8427064E-006, -1.3717403E-001, -2.8277374E-002, +3.7142077E-001, +3.0880653E+002, -3.6107014E+002, -5.0100128E+005; ... 
+3.1513403E-003, -1.7529758E-004, -2.8427064E-006, -1.1355492E-001, -4.4308146E-002, +3.6791632E-001, +1.1245127E+002, -5.5332241E+002, -1.7261682E+005; ... 
+4.2872929E-003, -4.9044512E-005, -2.8427064E-006, -9.6734328E-002, -6.0409172E-002, -1.3450044E-001, +1.1928206E+000, +5.3427061E+002, -4.6922397E+004; ... 
+3.6552527E-003, +1.0969119E-004, -2.8427064E-006, -8.9180105E-002, -1.0710272E-001, +9.5155438E-002, +5.9086718E+000, +5.0130658E+000, -3.2979961E+004; ... 
+4.4568630E-003, +3.1855350E-004, -2.8427064E-006, -8.9076693E-002, -1.4118142E-001, -8.9012423E-002, -8.4867456E+001, +4.1667189E+002, +9.8823493E+004; ... 
+3.5797086E-003, +4.1108110E-004, -2.8427064E-006, -9.4166230E-002, -2.0568574E-001, +2.3459114E-001, -1.0960920E+001, -4.9750867E+002, -4.2973495E+004; ... 
+3.5797086E-003, +5.6846128E-004, -2.8427064E-006, -1.0207451E-001, -2.6127319E-001, +1.1863765E-002, -1.3178282E+001, +2.2631708E+002, -2.2024844E+004; ... 
+2.5910414E-003, +5.2376154E-004, -2.8427064E-006, -1.0933695E-001, -2.8915355E-001, -6.8348598E-002, -1.4361881E+002, +1.6358070E+002, +1.6213722E+005; ... 
+2.8588783E-003, +7.0490375E-004, -2.8427064E-006, -1.1285786E-001, -3.2895985E-001, -3.7145797E-001, -1.9059042E+002, +8.7599211E+002, +2.1028039E+005; ... 
+2.7176915E-003, +8.0729380E-004, -2.8427064E-006, -1.0987965E-001, -3.8233572E-001, -3.6174680E-001, -1.2557300E+002, +5.8824618E+002, +5.1068869E+004; ... 
+2.1674809E-003, +7.4664301E-004, -2.8427064E-006, -1.0079006E-001, -4.1277477E-001, -4.2620859E-001, -2.4976758E+002, +8.8063527E+002, +3.2063415E+005; ... 
+2.7999626E-003, +1.1081566E-003, -2.8427064E-006, -8.5467488E-002, -4.1167786E-001, +3.3441687E-001, -4.3185091E+002, -1.1320648E+003, +6.5886754E+005; ... 
+2.6275232E-003, +1.1862998E-003, -2.8427064E-006, -5.8229233E-002, -7.2310885E-001, +6.9064448E-001, +1.3292099E+003, -1.8611417E+003, -2.3772538E+006; ... 
+4.5673572E-003, +2.3035813E-003, -2.8427064E-006, -1.4697992E-002, -5.0667928E-001, -9.2855447E-001, +4.1388503E+002, +6.7067535E+002, -1.1441881E+006; ... 
%-- FIELDMAP CENTER --
+4.5673572E-003, +2.3035813E-003, -2.8427064E-006, -1.4697992E-002, -5.0667928E-001, -9.2855447E-001, +4.1388503E+002, +6.7067535E+002, -1.1441881E+006; ... 
+2.6275232E-003, +1.1862998E-003, -2.8427064E-006, -5.8229233E-002, -7.2310885E-001, +6.9064448E-001, +1.3292099E+003, -1.8611417E+003, -2.3772538E+006; ... 
+2.7999626E-003, +1.1081566E-003, -2.8427064E-006, -8.5467488E-002, -4.1167786E-001, +3.3441687E-001, -4.3185091E+002, -1.1320648E+003, +6.5886754E+005; ... 
+2.1674809E-003, +7.4664301E-004, -2.8427064E-006, -1.0079006E-001, -4.1277477E-001, -4.2620859E-001, -2.4976758E+002, +8.8063527E+002, +3.2063415E+005; ... 
+2.7176915E-003, +8.0729380E-004, -2.8427064E-006, -1.0987965E-001, -3.8233572E-001, -3.6174680E-001, -1.2557300E+002, +5.8824618E+002, +5.1068869E+004; ... 
+2.8588783E-003, +7.0490375E-004, -2.8427064E-006, -1.1285786E-001, -3.2895985E-001, -3.7145797E-001, -1.9059042E+002, +8.7599211E+002, +2.1028039E+005; ... 
+2.5910414E-003, +5.2376154E-004, -2.8427064E-006, -1.0933695E-001, -2.8915355E-001, -6.8348598E-002, -1.4361881E+002, +1.6358070E+002, +1.6213722E+005; ... 
+3.5797086E-003, +5.6846128E-004, -2.8427064E-006, -1.0207451E-001, -2.6127319E-001, +1.1863765E-002, -1.3178282E+001, +2.2631708E+002, -2.2024844E+004; ... 
+3.5797086E-003, +4.1108110E-004, -2.8427064E-006, -9.4166230E-002, -2.0568574E-001, +2.3459114E-001, -1.0960920E+001, -4.9750867E+002, -4.2973495E+004; ... 
+4.4568630E-003, +3.1855350E-004, -2.8427064E-006, -8.9076693E-002, -1.4118142E-001, -8.9012423E-002, -8.4867456E+001, +4.1667189E+002, +9.8823493E+004; ... 
+3.6552527E-003, +1.0969119E-004, -2.8427064E-006, -8.9180105E-002, -1.0710272E-001, +9.5155438E-002, +5.9086718E+000, +5.0130658E+000, -3.2979961E+004; ... 
+4.2872929E-003, -4.9044512E-005, -2.8427064E-006, -9.6734328E-002, -6.0409172E-002, -1.3450044E-001, +1.1928206E+000, +5.3427061E+002, -4.6922397E+004; ... 
+3.1513403E-003, -1.7529758E-004, -2.8427064E-006, -1.1355492E-001, -4.4308146E-002, +3.6791632E-001, +1.1245127E+002, -5.5332241E+002, -1.7261682E+005; ... 
+2.9142716E-003, -2.9036761E-004, -2.8427064E-006, -1.3717403E-001, -2.8277374E-002, +3.7142077E-001, +3.0880653E+002, -3.6107014E+002, -5.0100128E+005; ... 
+2.8677829E-003, -4.3503232E-004, -2.8427064E-006, -1.5962720E-001, -6.2311361E-002, +5.9666533E-001, +5.5457540E+002, +1.5567262E+002, -4.8945638E+005; ... 
+2.9354623E-003, -6.1446892E-004, -2.8427064E-006, -1.4310100E-001, -2.3463099E-001, +2.2976507E+000, +2.3705477E+003, -2.5577728E+003, -2.8519345E+006; ... 
+8.8280259E-003, -2.2999286E-003, -2.8427064E-006, -1.4759136E-002, -4.3694930E-001, +2.6091247E+000, +2.9856223E+003, -5.0094751E+003, -3.6871261E+006; ... 
+1.4158809E-003, -3.2069825E-004, -2.8427064E-006, +6.9137179E-002, -6.1686832E-001, +1.1603717E+000, +2.2341828E+003, -7.9885536E+002, -1.9254325E+006; ... 
%-- MAGNET EDGE --
+1.7944711E-003, -4.0644926E-004, -2.8427064E-006, +6.9137179E-002, -6.1686832E-001, +1.1603717E+000, +2.2341828E+003, -7.9885536E+002, -1.9254325E+006; ... 
+2.9743033E-003, -5.2340815E-004, -2.8427064E-006, +6.3967376E-002, -4.1410548E-001, +1.2681371E+000, +1.5259359E+003, -1.4787585E+003, -1.4338886E+006; ... 
+3.9584228E-003, -5.1044851E-004, -2.8427064E-006, +3.8491297E-002, -1.9379048E-001, +8.2124029E-001, +1.0177333E+003, -1.2715809E+003, -1.1456741E+006; ... 
+6.8350977E-003, -5.9292266E-004, -2.8427064E-006, +1.6726274E-002, +1.1350219E-002, +1.7316570E-001, +2.4742358E+002, -2.0816899E+002, -2.1572902E+005; ... 
+1.1491578E-002, -6.2046148E-004, -2.8427064E-006, +5.6408000E-003, +7.4387321E-002, +2.7784078E-002, +6.9885424E+001, -4.1727315E+001, -9.2133444E+004; ... 
+2.3582843E-002, -7.1023210E-004, -2.8427064E-006, +1.4940794E-003, +9.7455197E-002, +4.2770271E-003, +6.7309552E+000, +1.8810696E-001, -4.7255749E+002; ... 
+5.5500000E-002, -7.2392655E-004, -2.8427064E-006, +2.6229785E-004, +1.0430067E-001, +1.3139786E-003, +4.4494938E+000, -7.9347354E-002, -4.9642944E+001; ... 
+2.3100000E-001, -5.1574038E-004, -2.8427064E-006, +1.3040297E-005, +3.2652914E-002, -6.4368069E-005, +2.4296925E-001, -1.4431704E-003, +3.9853910E+001; ... 
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
