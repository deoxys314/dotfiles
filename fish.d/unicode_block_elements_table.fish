# I seem to use these a lot, so this is a handy ref
function unicode_block_elements_table
	set --function idx 0
	for char_id in (seq (math 0x2580) (math 0x259F))
		set idx (math "$idx" + 1)
		echo -s -n \
			(math --base hex $char_id) \
			': ' \
			(set_color blue) \
			(printf (printf '\\\\u%x' "$char_id")) \
			(set_color normal)

		if test (math "$idx % 4") -eq 0
			echo
		else
			echo -n -s ' | '
		end
	end
end
