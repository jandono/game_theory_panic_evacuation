 
#include <mex.h>
#include <string.h>
 
#include "tree_build.c"
#include "tree_query.c"
#include "tree_free.c"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    tree_t *tree;
    int n, i;
    int *point_idx, *root_idx;
    range_t *range;
    uchar *data;
    
    if (nlhs != 1)
        mexErrMsgTxt("...");
    
    if (nrhs < 5)
        mexErrMsgTxt("...");
    else if (nrhs > 5)
        mexErrMsgTxt("...");
    
    data = (uchar*) mxGetPr(prhs[0]);
    
    tree = (tree_t*) malloc(sizeof(tree_t));
    tree->first_free = mxGetM(prhs[0]) - sizeof(int);
    tree->total_size = tree->first_free;
    root_idx = (int*) data;
    tree->root_index = *root_idx;
    tree->data = data + sizeof(int);
    
    n = mxGetN(prhs[0]);
    if (n != 1)
        mexErrMsgTxt("...");
    
    range = range_query(tree, *mxGetPr(prhs[1]), *mxGetPr(prhs[2]), *mxGetPr(prhs[3]), *mxGetPr(prhs[4]));
    
    plhs[0] = mxCreateNumericMatrix(range->n, 1, mxUINT32_CLASS, mxREAL);
    point_idx = (int*) mxGetPr(plhs[0]);
    
    for (i = 0; i < range->n; ++i)
        point_idx[i] = range->point_idx[i] + 1;
    
    free_range(range);
    free(tree);
}