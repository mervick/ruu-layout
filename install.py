#!/usr/bin/env python3

import sys, subprocess, xml.etree.ElementTree as ET
from xml.etree import ElementTree

user = subprocess.run(['whoami'],
    stdout=subprocess.PIPE, stderr=subprocess.PIPE,
    check=True, text=True).stdout

# if user != "root":
#   print('Root permissions is required. Run it with sudo')
#   exit(1)


class CommentedTreeBuilder(ElementTree.TreeBuilder):
# This class will retain remarks and comments opposed to the xml parser default
    def comment(self, data):
        self.start(ElementTree.Comment, {})
        self.data(data)
        self.end(ElementTree.Comment)

# the missing part:
def parse_xml_with_remarks(filepath):
    ctb = CommentedTreeBuilder()
    xp = ET.XMLParser(target=ctb)
    tree = ET.parse(filepath, parser=xp)
    return tree

test_file = './test/evdev.xml'
ruu_variant = './evdev.ruu-variant.xml'
# extra_file = '/usr/share/X11/xkb/rules/evdev.extras.xml'
evdev_file = '/usr/share/X11/xkb/rules/evdev.xml'
out_file = evdev_file
# evdev_file = out_file

contents = open(evdev_file).read()
header_end = contents.find('<xkbConfigRegistry')
if header_end == -1:
  print('Invalid file format')
  exit(2)

xml_header = contents[0:header_end]
tree = parse_xml_with_remarks(evdev_file)
layoutList = tree.find('.//layoutList')
layouts = layoutList.findall('layout')

for layout in layouts:
  configItem = layout.find('./configItem')
# for configItem, variantList in layouts:
  if configItem.find('name').text == "ru":
    variantList = layout.find('./variantList')
    variants = variantList.findall('variant')
    for variant in variants:
      configItem = variant.find('./configItem')
      if configItem.find('name').text == "ruu":
        exit(5)
    variantList.append(ET.parse(ruu_variant).getroot())

# subprocess.call("cp " + extra_file + " " + extra_file + ".back", shell=True)
subprocess.call("cp " + evdev_file + " " + evdev_file + ".back", shell=True)

with open(out_file, 'wb') as f:
    f.write(xml_header.encode('utf8'))
    ElementTree.ElementTree(tree.getroot()).write(f, 'utf-8')
