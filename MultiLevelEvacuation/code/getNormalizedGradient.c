#include "mex.h"

#include <math.h>

#define INTERIOR(i, j)  (boundary[(i) + m*(j)] == 0)

#define DIST(i, j)  dist[(i) + m*(j)]
#define XGRAD(i, j) xgrad[(i) + m*(j)]
#define YGRAD(i, j) ygrad[(i) + m*(j)]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *xgrad, *ygrad, *boundary, *dist;
    double dxp, dxm, dyp, dym, xns, yns, nrm;
    int m, n, i, j, nn;
    
    /* Check number of outputs */
    if (nlhs < 2)
        mexErrMsgTxt("At least 2 output argument needed.");
    else if (nlhs > 2)
        mexErrMsgTxt("At most 2 output argument needed.");
    
    /* Get inputs */
    if (nrhs < 2)
        mexErrMsgTxt("At least 2 input argument needed.");
    else if (nrhs > 2)
        mexErrMsgTxt("At most 2 input argument used.");
    
    
    
    /* Get boundary */
    if (!mxIsDouble(prhs[0]) || mxIsClass(prhs[0], "sparse"))
        mexErrMsgTxt("Boundary field needs to be a full double precision matrix.");
    
    boundary = mxGetPr(prhs[0]);
    m = mxGetM(prhs[0]);
    n = mxGetN(prhs[0]);
    
    /* Get distance field */
    if (!mxIsDouble(prhs[1]) || mxIsClass(prhs[1], "sparse") || mxGetM(prhs[1]) != m || mxGetN(prhs[1]) != n)
        mexErrMsgTxt("Distance field needs to be a full double precision matrix with same dimension as the boundary.");
    
    dist = mxGetPr(prhs[1]);
    m = mxGetM(prhs[1]);
    n = mxGetN(prhs[1]);
    
    /* create and init output (gradient) matrices */
    plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(m, n, mxREAL);
    xgrad = mxGetPr(plhs[0]);
    ygrad = mxGetPr(plhs[1]);
    
    
    
    for (j = 0; j < n; ++j)
        for (i = 0; i < m; ++i)
            if (INTERIOR(i,j))
            {
                if (i > 0)
                    dxm = INTERIOR(i-1,j) ? DIST(i-1,j) : DIST(i,j);
                else
                    dxm = DIST(i,j);
                
                if (i < m-1)
                    dxp = INTERIOR(i+1,j) ? DIST(i+1,j) : DIST(i,j);
                else
                    dxp = DIST(i,j);
                
                if (j > 0)
                    dym = INTERIOR(i,j-1) ? DIST(i,j-1) : DIST(i,j);
                else
                    dym = DIST(i,j);
                
                if (j < n-1)
                    dyp = INTERIOR(i,j+1) ? DIST(i,j+1) : DIST(i,j);
                else
                    dyp = DIST(i,j);
                
                XGRAD(i, j) = (dxp - dxm) / 2.0;
                YGRAD(i, j) = (dyp - dym) / 2.0;
                nrm = sqrt(XGRAD(i, j)*XGRAD(i, j) + YGRAD(i, j)*YGRAD(i, j));
                if (nrm > 1e-12)
                {
                    XGRAD(i, j) /= nrm;
                    YGRAD(i, j) /= nrm;
                }
            }
            else
            {
                XGRAD(i, j) = 0.0;
                YGRAD(i, j) = 0.0;
            }
    
    for (j = 0; j < n; ++j)
        for (i = 0; i < m; ++i)
            if (!INTERIOR(i, j))
            {
                xns = 0.0;
                yns = 0.0;
                nn = 0;
                if (i > 0 && INTERIOR(i-1,j))
                {
                    xns += XGRAD(i-1,j);
                    yns += YGRAD(i-1,j);
                    ++nn;
                }
                if (i < m-1 && INTERIOR(i+1,j))
                {
                    xns += XGRAD(i+1,j);
                    yns += YGRAD(i+1,j);
                    ++nn;
                }
                if (j > 0 && INTERIOR(i,j-1))
                {
                    xns += XGRAD(i,j-1);
                    yns += YGRAD(i,j-1);
                    ++nn;
                }
                if (j < n-1 && INTERIOR(i,j+1))
                {
                    xns += XGRAD(i,j+1);
                    yns += YGRAD(i,j+1);
                    ++nn;
                }
                
                if (nn > 0)
                {
                    XGRAD(i, j) = xns / nn;
                    YGRAD(i, j) = yns / nn;
                }
            }
}