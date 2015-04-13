//BR2000_12_31.cpp<-- aBR.cpp

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "goemon.h"
#include "ALS/gALSBR.h"


ALSBR0::ALSBR0():Ring("")
{
  MARKER(SYM);
  QUAD(QF ,0.15000, 2.7682214);
  QUAD(QD ,0.10000,-2.5401249);
  DRIFT(L1,  0.546875);
  DRIFT(L2,  0.496875);
  DRIFT(L3,  2.093750);
  BEND(B,1.05,15.0, 7.5,7.5,0.0);
  CAVITY(CAV, 500.0E6, 1.5E6/1.5E9);
  Eline HalfCell=QD+L1+B +L2+QF+QF+L3+QD+QD+L1+B +L2+QF+QF+L2+B +L1+QD;
//Eline HalfCell=QD+L1+B +L2+QF+QF+L2+B +L1+QD+QD+L1+B +L2+QF+QF+L3+QD;
  Eline Cell=HalfCell-HalfCell;
  Eline RING =SYM+2*Cell+CAV+2*Cell;
  setLine(&RING);
  setName("BR0");
  setSymmetry(1);
  setCODeps  (1.0E-16);
//  setCODeps  (1.0E-15);
  setdPcommon(1.0E-10);
  setEnergy  (1.5E+09);
  setQforTune(&QF,&QD);
  calcS();
}


ALSBR0::~ALSBR0()
{

}

double ALSBR0::getKQF()
{
  return QFforTune->getK();
}

double ALSBR0::getKQD()
{
  return QDforTune->getK();
}

double ALSBR0::getBetaX()
{
  first();
  return  getBetaH();
}

double ALSBR0::getBetaY()
{
  first();
  return  getBetaV();
}

double ALSBR0::getEtaX()
{
  first();
  return  getEtaH();
}
//-------------------------------------------------------------------
ALSBR0B::ALSBR0B():Ring("")
{
  MARKER(SYM);
  QUAD(QF ,0.15000, 2.7682214);
  QUAD(QD ,0.10000,-2.5401249);
  DRIFT(L1,  0.546875);
  DRIFT(L2,  0.496875);
  DRIFT(L3,  2.093750);
  DRIFT(L3H,  2.093750/2);
  BINGO(B,1.05,15.0,0.0);
  CAVITY(CAV, 500.0E6, 1.5E6/1.5E9*2.0);
  Cav=(Cavity*)CAV[0];

  Eline HalfCell  =QD+L1+B +L2+QF+QF+L2+B +L1+QD+QD+L1+B +L2+QF+QF+L3+QD;
  Eline HalfCellRF=QD+L1+B +L2+QF+QF+L2+B +L1+QD+QD+L1+B +L2+QF+QF+L3H+CAV+L3H+QD;
  Eline Cell=HalfCell-HalfCell;
  Eline CellRF=HalfCellRF-HalfCell;
  Eline RING =SYM+CellRF+3*Cell;
  setLine(&RING);
  setName("BR0B");
  setSymmetry(1);
  setCODeps  (1.0E-16);
//  setCODeps  (1.0E-15);
//  setdPcommon(1.0E-10);
  setdPcommon(1.0E-9);
  setEnergy  (1.5E+09);
  setQforTune(&QF,&QD);
  calcS();
}


ALSBR0B::~ALSBR0B()
{

}

double ALSBR0B::getKQF()
{
  return QFforTune->getK();
}

double ALSBR0B::getKQD()
{
  return QDforTune->getK();
}

double ALSBR0B::getBetaX()
{
  first();
  return  getBetaH();
}

double ALSBR0B::getBetaY()
{
  first();
  return  getBetaV();
}

double ALSBR0B::getEtaX()
{
  first();
  return  getEtaH();
}


//-------------------------------------------------------------------
ALSBR::ALSBR():Ring("")
{

  DRIFT(LHALF ,2.34375);
  DRIFT(LQUAD ,0.15000);
  DRIFT(LQD   ,0.05000);
  DRIFT(LFREE ,2.09375);
  DRIFT(LVCMQD,0.35000);

  BEND(BU,0.525/5, 7.5/5, 7.5,0.0,0.0);
  BEND(BM,0.525/5, 7.5/5, 0.0,0.0,0.0);
  BEND(BD,0.525/5, 7.5/5, 0.0,7.5,0.0);

  Eline BB = BU+8*BM+BD;

  QUAD(QF ,0.15000, 2.7682214);
  QUAD(QD ,0.10000,-2.5401249);

  SEXT(SF,0.0);//0.910946);
  SEXT(SD,0.0);//1.196767);

  DRIFT(LBS,0.309375);
  DRIFT(LSQ,0.187500);

  BPMON(BPM);// : beam position monitor;
  HSTEER(HCM);// : horizontal corrector;
  VSTEER(VCM);// : vertical   corrector;

  DRIFT(LBCI, 0.296875);
  DRIFT(LBC ,0.346875);
  DRIFT(LQM,0.100000);
  DRIFT(LMC,0.100000);
  DRIFT(LQC,0.200000);

  DRIFT(LVCM,1.84375-0.296875);
  DRIFT(LMON,(0.187500+0.05)/2);
  Eline MMON = LMON+BPM+LMON;// {LSQ.L};

  DRIFT(L05,0.05);

  ELINE(BLK1 ) = QD+LQM +BPM+LMC +VCM+LBC      +BB+LBS+SF+LSQ          +QF;
  ELINE(BLK2 ) = QF+LQM +BPM+LMC +HCM+LBCI     +BB+LBS+SD+LMON+BPM+LMON+QD;
  ELINE(BLK3 ) = QD+LQC          +VCM+LBC      +BB+LBCI+HCM+LMC+BPM+LQM+QF;
  ELINE(BLK4 ) = QF+LVCM +LBC    +VCM                      +LMC+BPM+LQM+QD;
  ELINE(BLK4M) = QF+LVCM             +LBC                  +LMC+BPM+LQM+QD;
  ELINE(BLK40) = QF              +LFREE                                +QD;
  ELINE(BLK5 ) = QD              +LFREE                                +QF;
  ELINE(BLK6 ) = QF+LQM +BPM+LMC +HCM+LBCI     +BB+LBC +VCM+LQC        +QD;
  ELINE(BLK7 ) = QD+LMON+BPM+LMON+SD+LBS       +BB+LBCI+HCM+LMC+BPM+LQM+QF;
  ELINE(BLK8 ) = QF+LSQ          +SF+LBS       +BB+LBS+SD+LSQ+L05      +QD;

  Eline BL1   = BLK1+BLK2+BLK3+BLK4 +BLK5+BLK6+BLK7+BLK8;
  Eline BLINJ = BLK1+BLK2+BLK3+BLK40+BLK5+BLK6+BLK7+BLK8;
  Eline BLMON = BLK1+BLK2+BLK3+BLK4M+BLK5+BLK6+BLK7+BLK8;
//  Eline RING  ={BLMON+3*BL1;}{BLINJ+3*BL1;} 4*BL1;
//  Eline RING  = BLINJ+3*BL1;//}{BLINJ+3*BL1;};// 4*BL1;
//  BeamLine BLINE(&BL1);
  Eline RING =4*BL1;

//  ElemTable.madPrint();
  //Eline::madPrintAll();
  //Eline RING(BLINE);// = BL1;

//  cell:  RING,symmetry = 1;
//  tune fitting, use QF and QD;
//  chromaticity fitting, use SF and SD;

//   SPR.list(stdout);
   setLine(&RING);
   setName("BR");
   setSymmetry(1);
   setCODeps  (1.0E-16);
   setdPcommon(1.0E-10);
   setEnergy  (1.5E+09);
   setChromParam(0.001,0.001,0.00005,0.00005);
   setQforTune(&QF,&QD);
   setPosForDisp(58);
   setSextforChrom(&SF,&SD);
   calcS();

  // Indivisualize BPM
  BelemBPM[0]=NULL;
  int i,j,n=1;
  for(i=1; i<=4; i++)
  for(j=1; j<=8; j++)
  {
    char s[100];
    sprintf(s, "BR%1d     BPM%1d", i, j);
    BPMS[n]=new BPMon(s);
    n++;
  }
  //BPMS[32]=BPMS[0];
  //BPMS[0]=NULL;
  n=30;
  Belement *belem=Root;
  while(belem!=NULL)
  {
    Element *Elem=belem->Elem;
    if((Elem==BPM[0]))
    {
      BelemBPM[n]=belem;
      belem->Elem=BPMS[n];
      n++;
	  if(n==33) n=1;
    }
    belem=belem->Belem_next;
  }

  // Indivisualize HCM
  BelemHCM[0]=NULL;
  HCMag[0]=NULL;
  n=1;
  for(i=1; i<=4; i++)
  for(j=1; j<=4; j++)
  {
    char s[100];
    sprintf(s, "BR%1d     HCM%1d", i, j);
    HCMag[n]=new Steer(s,0);
    n++;
	//if(n==17) n=1;
  }

  n=16;
  belem=Root;
  while(belem!=NULL)
  {
    Element *Elem=belem->Elem;
    if((Elem==HCM[0]))
    {
      BelemHCM[n]=belem;
      belem->Elem=HCMag[n];
      n++;
	  if(n==17) n=1;
    }
    belem=belem->Belem_next;
  }

  // Indivisualize VCM
  VCMag[0]=NULL;
  BelemVCM[0]=NULL;
  n=1;
  for(i=1; i<=4; i++)
  for(j=1; j<=4; j++)
  {
    char s[100];
    sprintf(s, "BR%1d     VCM%1d", i, j);
    VCMag[n]=new Steer(s,0);
    n++;
  }
  n=15;
  belem=Root;
  while(belem!=NULL)
  {
    Element *Elem=belem->Elem;
    if((Elem==VCM[0]))
    {
      BelemVCM[n]=belem;
      belem->Elem=VCMag[n];
      n++;
	  if(n==17) n=1;
    }
    belem=belem->Belem_next;
  }

}


ALSBR::~ALSBR()
{

}

double ALSBR::getBPM(int dir, int n)
{
  if((1<=n)&(n<=32))
  {
	if(dir==0)
		return getBPMX(n);
	else
		return getBPMY(n);
  }
  else 
		return 0.0;
}