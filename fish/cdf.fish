function cdf
	set --local target (osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
	if test -n target
		echo "Changing directory to: $target"
		cd $target
	else
		echo "No Finder window found." >&2
		return 1
	end
end

