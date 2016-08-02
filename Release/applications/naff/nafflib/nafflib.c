/* Version modified by Laurent S. Nadolski - Synchrotron SOLEIL
 * April 6th, 2007
 * Modifications
 * 1 - english comments added
 * 2 - debug information display if fourth argument is 1
 * 3 - optional outputs: amplitude and phase
 *
 * known NAFF bugs: data length has to be at least 64
 */

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "mex.h"
#include "matrix.h"
/* #include "gpfunc.h" */
#include "modnaff.h"
#include "complexe.h"
/* #include <sys/ddi.h> */

double pi = M_PI;

/* Input Arguments */
#define	Y_IN    prhs[0]
#define	YP_IN   prhs[1]
#define	IS_REAL prhs[2]
#define	WIN_IN  prhs[3]
#define	NFREQ_IN  prhs[4]
#define	DEBUG_IN  prhs[5]

/* Output Arguments */
#define	NU_OUT plhs[0]
#define	AMPLITUDE_OUT plhs[1]
#define	PHASE_OUT plhs[2]

unsigned int call_naff(double *ydata, double *ypdata, bool is_real, int n_interval, double  *nu_out,
double *amplitude_out, double *phase_out, int win, int nfreq, int debug)
{
    int i, iCpt;
    unsigned int numfreq;

    /* n_interval is truncated to be a multiple of 6 if is not yet) */
    n_interval = 6*(int )(n_interval/6.0);

    /*Created before naf_initnaf*/
    g_NAFVariable.DTOUR      = 2*pi;       /* size of one "cadran" */
    g_NAFVariable.KTABS      = n_interval; /* number of intervals between data (equal ndata-1): must be a multiple of 6. */
    g_NAFVariable.XH         = 1;          /* time interval between data. if 1, frequencies go from -pi to pi, if 2pi frequencies go from -0.5 to 0.5 */
    g_NAFVariable.NTERM      = nfreq;      /* max term to find */
    g_NAFVariable.IW         = win;        /* type of window to use. 0 means no window , 1 means hanning*/
    g_NAFVariable.T0         = 0.0;        /* initial time t0. Necessary to get the phase correctly*/
    g_NAFVariable.ICPLX      = !is_real;   /* 0 if the function is real, 1 if not*/
    g_NAFVariable.ISEC       = 1;          /* Flag defining use of secant method: 0 don't use, 1 use*/
    g_NAFVariable.NFPRT      = stdout;     /* Where to print the results : stdout or NULL   */
    g_NAFVariable.IPRT       = -1;         /* type of Printing: -1 nothing, O Error Messages, 1  Results, 2 (DEBUG) */
    /* Calculated by naf_initnaf*/
    g_NAFVariable.UNIANG     = 0;
    g_NAFVariable.FREFON     = 0;
    g_NAFVariable.EPSM       = 2.2204e-16;
    /*Filled after naf_initnaf*/
    g_NAFVariable.ZTABS      = NULL;     /* will contain data to analyze */
    /*Returned by NAFF*/
    g_NAFVariable.TFS        = NULL;     /* will contain frequency */
    g_NAFVariable.ZAMP       = NULL;     /* will contain amplitude and phase*/
    g_NAFVariable.NFS        = 0;        /* Number of frequencies found by NAFF */
    /****************************************************/
    /*               internal use in naf                */
    g_NAFVariable.NERROR            = 0;
    g_NAFVariable.ZALP              = NULL;   /* will contain transformation matrix to the orthgonal basis */
    g_NAFVariable.m_pListFen        = NULL;   /* no window */
    g_NAFVariable.m_iNbLineToIgnore = 1;      /* unused */
    g_NAFVariable.m_dneps           = 1.E100;
    g_NAFVariable.m_bFSTAB          = FALSE;  /* unused */
    /*             end of internal use in naf             */
    /****************************************************/

    naf_initnaf();

 /*Transform initial data to complex data since algorithm is optimized for cx data*/
    for(i=0;i<=n_interval;i++)
    {
        g_NAFVariable.ZTABS[i].reel = ydata[i];
        g_NAFVariable.ZTABS[i].imag = ypdata[i];
    }

    /*Frequency map analysis*/
    /* look for at most nfreq first fundamental frequencies */
    naf_mftnaf(nfreq,fabs(g_NAFVariable.FREFON)/g_NAFVariable.m_dneps);

   /* print out results */

    if (debug == 1)
    {
        mexPrintf("*** NAFF results ***\n");
        mexPrintf("NFS = %d\n",g_NAFVariable.NFS);


        for(iCpt=1;iCpt<=g_NAFVariable.NFS; iCpt++)
        {
            mexPrintf("AMPL=% 9.6e+i*% 9.6e abs(AMPL)=% 9.6e arg(AMPL)=% 9.6e FREQ=% 9.6e\n",
            g_NAFVariable.ZAMP[iCpt].reel,g_NAFVariable.ZAMP[iCpt].imag,
            (float )i_compl_module(g_NAFVariable.ZAMP[iCpt]),
            (float )i_compl_angle(g_NAFVariable.ZAMP[iCpt]),
            (float )g_NAFVariable.TFS[iCpt]);

        }
    } /* debug
    /* number of identified fondamental frequencies */
    numfreq = (unsigned int) g_NAFVariable.NFS;

    for(iCpt=1;iCpt<=numfreq; iCpt++) {
        nu_out[iCpt-1] = g_NAFVariable.TFS[iCpt];
        amplitude_out[iCpt-1] = (float )i_compl_module(g_NAFVariable.ZAMP[iCpt]);
        phase_out[iCpt-1] = (float )i_compl_angle(g_NAFVariable.ZAMP[iCpt]);
    }


    /*free memory*/
    naf_cleannaf();

    /* return number of fundamental frequencies */
    return(numfreq);
}

#define min(a, b)       ((a) < (b) ? (a) : (b))
#define max(a, b)       ((a) < (b) ? (b) : (a))

/*  MATLAB TO C-CALL LINKING FUNCTION  */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double	 *nu_out, *amplitude_out, *phase_out, *y_in, *yp_in, *scalar_in;
    double   *nu, *amplitude, *phase;
    unsigned int  i, m, n, m2, n2, numfreq;
    int win, debug, nfreq;
    bool is_real = false;

    /* lock mex-file for avoiding unloading with clear all */
    /*mexLock();*/

    debug = 0; /* 1 means debugging information */
    nfreq = 10;/* maximum number of frequencies to look for */

    if ((nrhs < 2) || (nrhs >6)) {
        mexErrMsgTxt("Requires 2 to 6 input arguments");
    }

    if (nrhs <2) { /* no windows */
        win = 0;
    }

    if (nrhs >= 3){ /* check if user wants it to be treated as real */
        m = mxGetM(IS_REAL);
        n = mxGetN(IS_REAL);

        if (!mxIsLogical(IS_REAL) || mxIsSparse(IS_REAL)  ||  (max(m,n) != 1) || (min(m,n) != 1))
        {
            mexErrMsgTxt("CALCNAFF requires that is_real be a scalar.");
        }
        is_real = mxIsLogicalScalarTrue(IS_REAL);
    }

    if (nrhs >= 4){ /* windowing */
        m = mxGetM(WIN_IN);
        n = mxGetN(WIN_IN);

        if (!mxIsNumeric(WIN_IN) || mxIsComplex(WIN_IN) ||
        mxIsSparse(WIN_IN)  ||  (max(m,n) != 1) || (min(m,n) != 1))
        {
            mexErrMsgTxt("CALCNAFF requires that Window be a scalar.");
        }

        /* assign pointer */
        scalar_in   = mxGetPr(WIN_IN);
        win = (int )*scalar_in;
    }

    if (nrhs >= 5){ /* user fequency number */
        m = mxGetM(NFREQ_IN);
        n = mxGetN(NFREQ_IN);

        if (!mxIsNumeric(NFREQ_IN) || mxIsComplex(NFREQ_IN) ||
        mxIsSparse(NFREQ_IN)  ||  (max(m,n) != 1) || (min(m,n) != 1))
        {
            mexErrMsgTxt("CALCNAFF requires that frequency number be a scalar.");
        }
           /* assign pointer for maximum number of frequency */
        scalar_in   = mxGetPr(NFREQ_IN);
        nfreq = (int )*scalar_in;
    }

    if (nrhs >= 6){ /* debugging flag */
        m = mxGetM(DEBUG_IN);
        n = mxGetN(DEBUG_IN);

        if (!mxIsNumeric(DEBUG_IN) || mxIsComplex(DEBUG_IN) ||
        mxIsSparse(DEBUG_IN)  ||  (max(m,n) != 1) || (min(m,n) != 1))
        {
            mexErrMsgTxt("CALCNAFF requires that dubbing flag be a scalar.");
        }

            /* assign pointer for debugging flag */
        scalar_in   = mxGetPr(DEBUG_IN);
        debug = (int )*scalar_in;

    }

  /* Check the dimensions of Y.  Y can be >6 X 1 or 1 X >6. */

    m = mxGetM(Y_IN);
    n = mxGetN(Y_IN);

    if (!mxIsNumeric(Y_IN) || mxIsComplex(Y_IN) ||
    mxIsSparse(Y_IN)  || !mxIsDouble(Y_IN) ||
    (max(m,n) < 67) || (min(m,n) != 1)) { /*Fernando Henrique de Sá - changed from 66 to 67*/
        mexErrMsgTxt("CALCNAFF requires that Y be a >= 67 x 1 vector.");
    }

    /* assign pointer */
    y_in   = mxGetPr(Y_IN);

    /* Check the dimensions of YP.  YP must have same size as Y */
    m2 = mxGetM(YP_IN);
    n2 = mxGetN(YP_IN);

    if (!mxIsNumeric(YP_IN) || mxIsComplex(YP_IN) ||
    mxIsSparse(YP_IN)  || !mxIsDouble(YP_IN) ||
    (m2 != m) || (n2 != n)) {
        mexErrMsgTxt("CALCNAFF requires that YP has the same size as Y.");
    }

    /* assign pointer */
    yp_in   = mxGetPr(YP_IN);

    /* Dynamic memory allocation */
    SYSCHECKMALLOCSIZE(nu, double, nfreq);
    SYSCHECKMALLOCSIZE(amplitude, double, nfreq);
    SYSCHECKMALLOCSIZE(phase, double, nfreq);

    /* call subroutine that calls routine for all NAFF computation */
    numfreq = call_naff(y_in, yp_in, is_real, (int )(max(m,n)-1), nu, amplitude, phase, win, nfreq, debug);
    /*In above, (int )max(m,n) was changed to (int )(max(m,n)-1) due to misintepretation of input*//* Fernando*/

    /* Create Output Vector */
    NU_OUT = mxCreateDoubleMatrix(numfreq, (unsigned int) 1, mxREAL);

    /* assign pointer */
    nu_out = mxGetPr(NU_OUT);

    if (nlhs == 2){ /* frequencies and amplitudes */
    /* Create Output Vector */
        AMPLITUDE_OUT = mxCreateDoubleMatrix(numfreq, (unsigned int) 1, mxREAL);

    /* assign pointer */
        amplitude_out = mxGetPr(AMPLITUDE_OUT);

    /* copy results */
        for (i=0;i<numfreq;i++) {
            nu_out[i] = nu[i];
            amplitude_out[i] = amplitude[i];
        }
    }
    else if (nlhs == 3){ /* frequencies, amplitudes and phase*/
    /* Create Output Vector */
        AMPLITUDE_OUT = mxCreateDoubleMatrix(numfreq, (unsigned int) 1, mxREAL);

    /* assign pointer */
        amplitude_out = mxGetPr(AMPLITUDE_OUT);

    /* Create Output Vector */
        PHASE_OUT = mxCreateDoubleMatrix(numfreq, (unsigned int) 1, mxREAL);

    /* assign pointer */
        phase_out = mxGetPr(PHASE_OUT);

    /* copy results */
        for (i=0;i<numfreq;i++) {
            nu_out[i] = nu[i];
            amplitude_out[i] = amplitude[i];
            phase_out[i] = phase[i];
        }
    }
    else { /* just frequencies */
        for(i=0;i<numfreq;i++) {
            nu_out[i] = nu[i];
        }
    }/* end of nlhs == 2 */

    /* free dynamically memory allocation */
    SYSFREE(nu);
    SYSFREE(amplitude);
    SYSFREE(phase);

    return;
} /* end of mexFunction */
