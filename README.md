# iCloud Shared Album photo frame for Pimoroni Inky Impression
Currently cobbling this together. I couldn't find anyone else's project that could do what I want so I'm making my own from bits I've found elsewhere to reduce workload.

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
* clone this repo to a folder
* run `./photo_frame.sh`


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
