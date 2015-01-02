#!/bin/bash

# OpenMandriva Association 2014
# Original author: Tomasz Pawe³ Gajc <tpgxyz@gmail.com>

# This tool is licensed under GPL license
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

if [ "`id -u`" != "0" ]; then
    # We need to be root for umount and friends to work...
    echo Run me as root.
    exit 1
fi

if grep -q '\bcliinstall\b' /proc/cmdline; then
    echo "Starting CLI installer."
else
    echo "Warning! You are running CLI installer on working system. Exiting."
    exit 1
fi

install_chroot() {
    # $TARGET is a blockdevice where stuff will be installed
    mount --bind /proc $TARGET/proc
    mount --bind /dev $TARGET/dev
    mount --bind /tmp $TARGET/tmp
    mount --bind /sys $TARGET/sys
    mount --bind /run $TARGET/run
}

umount_chroot() {
    echo "Umounting all."
    umount -l $TARGET/proc || :
    umount -l $TARGET/sys || :
    umount -l $TARGET/dev/pts || :
    umount -l $TARGET/dev || :
}

error() {
    echo "Something went wrong. Exiting"
    umount_chroot
    rm -rf $TARGET
    exit 1
}

# Don't leave potentially dangerous stuff if we had to error out...
trap error ERR

# EOF
