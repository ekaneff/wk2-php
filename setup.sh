#!/bin/sh

DIRECTORY="/var/www/html/php"

if [ ! -d "$DIRECTORY" ]; then
	mkdir $DIRECTORY
fi