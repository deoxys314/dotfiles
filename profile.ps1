Function prompt {
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
        if ($dir[0] -eq ".") {
            Write-Host $($dir[0] + $dir[1]) -nonewline -foregroundcolor Yellow
        } else {
            Write-Host $dir[0] -nonewline -foregroundcolor Yellow
        }
        Write-Host "\" -nonewline -foregroundcolor Gray
    }
    Write-Host $currpath[-1] -nonewline -foregroundcolor Yellow

    # if posh-git is available, run the relevant bit here.
    if (Get-Command Write-VcsStatus -errorAction SilentlyContinue) {
        $prompt = Write-VcsStatus
    }

    Write-Host " >" -nonewline -foregroundcolor Gray

    if ($prompt) {
        return " "
    } else {
        return " "
    }
}

Function Edit-Profile {
    gvim $profile
}

Function Reload-Profile {
    if (!(Test-Path -Path $profile )) { 
        New-Item -Type File -Path $profile -Force
    }
    . $profile
}


Function List-EmptyDirectories {
	# Assumes you are in the correct directory unless told otherwise
	Param (
		[Parameter(mandatory)] $path
	)

	Get-ChildItem $path -Directory -Recurse -ErrorAction 'ignore' `
	 | Where-Object { 
		 ($_.GetFileSystemInfos().Count -eq 0) -and ($_.FullName -notmatch '\\\.')
		 } `
	 | ForEach-Object { $_.FullName }
}


Function Set-FileTimeStamps {
    Param (
    # [Parameter(mandatory=$true)]
    [string[]]$path,
    [datetime]$date = (Get-Date))

    if (-not ($path)) {
        Throw "Must supply a value for -Path"
    }

    Get-ChildItem -Path $path |
    ForEach-Object {
        $_.CreationTime = $_.LastAccessTime =  $_.LastWriteTime = $date
    }
}

Function Convert-Size {
    <#
        .SYSNOPSIS
            Converts a size in bytes to its upper most value.

        .DESCRIPTION
            Converts a size in bytes to its upper most value.

        .PARAMETER Size
            The size in bytes to convert

        .NOTES
            Author: Boe Prox
            Date Created: 22AUG2012

        .EXAMPLE
        Convert-Size -Size 568956
        555 KB

        Description
        -----------
        Converts the byte value 568956 to upper most value of 555 KB

        .EXAMPLE
        Get-ChildItem  | ? {! $_.PSIsContainer} | Select -First 5 | Select Name, @{L='Size';E={$_ | Convert-Size}}
        Name                                                           Size
        ----                                                           ----
        Data1.cap                                                      14.4 MB
        Data2.cap                                                      12.5 MB
        Image.iso                                                      5.72 GB
        Index.txt                                                      23.9 KB
        SomeSite.lnk                                                   1.52 KB
        SomeFile.ini                                                   152 bytes

        Description
        -----------
        Used with Get-ChildItem and custom formatting with Select-Object to list the uppermost size.
    #>
    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [Alias("Length")]
        [int64]$Size
    )
    Begin {
        If (-Not $ConvertSize) {
            Write-Verbose ("Creating signature from Win32API")
            $Signature =  @"
                 [DllImport("Shlwapi.dll", CharSet = CharSet.Auto)]
                 public static extern long StrFormatByteSize( long fileSize, System.Text.StringBuilder buffer, int bufferSize );
"@
            $Global:ConvertSize = Add-Type -Name SizeConverter -MemberDefinition $Signature -PassThru
        }
        Write-Verbose ("Building buffer for string")
        $stringBuilder = New-Object Text.StringBuilder 1024
    }
    Process {
        Write-Verbose ("Converting {0} to upper most size" -f $Size)
        $ConvertSize::StrFormatByteSize( $Size, $stringBuilder, $stringBuilder.Capacity ) | Out-Null
        $stringBuilder.ToString()
    }
}
