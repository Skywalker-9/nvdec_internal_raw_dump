# nvdec_internal_raw_dump
Gstreamer bad plugin nvdec has video/x-raw(memory:GLMemory) , this change dumps raw file locally.

$ make && sudo mv .libs/libgstnvdec.so /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstnvdec.so

Sample Commands : 

$ gst-launch-1.0 filesrc location= ~/sample_720p.mp4 ! qtdemux ! h264parse ! nvdec ! fakesink

Above command dumps GRAY8 output for first 50 frames, playback using below command

$ gst-launch-1.0 filesrc location= ./nvdec_filedump_1280x720.yuv ! videoparse width=1280 height=720 format=gray8 ! videoconvert ! nveglglessink
