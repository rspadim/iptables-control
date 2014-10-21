#!/bin/sh
#***************************************************************************
#                           install.sh  -  description
#                             -------------------
#    begin                : mar ago 13 17:04:19 CEST 2002
#    copyright            : (C) 2002 by StealthP
#    email                : stealthp@stealthp.net
# ***************************************************************************/

#/***************************************************************************
# *                                                                         *
# *   This program is free software; you can redistribute it and/or modify  *
# *   it under the terms of the GNU General Public License as published by  *
# *   the Free Software Foundation; either version 2 of the License, or     *
# *   (at your option) any later version.                                   *
# *                                                                         *
# ***************************************************************************/


######################################
# iptables-control install program   #
#$Id: install.sh,v 1.5 2003/02/03 23:30:50 flaurita Exp $				     
#                                    #
######################################



#Print function

# red
stamp_error(){
        echo -e "\033[40m\033[1;31m$1\033[0m"
}

#yellow
stamp_act(){
        echo -e "\033[40m\033[1;33m$1\033[0m"
}

#green
stamp_succ(){
        echo -e "\033[40m\033[1;32m$1\033[0m"
}

clear
chmod +x sbin/.template
. sbin/.template
DATE=`date +'%b %d %k:%M:%S'`;
REN=`date +i'%b%d%M%S'`;
echo $REN
stamp_act "Welcome to iptables-controll installation programs!"
stamp_act "-----------------------------------------------------------"
stamp_act "$DATE:Istalling $PROGNAME $VERSION ($CODER)"
stamp_act "-----------------------------------------------------------"

#check for root privileges

if [ "$UID" != 0 ]; then
        stamp_error "Become root first!"
        exit 1
fi

stamp_act "Rename old version"
if [ -f /sbin/iptables-control ]; then
	mv -f /sbin/iptables-control /sbin/iptables-control.$REN
	chmod -x /sbin/iptables-control.$REN
	stamp_succ "[PASSED]"
else
	echo -e "No old version found"
fi

stamp_act "Back up for old configuration file"
if [ -f /etc/iptables-control.conf ]; then
        mv -f /etc/iptables-control.conf /etc/iptables-control.conf.$REN
	chmod -x /etc/iptables-control.conf.$REN
        stamp_succ "[PASSED]"
else
        echo -e "No old configuration file found"
fi

cd sbin/
./genconf.sh
cd ..
stamp_act "Copyng program in /sbin/iptables-control"
cp sbin/iptables-control /sbin/iptables-control
stamp_succ "[PASSED]"
stamp_act "Copyng config file in /etc/iptables-control.conf"
cp etc/iptables-control.conf /etc/iptables-control.conf
chmod 0700 /sbin/iptables-control
stamp_succ "[PASSED]"

stamp_act "---------------------------------------------"
stamp_act "$PROGNAME is now installed!"
stamp_act "Type iptables-control to see options"
stamp_act "---------------------------------------------"

