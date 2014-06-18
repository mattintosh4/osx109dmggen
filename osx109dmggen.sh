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
#set -x
PATH=/usr/bin:/bin

InstallESD_dmg="/Applications/Install OS X Mavericks.app/Contents/SharedSupport/InstallESD.dmg"
test -f "${InstallESD_dmg}" || { echo "'${InstallESD_dmg}' is not found."; exit 1; }

sparseimage=/tmp/`uuidgen`.sparseimage
hdiutil attach "${InstallESD_dmg}" -nobrowse -mountpoint /Volumes/ESD
hdiutil convert /Volumes/ESD/BaseSystem.dmg -ov -format UDSP -o ${sparseimage}
hdiutil resize ${sparseimage} -size 6g
hdiutil attach ${sparseimage} -nobrowse -mountpoint /Volumes/BSD
rm /Volumes/BSD/System/Installation/Packages
ditto -V /Volumes/ESD/Packages /Volumes/BSD/System/Installation/Packages
hdiutil detach /Volumes/BSD
hdiutil detach /Volumes/ESD
hdiutil convert ${sparseimage} -ov -format UDRO -o "Install OS X Mavericks"
rm ${sparseimage}
