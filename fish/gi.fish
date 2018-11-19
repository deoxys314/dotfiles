function gi -d "Uses gitignore.io to create .gitignore files" --argument-names 'tags'
	if test -z $tags
		echo "No arguments provided."
		return 1
	end
	curl -L -s "https://www.gitignore.io/api/$tags"
end
