function extract --description 'Extract the contents of nearly any archive file' --argument-names file
	switch $file
		case '**.tar.gz'
			tar -xzf $file
		case '**.tar.bz2'
			tar -xjf $file
		case '**.tar.xz'
			tar -xJf $file
		case '**.tar.Z'
			tar -xZf $file
		case '**.tar'
			tar -xf $file
		case '**.zip'
			unzip $file
		case '**.rar'
			unrar x $file
		case '**.7z'
			7z x $file
		case '**.gz'
			gzip -d $file
		case '**.bz2'
			bzip2 -d $file
		case '**.xz'
			xz -d $file
		case '*'
			echo "Unsupported file type: $file" >&2
			return 1
	end
end
