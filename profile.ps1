function prompt {
    # Script based on examples provided by Rikard Ronnkvist / snowland.se
    # Multicolored prompt with marker for windows started as Admin and marker for providers outside filesystem

    # New nice WindowTitle
    $Host.UI.RawUI.WindowTitle = "PowerShell v" + (get-host).Version.Major + "." + (get-host).Version.Minor + " (" + $pwd.Provider.Name + ") " + $pwd.Path

    # Admin ?
    if( (
        New-Object Security.Principal.WindowsPrincipal (
            [Security.Principal.WindowsIdentity]::GetCurrent())
        ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        # Admin-mark in WindowTitle
        $Host.UI.RawUI.WindowTitle = "[Admin] " + $Host.UI.RawUI.WindowTitle

        # Admin-mark on prompt
        Write-Host "[" -nonewline -foregroundcolor DarkGray
        Write-Host "Admin" -nonewline -foregroundcolor Red
        Write-Host "] > " -nonewline -foregroundcolor DarkGray
    }

    # Show providername if you are outside FileSystem
    if ($pwd.Provider.Name -ne "FileSystem") {
        Write-Host "[" -nonewline -foregroundcolor DarkGray
        Write-Host $pwd.Provider.Name -nonewline -foregroundcolor Gray
        Write-Host "] > " -nonewline -foregroundcolor DarkGray
    }

    # write out username and hostname
    Write-Host $env:username -nonewline -foregroundcolor Cyan
    Write-Host "@" -nonewline -foregroundcolor Cyan
    Write-Host $env:computername -nonewline -foregroundcolor Cyan
    Write-Host " > " -nonewline

    # Split path and write \ in a gray
    $currpath = $pwd.Path.Split("\")
    foreach ( $dir in $($currpath -ne $currpath[-1]) ) {
        Write-Host $dir[0] -nonewline -foregroundcolor Yellow
        Write-Host "\" -nonewline -foregroundcolor Gray
    }
    Write-Host $currpath[-1] -nonewline -foregroundcolor Yellow
    Write-Host " >" -nonewline -foregroundcolor Gray

    return " "
}

Function Edit-Profile {
	gvim $profile
}
