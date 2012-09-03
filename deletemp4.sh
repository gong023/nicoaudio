#!/bin/bash
DELETE_DATE=$(date -d "$1 days ago" "+%Y-%m-%d")
rm -rf /root/scripts/nicoaudio/video/all/$DELETE_DATE > /dev/null 2>&1
rm -rf /root/scripts/nicoaudio/video/music/$DELETE_DATE > /dev/null 2>&1
rm -rf /usr/local/nicoaudio/audio/all/$DELETE_DATE > /dev/null 2>&1
rm -rf /usr/local/nicoaudio/audio/music/$DELETE_DATE > /dev/null 2>&1
echo $DELETE_DATE
