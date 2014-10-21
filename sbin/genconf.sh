#!/bin/sh
#***************************************************************************
#                           genconf.sh  -  description
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
# iptables-control configurator      #
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
set_variable(){

#echo "$0" "$1" "$2" "$3" "$4"
if [ "$2" = "" ]; then

	echo "$3=\"$1\"" >> ../etc/iptables-control.conf
else
	
	echo "$3=\"$2\"" >> ../etc/iptables-control.conf
fi

}




#Init file

cat .template > ../etc/iptables-control.conf

stamp_act "---------------------------------------------------------------"
stamp_act "This is a simple guide to create a basilary configuration file"
stamp_act "---------------------------------------------------------------"


stamp_succ "--------------------------------------------------------------"
stamp_succ "                  Starting global settings       "
stamp_succ "--------------------------------------------------------------"


#Setting external interface.
echo "External internet interface:[ppp0]"
read IF
set_variable "ppp0" "$IF" "IF"

echo "Where is iptables?[`which iptables`]"
read IPTABLES
set_variable "`which iptables`" "$IPTABLES" "IPTABLES"

echo "Where is modprobre?[`which modprobe`]"
read MODPROBE
set_variable "`which modprobe`" "$MODPROBE" "MODPROBE"


stamp_succ "Done!"


stamp_succ "-----------------------------------------------------------"
stamp_succ "            Starting port settings section"
stamp_succ "-----------------------------------------------------------"

#setting tcp open ports

echo "Insert tcp port to open at all world"
echo "Syntax: <port>[SPACE]<port>...."
echo "To close all ports just type NOTHING"
echo "Default:[21 22 25 80 110]"
read TCP_ALL_PORTS
if [ "$TCP_ALL_PORTS" = "NOTHING" ]; then
        set_variable "" "" "TCP_ALL_PORTS"
else
        set_variable "21 22 25 80 110" "$TCP_ALL_PORTS" "TCP_ALL_PORTS"
fi

#setting udp ports
echo "Insert udp ports to open at all world"
echo "Syntax: <port>[SPACE]<port>...."
echo "To close all ports just type NOTHING"
echo "Default:[53]"
read TCP_ALL_PORTS
if [ "$UDP_ALL_PORTS" = "NOTHING" ]; then
        set_variable "" "" "UDP_ALL_PORTS"
else
        set_variable "53" "$UDP_ALL_PORTS" "UDP_ALL_PORTS"
fi



#setting tcp port to open at only determinate host
echo "Insert TCP ports that will open at determinate host"
echo "Syntax:<ip>/<class>@<port>"
echo "Leave blank for nothing"
read TCP_PRIV_PORTS
set_variable "" "$TCP_PRIV_PORTS" "TCP_PRIV_PORTS"


#setting udp ports to open at only determinate host
echo "Insert UDP ports that will open a determinate host"
echo "Syntax:<ip>/<class>@<port>"
echo "Leave blank for nothing"
read UDP_PRIV_PORTS
set_variable "" "$UDP_PRIV_PORTS" "UDP_PRIV_PORTS"

stamp_succ "Done!"


stamp_succ "---------------------------------------------------"
stamp_succ "         		Port forwarding settings           "
stamp_succ "---------------------------------------------------"

echo "Insert the port forwarding rules"
echo "Syntax:<portforwarded>@<host>"
echo "Leave blank for nothing"
read PRT_FW
set_variable "" "$PRT_FW" "PRT_FW"


stamp_succ "Done!"

stamp_succ "---------------------------------------------------"
stamp_succ "         		Banned host  settings              "
stamp_succ "---------------------------------------------------"
#Setting banned host
echo "Banned host"
echo "Insert host that are banned from your system like adv site or spammer host"
echo "Syntax:<ip>/<class>[SPACE]<ip>/<class>...."
echo "Leave blank for nothing"
read BANNED_HOST
set_variable "" "$BANNED_HOST" "BANNED_HOST"

stamp_succ "Done!"

stamp_succ "---------------------------------------------------"
stamp_succ "         Starting NAT section settings"
stamp_succ "---------------------------------------------------"

echo "Do you have lan?"
OPT="YES NO"
select opt_lan in $OPT; do
	set_variable "NO" "$opt_lan" "NAT"
	break
done
unset OPT

if [ "$opt_lan" = "YES" ]; then
	#Setting lan interface
	echo "LAN interface:[eth0]"
	read IF_LAN
	set_variable "eth0" "$IF_LAN" "IF_LAN"

	#LAN address
	echo "LAN Address:[192.168.0.0/255.255.255.0]"
	read LAN_ADDR
	set_variable "192.168.0.0/255.255.255.0" "$LAN_ADDR" "LAN_ADDR"
	
	#Trasparent proxy setting
	
	echo "Do yoy ave trasparent proxy for your lan?"
	OPT="YES NO"
	select opt_pro in $OPT; do
        	set_variable "NO" "$opt_pro" "HAVE_PROXY"
        	break
	done
	unset OPT
	
	if [ "$opt_pro" = "YES"  ]; then
		echo "Tell me if your proxy is here or in remote machine"
		echo "If here, type LOCAL, else insert IP address"
		echo "Default:[LOCAL]"
		read TRASPARENT_PROXY
		set_variable "LOCAL" "$TRASPARENT_PROXY" "TRASPARENT_PROXY"
		
		echo "Proxy port:[8080]"
		read PROXY_PORT
		set_variable "8080" "$PROXY_PORT" "PROXY_PORT"
	else
		echo "Skipping proxy configuration"
		set_variable "" "$TRASPARENT_PROXY" "TRASPARENT_PROXY"
		set_variable "" "$PROXY_PORT" "PROXY_PORT"	
	fi

else	
	echo "Skipping NAT configuration"
	set_variable "" "$IF_LAN" "IF_LAN"
	set_variable "" "$LAN_ADDR" "LAN_ADDR"
	set_variable "" "$opt_pro" "HAVE_PROXY"
	set_variable "" "$TRASPARENT_PROXY" "TRASPARENT_PROXY"
	set_variable "" "$PROXY_PORT" "PROXY_PORT"
	
fi

stamp_succ "[PASSEED]"

stamp_act "Setting attribute file"
chmod 0700 ../etc/iptables-control.conf
stamp_succ "[PASSED]"


stamp_act "This is your configuration file:"
cat ../etc/iptables-control.conf
stamp_succ "[EOF]"

stamp_act "---------------------------------------------"
stamp_act "              Configuration end!"
stamp_act "---------------------------------------------"
