mex 'fastSweeping.c'
mex 'getNormalizedGradient.c'
mex -O CFLAGS="\$CFLAGS -std=c99" 'lerp2.c'
mex -O CFLAGS="\$CFLAGS -std=c99" 'createRangeTree.c'
mex -O CFLAGS="\$CFLAGS -std=c99" 'rangeQuery.c'
