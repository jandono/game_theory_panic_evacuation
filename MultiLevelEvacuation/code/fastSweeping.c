#include "mex.h"

#include <math.h>

#if defined __GNUC__ && defined __FAST_MATH__ && !defined __STRICT_ANSI__
#define MIN(i, j) fmin(i, j)
#define MAX(i, j) fmax(i, j)
#define ABS(i)    fabs(i)
#else
#define MIN(i, j) ((i) < (j) ? (i) : (j))
#define MAX(i, j) ((i) > (j) ? (i) : (j))
#define ABS(i)    ((i) < 0.0 ? -(i) : (i))
#endif


#define SOLVE_AND_UPDATE    udiff = uxmin - uymin; \
                            if (ABS(udiff) >= 1.0) \
                            { \
                                up = MIN(uxmin, uymin) + 1.0; \
                            } \
                            else \
                            { \
                                up = (uxmin + uymin + sqrt(2.0 - udiff * udiff)) / 2.0; \
                                up = MIN(uij, up); \
                            } \
                            err_loc = MAX(ABS(uij - up), err_loc); \
                            u[ij] = up;

#define I_STEP(_uxmin, _uymin, _st) if (boundary[ij] == 0.0) \
                                    { \
                                        uij = un; \
                                        un = u[ij + _st]; \
                                        uxmin = _uxmin; \
                                        uymin = _uymin; \
                                        SOLVE_AND_UPDATE \
                                        ij += _st; \
                                    } \
                                    else \
                                    { \
                                        up = un; \
                                        un = u[ij + _st]; \
                                        ij += _st; \
                                    }
                                        
                                        
                                        
                                    
#define I_STEP_UP(_uxmin, _uymin)   I_STEP(_uxmin, _uymin, 1)
#define I_STEP_DOWN(_uxmin, _uymin) I_STEP(_uxmin, _uymin,-1)
                                    
#define UX_NEXT un
#define UX_PREV up
#define UX_BOTH MIN(UX_PREV, UX_NEXT)

#define UY_RIGHT u[ij + m]
#define UY_LEFT  u[ij - m]
#define UY_BOTH  MIN(UY_LEFT, UY_RIGHT)

                                    

static void iteration(double *u, double *boundary, int m, int n, double *err)
{
    int i, j, ij;
    int m2, n2;
    double up, un, uij, uxmin, uymin, udiff, err_loc;
    
    m2 = m - 2;
    n2 = n - 2;
    
    *err = 0.0;
    err_loc = 0.0;
    
    /* first sweep */
    /* i = 0, j = 0 */
    ij = 0;
    un = u[ij];
    I_STEP_UP(UX_NEXT, UY_RIGHT)
    
    /* i = 1->m2, j = 0 */
    for (i = 1; i <= m2; ++i)
        I_STEP_UP(UX_BOTH, UY_RIGHT)
    
    /* i = m-1, j = 0 */
    I_STEP_UP(UX_PREV, UY_RIGHT)
    
    /* i = 0->m-1, j = 1->n2 */
    for (j = 1; j <= n2; ++j)
    {
        I_STEP_UP(UX_NEXT, UY_BOTH)
        
        for (i = 1; i <= m2; ++i)
            I_STEP_UP(UX_BOTH, UY_BOTH)
        
        I_STEP_UP(UX_PREV, UY_BOTH)
    }
    
    /* i = 0, j = n-1 */
    I_STEP_UP(UX_NEXT, UY_LEFT)
    
    /* i = 1->m2, j = n-1 */
    for (i = 1; i <= m2; ++i)
        I_STEP_UP(UX_BOTH, UY_LEFT)
    
    /* i = m-1, j = n-1 */
    I_STEP_UP(UX_PREV, UY_LEFT)

    
    /* sweep 2 */
    /* i = 0, j = n-1 */
    ij = (n-1)*m;
    un = u[ij];
    I_STEP_UP(UX_NEXT, UY_LEFT)
    
    /* i = 1->m2, j = n-1 */
    for (i = 1; i <= m2; ++i)
        I_STEP_UP(UX_BOTH, UY_LEFT)
    
    /* i = m-1, j = n-1 */
    I_STEP_UP(UX_PREV, UY_LEFT)
    
    /* i = 0->m-1, j = n2->1 */
    for (j = n2; j >= 1; --j)
    {
        ij = j*m;
        un = u[ij];
        I_STEP_UP(UX_NEXT, UY_BOTH)
        
        for (i = 1; i <= m2; ++i)
            I_STEP_UP(UX_BOTH, UY_BOTH)
        
        I_STEP_UP(UX_PREV, UY_BOTH)
    }
    
    /* i = 0, j = 0 */
    ij = 0;
    un = u[ij];
    I_STEP_UP(UX_NEXT, UY_RIGHT)
    
    /* i = 1->m2, j = 0 */
    for (i = 1; i <= m2; ++i)
        I_STEP_UP(UX_BOTH, UY_RIGHT)
    
    /* i = m-1, j = 0 */
    I_STEP_UP(UX_PREV, UY_RIGHT)
    
    /* sweep 3 */
    /* i = m-1, j = n-1 */
    ij = m*n - 1;
    un = u[ij];
    I_STEP_DOWN(UX_NEXT, UY_LEFT)
    
    /* i = m2->1, j = n-1 */
    for (i = m2; i >= 1; --i)
        I_STEP_DOWN(UX_BOTH, UY_LEFT)
    
    /* i = 0, j = n-1 */
    I_STEP_DOWN(UX_PREV, UY_LEFT)
    
    /* i = m-1->0, j = n2->1 */
    for (j = n2; j >= 1; --j)
    {
        I_STEP_DOWN(UX_NEXT, UY_BOTH)
        
        for (i = m2; i >= 1; --i)
            I_STEP_DOWN(UX_BOTH, UY_BOTH)
            
        I_STEP_DOWN(UX_PREV, UY_BOTH)
    }
    
    /* i = m-1, j = 0 */
    I_STEP_DOWN(UX_NEXT, UY_RIGHT)
    
    /* i = m2->1, j = 0 */
    for (i = m2; i >= 1; --i)
        I_STEP_DOWN(UX_BOTH, UY_RIGHT)
    
    /* i = 0, j = 0 */
    I_STEP_DOWN(UX_PREV, UY_RIGHT)
    
    /* sweep 4 */
    /* i = m-1, j = 0 */
    ij = m - 1;
    un = u[ij];
    I_STEP_DOWN(UX_NEXT, UY_RIGHT)
    
    /* i = m2->1, j = 0 */
    for (i = m2; i >= 1; --i)
        I_STEP_DOWN(UX_BOTH, UY_RIGHT)
    
    /* i = 0, j = 0 */
    I_STEP_DOWN(UX_PREV, UY_RIGHT)
    
    /* i = m-1->0, j = 1->n2 */
    for (j = 1; j <= n2; ++j)
    {
        ij = m - 1 + j*m;
        un = u[ij];
        I_STEP_DOWN(UX_NEXT, UY_BOTH)
        
        for (i = m2; i >= 1; --i)
            I_STEP_DOWN(UX_BOTH, UY_BOTH)
            
        I_STEP_DOWN(UX_PREV, UY_BOTH)
    }
    
    /* i = m-1, j = n-1 */
    ij = m*n - 1;
    un = u[ij];
    I_STEP_DOWN(UX_NEXT, UY_LEFT)
    
    /* i = m2->1, j = n-1 */
    for (i = m2; i >= 1; --i)
        I_STEP_DOWN(UX_BOTH, UY_LEFT)
        
    /* i = 0, j = n-1 */
    I_STEP_DOWN(UX_PREV, UY_LEFT)
    
    *err = MAX(*err, err_loc);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *u, *boundary;
    double tol, err;
    int m, n, entries, max_iter, i;
    
    /* Check number of outputs */
    if (nlhs < 1)
        return;
    else if (nlhs > 1)
        mexErrMsgTxt("At most 1 output argument needed.");
    
    /* Get inputs */
    if (nrhs < 1)
        mexErrMsgTxt("At least 1 input argument needed.");
    else if (nrhs > 3)
        mexErrMsgTxt("At most 3 input arguments used.");
    
    
    
    /* Get boundary */
    if (!mxIsDouble(prhs[0]) || mxIsClass(prhs[0], "sparse"))
        mexErrMsgTxt("Boundary field needs to be a full double precision matrix.");
    
    boundary = mxGetPr(prhs[0]);
    m = mxGetM(prhs[0]);
    n = mxGetN(prhs[0]);
    entries = m * n;
    
    /* Get max iterations  */
    if (nrhs >= 2)
    {
        if (!mxIsDouble(prhs[1]) || mxGetM(prhs[1]) != 1 || mxGetN(prhs[1]) != 1)
            mexErrMsgTxt("Maximum iteration needs to be positive integer.");
        max_iter = (int) *mxGetPr(prhs[1]);
        if (max_iter <= 0)
            mexErrMsgTxt("Maximum iteration needs to be positive integer.");
    }
    else
        max_iter = 20;
    
    /* Get tolerance */
    if (nrhs >= 3)
    {
        if (!mxIsDouble(prhs[2]) || mxGetM(prhs[2]) != 1 || mxGetN(prhs[2]) != 1)
            mexErrMsgTxt("Tolerance needs to be a positive real number.");
        tol = *mxGetPr(prhs[2]);
        if (tol < 0)
            mexErrMsgTxt("Tolerance needs to be a positive real number.");
    }
    else
        tol = 1e-12;
        
    
    /* create and init output (distance) matrix */
    plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL);
    u = mxGetPr(plhs[0]);
    
    for (i = 0; i < entries; ++i)
        u[i] = boundary[i] < 0.0 ? 0.0 : 1.0e10;
        
    err = 0.0;
    i = 0;
    do
    {
        iteration(u, boundary, m, n, &err);
        ++i;
    } while (err > tol && i < max_iter);
}