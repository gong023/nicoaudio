#!/bin/bash
ORIGIN=${pwd}
WORKSPACE=/root/scripts/nicoaudio
cd $WORKSPACE/video
touch audioname.txt 
find $WORKSPACE/video/*.mp4 >> audioname.txt 
chmod 777 $WORKSPACE/video/*.mp4

MP3=".mp3"
while read line
do
    echo "$line$MP3"
    ffmpeg -i "$line" -ab 128 "$line$MP3" < /dev/null
done <$WORKSPACE/video/audioname.txt 

mkdir -p /usr/local/nicoaudio/audio
mv $WORKSPACE/video/*.mp3 /usr/local/nicoaudio/audio/

rm audioname.txt
cd $ORIGIN
