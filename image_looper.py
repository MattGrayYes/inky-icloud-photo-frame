#!/usr/bin/env python3

import argparse
import pathlib
import sys
import os
import random
import time
from PIL import Image
from inky.auto import auto

parser = argparse.ArgumentParser()
parser.add_argument("--infolder", "-i", type=pathlib.Path, help="Image folder")
parser.add_argument("--time", "-t", type=int, help="Time between images", default=1800)
args, _ = parser.parse_known_args()

if not args.infolder:
    print(f"""Usage:
    {sys.argv[0]} --infolder images/processed/ (--time 1800)""")
    sys.exit(1)

if args.time:
    try:
        sleep_time = int(args.time)
    except ValueError:
        print("Time must be an integer")
        sys.exit(1)

print("Starting image looper.")
print(f"Using images from: {args.infolder}")
print(f"Time between images: {sleep_time} seconds")
print("Press Ctrl+C to stop.")

inky = auto(ask_user=True, verbose=True)
saturation = 0.5

print("Loading images")
images = os.listdir(args.infolder)
random.shuffle(images)
print(f"Found {len(images)} images")
print("Displaying images")

for file in images:
    filename = os.fsdecode(file)
    filepath = os.path.abspath(f"{args.infolder}/{filename}")

    image = Image.open(filepath)

    try:
        inky.set_image(image, saturation=saturation)
    except TypeError:
        inky.set_image(image)
    inky.show()

    time.sleep(sleep_time)