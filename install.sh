#!/usr/bin/env bash

user=$(whoami)
if [[ "$user" != 'root' ]]; then
  (1>&2 echo 'Root permissions is required. Run it with sudo')
  exit 1
fi

extra_file=/usr/share/X11/xkb/rules/evdev.extras.xml
evdev_file=/usr/share/X11/xkb/rules/evdev.xml

if [[ "$(cat $evdev_file | grep '<name>ruu</name>')" != "" ]]; then
  (1>&2 echo 'Layout variant "ruu" is already installed in your evdev.xml file')
  exit 2
fi

if [[ "$(cat "$evdev_file" | grep '<name>ruua</name>')" != "" ]]; then
  (1>&2 echo 'Layout variant "ruua" is already installed in your evdev.xml file')
  exit 3
fi

regex='<layout>[\s\n]*<configItem>[\s\n]*<name>ru<\/name>[a-zA-Z0-9\s\n<>\/]*<\/configItem>[\s\n]*<variantList>'
regex2="$(echo "$regex" | sed 's/\\s/[:space:]/g')"

if [[ "$(cat "$extra_file" | grep -zoP "$regex")" == "" || "$(cat "$evdev_file" | grep -zoP "$regex")" ]]; then
  (1>&2 echo 'Unable to find "ru" layout')
  exit 4
fi

if [[ -f "$evdev_file.back" ]]; then
  mv "$evdev_file.back" "$evdev_file.back~$(date +%s)"
fi
if [[ -f "$extra_file.back" ]]; then
  mv "$extra_file.back" "$extra_file.back~$(date +%s)"
fi

cp "$evdev_file" "$evdev_file.back"
cp "$extra_file" "$extra_file.back"

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

variant="$(cat "$DIR/evdev.ruu-variant.xml" | tr '\n' '\f' | sed -s 's/\//\\\//g')"

cat "$evdev_file" | tr '\n' '\f' | sed -E "s/($regex2)/\1$variant/" | tr '\f' '\n' > "$evdev_file"
cat "$extra_file" | tr '\n' '\f' | sed -E "s/($regex2)/\1$variant/" | tr '\f' '\n' > "$extra_file"
