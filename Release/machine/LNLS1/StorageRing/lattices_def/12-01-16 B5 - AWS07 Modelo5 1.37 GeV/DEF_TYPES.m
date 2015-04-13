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
% +7.9939828E-001, +3.6692844E-004, +0.0000000E+000, -9.5844764E-003, -9.0570992E-002, +4.2309395E-002, -4.9771318E+001, +1.6469467E+002, +2.0406724E+005; ... 
% ------------------------------------------------------------------------------------------------------------------------------------------------------------
+1.5900000E-001, -3.0385081E-004, -0.0000000E+000, +7.9646244E-006, +1.9853779E-002, -1.2085645E-004, -2.2557671E-001, +5.4851078E-002, +2.6028252E+002; ... 
+1.0500000E-001, -7.9026354E-004, -0.0000000E+000, +1.1706580E-004, +8.1865757E-002, +5.1554018E-004, +1.9805271E+000, +4.6430069E-002, +1.6818183E+002; ... 
+3.7303374E-002, -8.2313835E-004, -0.0000000E+000, +8.8408418E-004, +9.9612683E-002, +8.0365569E-003, +7.8054464E+000, +1.1969650E-001, +3.5772266E+002; ... 
+1.7109839E-002, -7.5597817E-004, -0.0000000E+000, +3.9919189E-003, +3.1815185E-002, +2.9068315E-002, +1.7641923E+001, -1.7573481E+001, -1.1240002E+004; ... 
+8.6119541E-003, -6.5119478E-004, -0.0000000E+000, +1.3544549E-002, -1.1645368E-001, +3.7383303E-001, +2.0586814E+002, -5.2662652E+002, -1.6730908E+005; ... 
+5.0226629E-003, -5.8885138E-004, -0.0000000E+000, +3.5232717E-002, -5.0778442E-001, +8.3756816E-001, +6.8751725E+002, +1.6533280E+002, -2.8540651E+005; ... 
+3.1732814E-003, -5.2629819E-004, -0.0000000E+000, +6.5386727E-002, -1.1195958E+000, +1.1948980E+000, -1.5486576E+002, +3.7043806E+003, +2.6605907E+006; ... 
+2.4763099E-003, -5.3439681E-004, -0.0000000E+000, +7.9460066E-002, -2.0449229E+000, +4.3839746E+000, +2.9640558E+003, -4.8903435E+003, -1.7745874E+006; ... 
%-- MAGNET EDGE --
+4.5450891E-004, -9.8084700E-005, -0.0000000E+000, +7.9460066E-002, -2.0449229E+000, +4.3839746E+000, +2.9640558E+003, -4.8903435E+003, -1.7745874E+006; ... 
+8.8571022E-003, -2.3350827E-003, -0.0000000E+000, +2.0537535E-003, -7.5653912E-001, +1.3215473E+000, -1.9332920E+003, -7.2050272E+002, +4.5328116E+006; ... 
+3.1838324E-003, -7.1635616E-004, -0.0000000E+000, -1.3985473E-001, -8.5217983E-001, +2.0496840E+000, -6.2500727E+003, +2.0333334E+003, +1.4018615E+007; ... 
+2.6735360E-003, -4.4719648E-004, -0.0000000E+000, -1.7884196E-001, -2.0314426E+000, +3.9286354E+000, +4.5993300E+003, -5.6810562E+003, -5.3628218E+006; ... 
+2.9212074E-003, -3.2956658E-004, -0.0000000E+000, -1.6067030E-001, -1.0853367E+000, +1.3809941E+000, +1.2010540E+003, -2.3535431E+003, -8.8911955E+005; ... 
+3.0831986E-003, -1.9923053E-004, -0.0000000E+000, -1.3356811E-001, -7.4618543E-001, +6.0901322E-001, +7.3443524E+002, -7.0659322E+002, -5.9777609E+005; ... 
+4.2380292E-003, -7.2214022E-005, -0.0000000E+000, -1.1246787E-001, -5.2354481E-001, +3.2460629E-001, +2.4730235E+002, -2.5837397E+002, -1.9723785E+005; ... 
+4.5007306E-003, +1.4473590E-004, -0.0000000E+000, -1.0123356E-001, -4.7501341E-001, +9.8142413E-002, +3.2996883E+001, +1.7657848E+002, -2.2626996E+004; ... 
+4.4234985E-003, +3.5496735E-004, -0.0000000E+000, -9.9630465E-002, -5.2394453E-001, +1.9788056E-001, +4.9021265E+000, -1.7627818E+002, -2.6517951E+004; ... 
+3.7827022E-003, +4.7996652E-004, -0.0000000E+000, -1.0425122E-001, -6.0226687E-001, +8.8647374E-002, -1.8855452E+001, +1.8744790E+002, -5.4980674E+003; ... 
+3.2981006E-003, +5.6718996E-004, -0.0000000E+000, -1.1151676E-001, -6.9511767E-001, +3.0694742E-001, +3.0902824E+001, -3.8404125E+002, -7.5838392E+004; ... 
+2.6060970E-003, +5.5975142E-004, -0.0000000E+000, -1.1813896E-001, -8.0344730E-001, +6.6212797E-001, +1.7869933E+002, -9.7601733E+002, -2.6072819E+005; ... 
+2.6737758E-003, +6.9041101E-004, -0.0000000E+000, -1.2140081E-001, -8.7750159E-001, +4.2987017E-001, +1.6169397E+002, -4.0364073E+002, -2.2508917E+005; ... 
+2.5804115E-003, +7.8974767E-004, -0.0000000E+000, -1.1862206E-001, -8.5828717E-001, -5.8948653E-001, -1.7899852E+002, +1.1626767E+003, +1.5933743E+005; ... 
+2.3260041E-003, +8.2348857E-004, -0.0000000E+000, -1.0916500E-001, -7.7164983E-001, -1.4268285E+000, -9.2502260E+002, +2.5858082E+003, +1.3061113E+006; ... 
+2.7708349E-003, +1.1259380E-003, -0.0000000E+000, -9.3254983E-002, -9.6607179E-001, -1.3052167E+000, +7.1493550E+001, +2.6582257E+003, -2.6101526E+005; ... 
+3.0297525E-003, +1.4128459E-003, -0.0000000E+000, -6.3353356E-002, -4.8983510E-001, -7.5600383E+000, -2.1494479E+003, +1.4514679E+004, +2.5787316E+006; ... 
+4.5983956E-003, +2.4061250E-003, -0.0000000E+000, -1.6681195E-002, -8.7574649E-001, -3.0323599E+000, -2.9007106E+003, +1.2605870E+004, +6.0569124E+006; ... 
%-- FIELDMAP CENTER --
+4.5983956E-003, +2.4061250E-003, -0.0000000E+000, -1.6681195E-002, -8.7574649E-001, -3.0323599E+000, -2.9007106E+003, +1.2605870E+004, +6.0569124E+006; ... 
+3.0297525E-003, +1.4128459E-003, -0.0000000E+000, -6.3353356E-002, -4.8983510E-001, -7.5600383E+000, -2.1494479E+003, +1.4514679E+004, +2.5787316E+006; ... 
+2.7708349E-003, +1.1259380E-003, -0.0000000E+000, -9.3254983E-002, -9.6607179E-001, -1.3052167E+000, +7.1493550E+001, +2.6582257E+003, -2.6101526E+005; ... 
+2.3260041E-003, +8.2348857E-004, -0.0000000E+000, -1.0916500E-001, -7.7164983E-001, -1.4268285E+000, -9.2502260E+002, +2.5858082E+003, +1.3061113E+006; ... 
+2.5804115E-003, +7.8974767E-004, -0.0000000E+000, -1.1862206E-001, -8.5828717E-001, -5.8948653E-001, -1.7899852E+002, +1.1626767E+003, +1.5933743E+005; ... 
+2.6737758E-003, +6.9041101E-004, -0.0000000E+000, -1.2140081E-001, -8.7750159E-001, +4.2987017E-001, +1.6169397E+002, -4.0364073E+002, -2.2508917E+005; ... 
+2.6060970E-003, +5.5975142E-004, -0.0000000E+000, -1.1813896E-001, -8.0344730E-001, +6.6212797E-001, +1.7869933E+002, -9.7601733E+002, -2.6072819E+005; ... 
+3.2981006E-003, +5.6718996E-004, -0.0000000E+000, -1.1151676E-001, -6.9511767E-001, +3.0694742E-001, +3.0902824E+001, -3.8404125E+002, -7.5838392E+004; ... 
+3.7827022E-003, +4.7996652E-004, -0.0000000E+000, -1.0425122E-001, -6.0226687E-001, +8.8647374E-002, -1.8855452E+001, +1.8744790E+002, -5.4980674E+003; ... 
+4.4234985E-003, +3.5496735E-004, -0.0000000E+000, -9.9630465E-002, -5.2394453E-001, +1.9788056E-001, +4.9021265E+000, -1.7627818E+002, -2.6517951E+004; ... 
+4.5007306E-003, +1.4473590E-004, -0.0000000E+000, -1.0123356E-001, -4.7501341E-001, +9.8142413E-002, +3.2996883E+001, +1.7657848E+002, -2.2626996E+004; ... 
+4.2380292E-003, -7.2214022E-005, -0.0000000E+000, -1.1246787E-001, -5.2354481E-001, +3.2460629E-001, +2.4730235E+002, -2.5837397E+002, -1.9723785E+005; ... 
+3.0831986E-003, -1.9923053E-004, -0.0000000E+000, -1.3356811E-001, -7.4618543E-001, +6.0901322E-001, +7.3443524E+002, -7.0659322E+002, -5.9777609E+005; ... 
+2.9212074E-003, -3.2956658E-004, -0.0000000E+000, -1.6067030E-001, -1.0853367E+000, +1.3809941E+000, +1.2010540E+003, -2.3535431E+003, -8.8911955E+005; ... 
+2.6735360E-003, -4.4719648E-004, -0.0000000E+000, -1.7884196E-001, -2.0314426E+000, +3.9286354E+000, +4.5993300E+003, -5.6810562E+003, -5.3628218E+006; ... 
+3.1838324E-003, -7.1635616E-004, -0.0000000E+000, -1.3985473E-001, -8.5217983E-001, +2.0496840E+000, -6.2500727E+003, +2.0333334E+003, +1.4018615E+007; ... 
+8.8571022E-003, -2.3350827E-003, -0.0000000E+000, +2.0537535E-003, -7.5653912E-001, +1.3215473E+000, -1.9332920E+003, -7.2050272E+002, +4.5328116E+006; ... 
+4.5450891E-004, -9.8084700E-005, -0.0000000E+000, +7.9460066E-002, -2.0449229E+000, +4.3839746E+000, +2.9640558E+003, -4.8903435E+003, -1.7745874E+006; ... 
%-- MAGNET EDGE --
+2.4763099E-003, -5.3439681E-004, -0.0000000E+000, +7.9460066E-002, -2.0449229E+000, +4.3839746E+000, +2.9640558E+003, -4.8903435E+003, -1.7745874E+006; ... 
+3.1732814E-003, -5.2629819E-004, -0.0000000E+000, +6.5386727E-002, -1.1195958E+000, +1.1948980E+000, -1.5486576E+002, +3.7043806E+003, +2.6605907E+006; ... 
+5.0226629E-003, -5.8885138E-004, -0.0000000E+000, +3.5232717E-002, -5.0778442E-001, +8.3756816E-001, +6.8751725E+002, +1.6533280E+002, -2.8540651E+005; ... 
+8.6119541E-003, -6.5119478E-004, -0.0000000E+000, +1.3544549E-002, -1.1645368E-001, +3.7383303E-001, +2.0586814E+002, -5.2662652E+002, -1.6730908E+005; ... 
+1.7109839E-002, -7.5597817E-004, -0.0000000E+000, +3.9919189E-003, +3.1815185E-002, +2.9068315E-002, +1.7641923E+001, -1.7573481E+001, -1.1240002E+004; ... 
+3.7303374E-002, -8.2313835E-004, -0.0000000E+000, +8.8408418E-004, +9.9612683E-002, +8.0365569E-003, +7.8054464E+000, +1.1969650E-001, +3.5772266E+002; ... 
+1.0500000E-001, -7.9026354E-004, -0.0000000E+000, +1.1706580E-004, +8.1865757E-002, +5.1554018E-004, +1.9805271E+000, +4.6430069E-002, +1.6818183E+002; ... 
+1.5900000E-001, -3.0385081E-004, -0.0000000E+000, +7.9646244E-006, +1.9853779E-002, -1.2085645E-004, -2.2557671E-001, +5.4851078E-002, +2.6028252E+002; ... 
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
