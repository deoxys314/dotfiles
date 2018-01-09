#!/usr/bn/env sh

if [ -z "$JOURNAL_PATH" ]
then
	echo "Please set JOURNAL_PATH environmental variable."
	exit 10
fi

touch "$JOURNAL_PATH/$(date +%y%m%d).jo"
