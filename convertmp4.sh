#!/bin/bash
ORIGIN=${pwd}
chmod 777 /root/scripts/php/video/*
cd /root/scripts/php/video
touch audioname.txt 
find /root/scripts/php/video/*.mp4 >> audioname.txt 

mkdir -p /usr/local/nicoaudio
MP3=".mp3"
while read line
do
    echo "$line$MP3"
    ffmpeg -i "$line" -ab 128 "$line$MP3" < /dev/null
done </root/scripts/php/video/audioname.txt 

mv /root/scripts/php/video/*.mp3 /usr/local/nicoaudio 
rm audioname.txt
cd $ORIGIN
