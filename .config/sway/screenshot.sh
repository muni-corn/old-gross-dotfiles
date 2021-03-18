#!/bin/bash

DATE=`date +%Y%m%d-%H%M%S`

folder=$HOME/Pictures/Screenshots
if [ ! -f $folder ]; then
	mkdir -p $folder
fi

if [ $1 = "-s" ]; then
	name=$folder/$DATE-s.png
	notify-send "Selection screenshot started" "Select an area to capture."
	slurp | grim -g - $name && notify-send "Screenshot saved" "Your capture was saved as $name." || notify-send "Selection screenshot cancelled" "Nothing was saved."
else
	name=$folder/$DATE.png
	grim $name && notify-send "Screenshot taken" "Your picture was saved as $name." || notify-send "Your screenshot couldn't be saved" "Sorry about that..."
fi