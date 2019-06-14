#!/bin/sh

if [ "$#" -lt 1 -o "$#" -gt 4 ]
then
    echo "Usage: $0 <basemame as specified in simulationconfig file> [fps] [ <width> <height> ]"
	exit
fi

BASENAME="$1"
FPS=25
WIDTH=1280
HEIGHT=720

[ "$#" -gt 1 ] && FPS=$2
if [ "$#" -eq 4 ]; then
    WIDTH=$3
    HEIGHT=$4
fi

export WIDTH
export HEIGHT
find ./frames -name "$BASENAME"*.eps -print0 \
	| xargs -0 -n 1 -P 6 sh -c 'convert -density 300x300 "$1" -colorspace RGB \
	-resize "$WIDTH"x"$HEIGHT" -gravity center -extent "$WIDTH"x"$HEIGHT" \
	-quality 98 "${1%eps}jpg"; echo "converting $1"' sh

ffmpeg -i ./frames/"$BASENAME"_%04d.jpg -r "$FPS" -crf 22 -vcodec libx264 -threads 6 ../videos/"$BASENAME".avi
#avconv -i ./frames/"$BASENAME"_%04d.jpg -r "$FPS" -b 100M -threads 6 ../videos/"$BASENAME".avi

