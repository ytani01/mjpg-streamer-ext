#!/bin/sh
#
#

PORT_NUM=9000


#SIZE_X=3280
#SIZE_Y=2464

#SIZE_X=2560
#SIZE_Y=1920

#SIZE_X=1920
#SIZE_X=1440
#SIZE_Y=1080

SIZE_X=1280
SIZE_Y=960

#FPS=30
FPS=5
QUALITY=80

LD_LIBRARY_PATH=/usr/local/lib/mjpg-streamer 
WWW_DIR=/usr/local/share/mjpg-streamer/www

CMD=/usr/local/bin/mjpg_streamer

exec ${CMD} \
  -i "input_raspicam.so -fps ${FPS} -x ${SIZE_X} -y ${SIZE_Y} -vs" \
  -o "output_http.so -p ${PORT_NUM} -w ${WWW_DIR}"
