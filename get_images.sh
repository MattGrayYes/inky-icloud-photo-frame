#!/bin/bash

if [ ! -f get_images.conf ]; then
    echo "get_images.conf config file not found."
    echo "please create it and put ICLOUD_URL=\"<url to icloud shared album webpage>\" on the first line"
    exit
fi

source get_images.conf

if [[ -z "$ICLOUD_URL" || $ICLOUD_URL == *"REDACTED"* || $ICLOUD_URL == *"webpage"* ]]; then
    echo "please edit get_images.conf to have ICLOUD_URL=\"<url to icloud shared album webpage>\" on the first line"
    exit
else
    echo "using iCloud URL:"
    echo $ICLOUD_URL
fi


source ~/.virtualenvs/pimoroni/bin/activate

./icloud_photo.sh $ICLOUD_URL ./images/icloud/
./process.py --infolder ./images/icloud/ --outfolder ./images/processed/
ls -l ./images/processed/
