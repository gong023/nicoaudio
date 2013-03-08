#!/bin/sh
cd /var/www/scripts/nicoaudio
ruby ./app/script/recover.rb --reDownload true

TODAY=$(date "+%Y-%m-%d")
WORKSPACE=/root/scripts/nicoaudio/video/recover/$TODAY
cd $WORKSPACE
find $WORKSPACE/*.mp4 >> $WORKSPACE/audioname.txt
chmod 777 $WORKSPACE/*.mp4

while read line
do
    ffmpeg -i "$line" -ab 128 $line".mp3" < /dev/null
done <$WORKSPACE/audioname.txt

SAVE=/var/www/html/nicoplay/public/audio/all/$TODAY
mv $WORKSPACE/*.mp3 $SAVE
cd $SAVE
rename .mp4.mp3 .mp3 *.mp3
scp $SAVE/* aws:$SAVE

cd /var/www/scripts/nicoaudio
ruby ./app/script/recover.rb --checkExists true
