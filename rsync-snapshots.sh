#!/bin/sh

MYHOST=`hostname`

SRC_DIR="${HOME}/tmp/snapshots-${MYHOST}"
#DST_DIR="/common/myhost/tmp"
DST_DIR="ytani@ssh.ytani.net:./tmp"
RSYNC_OPT="-avt --remove-source-files -e ssh"


echo ${SRC_DIR} to ${DST_DIR}
rsync ${RSYNC_OPT} ${SRC_DIR} ${DST_DIR}


#clean
echo '========== Clean up dirs =========='

DIRS=`echo ${SRC_DIR}/*`
if [ "${DIRS}" = ${SRC_DIR}'/*' ]; then
    echo ${DIRS}
    exit 0
fi

for d in ${DIRS}; do
    echo $d
    if [ X`ls $d` = X ]; then
	echo "remove directory: $d"
	rmdir $d
    fi
done
