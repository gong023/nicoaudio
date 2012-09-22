#!/bin/bash
ORIGIN=${pwd}
TYPE=$1
SAVE=$2
TODAY=$(date '+%Y-%m-%d')
WORKSPACE=/root/scripts/nicoaudio/video/$TYPE/$TODAY

cd $WORKSPACE
touch audioname.txt 
find $WORKSPACE/*.mp4 >> audioname.txt 
chmod 777 $WORKSPACE/*.mp4

MP3=".mp3"
while read line
do
    ffmpeg -i "$line" -ab 128 "$line$MP3" < /dev/null
done <$WORKSPACE/audioname.txt 

mkdir -p $SAVE/$TYPE/$TODAY
mv $WORKSPACE/*.mp3 $SAVE/$TYPE/$TODAY

rm audioname.txt
cd $ORIGIN
