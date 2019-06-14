 
#include <mex.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int m, n, i0, i1, j0, j1, idx00;
    double *data, *out, x, y, wx0, wy0, wx1, wy1;
    double d00, d01, d10, d11;
    
    if (nlhs < 1)
        return;
    else if (nlhs > 1)
        mexErrMsgTxt("Exactly one output argument needed.");
    
    if (nrhs != 3)
        mexErrMsgTxt("Exactly three input arguments needed.");
    
    m = mxGetM(prhs[0]);
    n = mxGetN(prhs[0]);
    data = mxGetPr(prhs[0]);
    x = *mxGetPr(prhs[1]) - 1;
    y = *mxGetPr(prhs[2]) - 1;
    
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    out = mxGetPr(plhs[0]);
    
    x = x < 0 ? 0 : x > m - 1 ? m - 1 : x;
    y = y < 0 ? 0 : y > n - 1 ? n - 1 : y;
    i0 = (int) x;
    j0 = (int) y;
    i1 = i0 + 1;
    i1 = i1 > m - 1 ? m - 1 : i1;
    j1 = j0 + 1;
    j1 = j1 > n - 1 ? n - 1 : j1;
    
    idx00 = i0 + m * j0;
    d00 = data[idx00];
    d01 = data[idx00 + m];
    d10 = data[idx00 + 1];
    d11 = data[idx00 + m + 1];
    
    wx1 = x - i0;
    wy1 = y - j0;
    wx0 = 1.0 - wx1;
    wy0 = 1.0 - wy1;
    
    *out = wx0 * (wy0 * d00 + wy1 * d01) + wx1 * (wy0 * d10 + wy1 * d11);
}