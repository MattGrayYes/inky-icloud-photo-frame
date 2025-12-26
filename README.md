# iCloud Shared Album photo frame for Pimoroni Inky Impression
Currently cobbling this together. I couldn't find anyone else's project that could do what I want so I'm making my own from bits I've found elsewhere to reduce workload.

## What you need
* An iCloud Shared Photo Album with Public Website enabled
  * You can create these in the Photos app on Apple devices: [iPhone / iPad](https://support.apple.com/en-gb/108314) / [Mac](https://support.apple.com/en-gb/124160), or on [iCloud for Windows](https://support.apple.com/en-gb/guide/icloud-windows/icwe010db4bc/icloud).
  * Enabling Public Website is described in the "Inviting More People" section.
* Raspberry Pi, I used a [Raspberry Pi Zero 2W](https://shop.pimoroni.com/products/raspberry-pi-zero-2-w?variant=42101934587987)
* [Pimoroni Inky Impression Spectra 7.3" ePaper Display](https://shop.pimoroni.com/products/inky-impression-7-3?variant=55186435244411)
* [Ikea Rodalm Frame 130x180mm](https://www.ikea.com/gb/en/p/roedalm-frame-black-10548867/)
* [3D-Printed mount and bracket](https://makerworld.com/en/models/2050481-inky-impression-mount-for-ikea-rodlam-w-back-plate#profileId-2212933)

## What it does
### Image library 
1. Download images from icloud shared album
1. Remove images from local cache that are no longer part of the album
1. Process each of those images for quicker display on the eink screen

### Image Display 
1. Check iCloud album for changes, then download and process new images.
1. loop through processed images, displaying them one by one, in a random order.
   * change image every DISPLAY_TIME seconds
1. GOTO 1.

## What it doesn't do
### Bonus Features
* Overlay clock in bottom left corner
    * display the minute-tens in full size, and minute-units smaller and only update every 5m?
    * do partial screen updates for the minutes?

## Installation
Who knows what's required to make this work but here's some idea of what I've done

* Raspberry Pi OS Bookworm 64 full GUI version
* in raspi-config, set to boot into console rather than gui
* install inky library as per [getting started guide](https://learn.pimoroni.com/article/getting-started-with-inky-impression)
    * my bash script that runs the process starts by loading the pimoroni virtualenv which is set up by this installer.
* clone this repo to a folder, or download and unzip the repo into a folder
* Create a config file `cp photo_frame.config.example photo_frame.config`
* Edit the config file
* run `./photo_frame.sh`

### Auto-run with Systemd
1. run the above and watch the output to make sure it works fine.
2. Create service file`sudo vim /etc/systemd/system/photo_frame.service`
3. Add the following to configure it
    ```
    [Unit]
    Description=Photo Frame
    After=network-online.target
    
    [Service]
    User=YOUR_USERNAME
    Type=exec
    WorkingDirectory=THE_FOLDER_WHERE_THIS_CODE_IS
    ExecStart=/bin/bash THE_FOLDER_WHERE_THIS_CODE_IS/photo_frame.sh
    Restart=on-failure
    RestartSec=60

    [Install]
    WantedBy=multi-user.target
    ```
4. Start the service: `sudo systemctl start photo_frame.service`
5. Monitor the service live as it runs `journalctl --follow --unit=photo_frame.service --lines=20`
6. Take a sneak peek at the service `systemctl status photo_frame.service`
7. If it all looks fine, enable the service `sudo systemctl enable photo_frame.service`
8. Reboot `sudo reboot`
9. log back in and see if it's running `systemctl status photo_frame.service`

### Add Extra WiFi network
If it's going to need to connect to a different wifi network to the one you've used for setup, you can add details of another wifi network in advance while you're sshed in, without it kicking you off the one you're currently on. This will save the wifi password in plaintext along with the other connection info in /etc/NetworkManager/system-connections/
```
nmcli connection add \
    type wifi \
    wifi.ssid "SSID" \
    wifi-sec.key-mgmt wpa-psk \
    wifi-sec.psk "KEY"
```
(The slashes here are just escaping the newlines I've added for clarity. You can enter it all on one line, omitting the slashes.)

`nmcli connection add  type wifi  wifi.ssid "SSID"  wifi-sec.key-mgmt wpa-psk  wifi-sec.psk "KEY"`


## Sources
* `icloud_photo.sh` based on a comment on [@Fay59's gist](https://gist.github.com/fay59/8f719cd81967e0eb2234897491e051ec?permalink_comment_id=4219612#gistcomment-4219612)
* `process.py` scale function based on this [@matteoferla blog post](https://blog.matteoferla.com/2023/03/7-colour-electronic-paper.html)
* The @pimoroni [Inky Library](https://github.com/pimoroni/inky)


## CLI Output Example
```
(pimoroni) $ ./photo_frame.sh 

┌─────────────────────── ⋆⋅☆⋅⋆ ───────────────────────┐
│   iCloud Photo Frame for Pimoroni Inky Impression   │
│   Matt Gray                                         │
│   mattg.co.uk @MattGrayYES                          │
└─────────────────────────────────────────────────────┘

Loading settings
Changing images every 1800 seconds
Getting images from: ./images

Checking for pimoroni inky library

Getting Images
│ using iCloud URL:
│ https://www.icloud.com/sharedalbum/[REDACTED]
│ using IMAGES_FOLDER of ./images
│ 
│ iCloud Photo Downloader
│ │ Connecting to iCloud Shared Album
│ │ Matt Gray: Inky Photo Frame
│ │ 
│ │ Total Downloads: 4
│ │ Unique Downloads: 4
│ │ 
│ │ Ignoring: IMG_3501.JPG
│ │ Ignoring: IMG_3863.JPG
│ │ Ignoring: IMG_0507.JPG
│ │ 
│ │ Checking for unexpected files in download directory
│ │ iCloud Photo Downloader Finished
│ 
│ Processing Images
│ │ Detected Spectra 6 7.3 800 x 480 (E673)
│ │ Input: images/icloud/
│ │ Output: images/processed/
│ │ No new images to process

Images Satus
│ ./images:
│ icloud
│ processed
│ 
│ ./images/icloud:
│ IMG_0507.JPG
│ IMG_3501.JPG
│ IMG_3863.JPG
│ 
│ ./images/processed:
│ IMG_0507.JPG.png
│ IMG_3501.JPG.png
│ IMG_3863.JPG.png

Running Image Looper

```
