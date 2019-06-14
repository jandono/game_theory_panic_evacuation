
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "tree_query.h"

#define LEFT_CHILD_IDX(node_idx, node)  (node_idx) + sizeof(node_t) + (node)->np * sizeof(int)
#define RIGHT_CHILD_IDX(node_idx, node) (node)->right_idx
#define NODE_FROM_IDX(tree, node_idx)   (node_t*) &(tree)->data[node_idx];

range_t* range_query(tree_t *tree, double x_min, double x_max, double y_min, double y_max)
{
    int split_node_idx, node_idx;
    node_t *split_node, *node;
    range_t *range;

    /* init range */
    range = (range_t*) malloc(sizeof(range_t));
    range->min.x = x_min;
    range->max.x = x_max;
    range->min.y = y_min;
    range->max.y = y_max;
    range->n = 0;
    range->total_size = 16;
    range->point_idx = (int*) malloc(range->total_size * sizeof(int));

    /* find split node */
    split_node_idx = find_split_node(tree, tree->root_index, range);
    split_node = NODE_FROM_IDX(tree, split_node_idx);
    
    /* if split node is a child */
    if (split_node->right_idx == -1)
    {
        range_query_y(tree, split_node_idx, range);
        return range;
    }

    /* follow left path of the split node */
    node_idx = LEFT_CHILD_IDX(split_node_idx, split_node);
    node = NODE_FROM_IDX(tree, node_idx);
    while (node->right_idx != -1)
    {
        if (range->min.x <= node->x_val)
        {
            range_query_y(tree, RIGHT_CHILD_IDX(node_idx, node), range);
            node_idx = LEFT_CHILD_IDX(node_idx, node);
        }
        else
            node_idx = RIGHT_CHILD_IDX(node_idx, node);
        node = NODE_FROM_IDX(tree, node_idx);
    }
    range_query_y(tree, node_idx, range);

    /* follow right path of the split node */
    node_idx = split_node->right_idx;
    node = NODE_FROM_IDX(tree, node_idx);
    while (node->right_idx != -1)
    {
        if (range->max.x > node->x_val)
        {
            range_query_y(tree, LEFT_CHILD_IDX(node_idx, node), range);
            node_idx = RIGHT_CHILD_IDX(node_idx, node);
        }
        else
            node_idx = LEFT_CHILD_IDX(node_idx, node);
        node = NODE_FROM_IDX(tree, node_idx);
    }
    range_query_y(tree, node_idx, range);

    return range;
}

void range_append(range_t *range, int idx)
{
    int *new_point_idx;
    int new_size, i;

    /* just append if there is enough place, otherwise double capacity and append */
    if (range->n < range->total_size)
        range->point_idx[range->n++] = idx;
    else
    {
        new_size = range->total_size << 1;
        new_point_idx = (int*) malloc(new_size * sizeof(int));
        for (i = 0; i < range->n; ++i)
            new_point_idx[i] = range->point_idx[i];
        new_point_idx[range->n++] = idx;
        free(range->point_idx);
        range->point_idx = new_point_idx;
        range->total_size = new_size;
    }
}

int find_split_node(tree_t *tree, int node_idx, range_t *range)
{
    node_t *node;

    node = (node_t*) &tree->data[node_idx];
    /* check if this node is the split node */
    if (range->min.x <= node->x_val && range->max.x > node->x_val)
        return node_idx;

    /* ...or if it is a child (and therefor the split node) */
    if (node->right_idx == -1)
        return node_idx;

    /* otherwise search the split node at the left or right of the current node */
    if (range->max.x <= node->x_val)
        return find_split_node(tree, LEFT_CHILD_IDX(node_idx, node), range);
    else
        return find_split_node(tree, RIGHT_CHILD_IDX(node_idx, node), range);
}

void range_query_y(tree_t *tree, int node_idx, range_t *range)
{
    point_t *points;
    double y;
    int i, j, k, m, start, end;
    int *point_idx;
    node_t *node;

    node = (node_t*) &tree->data[node_idx];
    points = (point_t*) tree->data;
    point_idx = (int*) (node + 1);

    /* return if all points are outside the range */
    if (points[point_idx[0]].y > range->max.y || points[point_idx[node->np - 1]].y < range->min.y)
        return;

    /* binary search for lower end of the range */
    y = range->min.y;
    j = 0;
    k = node->np - 1;
    while (j != k)
    {
        m = (j + k) / 2;
        if (points[point_idx[m]].y >= y)
            k = m;
        else
            j = m + 1;
    }
    start = j;

    /* binary search for higher end of the range */
    y = range->max.y;
    j = 0;
    k = node->np - 1;
    while (j != k)
    {
        m = (j + k + 1) / 2;
        if (points[point_idx[m]].y > y)
            k = m - 1;
        else
            j = m;
    }
    end = j;

    /* append found points to the range */
    for (i = start; i <= end; ++i)
        if (points[point_idx[i]].x <= range->max.x)
            range_append(range, point_idx[i]);
        
}
