function cdf --description="If on OSX, `cd` to the directory the front Finder window is open to."
	# first we check if we're on OSX
	if not string match --ignore-case --quiet 'Darwin' (uname)
		echo "We are not on OSX." >&2
		return 3
	end
	set --local target (osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
	if test -n target
		echo "Changing directory to: $target"
		cd $target
	else
		echo "No Finder window found." >&2
		return 1
	end
end

