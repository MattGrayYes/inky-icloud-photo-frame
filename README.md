Currently cobbling this together.

Couldn't find anyone else's project that could do what I want so I'm making my own from bits I've found elsewhere to reduce workload.

## Sources

* `icloud_photo.sh` based on @Uj947nXmRqV2nRaWshKtHzTvckUUpD's comment on @Fay59's [gist](https://gist.github.com/fay59/8f719cd81967e0eb2234897491e051ec?permalink_comment_id=4219612#gistcomment-4219612)
* `process.py` scale function based on this @matteoferla [blog post](https://blog.matteoferla.com/2023/03/7-colour-electronic-paper.html)
* The @pimoroni [Inky Library](https://github.com/pimoroni/inky)

## What it does
AKA what I hope for it to do

### Image library 
1. Download images from icloud shared album
1. Remove images from local cache that are no longer part of the album
1. Process each of those images for quicker display on the eink screen
1. repeat every x interval

### Image Display 
1. loop through processed images, displaying them one by one, in a random order.
1. change image every y interval

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
