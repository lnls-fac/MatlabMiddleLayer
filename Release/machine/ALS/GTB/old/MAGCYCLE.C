#include <windows.h>
#include <dbdefine.h>
#include <llinkc.h>
//#include <linktobw.h>
#include "y:\ilc\pcdriver\tools\windows\magfunc.h"
#include <structco.h>
#include <dbdeftyp.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <magcycle.h>
#include <ptypes.h>
#include <blsect.h>
#include <stdio.h>
//int __cdecl fscanf(FILE *, const char *, ...);
#include <stdlib.h>
#include <report.h>

//#include "driver.h"


/*  errcode = 0  no errors
    errcode = 1  magnet cycling already in progress, try again later
    errcode = 2  too many magnets
    errcode = 3  bad magnet state
*/
static	int	InUse = 0;
static	time_t	TargetTime;

//ErrorLog: opened in MCLogon
static	FILE *fhErr; 

static int		RampState, FindNameErrCntr = 0;

static float	GTL_LNTrimCurrStep;
static float	LNQ_LTB_BTSTrimCurrStep;
static float	LTBQuadCurrStep;
static float	LTBB1B2CurrStep;
static float	LTBB3CurrStep;
static float	BTSBQCurrStep;
static float	BTSSQCurrStep;
static float	BTSBCurrStep;
static float	SRHCMCurrStep;
static float	SRVCMCurrStep;
static float	SRQCurrStep;
static float	SRHVCSCurrStep;
static float	SRSQCurrStep;
static float	SRSCurrStep;                            
static float	SRQFACurrStep;
static float	SRBCurrStep;

char GString[256];

static struct	MagGroup MagGroup1[GROUP1_MEM],
							MagGroup2[GROUP2_MEM],
							MagGroup3[GROUP3_MEM],
							MagGroup4[GROUP4_MEM],
							MagGroup5[GROUP5_MEM],
							MagGroup6[GROUP6_MEM],
							MagGroup7[GROUP7_MEM],
							MagGroup8[GROUP8_MEM];

static float Grp1RampVal[GROUP1_TYPES][GROUP1_DIV+1];
static float Grp2RampVal[GROUP2_TYPES][GROUP2_DIV+1];
static float Grp3RampVal[GROUP3_TYPES][GROUP3_DIV+1];
static float Grp4RampVal[GROUP4_TYPES][GROUP4_DIV+1];
static float Grp5RampVal[GROUP5_TYPES][GROUP5_DIV+1];
//static float Grp6RampVal[GROUP6_TYPES][GROUP6_DIV+1];

static int	grp1cntr, grp2cntr, grp3cntr, grp4cntr, grp5cntr, grp6cntr, grp7cntr, grp8cntr;
static int	G1TimeRatio, G2TimeRatio, G3TimeRatio, G4TimeRatio, G5TimeRatio;

static struct	FindNameErr FindNameErrList[MAX_DB_ERR_ITEMS];

void _far _pascal GetBeamLineSection ( int *ErrCode, UBYTE4 *Index, int *sect );
int far pascal IsSectionSelected (UBYTE4 IndexILC, int DisplayMask, int DeviceMask, char *FindNameStr);

void near pascal sleep (long N);

void far pascal 
MCLogon (UBYTE2 *ErrCode);   

void 
InitialStateSetup(UBYTE2 __far *ErrCode, char far *FileSpec, int FileNameLen, UBYTE4 NewSectionMask, UBYTE2 SingleCycFlag); 

void near pascal 
SetupTables (UBYTE2 far *ErrCode, char far * FileSpec, int FileNameLen, UBYTE4 SectionMask, UBYTE2 SingleCycFlag);
void near pascal 
SetupTablesPart2 (UBYTE2 *ErrCode, char far *OutBuffer, UBYTE4 SectionMask, UBYTE2 SingleCycFlag, 
					char *string_value, UBYTE2 occur);
void near pascal 
StepMagState (UBYTE2 *ErrCode, UBYTE4 SectionMask, UBYTE2 SingleCycFlag);
void near pascal 
RampMag (UBYTE2 *ErrCode, SBYTE1 RampFlag, UBYTE4 SectionMask, REAL4 GroupLimits[GROUP_NUM][4]);
void near pascal 
RestoreMag (UBYTE2 *ErrCode, UBYTE4 SectionMask, UBYTE2 SingleCycFlag);
void near pascal 
SetTargetTime (UBYTE2 *ErrCode, UBYTE2 *TimeInterval);
void near pascal 
SetupGroups (char *Name, UBYTE4 SectionMask, UBYTE4 ACIndex, UBYTE4 DVIndex, UBYTE4 RstIndex, float RestoreVal, BOOL ironflag);
void near pascal 
SetSingleCycVal (UBYTE4 ACIndex);
void near pascal 
SetupRampArrays (UBYTE2 *ErrCode);
void WaitMagAMs(UBYTE2 *ErrCode, UBYTE4 SectionMask, UBYTE1 *CycleDone);
int _far _pascal 
SetSpWaitAM( UBYTE2 error[], UBYTE4 IndexILC[], float value[], int Nr );
int _far _pascal 
WaitAM( UBYTE2 error[], UBYTE4 IndexILC[], int Nr );
void far pascal  
TurnMagnetsOnOff (UBYTE2 *ErrCode, UBYTE2 OnOff, UBYTE4 OrigSectionMask);
static int
ParseString(char *InputStr, char *disp_name, char *chan_type, char *dev_type, char *string_value);
//static void
//LoadGroupLimits(int *ErrCode, REAL4 GroupLimits[GROUP_NUM][4]);
char *
gErrCode(UBYTE2 err);
void
SetCorrectors(UBYTE2 TmpErr, UBYTE4 SectionMask);
void
ZeroMags(UBYTE2 TmpErr, UBYTE4 SectionMask);
void
MCFilterMagnet (UBYTE2 _far *ErrCode, char _far *Name, BOOL _far *fIronDominated, BOOL _far *Pass);

static char	string_value[256];
static char ErrBuf[80];
static char	disp_name[DB_FULLNAMELEN+1],chan_type[DB_FULLNAMELEN+1], dev_type[DB_FULLNAMELEN+1];
static char	ReturnStr[DB_FULLNAMELEN+1];
static UBYTE2	TargetNameLen=0;
static UBYTE2	ReturnStrLen=sizeof(ReturnStr) - 1;


void __far __pascal __export
MCMagnetsOnOff (UBYTE2 __far *ErrCode, char __far *FileSpec, 
			int FileNameLen,UBYTE2 OnOff, UBYTE4 OrigSectionMask)
{
    UBYTE4 NewSectionMask, SectionMask;
    
    SectionMask = OrigSectionMask;
      						/* A trick to pickup all SR sectors */
    NewSectionMask = (SectionMask == (1L<<SEC_SR)) ? 0xffff00 : SectionMask;

	InitialStateSetup(ErrCode, FileSpec, FileNameLen, NewSectionMask, 0); 
	TurnMagnetsOnOff (ErrCode, OnOff, NewSectionMask);
	fclose(fhErr);
}
/*  Use a state machine where each state is indicated in the
    algorithm listed above.  Start enumerating with 0.
*/
/************************************************************/

void __far __pascal __export MCGetVersion (UBYTE2 __far *ErrCode, UBYTE2 __far *Version)
{

    *ErrCode = ERR_OK; //0 means no error
    *Version = 1;
}

/************************************************************/
#define YES	1
#define NO	0 


static UBYTE1 ErrFlag;
static long GroupMask;
UBYTE1	OnFlag = 0;


void __far __pascal __export
MCCycleMagnets (UBYTE2 far *ErrCode, UBYTE2 far *IDNumber, UBYTE2 far *TimeInterval, char far *FileSpec, 
			int FileNameLen, UBYTE4 SectionMask, UBYTE2 fMagnetsOffWhenDone, UBYTE2 SingleCycFlag)
{
    UBYTE4 NewSectionMask;
      						/* A trick to pickup all SR sectors */
    NewSectionMask = (SectionMask == (1L<<SEC_SR)) ? 0xffff00 : SectionMask;
     
    ErrFlag = NO;

	InitialStateSetup(ErrCode, FileSpec, FileNameLen, NewSectionMask, SingleCycFlag);
    if (*ErrCode) {
    	InUse = 0;
    	return;
    }

/*  Don't cycle the trims for now!
  
    GroupMask = (GROUP_6);
	StepMagState (ErrCode, NewSectionMask, SingleCycFlag);  // Cycle the trims
    if (*ErrCode)
    		ErrFlag = YES;
*/
    GroupMask = (GROUP_1 | GROUP_2 | GROUP_3 | GROUP_4 | GROUP_5);
	StepMagState (ErrCode, NewSectionMask, SingleCycFlag);  // Cycle the rest
    if (*ErrCode)
    		ErrFlag = YES;

	if (fMagnetsOffWhenDone) // we're done
   		{
   		TurnMagnetsOnOff (ErrCode, OFF, NewSectionMask);
   		if (*ErrCode)
			{
				ErrFlag = YES;
			}
   	}
	InUse = 0;
	if (ErrFlag == YES)
		*ErrCode = ANOMALY;
	else
		*ErrCode = ERR_DONE;

	fclose(fhErr);

}


REAL4 GroupLimits[GROUP_NUM][4];

void near pascal StepMagState (UBYTE2 *ErrCode, UBYTE4 SectionMask, UBYTE2 SingleCycFlag )
{
    //	Handle each of the Magnet States

    UBYTE2	TmpErr, WMErr;
    UBYTE2	ResponseDelay;
    UBYTE1	CycleDone = NO;

    TmpErr = ERR_OK;
    WMErr = ERR_OK;

    
//    LoadGroupLimits(ErrCode, GroupLimits);
    
	while (CycleDone == NO) {
	
		//Set Magnet SP's to Magnet Minimum

	    ZeroMags(TmpErr, SectionMask);

	    //Turn on all specified magnets

	    if (!OnFlag) {
	    	TurnMagnetsOnOff (ErrCode, ON, SectionMask);
	    	OnFlag = 1;
			ResponseDelay = 400;	//Wait 4 sec for Techron PSs
			DELAY(&ResponseDelay);
		}


	  	//set corrector PS to final value
	  	
	  	SetCorrectors(TmpErr, SectionMask);


		//    	RampFlag = UP;
	    RampMag ( ErrCode, UP, SectionMask, GroupLimits );
        if (*ErrCode != ERR_OK)
        	return;
        	
	  	//Cycling complete - Restore values 
	
    	RestoreMag ( ErrCode, SectionMask, SingleCycFlag );   
        if (*ErrCode != ERR_OK)
        	return;
        	
        CycleDone = YES; // If there are any magnets not done cycling,
        				 // WaitMagAMs will set CycleDone to NO.

		WaitMagAMs(&TmpErr, SectionMask, &CycleDone);
		ResponseDelay = 100;     // 1 sec delay
		DELAY(&ResponseDelay);

		if (TmpErr != ERR_OK)
			WMErr = ANOMALY;
	}
	if (WMErr == ANOMALY)
		*ErrCode = ANOMALY;
}

void
ZeroMags(UBYTE2 TmpErr, UBYTE4 SectionMask)
{
	    int	g1, g2, g3, g4, g5, g6, g7;
	    float	zero = 0;


//set PS to initial value
		for(g7=0; g7 < grp7cntr; g7++)
		 if ( SectionMask & 1L<<MagGroup7[g7].SectionMask && GroupMask & GROUP_7)
		  if ( MagGroup7[g7].CycleFlag && MagGroup7[g7].CycleLevel[CYCLE] == SET_LOWERLIM_STATE) {
		   SetSP ( &TmpErr, &MagGroup7[g7].MagnetACIndexILC, &zero /*&Grp5RampVal[MagGroup5[g5].MagType][0]*/ );
		   MagGroup7[g7].CycleLevel[CYCLE] = WAIT_LOWERLIM_STATE;
		  }

		for(g6=0; g6 < grp6cntr; g6++)
		 if ( SectionMask & 1L<<MagGroup6[g6].SectionMask && GroupMask & GROUP_6)
		  if ( MagGroup6[g6].CycleFlag && MagGroup6[g6].CycleLevel[CYCLE] == SET_LOWERLIM_STATE) {
		   SetSP ( &TmpErr, &MagGroup6[g6].MagnetACIndexILC, &zero /*&Grp5RampVal[MagGroup5[g5].MagType][0]*/ );
		   MagGroup6[g6].CycleLevel[CYCLE] = WAIT_LOWERLIM_STATE;
		  }

		for(g5=0; g5 < grp5cntr; g5++)
		 if ( SectionMask & 1L<<MagGroup5[g5].SectionMask && GroupMask & GROUP_5)
		  if ( MagGroup5[g5].CycleFlag && MagGroup5[g5].CycleLevel[CYCLE] == SET_LOWERLIM_STATE) {
		   SetSP ( &TmpErr, &MagGroup5[g5].MagnetACIndexILC, &zero /*&Grp5RampVal[MagGroup5[g5].MagType][0]*/ );
		   MagGroup5[g5].CycleLevel[CYCLE] = WAIT_LOWERLIM_STATE;
		  }

	    for(g4=0; g4 < grp4cntr; g4++)
	     if (SectionMask & 1L<<MagGroup4[g4].SectionMask && GroupMask & GROUP_4)
		  if ( MagGroup4[g4].CycleFlag && MagGroup4[g4].CycleLevel[CYCLE] == SET_LOWERLIM_STATE) {
		   SetSP ( &TmpErr, &MagGroup4[g4].MagnetACIndexILC, &zero /*&Grp4RampVal[MagGroup4[g4].MagType][0]*/ );
           MagGroup4[g4].CycleLevel[CYCLE] = WAIT_LOWERLIM_STATE;
           }
          
		for(g3=0; g3 < grp3cntr; g3++)
		 if (SectionMask & 1L<<MagGroup3[g3].SectionMask && GroupMask & GROUP_3)
		  if ( MagGroup3[g3].CycleFlag && MagGroup3[g3].CycleLevel[CYCLE] == SET_LOWERLIM_STATE) {
		   SetSP ( &TmpErr, &MagGroup3[g3].MagnetACIndexILC, &zero /*&Grp3RampVal[MagGroup3[g3].MagType][0]*/ );
           MagGroup3[g3].CycleLevel[CYCLE] = WAIT_LOWERLIM_STATE;
          }
                         
		for(g2=0; g2 < grp2cntr; g2++)
		 if (SectionMask & 1L<<MagGroup2[g2].SectionMask && GroupMask & GROUP_2)
		  if ( MagGroup2[g2].CycleFlag && MagGroup2[g2].CycleLevel[CYCLE] == SET_LOWERLIM_STATE) {
		   SetSP ( &TmpErr, &MagGroup2[g2].MagnetACIndexILC, &zero /*&Grp2RampVal[MagGroup2[g2].MagType][0]*/ );
           MagGroup2[g2].CycleLevel[CYCLE] = WAIT_LOWERLIM_STATE;
          }
          
		for(g1=0; g1 < grp1cntr; g1++)
		 if (SectionMask & 1L<<MagGroup1[g1].SectionMask && GroupMask & GROUP_1)
		  if ( MagGroup1[g1].CycleFlag && MagGroup1[g1].CycleLevel[CYCLE] == SET_LOWERLIM_STATE) {
		   SetSP ( &TmpErr, &MagGroup1[g1].MagnetACIndexILC, &zero /*&Grp1RampVal[MagGroup1[g1].MagType][0]*/ );
           MagGroup1[g1].CycleLevel[CYCLE] = WAIT_LOWERLIM_STATE;
          }

}

void
SetCorrectors(UBYTE2 TmpErr, UBYTE4 SectionMask)
{
	    int	g1, g2, g3, g4, g5, g6, g7;
        REAL4	Value;

		for(g7=0; g7 < grp7cntr; g7++)
		 	if (MagGroup7[g7].CycleLevel[CYCLE] == FINAL_TRIM_STATE)
		 		MagGroup7[g2].CycleLevel[CYCLE] = SET_FINAL_STATE;
        for(g6=0; g6 < grp1cntr; g6++) 
		 	if (MagGroup6[g6].CycleLevel[CYCLE] == FINAL_TRIM_STATE)
		 		MagGroup6[g6].CycleLevel[CYCLE] = SET_FINAL_STATE;


		for(g5=0; g5 < grp5cntr; g5++)
		 if ( SectionMask & 1L<<MagGroup5[g5].SectionMask && GroupMask & GROUP_5)
		  if (MagGroup5[g5].CycleFlag && MagGroup5[g5].CycleLevel[CYCLE] == FINAL_TRIM_STATE) {
			if (MagGroup5[g5].RestoreVal == 0)
			switch (MagGroup5[g5].TrimType)
		 		{
		 		case NO_TYPE:
		 			break;
		 		case L_HVC_MAGS:
					Value = (REAL4)FINAL_L_HVC_VAL;
		  			SetSP ( &TmpErr, &MagGroup5[g5].MagnetACIndexILC, &Value );
		 			break;
		 		case BTS_HVC_MAGNET:
					Value = (REAL4)FINAL_BTS_HVC_VAL;
		  			SetSP ( &TmpErr, &MagGroup5[g5].MagnetACIndexILC, &Value );
		 			break;
		 		default:
		 			break;
		 		}
		 	MagGroup5[g5].CycleLevel[CYCLE] = SET_FINAL_STATE;
		 	}

		//SR correctors
		for(g4=0; g4 < grp4cntr; g4++)
		 if (SectionMask & 1L<<MagGroup4[g4].SectionMask && GroupMask & GROUP_4)
		  if (MagGroup4[g4].CycleFlag && MagGroup4[g4].CycleLevel[CYCLE] == FINAL_TRIM_STATE) {
			if (MagGroup4[g4].MagType)
		 	switch (MagGroup4[g4].MagType)
		 		{
		 		case NO_TYPE:
		 			break;
		 		case SR_HCM_MAGNET:
					Value = (REAL4)FINAL_SR_HCM_VAL;
		  			SetSP ( &TmpErr, &MagGroup4[g4].MagnetACIndexILC, &Value );
		 			break;
		 		case SR_HCS_MAGNET:
					Value = (REAL4)FINAL_SR_HCS_VAL;
		  			SetSP ( &TmpErr, &MagGroup4[g4].MagnetACIndexILC, &Value );
		 			break;
		 		case SR_VCS_MAGNET:
					Value = (REAL4)FINAL_SR_VCS_VAL;
		  			SetSP ( &TmpErr, &MagGroup4[g4].MagnetACIndexILC, &Value );
		 			break;
		 		default:
		 			break;
		 		}
		   MagGroup4[g4].CycleLevel[CYCLE] = SET_FINAL_STATE;
		   }

		for(g3=0; g3 < grp3cntr; g3++)
		 if (SectionMask & 1L<<MagGroup3[g3].SectionMask && GroupMask & GROUP_3)
		  if (MagGroup3[g3].CycleFlag && MagGroup3[g3].CycleLevel[CYCLE] == FINAL_TRIM_STATE) {
			if (MagGroup3[g3].MagType)
		 	switch (MagGroup3[g3].MagType)
		 		{
		 		case NO_TYPE:
		 			break;
		 		case SR_VCM_MAGNET:
					Value = (REAL4)FINAL_SR_VCM_VAL;
		  			SetSP ( &TmpErr, &MagGroup3[g3].MagnetACIndexILC, &Value );
		 			break;
		 		default:
		 			break;
		 		}
		  MagGroup3[g3].CycleLevel[CYCLE] = SET_FINAL_STATE;
		  }
		 
		 for(g2=0; g2 < grp2cntr; g2++)
		 	if (MagGroup2[g2].CycleLevel[CYCLE] == FINAL_TRIM_STATE)
		 		MagGroup2[g2].CycleLevel[CYCLE] = SET_FINAL_STATE;
         for(g1=0; g1 < grp1cntr; g1++) 
		 	if (MagGroup1[g1].CycleLevel[CYCLE] == FINAL_TRIM_STATE)
		 		MagGroup1[g1].CycleLevel[CYCLE] = SET_FINAL_STATE;

}


void 
InitialStateSetup(UBYTE2 __far *ErrCode, char far *FileSpec, int FileNameLen, UBYTE4 NewSectionMask, UBYTE2 SingleCycFlag) 
{ 
	int i;
	    	//Zero MagGroup counters
	    	 grp1cntr = 0;
	    	 grp2cntr = 0;
	    	 grp3cntr = 0;
	    	 grp4cntr = 0;
	    	 grp5cntr = 0;
	    	 grp6cntr = 0;
	    	 grp7cntr = 0;
	    	 grp8cntr = 0;

            //Zero out the MagGroup structures
            for (i=0; i<GROUP1_MEM; i++)
            	{
            	MagGroup1[i].MagName = NULL;
            	MagGroup1[i].MagType = 0;
            	MagGroup1[i].TrimType = 0;
            	MagGroup1[i].IncrementVal = 0;
            	MagGroup1[i].RestoreVal = 0;
            	MagGroup1[i].SectionMask = 0;
            	MagGroup1[i].MagnetACIndexILC = 0;
            	MagGroup1[i].MagnetDVIndexILC = 0;
            	MagGroup1[i].MagnetRstIndexILC = 0;
            	MagGroup1[i].CycleLevel[CYCLE] = SET_LOWERLIM_STATE;
            	MagGroup1[i].CycleLevel[PREV_AM] = 0;
            	MagGroup1[i].CycleLevel[TRIES] = 0;
            	MagGroup1[i].CycleLevel[COUNT_DOWN] = 2;
            	MagGroup1[i].CycleLevel[BOUND_WAIT] = 2;
            	MagGroup1[i].CycleUpperLim = 0;
            	MagGroup1[i].CycleFlag = 1;
            }
            for (i=0; i<GROUP2_MEM; i++)
            	{
            	MagGroup2[i].MagName = NULL;
            	MagGroup2[i].MagType = 0;
            	MagGroup2[i].TrimType = 0;
            	MagGroup2[i].IncrementVal = 0;
            	MagGroup2[i].RestoreVal = 0;
            	MagGroup2[i].SectionMask = 0;
            	MagGroup2[i].MagnetACIndexILC = 0;
            	MagGroup2[i].MagnetDVIndexILC = 0;
            	MagGroup2[i].MagnetRstIndexILC = 0;
            	MagGroup2[i].CycleLevel[CYCLE] = SET_LOWERLIM_STATE;
            	MagGroup2[i].CycleLevel[PREV_AM] = 0;
            	MagGroup2[i].CycleLevel[TRIES] = 0;
            	MagGroup2[i].CycleLevel[COUNT_DOWN] = 2;
            	MagGroup2[i].CycleLevel[BOUND_WAIT] = 2;
            	MagGroup2[i].CycleUpperLim = 0;
            	MagGroup2[i].CycleFlag = 1;
            	}

            for (i=0; i<GROUP3_MEM; i++)
            	{
            	MagGroup3[i].MagName = NULL;
            	MagGroup3[i].MagType = 0;
            	MagGroup3[i].TrimType = 0;
            	MagGroup3[i].IncrementVal = 0;
            	MagGroup3[i].RestoreVal = 0;
            	MagGroup3[i].SectionMask = 0;
            	MagGroup3[i].MagnetACIndexILC = 0;
            	MagGroup3[i].MagnetDVIndexILC = 0;
            	MagGroup3[i].MagnetRstIndexILC = 0;
            	MagGroup3[i].CycleLevel[CYCLE] = SET_LOWERLIM_STATE;
            	MagGroup3[i].CycleLevel[PREV_AM] = 0;
            	MagGroup3[i].CycleLevel[TRIES] = 0;
            	MagGroup3[i].CycleLevel[COUNT_DOWN] = 2;
            	MagGroup3[i].CycleLevel[BOUND_WAIT] = 2;
            	MagGroup3[i].CycleUpperLim = 0;
            	MagGroup3[i].CycleFlag = 1;
            	}

            for (i=0; i<GROUP4_MEM; i++)
            	{
            	MagGroup4[i].MagName = NULL;
            	MagGroup4[i].MagType = 0;
            	MagGroup4[i].TrimType = 0;
            	MagGroup4[i].IncrementVal = 0;
            	MagGroup4[i].RestoreVal = 0;
            	MagGroup4[i].SectionMask = 0;
            	MagGroup4[i].MagnetACIndexILC = 0;
            	MagGroup4[i].MagnetDVIndexILC = 0;
            	MagGroup4[i].MagnetRstIndexILC = 0;
            	MagGroup4[i].CycleLevel[CYCLE] = SET_LOWERLIM_STATE;
            	MagGroup4[i].CycleLevel[PREV_AM] = 0;
            	MagGroup4[i].CycleLevel[TRIES] = 0;
            	MagGroup4[i].CycleLevel[COUNT_DOWN] = 2;
            	MagGroup4[i].CycleLevel[BOUND_WAIT] = 2;
            	MagGroup4[i].CycleUpperLim = 0;
            	MagGroup4[i].CycleFlag = 1;
           	}

			for (i=0; i<GROUP5_MEM; i++)
            	{
            	MagGroup5[i].MagName = NULL;
            	MagGroup5[i].MagType = 0;
            	MagGroup5[i].TrimType = 0;
            	MagGroup5[i].IncrementVal = 0;
            	MagGroup5[i].RestoreVal = 0;
            	MagGroup5[i].SectionMask = 0;
            	MagGroup5[i].MagnetACIndexILC = 0;
            	MagGroup5[i].MagnetDVIndexILC = 0;
            	MagGroup5[i].MagnetRstIndexILC = 0;
            	MagGroup5[i].CycleLevel[CYCLE] = SET_LOWERLIM_STATE;
            	MagGroup5[i].CycleLevel[PREV_AM] = 0;
            	MagGroup5[i].CycleLevel[TRIES] = 0;
            	MagGroup5[i].CycleLevel[COUNT_DOWN] = 2;
            	MagGroup5[i].CycleLevel[BOUND_WAIT] = 2;
            	MagGroup5[i].CycleUpperLim = 0;
            	MagGroup5[i].CycleFlag = 1;
            	}

			for (i=0; i<GROUP6_MEM; i++)        		// These guys are not to be cycled
            	{
            	MagGroup6[i].MagName = NULL;
            	MagGroup6[i].MagType = 0;
            	MagGroup6[i].TrimType = 0;
            	MagGroup6[i].IncrementVal = 0;
            	MagGroup6[i].RestoreVal = 0;
            	MagGroup6[i].SectionMask = 0;
            	MagGroup6[i].MagnetACIndexILC = 0;
            	MagGroup6[i].MagnetDVIndexILC = 0;
            	MagGroup6[i].MagnetRstIndexILC = 0;
            	MagGroup6[i].CycleLevel[CYCLE] = SET_LOWERLIM_STATE;
            	MagGroup6[i].CycleLevel[PREV_AM] = 0;
            	MagGroup6[i].CycleLevel[TRIES] = 0;
            	MagGroup6[i].CycleLevel[COUNT_DOWN] = 2;
            	MagGroup6[i].CycleLevel[BOUND_WAIT] = 2;
            	MagGroup6[i].CycleUpperLim = 0;
            	MagGroup6[i].CycleFlag = 1;		
            	}

			for (i=0; i<GROUP7_MEM; i++)        		// These guys are not to be cycled
            	{
            	MagGroup7[i].MagName = NULL;
            	MagGroup7[i].MagType = 0;
            	MagGroup7[i].TrimType = 0;
            	MagGroup7[i].IncrementVal = 0;
            	MagGroup7[i].RestoreVal = 0;
            	MagGroup7[i].SectionMask = 0;
            	MagGroup7[i].MagnetACIndexILC = 0;
            	MagGroup7[i].MagnetDVIndexILC = 0;
            	MagGroup7[i].MagnetRstIndexILC = 0;
            	MagGroup7[i].CycleLevel[CYCLE] = SET_LOWERLIM_STATE;
            	MagGroup7[i].CycleLevel[PREV_AM] = 0;
            	MagGroup7[i].CycleLevel[TRIES] = 0;
            	MagGroup7[i].CycleLevel[COUNT_DOWN] = 2;
            	MagGroup7[i].CycleLevel[BOUND_WAIT] = 2;
            	MagGroup7[i].CycleUpperLim = 0;
            	MagGroup7[i].CycleFlag = 0;		
            	}

			for (i=0; i<GROUP8_MEM; i++)        		// These guys are not to be cycled
            	{
            	MagGroup8[i].MagName = NULL;
            	MagGroup8[i].MagType = 0;
            	MagGroup8[i].TrimType = 0;
            	MagGroup8[i].IncrementVal = 0;
            	MagGroup8[i].RestoreVal = 0;
            	MagGroup8[i].SectionMask = 0;
            	MagGroup8[i].MagnetACIndexILC = 0;
            	MagGroup8[i].MagnetDVIndexILC = 0;
            	MagGroup8[i].MagnetRstIndexILC = 0;
            	MagGroup8[i].CycleLevel[CYCLE] = SET_LOWERLIM_STATE;
            	MagGroup8[i].CycleLevel[PREV_AM] = 0;
            	MagGroup8[i].CycleLevel[TRIES] = 0;
            	MagGroup8[i].CycleLevel[COUNT_DOWN] = 2;
            	MagGroup8[i].CycleLevel[BOUND_WAIT] = 2;
            	MagGroup8[i].CycleUpperLim = 0;
            	MagGroup8[i].CycleFlag = 0;		
            	}


	    	//Set up magnet tables
	    	SetupTables (ErrCode, FileSpec, FileNameLen, NewSectionMask, SingleCycFlag);
	    	if (*ErrCode)
				{
				InUse = 0;
				fclose(fhErr);
				return;
				}

}

void near pascal 
SetupTables (UBYTE2 far *ErrCode, char far * FileName, int FileNameLen, UBYTE4 SectionMask, UBYTE2 SingleCycFlag)
{
    char DVBuffer[40];
    int  fAlreadyDidLTB;
    UBYTE4  i;
    UBYTE2 occur;


	*ErrCode = ERR_OK;

    if (FileNameLen == 0)	//Create setup tables using SectionMask
		{
		_fstrcpy (string_value, "");
      	fAlreadyDidLTB = FALSE;
      	for (i=0; i < SEC_SR; i++)
			{
			if (SectionMask & (1L << i))
	    		{
	    		if (i>=SEC_LTB_INC_BS && i<=SEC_AFTER_BS_EXC_BR)
					if (fAlreadyDidLTB)
		    			i = SEC_AFTER_BS_EXC_BR;
					else
		    			fAlreadyDidLTB = TRUE;

	    		switch (i)
				{
					case SEC_EG:
		    			_fstrcpy (DVBuffer, "");	// no mags in EG section
		    			break;
					case SEC_GTL:
		    			_fstrcpy (DVBuffer, "GTL???? *DV*MPS");
		    			break;
					case SEC_LN:
		    			_fstrcpy (DVBuffer, "LN????? *DV*MPS");
		    			break;
					case SEC_LTB_INC_BS:
					case SEC_AFTER_BS_INC_FC:
					case SEC_AFTER_BS_EXC_BR:
		    			_fstrcpy (DVBuffer, "LTB???? *DV*MPS");
		    			break;
					case SEC_BR:
		    			_fstrcpy (DVBuffer, "BR????? *DV*MPS");	
		    			break;
					case SEC_BTS:
		    			_fstrcpy (DVBuffer, "BTS???? *DV*MPS");
		    			break;
					case SEC_SR01:
		    			_fstrcpy (DVBuffer, "SR01??? *DV*MPS");
		    			break;
					case SEC_SR02:
		    			_fstrcpy (DVBuffer, "SR02??? *DV*MPS");
		    			break;
					case SEC_SR03:
		    			_fstrcpy (DVBuffer, "SR03??? *DV*MPS");
		    			break;
					case SEC_SR04:
		    			_fstrcpy (DVBuffer, "SR04??? *DV*MPS");
		    			break;
					case SEC_SR05:
		    			_fstrcpy (DVBuffer, "SR05??? *DV*MPS");
		    			break;
					case SEC_SR06:
		    			_fstrcpy (DVBuffer, "SR06??? *DV*MPS");
		    			break;
					case SEC_SR07:
		    			_fstrcpy (DVBuffer, "SR07??? *DV*MPS");
		    			break;
					case SEC_SR08:
		    			_fstrcpy (DVBuffer, "SR08??? *DV*MPS");
		    			break;
					case SEC_SR09:
		    			_fstrcpy (DVBuffer, "SR09??? *DV*MPS");
		    			break;
					case SEC_SR10:
		    			_fstrcpy (DVBuffer, "SR10??? *DV*MPS");
		    			break;
					case SEC_SR11:
		    			_fstrcpy (DVBuffer, "SR11??? *DV*MPS");
		    			break;
					case SEC_SR12:
		    			_fstrcpy (DVBuffer, "SR12??? *DV*MPS");
		    			break;
					default:
		    			_fstrcpy (DVBuffer, "");
		    			break;
				}
                occur = 1;
	    		if (DVBuffer[0] != '\0') 
	    			do {
						SetupTablesPart2 (ErrCode, DVBuffer, SectionMask, SingleCycFlag, string_value, occur);
						occur++;
					} while (!ErrCode && occur < 1000);
					
	    		}// if (SectionMask ...)
			}// for (... i<=SEC_SR ...)
		}// if (FileNameLen)
    else    //parse file
    	{
		UBYTE4	i=0;
		FILE	*fin;
		SBYTE2	ilcnum=0;
		int	RstrCount = 0;		/*number of items restored */
		char	LocalString[256];
		char srnr[3];

		strncpy (LocalString, FileName, FileNameLen);
		LocalString[FileNameLen] = '\0';
		fin = fopen (LocalString, "r");
		if (fin != NULL)
			{		/* continue if file is readable */
			while ( fgets (LocalString, 200, fin) != NULL)
				{
					/* do til error or file end */
				ParseString(LocalString, disp_name, chan_type, dev_type , string_value);

				if (memcmp ("AC", chan_type, 2)==0)
					{
			    	switch (disp_name[0])
			    		{
						case 'E':
				    		i = SEC_EG;
				    		break;
						case 'G':
				    		i = SEC_GTL;
				    		break;
						case 'L':
				    		if (disp_name[1] == 'N')
								i = SEC_LN;
				    		else
								{
								if (SectionMask & (1L << SEC_LTB_INC_BS))
					    			i = SEC_LTB_INC_BS;
								else if (SectionMask & (1L << SEC_AFTER_BS_INC_FC))
					    			i = SEC_AFTER_BS_INC_FC;
								else
					    			i = SEC_AFTER_BS_EXC_BR;
								}
				    		break;
						case 'B':
				    		if (disp_name[1] == 'R')
				    			{
				    			i = SEC_BR;
								break;
								}
				    		else
								i = SEC_BTS;
				    		break;
						case 'S':
							memcpy(srnr,&disp_name[2],2);
							srnr[2]='\0';
							i = atoi(srnr)+SEC_BTS;
				    		//i = SEC_SR;
				    		break;
						}//end switch (dispname )

			    	if ( SectionMask & (1L<<i) )
			    		if ( i == SEC_EG ) // || i == SEC_BR )	//No devices to cycle
			    			continue;
			    		else
							{
							_fstrcpy (DVBuffer, disp_name);
			   				//	_fstrcat (DVBuffer, chan_type);
							_fstrcat (DVBuffer, "DV*MPS");
                            occur = 1;
							SetupTablesPart2 (ErrCode, DVBuffer, SectionMask, SingleCycFlag, string_value, occur);
							}

					}//if memcmp (AC...)
				} //end while
			fclose (fin);
	    	}//end if (NULL...)
		else
	    	*ErrCode = ERR_BADFILE;
	}  
	if (*ErrCode == EFINDNAME)
		*ErrCode = ERR_OK;
}


void near pascal 
SetupTablesPart2 (UBYTE2 *ErrCode, char far *OutBuffer, UBYTE4 SectionMask, UBYTE2 SingleCycFlag, 
					char *string_value, UBYTE2 occurence)
{
    UBYTE4 DVIndex;
    UBYTE4 ACIndex;
    SBYTE1 FullName[DB_FULLNAMELEN+1], ACFullName[DB_FULLNAMELEN+1], RstFullName[DB_FULLNAMELEN+1];
    UBYTE2 FullNameLen=DB_FULLNAMELEN;
    UBYTE2 First = 1;
    UBYTE2 Occur;
    int    Section; // its safe to have a 2 byte section mask for GetBeamlineSection
    int    fOkSoFar;
    float	RestoreVal;
    
    Occur = occurence;

	fOkSoFar = FALSE;
	TargetNameLen = _fstrlen(OutBuffer);
	FindName( ErrCode, OutBuffer, &TargetNameLen, &DVIndex, FullName, &FullNameLen, &Occur );

    if (*ErrCode == EFINDNAME)	//Name not found in database
       	{
	    sprintf(ErrBuf, "%s: FindName failed\r\n", OutBuffer);
	    fprintf(fhErr, ErrBuf);
       	return;
       	}

	else if (*ErrCode != 0)
	    {
		sprintf(ErrBuf, "%s error = %d\r\n", OutBuffer,*ErrCode);
		fprintf(fhErr, ErrBuf);
	    }
	else		//ErrCode == 0
	    {
	    Occur++;

	    if (_fstrncmp(OutBuffer, "LTB", 3) == 0)
			{
			GetBeamLineSection ((int *)ErrCode, &DVIndex, &Section);
			if (*ErrCode)
				*ErrCode = ERR_BEAMLINESEC;
			else
		    	{
		    	switch (Section)
					{
					case BLS_LTB_INC_BS:
			    		if (SectionMask & 1<<SEC_LTB_INC_BS)
							fOkSoFar = TRUE;
			    		break;
					case BLS_AFTER_BS_INC_FC:
			    		if (SectionMask & 1<<SEC_AFTER_BS_INC_FC)
							fOkSoFar = FALSE;
			    		break;
					case BLS_AFTER_BS_INC_TV3:
					case BLS_AFTER_TV3_EXC_BR:
			    		if (SectionMask & 1<<SEC_AFTER_BS_EXC_BR)
							fOkSoFar = TRUE;
			    		break;
					default:
			    		*ErrCode = ERR_BEAMLINESEC;
			    		break;
					}
		    	}
			}
	    else
			fOkSoFar = TRUE;

	    if (fOkSoFar)
			{
			BOOL	fIronDominated;
			BOOL	Include;
			UBYTE4  RstIndex;

			MCFilterMagnet (ErrCode, FullName, &fIronDominated, &Include);
			if (Include)
				{
		    	FullName[15] = 'A'; //look for AC channel
		    	FullName[16] = 'C';
		    	FullName[17] = '\0';
		    	TargetNameLen = _fstrlen(FullName);
				FindName( ErrCode, FullName, &TargetNameLen, &ACIndex, ACFullName, &FullNameLen, &First );

	 		    if (*ErrCode == 0)
					{
					if (SingleCycFlag)	//Get current value. Restore to MULT*value after cycling.
						GetSP ( ErrCode, &ACIndex, &RestoreVal );
					else
						RestoreVal = (float)atof (string_value);

		    		FullName[13] = 'R';  // look for PS reset channel
		    		FullName[15] = 'B';
		    		FullName[16] = 'C';
		    		FullName[17] = '\0';
		    		TargetNameLen = _fstrlen(FullName);
					FindName( ErrCode, FullName, &TargetNameLen, &RstIndex, RstFullName, &FullNameLen, &First );
                    if (*ErrCode != 0)
                    	RstIndex =0;
                    	
					//Put the found magnet in its respective group
					SetupGroups (ACFullName, SectionMask, ACIndex, DVIndex, RstIndex, RestoreVal, fIronDominated);

			        //Set up the single cycling restore value
	    			if (SingleCycFlag == PARTIAL_RESTORE)
	    				SetSingleCycVal (ACIndex);
	    				
					}
		    	else  
		    		{
					*ErrCode = 0;
		    		}
		    }
	    }// end if fOkSoFar
	}// else error code == 0
}

void far pascal _export
MCIronDominatedMagnet (UBYTE2 _far *ErrCode, char _far *Name, BOOL _far *fIronDominated)
{

	BOOL	bogus;

	MCFilterMagnet (ErrCode, Name, fIronDominated, &bogus);
}	

void
MCFilterMagnet (UBYTE2 _far *ErrCode, char _far *Name, BOOL _far *fIronDominated, BOOL _far *Pass)
{
    /* Cycle only iron-dominated magnets, not in the booster ring.
       Returns TRUE if this is an iron-dominated magnet.
    */
    BOOL    retval = FALSE;
    BOOL	passbool = FALSE;
/*
	if (_fstrncmp (Name, "BR", 2) == 0)		// reject BR devices since they are pulsed
		{
		retval = FALSE;
		return;
		}
*/
    switch (*(Name+8))
		{
		case 'B':		//Bending Magnet
			switch (*(Name))
				{
				case 'L':		//LTB line
					switch (*(Name+9))
		    			{
		    			case '1':	// LTB bend magnet
							if (_fstrncmp ((Name+11), " ", 1) == 0)		// reject SHNT
								retval = TRUE;
							break;
		    			case '2':	// LTB bend magnet
		    			case '3':	// LTB bend magnet
							retval = TRUE;
							break;
		    			default:
							retval = FALSE;
							break;
		    			}
		    		break;
		    	case 'G':	// GTL BC magnet       // Don't Cycle, but include in magnet group
					switch (*(Name+9))
		    			{
		    			case 'C':	// LTB bend magnet
							retval = FALSE;
							passbool = TRUE;
							break;
						default:
							retval = FALSE;
							break;
		    			}
		    		break;
				case 'B':		//BTS line
					if (_fstrncmp ((Name+11), "RS", 2) == 0)		// reject RS
						break;
					else
						retval = TRUE;
					break;
				case 'S':		//SR
					if (_fstrncmp ((Name+8), "B     ", 6) == 0)		// select B PS only
						retval = TRUE;
					break;
				}
			break;
		case 'H':	//Horz Corr
	    	if (_fstrncmp (Name, "SR", 2) == 0)   //storage ring
	    		{
	    		if (_fstrncmp ((Name+9), "CM", 2) == 0 && Name[13] == ' ') {  //SR horz corr
	    			retval = FALSE; // changed
	    			passbool = TRUE;
	    			if (_fstrncmp (Name, "BR", 2) == 0) {
	    				passbool = TRUE;
	    				retval = FALSE;
	    			}
	    		}
	    		}
	    		else if (_fstrncmp ((Name+9), "CS", 2) == 0 && Name[13] == ' ') {  //SR sext horz corr
	    			retval = FALSE;  // changed
	    			passbool = TRUE;
	    		break;
	    		}
	    	else if (_fstrncmp ((Name+9), "C", 1) == 0)	//GTL, LN, LTB, or BTS horz corr
				retval = TRUE;
	    	break;
		case 'V':	//Vert Corr
	    	if (_fstrncmp (Name, "SR", 2) == 0)   //storage ring
	    		{
	    		if (_fstrncmp ((Name+9), "CM", 2) == 0 && Name[13] == ' ') {  //SR vert corr
	    			retval = FALSE;   // changed
	    			passbool = TRUE;
	    			if (_fstrncmp (Name, "BR", 2) == 0) {
	    				passbool = TRUE;
	    				retval = FALSE;
	    			}
	    		}
	    		}
	    		else if (_fstrncmp ((Name+9), "CS", 2) == 0 && Name[13] == ' ') {  //SR sext vert corr
	    			retval = FALSE;  // changed
	    			passbool = TRUE;
	    		break;
	    		}
	    	else if (_fstrncmp ((Name+9), "C", 1) == 0)	//GTL, LN, LTB, or BTS vert corr
				retval = TRUE;
	    	break;
		case 'Q':	//Quadrupole
	    	if (_fstrncmp (Name, "SR", 2) == 0 && _fstrncmp ((Name+11), "   ", 3) != 0)   //reject SR Q's non AC devices
	    		break;
	    	else if (_fstrncmp ((Name+11), "R", 1) == 0)	//reject BTS Q1 RS
				break;
	    	else if (_fstrncmp ((Name+12), "R", 1) == 0)	//reject BTS Qx.1RS
				break;
	    	else
				retval = TRUE;
	    	break;
		case 'S':	//Sextupole
	      	switch (*(Name+9))
				{
				case 'O': //solenoid            // return FALSE, but flag that we want to include in MAGNET group.
		    		retval = FALSE;
		    		passbool = TRUE;
		    		break;
				case 'D': //defocusing sextupole
					if (_fstrncmp ((Name+8), "SD    ", 6) == 0)	//select SD only
		    			retval = TRUE;
		    		break;
				case 'F': //focusing sextupole
					if (_fstrncmp ((Name+8), "SF    ", 6) == 0)	//select SF only
		    			retval = TRUE;
		    		break;
				default:
		    		retval = FALSE;
		    		break;
				}
	    	break;
		default:	// reject all other devices
	    	retval = FALSE;
	    	break;
		}

    *fIronDominated = retval;
    *Pass = (retval || passbool);
    *ErrCode = ERR_OK;
	}

 



void near pascal 
SetupGroups (char *Name, UBYTE4 SectionMask, UBYTE4 ACIndex, UBYTE4 DVIndex, UBYTE4 RstIndex, float RestoreVal, BOOL ironflag)
{
// Function sorts Name and ACIndex into its appropriate group.
// Mag Type struct elements are filled only for correctors.

	//int i, j, k;
    char SrSectorStr[3];
    UBYTE4 SrSectorMask;
    
	switch (*(Name))
		{
		case 'E':	//EG
			break;
		case 'G': 	//GTL
			if (Name[8] == 'H' || Name[8] == 'V' || (Name[8] == 'S' && Name[9] == 'O') || (Name[8] == 'B' && Name[9] == 'C'))	//GTL trims, BC, and solenoids
				{
				if (ironflag) {
					MagGroup5[grp5cntr].MagName = "GTL H(V)";
					MagGroup5[grp5cntr].MagType = G5_TYPE_GTL_LN_TRM;
					MagGroup5[grp5cntr].TrimType = L_HVC_MAGS;
					MagGroup5[grp5cntr].IncrementVal = GTL_LNTrimCurrStep;
					MagGroup5[grp5cntr].RestoreVal = RestoreVal;
					MagGroup5[grp5cntr].SectionMask = SEC_GTL;
					MagGroup5[grp5cntr].MagnetACIndexILC = ACIndex;
					MagGroup5[grp5cntr++].MagnetDVIndexILC = DVIndex;
				}
				else {				
					MagGroup7[grp7cntr].MagName = "GTL(LN) SOL(BC)";
					MagGroup7[grp7cntr].MagType = G6_TYPE_GTL_SOL_BC;
					MagGroup7[grp7cntr].TrimType = 0;//L_HVC_MAGS;
					MagGroup7[grp7cntr].IncrementVal = 0;//GTL_LNTrimCurrStep;
					MagGroup7[grp7cntr].RestoreVal = RestoreVal;
					MagGroup7[grp7cntr].SectionMask = SEC_GTL;
					MagGroup7[grp7cntr].MagnetACIndexILC = ACIndex;
					MagGroup7[grp7cntr++].MagnetDVIndexILC = DVIndex;
				}
/*				if (!ironflag)
					MagGroup5[grp5cntr].CycleFlag = 0;
				
				MagGroup5[grp5cntr++].MagnetDVIndexILC = DVIndex;
*/				}
			break;
		case 'L':	//LN and LTB
			switch (*(Name+1))
				{
				case 'N':	//LN
					switch (*(Name+8))
						{
						case 'H':
						case 'V':					//LN trims
							MagGroup5[grp5cntr].MagName = "LN H(V)";
							MagGroup5[grp5cntr].MagType = G5_TYPE_GTL_LN_TRM;
							MagGroup5[grp5cntr].TrimType = L_HVC_MAGS;
							MagGroup5[grp5cntr].IncrementVal = GTL_LNTrimCurrStep;
							MagGroup5[grp5cntr].RestoreVal = RestoreVal;
							MagGroup5[grp5cntr].SectionMask = SEC_LN;
							MagGroup5[grp5cntr].MagnetACIndexILC = ACIndex;
				
							MagGroup5[grp5cntr++].MagnetDVIndexILC = DVIndex;
							break;
						case 'Q':                   //LN quads
							MagGroup5[grp5cntr].MagName = "LN Q";
							MagGroup5[grp5cntr].MagType = G5_TYPE_LN_Q_LTB_BTS_TRM;
							MagGroup5[grp5cntr].IncrementVal = LNQ_LTB_BTSTrimCurrStep;
							MagGroup5[grp5cntr].RestoreVal = RestoreVal;
							MagGroup5[grp5cntr].SectionMask = SEC_LN;
							MagGroup5[grp5cntr].MagnetACIndexILC = ACIndex;
							MagGroup5[grp5cntr++].MagnetDVIndexILC = DVIndex;
							break;
						case 'S':
							if (!(*(Name+11) == 'I')) {                 //LN solenoids
								MagGroup7[grp7cntr].MagName = "LN SOL";
								MagGroup7[grp7cntr].MagType = G6_TYPE_LN_SOL;
								MagGroup7[grp7cntr].IncrementVal = 0;//LNQ_LTB_BTSTrimCurrStep;
								MagGroup7[grp7cntr].RestoreVal = RestoreVal;
								MagGroup7[grp7cntr].SectionMask = SEC_LN;
							//	MagGroup7[grp7cntr].CycleFlag = 0;
								MagGroup7[grp7cntr].MagnetACIndexILC = ACIndex;
								MagGroup7[grp7cntr++].MagnetDVIndexILC = DVIndex;
								break;
							}
						}
					break;
				case 'T':	//LTB
					switch (*(Name+8))
						{
						case 'H':
						case 'V':					//LTB trims
							MagGroup5[grp5cntr].MagName = "LTB H(V)";
							MagGroup5[grp5cntr].TrimType = L_HVC_MAGS;
							MagGroup5[grp5cntr].MagType = G5_TYPE_LN_Q_LTB_BTS_TRM;
							MagGroup5[grp5cntr].IncrementVal = LNQ_LTB_BTSTrimCurrStep;
							MagGroup5[grp5cntr].RestoreVal = RestoreVal;
							if (SectionMask & 1L<<SEC_LTB_INC_BS)
								MagGroup5[grp5cntr].SectionMask = SEC_LTB_INC_BS;
							else
								MagGroup5[grp5cntr].SectionMask = SEC_AFTER_BS_EXC_BR;
							MagGroup5[grp5cntr].MagnetACIndexILC = ACIndex;
							MagGroup5[grp5cntr++].MagnetDVIndexILC = DVIndex;
							break;
						case 'Q':                   //LTB quads
							MagGroup5[grp5cntr].MagName = "LTB Q";
							MagGroup5[grp5cntr].MagType = G5_TYPE_LTB_Q;
							MagGroup5[grp5cntr].IncrementVal = LTBQuadCurrStep;
							MagGroup5[grp5cntr].RestoreVal = RestoreVal;
							if (SectionMask & 1L<<SEC_LTB_INC_BS)
								MagGroup5[grp5cntr].SectionMask = SEC_LTB_INC_BS;
							else
								MagGroup5[grp5cntr].SectionMask = SEC_AFTER_BS_EXC_BR;
							MagGroup5[grp5cntr].MagnetACIndexILC = ACIndex;
							MagGroup5[grp5cntr++].MagnetDVIndexILC = DVIndex;
							break;
						case 'B':                   //LTB bends
							switch(*(Name+9))
								{
								case '1':
								case '2':         	//B1 & B2
									if (_fstrncmp ((Name+11), "SHNT", 4) == 0) //reject B1 shunt
										break;
									else
										{
										MagGroup2[grp2cntr].MagName = "LTB B1(2)";
										MagGroup2[grp2cntr].MagType = G2_TYPE_LTB_B1_B2;
										MagGroup2[grp2cntr].IncrementVal = LTBB1B2CurrStep;
										MagGroup2[grp2cntr].RestoreVal = RestoreVal;
										MagGroup2[grp2cntr].SectionMask = SEC_AFTER_BS_EXC_BR;
										MagGroup2[grp2cntr].MagnetACIndexILC = ACIndex;
										MagGroup2[grp2cntr++].MagnetDVIndexILC = DVIndex;
										}
									break;
								case '3':        	//B3
									MagGroup5[grp5cntr].MagName = "LTB B3";
									MagGroup5[grp5cntr].MagType = G5_TYPE_LTB_B3;
									MagGroup5[grp5cntr].IncrementVal = LTBB3CurrStep;
									MagGroup5[grp5cntr].RestoreVal = RestoreVal;
									MagGroup5[grp5cntr].SectionMask = SEC_AFTER_BS_EXC_BR;
									MagGroup5[grp5cntr].MagnetACIndexILC = ACIndex;
									MagGroup5[grp5cntr++].MagnetDVIndexILC = DVIndex;
									break;
								}
							break;
						}//end case T
					break;
				}//end case LN and LTB switch
			break;

		case 'B':	//BR and BTS
			switch(*(Name+1))
				{
				case 'R':
					switch(*(Name+8))
						{
						case 'H':
						case 'V':                   //BR trims
						MagGroup7[grp7cntr].MagName = "BR H(V)";
						MagGroup7[grp7cntr].MagType = 0;
						MagGroup7[grp7cntr].TrimType = 0;//L_HVC_MAGS;
						MagGroup7[grp7cntr].IncrementVal = 0;//GTL_LNTrimCurrStep;
						MagGroup7[grp7cntr].RestoreVal = RestoreVal;
						MagGroup7[grp7cntr].SectionMask = SEC_BR;
						MagGroup7[grp7cntr].MagnetACIndexILC = ACIndex;
						MagGroup7[grp7cntr++].MagnetDVIndexILC = DVIndex;
						break;
						}
					break;
				case 'T':							//BTS
					switch(*(Name+8))
						{
						case 'H':
						case 'V':                   //BTS trims
							MagGroup5[grp5cntr].MagName = "BTS H(V)";
							MagGroup5[grp5cntr].MagType = G5_TYPE_LN_Q_LTB_BTS_TRM;
							MagGroup5[grp5cntr].TrimType = BTS_HVC_MAGNET;
							MagGroup5[grp5cntr].IncrementVal = LNQ_LTB_BTSTrimCurrStep;
							MagGroup5[grp5cntr].RestoreVal = RestoreVal;
							MagGroup5[grp5cntr].SectionMask = SEC_BTS;
							MagGroup5[grp5cntr].MagnetACIndexILC = ACIndex;
							MagGroup5[grp5cntr].MagnetRstIndexILC = RstIndex;
							MagGroup5[grp5cntr++].MagnetDVIndexILC = DVIndex;
							break;
						case 'Q':                   //BTS quads
							if (_fstrncmp((Name+9), "2.2", 3) == 0 ||
								_fstrncmp((Name+9), "3.1", 3) == 0    )		//BTS small quads
								{
								MagGroup4[grp4cntr].MagName = "BTS Q2.2(3.1)";
								MagGroup4[grp4cntr].MagType = G4_TYPE_BTS_SMLQ;
								MagGroup4[grp4cntr].IncrementVal = BTSSQCurrStep;
								MagGroup4[grp4cntr].RestoreVal = RestoreVal;
								MagGroup4[grp4cntr].SectionMask = SEC_BTS;
								MagGroup4[grp4cntr].MagnetACIndexILC = ACIndex;
								MagGroup4[grp4cntr].MagnetRstIndexILC = RstIndex;
								MagGroup4[grp4cntr++].MagnetDVIndexILC = DVIndex;
								}
							else
								{										//BTS big quads
								MagGroup3[grp3cntr].MagName = "BTS Q";
								MagGroup3[grp3cntr].MagType = G3_TYPE_BTS_BIGQ;
								MagGroup3[grp3cntr].IncrementVal = BTSBQCurrStep;
								MagGroup3[grp3cntr].RestoreVal = RestoreVal;
								MagGroup3[grp3cntr].SectionMask = SEC_BTS;
								MagGroup3[grp3cntr].MagnetACIndexILC = ACIndex;
								MagGroup3[grp3cntr].MagnetRstIndexILC = RstIndex;
								MagGroup3[grp3cntr++].MagnetDVIndexILC = DVIndex;
								}
							break;
						case 'B':                   //BTS bends
							if (*(Name+13) == 'R')		//reject reset
								break;
							else
								{
								MagGroup1[grp1cntr].MagName = "BTS B";
								MagGroup1[grp1cntr].MagType = G1_TYPE_BTS_B;
								MagGroup1[grp1cntr].IncrementVal = BTSBCurrStep;
								MagGroup1[grp1cntr].RestoreVal = RestoreVal;
								MagGroup1[grp1cntr].SectionMask = SEC_BTS;
								MagGroup1[grp1cntr].MagnetACIndexILC = ACIndex;
								MagGroup1[grp1cntr].MagnetRstIndexILC = RstIndex;
								MagGroup1[grp1cntr++].MagnetDVIndexILC = DVIndex;
								}
						break;
						}//end BTS switch
					break;
				}//end BR and BTS switch
			break;

		case 'S':	//SR
			SrSectorStr[2] = '\0';
			memcpy(SrSectorStr, Name+2, 2);
			SrSectorMask = (UBYTE4)atoi(SrSectorStr) + SEC_BTS;

			switch(*(Name+8))
				{
				case 'H':
					switch(*(Name+10))
						{
						case 'M':									//SR HCM       was 4
							MagGroup6[grp6cntr].MagName = "SR HCM";
							MagGroup6[grp6cntr].MagType = G4_TYPE_SR_HCM;
							MagGroup6[grp6cntr].TrimType = SR_HCM_MAGNET;
							MagGroup6[grp6cntr].IncrementVal = SRHCMCurrStep;
							MagGroup6[grp6cntr].RestoreVal = RestoreVal;
							MagGroup6[grp6cntr].SectionMask = SrSectorMask;
							MagGroup6[grp6cntr].MagnetACIndexILC = ACIndex;
							MagGroup6[grp6cntr].MagnetRstIndexILC = RstIndex;
						//	MagGroup6[grp6cntr].CycleFlag = 0;
							MagGroup6[grp6cntr++].MagnetDVIndexILC = DVIndex;
			                break;
						case 'S':                                   //SR HCSD & HCSF
							if (Name[11] == 'D')
								{
								MagGroup6[grp6cntr].MagName = "SR HCSD";
								MagGroup6[grp6cntr].MagType = G4_TYPE_SR_HCS_VCS;
								MagGroup6[grp6cntr].TrimType = SR_HCS_MAGNET;
								MagGroup6[grp6cntr].IncrementVal = SRHVCSCurrStep;
								MagGroup6[grp6cntr].RestoreVal = RestoreVal;
								MagGroup6[grp6cntr].SectionMask = SrSectorMask;
								MagGroup6[grp6cntr].MagnetACIndexILC = ACIndex;
								MagGroup6[grp6cntr].MagnetRstIndexILC = RstIndex;
						//		MagGroup6[grp6cntr].CycleFlag = 0;
								MagGroup6[grp6cntr++].MagnetDVIndexILC = DVIndex;
								break;
								}
							else if (Name[11] == 'F')
								{
								MagGroup6[grp6cntr].MagName = "SR HCSD";
								MagGroup6[grp6cntr].MagType = G4_TYPE_SR_HCS_VCS;
								MagGroup6[grp6cntr].TrimType = SR_HCS_MAGNET;
								MagGroup6[grp6cntr].IncrementVal = SRHVCSCurrStep;
								MagGroup6[grp6cntr].RestoreVal = RestoreVal;
								MagGroup6[grp6cntr].SectionMask = SrSectorMask;
								MagGroup6[grp6cntr].MagnetRstIndexILC = RstIndex;
								MagGroup6[grp6cntr].MagnetACIndexILC = ACIndex;
						//		MagGroup6[grp6cntr].CycleFlag = 0;
								MagGroup6[grp6cntr++].MagnetDVIndexILC = DVIndex;
								break;
								}
			    		}
			    	break;
				case 'V':
					switch(*(Name+10))
						{
						case 'M':									//SR VCM         was 3
							MagGroup6[grp6cntr].MagName = "SR VCM";
							MagGroup6[grp6cntr].MagType = G3_TYPE_SR_VCM;
							MagGroup6[grp6cntr].TrimType = SR_VCM_MAGNET;
							MagGroup6[grp6cntr].IncrementVal = SRVCMCurrStep;
							MagGroup6[grp6cntr].RestoreVal = RestoreVal;
							MagGroup6[grp6cntr].SectionMask = SrSectorMask;
							MagGroup6[grp6cntr].MagnetACIndexILC = ACIndex;
						//	MagGroup6[grp6cntr].CycleFlag = 0;
							MagGroup6[grp6cntr].MagnetRstIndexILC = RstIndex;
							MagGroup6[grp6cntr++].MagnetDVIndexILC = DVIndex;
			                break;
						case 'S':                                   //SR VCSF
							if (Name[11] == 'F')
								{      
								MagGroup6[grp6cntr].MagName = "SR VCSF";              // was 4
								MagGroup6[grp6cntr].MagType = G4_TYPE_SR_HCS_VCS;
								MagGroup6[grp6cntr].TrimType = SR_VCS_MAGNET;
								MagGroup6[grp6cntr].IncrementVal = SRHVCSCurrStep;
								MagGroup6[grp6cntr].RestoreVal = RestoreVal;
								MagGroup6[grp6cntr].SectionMask = SrSectorMask;
								MagGroup6[grp6cntr].MagnetACIndexILC = ACIndex;
						//		MagGroup6[grp6cntr].CycleFlag = 0;
								MagGroup6[grp6cntr++].MagnetDVIndexILC = DVIndex;
								}
							break;
			    		}
			    	break;
				case 'Q':
					switch(*(Name+9))
						{
						case 'D':									//SR QDx
							MagGroup3[grp3cntr].MagName = "SR QD";
							MagGroup3[grp3cntr].MagType = G3_TYPE_SR_QD_QF;
							MagGroup3[grp3cntr].IncrementVal = SRQCurrStep;
							MagGroup3[grp3cntr].RestoreVal = RestoreVal;
							MagGroup3[grp3cntr].SectionMask = SrSectorMask;
							MagGroup3[grp3cntr].MagnetACIndexILC = ACIndex;
							MagGroup3[grp3cntr].MagnetRstIndexILC = RstIndex;
							MagGroup3[grp3cntr++].MagnetDVIndexILC = DVIndex;
			                break;
						case 'F':
							if (Name[11] == 'A')				//SR QFA
								{
								MagGroup2[grp2cntr].MagName = "SR QFA";
								MagGroup2[grp2cntr].MagType = G2_TYPE_SR_QFA;
								MagGroup2[grp2cntr].IncrementVal = SRQFACurrStep;
								MagGroup2[grp2cntr].RestoreVal = RestoreVal;
								MagGroup2[grp2cntr].SectionMask = SrSectorMask;
								MagGroup2[grp2cntr].MagnetACIndexILC = ACIndex;
								MagGroup2[grp2cntr].MagnetRstIndexILC = RstIndex;
								MagGroup2[grp2cntr++].MagnetDVIndexILC = DVIndex;
								}
			                else
			                	{									//SR QFx
								MagGroup3[grp3cntr].MagName = "SR QF";
								MagGroup3[grp3cntr].MagType = G3_TYPE_SR_QD_QF;
								MagGroup3[grp3cntr].IncrementVal = SRQCurrStep;
								MagGroup3[grp3cntr].RestoreVal = RestoreVal;
								MagGroup3[grp3cntr].SectionMask = SrSectorMask;
								MagGroup3[grp3cntr].MagnetACIndexILC = ACIndex;
								MagGroup3[grp3cntr].MagnetRstIndexILC = RstIndex;
								MagGroup3[grp3cntr++].MagnetDVIndexILC = DVIndex;
								}
							break;
			    		}
			    	break;
				case 'S':											//SR SD & SF
					MagGroup2[grp2cntr].MagName = "SR SD(F)";
					MagGroup2[grp2cntr].MagType = G2_TYPE_SR_SD_SF;
					MagGroup2[grp2cntr].IncrementVal = SRSCurrStep;
					MagGroup2[grp2cntr].RestoreVal = RestoreVal;
					MagGroup2[grp2cntr].SectionMask = SrSectorMask;
					MagGroup2[grp2cntr].MagnetACIndexILC = ACIndex;
					MagGroup2[grp2cntr].MagnetRstIndexILC = RstIndex;
					MagGroup2[grp2cntr++].MagnetDVIndexILC = DVIndex;
			    	break;
				case 'B':											//SR Gradient
					MagGroup1[grp1cntr].MagName = "SR B";
					MagGroup1[grp1cntr].MagType = G1_TYPE_SR_B;
					MagGroup1[grp1cntr].IncrementVal = SRBCurrStep;
					MagGroup1[grp1cntr].RestoreVal = RestoreVal;
					MagGroup1[grp1cntr].SectionMask = SrSectorMask;
					MagGroup1[grp1cntr].MagnetACIndexILC = ACIndex;
					MagGroup1[grp1cntr].MagnetRstIndexILC = RstIndex;
					MagGroup1[grp1cntr++].MagnetDVIndexILC = DVIndex;
			    	break;
			    }//end of SR switch
			break;
		default:
			break;
		}//end of main switch

}

void near pascal SetSingleCycVal (UBYTE4 ACIndex)
{
    //	Set the RestoreValMultiplier for the magnet (by group for now)

    int	g1, g2, g3, g4, g5;
    float mult;

	for(g5=0; g5 < grp5cntr; g5++)
		if ( MagGroup5[g5].MagnetACIndexILC == ACIndex )
			switch (MagGroup5[g5].MagType)
			{
			case G5_TYPE_LTB_B3:
			case G5_TYPE_LTB_Q:
			case G5_TYPE_LN_Q_LTB_BTS_TRM:
			case G5_TYPE_GTL_LN_TRM:
				mult = (float)G5_SNGL_CYC_MULT;
				if( MagGroup5[g5].RestoreVal < (float)0)
					mult = 2 - mult;					
				MagGroup5[g5].RestoreVal *= mult;
				return;
			}

	for(g4=0; g4 < grp4cntr; g4++)
		if ( MagGroup4[g4].MagnetACIndexILC == ACIndex )
			switch (MagGroup4[g4].MagType)
			{
			case G4_TYPE_BTS_SMLQ:
			case G4_TYPE_SR_HCM:
			case G4_TYPE_SR_HCS_VCS:
			case G4_TYPE_SR_SQS:
				mult = (float)G4_SNGL_CYC_MULT;
				if( MagGroup4[g4].RestoreVal < (float)0)
					mult = 2 - mult;					
				MagGroup4[g4].RestoreVal *= mult;
				return;
			}
                                                           
	for(g3=0; g3 < grp3cntr; g3++)
		if ( MagGroup3[g3].MagnetACIndexILC = ACIndex )
			switch (MagGroup3[g3].MagType)
			{
			case G3_TYPE_SR_QD_QF:
			case G3_TYPE_BTS_BIGQ:
			case G3_TYPE_SR_VCM:
				mult = (float)G3_SNGL_CYC_MULT;
				if( MagGroup3[g3].RestoreVal < (float)0)
					mult = 2 - mult;					
				MagGroup3[g3].RestoreVal *= mult;
				return;
			}

	for(g2=0; g2 < grp2cntr; g2++)
		if ( MagGroup2[g2].MagnetACIndexILC == ACIndex )
			switch (MagGroup2[g2].MagType)
			{
			case G2_TYPE_SR_QFA:
			case G2_TYPE_SR_SD_SF:
			case G2_TYPE_LTB_B1_B2:
				mult = (float)G2_SNGL_CYC_MULT;
				if( MagGroup2[g2].RestoreVal < (float)0)
					mult = 2 - mult;					
				MagGroup2[g2].RestoreVal *= mult;
				return;
			}

	for(g1=0; g1 < grp1cntr; g1++)
		if ( MagGroup1[g1].MagnetACIndexILC == ACIndex )
			switch (MagGroup1[g1].MagType)
			{
			case G5_TYPE_LTB_B3:
			case G5_TYPE_LTB_Q:
			case G5_TYPE_LN_Q_LTB_BTS_TRM:
			case G5_TYPE_GTL_LN_TRM:
				mult = (float)G1_SNGL_CYC_MULT;
				if( MagGroup1[g1].RestoreVal < (float)0)
					mult = 2 - mult;					
				MagGroup1[g1].RestoreVal *= mult;
				return;
			}

}


void near pascal RampMag (UBYTE2 *ErrCode, SBYTE1 RampFlag, UBYTE4 SectionMask, REAL4 GroupLimits[GROUP_NUM][4])
{
    //	For each magnet PS, continuously increment (or decrement) the AC value
    //	until the endpoint of the particular ramp state is reached.
    //	Assume magnets are already turned on.

    int	g1, g2, g3, g4, g5, g6, g7;
    UBYTE2 TmpErr;
    REAL4	FSvalue, ACUpperLim, dummy;
    
    TmpErr = ERR_OK;
    
    
	//set all magnets to their upper limits: handles RampState=1.
	for(g1=0; g1 < grp1cntr; g1++)
	  if (SectionMask & 1L<<MagGroup1[g1].SectionMask && GroupMask & GROUP_1)
		if ( MagGroup1[g1].CycleFlag && MagGroup1[g1].CycleLevel[CYCLE] == SET_UPPERLIM_STATE )  { 
			GetACLims( &MagGroup1[g1].ErrCode, &MagGroup1[g1].MagnetACIndexILC, &ACUpperLim, &dummy, &FSvalue );
			SetSP ( &MagGroup1[g1].ErrCode, &MagGroup1[g1].MagnetDVIndexILC, &ACUpperLim);
            MagGroup1[g1].CycleLevel[CYCLE] == WAIT_UPPERLIM_STATE;
		}
	for(g2=0; g2 < grp2cntr; g2++)
	  if (SectionMask & 1L<<MagGroup2[g2].SectionMask && GroupMask & GROUP_2)
		if ( MagGroup2[g2].CycleFlag && MagGroup2[g2].CycleLevel[CYCLE] == SET_UPPERLIM_STATE )  { 
			GetACLims( &MagGroup2[g2].ErrCode, &MagGroup2[g2].MagnetACIndexILC, &ACUpperLim, &dummy, &FSvalue );
			SetSP ( &MagGroup2[g2].ErrCode, &MagGroup2[g2].MagnetDVIndexILC, &ACUpperLim);
            MagGroup2[g2].CycleLevel[CYCLE] == WAIT_UPPERLIM_STATE;
		}
	for(g3=0; g3 < grp3cntr; g3++)
	  if (SectionMask & 1L<<MagGroup3[g3].SectionMask && GroupMask & GROUP_3)
		if ( MagGroup3[g3].CycleFlag && MagGroup3[g3].CycleLevel[CYCLE] == SET_UPPERLIM_STATE )  { 
			GetACLims( &MagGroup3[g3].ErrCode, &MagGroup3[g3].MagnetACIndexILC, &ACUpperLim, &dummy, &FSvalue );
			SetSP ( &MagGroup3[g3].ErrCode, &MagGroup3[g3].MagnetDVIndexILC, &ACUpperLim);
            MagGroup3[g3].CycleLevel[CYCLE] == WAIT_UPPERLIM_STATE;
		}
	for(g4=0; g4 < grp4cntr; g4++)
	  if (SectionMask & 1L<<MagGroup4[g4].SectionMask && GroupMask & GROUP_4)
		if ( MagGroup4[g4].CycleFlag && MagGroup4[g4].CycleLevel[CYCLE] == SET_UPPERLIM_STATE )  { 
			GetACLims( &MagGroup4[g4].ErrCode, &MagGroup4[g4].MagnetACIndexILC, &ACUpperLim, &dummy, &FSvalue );
			SetSP ( &MagGroup4[g4].ErrCode, &MagGroup4[g4].MagnetDVIndexILC, &ACUpperLim);
            MagGroup4[g4].CycleLevel[CYCLE] == WAIT_UPPERLIM_STATE;
		}
	for(g5=0; g5 < grp5cntr; g5++)
	  if (SectionMask & 1L<<MagGroup5[g5].SectionMask && GroupMask & GROUP_5)
		if ( MagGroup5[g5].CycleFlag && MagGroup5[g5].CycleLevel[CYCLE] == SET_UPPERLIM_STATE )  { 
			GetACLims( &MagGroup5[g5].ErrCode, &MagGroup5[g5].MagnetACIndexILC, &ACUpperLim, &dummy, &FSvalue );
			SetSP ( &MagGroup5[g5].ErrCode, &MagGroup5[g5].MagnetDVIndexILC, &ACUpperLim);
            MagGroup5[g5].CycleLevel[CYCLE] == WAIT_UPPERLIM_STATE;
		}
	for(g6=0; g6 < grp6cntr; g6++)
	  if (SectionMask & 1L<<MagGroup6[g6].SectionMask && GroupMask & GROUP_6)
		if ( MagGroup6[g6].CycleFlag && MagGroup6[g6].CycleLevel[CYCLE] == SET_UPPERLIM_STATE )  { 
			GetACLims( &MagGroup6[g6].ErrCode, &MagGroup6[g6].MagnetACIndexILC, &ACUpperLim, &dummy, &FSvalue );
			SetSP ( &MagGroup6[g6].ErrCode, &MagGroup6[g5].MagnetDVIndexILC, &ACUpperLim);
            MagGroup6[g6].CycleLevel[CYCLE] == WAIT_UPPERLIM_STATE;
		}
	for(g7=0; g7 < grp7cntr; g7++)
	  if (SectionMask & 1L<<MagGroup7[g7].SectionMask && GroupMask & GROUP_7)
		if ( MagGroup7[g7].CycleFlag && MagGroup7[g7].CycleLevel[CYCLE] == SET_UPPERLIM_STATE )  { 
			GetACLims( &MagGroup7[g7].ErrCode, &MagGroup7[g7].MagnetACIndexILC, &ACUpperLim, &dummy, &FSvalue );
			SetSP ( &MagGroup7[g7].ErrCode, &MagGroup7[g7].MagnetDVIndexILC, &ACUpperLim);
            MagGroup7[g7].CycleLevel[CYCLE] == WAIT_UPPERLIM_STATE;
		}
		
	//Now verify that all magnets have reached their upper limits
}

void near pascal RestoreMag (UBYTE2 *ErrCode, UBYTE4 SectionMask, UBYTE2 SingleCycFlag)
{
    //	For each magnet PS, restore the saved AC value
    //	using ramp profile for the particular magnet family.
    //	Groups 3, 4, & 5 search for negative trim setpoints so
    //	final value is approached with a negative ramp.
    //	Assume magnets are already turned on.
    //	Zero value will always have been set from previous state.

    int	g1, g2, g3, g4, g5, g6, g7;
    UBYTE2 TmpErr, linktime;

    TmpErr = ERR_OK;

    //set restore value
	linktime = 1; //10ms 

	for(g1=0; g1 < grp1cntr; g1++)
	  if (SectionMask & 1L<<MagGroup1[g1].SectionMask && GroupMask & GROUP_1)
		if ( !MagGroup1[g1].CycleFlag || MagGroup1[g1].CycleLevel[CYCLE] == SET_FINAL_STATE )  { 
			SetSP ( &MagGroup1[g1].ErrCode, &MagGroup1[g1].MagnetDVIndexILC, &MagGroup1[g1].RestoreVal);
			MagGroup1[g1].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			MagGroup1[g1].CycleFlag = TRUE;
		}
	for(g2=0; g2 < grp2cntr; g2++)
	  if (SectionMask & 1L<<MagGroup2[g2].SectionMask && GroupMask & GROUP_2)
		if ( !MagGroup2[g2].CycleFlag || MagGroup2[g2].CycleLevel[CYCLE] == SET_FINAL_STATE )  { 
			SetSP ( &MagGroup2[g2].ErrCode, &MagGroup2[g2].MagnetDVIndexILC, &MagGroup2[g2].RestoreVal);
			MagGroup2[g2].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			MagGroup2[g2].CycleFlag = TRUE;
		}
	for(g3=0; g3 < grp3cntr; g3++)
	  if (SectionMask & 1L<<MagGroup3[g3].SectionMask && GroupMask & GROUP_3)
		if ( !MagGroup3[g3].CycleFlag || MagGroup3[g3].CycleLevel[CYCLE] == SET_FINAL_STATE )  { 
			SetSP ( &MagGroup3[g3].ErrCode, &MagGroup3[g3].MagnetDVIndexILC, &MagGroup3[g3].RestoreVal);
			MagGroup3[g3].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			MagGroup3[g3].CycleFlag = TRUE;
		}
	for(g4=0; g4 < grp4cntr; g4++)
	  if (SectionMask & 1L<<MagGroup4[g4].SectionMask && GroupMask & GROUP_4)
		if ( !MagGroup4[g4].CycleFlag || MagGroup4[g4].CycleLevel[CYCLE] == SET_FINAL_STATE )  { 
			SetSP ( &MagGroup4[g4].ErrCode, &MagGroup4[g4].MagnetDVIndexILC, &MagGroup4[g4].RestoreVal);
			MagGroup4[g4].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			MagGroup4[g4].CycleFlag = TRUE;
		}
	for(g5=0; g5 < grp5cntr; g5++)
	  if (SectionMask & 1L<<MagGroup5[g5].SectionMask && GroupMask & GROUP_5)
		if ( !MagGroup5[g5].CycleFlag || MagGroup5[g5].CycleLevel[CYCLE] == SET_FINAL_STATE )  { 
			SetSP ( &MagGroup5[g5].ErrCode, &MagGroup5[g5].MagnetDVIndexILC, &MagGroup5[g5].RestoreVal);
			MagGroup5[g5].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
            MagGroup5[g5].CycleFlag = TRUE;
		}
	for(g6=0; g6 < grp6cntr; g6++)
	  if (SectionMask & 1L<<MagGroup6[g6].SectionMask && GroupMask & GROUP_6)
		if ( !MagGroup6[g6].CycleFlag || MagGroup6[g6].CycleLevel[CYCLE] == SET_FINAL_STATE )  { 
			SetSP ( &MagGroup6[g6].ErrCode, &MagGroup6[g6].MagnetDVIndexILC, &MagGroup6[g6].RestoreVal);
			MagGroup6[g6].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			MagGroup6[g6].CycleFlag = TRUE;
		}
	for(g7=0; g7 < grp7cntr; g7++)
	  if (SectionMask & 1L<<MagGroup7[g7].SectionMask && GroupMask & GROUP_7)
		if ( !MagGroup7[g7].CycleFlag || MagGroup7[g7].CycleLevel[CYCLE] == SET_FINAL_STATE )  { 
			SetSP ( &MagGroup7[g7].ErrCode, &MagGroup7[g7].MagnetDVIndexILC, &MagGroup7[g7].RestoreVal);
			MagGroup7[g7].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			MagGroup7[g7].CycleFlag = TRUE;
		}
		
	*ErrCode = ERR_OK;
}

void WaitMagAMs(UBYTE2 *ErrCode, UBYTE4 SectionMask, UBYTE1 *CycleDone) { 

    int	g1, g2, g3, g4, g5, g6, g7;
    UBYTE2 TmpErr, linktime, gErr; 
    
	gErr = ERR_OK;
	linktime = 1; //10ms 
	for(g1=0; g1 < grp1cntr; g1++)
		if ( (SectionMask & 1L<<MagGroup1[g1].SectionMask && MagGroup1[g1].CycleLevel[CYCLE] != DONE_STATE) ) 
		  if ( GroupMask & GROUP_1 ) {
            *CycleDone = NO;
			fWaitAM ( &MagGroup1[g1] );
			TmpErr=MagGroup1[g1].ErrCode;
			if (TmpErr != OK_PASS && TmpErr != NOT_READY) {
				gErr = ERR_BADSTATE;
		    	sprintf(ErrBuf, "%s: %s: fWaitAM TimeOut\r\n", 
		    			MagGroup1[g1].MagName, gErrCode(TmpErr));
		    	fprintf(fhErr, ErrBuf);
		    }
		}
	for(g2=0; g2 < grp2cntr; g2++)
		if ( (SectionMask & 1L<<MagGroup2[g2].SectionMask && MagGroup2[g2].CycleLevel[CYCLE] != DONE_STATE) ) 
		  if ( GroupMask & GROUP_2 ) { 
            *CycleDone = NO;
			fWaitAM ( &MagGroup2[g2] );
			TmpErr=MagGroup2[g2].ErrCode;
			if (TmpErr != OK_PASS && TmpErr != NOT_READY) {
				gErr = ERR_BADSTATE;
		    	sprintf(ErrBuf, "%s: %s: fWaitAM TimeOut\r\n", 
		    			MagGroup2[g2].MagName, gErrCode(TmpErr));
		    	fprintf(fhErr, ErrBuf);
		    }
		}
	for(g3=0; g3 < grp3cntr; g3++)
		if ( (SectionMask & 1L<<MagGroup3[g3].SectionMask && MagGroup3[g3].CycleLevel[CYCLE] != DONE_STATE) )
		  if ( GroupMask & GROUP_3 ) { 
            *CycleDone = NO;
			fWaitAM ( &MagGroup3[g3] );
			TmpErr=MagGroup3[g3].ErrCode;
			if (TmpErr != OK_PASS && TmpErr != NOT_READY) {
				gErr = ERR_BADSTATE;
		    	sprintf(ErrBuf, "%s: %s: fWaitAM TimeOut\r\n", 
		    			MagGroup3[g3].MagName, gErrCode(TmpErr));
		    	fprintf(fhErr, ErrBuf);
		    }
		}
	for(g4=0; g4 < grp4cntr; g4++)
		if ( (SectionMask & 1L<<MagGroup4[g4].SectionMask && MagGroup4[g4].CycleLevel[CYCLE] != DONE_STATE) )
		  if ( GroupMask & GROUP_4 ) { 
            *CycleDone = NO;
			fWaitAM ( &MagGroup4[g4] );
			TmpErr=MagGroup4[g4].ErrCode;
			if (TmpErr != OK_PASS && TmpErr != NOT_READY) {
				gErr = ERR_BADSTATE;
		    	sprintf(ErrBuf, "%s: %s: fWaitAM TimeOut\r\n", 
		    			MagGroup4[g4].MagName, gErrCode(TmpErr));
		    	fprintf(fhErr, ErrBuf);
		    }
		}
	for(g5=0; g5 < grp5cntr; g5++)
		if ( (SectionMask & 1L<<MagGroup5[g5].SectionMask && MagGroup5[g5].CycleLevel[CYCLE] != DONE_STATE) )
		  if ( GroupMask & GROUP_5 ) { 
            *CycleDone = NO;
			fWaitAM ( &MagGroup5[g5] );
			TmpErr=MagGroup5[g5].ErrCode;
			if (TmpErr != OK_PASS && TmpErr != NOT_READY) {
				gErr = ERR_BADSTATE;
		    	sprintf(ErrBuf, "%s: %s: fWaitAM TimeOut\r\n", 
		    			MagGroup5[g5].MagName, gErrCode(TmpErr));
		    	fprintf(fhErr, ErrBuf);
		    }
		}
	for(g6=0; g6 < grp6cntr; g6++)
		if ( (SectionMask & 1L<<MagGroup6[g6].SectionMask && MagGroup6[g6].CycleLevel[CYCLE] != DONE_STATE) )
		  if ( GroupMask & GROUP_6 ) {
            *CycleDone = NO;
			fWaitAM ( &MagGroup6[g6] );
			TmpErr=MagGroup6[g6].ErrCode;
			if (TmpErr != OK_PASS && TmpErr != NOT_READY) {
				gErr = ERR_BADSTATE;
		    	sprintf(ErrBuf, "%s: %s: fWaitAM TimeOut\r\n", 
		    			MagGroup6[g6].MagName, gErrCode(TmpErr));
		    	fprintf(fhErr, ErrBuf);
		    }
		}
	for(g7=0; g7 < grp7cntr; g7++)
		if ( (SectionMask & 1L<<MagGroup7[g7].SectionMask && MagGroup7[g7].CycleLevel[CYCLE] != DONE_STATE) )
		  if ( GroupMask & GROUP_7 ) {
            *CycleDone = NO;
			fWaitAM ( &MagGroup7[g7] );
			TmpErr=MagGroup7[g7].ErrCode;
			if (TmpErr != OK_PASS && TmpErr != NOT_READY) {
				gErr = ERR_BADSTATE;
		    	sprintf(ErrBuf, "%s: %s: fWaitAM TimeOut\r\n", 
		    			MagGroup7[g7].MagName, gErrCode(TmpErr));
		    	fprintf(fhErr, ErrBuf);
		    }
		}
				
	if (gErr == ERR_BADSTATE)
		*ErrCode = ERR_BADSTATE;
	else
		*ErrCode = ERR_OK;
}

char *
gErrCode(UBYTE2 err)
{
	ErrFlag = YES;

	switch (err) {
		case ERAMPTIMEOUT:	return("Magnet Failed to reach Set Point (>+/- 10%%)");
							break;
		case EAMFROZEN:		return("Magnet current not changing");
							break;
		case EAMMISCALIB:	return("Magnet miscalibrated (>+/- 1%%)");
							break;
		default:			return(itoa(err, GString, 10));
							break;
	}
}


void far pascal  
TurnMagnetsOnOff (UBYTE2 *ErrCode, UBYTE2 OnOff, UBYTE4 OrigSectionMask)
{
    UBYTE2  TmpErr, TmpOnOff;
    int     i, cntr;
    int	g1, g2, g3, g4, g5, g6, g7;
    UBYTE2 linktime, resettime; 
    UBYTE4 SectionMask;
    UBYTE2 Reset;
    UBYTE1 SPDone;
    
    float zero = 0;
    
    SPDone = NO;
    *ErrCode = ERR_OK;  
      						/* A trick to pickup all SR sectors */
    SectionMask = (OrigSectionMask == (1L<<SEC_SR)) ? 0xffff00 : OrigSectionMask;
    
    if (OnOff == OFF) {  // set magnet supplies to 0 before turning off 
		for(g7=0; g7 < grp7cntr; g7++)
			if ( (SectionMask & 1L<<MagGroup7[g7].SectionMask) ) {
				SetSP ( &TmpErr, &MagGroup7[g7].MagnetACIndexILC, &zero /*&Grp6RampVal[MagGroup6[g6].MagType][0]*/ );
				MagGroup7[g7].CycleLevel[TEMP_CYCLE] = MagGroup7[g7].CycleLevel[CYCLE];
				MagGroup7[g7].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			}

		for(g6=0; g6 < grp6cntr; g6++)
			if ( (SectionMask & 1L<<MagGroup6[g6].SectionMask) ) {
				SetSP ( &TmpErr, &MagGroup6[g6].MagnetACIndexILC, &zero /*&Grp6RampVal[MagGroup6[g6].MagType][0]*/ );
				MagGroup6[g6].CycleLevel[TEMP_CYCLE] = MagGroup6[g6].CycleLevel[CYCLE];
				MagGroup6[g6].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			}

		for(g5=0; g5 < grp5cntr; g5++)
			if ( (SectionMask & 1L<<MagGroup5[g5].SectionMask) ) {
				SetSP ( &TmpErr, &MagGroup5[g5].MagnetACIndexILC, &zero /*&Grp5RampVal[MagGroup5[g5].MagType][0]*/ );
				MagGroup5[g5].CycleLevel[TEMP_CYCLE] = MagGroup5[g5].CycleLevel[CYCLE];
				MagGroup5[g5].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			}

		for(g4=0; g4 < grp4cntr; g4++)
		 	if ( (SectionMask & 1L<<MagGroup4[g4].SectionMask) ) {
				SetSP ( &TmpErr, &MagGroup4[g4].MagnetACIndexILC, &zero /*&Grp4RampVal[MagGroup4[g4].MagType][0]*/ );
				MagGroup4[g4].CycleLevel[TEMP_CYCLE] = MagGroup4[g4].CycleLevel[CYCLE];
				MagGroup4[g4].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			}

		for(g3=0; g3 < grp3cntr; g3++)
			if ( (SectionMask & 1L<<MagGroup3[g3].SectionMask) ) {
				SetSP ( &TmpErr, &MagGroup3[g3].MagnetACIndexILC, &zero /*&Grp3RampVal[MagGroup3[g3].MagType][0]*/ );
				MagGroup3[g3].CycleLevel[TEMP_CYCLE] = MagGroup3[g3].CycleLevel[CYCLE];
				MagGroup3[g3].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			}

		for(g2=0; g2 < grp2cntr; g2++)
			if ( (SectionMask & 1L<<MagGroup2[g2].SectionMask) ) {
				SetSP ( &TmpErr, &MagGroup2[g2].MagnetACIndexILC, &zero /*&Grp2RampVal[MagGroup2[g2].MagType][0]*/ );
				MagGroup2[g2].CycleLevel[TEMP_CYCLE] = MagGroup2[g2].CycleLevel[CYCLE];
				MagGroup2[g2].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			}

		for(g1=0; g1 < grp1cntr; g1++)
			if ( (SectionMask & 1L<<MagGroup1[g1].SectionMask) ) {
				SetSP ( &TmpErr, &MagGroup1[g1].MagnetACIndexILC, &zero /*&Grp1RampVal[MagGroup1[g1].MagType][0]*/ );
				MagGroup1[g1].CycleLevel[TEMP_CYCLE] = MagGroup1[g1].CycleLevel[CYCLE];
				MagGroup1[g1].CycleLevel[CYCLE] = WAIT_FINAL_STATE;
			}
				
      while  (SPDone == NO) {
      
      	SPDone = YES;
      	
		linktime = 100;
		DELAY(&linktime);
		WaitMagAMs(&TmpErr, SectionMask, &SPDone);
	  }                                            
	  
	  	for(g7=0; g7 < grp7cntr; g7++)
			if ( (SectionMask & 1L<<MagGroup7[g7].SectionMask) ) {
				MagGroup7[g7].CycleLevel[CYCLE] = MagGroup7[g7].CycleLevel[TEMP_CYCLE];
			}

	  	for(g6=0; g6 < grp6cntr; g6++)
			if ( (SectionMask & 1L<<MagGroup6[g6].SectionMask) ) {
				MagGroup6[g6].CycleLevel[CYCLE] = MagGroup6[g6].CycleLevel[TEMP_CYCLE];
			}

	  	for(g5=0; g5 < grp5cntr; g5++)
			if ( (SectionMask & 1L<<MagGroup5[g5].SectionMask) ) {
				MagGroup5[g5].CycleLevel[CYCLE] = MagGroup5[g5].CycleLevel[TEMP_CYCLE];
			}

		for(g4=0; g4 < grp4cntr; g4++)
		 	if ( (SectionMask & 1L<<MagGroup4[g4].SectionMask) ) {
				MagGroup4[g4].CycleLevel[CYCLE] = MagGroup4[g4].CycleLevel[TEMP_CYCLE];
			}

		for(g3=0; g3 < grp3cntr; g3++)
			if ( (SectionMask & 1L<<MagGroup3[g3].SectionMask) ) {
				MagGroup3[g3].CycleLevel[CYCLE] = MagGroup3[g3].CycleLevel[TEMP_CYCLE];
			}

		for(g2=0; g2 < grp2cntr; g2++)
			if ( (SectionMask & 1L<<MagGroup2[g2].SectionMask) ) {
				MagGroup2[g2].CycleLevel[CYCLE] = MagGroup2[g2].CycleLevel[TEMP_CYCLE];
			}

		for(g1=0; g1 < grp1cntr; g1++)
			if ( (SectionMask & 1L<<MagGroup1[g1].SectionMask) ) {
				MagGroup1[g1].CycleLevel[CYCLE] = MagGroup1[g1].CycleLevel[TEMP_CYCLE];
			}

	
		
    } else {   // to turn ON, reset all PSs that have reset lines
		linktime = 5;
    	Reset = 255;
		for(g7=0; g7 < grp7cntr; g7++)
			if ( (SectionMask & 1L<<MagGroup7[g7].SectionMask) && MagGroup7[g7].MagnetRstIndexILC)
				SetBC ( &TmpErr, &MagGroup7[g7].MagnetRstIndexILC, &Reset );

		for(g6=0; g6 < grp6cntr; g6++)
			if ( (SectionMask & 1L<<MagGroup6[g6].SectionMask) && MagGroup6[g6].MagnetRstIndexILC)
				SetBC ( &TmpErr, &MagGroup6[g6].MagnetRstIndexILC, &Reset );

		for(g5=0; g5 < grp5cntr; g5++)
			if ( (SectionMask & 1L<<MagGroup5[g5].SectionMask) && MagGroup5[g5].MagnetRstIndexILC)
				SetBC ( &TmpErr, &MagGroup5[g5].MagnetRstIndexILC, &Reset );

		for(g4=0; g4 < grp4cntr; g4++)
		 	if ( (SectionMask & 1L<<MagGroup4[g4].SectionMask) && MagGroup4[g4].MagnetRstIndexILC)
				SetBC ( &TmpErr, &MagGroup4[g4].MagnetRstIndexILC, &Reset  );

		for(g3=0; g3 < grp3cntr; g3++)
			if ( (SectionMask & 1L<<MagGroup3[g3].SectionMask) && MagGroup3[g3].MagnetRstIndexILC)
				SetBC ( &TmpErr, &MagGroup3[g3].MagnetRstIndexILC, &Reset  );

		for(g2=0; g2 < grp2cntr; g2++)
			if ( (SectionMask & 1L<<MagGroup2[g2].SectionMask) && MagGroup2[g2].MagnetRstIndexILC)
				SetBC ( &TmpErr, &MagGroup2[g2].MagnetRstIndexILC, &Reset  );

		for(g1=0; g1 < grp1cntr; g1++)
			if ( (SectionMask & 1L<<MagGroup1[g1].SectionMask) && MagGroup1[g1].MagnetRstIndexILC)
				SetBC ( &TmpErr, &MagGroup1[g1].MagnetRstIndexILC, &Reset  );
				
		resettime = 100;    // wait 1 second for resets to be set and remain set long enough to reset
		DELAY(&resettime);
    }
    Reset = 0; 
    linktime = 5;
    // check reset state: set it to low if it's high, then turn on PS
    for (i=0; i<=grp1cntr; i++)
    	if ( SectionMask & 1L<<MagGroup1[i].SectionMask )
		{   
			if (MagGroup1[i].MagnetRstIndexILC) {      // if there is a reset, check it
				GetBC( &TmpErr, &MagGroup1[i].MagnetRstIndexILC, &Reset );
				if (Reset) {
					Reset = 0;
					SetBC( &TmpErr, &MagGroup1[i].MagnetRstIndexILC, &Reset );
				}
			}
					
			cntr = 0;
			SetBC (&MagGroup1[i].ErrCode, &MagGroup1[i].MagnetDVIndexILC, &OnOff);
			do {
				DELAY(&linktime);
				GetBC(&TmpErr, &MagGroup1[i].MagnetDVIndexILC, &TmpOnOff);
	    		cntr++;
			} while ( TmpOnOff != OnOff && cntr < WAIT_LIMIT && !TmpErr);
						
			if ( cntr == WAIT_LIMIT ) {
		    		sprintf(ErrBuf, "%s: Timed out trying to turn off or on\r\n", 
		    				MagGroup1[i].MagName);
		    		fprintf(fhErr, ErrBuf);
			}
			if (MagGroup1[i].ErrCode || TmpErr) {
		    		sprintf(ErrBuf, "%s: BC:Error=%u. Stat:Error=%u. Trying to turn off or on\r\n", 
		    				MagGroup1[i].MagName, MagGroup1[i].ErrCode, TmpErr);
		    		fprintf(fhErr, ErrBuf);
			}
        }
    for (i=0; i<=grp2cntr; i++)
    	if ( SectionMask & 1L<<MagGroup2[i].SectionMask )
		{
			if (MagGroup2[i].MagnetRstIndexILC) {      // if there is a reset, check it
				GetBC( &TmpErr, &MagGroup2[i].MagnetRstIndexILC, &Reset );
				if (Reset) {
					Reset = 0;
					SetBC( &TmpErr, &MagGroup2[i].MagnetRstIndexILC, &Reset );
				} 
			}
			cntr = 0;   								//Turn on or off and check result
			SetBC (&MagGroup2[i].ErrCode, &MagGroup2[i].MagnetDVIndexILC, &OnOff);
			do {
				DELAY(&linktime);
				GetBC(&TmpErr, &MagGroup2[i].MagnetDVIndexILC, &TmpOnOff);
	    		cntr++;
			} while ( TmpOnOff != OnOff && cntr < WAIT_LIMIT && !TmpErr);
						
			if ( cntr == WAIT_LIMIT ) {
		    		sprintf(ErrBuf, "%s: Timed out trying to turn off or on\r\n", 
		    				MagGroup2[i].MagName);
		    		fprintf(fhErr, ErrBuf);
			}
			if (MagGroup2[i].ErrCode || TmpErr) {
		    		sprintf(ErrBuf, "%s: BC:Error=%u. Stat:Error=%u. Trying to turn off or on\r\n", 
		    				MagGroup2[i].MagName, MagGroup2[i].ErrCode, TmpErr);
		    		fprintf(fhErr, ErrBuf);
			}
       }
    for (i=0; i<=grp3cntr; i++)
    	if ( SectionMask & 1L<<MagGroup3[i].SectionMask )
		{
			if (MagGroup3[i].MagnetRstIndexILC) {      // if there is a reset, check it
				GetBC( &TmpErr, &MagGroup3[i].MagnetRstIndexILC, &Reset );
				if (Reset) {
					Reset = 0;
					SetBC( &TmpErr, &MagGroup3[i].MagnetRstIndexILC, &Reset );
				}
			}		
			cntr = 0;
			SetBC (&MagGroup3[i].ErrCode, &MagGroup3[i].MagnetDVIndexILC, &OnOff);
			do {
				DELAY(&linktime);
				GetBC(&TmpErr, &MagGroup3[i].MagnetDVIndexILC, &TmpOnOff);
	    		cntr++;
			} while ( TmpOnOff != OnOff && cntr < WAIT_LIMIT && !TmpErr);
						
			if ( cntr == WAIT_LIMIT ) {
		    		sprintf(ErrBuf, "%s: Timed out trying to turn off or on\r\n", 
		    				MagGroup3[i].MagName);
		    		fprintf(fhErr, ErrBuf);
			}
			if (MagGroup3[i].ErrCode || TmpErr) {
		    		sprintf(ErrBuf, "%s: BC:Error=%u. Stat:Error=%u. Trying to turn off or on\r\n", 
		    				MagGroup3[i].MagName, MagGroup3[i].ErrCode, TmpErr);
		    		fprintf(fhErr, ErrBuf);
			}
       }
    for (i=0; i<=grp4cntr; i++)
    	if ( SectionMask & 1L<<MagGroup4[i].SectionMask )
		{
			if (MagGroup4[i].MagnetRstIndexILC) {      // if there is a reset, check it
				GetBC( &TmpErr, &MagGroup4[i].MagnetRstIndexILC, &Reset );
				if (Reset) {
					Reset = 0;
					SetBC( &TmpErr, &MagGroup4[i].MagnetRstIndexILC, &Reset );
				}
			}
			cntr = 0;
			SetBC (&MagGroup4[i].ErrCode, &MagGroup4[i].MagnetDVIndexILC, &OnOff);
			do {
				DELAY(&linktime);
				GetBC(&TmpErr, &MagGroup4[i].MagnetDVIndexILC, &TmpOnOff);
	    		cntr++;
			} while ( TmpOnOff != OnOff && cntr < WAIT_LIMIT && !TmpErr);
						
			if ( cntr == WAIT_LIMIT ) {
		    		sprintf(ErrBuf, "%s: Timed out trying to turn off or on\r\n", 
		    				MagGroup4[i].MagName);
		    		fprintf(fhErr, ErrBuf);
			}
			if (MagGroup4[i].ErrCode || TmpErr) {
		    		sprintf(ErrBuf, "%s: BC:Error=%u. Stat:Error=%u. Trying to turn off or on\r\n", 
		    				MagGroup4[i].MagName, MagGroup4[i].ErrCode, TmpErr);
		    		fprintf(fhErr, ErrBuf);
			}
        }
    for (i=0; i<=grp5cntr; i++)
    	if ( (SectionMask & 1L<<MagGroup5[i].SectionMask) &&
    			MagGroup5[i].MagName != NULL )
		{
			if (MagGroup5[i].MagnetRstIndexILC) {      // if there is a reset, check it
				GetBC( &TmpErr, &MagGroup5[i].MagnetRstIndexILC, &Reset );
				if (Reset) {
					Reset = 0;
					SetBC( &TmpErr, &MagGroup5[i].MagnetRstIndexILC, &Reset );
				}
			}
			cntr = 0;
			SetBC (&MagGroup5[i].ErrCode, &MagGroup5[i].MagnetDVIndexILC, &OnOff);
			do {
				DELAY(&linktime);
				GetBC(&TmpErr, &MagGroup5[i].MagnetDVIndexILC, &TmpOnOff);
	    		cntr++;
			} while ( TmpOnOff != OnOff && cntr < WAIT_LIMIT && !TmpErr);
						
			if ( cntr == WAIT_LIMIT ) {
		    		sprintf(ErrBuf, "%s: Timed out trying to turn off or on\r\n", 
		    				MagGroup5[i].MagName);
		    		fprintf(fhErr, ErrBuf);
			}
			if (MagGroup5[i].ErrCode || TmpErr) {
		    		sprintf(ErrBuf, "%s: BC:Error=%u. Stat:Error=%u. Trying to turn off or on\r\n", 
		    				MagGroup5[i].MagName, MagGroup5[i].ErrCode, TmpErr);
		    		fprintf(fhErr, ErrBuf);
			}
		}
    for (i=0; i<=grp6cntr; i++)
    	if ( (SectionMask & 1L<<MagGroup6[i].SectionMask) &&
    			MagGroup6[i].MagName != NULL )
		{
			if (MagGroup6[i].MagnetRstIndexILC) {      // if there is a reset, check it
				GetBC( &TmpErr, &MagGroup6[i].MagnetRstIndexILC, &Reset );
				if (Reset) {
					Reset = 0;
					SetBC( &TmpErr, &MagGroup6[i].MagnetRstIndexILC, &Reset );
				}
			}
			cntr = 0;
			SetBC (&MagGroup6[i].ErrCode, &MagGroup6[i].MagnetDVIndexILC, &OnOff);
			do {
				DELAY(&linktime);
				GetBC(&TmpErr, &MagGroup6[i].MagnetDVIndexILC, &TmpOnOff);
	    		cntr++;
			} while ( TmpOnOff != OnOff && cntr < WAIT_LIMIT && !TmpErr);
						
			if ( cntr == WAIT_LIMIT ) {
		    		sprintf(ErrBuf, "%s: Timed out trying to turn off or on\r\n", 
		    				MagGroup6[i].MagName);
		    		fprintf(fhErr, ErrBuf);
			}
			if (MagGroup6[i].ErrCode || TmpErr) {
		    		sprintf(ErrBuf, "%s: BC:Error=%u. Stat:Error=%u. Trying to turn off or on\r\n", 
		    				MagGroup6[i].MagName, MagGroup6[i].ErrCode, TmpErr);
		    		fprintf(fhErr, ErrBuf);
			}
		}
    for (i=0; i<=grp7cntr; i++)
    	if ( (SectionMask & 1L<<MagGroup7[i].SectionMask) &&
    			MagGroup7[i].MagName != NULL )
		{
			if (MagGroup7[i].MagnetRstIndexILC) {      // if there is a reset, check it
				GetBC( &TmpErr, &MagGroup7[i].MagnetRstIndexILC, &Reset );
				if (Reset) {
					Reset = 0;
					SetBC( &TmpErr, &MagGroup7[i].MagnetRstIndexILC, &Reset );
				}
			}
			cntr = 0;
			SetBC (&MagGroup7[i].ErrCode, &MagGroup7[i].MagnetDVIndexILC, &OnOff);
			do {
				DELAY(&linktime);
				GetBC(&TmpErr, &MagGroup7[i].MagnetDVIndexILC, &TmpOnOff);
	    		cntr++;
			} while ( TmpOnOff != OnOff && cntr < WAIT_LIMIT && !TmpErr);
						
			if ( cntr == WAIT_LIMIT ) {
		    		sprintf(ErrBuf, "%s: Timed out trying to turn off or on\r\n", 
		    				MagGroup7[i].MagName);
		    		fprintf(fhErr, ErrBuf);
			}
			if (MagGroup7[i].ErrCode || TmpErr) {
		    		sprintf(ErrBuf, "%s: BC:Error=%u. Stat:Error=%u. Trying to turn off or on\r\n", 
		    				MagGroup7[i].MagName, MagGroup7[i].ErrCode, TmpErr);
		    		fprintf(fhErr, ErrBuf);
			}
		}
}


void far pascal MCLogon (UBYTE2 *ErrCode)
{
    PASSWD passwd;
    UBYTE2 NumILCs, ILCArray[32];

    Logon( ErrCode, &NumILCs, ILCArray, &passwd );
    if (*ErrCode != 0)
		return;

    if (NumILCs == 0)
		{
		*ErrCode = 1;
		return;
		}
	
	fhErr = fopen("y:\\opstat\\temp\\magcycle.txt", "w");	
//	fhErr = fopen("c:\\magcycle.txt", "w");	
}


int far pascal WEP (bSystemExit)
int  bSystemExit;
{ 
    return(1);
}

int far pascal LibMain(hModule, wDataSeg, cbHeapSize, lpszCmdLine)
HANDLE   hModule;
WORD      wDataSeg;
WORD      cbHeapSize;
LPSTR	   lpszCmdLine;
{
    UBYTE2 ErrCode;

    MCLogon (&ErrCode);
    return 1;
}

static int ParseString(char *InputStr, char *disp_name, char *chan_type, char *dev_type, char *string_value)
{
	int	i,j,k;
	char	*StrPtrs[4];

	StrPtrs[0]=disp_name;
	StrPtrs[1]=chan_type;
	StrPtrs[2]=dev_type;
	StrPtrs[3]=string_value;

	j=0;			/* which char in a string */
	k=0;			/* which string */
	for (i=0; i<(int)strlen (InputStr); i++)
		{
	    if (InputStr[i] != '\t')
	    	{
			StrPtrs[k][j]=InputStr[i];
			j++;
	    	}
	    else
	    	{
			StrPtrs[k][j]=0; /* terminate current string */
			j = 0;		/* reset char count */
			k ++;		/* point to next string to be filled */
			if (k>=4) return (-1);
				/* too many fields */
	    	}
		}
	StrPtrs[k][j]=0; /* terminate last string */
	return (k+1);	   /* return number of fields filled */
}

/*static void LoadGroupLimits(int *ErrCode, REAL4 GroupLimits[GROUP_NUM][4])
{
ILE *gfile;
	int i;
	char c;

	
//	gfile = fopen("y:\\opstat\\temp\\groupdb.txt", "r");
	gfile = fopen("c:\\groupdb.txt", "r");

	if (gfile == NULL) {
		*ErrCode = ERR_BADGROUPFILE;
		return;
	}

	for (i=0; i< GROUP_NUM; i++) {
		if ((c = getc(gfile)) != 'v')
			while((c = getc(gfile)) != 'v')
				if (c == EOF) {
					*ErrCode = ERR_BADGROUPFILE;
					return;
				}
		if (fscanf(gfile, "%f %f %f %f\n", GroupLimits[i][0], GroupLimits[i][1],
										   GroupLimits[i][2], GroupLimits[i][3]) == EOF) {
			*ErrCode = ERR_BADGROUPFILE;
			return;
		}
	}
	
    *ErrCode = ERR_OK;
}
*/		
		 