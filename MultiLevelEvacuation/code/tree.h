#ifndef TREE_H
#define TREE_H

#include "tree_types.h"

/* build a 2D range tree using the given points */
tree_t* build_tree(point_t *points, int n);

/* query a range tree */
range_t* range_query(tree_t *tree, double x_min, double x_max, double y_min, double y_max);

/* free memory of a tree */
void free_tree(tree_t *tree);

/* free memory of a range */
void free_range(range_t *range);

#endif
