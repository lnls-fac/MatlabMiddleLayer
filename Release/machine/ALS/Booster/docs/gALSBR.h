#ifndef __gALSBR_H
#define __gALSBR_H

/**
 *   ALSBR0
 *   The simplest ideal lattice for ALS BR. 
 */
class ALSBR0:public Ring
{
  public:
  /**
   *   Constructor.
   */
  ALSBR0();
  /**
   *   Destructor.
   */
 ~ALSBR0();

  double getKQF();
  double getKQD();
  double getBetaX();
  double getBetaY();
  double getEtaX();
};


/**
 *   ALSBR0B
 *   The simplest ideal lattice for ALS BR with Bingo.
 */
class ALSBR0B:public Ring
{
  public:
  /**
   *   Constructor.
   */
  ALSBR0B();
  /**
   *   Destructor.
   */
 ~ALSBR0B();

  Cavity *Cav;
  double getKQF();
  double getKQD();
  double getBetaX();
  double getBetaY();
  double getEtaX();
};

/**
 *   ALSBR
 *   <TODO: insert function description here>
 *   Base class Ring <TODO: insert base class description here>
 *   @remarks <TODO: insert remarks here>
 */
class ALSBR:public Ring
{
protected:
	BPMon *BPMS[33];
	Belement *BelemBPM[33];
	Steer *HCMag[17];
	Steer *VCMag[17];
	Belement *BelemHCM[17];
	Belement *BelemVCM[17];

  public:
  /**
   *   Constructor.
   */
  ALSBR();
  /**
   *   Destructor.
   */
 ~ALSBR();
  double getBPM(int dir, int n);
  //void listBPM(FILE *f=stdout);
  //void listHCM(FILE *f=stdout);
  //void listVCM(FILE *f=stdout);

};

#endif
