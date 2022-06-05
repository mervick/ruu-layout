# ruu layout for xkb

RUU: Russian-Ukrainian United keyboard layout

To install `ruu` layout with Russian-Ukrainian-Belorussian layout, run

```bash
sudo bash install.py
```

This script adds `ruu` Russian-Ukrainian-Belorussian 
layout to your xkb settings (`/usr/share/X11/xkb/rules/evdev.xml`).  
During installation it creates backup file `/usr/share/X11/xkb/rules/evdev.xml.back`, 
which used for uninstall script, please don't remove it manually.

To uninstall:
```bash
sudo bash uninstall.sh
```

**Related external Links:**

- [Single Russian-Ukrainian keyboard layout on Ubuntu](https://pshchelo.github.io/ubuntu-ruu-kbd.html)
- [RUU OpenWiki (Russian)](http://wiki.opennet.ru/RUU)
