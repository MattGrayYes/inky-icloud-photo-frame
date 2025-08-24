#!/bin/bash
echo -e "\033[7m"
echo "┌─────────────────────── ⋆⋅☆⋅⋆ ───────────────────────┐"
echo -e "│   \033[1miCloud Photo Frame for Pimoroni Inky Impression\033[0m\033[7m   │"
echo -e "│   Matt Gray                                         │"
echo -e "│   \033[2mmattg.co.uk @MattGrayYES\033[0m\033[7m                          │"
echo "└─────────────────────────────────────────────────────┘"
echo -e "\033[0m"

if [ ! -f photo_frame.conf ]; then
    echo "photo_frame.conf config file not found."
    echo "please create it and put ICLOUD_URL=\"<url to icloud shared album webpage>\" on the first line"
    exit
fi

echo -e "\033[1mLoading settings\033[0m"

source photo_frame.conf

if [[ -z "$DISPLAY_TIME" ]]; then
    DISPLAY_TIME=1800
    echo "DISPLAY_TIME not set in photo_frame.conf, defaulting change images every $DISPLAY_TIME seconds"
else
    echo "Changing images every $DISPLAY_TIME seconds"
fi

if [[ -z "$IMAGES_FOLDER" ]]; then
    IMAGES_FOLDER="./images"
    echo "IMAGES_FOLDER not set in photo_frame.conf, defaulting get images from: $IMAGES_FOLDER"
else
    echo "Getting images from: $IMAGES_FOLDER"
fi

echo ""

echo -e "\033[1mChecking for pimoroni inky library\033[0m"

if [ ! -d ~/.virtualenvs/pimoroni/bin/ ]; then
    echo "Pimoroni inky library not installed, or virtualenv not found."
    echo -e "Please install the inky library from \033[1mhttps://github.com/pimoroni/inky\033[0m\n"
    exit
else
    source ~/.virtualenvs/pimoroni/bin/activate
fi


while :
do
    echo "\n\033[1mChecking iCloud Album and processing images\033[0m"
    echo -e "\n\033[7mGetting Images\033[0m"
    ./get_images.sh | sed 's/^/| /'

    echo -e "\n\033[7mRunning Image Looper\033[0m"
    ./image_looper.py --infolder $IMAGES_FOLDER/processed/ --time $DISPLAY_TIME | sed 's/^/| /'
done