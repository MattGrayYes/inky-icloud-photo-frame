#!/usr/bin/env python3

import argparse
import pathlib
import sys
import os
from pprint import pprint
from warnings import warn

from PIL import Image

from inky.auto import auto

parser = argparse.ArgumentParser()

parser.add_argument("--saturation", "-s", type=float, default=0.5, help="Colour palette saturation")
parser.add_argument("--infolder", "-i", type=pathlib.Path, help="Input folder")
parser.add_argument("--outfolder", "-o", type=pathlib.Path, help="Output folder")
parser.add_argument("--show", action='store_true')

inky = auto(ask_user=True, verbose=True)

args, _ = parser.parse_known_args()

saturation = args.saturation

if not (args.infolder and args.outfolder):
    print(f"""Usage:
    {sys.argv[0]} --infolder ./images/icloud/ --outfolder ./images/processed/ (--saturation 0.5)""")
    sys.exit(1)

print(f"Input: {args.infolder}/Example.png")
print(f"Output: {args.outfolder}/Example.png")

def scale(image: Image, target_width=800, target_height=480) -> Image:
    """
    Given an Pillow image and the two dimensions scale it, 
    cropping centrally if required.
    """
    width, height = image.size
    if height/width < target_height/target_width:
        warn('too wide: cropping')
        new_height = target_height
        new_width = int(width * new_height / height)
    else:
        warn('too tall: cropping')
        new_width = target_width
        new_height = int(height * new_width / width)
    print(height, width, target_height, target_width, new_height, new_width)
    # Image.ANTIALIAS is depracated --> Image.Resampling.LANCZOS
    # but a fresh install of pillow via ``ARCHFLAGS='-arch arm6' python3 -m pip install pillow``
    # yielded 8.1.2 as of 26/02/23
    ANTIALIAS = Image.Resampling.LANCZOS if hasattr(Image, 'Resampling') else Image.ANTIALIAS
    img = image.resize((new_width, new_height), ANTIALIAS)
    # (left, top, right, bottom)
    half_width_delta = (new_width - target_width) // 2
    half_height_delta = (new_height - target_height) // 2
    img = img.crop((half_width_delta, half_height_delta,
                    half_width_delta + target_width, half_height_delta + target_height
                   ))
    return img

    
for file in os.listdir(args.infolder):
    filename = os.fsdecode(file)
    filepath = os.path.abspath(f"{args.infolder}/{filename}")

    print(f"Processing {filepath}")
    image = Image.open(filepath)
    resizedimage = scale(image, inky.WIDTH, inky.HEIGHT)
    resizedimage.save(f"{args.outfolder}/{filename}.png")

    if args.show:
        try:
            inky.set_image(resizedimage, saturation=saturation)
        except TypeError:
            inky.set_image(resizedimage)
        inky.show()
    
