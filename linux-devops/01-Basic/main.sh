#!/bin/sh

# COLORS
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# TEXT STYLES
bold=$(tput bold)
normal=$(tput sgr0)

echo
echo "${bold}INTERNET${normal}"
ping -w 1 -c 1 8.8.8.8 >/dev/null 2>&1

if [ $? -eq 0 ]; then
	status="${GREEN}Connected${NC}"
	echo $status
	echo

	echo "${bold}RUN AS${normal}"
	if [ $(id -u) -eq 0 ]; then
		echo "${GREEN}Root${NC}"
		echo

		echo "${bold}UPDATING${normal}"
		apt update
		yes | apt upgrade
		echo "${GREEN}Done${NC}"
		echo

		echo "${bold}CLEANING${normal}"
		apt autoremove
		apt autoclean
		apt clean
		echo "${GREEN}Done${NC}"
		echo

	else

		echo "${RED}Non-Root${NC}"
		echo

		url="https://www.youtube.com/watch?v=BkvhwRJAYYY"
		echo "${bold}Opening${normal} ${url}"
		open $url
	fi

else
	status="${RED}Disconnected${NC}"
	echo $status
	echo
	echo "${bold}INTERFACES${normal}"
	for int in $(ls /sys/class/net | grep -v lo); do
		mac=$(cat /sys/class/net/$int/address)
		ip=$(ip a | grep $int: -A 2 | grep inet)
		if [ $? -eq 0 ]; then
			ip=$(echo $ip | awk -F " " '{print $2}' | awk -F "/" '{print $1}')
		else
			ip="-"
		fi

		echo $int '\t\t' $mac '\t\t' $ip

	done
fi

echo
