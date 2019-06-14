 
#include <mex.h>
#include <string.h>
 
#include "tree_build.c"
#include "tree_query.c"
#include "tree_free.c"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    point_t *points;
    tree_t *tree;
    int m, n;
    uchar *data;
    int *root_index;
    
    if (nlhs < 1)
        return;
    
    points = (point_t*) mxGetPr(prhs[0]);
    m = mxGetM(prhs[0]);
    n = mxGetN(prhs[0]);
    
    if (m != 2)
        mexErrMsgTxt("...");
    
    tree = build_tree(points, n);
    
    plhs[0] = mxCreateNumericMatrix(tree->first_free + sizeof(int), 1, mxUINT8_CLASS, mxREAL);
    data = (uchar*) mxGetPr(plhs[0]);
    
    root_index = (int*) data;
    *root_index = tree->root_index;
    memcpy(data + sizeof(int), tree->data, tree->first_free);
    
    free_tree(tree);
}