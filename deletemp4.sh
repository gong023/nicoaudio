#!/bin/bash
DATE=$(date -d "$1 days ago" "+%Y-%m-%d")
DELETE=$2
rm -rf /root/scripts/nicoaudio/video/all/$DATE > /dev/null 2>&1
rm -rf /root/scripts/nicoaudio/video/music/$DATE > /dev/null 2>&1
rm -rf $DELETE/all/$DATE > /dev/null 2>&1
rm -rf $DELETE/music/$DATE > /dev/null 2>&1
echo $DELETE_DATE
