#!/bin/bash
source ~/.virtualenvs/pimoroni/bin/activate

pipreqs --savepath=requirements.in && pip-compile