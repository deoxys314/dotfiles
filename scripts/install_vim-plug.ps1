echo "This script will install vim-plug and start vim to install all plugins."
echo "It assumes you have curl somewhere in PATH and will fail otherwise."

$confirm = Read-Host "Are you sure you want to proceed? [y/n] "

if ($confirm -eq "y" -or $confirm -eq "Y") {
    md ~\vimfiles\autoload
        $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        (New-Object Net.WebClient).DownloadFile(
                $uri,
                $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
                    "~\vimfiles\autoload\plug.vim"
                    )
                )
}
