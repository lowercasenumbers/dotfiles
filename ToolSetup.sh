#!/bin/bash

#Color Vars
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

#Install golang-go
if [ ! -d "$HOME/go" ]; then
	echo "${green} Installing golang-go${reset}"
	apt-get install golang-go
else
	echo "${green} [+] golang is already installed ${reset}"
fi


# Setup Tools Dir
if [ ! -d "$HOME/Tools" ]; then
	echo "${green}[+] Creating Tools directory${reset}"
	mkdir ~/Tools
else
	echo "${green} [+] Tools directory already exist${reset}"
fi

#Clone Sublist3r
if [ ! -d "$HOME/Tools/Sublist3r" ]; then 
	echo "${green} [+] Cloning Sublist3r${reset}"
	cd ~/Tools/
	git clone https://github.com/aboul3la/Sublist3r.git
else 
	echo "${green} [+] Sublist3r already exists${reset}"
fi

#Clone Subjack	
if [ ! -f "$HOME/go/bin/subjack" ]; then 
	echo "${green}[+] Installing Subjack${reset}"
	go get github.com/haccer/subjack
else 
	echo "${green} [+] Subjack already installed${reset}"
fi

