function list-functions --description "Lists all autoloaded functions fish can see. Does not guarantee order."
	for dir in $fish_function_path
		for func in (ls "$dir")
			echo "$func"
		end
	end
end
