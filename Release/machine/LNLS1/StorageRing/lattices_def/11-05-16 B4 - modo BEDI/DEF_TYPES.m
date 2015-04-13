function TYPES = DEF_TYPES

QUAD_LENGTH     = '0.27';
QUAD_PASSMETHOD = 'QuadLinearPass';

QF.STRENGTH   = '2.765162278976464';
QF.LENGTH     = QUAD_LENGTH;
QF.PASSMETHOD = QUAD_PASSMETHOD;
QF.TEMPLATE_ELEMENT = { ...
    'e1 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2];'; ...
    };

QD.STRENGTH   = '-2.952792922637205';
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
TYPES.A2QF01.STRENGTH   = '2.7995';

TYPES.A2QF03 = QF;
TYPES.A2QF03.TYPENAME = 'A2QF03';
TYPES.A2QF03.FAMNAME  = 'A2QF03';
TYPES.A2QF03.STRENGTH   = '2.7988';

TYPES.A2QF05 = QF;
TYPES.A2QF05.TYPENAME = 'A2QF05';
TYPES.A2QF05.FAMNAME  = 'A2QF05';
TYPES.A2QF05.STRENGTH   = '2.7988';

TYPES.A2QF07 = QF;
TYPES.A2QF07.TYPENAME = 'A2QF07';
TYPES.A2QF07.FAMNAME  = 'A2QF07';
TYPES.A2QF07.STRENGTH   = '2.7988';

TYPES.A2QF09 = QF;
TYPES.A2QF09.TYPENAME = 'A2QF09';
TYPES.A2QF09.FAMNAME  = 'A2QF09';
TYPES.A2QF09.STRENGTH   = '2.772580790508343';
TYPES.A2QF09.STRENGTH   = '2.8069';

TYPES.A2QF11 = QF;
TYPES.A2QF11.TYPENAME = 'A2QF11';
TYPES.A2QF11.FAMNAME  = 'A2QF11';
TYPES.A2QF11.STRENGTH   = '2.765157690172940';
TYPES.A2QF11.STRENGTH   = '2.7988';

TYPES.A2QD01 = QD;
TYPES.A2QD01.TYPENAME = 'A2QD01';
TYPES.A2QD01.FAMNAME  = 'A2QD01';
TYPES.A2QD01.STRENGTH   = '-2.9625';

TYPES.A2QD03 = QD;
TYPES.A2QD03.TYPENAME = 'A2QD03';
TYPES.A2QD03.FAMNAME  = 'A2QD03';
TYPES.A2QD03.STRENGTH   = '-2.9603';

TYPES.A2QD05 = QD;
TYPES.A2QD05.TYPENAME = 'A2QD05';
TYPES.A2QD05.FAMNAME  = 'A2QD05';
TYPES.A2QD05.STRENGTH   = '-2.9603';

TYPES.A2QD07 = QD;
TYPES.A2QD07.TYPENAME = 'A2QD07';
TYPES.A2QD07.FAMNAME  = 'A2QD07';
TYPES.A2QD07.STRENGTH   = '-2.9603';

TYPES.A2QD09 = QD;
TYPES.A2QD09.TYPENAME = 'A2QD09';
TYPES.A2QD09.FAMNAME  = 'A2QD09';
TYPES.A2QD09.STRENGTH   = '-2.9859';

TYPES.A2QD11 = QD;
TYPES.A2QD11.TYPENAME = 'A2QD11';
TYPES.A2QD11.FAMNAME  = 'A2QD11';
TYPES.A2QD11.STRENGTH   = '-2.952778814070184';
TYPES.A2QD11.STRENGTH   = '-2.9604';

TYPES.A6QF01 = QFC;
TYPES.A6QF01.TYPENAME = 'A6QF01';
TYPES.A6QF01.FAMNAME  = 'A6QF01';
TYPES.A6QF01.STRENGTH   = '1.8723';

TYPES.A6QF02 = QFC;
TYPES.A6QF02.TYPENAME = 'A6QF02';
TYPES.A6QF02.FAMNAME  = 'A6QF02';
TYPES.A6QF02.STRENGTH   = '1.8723';

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
TYPES.A6SF.STRENGTH   = '69.0618';
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
TYPES.A6SD01.STRENGTH   = '-46.0057';
TYPES.A6SD01.PASSMETHOD = 'StrMPoleSymplectic4Pass';
TYPES.A6SD01.TEMPLATE_ELEMENT = { ...
    'e1 = sextupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = sextupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2];'; ...
    };

TYPES.A6SD02.TYPENAME   = 'A6SD02';
TYPES.A6SD02.FAMNAME    = 'A6SD02';
TYPES.A6SD02.LENGTH     = '0.1';
TYPES.A6SD02.STRENGTH   = '-46.0057';
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



%% SCRAPPER

TYPES.SCRAPPER.TYPENAME   = 'SCRAPPER';
TYPES.SCRAPPER.FAMNAME    = 'SCRAPPER';
TYPES.SCRAPPER.LENGTH     = '0';
TYPES.SCRAPPER.PASSMETHOD = 'IdentityPass';
TYPES.SCRAPPER.TEMPLATE_ELEMENT = { ...
    'e1 = marker(''FAMNAME'', ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };
