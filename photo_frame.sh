#!/bin/bash

if [ ! -f photo_frame.conf ]; then
    echo "photo_frame.conf config file not found."
    echo "please create it and put ICLOUD_URL=\"<url to icloud shared album webpage>\" on the first line"
    exit
fi

source photo_frame.conf

if [[ -z "$DISPLAY_TIME" ]]; then
    DISPLAY_TIME=1800
    echo "DISPLAY_TIME not set in photo_frame.conf, defaulting to $DISPLAY_TIME seconds"
else
    echo "using DISPLAY_TIME of $DISPLAY_TIME seconds"
fi

if [[ -z "$IMAGES_FOLDER" ]]; then
    IMAGES_FOLDER="./images"
    echo "IMAGES_FOLDER not set in photo_frame.conf, defaulting to $IMAGES_FOLDER"
else
    echo "using IMAGES_FOLDER of $IMAGES_FOLDER"
fi

source ~/.virtualenvs/pimoroni/bin/activate

echo "Checking iCloud Album and processing images"

./get_images.sh

./image_looper.py --infolder $IMAGES_FOLDER/processed/ --time $DISPLAY_TIME
