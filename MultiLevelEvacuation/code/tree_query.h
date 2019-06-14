#ifndef TREE_QUERY_H
#define TREE_QUERY_H

#include "tree_types.h"

/* appends a point-index to a range, icnreases range capacity if needed */
void range_append(range_t *range, int idx);

/* finds the split node of a given query */
int find_split_node(tree_t *tree, int node_idx, range_t *range);

/* query the points of a node by a given range by y-coordinate */
void range_query_y(tree_t *tree, int node_idx, range_t *range);

#endif
