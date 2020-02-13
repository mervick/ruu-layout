#!/usr/bin/env bash

user=$(whoami)
if [[ "$user" != 'root' ]]; then
  (1>&2 echo 'Root permissions is required. Run it with sudo')
  exit 1
fi

evdev_file=/usr/share/X11/xkb/rules/evdev.xml
evdev_file=/tmp/evdev.xml

if [[ -f "$evdev_file.back" ]]; then
  cp "$evdev_file.back" "$evdev_file"
  exit 0
fi

(1>&2 echo "Failure. Unable to locate $evdev_file.back file")
exit 2
