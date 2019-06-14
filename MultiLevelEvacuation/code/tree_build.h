#ifndef TREE_BUILD_H
#define TREE_BUILD_H

#include "tree.h"

/* recursively build a subtree */
int build_subtree(tree_t *tree, double *x_vals, const int nx, point_t *points, int *point_idx, const int np);

/* double comparison for qsort */
int compare_double(const void *a, const void *b);

/* index array sorting functions, sort point index array by point y coordinates */
void index_sort_y(const point_t *points, int *point_idx, const int n);
void index_quicksort_y(const point_t *points, int *point_idx, int l, int r);
int index_partition_y(const point_t *points, int *point_idx, int l, int r);

#endif
