
#include <stdlib.h>

#include "tree.h"

void free_tree(tree_t *tree)
{
    free(tree->data); 
}

void free_range(range_t *range)
{
    free(range->point_idx);
}
