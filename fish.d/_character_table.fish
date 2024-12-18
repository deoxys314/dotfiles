function _character_table --argument-names start stop

	set --function idx 0
	for char_id in (seq $start $stop)
		set idx (math "$idx" + 1)
		echo -s -n \
			(printf '%4s' (math --base hex $char_id)) \
			': ' \
			(set_color blue) \
			(printf (printf '\\\\u%1x' "$char_id")) \
			(set_color normal)

		if test (math "$idx % 4") -eq 0
			echo
		else
			echo -n -s ' | '
		end
	end

end
