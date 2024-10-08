oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/darkblood.omp.json" | Invoke-Expression



function Test-CommandExists {
    param($command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

function touch($file) { "" | Out-File $file -Encoding ASCII }

# Find file recursive
function ff($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output "$($_.FullName)"
    }
}

function Get-PubIP { (Invoke-WebRequest http://ifconfig.me/ip).Content }

# Open WinUtil
function winutil {
	iwr -useb https://christitus.com/win | iex
}


function uptime {
    if ($PSVersionTable.PSVersion.Major -eq 5) {
        Get-WmiObject win32_operatingsystem | Select-Object @{Name='LastBootUpTime'; Expression={$_.ConverttoDateTime($_.lastbootuptime)}} | Format-Table -HideTableHeaders
    } else {
        net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
    }
}


function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}


function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function downloads { Set-Location -Path $HOME\Downloads }
function dtop { Set-Location -Path $HOME\Desktop }

function gs { git status }

function ga { git add . }

# Quick Access to System Information
function sysinfo { Get-ComputerInfo }

# Networking Utilities
function flushdns {
	Clear-DnsClientCache
	Write-Host "DNS has been flushed"
}


function npp {
    param (
        [string]$file
    )
    if (Test-Path $file) {
        Start-Process notepad++.exe -ArgumentList $file
    } else {
        Write-Host "File not found: $file"
    }
}




function Show-Help {
    @"
PowerShell Profile Help
=======================


touch <file> - Creates a new empty file.

ff <name> - Finds files recursively with the specified name.

Get-PubIP - Retrieves the public IP address of the machine.

winutil - Runs the WinUtil script from Chris Titus Tech.

uptime - Displays the system uptime.

unzip <file> - Extracts a zip file to the current directory.

downloads - Changes the current directory to the user's Downloads folder.

dtop - Changes the current directory to the user's Desktop folder.

gs - Shortcut for 'git status'.

ga - Shortcut for 'git add .'.

sysinfo - Displays detailed system information.

flushdns - Clears the DNS cache.

Use 'Show-Help' to display this help message.
"@
}
Write-Host "Use 'Show-Help' to display help"



# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
