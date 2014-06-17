#!/bin/sh
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

set -e

PATH=/usr/bin:/bin:/usr/sbin:/sbin

InstallESD_dmg="/Applications/Install OS X Mavericks.app/Contents/SharedSupport/InstallESD.dmg"

if test ! -f "${InstallESD_dmg}"
then
    echo "${InstallESD_dmg} is not found."
    exit 1
fi

temp=/tmp/`uuidgen`.sparseimage

set -x

hdiutil attach "${InstallESD_dmg}" -nobrowse -mountpoint /Volumes/ESD
hdiutil convert /Volumes/ESD/BaseSystem.dmg -ov -format UDSP -o ${temp}
hdiutil resize ${temp} -size 6g
hdiutil attach ${temp} -nobrowse -mountpoint /Volumes/BSD
rm /Volumes/BSD/System/Installation/Packages
ditto /Volumes/ESD/Packages /Volumes/BSD/System/Installation/Packages
hdiutil detach /Volumes/BSD
hdiutil detach /Volumes/ESD
hdiutil convert ${temp} -ov -format UDRO -o "Install OS X Mavericks"
rm ${temp}
