#!/bin/sh -e
# 
# Easy script for creating OS X Mavericks installation disk image
# 
# Copyright (c) 2014 mattintosh4
# Released under the MIT license
# https://github.com/mattintosh4/osx109dmggen/blob/master/LICENSE
# 
# Operation confirmation:
#    OS X 10.6.8
#    OS X 10.9.3
# 

PATH=/usr/bin:/bin:/usr/sbin:/sbin

InstallESD_dmg="/Applications/Install OS X Mavericks.app/Contents/SharedSupport/InstallESD.dmg"

if test ! -f "${InstallESD_dmg}"
then
    echo "${InstallESD_dmg} is not found."
    exit 1
fi

set -x

hdiutil attach "${InstallESD_dmg}" -mountpoint /Volumes/ESD -nobrowse
hdiutil convert -ov -format UDSP -o /tmp/foo /Volumes/ESD/BaseSystem.dmg
hdiutil resize -size 6g /tmp/foo.sparseimage
hdiutil attach /tmp/foo.sparseimage -mountpoint /Volumes/BS -nobrowse
rm /Volumes/BS/System/Installation/Packages
ditto /Volumes/ESD/Packages /Volumes/BS/System/Installation/Packages
hdiutil detach /Volumes/ESD
hdiutil detach /Volumes/BS
hdiutil convert -ov -format UDRO -o "Install OS X Mavericks" /tmp/foo.sparseimage
rm /tmp/foo.sparseimage
