function RING = DEF_RING(TYPES)

RING.LENGTH    = 93.2;
RING.ENERGY    = 1.37e9;
RING.NRSECTORS = 6;


DIP = eval(TYPES.BEND.LENGTH);
SSS = 4.413;
LSS = (RING.LENGTH/6) - 2 * DIP - SSS;

RING.CELLS.TR01  = struct('FILE', 'TR01.txt',  'LENGTH', LSS);
RING.CELLS.ADI01 = struct('FILE', 'ADI01.txt', 'LENGTH', DIP);
RING.CELLS.TR02  = struct('FILE', 'TR02.txt',  'LENGTH', SSS);
RING.CELLS.ADI02 = struct('FILE', 'ADI02.txt', 'LENGTH', DIP);
RING.CELLS.TR03  = struct('FILE', 'TR03.txt',  'LENGTH', LSS);
RING.CELLS.ADI03 = struct('FILE', 'ADI03.txt', 'LENGTH', DIP);
RING.CELLS.TR04  = struct('FILE', 'TR04.txt',  'LENGTH', SSS);
RING.CELLS.ADI04 = struct('FILE', 'ADI04.txt', 'LENGTH', DIP);
RING.CELLS.TR05  = struct('FILE', 'TR05.txt',  'LENGTH', LSS);
RING.CELLS.ADI05 = struct('FILE', 'ADI05.txt', 'LENGTH', DIP);
RING.CELLS.TR06  = struct('FILE', 'TR06.txt',  'LENGTH', SSS);
RING.CELLS.ADI06 = struct('FILE', 'ADI06.txt', 'LENGTH', DIP);
RING.CELLS.TR07  = struct('FILE', 'TR07.txt',  'LENGTH', LSS);
RING.CELLS.ADI07 = struct('FILE', 'ADI07.txt', 'LENGTH', DIP);
RING.CELLS.TR08  = struct('FILE', 'TR08.txt',  'LENGTH', SSS);
RING.CELLS.ADI08 = struct('FILE', 'ADI08.txt', 'LENGTH', DIP);
RING.CELLS.TR09  = struct('FILE', 'TR09.txt',  'LENGTH', LSS);
RING.CELLS.ADI09 = struct('FILE', 'ADI09.txt', 'LENGTH', DIP);
RING.CELLS.TR10  = struct('FILE', 'TR10.txt',  'LENGTH', SSS);
RING.CELLS.ADI10 = struct('FILE', 'ADI10.txt', 'LENGTH', DIP);
RING.CELLS.TR11  = struct('FILE', 'TR11.txt',  'LENGTH', LSS);
RING.CELLS.ADI11 = struct('FILE', 'ADI11.txt', 'LENGTH', DIP);
RING.CELLS.TR12  = struct('FILE', 'TR12.txt',  'LENGTH', SSS);
RING.CELLS.ADI12 = struct('FILE', 'ADI12.txt', 'LENGTH', DIP);
