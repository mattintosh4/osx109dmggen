#!/bin/sh -e
# 
# Easy script for creating OS X Mavericks installation disk image
# 
# Operation confirmation:
#    OS X 10.6.8
#    OS X 10.9.3
# 
# The MIT License (MIT)
# 
# Copyright (c) 2014 mattintosh4
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
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
