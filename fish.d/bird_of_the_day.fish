function bird_of_the_day
	set -f birds (cat "$(git -C (status dirname) rev-parse --show-toplevel)/data/bird_names.txt")
	set -f n_birds (count $birds)
	set -f idx (math "$(date '+(%y * %j)') % $n_birds + 1")
	printf '%s\n' $birds[$idx]
end
