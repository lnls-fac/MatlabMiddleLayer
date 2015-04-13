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
% +7.9709519E-001, +3.7178246E-004, +0.0000000E+000, -1.0230589E-002, +8.4797785E-003, -4.7576633E-001, -2.0087289E+002, +9.0489226E+002, +2.1965645E+005; ... 
% ------------------------------------------------------------------------------------------------------------------------------------------------------------
+4.0500000E-002, -4.8181215E-005, -0.0000000E+000, +2.3896110E-006, +8.9788724E-003, +1.1196474E-005, +2.2393232E-001, -8.3953691E-002, -3.6717115E+002; ... 
+1.9650000E-001, -7.7401006E-004, -0.0000000E+000, +3.8384590E-005, +4.4979445E-002, -8.0239164E-005, +2.9420198E-001, +1.4115522E-002, +2.2434571E+002; ... 
+5.2500000E-002, -8.6383003E-004, -0.0000000E+000, +4.8774920E-004, +1.0970352E-001, +5.0661712E-003, +6.3293084E+000, -3.3106049E-002, +2.6235534E+002; ... 
+2.2590525E-002, -8.1520097E-004, -0.0000000E+000, +2.4885035E-003, +5.5874093E-002, +1.6254764E-002, +7.9119900E+000, -1.2245549E+000, -3.5721684E+002; ... 
+1.0707438E-002, -6.8320463E-004, -0.0000000E+000, +9.0408636E-003, -3.7768770E-002, +7.4587873E-002, +2.6100275E+001, -9.5365759E+001, -2.5261995E+004; ... 
+6.2593094E-003, -6.3268734E-004, -0.0000000E+000, +2.5664212E-002, -2.1174284E-001, +5.8886610E-001, +2.5951110E+002, -8.5499222E+002, -1.8518361E+005; ... 
+4.0673580E-003, -6.1174158E-004, -0.0000000E+000, +5.6846268E-002, -4.7809674E-001, +2.2189514E+000, -4.0710359E-001, -2.4102466E+003, +1.2040343E+006; ... 
+3.0204856E-003, -6.2074110E-004, -0.0000000E+000, +8.4318348E-002, -3.8237649E-001, -7.1139133E+000, -2.5703684E+003, +2.0781320E+004, +5.4639572E+006; ... 
+4.0063756E-004, -1.0457866E-004, -0.0000000E+000, +5.3843184E-002, +3.1792574E-001, -5.9117187E+000, -4.5321883E+003, +1.2935975E+004, +7.3242295E+006; ... 
%-- MAGNET EDGE --
+4.5628276E-003, -1.1910376E-003, -0.0000000E+000, +5.3843184E-002, +3.1792574E-001, -5.9117187E+000, -4.5321883E+003, +1.2935975E+004, +7.3242295E+006; ... 
+6.1382051E-003, -1.6386023E-003, -0.0000000E+000, -5.3072509E-002, +8.8964338E-001, -1.1669218E+001, +1.0198947E+002, +1.5756011E+004, -5.2717182E+006; ... 
+2.9580236E-003, -6.1073221E-004, -0.0000000E+000, -1.7034258E-001, +1.6198309E+000, -5.9235595E+000, -5.2282208E+003, +6.1879527E+003, +2.8516039E+006; ... 
+2.9431091E-003, -4.2844723E-004, -0.0000000E+000, -1.7839837E-001, +9.1076992E-001, -7.9299411E+000, -5.3849040E+003, +1.2790508E+004, +6.2823506E+006; ... 
+3.0169654E-003, -2.7688900E-004, -0.0000000E+000, -1.5132833E-001, +1.4431966E-001, -3.4521982E+000, -2.1602600E+003, +4.9363047E+003, +2.3631823E+006; ... 
+4.0432689E-003, -1.6610373E-004, -0.0000000E+000, -1.2476259E-001, -2.2751872E-001, -8.0733444E-001, -4.9971160E+002, +8.0158694E+002, +4.0423085E+005; ... 
+4.3895998E-003, +4.0675949E-005, -0.0000000E+000, -1.0859645E-001, -3.3912432E-001, -3.4483319E-001, -1.9128696E+002, +5.7001341E+002, +1.5112977E+005; ... 
+4.3976734E-003, +2.5235027E-004, -0.0000000E+000, -1.0407263E-001, -4.1952045E-001, +1.5863885E-003, -7.6866091E+001, +6.1786062E+001, +4.0985818E+004; ... 
+4.3682477E-003, +4.6551163E-004, -0.0000000E+000, -1.0790733E-001, -5.0512063E-001, +1.4171575E-001, -2.3590780E+001, -8.4864055E+001, -2.3481831E+004; ... 
+3.4667697E-003, +5.3870972E-004, -0.0000000E+000, -1.1664275E-001, -5.8958755E-001, +7.2486300E-002, -3.3208062E+001, +1.2775418E+002, +1.1704291E+004; ... 
+3.4920454E-003, +7.1910830E-004, -0.0000000E+000, -1.2701215E-001, -7.1807913E-001, +6.9766423E-001, +1.7081487E+002, -1.0943219E+003, -2.6706085E+005; ... 
+2.7397241E-003, +7.0873497E-004, -0.0000000E+000, -1.3421534E-001, -8.1573684E-001, +5.2599948E-001, +1.7929640E+002, -5.5359514E+002, -2.5261250E+005; ... 
+2.9431907E-003, +9.2359250E-004, -0.0000000E+000, -1.3359002E-001, -7.9854927E-001, -6.3199785E-001, -2.4436468E+002, +1.2934993E+003, +2.6595943E+005; ... 
+2.6914139E-003, +1.0064002E-003, -0.0000000E+000, -1.2359370E-001, -7.2589657E-001, -1.7266947E+000, -1.0258307E+003, +3.3452771E+003, +1.4819096E+006; ... 
+2.5979791E-003, +1.1286287E-003, -0.0000000E+000, -1.0531373E-001, -9.2297927E-001, -2.5572837E+000, +1.9375189E+002, +4.8489551E+003, -6.5841822E+005; ... 
+2.5491232E-003, +1.2596225E-003, -0.0000000E+000, -7.3131186E-002, -1.2845184E-001, -1.1487840E+001, -3.4333138E+003, +2.1075624E+004, +4.1217630E+006; ... 
+4.7036736E-003, +2.6085442E-003, -0.0000000E+000, -1.9654839E-002, -3.8801995E-001, -7.6150141E+000, -4.5485915E+003, +2.0035351E+004, +7.9541883E+006; ... 
%-- FIELDMAP CENTER --
+4.7036736E-003, +2.6085442E-003, -0.0000000E+000, -1.9654839E-002, -3.8801995E-001, -7.6150141E+000, -4.5485915E+003, +2.0035351E+004, +7.9541883E+006; ... 
+2.5491232E-003, +1.2596225E-003, -0.0000000E+000, -7.3131186E-002, -1.2845184E-001, -1.1487840E+001, -3.4333138E+003, +2.1075624E+004, +4.1217630E+006; ... 
+2.5979791E-003, +1.1286287E-003, -0.0000000E+000, -1.0531373E-001, -9.2297927E-001, -2.5572837E+000, +1.9375189E+002, +4.8489551E+003, -6.5841822E+005; ... 
+2.6914139E-003, +1.0064002E-003, -0.0000000E+000, -1.2359370E-001, -7.2589657E-001, -1.7266947E+000, -1.0258307E+003, +3.3452771E+003, +1.4819096E+006; ... 
+2.9431907E-003, +9.2359250E-004, -0.0000000E+000, -1.3359002E-001, -7.9854927E-001, -6.3199785E-001, -2.4436468E+002, +1.2934993E+003, +2.6595943E+005; ... 
+2.7397241E-003, +7.0873497E-004, -0.0000000E+000, -1.3421534E-001, -8.1573684E-001, +5.2599948E-001, +1.7929640E+002, -5.5359514E+002, -2.5261250E+005; ... 
+3.4920454E-003, +7.1910830E-004, -0.0000000E+000, -1.2701215E-001, -7.1807913E-001, +6.9766423E-001, +1.7081487E+002, -1.0943219E+003, -2.6706085E+005; ... 
+3.4667697E-003, +5.3870972E-004, -0.0000000E+000, -1.1664275E-001, -5.8958755E-001, +7.2486300E-002, -3.3208062E+001, +1.2775418E+002, +1.1704291E+004; ... 
+4.3682477E-003, +4.6551163E-004, -0.0000000E+000, -1.0790733E-001, -5.0512063E-001, +1.4171575E-001, -2.3590780E+001, -8.4864055E+001, -2.3481831E+004; ... 
+4.3976734E-003, +2.5235027E-004, -0.0000000E+000, -1.0407263E-001, -4.1952045E-001, +1.5863885E-003, -7.6866091E+001, +6.1786062E+001, +4.0985818E+004; ... 
+4.3895998E-003, +4.0675949E-005, -0.0000000E+000, -1.0859645E-001, -3.3912432E-001, -3.4483319E-001, -1.9128696E+002, +5.7001341E+002, +1.5112977E+005; ... 
+4.0432689E-003, -1.6610373E-004, -0.0000000E+000, -1.2476259E-001, -2.2751872E-001, -8.0733444E-001, -4.9971160E+002, +8.0158694E+002, +4.0423085E+005; ... 
+3.0169654E-003, -2.7688900E-004, -0.0000000E+000, -1.5132833E-001, +1.4431966E-001, -3.4521982E+000, -2.1602600E+003, +4.9363047E+003, +2.3631823E+006; ... 
+2.9431091E-003, -4.2844723E-004, -0.0000000E+000, -1.7839837E-001, +9.1076992E-001, -7.9299411E+000, -5.3849040E+003, +1.2790508E+004, +6.2823506E+006; ... 
+2.9580236E-003, -6.1073221E-004, -0.0000000E+000, -1.7034258E-001, +1.6198309E+000, -5.9235595E+000, -5.2282208E+003, +6.1879527E+003, +2.8516039E+006; ... 
+6.1382051E-003, -1.6386023E-003, -0.0000000E+000, -5.3072509E-002, +8.8964338E-001, -1.1669218E+001, +1.0198947E+002, +1.5756011E+004, -5.2717182E+006; ... 
+4.5628276E-003, -1.1910376E-003, -0.0000000E+000, +5.3843184E-002, +3.1792574E-001, -5.9117187E+000, -4.5321883E+003, +1.2935975E+004, +7.3242295E+006; ... 
%-- MAGNET EDGE --
+4.0063756E-004, -1.0457866E-004, -0.0000000E+000, +5.3843184E-002, +3.1792574E-001, -5.9117187E+000, -4.5321883E+003, +1.2935975E+004, +7.3242295E+006; ... 
+3.0204856E-003, -6.2074110E-004, -0.0000000E+000, +8.4318348E-002, -3.8237649E-001, -7.1139133E+000, -2.5703684E+003, +2.0781320E+004, +5.4639572E+006; ... 
+4.0673580E-003, -6.1174158E-004, -0.0000000E+000, +5.6846268E-002, -4.7809674E-001, +2.2189514E+000, -4.0710359E-001, -2.4102466E+003, +1.2040343E+006; ... 
+6.2593094E-003, -6.3268734E-004, -0.0000000E+000, +2.5664212E-002, -2.1174284E-001, +5.8886610E-001, +2.5951110E+002, -8.5499222E+002, -1.8518361E+005; ... 
+1.0707438E-002, -6.8320463E-004, -0.0000000E+000, +9.0408636E-003, -3.7768770E-002, +7.4587873E-002, +2.6100275E+001, -9.5365759E+001, -2.5261995E+004; ... 
+2.2590525E-002, -8.1520097E-004, -0.0000000E+000, +2.4885035E-003, +5.5874093E-002, +1.6254764E-002, +7.9119900E+000, -1.2245549E+000, -3.5721684E+002; ... 
+5.2500000E-002, -8.6383003E-004, -0.0000000E+000, +4.8774920E-004, +1.0970352E-001, +5.0661712E-003, +6.3293084E+000, -3.3106049E-002, +2.6235534E+002; ... 
+1.9650000E-001, -7.7401006E-004, -0.0000000E+000, +3.8384590E-005, +4.4979445E-002, -8.0239164E-005, +2.9420198E-001, +1.4115522E-002, +2.2434571E+002; ... 
+4.0500000E-002, -4.8181215E-005, -0.0000000E+000, +2.3896110E-006, +8.9788724E-003, +1.1196474E-005, +2.2393232E-001, -8.3953691E-002, -3.6717115E+002; ... 
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
