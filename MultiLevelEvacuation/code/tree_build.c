
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tree_build.h"

tree_t* build_tree(point_t *points, int n)
{
    int nx, i, j, *point_idx;
    double *x_vals;
    tree_t *tree;

    /* get x coordinate values of all points */
    x_vals = (double*) malloc(n * sizeof(double));
    for (i = 0; i < n; ++i)
        x_vals[i] = points[i].x;

    /* sort x values */
    qsort(x_vals, n, sizeof(double), compare_double);
    
    /* count number of unique x values */
    nx = 1;
    for (i = 1; i < n; ++i)
        if (x_vals[i] != x_vals[i - 1])
            ++nx;

    /* remove duplicates */
    j = 0;
    for (i = 0; i < nx; ++i)
    {
        x_vals[i] = x_vals[j];
        while (x_vals[i] == x_vals[j])
            ++j;
    }

    /* create an index array */
    point_idx = (int*) malloc(n * sizeof(int));
    for (i = 0; i < n; ++i)
        point_idx[i] = i;

    /* sort index array by y coordinates of associated points */
    index_sort_y(points, point_idx, n);

    /* init tree */
    tree = (tree_t*) malloc(sizeof(tree_t));
    tree->total_size = n * sizeof(point_t);
    tree->data = (uchar*) malloc(tree->total_size);

    /* copy point coordinates to tree data */
    memcpy(tree->data, points, n * sizeof(point_t));

    /* set first free byte and root index of the tree */
    tree->first_free = n * sizeof(point_t);
    tree->root_index = tree->first_free;
   
    /* recursively build tree */
    build_subtree(tree, x_vals, nx, points, point_idx, n);

    /* free temporaries */
    free(x_vals);
    return tree;
}


int build_subtree(tree_t *tree, double *x_vals, const int nx, point_t *points, int *point_idx, const int np)
{
    int i, j, k, nx_left, np_left, node_size, right_idx;
    node_t *node;
    int *node_point_idx, *point_idx_left, *point_idx_right, node_idx;
    uchar *new_data;

    assert(nx > 0);
    assert(np > 0);

    /* allocate memory in the tree data structure */
    node_size = sizeof(node_t) + np * sizeof(int);
    while (tree->first_free + node_size > tree->total_size)
    {
        tree->total_size <<= 1;
        new_data = (uchar*) malloc(tree->total_size * sizeof(uchar));
        for (i = 0; i < tree->first_free; ++i)
            new_data[i] = tree->data[i];
        free(tree->data);
        tree->data = new_data;
    }
    node_idx = tree->first_free;
    node = (node_t*) &tree->data[node_idx];
    tree->first_free += node_size;
    
    /* set number of stored points */
    node->np = np;
    node_point_idx = (int*) (node + 1);

    /* copy point indices to node */
    memcpy(node_point_idx, point_idx, np * sizeof(int));

    /* create child node if there is only one x value left, otherwise create interior node */
    if (nx == 1)
    {
        node->right_idx = -1;
        node->x_val = x_vals[0];
    }
    else
    {
        /* get median of x values */
        nx_left = nx >> 1;
        node->x_val = x_vals[nx_left - 1];

        /* count points belonging to the left child */
        np_left = 0;
        for (i = 0; i < np; ++i)
        {
            if (points[point_idx[i]].x <= node->x_val)
                ++np_left;
        }

        /* allocate memory for children's index arrays */
        point_idx_left = (int*) malloc(np_left * sizeof(int));
        point_idx_right = (int*) malloc((np - np_left) * sizeof(int));

        /* fill index arrays */
        j = 0;
        k = 0;
        for (i = 0; i < np; ++i)
        {
            if (points[point_idx[i]].x <= node->x_val)
                point_idx_left[j++] = point_idx[i];
            else
                point_idx_right[k++] = point_idx[i];
        }

        /* free current node's temporary index array */
        free(point_idx);

        /* build left subtree */
        build_subtree(tree, x_vals, nx_left, points, point_idx_left, np_left);
        
        /* build right subtree and get its root node index */
        right_idx = build_subtree(tree, x_vals + nx_left, nx - nx_left, points, point_idx_right, np - np_left);
        /* update node pointer (could have changed during build_subtree, because of data allocation) */
        node = (node_t*) &tree->data[node_idx];
        /* update node's right child index */
        node->right_idx = right_idx;
    }

    /* return node index to parent */
    return node_idx;
}

int compare_double(const void *a, const void *b)
{
    double ad, bd;
    ad = *((double*) a);
    bd = *((double*) b);
    return (ad < bd) ? -1 : (ad > bd) ? 1 : 0;
}

void index_sort_y(const point_t *points, int *point_idx, const int n)
{
    index_quicksort_y(points, point_idx, 0, n - 1);
}

void index_quicksort_y(const point_t *points, int *point_idx, int l, int r)
{
    int p;

    /* quicksort point indices by point y coordinates, don't touch point array itself */
    while (l < r)
    {
        p = index_partition_y(points, point_idx, l, r);
        if (r - p > p - l)
        {
            index_quicksort_y(points, point_idx, l, p - 1);
            l = p + 1;
        }
        else
        {
            index_quicksort_y(points, point_idx, p + 1, r);
            r = p - 1;
        }
    }
}

int index_partition_y(const point_t *points, int *point_idx, int l, int r)
{
    int i, j, tmp;
    double pivot;

    /* rightmost element is pivot */
    i = l;
    j = r - 1;
    pivot = points[point_idx[r]].y;

    /* quicksort partition */
    do
    {
        while (points[point_idx[i]].y <= pivot && i < r)
            ++i;

        while (points[point_idx[j]].y >= pivot && j > l)
            --j;

        if (i < j)
        {
            tmp = point_idx[i];
            point_idx[i] = point_idx[j];
            point_idx[j] = tmp;
        }
    } while (i < j);

    if (points[point_idx[i]].y > pivot)
    {
        tmp = point_idx[i];
        point_idx[i] = point_idx[r];
        point_idx[r] = tmp;
    }

    return i;
}
