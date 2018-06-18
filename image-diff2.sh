#!/bin/sh

DIFF_FILE=/tmp/image-diff.jpg
#DIFF_FILE=image-diff.jpg

if [ "X$2" = "X" ]; then
  echo "$0 jpg1 jpg2"
  exit 1
fi

#composite -compose difference $1 $2 ${DIFF_FILE}
#identify -format "%[mean]" ${DIFF_FILE}
#compare -metric PSNR $1 $2 ${DIFF_FILE} 2>&1
#echo

SIZE1=`ls -s $1 | cut -f 1 -d ' '`
SIZE2=`ls -s $2 | cut -f 1 -d ' '`
SIZE_DIFF=`expr ${SIZE1} - ${SIZE2} | sed 's/^\-//'`
echo ${SIZE_DIFF}

