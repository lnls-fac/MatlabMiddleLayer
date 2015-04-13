function varargout = bessy2atdeck(varargin)
% Created by Goemon2AccLab Converter

global FAMLIST THERING

L0 = 240;        % design length [m]
C0 = 299792458;  % speed of light [m/s]
H  = 400;        % cavity harmonic number
F  = C0*H/L0;
Energy = 1.7e9;
FAMLIST = cell(0);


% Dipoles: cut for HB-steerer 
 BM1D1R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1D1R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1D2R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1D2R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1D3R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1D3R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1D4R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1D4R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1D5R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1D5R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1D6R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1D6R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1D7R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1D7R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1D8R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1D8R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1T1R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1T1R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1T2R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1T2R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1T3R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1T3R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1T4R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1T4R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1T5R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1T5R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1T6R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1T6R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1T7R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1T7R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM1T8R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM1T8R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2D1R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2D1R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2D2R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2D2R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2D3R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2D3R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2D4R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2D4R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2D5R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2D5R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2D6R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2D6R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2D7R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2D7R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2D8R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2D8R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2T1R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2T1R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2T2R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2T2R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2T3R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2T3R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2T4R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2T4R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2T5R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2T5R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2T6R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2T6R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2T7R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2T7R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');
 BM2T8R1	 = rbend('BEND',0.427500,5.625000*(pi/180),5.625000*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');
 BM2T8R2	 = rbend('BEND',0.427500,5.625000*(pi/180),0.000000*(pi/180),5.625000*(pi/180),0.000000,'BendLinearPass');


% Quadrupoles:
 Q1M1D1R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1D2R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1D3R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1D4R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1D5R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1D6R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1D7R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1D8R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1T1R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1T2R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1T3R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1T4R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1T5R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1T6R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1T7R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M1T8R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2D1R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2D2R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2D3R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2D4R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2D5R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2D6R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2D7R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2D8R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2T1R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2T2R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2T3R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2T4R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2T5R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2T6R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2T7R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 Q1M2T8R	 = quadrupole('Q1',0.250000,2.447746,'QuadLinearPass');
 
 Q2M1D1R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1D2R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1D3R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1D4R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1D5R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1D6R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1D7R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1D8R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1T1R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1T2R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1T3R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1T4R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1T5R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1T6R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1T7R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M1T8R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2D1R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2D2R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2D3R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2D4R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2D5R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2D6R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2D7R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2D8R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2T1R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2T2R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2T3R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2T4R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2T5R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2T6R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2T7R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 Q2M2T8R	 = quadrupole('Q2',0.200000,-1.856167,'QuadLinearPass');
 
 Q3M1D1R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M1D2R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M1D3R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M1D4R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M1D5R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M1D6R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M1D7R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M1D8R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M1T1R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M1T2R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M1T3R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M1T4R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M1T5R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M1T6R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M1T7R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M1T8R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M2D1R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M2D2R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M2D3R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M2D4R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M2D5R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M2D6R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M2D7R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M2D8R	 = quadrupole('Q3',0.250000,-2.082959,'QuadLinearPass');
 Q3M2T1R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M2T2R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M2T3R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M2T4R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M2T5R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M2T6R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M2T7R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 Q3M2T8R	 = quadrupole('Q3',0.250000,-2.495013,'QuadLinearPass');
 
 Q4M1D1R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M1D2R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M1D3R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M1D4R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M1D5R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M1D6R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M1D7R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M1D8R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass'); 
 Q4M1T1R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M1T2R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M1T3R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M1T4R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M1T5R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M1T6R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M1T7R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M1T8R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M2D1R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M2D2R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M2D3R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M2D4R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M2D5R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M2D6R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M2D7R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M2D8R	 = quadrupole('Q4',0.500000,1.437637,'QuadLinearPass');
 Q4M2T1R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M2T2R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M2T3R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M2T4R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M2T5R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M2T6R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M2T7R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 Q4M2T8R	 = quadrupole('Q4',0.500000,2.602422,'QuadLinearPass');
 
 Q5M1T1R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M1T2R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M1T3R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M1T4R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M1T5R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M1T6R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M1T7R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M1T8R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M2T1R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M2T2R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M2T3R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M2T4R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M2T5R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M2T6R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M2T7R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');
 Q5M2T8R	 = quadrupole('Q5',0.200000,-2.546759,'QuadLinearPass');


% Sextupoles have zero length ! 
  S1MD1R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MD2R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MD3R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MD4R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MD5R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MD6R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MD7R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MD8R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MT1R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MT2R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MT3R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MT4R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MT5R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MT6R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MT7R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
  S1MT8R	 = sextupole('S1',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1D1R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1D2R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1D3R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1D4R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1D5R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1D6R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1D7R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1D8R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1T1R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1T2R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1T3R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1T4R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1T5R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1T6R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1T7R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M1T8R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2D1R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2D2R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2D3R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2D4R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2D5R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2D6R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2D7R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2D8R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2T1R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2T2R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2T3R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2T4R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2T5R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2T6R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2T7R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S2M2T8R	 = sextupole('S2',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1D1R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1D2R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1D3R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1D4R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1D5R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1D6R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1D7R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1D8R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1T1R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1T2R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1T3R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1T4R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1T5R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1T6R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1T7R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M1T8R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2D1R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2D2R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2D3R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2D4R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2D5R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2D6R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2D7R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2D8R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2T1R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2T2R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2T3R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2T4R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2T5R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2T6R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2T7R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S3M2T8R	 = sextupole('S3',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1D1R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1D2R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1D3R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1D4R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1D5R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1D6R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1D7R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1D8R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1T1R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1T2R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1T3R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1T4R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1T5R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1T6R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1T7R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M1T8R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2D1R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2D2R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2D3R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2D4R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2D5R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2D6R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2D7R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2D8R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2T1R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2T2R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2T3R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2T4R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2T5R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2T6R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2T7R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');
 S4M2T8R	 = sextupole('S4',0.000000,0,'StrMPoleSymplectic4Pass');


% Skew Quadrupoles:
CQS2M2D2R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS2M2D6R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS2M2T5R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS3M1D6R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS3M1T1R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS3M1T2R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS3M1T3R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS3M1T7R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS3M2D5R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS3M2D6R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS3M2T1R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS3M2T3R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS3M2T4R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS3M2T6R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');
CQS3M2T7R	 = quadrupole('CQS',0.0,0.0,'QuadLinearPass');


% Steerer: 
 HBM1D1R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1D2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1D3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1D4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1D5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1D6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1D7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1D8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1T1R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1T2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1T3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1T4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1T5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1T6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1T7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM1T8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2D1R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2D2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2D3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2D4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2D5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2D6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2D7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2D8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2T1R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2T2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2T3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2T4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2T5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2T6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2T7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HBM2T8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MD1R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MD2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MD3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MD4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MD5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MD6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MD7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MD8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MT1R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MT2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MT3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MT4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MT5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MT6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MT7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HS1MT8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1D1R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1D2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1D3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1D4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1D5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1D6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1D7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1D8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1T1R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1T2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1T3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1T4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1T5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1T6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1T7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M1T8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2D1R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2D2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2D3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2D4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2D5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2D6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2D7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2D8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2T1R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2T2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2T3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2T4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2T5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2T6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2T7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HS4M2T8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VS2M1D1R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1D2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1D3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1D4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1D5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1D6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1D7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1D8R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1T1R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1T2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1T3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1T4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1T5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1T6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1T7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M1T8R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2D1R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2D2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2D3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2D4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2D5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2D6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2D7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2D8R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2T1R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2T2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2T3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2T4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2T5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2T6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2T7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS2M2T8R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1D1R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1D2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1D3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1D4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1D5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1D6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1D7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1D8R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1T1R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1T2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1T3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1T4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1T5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1T6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1T7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M1T8R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2D1R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2D2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2D3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2D4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2D5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2D6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2D7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2D8R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2T1R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2T2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2T3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2T4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2T5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2T6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2T7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS3M2T8R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS4M1T1R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS4M1T2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS4M1T3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS4M1T7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS4M2T1R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS4M2T2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS4M2T3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VS4M2T7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');


% Femto Second Slicing Dipoles 
 B1ID6R1	 = rbend('BENDID',0.140000,1.658108*(pi/180),0.000000*(pi/180),1.658108*(pi/180),0.000000,'BendLinearPass');
 B1ID6R2	 = rbend('BENDID',0.140000,1.658108*(pi/180),1.658108*(pi/180),3.316216*(pi/180),0.000000,'BendLinearPass');
 B2ID6R1	 = rbend('BENDID',0.280000,-3.200000*(pi/180),-3.316216*(pi/180),-0.116216*(pi/180),0.000000,'BendLinearPass');
 B2ID6R2	 = rbend('BENDID',0.280000,-3.200000*(pi/180),-0.116216*(pi/180),-3.083784*(pi/180),0.000000,'BendLinearPass');
 B3ID6R1	 = rbend('BENDID',0.140000,1.541892*(pi/180),3.083784*(pi/180),1.541892*(pi/180),0.000000,'BendLinearPass');
 B3ID6R2	 = rbend('BENDID',0.140000,1.541892*(pi/180),1.541892*(pi/180),0.000000*(pi/180),0.000000,'BendLinearPass');

 HB1ID6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HB2ID6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
 HB3ID6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');


% ID-Steerer: 
HBU125ID2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HU125I1D2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HU125I2D2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VBU125ID2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VU125I1D2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VU125I2D2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
HBUE56I1D3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HBUE56I2D3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE56I1D3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE56I2D3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE56I3D3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE56I4D3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VBUE56I1D3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VBUE56I2D3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VUE56I1D3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VUE56I2D3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VUE56I3D3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VUE56I4D3R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
HBU49ID4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HU49I1D4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HU49I2D4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VBU49ID4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VU49I1D4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VU49I2D4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
HBUE52ID5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE52I1D5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE52I2D5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VBUE52ID5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VUE52I1D5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VUE52I2D5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
HU139I1D6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HU139I2D6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VU139I1D6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VU139I2D6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
HUE56I1D6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE56I2D6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VUE56I1D6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VUE56I2D6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
HBUE112ID7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE112I1D7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE112I2D7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VBUE112ID7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VUE112I1D7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VUE112I2D7R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
HBU49ID8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HU49I1D8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HU49I2D8R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VBU49ID8R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VU49I1D8R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VU49I2D8R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
HW7I1T1R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HW7I2T1R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HW7I1T2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HW7I2T2R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VW7I1T2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VW7I2T2R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
HW4I1T3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HW4I2T3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HW4I3T3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HW4I4T3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HW4I5T3R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE49I1T4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE49I2T4R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VUE49I1T4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VUE49I2T4R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
HBUE46IT5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE46I1T5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HUE46I2T5R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VBUE46IT5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VUE46I1T5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VUE46I2T5R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
HBU41IT6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HU41I1T6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HU41I2T6R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
VBU41IT6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VU41I1T6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
VU41I2T6R	 = corrector('VCM',0, [0 0], 'CorrectorPass');
HW7I1T7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');
HW7I2T7R	 = corrector('HCM',0, [0 0], 'CorrectorPass');


% local Feedback-Steerer: 
HFBM1D5R	 = corrector('HCMFB',0, [0 0], 'CorrectorPass');
HFBM2D5R	 = corrector('HCMFB',0, [0 0], 'CorrectorPass');
HFBM3D5R	 = corrector('HCMFB',0, [0 0], 'CorrectorPass');
HFBM4D5R	 = corrector('HCMFB',0, [0 0], 'CorrectorPass');
VFBM1D5R	 = corrector('VCMFB',0, [0 0], 'CorrectorPass');
VFBM2D5R	 = corrector('VCMFB',0, [0 0], 'CorrectorPass');
VFBM3D5R	 = corrector('VCMFB',0, [0 0], 'CorrectorPass');
VFBM4D5R	 = corrector('VCMFB',0, [0 0], 'CorrectorPass');


% kicker, bumper, septa: 
 KIK1D1R	 = corrector('KICKER',0, [0 0], 'CorrectorPass');
 KIK2D1R	 = corrector('KICKER',0, [0 0], 'CorrectorPass');
 KIK3D1R	 = corrector('KICKER',0, [0 0], 'CorrectorPass');
 KIK4D1R	 = corrector('KICKER',0, [0 0], 'CorrectorPass');


% cavities: 
CAVVolt = 1.2e+6;  % ????
CAVH1T8R	 = rfcavity('RF', 0.54, CAVVolt, F, H, 'CavityPass');
CAVH2T8R	 = rfcavity('RF', 0.54, CAVVolt, F, H, 'CavityPass');
CAVH3T8R	 = rfcavity('RF', 0.54, CAVVolt, F, H, 'CavityPass');
CAVH4T8R	 = rfcavity('RF', 0.54, CAVVolt, F, H, 'CavityPass');
 LC1HT1R	 = drift('LC1HT1R',0.200000,'DriftPass');
 LC2HT1R	 = drift('LC2HT1R',0.200000,'DriftPass');
 LC3HT1R	 = drift('LC3HT1R',0.200000,'DriftPass');
 LC4HT1R	 = drift('LC4HT1R',0.200000,'DriftPass');


% BPMs:
BPMZ1D1R	 = marker('BPM','IdentityPass');
BPMZ1D2R	 = marker('BPM','IdentityPass');
BPMZ1D3R	 = marker('BPM','IdentityPass');
BPMZ1D4R	 = marker('BPM','IdentityPass');
BPMZ1D5R	 = marker('BPM','IdentityPass');
BPMZ1D6R	 = marker('BPM','IdentityPass');
BPMZ1D7R	 = marker('BPM','IdentityPass');
BPMZ1D8R	 = marker('BPM','IdentityPass');

BPMZ1T1R	 = marker('BPM','IdentityPass');
BPMZ1T2R	 = marker('BPM','IdentityPass');
BPMZ1T3R	 = marker('BPM','IdentityPass');
BPMZ1T4R	 = marker('BPM','IdentityPass');
BPMZ1T5R	 = marker('BPM','IdentityPass');
BPMZ1T6R	 = marker('BPM','IdentityPass');
BPMZ1T7R	 = marker('BPM','IdentityPass');
BPMZ1T8R	 = marker('BPM','IdentityPass');

BPMZ2D1R	 = marker('BPM','IdentityPass');
BPMZ2D2R	 = marker('BPM','IdentityPass');
BPMZ2D3R	 = marker('BPM','IdentityPass');
BPMZ2D4R	 = marker('BPM','IdentityPass');
BPMZ2D5R	 = marker('BPM','IdentityPass');
BPMZ2D6R	 = marker('BPM','IdentityPass');
BPMZ2D7R	 = marker('BPM','IdentityPass');
BPMZ2D8R	 = marker('BPM','IdentityPass');

BPMZ2T1R	 = marker('BPM','IdentityPass');
BPMZ2T2R	 = marker('BPM','IdentityPass');
BPMZ2T3R	 = marker('BPM','IdentityPass');
BPMZ2T4R	 = marker('BPM','IdentityPass');
BPMZ2T5R	 = marker('BPM','IdentityPass');
BPMZ2T6R	 = marker('BPM','IdentityPass');
BPMZ2T7R	 = marker('BPM','IdentityPass');
BPMZ2T8R	 = marker('BPM','IdentityPass');

BPMZ3D1R	 = marker('BPM','IdentityPass');
BPMZ3D2R	 = marker('BPM','IdentityPass');
BPMZ3D3R	 = marker('BPM','IdentityPass');
BPMZ3D4R	 = marker('BPM','IdentityPass');
BPMZ3D5R	 = marker('BPM','IdentityPass');
BPMZ3D6R	 = marker('BPM','IdentityPass');
BPMZ3D7R	 = marker('BPM','IdentityPass');
BPMZ3D8R	 = marker('BPM','IdentityPass');

BPMZ3T1R	 = marker('BPM','IdentityPass');
BPMZ3T2R	 = marker('BPM','IdentityPass');
BPMZ3T3R	 = marker('BPM','IdentityPass');
BPMZ3T4R	 = marker('BPM','IdentityPass');
BPMZ3T5R	 = marker('BPM','IdentityPass');
BPMZ3T6R	 = marker('BPM','IdentityPass');
BPMZ3T7R	 = marker('BPM','IdentityPass');
BPMZ3T8R	 = marker('BPM','IdentityPass');

BPMZ41D6R	 = marker('BPMtmp','IdentityPass');
BPMZ41T3R	 = marker('BPMtmp','IdentityPass');
BPMZ42D6R	 = marker('BPMtmp','IdentityPass');
BPMZ42T3R	 = marker('BPMtmp','IdentityPass');
BPMZ43D6R	 = marker('BPMtmp','IdentityPass');

BPMZ44D6R	 = marker('BPM','IdentityPass');

BPMZ4D1R	 = marker('BPM','IdentityPass');
BPMZ4D2R	 = marker('BPM','IdentityPass');
BPMZ4D3R	 = marker('BPM','IdentityPass');
BPMZ4D4R	 = marker('BPM','IdentityPass');
BPMZ4D5R	 = marker('BPM','IdentityPass');
BPMZ4D6R	 = marker('BPM','IdentityPass');
BPMZ4D7R	 = marker('BPM','IdentityPass');
BPMZ4D8R	 = marker('BPM','IdentityPass');

BPMZ4T1R	 = marker('BPM','IdentityPass');
BPMZ4T2R	 = marker('BPM','IdentityPass');
BPMZ4T3R	 = marker('BPM','IdentityPass');
BPMZ4T4R	 = marker('BPM','IdentityPass');
BPMZ4T5R	 = marker('BPM','IdentityPass');
BPMZ4T6R	 = marker('BPM','IdentityPass');
BPMZ4T7R	 = marker('BPM','IdentityPass');
BPMZ4T8R	 = marker('BPM','IdentityPass');

BPMZ5D1R	 = marker('BPM','IdentityPass');
BPMZ5D2R	 = marker('BPM','IdentityPass');
BPMZ5D3R	 = marker('BPM','IdentityPass');
BPMZ5D4R	 = marker('BPM','IdentityPass');
BPMZ5D5R	 = marker('BPM','IdentityPass');
%BPMZ5D6R ??? using BPMZ44D6R
BPMZ5D7R	 = marker('BPM','IdentityPass');
BPMZ5D8R	 = marker('BPM','IdentityPass');

BPMZ5T1R	 = marker('BPM','IdentityPass');
BPMZ5T2R	 = marker('BPM','IdentityPass');
BPMZ5T3R	 = marker('BPM','IdentityPass');
BPMZ5T4R	 = marker('BPM','IdentityPass');
BPMZ5T5R	 = marker('BPM','IdentityPass');
BPMZ5T6R	 = marker('BPM','IdentityPass');
BPMZ5T7R	 = marker('BPM','IdentityPass');
BPMZ5T8R	 = marker('BPM','IdentityPass');

BPMZ6D1R	 = marker('BPM','IdentityPass');
BPMZ6D2R	 = marker('BPM','IdentityPass');
BPMZ6D3R	 = marker('BPM','IdentityPass');
BPMZ6D4R	 = marker('BPM','IdentityPass');
BPMZ6D5R	 = marker('BPM','IdentityPass');
BPMZ6D6R	 = marker('BPM','IdentityPass');
BPMZ6D7R	 = marker('BPM','IdentityPass');
BPMZ6D8R	 = marker('BPM','IdentityPass');

BPMZ6T1R	 = marker('BPM','IdentityPass');
BPMZ6T2R	 = marker('BPM','IdentityPass');
BPMZ6T3R	 = marker('BPM','IdentityPass');
BPMZ6T4R	 = marker('BPM','IdentityPass');
BPMZ6T5R	 = marker('BPM','IdentityPass');
BPMZ6T6R	 = marker('BPM','IdentityPass');
BPMZ6T7R	 = marker('BPM','IdentityPass');
BPMZ6T8R	 = marker('BPM','IdentityPass');

BPMZ7D1R	 = marker('BPM','IdentityPass');
BPMZ7D2R	 = marker('BPM','IdentityPass');
BPMZ7D3R	 = marker('BPM','IdentityPass');
BPMZ7D4R	 = marker('BPM','IdentityPass');
BPMZ7D5R	 = marker('BPM','IdentityPass');
BPMZ7D6R	 = marker('BPM','IdentityPass');
BPMZ7D7R	 = marker('BPM','IdentityPass');
BPMZ7D8R	 = marker('BPM','IdentityPass');

BPMZ7T1R	 = marker('BPM','IdentityPass');
BPMZ7T2R	 = marker('BPM','IdentityPass');
BPMZ7T3R	 = marker('BPM','IdentityPass');
BPMZ7T4R	 = marker('BPM','IdentityPass');
BPMZ7T5R	 = marker('BPM','IdentityPass');
BPMZ7T6R	 = marker('BPM','IdentityPass');
BPMZ7T7R	 = marker('BPM','IdentityPass');
BPMZ7T8R	 = marker('BPM','IdentityPass');

FOMZ1D1R	 = marker('BPMFOM','IdentityPass');
FOMZ1D2R	 = marker('BPMFOM','IdentityPass');
FOMZ1D3R	 = marker('BPMFOM','IdentityPass');
FOMZ1D8R	 = marker('BPMFOM','IdentityPass');
FOMZ1T4R	 = marker('BPMFOM','IdentityPass');
FOMZ2D1R	 = marker('BPMFOM','IdentityPass');


% diagnostics:


% IDs:
U125ID2R1	 = drift('U125ID2R1',2.143000,'DriftPass');
U125ID2R2	 = drift('U125ID2R2',2.143000,'DriftPass');
UE112ID7R1	 = drift('UE112ID7R1',2.143000,'DriftPass');
UE112ID7R2	 = drift('UE112ID7R2',2.143000,'DriftPass');
U139ID6R1	 = drift('U139ID6R1',0.835200,'DriftPass');
U139ID6R2	 = drift('U139ID6R2',0.835200,'DriftPass');
U41IT6R1	 = drift('U41IT6R1',1.682500,'DriftPass');
U41IT6R2	 = drift('U41IT6R2',1.682500,'DriftPass');
U49ID4R1	 = drift('U49ID4R1',2.141000,'DriftPass');
U49ID4R2	 = drift('U49ID4R2',2.141000,'DriftPass');
U49ID8R1	 = drift('U49ID8R1',2.102000,'DriftPass');
U49ID8R2	 = drift('U49ID8R2',2.102000,'DriftPass');
UE46IT5R1	 = drift('UE46IT5R1',1.714100,'DriftPass');
UE46IT5R2	 = drift('UE46IT5R2',1.714100,'DriftPass');
UE49IT4R1	 = drift('UE49IT4R1',1.592500,'DriftPass');
UE49IT4R2	 = drift('UE49IT4R2',1.592500,'DriftPass');
UE52ID5R1	 = drift('UE52ID5R1',2.105300,'DriftPass');
UE52ID5R2	 = drift('UE52ID5R2',2.105300,'DriftPass');
UE56I1D3R1	 = drift('UE56I1D3R1',0.896000,'DriftPass');
UE56I1D3R2	 = drift('UE56I1D3R2',0.896000,'DriftPass');
UE56I2D3R1	 = drift('UE56I2D3R1',0.896000,'DriftPass');
UE56I2D3R2	 = drift('UE56I2D3R2',0.896000,'DriftPass');
UE56ID3R1	 = drift('UE56ID3R1',2.267000,'DriftPass');
UE56ID3R2	 = drift('UE56ID3R2',2.267000,'DriftPass');
UE56ID6R1	 = drift('UE56ID6R1',0.896000,'DriftPass');
UE56ID6R2	 = drift('UE56ID6R2',0.896000,'DriftPass');
 W4IT3R1	 = drift('W4IT3R1',0.725000,'DriftPass');
 W4IT3R2	 = drift('W4IT3R2',0.245000,'DriftPass');
 W7IT1R1	 = drift('W7IT1R1',0.825000,'DriftPass');
 W7IT1R2	 = drift('W7IT1R2',0.825000,'DriftPass');
 W7IT2R1	 = drift('W7IT2R1',1.109500,'DriftPass');
 W7IT2R2	 = drift('W7IT2R2',1.109500,'DriftPass');
 W7IT7R1	 = drift('W7IT7R1',0.825000,'DriftPass');
 W7IT7R2	 = drift('W7IT7R2',0.825000,'DriftPass');


% drifts:
DG9L2D1R	 = drift('DG9L2D1R',0.615500,'DriftPass');
DF9L2D1R	 = drift('DF9L2D1R',0.521000,'DriftPass');
DE9L2D1R	 = drift('DE9L2D1R',0.445500,'DriftPass');
DD9L2D1R	 = drift('DD9L2D1R',0.203000,'DriftPass');
DC9L2D1R	 = drift('DC9L2D1R',0.402500,'DriftPass');
DB9L2D1R	 = drift('DB9L2D1R',0.548500,'DriftPass');
DA9L2D1R	 = drift('DA9L2D1R',0.150000,'DriftPass');
 D8L2D1R	 = drift('D8L2D1R',0.233000,'DriftPass');
 D7L2D1R	 = drift('D7L2D1R',0.233000,'DriftPass');
DB6L2D1R	 = drift('DB6L2D1R',0.143000,'DriftPass');
DA6L2D1R	 = drift('DA6L2D1R',0.090000,'DriftPass');
 D5L2D1R	 = drift('D5L2D1R',0.420000,'DriftPass');
 D4L2D1R	 = drift('D4L2D1R',0.420000,'DriftPass');
DB3L2D1R	 = drift('DB3L2D1R',0.244000,'DriftPass');
DA3L2D1R	 = drift('DA3L2D1R',0.143000,'DriftPass');
 D2L2D1R	 = drift('D2L2D1R',0.368000,'DriftPass');
 D1L2D1R	 = drift('D1L2D1R',0.265000,'DriftPass');
DA1L1T1R	 = drift('DA1L1T1R',0.175000,'DriftPass');
DB1L1T1R	 = drift('DB1L1T1R',0.090000,'DriftPass');
 D2L1T1R	 = drift('D2L1T1R',0.368000,'DriftPass');
DA3L1T1R	 = drift('DA3L1T1R',0.208000,'DriftPass');
DB3L1T1R	 = drift('DB3L1T1R',0.179000,'DriftPass');
 D4L1T1R	 = drift('D4L1T1R',0.420000,'DriftPass');
 D5L1T1R	 = drift('D5L1T1R',0.420000,'DriftPass');
DA6L1T1R	 = drift('DA6L1T1R',0.090000,'DriftPass');
DB6L1T1R	 = drift('DB6L1T1R',0.143000,'DriftPass');
 D7L1T1R	 = drift('D7L1T1R',0.233000,'DriftPass');
 D8L1T1R	 = drift('D8L1T1R',0.233000,'DriftPass');
 D9L1T1R	 = drift('D9L1T1R',0.233000,'DriftPass');
DA10L1T1R	 = drift('DA10L1T1R',0.092000,'DriftPass');
DB10L1T1R	 = drift('DB10L1T1R',0.301000,'DriftPass');
DC10L1T1R	 = drift('DC10L1T1R',0.220000,'DriftPass');
DD10L1T1R	 = drift('DD10L1T1R',0.215000,'DriftPass');
DD10L2T1R	 = drift('DD10L2T1R',0.104600,'DriftPass');
DC10L2T1R	 = drift('DC10L2T1R',0.805400,'DriftPass');
DB10L2T1R	 = drift('DB10L2T1R',0.626000,'DriftPass');
DA10L2T1R	 = drift('DA10L2T1R',0.092000,'DriftPass');
 D9L2T1R	 = drift('D9L2T1R',0.233000,'DriftPass');
 D8L2T1R	 = drift('D8L2T1R',0.233000,'DriftPass');
 D7L2T1R	 = drift('D7L2T1R',0.233000,'DriftPass');
DB6L2T1R	 = drift('DB6L2T1R',0.143000,'DriftPass');
DA6L2T1R	 = drift('DA6L2T1R',0.090000,'DriftPass');
 D5L2T1R	 = drift('D5L2T1R',0.420000,'DriftPass');
 D4L2T1R	 = drift('D4L2T1R',0.420000,'DriftPass');
DB3L2T1R	 = drift('DB3L2T1R',0.244000,'DriftPass');
DA3L2T1R	 = drift('DA3L2T1R',0.143000,'DriftPass');
 D2L2T1R	 = drift('D2L2T1R',0.368000,'DriftPass');
 D1L2T1R	 = drift('D1L2T1R',0.265000,'DriftPass');
DA1L1D2R	 = drift('DA1L1D2R',0.175000,'DriftPass');
DB1L1D2R	 = drift('DB1L1D2R',0.090000,'DriftPass');
 D2L1D2R	 = drift('D2L1D2R',0.368000,'DriftPass');
DA3L1D2R	 = drift('DA3L1D2R',0.208000,'DriftPass');
DB3L1D2R	 = drift('DB3L1D2R',0.179000,'DriftPass');
 D4L1D2R	 = drift('D4L1D2R',0.420000,'DriftPass');
 D5L1D2R	 = drift('D5L1D2R',0.420000,'DriftPass');
DA6L1D2R	 = drift('DA6L1D2R',0.090000,'DriftPass');
DB6L1D2R	 = drift('DB6L1D2R',0.143000,'DriftPass');
 D7L1D2R	 = drift('D7L1D2R',0.233000,'DriftPass');
 D8L1D2R	 = drift('D8L1D2R',0.233000,'DriftPass');
DA9L1D2R	 = drift('DA9L1D2R',0.150000,'DriftPass');
DB9L1D2R	 = drift('DB9L1D2R',0.344000,'DriftPass');
DC9L1D2R	 = drift('DC9L1D2R',0.249000,'DriftPass');
DC9L2D2R	 = drift('DC9L2D2R',0.249000,'DriftPass');
DB9L2D2R	 = drift('DB9L2D2R',0.344000,'DriftPass');
DA9L2D2R	 = drift('DA9L2D2R',0.150000,'DriftPass');
 D8L2D2R	 = drift('D8L2D2R',0.233000,'DriftPass');
 D7L2D2R	 = drift('D7L2D2R',0.233000,'DriftPass');
DB6L2D2R	 = drift('DB6L2D2R',0.143000,'DriftPass');
DA6L2D2R	 = drift('DA6L2D2R',0.090000,'DriftPass');
 D5L2D2R	 = drift('D5L2D2R',0.420000,'DriftPass');
 D4L2D2R	 = drift('D4L2D2R',0.420000,'DriftPass');
DB3L2D2R	 = drift('DB3L2D2R',0.244000,'DriftPass');
DA3L2D2R	 = drift('DA3L2D2R',0.143000,'DriftPass');
 D2L2D2R	 = drift('D2L2D2R',0.368000,'DriftPass');
 D1L2D2R	 = drift('D1L2D2R',0.265000,'DriftPass');
DA1L1T2R	 = drift('DA1L1T2R',0.175000,'DriftPass');
DB1L1T2R	 = drift('DB1L1T2R',0.090000,'DriftPass');
 D2L1T2R	 = drift('D2L1T2R',0.368000,'DriftPass');
DA3L1T2R	 = drift('DA3L1T2R',0.208000,'DriftPass');
DB3L1T2R	 = drift('DB3L1T2R',0.179000,'DriftPass');
 D4L1T2R	 = drift('D4L1T2R',0.420000,'DriftPass');
 D5L1T2R	 = drift('D5L1T2R',0.420000,'DriftPass');
DA6L1T2R	 = drift('DA6L1T2R',0.090000,'DriftPass');
DB6L1T2R	 = drift('DB6L1T2R',0.143000,'DriftPass');
 D7L1T2R	 = drift('D7L1T2R',0.233000,'DriftPass');
 D8L1T2R	 = drift('D8L1T2R',0.233000,'DriftPass');
 D9L1T2R	 = drift('D9L1T2R',0.233000,'DriftPass');
DA10L1T2R	 = drift('DA10L1T2R',0.092000,'DriftPass');
DB10L1T2R	 = drift('DB10L1T2R',0.491000,'DriftPass');
DC10L1T2R	 = drift('DC10L1T2R',0.760500,'DriftPass');
DC10L2T2R	 = drift('DC10L2T2R',0.760500,'DriftPass');
DB10L2T2R	 = drift('DB10L2T2R',0.491000,'DriftPass');
DA10L2T2R	 = drift('DA10L2T2R',0.092000,'DriftPass');
 D9L2T2R	 = drift('D9L2T2R',0.233000,'DriftPass');
 D8L2T2R	 = drift('D8L2T2R',0.233000,'DriftPass');
 D7L2T2R	 = drift('D7L2T2R',0.233000,'DriftPass');
DB6L2T2R	 = drift('DB6L2T2R',0.143000,'DriftPass');
DA6L2T2R	 = drift('DA6L2T2R',0.090000,'DriftPass');
 D5L2T2R	 = drift('D5L2T2R',0.420000,'DriftPass');
 D4L2T2R	 = drift('D4L2T2R',0.420000,'DriftPass');
DB3L2T2R	 = drift('DB3L2T2R',0.244000,'DriftPass');
DA3L2T2R	 = drift('DA3L2T2R',0.143000,'DriftPass');
 D2L2T2R	 = drift('D2L2T2R',0.368000,'DriftPass');
 D1L2T2R	 = drift('D1L2T2R',0.265000,'DriftPass');
DA1L1D3R	 = drift('DA1L1D3R',0.175000,'DriftPass');
DB1L1D3R	 = drift('DB1L1D3R',0.090000,'DriftPass');
 D2L1D3R	 = drift('D2L1D3R',0.368000,'DriftPass');
DA3L1D3R	 = drift('DA3L1D3R',0.208000,'DriftPass');
DB3L1D3R	 = drift('DB3L1D3R',0.179000,'DriftPass');
 D4L1D3R	 = drift('D4L1D3R',0.420000,'DriftPass');
 D5L1D3R	 = drift('D5L1D3R',0.420000,'DriftPass');
DA6L1D3R	 = drift('DA6L1D3R',0.090000,'DriftPass');
DB6L1D3R	 = drift('DB6L1D3R',0.143000,'DriftPass');
 D7L1D3R	 = drift('D7L1D3R',0.233000,'DriftPass');
 D8L1D3R	 = drift('D8L1D3R',0.233000,'DriftPass');
DA9L1D3R	 = drift('DA9L1D3R',0.150000,'DriftPass');
DB9L1D3R	 = drift('DB9L1D3R',0.340000,'DriftPass');
DC9L1D3R	 = drift('DC9L1D3R',0.129000,'DriftPass');
DD9L1D3R	 = drift('DD9L1D3R',0.475000,'DriftPass');
DC9L2D3R	 = drift('DC9L2D3R',0.475000,'DriftPass');
DB9L2D3R	 = drift('DB9L2D3R',0.469000,'DriftPass');
DA9L2D3R	 = drift('DA9L2D3R',0.150000,'DriftPass');
 D8L2D3R	 = drift('D8L2D3R',0.233000,'DriftPass');
 D7L2D3R	 = drift('D7L2D3R',0.233000,'DriftPass');
DB6L2D3R	 = drift('DB6L2D3R',0.143000,'DriftPass');
DA6L2D3R	 = drift('DA6L2D3R',0.090000,'DriftPass');
 D5L2D3R	 = drift('D5L2D3R',0.420000,'DriftPass');
 D4L2D3R	 = drift('D4L2D3R',0.420000,'DriftPass');
DB3L2D3R	 = drift('DB3L2D3R',0.244000,'DriftPass');
DA3L2D3R	 = drift('DA3L2D3R',0.143000,'DriftPass');
 D2L2D3R	 = drift('D2L2D3R',0.368000,'DriftPass');
 D1L2D3R	 = drift('D1L2D3R',0.265000,'DriftPass');
DA1L1T3R	 = drift('DA1L1T3R',0.175000,'DriftPass');
DB1L1T3R	 = drift('DB1L1T3R',0.090000,'DriftPass');
 D2L1T3R	 = drift('D2L1T3R',0.368000,'DriftPass');
DA3L1T3R	 = drift('DA3L1T3R',0.208000,'DriftPass');
DB3L1T3R	 = drift('DB3L1T3R',0.179000,'DriftPass');
 D4L1T3R	 = drift('D4L1T3R',0.420000,'DriftPass');
 D5L1T3R	 = drift('D5L1T3R',0.420000,'DriftPass');
DA6L1T3R	 = drift('DA6L1T3R',0.090000,'DriftPass');
DB6L1T3R	 = drift('DB6L1T3R',0.143000,'DriftPass');
 D7L1T3R	 = drift('D7L1T3R',0.233000,'DriftPass');
 D8L1T3R	 = drift('D8L1T3R',0.233000,'DriftPass');
 D9L1T3R	 = drift('D9L1T3R',0.233000,'DriftPass');
DA10L1T3R	 = drift('DA10L1T3R',0.092000,'DriftPass');
DB10L1T3R	 = drift('DB10L1T3R',0.666000,'DriftPass');
DC10L1T3R	 = drift('DC10L1T3R',0.594000,'DriftPass');
DD10L1T3R	 = drift('DD10L1T3R',0.228500,'DriftPass');
DE10L1T3R	 = drift('DE10L1T3R',0.147500,'DriftPass');
DF10L2T3R	 = drift('DF10L2T3R',0.134500,'DriftPass');
DE10L2T3R	 = drift('DE10L2T3R',0.223000,'DriftPass');
DD10L2T3R	 = drift('DD10L2T3R',0.594000,'DriftPass');
DC10L2T3R	 = drift('DC10L2T3R',0.505000,'DriftPass');
DB10L2T3R	 = drift('DB10L2T3R',0.659500,'DriftPass');
DA10L2T3R	 = drift('DA10L2T3R',0.092000,'DriftPass');
 D9L2T3R	 = drift('D9L2T3R',0.233000,'DriftPass');
 D8L2T3R	 = drift('D8L2T3R',0.233000,'DriftPass');
 D7L2T3R	 = drift('D7L2T3R',0.233000,'DriftPass');
DB6L2T3R	 = drift('DB6L2T3R',0.143000,'DriftPass');
DA6L2T3R	 = drift('DA6L2T3R',0.090000,'DriftPass');
 D5L2T3R	 = drift('D5L2T3R',0.420000,'DriftPass');
 D4L2T3R	 = drift('D4L2T3R',0.420000,'DriftPass');
DB3L2T3R	 = drift('DB3L2T3R',0.244000,'DriftPass');
DA3L2T3R	 = drift('DA3L2T3R',0.143000,'DriftPass');
 D2L2T3R	 = drift('D2L2T3R',0.368000,'DriftPass');
 D1L2T3R	 = drift('D1L2T3R',0.265000,'DriftPass');
DA1L1D4R	 = drift('DA1L1D4R',0.175000,'DriftPass');
DB1L1D4R	 = drift('DB1L1D4R',0.090000,'DriftPass');
 D2L1D4R	 = drift('D2L1D4R',0.368000,'DriftPass');
DA3L1D4R	 = drift('DA3L1D4R',0.208000,'DriftPass');
DB3L1D4R	 = drift('DB3L1D4R',0.179000,'DriftPass');
 D4L1D4R	 = drift('D4L1D4R',0.420000,'DriftPass');
 D5L1D4R	 = drift('D5L1D4R',0.420000,'DriftPass');
DA6L1D4R	 = drift('DA6L1D4R',0.090000,'DriftPass');
DB6L1D4R	 = drift('DB6L1D4R',0.143000,'DriftPass');
 D7L1D4R	 = drift('D7L1D4R',0.233000,'DriftPass');
 D8L1D4R	 = drift('D8L1D4R',0.233000,'DriftPass');
DA9L1D4R	 = drift('DA9L1D4R',0.150000,'DriftPass');
DB9L1D4R	 = drift('DB9L1D4R',0.335000,'DriftPass');
DC9L1D4R	 = drift('DC9L1D4R',0.260000,'DriftPass');
DC9L2D4R	 = drift('DC9L2D4R',0.250000,'DriftPass');
DB9L2D4R	 = drift('DB9L2D4R',0.345000,'DriftPass');
DA9L2D4R	 = drift('DA9L2D4R',0.150000,'DriftPass');
 D8L2D4R	 = drift('D8L2D4R',0.233000,'DriftPass');
 D7L2D4R	 = drift('D7L2D4R',0.233000,'DriftPass');
DB6L2D4R	 = drift('DB6L2D4R',0.143000,'DriftPass');
DA6L2D4R	 = drift('DA6L2D4R',0.090000,'DriftPass');
 D5L2D4R	 = drift('D5L2D4R',0.420000,'DriftPass');
 D4L2D4R	 = drift('D4L2D4R',0.420000,'DriftPass');
DB3L2D4R	 = drift('DB3L2D4R',0.244000,'DriftPass');
DA3L2D4R	 = drift('DA3L2D4R',0.143000,'DriftPass');
 D2L2D4R	 = drift('D2L2D4R',0.368000,'DriftPass');
 D1L2D4R	 = drift('D1L2D4R',0.265000,'DriftPass');
DA1L1T4R	 = drift('DA1L1T4R',0.175000,'DriftPass');
DB1L1T4R	 = drift('DB1L1T4R',0.090000,'DriftPass');
 D2L1T4R	 = drift('D2L1T4R',0.368000,'DriftPass');
DA3L1T4R	 = drift('DA3L1T4R',0.208000,'DriftPass');
DB3L1T4R	 = drift('DB3L1T4R',0.179000,'DriftPass');
 D4L1T4R	 = drift('D4L1T4R',0.420000,'DriftPass');
 D5L1T4R	 = drift('D5L1T4R',0.420000,'DriftPass');
DA6L1T4R	 = drift('DA6L1T4R',0.090000,'DriftPass');
DB6L1T4R	 = drift('DB6L1T4R',0.143000,'DriftPass');
 D7L1T4R	 = drift('D7L1T4R',0.233000,'DriftPass');
 D8L1T4R	 = drift('D8L1T4R',0.233000,'DriftPass');
 D9L1T4R	 = drift('D9L1T4R',0.233000,'DriftPass');
DA10L1T4R	 = drift('DA10L1T4R',0.092000,'DriftPass');
DB10L1T4R	 = drift('DB10L1T4R',0.371000,'DriftPass');
DC10L1T4R	 = drift('DC10L1T4R',0.050000,'DriftPass');
DD10L1T4R	 = drift('DD10L1T4R',0.072500,'DriftPass');
DD10L2T4R	 = drift('DD10L2T4R',0.072500,'DriftPass');
DC10L2T4R	 = drift('DC10L2T4R',0.050000,'DriftPass');
DB10L2T4R	 = drift('DB10L2T4R',0.921000,'DriftPass');
DA10L2T4R	 = drift('DA10L2T4R',0.092000,'DriftPass');
 D9L2T4R	 = drift('D9L2T4R',0.233000,'DriftPass');
 D8L2T4R	 = drift('D8L2T4R',0.233000,'DriftPass');
 D7L2T4R	 = drift('D7L2T4R',0.233000,'DriftPass');
DB6L2T4R	 = drift('DB6L2T4R',0.143000,'DriftPass');
DA6L2T4R	 = drift('DA6L2T4R',0.090000,'DriftPass');
 D5L2T4R	 = drift('D5L2T4R',0.420000,'DriftPass');
 D4L2T4R	 = drift('D4L2T4R',0.420000,'DriftPass');
DB3L2T4R	 = drift('DB3L2T4R',0.244000,'DriftPass');
DA3L2T4R	 = drift('DA3L2T4R',0.143000,'DriftPass');
 D2L2T4R	 = drift('D2L2T4R',0.368000,'DriftPass');
 D1L2T4R	 = drift('D1L2T4R',0.265000,'DriftPass');
DA1L1D5R	 = drift('DA1L1D5R',0.175000,'DriftPass');
DB1L1D5R	 = drift('DB1L1D5R',0.090000,'DriftPass');
 D2L1D5R	 = drift('D2L1D5R',0.368000,'DriftPass');
DA3L1D5R	 = drift('DA3L1D5R',0.208000,'DriftPass');
DB3L1D5R	 = drift('DB3L1D5R',0.179000,'DriftPass');
 D4L1D5R	 = drift('D4L1D5R',0.420000,'DriftPass');
 D5L1D5R	 = drift('D5L1D5R',0.420000,'DriftPass');
DA6L1D5R	 = drift('DA6L1D5R',0.090000,'DriftPass');
DB6L1D5R	 = drift('DB6L1D5R',0.143000,'DriftPass');
 D7L1D5R	 = drift('D7L1D5R',0.233000,'DriftPass');
 D8L1D5R	 = drift('D8L1D5R',0.233000,'DriftPass');
DA9L1D5R	 = drift('DA9L1D5R',0.216500,'DriftPass');
DB9L1D5R	 = drift('DB9L1D5R',0.255000,'DriftPass');
DC9L1D5R	 = drift('DC9L1D5R',0.107800,'DriftPass');
DD9L1D5R	 = drift('DD9L1D5R',0.157200,'DriftPass');
DE9L1D5R	 = drift('DE9L1D5R',0.044200,'DriftPass');
DE9L2D5R	 = drift('DE9L2D5R',0.044200,'DriftPass');
DD9L2D5R	 = drift('DD9L2D5R',0.157200,'DriftPass');
DC9L2D5R	 = drift('DC9L2D5R',0.107800,'DriftPass');
DB9L2D5R	 = drift('DB9L2D5R',0.255000,'DriftPass');
DA9L2D5R	 = drift('DA9L2D5R',0.216500,'DriftPass');
 D8L2D5R	 = drift('D8L2D5R',0.233000,'DriftPass');
 D7L2D5R	 = drift('D7L2D5R',0.233000,'DriftPass');
DB6L2D5R	 = drift('DB6L2D5R',0.143000,'DriftPass');
DA6L2D5R	 = drift('DA6L2D5R',0.090000,'DriftPass');
 D5L2D5R	 = drift('D5L2D5R',0.420000,'DriftPass');
 D4L2D5R	 = drift('D4L2D5R',0.420000,'DriftPass');
DB3L2D5R	 = drift('DB3L2D5R',0.244000,'DriftPass');
DA3L2D5R	 = drift('DA3L2D5R',0.143000,'DriftPass');
 D2L2D5R	 = drift('D2L2D5R',0.368000,'DriftPass');
 D1L2D5R	 = drift('D1L2D5R',0.265000,'DriftPass');
DA1L1T5R	 = drift('DA1L1T5R',0.175000,'DriftPass');
DB1L1T5R	 = drift('DB1L1T5R',0.090000,'DriftPass');
 D2L1T5R	 = drift('D2L1T5R',0.368000,'DriftPass');
DA3L1T5R	 = drift('DA3L1T5R',0.208000,'DriftPass');
DB3L1T5R	 = drift('DB3L1T5R',0.179000,'DriftPass');
 D4L1T5R	 = drift('D4L1T5R',0.420000,'DriftPass');
 D5L1T5R	 = drift('D5L1T5R',0.420000,'DriftPass');
DA6L1T5R	 = drift('DA6L1T5R',0.090000,'DriftPass');
DB6L1T5R	 = drift('DB6L1T5R',0.143000,'DriftPass');
 D7L1T5R	 = drift('D7L1T5R',0.233000,'DriftPass');
 D8L1T5R	 = drift('D8L1T5R',0.233000,'DriftPass');
 D9L1T5R	 = drift('D9L1T5R',0.233000,'DriftPass');
DA10L1T5R	 = drift('DA10L1T5R',0.092000,'DriftPass');
DB10L1T5R	 = drift('DB10L1T5R',0.383000,'DriftPass');
DC10L1T5R	 = drift('DC10L1T5R',0.220000,'DriftPass');
DD10L1T5R	 = drift('DD10L1T5R',0.043900,'DriftPass');
DD10L2T5R	 = drift('DD10L2T5R',0.043900,'DriftPass');
DC10L2T5R	 = drift('DC10L2T5R',0.220000,'DriftPass');
DB10L2T5R	 = drift('DB10L2T5R',0.383000,'DriftPass');
DA10L2T5R	 = drift('DA10L2T5R',0.092000,'DriftPass');
 D9L2T5R	 = drift('D9L2T5R',0.233000,'DriftPass');
 D8L2T5R	 = drift('D8L2T5R',0.233000,'DriftPass');
 D7L2T5R	 = drift('D7L2T5R',0.233000,'DriftPass');
DB6L2T5R	 = drift('DB6L2T5R',0.143000,'DriftPass');
DA6L2T5R	 = drift('DA6L2T5R',0.090000,'DriftPass');
 D5L2T5R	 = drift('D5L2T5R',0.420000,'DriftPass');
 D4L2T5R	 = drift('D4L2T5R',0.420000,'DriftPass');
DB3L2T5R	 = drift('DB3L2T5R',0.244000,'DriftPass');
DA3L2T5R	 = drift('DA3L2T5R',0.143000,'DriftPass');
 D2L2T5R	 = drift('D2L2T5R',0.368000,'DriftPass');
 D1L2T5R	 = drift('D1L2T5R',0.265000,'DriftPass');
DA1L1D6R	 = drift('DA1L1D6R',0.175000,'DriftPass');
DB1L1D6R	 = drift('DB1L1D6R',0.090000,'DriftPass');
 D2L1D6R	 = drift('D2L1D6R',0.368000,'DriftPass');
DA3L1D6R	 = drift('DA3L1D6R',0.208000,'DriftPass');
DB3L1D6R	 = drift('DB3L1D6R',0.179000,'DriftPass');
 D4L1D6R	 = drift('D4L1D6R',0.420000,'DriftPass');
 D5L1D6R	 = drift('D5L1D6R',0.420000,'DriftPass');
DA6L1D6R	 = drift('DA6L1D6R',0.090000,'DriftPass');
DB6L1D6R	 = drift('DB6L1D6R',0.143000,'DriftPass');
 D7L1D6R	 = drift('D7L1D6R',0.233000,'DriftPass');
 D8L1D6R	 = drift('D8L1D6R',0.233000,'DriftPass');
DA9L1D6R	 = drift('DA9L1D6R',0.150000,'DriftPass');
DB9L1D6R	 = drift('DB9L1D6R',0.094000,'DriftPass');
DC9L1D6R	 = drift('DC9L1D6R',0.091180,'DriftPass');
DD9L1D6R	 = drift('DD9L1D6R',0.010640,'DriftPass');
DE9L1D6R	 = drift('DE9L1D6R',0.045000,'DriftPass');
DF9L1D6R	 = drift('DF9L1D6R',0.034800,'DriftPass');
DG9L1D6R	 = drift('DG9L1D6R',0.034800,'DriftPass');
DH9L1D6R	 = drift('DH9L1D6R',0.045000,'DriftPass');
DI9L1D6R	 = drift('DI9L1D6R',0.010640,'DriftPass');
DJ9L1D6R	 = drift('DJ9L1D6R',0.077680,'DriftPass');
DI9L2D6R	 = drift('DI9L2D6R',0.079460,'DriftPass');
DH9L2D6R	 = drift('DH9L2D6R',0.008715,'DriftPass');
DG9L2D6R	 = drift('DG9L2D6R',0.047500,'DriftPass');
DF9L2D6R	 = drift('DF9L2D6R',0.061500,'DriftPass');
DE9L2D6R	 = drift('DE9L2D6R',0.061500,'DriftPass');
DD9L2D6R	 = drift('DD9L2D6R',0.047500,'DriftPass');
DC9L2D6R	 = drift('DC9L2D6R',0.008715,'DriftPass');
DB9L2D6R	 = drift('DB9L2D6R',0.109360,'DriftPass');
DA9L2D6R	 = drift('DA9L2D6R',0.180000,'DriftPass');
 D8L2D6R	 = drift('D8L2D6R',0.233000,'DriftPass');
 D7L2D6R	 = drift('D7L2D6R',0.233000,'DriftPass');
DB6L2D6R	 = drift('DB6L2D6R',0.143000,'DriftPass');
DA6L2D6R	 = drift('DA6L2D6R',0.090000,'DriftPass');
 D5L2D6R	 = drift('D5L2D6R',0.420000,'DriftPass');
 D4L2D6R	 = drift('D4L2D6R',0.420000,'DriftPass');
DB3L2D6R	 = drift('DB3L2D6R',0.244000,'DriftPass');
DA3L2D6R	 = drift('DA3L2D6R',0.143000,'DriftPass');
 D2L2D6R	 = drift('D2L2D6R',0.368000,'DriftPass');
 D1L2D6R	 = drift('D1L2D6R',0.265000,'DriftPass');
DA1L1T6R	 = drift('DA1L1T6R',0.175000,'DriftPass');
DB1L1T6R	 = drift('DB1L1T6R',0.090000,'DriftPass');
 D2L1T6R	 = drift('D2L1T6R',0.368000,'DriftPass');
DA3L1T6R	 = drift('DA3L1T6R',0.208000,'DriftPass');
DB3L1T6R	 = drift('DB3L1T6R',0.179000,'DriftPass');
 D4L1T6R	 = drift('D4L1T6R',0.420000,'DriftPass');
 D5L1T6R	 = drift('D5L1T6R',0.420000,'DriftPass');
DA6L1T6R	 = drift('DA6L1T6R',0.090000,'DriftPass');
DB6L1T6R	 = drift('DB6L1T6R',0.143000,'DriftPass');
 D7L1T6R	 = drift('D7L1T6R',0.233000,'DriftPass');
 D8L1T6R	 = drift('D8L1T6R',0.233000,'DriftPass');
 D9L1T6R	 = drift('D9L1T6R',0.233000,'DriftPass');
DA10L1T6R	 = drift('DA10L1T6R',0.092000,'DriftPass');
DB10L1T6R	 = drift('DB10L1T6R',0.436000,'DriftPass');
DC10L1T6R	 = drift('DC10L1T6R',0.242500,'DriftPass');
DC10L2T6R	 = drift('DC10L2T6R',0.372500,'DriftPass');
DB10L2T6R	 = drift('DB10L2T6R',0.306000,'DriftPass');
DA10L2T6R	 = drift('DA10L2T6R',0.092000,'DriftPass');
 D9L2T6R	 = drift('D9L2T6R',0.233000,'DriftPass');
 D8L2T6R	 = drift('D8L2T6R',0.233000,'DriftPass');
 D7L2T6R	 = drift('D7L2T6R',0.233000,'DriftPass');
DB6L2T6R	 = drift('DB6L2T6R',0.143000,'DriftPass');
DA6L2T6R	 = drift('DA6L2T6R',0.090000,'DriftPass');
 D5L2T6R	 = drift('D5L2T6R',0.420000,'DriftPass');
 D4L2T6R	 = drift('D4L2T6R',0.420000,'DriftPass');
DB3L2T6R	 = drift('DB3L2T6R',0.244000,'DriftPass');
DA3L2T6R	 = drift('DA3L2T6R',0.143000,'DriftPass');
 D2L2T6R	 = drift('D2L2T6R',0.368000,'DriftPass');
 D1L2T6R	 = drift('D1L2T6R',0.265000,'DriftPass');
DA1L1D7R	 = drift('DA1L1D7R',0.175000,'DriftPass');
DB1L1D7R	 = drift('DB1L1D7R',0.090000,'DriftPass');
 D2L1D7R	 = drift('D2L1D7R',0.368000,'DriftPass');
DA3L1D7R	 = drift('DA3L1D7R',0.208000,'DriftPass');
DB3L1D7R	 = drift('DB3L1D7R',0.179000,'DriftPass');
 D4L1D7R	 = drift('D4L1D7R',0.420000,'DriftPass');
 D5L1D7R	 = drift('D5L1D7R',0.420000,'DriftPass');
DA6L1D7R	 = drift('DA6L1D7R',0.090000,'DriftPass');
DB6L1D7R	 = drift('DB6L1D7R',0.143000,'DriftPass');
 D7L1D7R	 = drift('D7L1D7R',0.233000,'DriftPass');
 D8L1D7R	 = drift('D8L1D7R',0.233000,'DriftPass');
DA9L1D7R	 = drift('DA9L1D7R',0.150000,'DriftPass');
DB9L1D7R	 = drift('DB9L1D7R',0.351000,'DriftPass');
DC9L1D7R	 = drift('DC9L1D7R',0.242000,'DriftPass');
DC9L2D7R	 = drift('DC9L2D7R',0.372000,'DriftPass');
DB9L2D7R	 = drift('DB9L2D7R',0.221000,'DriftPass');
DA9L2D7R	 = drift('DA9L2D7R',0.150000,'DriftPass');
 D8L2D7R	 = drift('D8L2D7R',0.233000,'DriftPass');
 D7L2D7R	 = drift('D7L2D7R',0.233000,'DriftPass');
DB6L2D7R	 = drift('DB6L2D7R',0.143000,'DriftPass');
DA6L2D7R	 = drift('DA6L2D7R',0.090000,'DriftPass');
 D5L2D7R	 = drift('D5L2D7R',0.420000,'DriftPass');
 D4L2D7R	 = drift('D4L2D7R',0.420000,'DriftPass');
DB3L2D7R	 = drift('DB3L2D7R',0.244000,'DriftPass');
DA3L2D7R	 = drift('DA3L2D7R',0.143000,'DriftPass');
 D2L2D7R	 = drift('D2L2D7R',0.368000,'DriftPass');
 D1L2D7R	 = drift('D1L2D7R',0.265000,'DriftPass');
DA1L1T7R	 = drift('DA1L1T7R',0.175000,'DriftPass');
DB1L1T7R	 = drift('DB1L1T7R',0.090000,'DriftPass');
 D2L1T7R	 = drift('D2L1T7R',0.368000,'DriftPass');
DA3L1T7R	 = drift('DA3L1T7R',0.208000,'DriftPass');
DB3L1T7R	 = drift('DB3L1T7R',0.179000,'DriftPass');
 D4L1T7R	 = drift('D4L1T7R',0.420000,'DriftPass');
 D5L1T7R	 = drift('D5L1T7R',0.420000,'DriftPass');
DA6L1T7R	 = drift('DA6L1T7R',0.090000,'DriftPass');
DB6L1T7R	 = drift('DB6L1T7R',0.143000,'DriftPass');
 D7L1T7R	 = drift('D7L1T7R',0.233000,'DriftPass');
 D8L1T7R	 = drift('D8L1T7R',0.233000,'DriftPass');
 D9L1T7R	 = drift('D9L1T7R',0.233000,'DriftPass');
DA10L1T7R	 = drift('DA10L1T7R',0.092000,'DriftPass');
DB10L1T7R	 = drift('DB10L1T7R',1.321000,'DriftPass');
DC10L1T7R	 = drift('DC10L1T7R',0.215000,'DriftPass');
DC10L2T7R	 = drift('DC10L2T7R',0.910000,'DriftPass');
DB10L2T7R	 = drift('DB10L2T7R',0.626000,'DriftPass');
DA10L2T7R	 = drift('DA10L2T7R',0.092000,'DriftPass');
 D9L2T7R	 = drift('D9L2T7R',0.233000,'DriftPass');
 D8L2T7R	 = drift('D8L2T7R',0.233000,'DriftPass');
 D7L2T7R	 = drift('D7L2T7R',0.233000,'DriftPass');
DB6L2T7R	 = drift('DB6L2T7R',0.143000,'DriftPass');
DA6L2T7R	 = drift('DA6L2T7R',0.090000,'DriftPass');
 D5L2T7R	 = drift('D5L2T7R',0.420000,'DriftPass');
 D4L2T7R	 = drift('D4L2T7R',0.420000,'DriftPass');
DB3L2T7R	 = drift('DB3L2T7R',0.244000,'DriftPass');
DA3L2T7R	 = drift('DA3L2T7R',0.143000,'DriftPass');
 D2L2T7R	 = drift('D2L2T7R',0.368000,'DriftPass');
 D1L2T7R	 = drift('D1L2T7R',0.265000,'DriftPass');
DA1L1D8R	 = drift('DA1L1D8R',0.175000,'DriftPass');
DB1L1D8R	 = drift('DB1L1D8R',0.090000,'DriftPass');
 D2L1D8R	 = drift('D2L1D8R',0.368000,'DriftPass');
DA3L1D8R	 = drift('DA3L1D8R',0.208000,'DriftPass');
DB3L1D8R	 = drift('DB3L1D8R',0.179000,'DriftPass');
 D4L1D8R	 = drift('D4L1D8R',0.420000,'DriftPass');
 D5L1D8R	 = drift('D5L1D8R',0.420000,'DriftPass');
DA6L1D8R	 = drift('DA6L1D8R',0.090000,'DriftPass');
DB6L1D8R	 = drift('DB6L1D8R',0.143000,'DriftPass');
 D7L1D8R	 = drift('D7L1D8R',0.233000,'DriftPass');
 D8L1D8R	 = drift('D8L1D8R',0.233000,'DriftPass');
DA9L1D8R	 = drift('DA9L1D8R',0.150000,'DriftPass');
DB9L1D8R	 = drift('DB9L1D8R',0.351000,'DriftPass');
DC9L1D8R	 = drift('DC9L1D8R',0.283000,'DriftPass');
DC9L2D8R	 = drift('DC9L2D8R',0.413000,'DriftPass');
DB9L2D8R	 = drift('DB9L2D8R',0.221000,'DriftPass');
DA9L2D8R	 = drift('DA9L2D8R',0.150000,'DriftPass');
 D8L2D8R	 = drift('D8L2D8R',0.233000,'DriftPass');
 D7L2D8R	 = drift('D7L2D8R',0.233000,'DriftPass');
DB6L2D8R	 = drift('DB6L2D8R',0.143000,'DriftPass');
DA6L2D8R	 = drift('DA6L2D8R',0.090000,'DriftPass');
 D5L2D8R	 = drift('D5L2D8R',0.420000,'DriftPass');
 D4L2D8R	 = drift('D4L2D8R',0.420000,'DriftPass');
DB3L2D8R	 = drift('DB3L2D8R',0.244000,'DriftPass');
DA3L2D8R	 = drift('DA3L2D8R',0.143000,'DriftPass');
 D2L2D8R	 = drift('D2L2D8R',0.368000,'DriftPass');
 D1L2D8R	 = drift('D1L2D8R',0.265000,'DriftPass');
DA1L1T8R	 = drift('DA1L1T8R',0.175000,'DriftPass');
DB1L1T8R	 = drift('DB1L1T8R',0.090000,'DriftPass');
 D2L1T8R	 = drift('D2L1T8R',0.368000,'DriftPass');
DA3L1T8R	 = drift('DA3L1T8R',0.208000,'DriftPass');
DB3L1T8R	 = drift('DB3L1T8R',0.179000,'DriftPass');
 D4L1T8R	 = drift('D4L1T8R',0.420000,'DriftPass');
 D5L1T8R	 = drift('D5L1T8R',0.420000,'DriftPass');
DA6L1T8R	 = drift('DA6L1T8R',0.090000,'DriftPass');
DB6L1T8R	 = drift('DB6L1T8R',0.143000,'DriftPass');
 D7L1T8R	 = drift('D7L1T8R',0.233000,'DriftPass');
 D8L1T8R	 = drift('D8L1T8R',0.233000,'DriftPass');
 D9L1T8R	 = drift('D9L1T8R',0.233000,'DriftPass');
DA10L1T8R	 = drift('DA10L1T8R',0.092000,'DriftPass');
DB10L1T8R	 = drift('DB10L1T8R',0.845000,'DriftPass');
DC10L1T8R	 = drift('DC10L1T8R',0.375500,'DriftPass');
DD10L1T8R	 = drift('DD10L1T8R',0.060500,'DriftPass');
DD10L2T8R	 = drift('DD10L2T8R',0.315500,'DriftPass');
DC10L2T8R	 = drift('DC10L2T8R',0.375500,'DriftPass');
DB10L2T8R	 = drift('DB10L2T8R',0.590000,'DriftPass');
DA10L2T8R	 = drift('DA10L2T8R',0.092000,'DriftPass');
 D9L2T8R	 = drift('D9L2T8R',0.233000,'DriftPass');
 D8L2T8R	 = drift('D8L2T8R',0.233000,'DriftPass');
 D7L2T8R	 = drift('D7L2T8R',0.233000,'DriftPass');
DB6L2T8R	 = drift('DB6L2T8R',0.143000,'DriftPass');
DA6L2T8R	 = drift('DA6L2T8R',0.090000,'DriftPass');
 D5L2T8R	 = drift('D5L2T8R',0.420000,'DriftPass');
 D4L2T8R	 = drift('D4L2T8R',0.420000,'DriftPass');
DB3L2T8R	 = drift('DB3L2T8R',0.244000,'DriftPass');
DA3L2T8R	 = drift('DA3L2T8R',0.143000,'DriftPass');
 D2L2T8R	 = drift('D2L2T8R',0.368000,'DriftPass');
 D1L2T8R	 = drift('D1L2T8R',0.265000,'DriftPass');
DA1L1D1R	 = drift('DA1L1D1R',0.175000,'DriftPass');
DB1L1D1R	 = drift('DB1L1D1R',0.090000,'DriftPass');
 D2L1D1R	 = drift('D2L1D1R',0.368000,'DriftPass');
DA3L1D1R	 = drift('DA3L1D1R',0.208000,'DriftPass');
DB3L1D1R	 = drift('DB3L1D1R',0.179000,'DriftPass');
 D4L1D1R	 = drift('D4L1D1R',0.420000,'DriftPass');
 D5L1D1R	 = drift('D5L1D1R',0.420000,'DriftPass');
DA6L1D1R	 = drift('DA6L1D1R',0.090000,'DriftPass');
DB6L1D1R	 = drift('DB6L1D1R',0.143000,'DriftPass');
 D7L1D1R	 = drift('D7L1D1R',0.233000,'DriftPass');
 D8L1D1R	 = drift('D8L1D1R',0.233000,'DriftPass');
DA9L1D1R	 = drift('DA9L1D1R',0.150000,'DriftPass');
DB9L1D1R	 = drift('DB9L1D1R',0.505500,'DriftPass');
DC9L1D1R	 = drift('DC9L1D1R',0.445500,'DriftPass');
DD9L1D1R	 = drift('DD9L1D1R',0.203000,'DriftPass');
DE9L1D1R	 = drift('DE9L1D1R',0.402500,'DriftPass');
DF9L1D1R	 = drift('DF9L1D1R',0.665500,'DriftPass');
DG9L1D1R	 = drift('DG9L1D1R',0.514000,'DriftPass');


SEC1 = [DG9L2D1R FOMZ2D1R DF9L2D1R KIK3D1R ... 
	DE9L2D1R DD9L2D1R  ... 
	DC9L2D1R KIK4D1R DB9L2D1R BPMZ5D1R ... 
	DA9L2D1R S4M2D1R HS4M2D1R D8L2D1R ... 
	Q4M2D1R D7L2D1R S3M2D1R VS3M2D1R ... 
	DB6L2D1R BPMZ6D1R DA6L2D1R Q3M2D1R ... 
	D5L2D1R BM2D1R1 HBM2D1R BM2D1R2 D4L2D1R ... 
	Q2M2D1R DB3L2D1R BPMZ7D1R DA3L2D1R ... 
	S2M2D1R VS2M2D1R D2L2D1R Q1M2D1R ... 
	D1L2D1R S1MT1R HS1MT1R DA1L1T1R ... 
	BPMZ1T1R DB1L1T1R Q1M1T1R D2L1T1R ... 
	S2M1T1R VS2M1T1R DA3L1T1R BPMZ2T1R ... 
	DB3L1T1R Q2M1T1R D4L1T1R BM1T1R1 HBM1T1R ... 
	BM1T1R2 ... 
	D5L1T1R Q3M1T1R DA6L1T1R ... 
	BPMZ3T1R DB6L1T1R CQS3M1T1R S3M1T1R VS3M1T1R ... 
	D7L1T1R Q4M1T1R D8L1T1R ... 
	S4M1T1R HS4M1T1R VS4M1T1R D9L1T1R ... 
	Q5M1T1R DA10L1T1R BPMZ4T1R DB10L1T1R ... 
	LC1HT1R LC2HT1R LC3HT1R LC4HT1R ... 
	DC10L1T1R HW7I1T1R DD10L1T1R W7IT1R1 ... 
];  


SEC2 = [W7IT1R2 DD10L2T1R DC10L2T1R HW7I2T1R ... 
	DB10L2T1R BPMZ5T1R DA10L2T1R Q5M2T1R ... 
	D9L2T1R S4M2T1R HS4M2T1R VS4M2T1R ... 
	D8L2T1R Q4M2T1R D7L2T1R CQS3M2T1R ... 
	S3M2T1R ... 
	VS3M2T1R DB6L2T1R BPMZ6T1R ... 
	DA6L2T1R Q3M2T1R D5L2T1R BM2T1R1 HBM2T1R ... 
	BM2T1R2 ... 
	D4L2T1R Q2M2T1R DB3L2T1R ... 
	BPMZ7T1R DA3L2T1R S2M2T1R VS2M2T1R ... 
	D2L2T1R Q1M2T1R D1L2T1R S1MD2R ... 
	HS1MD2R DA1L1D2R BPMZ1D2R DB1L1D2R ... 
	Q1M1D2R D2L1D2R S2M1D2R VS2M1D2R ... 
	DA3L1D2R BPMZ2D2R DB3L1D2R Q2M1D2R ... 
	D4L1D2R BM1D2R1 HBM1D2R BM1D2R2 D5L1D2R ... 
	Q3M1D2R DA6L1D2R BPMZ3D2R DB6L1D2R ... 
	S3M1D2R VS3M1D2R D7L1D2R Q4M1D2R ... 
	D8L1D2R S4M1D2R HS4M1D2R DA9L1D2R ... 
	BPMZ4D2R DB9L1D2R VU125I1D2R FOMZ1D2R ... 
	DC9L1D2R HU125I1D2R U125ID2R1 HBU125ID2R ... 
	VBU125ID2R ... 
];  


SEC3 = [U125ID2R2 HU125I2D2R DC9L2D2R VU125I2D2R ... 
	DB9L2D2R BPMZ5D2R DA9L2D2R S4M2D2R ... 
	HS4M2D2R D8L2D2R Q4M2D2R D7L2D2R ... 
	S3M2D2R VS3M2D2R DB6L2D2R BPMZ6D2R ... 
	DA6L2D2R Q3M2D2R D5L2D2R BM2D2R1 HBM2D2R ... 
	BM2D2R2 ... 
	D4L2D2R Q2M2D2R DB3L2D2R ... 
	BPMZ7D2R DA3L2D2R CQS2M2D2R S2M2D2R VS2M2D2R ... 
	D2L2D2R Q1M2D2R D1L2D2R ... 
	S1MT2R HS1MT2R DA1L1T2R BPMZ1T2R ... 
	DB1L1T2R Q1M1T2R D2L1T2R S2M1T2R VS2M1T2R ... 
	DA3L1T2R BPMZ2T2R DB3L1T2R ... 
	Q2M1T2R D4L1T2R BM1T2R1 HBM1T2R BM1T2R2 ... 
	D5L1T2R Q3M1T2R DA6L1T2R BPMZ3T2R ... 
	DB6L1T2R CQS3M1T2R S3M1T2R VS3M1T2R ... 
	D7L1T2R Q4M1T2R D8L1T2R S4M1T2R ... 
	HS4M1T2R VS4M1T2R D9L1T2R Q5M1T2R ... 
	DA10L1T2R BPMZ4T2R DB10L1T2R HW7I1T2R VW7I1T2R ... 
	DC10L1T2R W7IT2R1  ]; 


SEC4 = [W7IT2R2 DC10L2T2R ... 
	HW7I2T2R VW7I2T2R DB10L2T2R BPMZ5T2R ... 
	DA10L2T2R Q5M2T2R D9L2T2R S4M2T2R ... 
	HS4M2T2R VS4M2T2R D8L2T2R Q4M2T2R ... 
	D7L2T2R S3M2T2R VS3M2T2R DB6L2T2R ... 
	BPMZ6T2R DA6L2T2R Q3M2T2R D5L2T2R ... 
	BM2T2R1 HBM2T2R BM2T2R2 D4L2T2R Q2M2T2R ... 
	DB3L2T2R BPMZ7T2R DA3L2T2R S2M2T2R VS2M2T2R ... 
	D2L2T2R Q1M2T2R D1L2T2R ... 
	S1MD3R HS1MD3R DA1L1D3R BPMZ1D3R ... 
	DB1L1D3R Q1M1D3R D2L1D3R S2M1D3R VS2M1D3R ... 
	DA3L1D3R BPMZ2D3R DB3L1D3R ... 
	Q2M1D3R D4L1D3R BM1D3R1 HBM1D3R BM1D3R2 ... 
	D5L1D3R Q3M1D3R DA6L1D3R BPMZ3D3R ... 
	DB6L1D3R S3M1D3R VS3M1D3R D7L1D3R ... 
	Q4M1D3R D8L1D3R S4M1D3R HS4M1D3R ... 
	DA9L1D3R BPMZ4D3R DB9L1D3R ... 
	DC9L1D3R HUE56I1D3R VUE56I1D3R UE56I1D3R1 HBUE56I1D3R ... 
	VBUE56I1D3R UE56I1D3R2 HUE56I2D3R VUE56I2D3R ... 
	DD9L1D3R  ]; 


SEC5 = [DC9L2D3R HUE56I3D3R VUE56I3D3R ... 
	UE56I2D3R1 HBUE56I2D3R ... 
	VBUE56I2D3R UE56I2D3R2 HUE56I4D3R VUE56I4D3R ... 
	DB9L2D3R BPMZ5D3R DA9L2D3R ... 
	S4M2D3R HS4M2D3R D8L2D3R Q4M2D3R ... 
	D7L2D3R S3M2D3R VS3M2D3R DB6L2D3R ... 
	BPMZ6D3R DA6L2D3R Q3M2D3R D5L2D3R ... 
	BM2D3R1 HBM2D3R BM2D3R2 D4L2D3R Q2M2D3R ... 
	DB3L2D3R BPMZ7D3R DA3L2D3R S2M2D3R VS2M2D3R ... 
	D2L2D3R Q1M2D3R D1L2D3R ... 
	S1MT3R HS1MT3R DA1L1T3R BPMZ1T3R ... 
	DB1L1T3R Q1M1T3R D2L1T3R S2M1T3R VS2M1T3R ... 
	DA3L1T3R BPMZ2T3R DB3L1T3R ... 
	Q2M1T3R D4L1T3R BM1T3R1 HBM1T3R BM1T3R2 ... 
	D5L1T3R Q3M1T3R DA6L1T3R BPMZ3T3R ... 
	DB6L1T3R CQS3M1T3R S3M1T3R VS3M1T3R ... 
	D7L1T3R Q4M1T3R D8L1T3R S4M1T3R ... 
	HS4M1T3R VS4M1T3R D9L1T3R Q5M1T3R ... 
	DA10L1T3R BPMZ4T3R DB10L1T3R HW4I1T3R ... 
	DC10L1T3R HW4I2T3R DD10L1T3R BPMZ41T3R ... 
	DE10L1T3R W4IT3R1  ]; 


SEC6 = [W4IT3R2 DF10L2T3R BPMZ42T3R ... 
	DE10L2T3R HW4I3T3R DD10L2T3R HW4I4T3R ... 
	DC10L2T3R HW4I5T3R DB10L2T3R BPMZ5T3R ... 
	DA10L2T3R Q5M2T3R D9L2T3R S4M2T3R ... 
	HS4M2T3R VS4M2T3R D8L2T3R Q4M2T3R ... 
	D7L2T3R CQS3M2T3R S3M2T3R VS3M2T3R ... 
	DB6L2T3R BPMZ6T3R DA6L2T3R Q3M2T3R ... 
	D5L2T3R BM2T3R1 HBM2T3R BM2T3R2 D4L2T3R ... 
	Q2M2T3R DB3L2T3R BPMZ7T3R DA3L2T3R ... 
	S2M2T3R VS2M2T3R D2L2T3R Q1M2T3R ... 
	D1L2T3R S1MD4R HS1MD4R DA1L1D4R ... 
	BPMZ1D4R DB1L1D4R Q1M1D4R D2L1D4R ... 
	S2M1D4R VS2M1D4R DA3L1D4R BPMZ2D4R ... 
	DB3L1D4R Q2M1D4R D4L1D4R BM1D4R1 HBM1D4R ... 
	BM1D4R2 ... 
	D5L1D4R Q3M1D4R DA6L1D4R ... 
	BPMZ3D4R DB6L1D4R S3M1D4R VS3M1D4R ... 
	D7L1D4R Q4M1D4R D8L1D4R S4M1D4R ... 
	HS4M1D4R DA9L1D4R BPMZ4D4R DB9L1D4R ... 
	VU49I1D4R ... 
	DC9L1D4R HU49I1D4R U49ID4R1 HBU49ID4R ... 
	VBU49ID4R  ]; 


SEC7 = [U49ID4R2 HU49I2D4R DC9L2D4R ... 
	VU49I2D4R ... 
	DB9L2D4R BPMZ5D4R DA9L2D4R ... 
	S4M2D4R HS4M2D4R D8L2D4R Q4M2D4R ... 
	D7L2D4R S3M2D4R VS3M2D4R DB6L2D4R ... 
	BPMZ6D4R DA6L2D4R Q3M2D4R D5L2D4R ... 
	BM2D4R1 HBM2D4R BM2D4R2 D4L2D4R Q2M2D4R ... 
	DB3L2D4R BPMZ7D4R DA3L2D4R S2M2D4R VS2M2D4R ... 
	D2L2D4R Q1M2D4R D1L2D4R ... 
	S1MT4R HS1MT4R DA1L1T4R BPMZ1T4R ... 
	DB1L1T4R Q1M1T4R D2L1T4R S2M1T4R VS2M1T4R ... 
	DA3L1T4R BPMZ2T4R DB3L1T4R ... 
	Q2M1T4R D4L1T4R BM1T4R1 HBM1T4R BM1T4R2 ... 
	D5L1T4R Q3M1T4R DA6L1T4R BPMZ3T4R ... 
	DB6L1T4R S3M1T4R VS3M1T4R D7L1T4R ... 
	Q4M1T4R D8L1T4R S4M1T4R HS4M1T4R ... 
	D9L1T4R Q5M1T4R DA10L1T4R BPMZ4T4R ... 
	DB10L1T4R VUE49I1T4R DC10L1T4R HUE49I1T4R ... 
	DD10L1T4R UE49IT4R1  ]; 


SEC8 = [UE49IT4R2 DD10L2T4R HUE49I2T4R ... 
	DC10L2T4R VUE49I2T4R DB10L2T4R BPMZ5T4R ... 
	DA10L2T4R Q5M2T4R D9L2T4R S4M2T4R ... 
	HS4M2T4R D8L2T4R Q4M2T4R D7L2T4R ... 
	CQS3M2T4R S3M2T4R VS3M2T4R DB6L2T4R ... 
	BPMZ6T4R DA6L2T4R Q3M2T4R D5L2T4R ... 
	BM2T4R1 HBM2T4R BM2T4R2 D4L2T4R Q2M2T4R ... 
	DB3L2T4R BPMZ7T4R DA3L2T4R S2M2T4R VS2M2T4R ... 
	D2L2T4R Q1M2T4R D1L2T4R ... 
	S1MD5R HS1MD5R DA1L1D5R BPMZ1D5R ... 
	DB1L1D5R Q1M1D5R D2L1D5R S2M1D5R VS2M1D5R ... 
	DA3L1D5R BPMZ2D5R DB3L1D5R ... 
	Q2M1D5R D4L1D5R BM1D5R1 HBM1D5R BM1D5R2 ... 
	D5L1D5R Q3M1D5R DA6L1D5R BPMZ3D5R ... 
	DB6L1D5R S3M1D5R VS3M1D5R D7L1D5R ... 
	Q4M1D5R D8L1D5R S4M1D5R HS4M1D5R ... 
	DA9L1D5R HFBM1D5R VFBM1D5R VUE52I1D5R ... 
	DB9L1D5R HFBM2D5R VFBM2D5R DC9L1D5R ... 
	BPMZ4D5R DD9L1D5R HUE52I1D5R DE9L1D5R ... 
	UE52ID5R1 HBUE52ID5R ... 
	VBUE52ID5R  ]; 


SEC9 = [UE52ID5R2 DE9L2D5R ... 
	HUE52I2D5R ... 
	DD9L2D5R BPMZ5D5R DC9L2D5R ... 
	HFBM3D5R VFBM3D5R DB9L2D5R HFBM4D5R VFBM4D5R ... 
	VUE52I2D5R DA9L2D5R S4M2D5R ... 
	HS4M2D5R D8L2D5R Q4M2D5R D7L2D5R ... 
	CQS3M2D5R S3M2D5R VS3M2D5R DB6L2D5R ... 
	BPMZ6D5R DA6L2D5R Q3M2D5R D5L2D5R ... 
	BM2D5R1 HBM2D5R BM2D5R2 D4L2D5R Q2M2D5R ... 
	DB3L2D5R BPMZ7D5R DA3L2D5R S2M2D5R VS2M2D5R ... 
	D2L2D5R Q1M2D5R D1L2D5R ... 
	S1MT5R HS1MT5R DA1L1T5R BPMZ1T5R ... 
	DB1L1T5R Q1M1T5R D2L1T5R S2M1T5R VS2M1T5R ... 
	DA3L1T5R BPMZ2T5R DB3L1T5R ... 
	Q2M1T5R D4L1T5R BM1T5R1 HBM1T5R BM1T5R2 ... 
	D5L1T5R Q3M1T5R DA6L1T5R BPMZ3T5R ... 
	DB6L1T5R S3M1T5R VS3M1T5R D7L1T5R ... 
	Q4M1T5R D8L1T5R S4M1T5R HS4M1T5R ... 
	D9L1T5R Q5M1T5R DA10L1T5R BPMZ4T5R ... 
	DB10L1T5R VUE46I1T5R DC10L1T5R HUE46I1T5R ... 
	DD10L1T5R UE46IT5R1 HBUE46IT5R VBUE46IT5R ... 
];  


SEC10 = [UE46IT5R2 DD10L2T5R HUE46I2T5R DC10L2T5R VUE46I2T5R ... 
	DB10L2T5R BPMZ5T5R DA10L2T5R Q5M2T5R ... 
	D9L2T5R S4M2T5R HS4M2T5R D8L2T5R ... 
	Q4M2T5R D7L2T5R S3M2T5R VS3M2T5R ... 
	DB6L2T5R BPMZ6T5R DA6L2T5R Q3M2T5R ... 
	D5L2T5R BM2T5R1 HBM2T5R BM2T5R2 D4L2T5R ... 
	Q2M2T5R DB3L2T5R BPMZ7T5R DA3L2T5R ... 
	CQS2M2T5R S2M2T5R VS2M2T5R D2L2T5R ... 
	Q1M2T5R D1L2T5R S1MD6R HS1MD6R ... 
	DA1L1D6R BPMZ1D6R DB1L1D6R Q1M1D6R ... 
	D2L1D6R S2M1D6R VS2M1D6R DA3L1D6R ... 
	BPMZ2D6R DB3L1D6R Q2M1D6R D4L1D6R ... 
	BM1D6R1 HBM1D6R BM1D6R2 D5L1D6R Q3M1D6R ... 
	DA6L1D6R BPMZ3D6R DB6L1D6R CQS3M1D6R ... 
	S3M1D6R ... 
	VS3M1D6R D7L1D6R Q4M1D6R ... 
	D8L1D6R S4M1D6R HS4M1D6R DA9L1D6R ... 
	BPMZ4D6R DB9L1D6R  ... 
	B1ID6R1 HB1ID6R B1ID6R2 DC9L1D6R ... 
	BPMZ41D6R DD9L1D6R VU139I1D6R DE9L1D6R ... 
	HU139I1D6R ... 
	DF9L1D6R U139ID6R1 U139ID6R2 DG9L1D6R ... 
	HU139I2D6R ... 
	DH9L1D6R VU139I2D6R DI9L1D6R ... 
	BPMZ42D6R DJ9L1D6R  ... 
	B2ID6R1 HB2ID6R B2ID6R2  ]; 


SEC11 = [DI9L2D6R ... 
	BPMZ43D6R DH9L2D6R VUE56I1D6R DG9L2D6R ... 
	HUE56I1D6R ... 
	DF9L2D6R UE56ID6R1 UE56ID6R2 DE9L2D6R ... 
	HUE56I2D6R ... 
	DD9L2D6R VUE56I2D6R DC9L2D6R ... 
	BPMZ44D6R DB9L2D6R  ... 
	B3ID6R1 HB3ID6R B3ID6R2 DA9L2D6R ... 
	S4M2D6R HS4M2D6R D8L2D6R Q4M2D6R ... 
	D7L2D6R CQS3M2D6R S3M2D6R VS3M2D6R ... 
	DB6L2D6R BPMZ6D6R DA6L2D6R Q3M2D6R ... 
	D5L2D6R BM2D6R1 HBM2D6R BM2D6R2 D4L2D6R ... 
	Q2M2D6R DB3L2D6R BPMZ7D6R DA3L2D6R ... 
	CQS2M2D6R S2M2D6R VS2M2D6R D2L2D6R ... 
	Q1M2D6R D1L2D6R S1MT6R HS1MT6R ... 
	DA1L1T6R BPMZ1T6R DB1L1T6R Q1M1T6R ... 
	D2L1T6R S2M1T6R VS2M1T6R DA3L1T6R ... 
	BPMZ2T6R DB3L1T6R Q2M1T6R D4L1T6R ... 
	BM1T6R1 HBM1T6R BM1T6R2 D5L1T6R Q3M1T6R ... 
	DA6L1T6R BPMZ3T6R DB6L1T6R S3M1T6R VS3M1T6R ... 
	D7L1T6R Q4M1T6R D8L1T6R ... 
	S4M1T6R HS4M1T6R D9L1T6R Q5M1T6R ... 
	DA10L1T6R BPMZ4T6R DB10L1T6R VU41I1T6R ... 
	DC10L1T6R HU41I1T6R U41IT6R1 HBU41IT6R ... 
	VBU41IT6R ... 
];  


SEC12 = [U41IT6R2 HU41I2T6R DC10L2T6R VU41I2T6R ... 
	DB10L2T6R BPMZ5T6R DA10L2T6R Q5M2T6R ... 
	D9L2T6R S4M2T6R HS4M2T6R D8L2T6R ... 
	Q4M2T6R D7L2T6R CQS3M2T6R S3M2T6R VS3M2T6R ... 
	DB6L2T6R BPMZ6T6R DA6L2T6R ... 
	Q3M2T6R D5L2T6R BM2T6R1 HBM2T6R BM2T6R2 ... 
	D4L2T6R Q2M2T6R DB3L2T6R BPMZ7T6R ... 
	DA3L2T6R S2M2T6R VS2M2T6R D2L2T6R ... 
	Q1M2T6R D1L2T6R S1MD7R HS1MD7R ... 
	DA1L1D7R BPMZ1D7R DB1L1D7R Q1M1D7R ... 
	D2L1D7R S2M1D7R VS2M1D7R DA3L1D7R ... 
	BPMZ2D7R DB3L1D7R Q2M1D7R D4L1D7R ... 
	BM1D7R1 HBM1D7R BM1D7R2 D5L1D7R Q3M1D7R ... 
	DA6L1D7R BPMZ3D7R DB6L1D7R S3M1D7R VS3M1D7R ... 
	D7L1D7R Q4M1D7R D8L1D7R ... 
	S4M1D7R HS4M1D7R DA9L1D7R BPMZ4D7R ... 
	DB9L1D7R VUE112I1D7R DC9L1D7R HUE112I1D7R ... 
	UE112ID7R1 HBUE112ID7R ... 
	VBUE112ID7R  ]; 


SEC13 = [UE112ID7R2 HUE112I2D7R ... 
	DC9L2D7R VUE112I2D7R DB9L2D7R BPMZ5D7R ... 
	DA9L2D7R S4M2D7R HS4M2D7R D8L2D7R ... 
	Q4M2D7R D7L2D7R S3M2D7R VS3M2D7R ... 
	DB6L2D7R BPMZ6D7R DA6L2D7R Q3M2D7R ... 
	D5L2D7R BM2D7R1 HBM2D7R BM2D7R2 D4L2D7R ... 
	Q2M2D7R DB3L2D7R BPMZ7D7R DA3L2D7R ... 
	S2M2D7R VS2M2D7R D2L2D7R Q1M2D7R ... 
	D1L2D7R S1MT7R HS1MT7R DA1L1T7R ... 
	BPMZ1T7R DB1L1T7R Q1M1T7R D2L1T7R ... 
	S2M1T7R VS2M1T7R DA3L1T7R BPMZ2T7R ... 
	DB3L1T7R Q2M1T7R D4L1T7R BM1T7R1 HBM1T7R ... 
	BM1T7R2 ... 
	D5L1T7R Q3M1T7R DA6L1T7R ... 
	BPMZ3T7R DB6L1T7R CQS3M1T7R S3M1T7R VS3M1T7R ... 
	D7L1T7R Q4M1T7R D8L1T7R ... 
	S4M1T7R HS4M1T7R VS4M1T7R D9L1T7R ... 
	Q5M1T7R DA10L1T7R BPMZ4T7R DB10L1T7R ... 
	HW7I1T7R ... 
	DC10L1T7R W7IT7R1  ]; 


SEC14 = [W7IT7R2 DC10L2T7R ... 
	HW7I2T7R ... 
	DB10L2T7R BPMZ5T7R DA10L2T7R ... 
	Q5M2T7R D9L2T7R S4M2T7R HS4M2T7R VS4M2T7R ... 
	D8L2T7R Q4M2T7R D7L2T7R ... 
	CQS3M2T7R S3M2T7R VS3M2T7R DB6L2T7R ... 
	BPMZ6T7R DA6L2T7R Q3M2T7R D5L2T7R ... 
	BM2T7R1 HBM2T7R BM2T7R2 D4L2T7R Q2M2T7R ... 
	DB3L2T7R BPMZ7T7R DA3L2T7R S2M2T7R VS2M2T7R ... 
	D2L2T7R Q1M2T7R D1L2T7R ... 
	S1MD8R HS1MD8R DA1L1D8R BPMZ1D8R ... 
	DB1L1D8R Q1M1D8R D2L1D8R S2M1D8R VS2M1D8R ... 
	DA3L1D8R BPMZ2D8R DB3L1D8R ... 
	Q2M1D8R D4L1D8R BM1D8R1 HBM1D8R BM1D8R2 ... 
	D5L1D8R Q3M1D8R DA6L1D8R BPMZ3D8R ... 
	DB6L1D8R S3M1D8R VS3M1D8R D7L1D8R ... 
	Q4M1D8R D8L1D8R S4M1D8R HS4M1D8R ... 
	DA9L1D8R BPMZ4D8R DB9L1D8R VU49I1D8R ... 
	FOMZ1D8R DC9L1D8R HU49I1D8R U49ID8R1 HBU49ID8R ... 
	VBU49ID8R  ]; 


SEC15 = [U49ID8R2 HU49I2D8R DC9L2D8R ... 
	VU49I2D8R ... 
	DB9L2D8R BPMZ5D8R DA9L2D8R ... 
	S4M2D8R HS4M2D8R D8L2D8R Q4M2D8R ... 
	D7L2D8R S3M2D8R VS3M2D8R DB6L2D8R ... 
	BPMZ6D8R DA6L2D8R Q3M2D8R D5L2D8R ... 
	BM2D8R1 HBM2D8R BM2D8R2 D4L2D8R Q2M2D8R ... 
	DB3L2D8R BPMZ7D8R DA3L2D8R S2M2D8R VS2M2D8R ... 
	D2L2D8R Q1M2D8R D1L2D8R ... 
	S1MT8R HS1MT8R DA1L1T8R BPMZ1T8R ... 
	DB1L1T8R Q1M1T8R D2L1T8R S2M1T8R VS2M1T8R ... 
	DA3L1T8R BPMZ2T8R DB3L1T8R ... 
	Q2M1T8R D4L1T8R BM1T8R1 HBM1T8R BM1T8R2 ... 
	D5L1T8R Q3M1T8R DA6L1T8R BPMZ3T8R ... 
	DB6L1T8R S3M1T8R VS3M1T8R D7L1T8R ... 
	Q4M1T8R D8L1T8R S4M1T8R HS4M1T8R ... 
	D9L1T8R Q5M1T8R DA10L1T8R BPMZ4T8R ... 
	DB10L1T8R CAVH1T8R DC10L1T8R CAVH2T8R ... 
	DD10L1T8R  ]; 


SEC16 = [DD10L2T8R CAVH3T8R DC10L2T8R ... 
	CAVH4T8R DB10L2T8R BPMZ5T8R DA10L2T8R ... 
	Q5M2T8R D9L2T8R S4M2T8R HS4M2T8R ... 
	D8L2T8R Q4M2T8R D7L2T8R S3M2T8R VS3M2T8R ... 
	DB6L2T8R BPMZ6T8R DA6L2T8R ... 
	Q3M2T8R D5L2T8R BM2T8R1 HBM2T8R BM2T8R2 ... 
	D4L2T8R Q2M2T8R DB3L2T8R BPMZ7T8R ... 
	DA3L2T8R S2M2T8R VS2M2T8R D2L2T8R ... 
	Q1M2T8R D1L2T8R S1MD1R HS1MD1R ... 
	DA1L1D1R BPMZ1D1R DB1L1D1R Q1M1D1R ... 
	D2L1D1R S2M1D1R VS2M1D1R DA3L1D1R ... 
	BPMZ2D1R DB3L1D1R Q2M1D1R D4L1D1R ... 
	BM1D1R1 HBM1D1R BM1D1R2 D5L1D1R Q3M1D1R ... 
	DA6L1D1R BPMZ3D1R DB6L1D1R S3M1D1R VS3M1D1R ... 
	D7L1D1R Q4M1D1R D8L1D1R ... 
	S4M1D1R HS4M1D1R DA9L1D1R BPMZ4D1R ... 
	DB9L1D1R KIK1D1R DC9L1D1R  ... 
	DD9L1D1R DE9L1D1R KIK2D1R ... 
	DF9L1D1R FOMZ1D1R DG9L1D1R  ]; 
	

 RING = [  SEC1 SEC2 SEC3 SEC4 SEC5 SEC6 SEC7 SEC8 SEC9... 
	SEC10 SEC11 SEC12 SEC13 SEC14 SEC15 SEC16   ]; 


buildlat(RING);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);


%---------------------------------------------
%--- debug section
 %---------------------------------------------
%findspos(RING,1:length(RING)+1)
l = 0;
for ii=1:length(THERING)
    %RING{1,ii} %List all Objects
    out{ii,1} = THERING{1,ii}.FamName;
    t = 0;
    for aa=1:ii-1
        t = t + THERING{1,aa}.Length;
    end
    out{ii,2} = t;
    l = THERING{1,ii}.Length + t;
end

disp(['     -> Gesamtlaenge : ',num2str(l), ' m']);
