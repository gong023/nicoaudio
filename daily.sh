#!/bin/bash
cd /var/www/scripts/nicoaudio
ruby nicofacade.rb --type set --category all
ruby nicofacade.rb --type set --category music
ruby nicofacade.rb --type get --category all

ORIGIN=${pwd}
TYPE=$1
SAVE=$2
TODAY=$(date '+%Y-%m-%d')
WORKSPACE=/root/scripts/nicoaudio/video/$TYPE/$TODAY

mkdir -p $WORKSPACE
cd $WORKSPACE
touch audioname.txt
find $WORKSPACE/*.mp4 >> $WORKSPACE/audioname.txt
chmod 777 $WORKSPACE/*.mp4

while read line
do
    ffmpeg -i "$line" -ab 128 $line".mp3" < /dev/null
done <$WORKSPACE/audioname.txt

mkdir -p $SAVE/$TYPE/$TODAY
mv $WORKSPACE/*.mp3 $SAVE/$TYPE/$TODAY
cd $SAVE/$TYPE/$TODAY
rename .mp4.mp3 .mp3 *.mp3
scp -r $SAVE/$TYPE/$TODAY aws:/var/www/html/nicoplay/public/audio/all

cd /var/www/scripts/nicoaudio
ruby class/nicorecovery.rb

rm -fr $WORKSPACE/*
cd $ORIGIN
