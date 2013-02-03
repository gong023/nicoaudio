#!/bin/bash
ORIGIN=${pwd}
FROM=$1
TO=$2

convertAndExport() {
  for i in $(seq $FROM $TO);
  do
    DAY=$(date --date "$i day ago" "+%Y-%m-%d")
    WORKSPACE=/root/scripts/nicoaudio/video/all/$DAY
    touch $WORKSPACE/audioname.txt
    find $WORKSPACE/*.mp4 >> $WORKSPACE/audioname.txt 
    chmod 777 $WORKSPACE/*.mp4

    while read line
    do
      ffmpeg -i "$line" -ab 128 $line".mp3" < /dev/null
    done <$WORKSPACE/audioname.txt 

    mkdir -p /var/www/html/nicoplay/public/audio/all/$DAY
    mv $WORKSPACE/*.mp3 /var/www/html/nicoplay/public/audio/all/$DAY
    rm -fr $WORKSPACE
    cd /var/www/html/nicoplay/public/audio/all/$DAY
    rename .mp4.mp3 .mp3 *.mp3

    scp -r /var/www/html/nicoplay/public/audio/all/$DAY aws:/var/www/html/nicoplay/public/audio/all
  done;
}

for i in $(seq $FROM $TO);
do
  # 何日かまとめてmp4をとってくる
  tmp=`expr $i % 3`
  if [ $tmp -eq 0 ] || [ $i -eq 0 ] ; then
    let TO=$i+3
    TO_DATE=$(date --date "$i day ago" "+%Y-%m-%d")
    FROM_DATE=$(date --date "$TO day ago" "+%Y-%m-%d")
    cd /var/www/scripts/nicoaudio;
    ./nicofacade.rb --type get --category all --duration $FROM_DATE"~"$TO_DATE
    # 取得したmp4をmp3にして転送する
    convertAndExport
  fi
done;
