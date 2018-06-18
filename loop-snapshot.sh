#!/bin/sh

MYHOST=`hostname`

BINDIR=${HOME}/bin

#IMAGE_DIFF=${BINDIR}/image-diff.sh
IMAGE_DIFF=${BINDIR}/image-diff2.sh

if [ "X$2" = "X" ]; then
  echo "$0 threshold max_data_size(MB)"
  exit 1
fi

THRESHOLD=$1

INTERVAL=1
MAXSIZE=$2

PORT=9000
SVR_URL=http://localhost:9000/?action=snapshot
OUTDIR=${HOME}/tmp/snapshots-${MYHOST}
TMPDIR=/tmp

if [ ! -d ${OUTDIR} ]; then
  mkdir -p ${OUTDIR}
fi

PREV_OUTFILE=`ls -r1 ${OUTDIR}/*/*.jpg | head -1`
echo "PREV_OUTFILE=${PREV_OUTFILE}"

while true; do
  OUTFILE_NAME=`date +%Y%m%d-%H%M%S`.jpg
  OUTFILE_SUBDIR=`echo ${OUTFILE_NAME} | sed 's/....\.jpg//'`
  OUTFILE=${OUTDIR}/${OUTFILE_SUBDIR}/${OUTFILE_NAME}
  TMP_OUTFILE=${TMPDIR}/${OUTFILE_NAME}

  echo "--- OUTFILE_NAME=${OUTFILE_NAME}"

  # get
  echo "wget ${TMP_OUTFILE}"
  wget -O ${TMP_OUTFILE} ${SVR_URL} -o /dev/null
  ls -l ${TMP_OUTFILE}

  if [ "X${PREV_OUTFILE}" != "X" -a -f ${PREV_OUTFILE} ]; then
    if [ -s ${PREV_OUTFILE} ]; then
      # diff
      echo "DIFF ${PREV_OUTFILE} ${TMP_OUTFILE}"
      DIFF=`${IMAGE_DIFF} ${PREV_OUTFILE} ${TMP_OUTFILE} | sed 's/\..*$//'`
      echo "DIFF=${DIFF}"
      if [ ${DIFF} -lt ${THRESHOLD} ]; then
      #if [ ${DIFF} -gt ${THRESHOLD} ]; then
        echo "rm -f ${TMP_OUTFILE}"
        rm -f ${TMP_OUTFILE} &
	sleep 0
        continue
      fi
    else
      echo "${PREV_OUTFILE}: size zero"
      rm -f ${PREV_OUTFILE} &
    fi
  else
    sleep 1
  fi 

  # check data size
  echo "check data size"
  while [ `du -sm ${OUTDIR}/ | sed 's/	.*$//'` -gt ${MAXSIZE} ]; do
    OLDDIR=`ls -1 ${OUTDIR}/ | head -1`
    echo "rm -rf ${OUTDIR}/${OLDDIR}"
    rm -rf "${OUTDIR}/${OLDDIR}"
  done

  # save
  echo "=== save ==="
  if [ ! -d ${OUTDIR}/${OUTFILE_SUBDIR} ]; then
    echo "mkdir ${OUTDIR}/${OUTFILE_SUBDIR}"
    mkdir ${OUTDIR}/${OUTFILE_SUBDIR}
  fi
  echo "mv ${TMP_OUTFILE} ${OUTFILE}"
  mv ${TMP_OUTFILE} ${OUTFILE}
  PREV_OUTFILE=${OUTFILE}

done
