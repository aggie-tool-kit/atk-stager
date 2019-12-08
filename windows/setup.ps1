# TODO:
    # - check if ruby is already installed, and what version

# 
# 
# introduction
# 
# 
$e = [char]0x001B
$clear = "$e[0m"
$blue = "$e[0;34;49m"
$red =  "$e[0;31;49m"
$green = "$e[0;32;49m"
$yellow = "$e[0;33;49m"
Clear-Host
read-host "
$($yellow)Hello!$clear
    This will be super easy,
    but I need to make sure you understand a few things

$blue[press enter to continue]$clear"

Clear-Host
read-host "
$($yellow)NOTE 1 of 2$clear
    $($red)If the process seems stuck try pressing enter$clear

This is a bug with an external package, and we're working on fixing it. 
Due to the way Windows CMD works,
and since it only happens sometimes,
it is very difficult to fix.

$blue[press enter to continue]$clear"

Clear-Host
read-host "
$($yellow)NOTE 2 of 2$clear
    This can take awhile to complete $red(~10 minutes)$clear

The time can be less than 30 seconds if you already have some of the tools installed

I recommend watching a ~7min YouTube video that
explains why MacOS & Linux are vastly superior to Windows
and then checking on the process to see if you need to press enter

$e[0;34;49m[press enter to continue]$clear"

Clear-Host
read-host "

$($red)To cancel:$clear press CTRL + C
$($green)To begin:$clear press enter MULTIPLE (2-3) TIMES
(this is to help counteract the bug)"

function ExitIfFailed { 
    if ($?) { } else { echo "There was an error when performing the install. There is likely details included above"; exit 1 } 
}

# 
# install scoop
# 
echo "================================="
echo "Checking/installing scoop"
echo "================================="
if (-not (cmd.exe /c "where scoop")) {
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
}
$Env:path += "$Home\scoop\shims"

# 
# install 7zip
# 
# use a better protocol to prevent a bug
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
echo "Checking/installing $($green)7zip$clear"
scoop uninstall 7zip *>$null # uninstall encase there was a previous failure
scoop install 7zip *>$null 
ExitIfFailed

# 
# install git
# 
echo "Checking/installing $($green)git$clear"
scoop uninstall git *>$null # uninstall encase there was a previous failure
scoop install git *>$null
ExitIfFailed
# install openssh (for git)
echo "Checking/installing $($green)openssh$clear"
scoop uninstall openssh *>$null
scoop install openssh *>$null
ExitIfFailed

# 
# finish scoop setup
# 
# make sure the extras bucket is included
scoop bucket add extras *>$null
scoop bucket add versions *>$null

# 
# install ruby & gem
# 
echo "Checking/installing $($green)ruby$clear"
scoop uninstall ruby *>$null
scoop install ruby *>$null
ExitIfFailed
$Env:path += "$Home\scoop\apps\ruby\current\bin"
# setup msys2 (for ruby)
scoop uninstall msys2 *>$null
scoop install msys2 *>$null
"exit
" | msys2

# 
# install atk_toolbox 
# 
echo "Installing the $($green)atk_toolbox$clear"
& "$Home\scoop\apps\ruby\current\bin\gem.cmd" install atk_toolbox
# create the atk temp directory if it doesn't exist
$temp_dir = "$Home\atk\temp"
if(!(Test-Path -Path $temp_dir )){
    md $temp_dir
}
# delete any previous setup
Remove-Item -Path "$Home\atk\temp\setup.rb" -Force -ErrorAction SilentlyContinue *>$null
# download and run the script
$install_script = (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/aggie-tool-kit/atk-stager/master/setup.rb')
New-Item -Path "$Home\atk\temp" -Name "setup.rb" -ItemType "file" -Value $install_script
ruby "$Home\atk\temp\setup.rb"
ExitIfFailed


# 
# Create the success-window script
# 
# this command opens a new CMD with the message in it
$file_name = "___AtkPrintDone.bat"
$print_command = @"
    Start cmd /k "echo ============================== & echo '        ATK Installed       ' & echo ============================== & echo Close and reopen CMD for changes to take effect" 
    Remove-Item "$Home\AppData\local\Microsoft\WindowsApps\$file_name" -erroraction 'silentlycontinue'
"@
# remove the old print statement if there was one
Remove-Item "$Home\AppData\local\Microsoft\WindowsApps\$file_name" -erroraction 'silentlycontinue' *>$null
# create the new one
New-Item -Path "$Home\AppData\local\Microsoft\WindowsApps\" -Name "$file_name" -ItemType "file" -Value $print_command
