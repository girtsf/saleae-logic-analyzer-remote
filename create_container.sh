#!/bin/bash
#
# Usage: create_container.sh <image id>

docker run \
  --privileged  -v /dev/bus/usb:/dev/bus/usb \
  -e "GEOMETRY=1800x800" \
  -p 5901:5901 \
  --name logic \
  -it "$1"
