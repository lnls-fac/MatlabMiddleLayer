function TYPES = DEF_TYPES

%% QUADRUPOLES %%

TYPES.QF.TYPENAME   = 'QF';
TYPES.QF.FAMNAME    = 'QF';
TYPES.QF.LENGTH     = '0.30';
TYPES.QF.STRENGTH   = '2.517371467317083';
TYPES.QF.PASSMETHOD = 'QuadLinearPass';
TYPES.QF.TEMPLATE_ELEMENT = { ...
    'e1 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...  
    'TYPENAME_element = [e1 e2];'; ...
    };


TYPES.QD.TYPENAME   = 'QD';
TYPES.QD.FAMNAME    = 'QD';
TYPES.QD.LENGTH     = '0.30';
TYPES.QD.STRENGTH   = '-2.696107818970809';
TYPES.QD.PASSMETHOD = 'QuadLinearPass';
TYPES.QD.TEMPLATE_ELEMENT = { ...
    'e1 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...  
    'TYPENAME_element = [e1 e2];'; ...
    };

TYPES.QFC.TYPENAME    = 'QFC';
TYPES.QFC.FAMNAME     = 'QFC';
TYPES.QFC.LENGTH      = '0.30';
TYPES.QFC.STRENGTH    = '1.769473070824602';
TYPES.QFC.PASSMETHOD  = 'QuadLinearPass';
TYPES.QFC.COR_FAMN    = 'VCM';
TYPES.QFC.COR_PASSM   = 'CorrectorPass';
TYPES.QFC.TEMPLATE_ELEMENT = { ...
    'e1 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = corrector  (''COR_FAMN'', 0.00000, [0 0], ''COR_PASSM'');'; ...
    'e3 = quadrupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...  
    'TYPENAME_element = [e1 e2 e3];'; ...
    };

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

%% DIPOLES

TYPES.BEND.TYPENAME   = 'BEND';
TYPES.BEND.FAMNAME    = 'BEND';
TYPES.BEND.LENGTH     = '1.432';
TYPES.BEND.PASSMETHOD = 'BndMPoleSymplectic4Pass';
TYPES.BEND.TEMPLATE_ELEMENT = { ...
    'e1 = rbend(''FAMNAME'', LENGTH*(4/30),  (2*pi/12)*(4/30), (2*pi/12)/2, 0, 0, ''PASSMETHOD'');'; ...
    'e2 = rbend(''FAMNAME'', LENGTH*(11/30), (2*pi/12)*(11/30), 0, 0, 0, ''PASSMETHOD'');'; ...
    'e3 = rbend(''FAMNAME'', LENGTH*(15/30), (2*pi/12)*(15/30), 0, (2*pi/12)/2, 0, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2 e3];'; ...
    };


%% SEXTUPOLES %%

TYPES.SD.TYPENAME   = 'SD';
TYPES.SD.FAMNAME    = 'SD';
TYPES.SD.LENGTH     = '0.1';
TYPES.SD.STRENGTH   = '-34.619552516400347';
TYPES.SD.PASSMETHOD = 'StrMPoleSymplectic4Pass';
TYPES.SD.TEMPLATE_ELEMENT = { ...
    'e1 = sextupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'e2 = sextupole(''FAMNAME'', LENGTH/2, STRENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1 e2];'; ...
    };

TYPES.SF.TYPENAME   = 'SF';
TYPES.SF.FAMNAME    = 'SF';
TYPES.SF.LENGTH     = '0.1';
TYPES.SF.STRENGTH   = '52.625252960900269';
TYPES.SF.PASSMETHOD = 'StrMPoleSymplectic4Pass';
TYPES.SF.TEMPLATE_ELEMENT = { ...
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

%% RF

TYPES.RF.TYPENAME   = 'RF';
TYPES.RF.FAMNAME    = 'RF';
TYPES.RF.LENGTH     = '0';
TYPES.RF.VOLTAGE    = '0.3e+6';
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


%% INSERTION DEVICES

TYPES.AWI01.TYPENAME   = 'AWI01';
TYPES.AWI01.FAMNAME    = 'ID';
TYPES.AWI01.LENGTH     = '2.7';
TYPES.AWI01.PASSMETHOD = 'DriftPass';
TYPES.AWI01.TEMPLATE_ELEMENT = { ...
    'e1 = drift(''FAMNAME'', LENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };

TYPES.AWI09.TYPENAME   = 'AWI09';
TYPES.AWI09.FAMNAME    = 'ID';
TYPES.AWI09.LENGTH     = '1.1';
TYPES.AWI09.PASSMETHOD = 'DriftPass';
TYPES.AWI09.TEMPLATE_ELEMENT = { ...
    'e1 = drift(''FAMNAME'', LENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };

TYPES.AON11.TYPENAME   = 'AON11';
TYPES.AON11.FAMNAME    = 'ID';
TYPES.AON11.LENGTH     = '2.8';
TYPES.AON11.PASSMETHOD = 'DriftPass';
TYPES.AON11.TEMPLATE_ELEMENT = { ...
    'e1 = drift(''FAMNAME'', LENGTH, ''PASSMETHOD'');'; ...
    'TYPENAME_element = [e1];'; ...
    };
