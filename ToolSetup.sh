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
	echo "${red} [-] golang is already installed ${reset}"
fi


# Setup Tools Dir
if [ ! -d "$HOME/Tools" ]; then
	echo "${green}[+] Creating Tools directory${reset}"
	mkdir ~/Tools
else
	echo 'Tools directory already exists'
fi

#Clone Sublist3r
if [ ! -d "$HOME/Tools/Sublist3r" ]; then 
	echo 'Cloning Sublist3r'
	cd ~/Tools/
	git clone https://github.com/aboul3la/Sublist3r.git
else 
	echo 'Sublist3r already exists'
fi

#Clone Subjack	
if [ ! -d "$HOME/go/bin/subjack" ]; then 
	echo 'Installing Subjack'
	go get github.com/haccer/subjack
else 
	echo 'Subjack already installed'
fi

