@'

Installing nvm-windows

'@

@'
download from https://github.com/coreybutler/nvm-windows/releases and then install it
'@


@'

Installing pyenv-win 

'@

# Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1") | iex


@'

Installing PsGet and posh-git

'@

(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/psget/psget/master/GetPsGet.ps1") | iex

# $PSVersionTable

Install-Module posh-git -Scope CurrentUser

# $env:PSModulePath
# $env:PSModulePath.split(";")[0]
# # code $PROFILE

Add-PoshGitToProfile
if (!(Test-Path -Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force
}

@'
Import-Module posh-git

$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = true
$GitPromptSettings.DefaultPromptWriteStatusFirst = $true
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'

'@ >> $PROFILE

@'

Adding Clone-Git command to PROFILE

'@

@'
function Clone-Git
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string] $SshKeyFilePath,

        [Parameter(Mandatory=$false, Position=0)]
        [string] $Url
    )

    Process
    {
        if (!$Url) {
            Write-Error "Usage: ${0} git@gitserver.com:owner/project.git|https://gitserver.com/owner/project.git"
            return
        }

        $PathItems = $Url -replace '.git$', '' -replace '(.*@|(https|http|ssh)://)([a-z0-9\.-]+)(:[0-9]+/|:|/)(.*)/(.*)', '$3 $5 $6' -split ' '
        $Path = [string]::Join('\', $env:USERPROFILE, 'studio', $PathItems[0], $PathItems[1]);
        $RepoName = $PathItems[2]
        Write-Host "Cloning $Url into $Path/ as $RepoName ..."

        New-Item -ItemType Directory $Path -ErrorAction SilentlyContinue

        Push-Location $Path
        if ($Url -match '^http' || !$SshKeyFilePath) {
            git clone $Url
        } else {
            $SshKeyFilePath = $SshKeyFilePath -replace '^~', $env:USERPROFILE -replace '\\', '/'
            # Write-Host $SshKeyFilePath
            git clone -c core.sshCommand="ssh -i $SshKeyFilePath" $Url
        }
        Pop-Location
    }
}
'@ >> $PROFILE

#
# ```
# Import-Module posh-git
# $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = true
# $GitPromptSettings.DefaultPromptWriteStatusFirst = $true
# $GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'
# ```
