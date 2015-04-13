function bessy2init(OperationalMode)

if nargin < 1
    OperationalMode = 1;
end

% Clear AO
setao([]); 
Mode = 'ONLINE';

ntbpm=122;

bpm={
%x-name	     x-chname	   x-state	y-name	y-chname	  y-state DEVLIST TYPE	DS
'BPMZ43D1R'	'BPMZ43D1R:rdX'	1	'BPMZ43D1R'	'BPMZ43D1R:rdY'	1	[1, 43]	01 'BPM'	1.582
'BPMZ44D1R'	'BPMZ44D1R:rdX'	1	'BPMZ44D1R'	'BPMZ44D1R:rdY'	1	[1, 44]	02 'BPM'	1.785
'BPMZ5D1R '	'BPMZ5D1R:rdX '	1	'BPMZ5D1R '	'BPMZ5D1R:rdY '	1	[1, 5]	03 'BPM'	2.736
'BPMZ6D1R '	'BPMZ6D1R:rdX '	1	'BPMZ6D1R '	'BPMZ6D1R:rdY '	1	[1, 6]	04 'BPM'	3.995
'BPMZ7D1R '	'BPMZ7D1R:rdX '	1	'BPMZ7D1R '	'BPMZ7D1R:rdY '	1	[1, 7]	05 'BPM'	6.474
'BPMZ1T1R '	'BPMZ1T1R:rdX '	1	'BPMZ1T1R '	'BPMZ1T1R:rdY '	1	[1, 1]	06 'BPM'	7.675
'BPMZ2T1R '	'BPMZ2T1R:rdX '	1	'BPMZ2T1R '	'BPMZ2T1R:rdY '	1	[1, 2]	07 'BPM'	8.591
'BPMZ3T1R '	'BPMZ3T1R:rdX '	1	'BPMZ3T1R '	'BPMZ3T1R:rdY '	1	[1, 3]	08 'BPM'	11.005
'BPMZ4T1R '	'BPMZ4T1R:rdX '	1	'BPMZ4T1R '	'BPMZ4T1R:rdY '	1	[1, 4]	09 'BPM'	12.639
'BPMZ43T1R'	'BPMZ43T1R:rdX'	1	'BPMZ43T1R'	'BPMZ43T1R:rdY'	1	[1, 43]	10 'BPM'	15.9296
'BPMZ5T1R '	'BPMZ5T1R:rdX '	1	'BPMZ5T1R '	'BPMZ5T1R:rdY '	1	[1, 5]	11 'BPM'	17.361
'BPMZ6T1R '	'BPMZ6T1R:rdX '	1	'BPMZ6T1R '	'BPMZ6T1R:rdY '	1	[1, 6]	12 'BPM'	18.995
'BPMZ7T1R '	'BPMZ7T1R:rdX '	1	'BPMZ7T1R '	'BPMZ7T1R:rdY '	1	[1, 7]	13 'BPM'	21.474
'BPMZ1D2R '	'BPMZ1D2R:rdX '	1	'BPMZ1D2R '	'BPMZ1D2R:rdY '	1	[2, 1]	14 'BPM'	22.675
'BPMZ2D2R '	'BPMZ2D2R:rdX '	1	'BPMZ2D2R '	'BPMZ2D2R:rdY '	1	[2, 2]	15 'BPM'	23.591
'BPMZ3D2R '	'BPMZ3D2R:rdX '	1	'BPMZ3D2R '	'BPMZ3D2R:rdY '	1	[2, 3]	16 'BPM'	26.005
'BPMZ4D2R '	'BPMZ4D2R:rdX '	1	'BPMZ4D2R '	'BPMZ4D2R:rdY '	1	[2, 4]	17 'BPM'	27.264
'BPMZ5D2R '	'BPMZ5D2R:rdX '	1	'BPMZ5D2R '	'BPMZ5D2R:rdY '	1	[2, 5]	18 'BPM'	32.736
'BPMZ6D2R '	'BPMZ6D2R:rdX '	1	'BPMZ6D2R '	'BPMZ6D2R:rdY '	1	[2, 6]	19 'BPM'	33.995
'BPMZ7D2R '	'BPMZ7D2R:rdX '	1	'BPMZ7D2R '	'BPMZ7D2R:rdY '	1	[2, 7]	20 'BPM'	36.474
'BPMZ1T2R '	'BPMZ1T2R:rdX '	1	'BPMZ1T2R '	'BPMZ1T2R:rdY '	1	[2, 1]	21 'BPM'	37.675
'BPMZ2T2R '	'BPMZ2T2R:rdX '	1	'BPMZ2T2R '	'BPMZ2T2R:rdY '	1	[2, 2]	22 'BPM'	38.591
'BPMZ3T2R '	'BPMZ3T2R:rdX '	1	'BPMZ3T2R '	'BPMZ3T2R:rdY '	1	[2, 3]	23 'BPM'	41.005
'BPMZ4T2R '	'BPMZ4T2R:rdX '	1	'BPMZ4T2R '	'BPMZ4T2R:rdY '	1	[2, 4]	24 'BPM'	42.639
'BPMZ5T2R '	'BPMZ5T2R:rdX '	1	'BPMZ5T2R '	'BPMZ5T2R:rdY '	1	[2, 5]	25 'BPM'	47.361
'BPMZ6T2R '	'BPMZ6T2R:rdX '	1	'BPMZ6T2R '	'BPMZ6T2R:rdY '	1	[2, 6]	26 'BPM'	48.995
'BPMZ7T2R '	'BPMZ7T2R:rdX '	1	'BPMZ7T2R '	'BPMZ7T2R:rdY '	1	[2, 7]	27 'BPM'	51.474
'BPMZ1D3R '	'BPMZ1D3R:rdX '	1	'BPMZ1D3R '	'BPMZ1D3R:rdY '	1	[3, 1]	28 'BPM'	52.675
'BPMZ2D3R '	'BPMZ2D3R:rdX '	1	'BPMZ2D3R '	'BPMZ2D3R:rdY '	1	[3, 2]	29 'BPM'	53.591
'BPMZ3D3R '	'BPMZ3D3R:rdX '	1	'BPMZ3D3R '	'BPMZ3D3R:rdY '	1	[3, 3]	30 'BPM'	56.005
'BPMZ4D3R '	'BPMZ4D3R:rdX '	1	'BPMZ4D3R '	'BPMZ4D3R:rdY '	1	[3, 4]	31 'BPM'	57.264
'BPMZ5D3R '	'BPMZ5D3R:rdX '	1	'BPMZ5D3R '	'BPMZ5D3R:rdY '	1	[3, 5]	32 'BPM'	62.736
'BPMZ6D3R '	'BPMZ6D3R:rdX '	1	'BPMZ6D3R '	'BPMZ6D3R:rdY '	1	[3, 6]	33 'BPM'	63.995
'BPMZ7D3R '	'BPMZ7D3R:rdX '	1	'BPMZ7D3R '	'BPMZ7D3R:rdY '	1	[3, 7]	34 'BPM'	66.474
'BPMZ1T3R '	'BPMZ1T3R:rdX '	1	'BPMZ1T3R '	'BPMZ1T3R:rdY '	1	[3, 1]	35 'BPM'	67.675
'BPMZ2T3R '	'BPMZ2T3R:rdX '	1	'BPMZ2T3R '	'BPMZ2T3R:rdY '	1	[3, 2]	36 'BPM'	68.591
'BPMZ3T3R '	'BPMZ3T3R:rdX '	1	'BPMZ3T3R '	'BPMZ3T3R:rdY '	1	[3, 3]	37 'BPM'	71.005
'BPMZ4T3R '	'BPMZ4T3R:rdX '	1	'BPMZ4T3R '	'BPMZ4T3R:rdY '	1	[3, 4]	38 'BPM'	72.639
'BPMZ41T3R'	'BPMZ41T3R:rdX'	1	'BPMZ41T3R'	'BPMZ41T3R:rdY'	1	[3, 41]	39 'BPM'	74.1275
'BPMZ42T3R'	'BPMZ42T3R:rdX'	1	'BPMZ42T3R'	'BPMZ42T3R:rdY'	1	[3, 42]	40 'BPM'	75.3795
'BPMZ5T3R '	'BPMZ5T3R:rdX '	1	'BPMZ5T3R '	'BPMZ5T3R:rdY '	1	[3, 5]	41 'BPM'	77.361
'BPMZ6T3R '	'BPMZ6T3R:rdX '	1	'BPMZ6T3R '	'BPMZ6T3R:rdY '	1	[3, 6]	42 'BPM'	78.995
'BPMZ7T3R '	'BPMZ7T3R:rdX '	1	'BPMZ7T3R '	'BPMZ7T3R:rdY '	1	[3, 7]	43 'BPM'	81.474
'BPMZ1D4R '	'BPMZ1D4R:rdX '	1	'BPMZ1D4R '	'BPMZ1D4R:rdY '	1	[4, 1]	44 'BPM'	82.675
'BPMZ2D4R '	'BPMZ2D4R:rdX '	1	'BPMZ2D4R '	'BPMZ2D4R:rdY '	1	[4, 2]	45 'BPM'	83.591
'BPMZ3D4R '	'BPMZ3D4R:rdX '	1	'BPMZ3D4R '	'BPMZ3D4R:rdY '	1	[4, 3]	46 'BPM'	86.005
'BPMZ4D4R '	'BPMZ4D4R:rdX '	1	'BPMZ4D4R '	'BPMZ4D4R:rdY '	1	[4, 4]	47 'BPM'	87.264
'BPMZ5D4R '	'BPMZ5D4R:rdX '	1	'BPMZ5D4R '	'BPMZ5D4R:rdY '	1	[4, 5]	48 'BPM'	92.736
'BPMZ6D4R '	'BPMZ6D4R:rdX '	1	'BPMZ6D4R '	'BPMZ6D4R:rdY '	1	[4, 6]	49 'BPM'	93.995
'BPMZ7D4R '	'BPMZ7D4R:rdX '	1	'BPMZ7D4R '	'BPMZ7D4R:rdY '	1	[4, 7]	50 'BPM'	96.474
'BPMZ1T4R '	'BPMZ1T4R:rdX '	1	'BPMZ1T4R '	'BPMZ1T4R:rdY '	1	[4, 1]	51 'BPM'	97.675
'BPMZ2T4R '	'BPMZ2T4R:rdX '	1	'BPMZ2T4R '	'BPMZ2T4R:rdY '	1	[4, 2]	52 'BPM'	98.591
'BPMZ3T4R '	'BPMZ3T4R:rdX '	1	'BPMZ3T4R '	'BPMZ3T4R:rdY '	1	[4, 3]	53 'BPM'	101.005
'BPMZ4T4R '	'BPMZ4T4R:rdX '	1	'BPMZ4T4R '	'BPMZ4T4R:rdY '	1	[4, 4]	54 'BPM'	102.639
'BPMZ5T4R '	'BPMZ5T4R:rdX '	1	'BPMZ5T4R '	'BPMZ5T4R:rdY '	1	[4, 5]	55 'BPM'	107.361
'BPMZ6T4R '	'BPMZ6T4R:rdX '	1	'BPMZ6T4R '	'BPMZ6T4R:rdY '	1	[4, 6]	56 'BPM'	108.995
'BPMZ7T4R '	'BPMZ7T4R:rdX '	1	'BPMZ7T4R '	'BPMZ7T4R:rdY '	1	[4, 7]	57 'BPM'	111.474
'BPMZ1D5R '	'BPMZ1D5R:rdX '	1	'BPMZ1D5R '	'BPMZ1D5R:rdY '	1	[5, 1]	58 'BPM'	112.675
'BPMZ2D5R '	'BPMZ2D5R:rdX '	1	'BPMZ2D5R '	'BPMZ2D5R:rdY '	1	[5, 2]	59 'BPM'	113.591
'BPMZ3D5R '	'BPMZ3D5R:rdX '	1	'BPMZ3D5R '	'BPMZ3D5R:rdY '	1	[5, 3]	60 'BPM'	116.005
'BPMZ4D5R '	'BPMZ4D5R:rdX '	1	'BPMZ4D5R '	'BPMZ4D5R:rdY '	1	[5, 4]	61 'BPM'	117.6933
'BPMZ5D5R '	'BPMZ5D5R:rdX '	1	'BPMZ5D5R '	'BPMZ5D5R:rdY '	1	[5, 5]	62 'BPM'	122.3067
'BPMZ6D5R '	'BPMZ6D5R:rdX '	1	'BPMZ6D5R '	'BPMZ6D5R:rdY '	1	[5, 6]	63 'BPM'	123.995
'BPMZ7D5R '	'BPMZ7D5R:rdX '	1	'BPMZ7D5R '	'BPMZ7D5R:rdY '	1	[5, 7]	64 'BPM'	126.474
'BPMZ1T5R '	'BPMZ1T5R:rdX '	1	'BPMZ1T5R '	'BPMZ1T5R:rdY '	1	[5, 1]	65 'BPM'	127.675
'BPMZ2T5R ' 'BPMZ2T5R:rdX '	1	'BPMZ2T5R '	'BPMZ2T5R:rdY '	1	[5, 2]	66 'BPM'	128.591
'BPMZ3T5R '	'BPMZ3T5R:rdX '	1	'BPMZ3T5R '	'BPMZ3T5R:rdY '	1	[5, 3]	67 'BPM'	131.005
'BPMZ4T5R '	'BPMZ4T5R:rdX '	1	'BPMZ4T5R '	'BPMZ4T5R:rdY '	1	[5, 4]	68 'BPM'	132.639
'BPMZ5T5R '	'BPMZ5T5R:rdX '	1	'BPMZ5T5R '	'BPMZ5T5R:rdY '	1	[5, 5]	69 'BPM'	137.361
'BPMZ6T5R '	'BPMZ6T5R:rdX '	1	'BPMZ6T5R '	'BPMZ6T5R:rdY '	1	[5, 6]	70 'BPM'	138.995
'BPMZ7T5R '	'BPMZ7T5R:rdX '	1	'BPMZ7T5R '	'BPMZ7T5R:rdY '	1	[5, 7]	71 'BPM'	141.474
'BPMZ1D6R '	'BPMZ1D6R:rdX '	1	'BPMZ1D6R '	'BPMZ1D6R:rdY '	1	[6, 1]	72 'BPM'	142.675
'BPMZ2D6R '	'BPMZ2D6R:rdX '	1	'BPMZ2D6R '	'BPMZ2D6R:rdY '	1	[6, 2]	73 'BPM'	143.591
'BPMZ3D6R '	'BPMZ3D6R:rdX '	1	'BPMZ3D6R '	'BPMZ3D6R:rdY '	1	[6, 3]	74 'BPM'	146.005
'BPMZ4D6R '	'BPMZ4D6R:rdX '	1	'BPMZ4D6R '	'BPMZ4D6R:rdY '	1	[6, 4]	75 'BPM'	147.264
'BPMZ41D6R'	'BPMZ41D6R:rdX'	1	'BPMZ41D6R'	'BPMZ41D6R:rdY'	1	[6, 41]	76 'BPM'	147.72918
'BPMZ42D6R'	'BPMZ42D6R:rdX'	1	'BPMZ42D6R'	'BPMZ42D6R:rdY'	1	[6, 42]	77 'BPM'	149.58046
'BPMZ43D6R'	'BPMZ43D6R:rdX'	1	'BPMZ43D6R'	'BPMZ43D6R:rdY'	1	[6, 43]	78 'BPM'	150.2976
'BPMZ44D6R'	'BPMZ44D6R:rdX'	1	'BPMZ44D6R'	'BPMZ44D6R:rdY'	1	[6, 44]	79 'BPM'	152.32503
'BPMZ6D6R '	'BPMZ6D6R:rdX '	1	'BPMZ6D6R '	'BPMZ6D6R:rdY '	1	[6, 6]	80 'BPM'	153.995
'BPMZ7D6R '	'BPMZ7D6R:rdX '	1	'BPMZ7D6R '	'BPMZ7D6R:rdY '	1	[6, 7]	81 'BPM'	156.474
'BPMZ1T6R '	'BPMZ1T6R:rdX '	1	'BPMZ1T6R '	'BPMZ1T6R:rdY '	1	[6, 1]	82 'BPM'	157.675
'BPMZ2T6R '	'BPMZ2T6R:rdX '	1	'BPMZ2T6R '	'BPMZ2T6R:rdY '	1	[6, 2]	83 'BPM'	158.591
'BPMZ3T6R '	'BPMZ3T6R:rdX '	1	'BPMZ3T6R '	'BPMZ3T6R:rdY '	1	[6, 3]	84 'BPM'	161.005
'BPMZ4T6R '	'BPMZ4T6R:rdX '	1	'BPMZ4T6R '	'BPMZ4T6R:rdY '	1	[6, 4]	85 'BPM'	162.639
'BPMZ5T6R '	'BPMZ5T6R:rdX '	1	'BPMZ5T6R '	'BPMZ5T6R:rdY '	1	[6, 5]	86 'BPM'	167.361
'BPMZ6T6R '	'BPMZ6T6R:rdX '	1	'BPMZ6T6R '	'BPMZ6T6R:rdY '	1	[6, 6]	87 'BPM'	168.995
'BPMZ7T6R '	'BPMZ7T6R:rdX '	1	'BPMZ7T6R '	'BPMZ7T6R:rdY '	1	[6, 7]	88 'BPM'	171.474
'BPMZ1D7R '	'BPMZ1D7R:rdX '	1	'BPMZ1D7R '	'BPMZ1D7R:rdY '	1	[7, 1]	89 'BPM'	172.675
'BPMZ2D7R '	'BPMZ2D7R:rdX '	1	'BPMZ2D7R '	'BPMZ2D7R:rdY '	1	[7, 2]	90 'BPM'	173.591
'BPMZ3D7R '	'BPMZ3D7R:rdX '	1	'BPMZ3D7R '	'BPMZ3D7R:rdY '	1	[7, 3]	91 'BPM'	176.005
'BPMZ4D7R '	'BPMZ4D7R:rdX '	1	'BPMZ4D7R '	'BPMZ4D7R:rdY '	1	[7, 4]	92 'BPM'	177.264
'BPMZ5D7R '	'BPMZ5D7R:rdX '	1	'BPMZ5D7R '	'BPMZ5D7R:rdY '	1	[7, 5]	93 'BPM'	182.736
'BPMZ6D7R '	'BPMZ6D7R:rdX '	1	'BPMZ6D7R '	'BPMZ6D7R:rdY '	1	[7, 6]	94 'BPM'	183.995
'BPMZ7D7R '	'BPMZ7D7R:rdX '	1	'BPMZ7D7R '	'BPMZ7D7R:rdY '	1	[7, 7]	95 'BPM'	186.474
'BPMZ1T7R '	'BPMZ1T7R:rdX '	1	'BPMZ1T7R '	'BPMZ1T7R:rdY '	1	[7, 1]	96 'BPM'	187.675
'BPMZ2T7R '	'BPMZ2T7R:rdX '	1	'BPMZ2T7R '	'BPMZ2T7R:rdY '	1	[7, 2]	97 'BPM'	188.591
'BPMZ3T7R '	'BPMZ3T7R:rdX '	1	'BPMZ3T7R '	'BPMZ3T7R:rdY '	1	[7, 3]	98 'BPM'	191.005
'BPMZ4T7R '	'BPMZ4T7R:rdX '	1	'BPMZ4T7R '	'BPMZ4T7R:rdY '	1	[7, 4]	99 'BPM'	192.639
'BPMZ5T7R '	'BPMZ5T7R:rdX '	1	'BPMZ5T7R '	'BPMZ5T7R:rdY '	1	[7, 5]	100 'BPM'	197.361
'BPMZ6T7R '	'BPMZ6T7R:rdX '	1	'BPMZ6T7R '	'BPMZ6T7R:rdY '	1	[7, 6]	101 'BPM'	198.995
'BPMZ7T7R '	'BPMZ7T7R:rdX '	1	'BPMZ7T7R '	'BPMZ7T7R:rdY '	1	[7, 7]	102 'BPM'	201.474
'BPMZ1D8R '	'BPMZ1D8R:rdX '	1	'BPMZ1D8R '	'BPMZ1D8R:rdY '	1	[8, 1]	103 'BPM'	202.675
'BPMZ2D8R '	'BPMZ2D8R:rdX '	1	'BPMZ2D8R '	'BPMZ2D8R:rdY '	1	[8, 2]	104 'BPM'	203.591
'BPMZ3D8R '	'BPMZ3D8R:rdX '	1	'BPMZ3D8R '	'BPMZ3D8R:rdY '	1	[8, 3]	105 'BPM'	206.005
'BPMZ4D8R '	'BPMZ4D8R:rdX '	1	'BPMZ4D8R '	'BPMZ4D8R:rdY '	1	[8, 4]	106 'BPM'	207.264
'BPMZ5D8R '	'BPMZ5D8R:rdX '	1	'BPMZ5D8R '	'BPMZ5D8R:rdY '	1	[8, 5]	107 'BPM'	212.736
'BPMZ6D8R '	'BPMZ6D8R:rdX '	1	'BPMZ6D8R '	'BPMZ6D8R:rdY '	1	[8, 6]	108 'BPM'	213.995
'BPMZ7D8R '	'BPMZ7D8R:rdX '	1	'BPMZ7D8R '	'BPMZ7D8R:rdY '	1	[8, 7]	109 'BPM'	216.474
'BPMZ1T8R '	'BPMZ1T8R:rdX '	1	'BPMZ1T8R '	'BPMZ1T8R:rdY '	1	[8, 1]	110 'BPM'	217.675
'BPMZ2T8R '	'BPMZ2T8R:rdX '	1	'BPMZ2T8R '	'BPMZ2T8R:rdY '	1	[8, 2]	111 'BPM'	218.591
'BPMZ3T8R '	'BPMZ3T8R:rdX '	1	'BPMZ3T8R '	'BPMZ3T8R:rdY '	1	[8, 3]	112 'BPM'	221.005
'BPMZ4T8R '	'BPMZ4T8R:rdX '	1	'BPMZ4T8R '	'BPMZ4T8R:rdY '	1	[8, 4]	113 'BPM'	222.639
'BPMZ5T8R '	'BPMZ5T8R:rdX '	1	'BPMZ5T8R '	'BPMZ5T8R:rdY '	1	[8, 5]	114 'BPM'	227.361
'BPMZ6T8R '	'BPMZ6T8R:rdX '	1	'BPMZ6T8R '	'BPMZ6T8R:rdY '	1	[8, 6]	115 'BPM'	228.995
'BPMZ7T8R '	'BPMZ7T8R:rdX '	1	'BPMZ7T8R '	'BPMZ7T8R:rdY '	1	[8, 7]	116 'BPM'	231.474
'BPMZ1D1R '	'BPMZ1D1R:rdX '	1	'BPMZ1D1R '	'BPMZ1D1R:rdY '	1	[1, 1]	117 'BPM'	232.675
'BPMZ2D1R '	'BPMZ2D1R:rdX '	1	'BPMZ2D1R '	'BPMZ2D1R:rdY '	1	[1, 2]	118 'BPM'	233.591
'BPMZ3D1R '	'BPMZ3D1R:rdX '	1	'BPMZ3D1R '	'BPMZ3D1R:rdY '	1	[1, 3]	119 'BPM'	236.005
'BPMZ4D1R '	'BPMZ4D1R:rdX '	1	'BPMZ4D1R '	'BPMZ4D1R:rdY '	1	[1, 4]	110 'BPM'	237.264
'BPMZ41D1R'	'BPMZ41D1R:rdX'	1	'BPMZ41D1R'	'BPMZ41D1R:rdY'	1	[1, 41]	121 'BPM'	238.215
'BPMZ42D1R'	'BPMZ42D1R:rdX'	1	'BPMZ42D1R'	'BPMZ42D1R:rdY'	1	[1, 42]	122 'BPM'	238.418
};

AO.BPMx.FamilyName               = 'BPMx';
AO.BPMx.FamilyType               = 'BPM';
AO.BPMx.MemberOf                 = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.Monitor.Mode             = Mode;
AO.BPMx.Monitor.DataType         = 'Scalar';
AO.BPMx.Monitor.Units            = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'meter';

AO.BPMy.FamilyName               = 'BPMy';
AO.BPMy.FamilyType               = 'BPM';
AO.BPMy.MemberOf                 = {'PlotFamily'; 'BPM'; 'BPMy';  'Diagnostics'};
AO.BPMy.Monitor.Mode             = Mode;
AO.BPMy.Monitor.DataType         = 'Scalar';
AO.BPMy.Monitor.Units            = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'meter';

%Load fields from data block
for ii=1:size(bpm,1)    
    AO.BPMx.CommonNames(ii,:)         = bpm{ii,1};
	AO.BPMx.Monitor.ChannelNames(ii,:)= @getBPMFromIOC; %bpm{ii,2};
    AO.BPMx.Monitor.CNParam(ii,:)     = bpm{ii,2};
	AO.BPMx.Status(ii,:)              = bpm{ii,3};  
	AO.BPMy.CommonNames(ii,:)         = bpm{ii,4};
	AO.BPMy.Monitor.ChannelNames(ii,:)= @getBPMFromIOC; %bpm{ii,5};
    AO.BPMy.Monitor.CNParam(ii,:)     = bpm{ii,5};
	AO.BPMy.Status(ii,:)              = bpm{ii,6};  
	AO.BPMx.DeviceList(ii,:)          = bpm{ii,7};   
	AO.BPMy.DeviceList(ii,:)          = bpm{ii,7};
	AO.BPMx.ElementList(ii,:)         = bpm{ii,8};   
	AO.BPMy.ElementList(ii,:)         = bpm{ii,8};
	AO.BPMx.Position(ii,:)            = bpm{ii,10};   
	AO.BPMy.Position(ii,:)            = bpm{ii,10};
	AO.BPMx.Monitor.HW2PhysicsParams(ii,:) = [1 0];
	AO.BPMx.Monitor.Physics2HWParams(ii,:) = 1;
	AO.BPMy.Monitor.HW2PhysicsParams(ii,:) = [1 0];
	AO.BPMy.Monitor.Physics2HWParams(ii,:) = 1;
end

AO.BPMx.Status = AO.BPMx.Status(:);
AO.BPMy.Status = AO.BPMy.Status(:);

% Sum und Cross Functions on BPMs
families={'BPMx' 'BPMy'};
for ii=1:size(families,1)
	AO.(families{ii}).Cross.Mode             = Mode;
	AO.(families{ii}).Cross.Units            = 'Hardware';
	AO.(families{ii}).Cross.DataType         = 'Vector';
	AO.(families{ii}).Cross.DataTypeIndex    = [1:ntbpm];
	AO.(families{ii}).Cross.SpecialFunctionGet  = 'getbpmq';
	AO.(families{ii}).Cross.HWUnits          = 'mm';
	AO.(families{ii}).Cross.PhysicsUnits     = 'meter';
	AO.(families{ii}).Cross.HW2PhysicsParams = 1e-3;
	AO.(families{ii}).Cross.Physics2HWParams = 1000;
	AO.(families{ii}).Sum.Mode             = Mode;
	AO.(families{ii}).Sum.Units            = 'Hardware';
	AO.(families{ii}).Sum.DataType         = 'Vector';
	AO.(families{ii}).Sum.DataTypeIndex    = [1:ntbpm];
	AO.(families{ii}).Sum.SpecialFunctionGet  = 'getbpmsum';   % Returns the BPM button voltage sum
	AO.(families{ii}).Sum.HWUnits          = 'ADC Counts';
	AO.(families{ii}).Sum.PhysicsUnits     = 'ADC Counts';
	AO.(families{ii}).Sum.HW2PhysicsParams = 1;
	AO.(families{ii}).Sum.Physics2HWParams = 1;
end

setao(AO);
setoperationalmode(OperationalMode);
