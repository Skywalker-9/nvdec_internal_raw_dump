#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: decPerf.sh <file> <num-instances>"
  exit 0
fi

FILE=$1
NUM_INSTANCES=$2

if [ ! -f "$FILE" ]; then
  echo "Error: Input file '$FILE' not found"
  exit 0
fi

NUM_FRAMES=$(gst-launch-1.0 filesrc location="$FILE" ! qtdemux ! h264parse ! nvv4l2decoder ! fakesink silent=0 -v 2>&1 | grep chain | wc -l)

echo "Frames in file: $NUM_FRAMES"
echo "Running $NUM_INSTANCES decode instances in parallel"

CMD="time gst-launch-1.0"
for i in `seq $NUM_INSTANCES` ; do
  CMD="$CMD filesrc location=$FILE ! qtdemux ! h264parse ! nvv4l2decoder ! fakesink"
done

OUTPUT="$(eval $CMD 2>&1)"
if echo "$OUTPUT" | grep -i error ; then
  exit 0
fi

TIME=$(echo "$OUTPUT" | grep ended | awk '{print $NF}')
echo "Total time taken $TIME"
SEC=$(echo $TIME | awk -F':' '{print $NF}')
MIN=$(echo $TIME | awk -F':' '{print $2}')
HR=$(echo $TIME | awk -F':' '{print $1}')
TIME_SEC=$(echo "scale=3; ($HR * 3600) + ($MIN * 60) + ($SEC)" | bc)
FPS=$(echo "scale=3; ($NUM_INSTANCES * $NUM_FRAMES) / $TIME_SEC" | bc)
echo "Total decode FPS = $FPS"

