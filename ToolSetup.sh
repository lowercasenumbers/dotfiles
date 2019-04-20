#!/bin/bash

#Install golang-go
if [ ! -d "$HOME/go" ]; then
	echo 'Installing golang-go'
	apt-get install golang-go
else
	echo "$(tput setaf 2)[+] golang is already installed"
fi


# Setup Tools Dir
if [ ! -d "$HOME/Tools" ]; then
	echo 'Creating Tools directory'
	mkdir ~/Tools
else
	echo 'Tools directory already exists'
fi

#Clone Sublist3r
if [ ! -d "$HOME/Tools/Sublist3r" ]
then 
	echo 'Cloning Sublist3r'
	cd ~/Tools/
	git clone https://github.com/aboul3la/Sublist3r.git
else 
	echo 'Sublist3r already exists'
fi



