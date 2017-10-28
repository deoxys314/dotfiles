#!/usr/local/bin/bash

# Preview how the colors accessible to tmux will look in your terminal

for i in {0..31}
do
	for j in {0..7}
	do
		x="$(expr $i \* 8 + $j)"
		printf "\x1b[38;5;${x}mcolour${x}\x1b[0m "
		l=$(expr 3 - ${#x})
		while [ $l -ge 0 ]
		do
			printf " "
			l=$(expr $l - 1)
		done
	done
	printf "\n"
done
