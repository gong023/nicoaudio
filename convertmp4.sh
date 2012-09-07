#!/bin/bash
ORIGIN=${pwd}
TYPE=$1
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

mkdir -p /usr/local/nicoaudio/audio/$TYPE/$TODAY
mv $WORKSPACE/*.mp3 /usr/local/nicoaudio/audio/$TYPE/$TODAY

rm audioname.txt
cd $ORIGIN
