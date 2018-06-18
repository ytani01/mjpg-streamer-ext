#!/bin/sh

MYNAME=`basename $0`

BINDIR=${HOME}/bin
LOGFILE=${HOME}/tmp/${MYNAME}.log

echo_and_bg () {
    CMDLINE=$*
    echo ${CMDLINE}
    ${CMDLINE} &
}

date

# pigpio
if [ X`pgrep pigpiod` = X ]; then
    echo pigpiod
    sudo pigpiod
fi


# 
CMD=${BINDIR}/mjpg-streamer.sh
echo ${CMD}
while [ X`pgrep mjpg_streamer` = X ]; do
    if [ -x ${CMD} ]; then
	echo_and_bg ${CMD}
        sleep 5
    fi
done

#
CMD=${BINDIR}/loop-snapshot.sh
echo ${CMD}
if [ "X`pgrep loop-snapshot`" = "X" ]; then
    if [ -x ${CMD} ]; then
	#echo_and_bg ${CMD} 20 1000
	echo_and_bg ${CMD} 5 2000
    fi
fi
