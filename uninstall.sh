#!/usr/bin/env bash

user=$(whoami)
if [[ "$user" != 'root' ]]; then
  (1>&2 echo 'Root permissions is required. Run it with sudo')
  exit 1
fi

#extra_file=/usr/share/X11/xkb/rules/evdev.extras.xml
evdev_file=/usr/share/X11/xkb/rules/evdev.xml

if [[ ! -f "$evdev_file.back" ]]; then
  (1>&2 echo "Failure. Unable to locate $evdev_file.back file")
  exit 2
fi

if [[ ! -f "$extra_file.back" ]]; then
  (1>&2 echo "Failure. Unable to locate $extra_file.back file")
  exit 3
fi


cp "$evdev_file.back" "$evdev_file"
#cp "$extra_file.back" "$extra_file"
