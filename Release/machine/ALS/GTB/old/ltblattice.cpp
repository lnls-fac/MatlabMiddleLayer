<div class="moz-text-flowed" style="font-family: -moz-fixed">// LTB01.cpp, a part of gemapp4
//  2004.04.01 H. Nishimura

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "goemon.h"

class ALSLTB:public BeamLine
{
  public:
//  Quad *Qfa, *Qda;
  ALSLTB();
 ~ALSLTB();
	

};

ALSLTB::ALSLTB():BeamLine()
{
//define lattice;
/*  Energy  = 0.05; { GeV }
  dP      = 1.0E-6;
  dK      = 0.01;
  CODdxdy = 1.0E-5;
  CODeps  = 1.0E-15;
  Brho    = 0.1685;
*/

  double Brho    = 0.1685;
  DRIFT(L4,3.83);
  QUAD(Q11,0.15,-0.781050/Brho);
  DRIFT(L5,0.30);
  QUAD(Q12,0.15, 1.2635/Brho);
  QUAD(Q13,0.15,-0.781050/Brho);
  DRIFT(L6,1.4);
  BEND(LTBBS,0.50,40.0,0,40.0,0.0);
  DRIFT(L7,0.992);
  DRIFT(L8,0.075);
  QUAD(Q2,0.15,1.7752/Brho);
  DRIFT(L9,0.9331);
  BEND(B1,0.50,40.0,18.0,18.0,0.0);
  DRIFT(L10,0.5);
  QUAD(Q31,0.15,1.524537/Brho);
  QUAD(Q32,0.15,-1.251297/Brho);
  DRIFT(L11,2.3894);
  BEND(B2,0.50,-20.0,-10.0,-10.0,0.0);
  DRIFT(L3,0.5);
  QUAD(Q41,0.15, 1.976818/Brho);
  QUAD(Q42,0.15,-1.552307/Brho);
  DRIFT(L12,2.5079);
  QUAD(Q5,0.15,1.23613/Brho);
  DRIFT(L13,0.5);
  QUAD(Q6,0.15,-1.069303/Brho);
  BEND(BRSI,0.35,-10.0,-5.0,-5.0,0.0);
  DRIFT(L14,0.8682);
  DRIFT(BRLQD1, 0.3);
  DRIFT(L15,1.2936);
  BEND(BRKI,0.5,-3.5,-3.5,0.0,0.0);
  DRIFT(L16,0.25);
  QUAD(BRLQF2,0.15,0.462/Brho);

  MARKER(START);

  Eline LTB= START+L4+Q11+L5+Q12+L5+Q11+L6+LTBBS+L7+L8+Q2+L9+B1+L10+
            Q31+ L5+ Q32+ L11+ B2+ L3+ Q41+ L5+ Q42+ L12+ Q5+ L13+
            Q6+ L10+ BRSI+ L14+ BRLQD1+ L15+ BRKI+ L16+ BRLQF2;

   setLine(&LTB);
   setName("LTB");
   //add(BLINE);

}

ALSLTB::~ALSLTB()
{

}

int main()
{
	ALSLTB LTB;
	LTB.list();

	BLTable DB;
	DB.read(&LTB);
	DB.write("LTBDEF.txt");

	return 0;
}
/***************
---------------------------------------------
                       L[m]       S[m]
---------------------------------------------
   0:START              0.00000   0.00000
   1:L4                 3.83000   3.83000
   2:Q11                0.15000   3.98000
   3:L5                 0.30000   4.28000
   4:Q12                0.15000   4.43000
   5:L5                 0.30000   4.73000
   6:Q11                0.15000   4.88000
   7:L6                 1.40000   6.28000
   8:LTBBS              0.50000   6.78000
   9:L7                 0.99200   7.77200
  10:L8                 0.07500   7.84700
  11:Q2                 0.15000   7.99700
  12:L9                 0.93310   8.93010
  13:B1                 0.50000   9.43010
  14:L10                0.50000   9.93010
  15:Q31                0.15000  10.08010
  16:L5                 0.30000  10.38010
  17:Q32                0.15000  10.53010
  18:L11                2.38940  12.91950
  19:B2                 0.50000  13.41950
  20:L3                 0.50000  13.91950
  21:Q41                0.15000  14.06950
  22:L5                 0.30000  14.36950
  23:Q42                0.15000  14.51950
  24:L12                2.50790  17.02740
  25:Q5                 0.15000  17.17740
  26:L13                0.50000  17.67740
  27:Q6                 0.15000  17.82740
  28:L10                0.50000  18.32740
  29:BRSI               0.35000  18.67740
  30:L14                0.86820  19.54560
  31:BRLQD1             0.30000  19.84560
  32:L15                1.29360  21.13920
  33:BRKI               0.50000  21.63920
  34:L16                0.25000  21.88920
  35:BRLQF2             0.15000  22.03920
---------------------------------------------
****************************/</div>