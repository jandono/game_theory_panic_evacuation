#ifndef TREE_TYPES_H
#define TREE_TYPES_H

typedef unsigned char uchar;

/* 2D point */
typedef struct
{
    double x;
    double y;
} point_t;

/* tree */
typedef struct
{
    /* byte data array with points and nodes */
    uchar *data;

    /* index of first unused byte */
    int first_free;

    /* total number of allocated bytes */
    int total_size;

    /* index of the root node in the data array*/
    int root_index;
} tree_t;

/* node */
typedef struct
{
    /* index of the right child node (left child follows directly after current) */
    int right_idx;

    /* number of associated points */
    int np;

    /* associated x-coordinate value */
    double x_val;
} node_t;

/* range */
typedef struct
{
    /* point index list */
    int *point_idx;

    /* number of saved indices */
    int n;

    /* total number of allocated indices */
    int total_size;

    /* minimum range point */
    point_t min;

    /* maximum range point */
    point_t max;
} range_t;

#endif
