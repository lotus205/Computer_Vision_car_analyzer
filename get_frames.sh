#!/bin/bash

mkdir -p day_time/
avconv -r 15 -i day_time.mkv -vsync 1 -r 1 -an -y 'day_time/day_time_frame_%d.jpg'

mkdir -p night_time/
avconv -r 15 -i night_time.mkv -vsync 1 -r 1 -an -y 'night_time/night_time_frame_%d.jpg'