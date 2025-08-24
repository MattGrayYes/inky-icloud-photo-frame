#!/bin/bash

if [ ! -f photo_frame.conf ]; then
    echo "photo_frame.conf config file not found."
    echo "please create it and put ICLOUD_URL=\"<url to icloud shared album webpage>\" on the first line"
    exit
fi

source photo_frame.conf

if [[ -z "$ICLOUD_URL" || $ICLOUD_URL == *"REDACTED"* || $ICLOUD_URL == *"webpage"* ]]; then
    echo "please edit photo_frame.conf to have ICLOUD_URL=\"<url to icloud shared album webpage>\" on the first line"
    exit
else
    echo "using iCloud URL:"
    echo $ICLOUD_URL
fi

if [[ -z "$IMAGES_FOLDER" ]]; then
    IMAGES_FOLDER="./images"
    echo "IMAGES_FOLDER not set in get_images.conf, defaulting to $IMAGES_FOLDER"
else
    echo "using IMAGES_FOLDER of $IMAGES_FOLDER"
fi

source ~/.virtualenvs/pimoroni/bin/activate

./icloud_photo.sh $ICLOUD_URL $IMAGES_FOLDER/icloud/
./process.py --infolder $IMAGES_FOLDER/icloud/ --outfolder $IMAGES_FOLDER/processed/
ls -l $IMAGES_FOLDER/processed/
