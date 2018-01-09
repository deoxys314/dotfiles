#!/usr/bin/env sh


if [ -z "$PUSHBULLET_PATH" ]
then
	echo "Please set PUSHBULLET_PATH environmental variable."
	exit 10
fi

if [ -z "$JOURNAL_PATH" ]
then
	echo "Please set JOURNAL_PATH environmental variable."
	exit 11
fi

picto_date=$(date +%y%m%d)


# If the current date isn't found in the file . . . 
if ! grep -q "$picto_date" $JOURNAL_PATH/*.jo
then
	echo "Date not found!"
fi
