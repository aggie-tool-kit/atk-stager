# TODO:
    # - check if ruby is already installed, and what version

# 
# 
# introduction
# 
# 

Clear-Host
read-host "
Hello!
    This will be super easy,
    but I need to make sure you understand a few things

$([char]0x0048)[0;34;49m[press enter to continue]$([char]0x0048)[0m"

Clear-Host
read-host "
NOTE 1 of 2
    $([char]0x0048)[0;31;49mIf the process seems stuck try pressing enter$([char]0x0048)[0m

This is a bug with an external package, and we're working on fixing it. 
Due to the way Windows CMD works,
and since it only happens sometimes,
it is very difficult to fix.

$([char]0x0048)[0;34;49m[press enter to continue]$([char]0x0048)[0m"

Clear-Host
read-host "
NOTE 2 of 2
    This can take awhile to complete $([char]0x0048)[0;31;49m(~10 minutes)$([char]0x0048)[0m

The time can be less than 30 seconds if you already have some of the tools installed

I recommend watching a ~7min YouTube video that
explains why MacOS & Linux are vastly superior to Windows
and then checking on the process to see if you need to press enter

$([char]0x0048)[0;34;49m[press enter to continue]$([char]0x0048)[0m"

Clear-Host
read-host "

$([char]0x0048)[0;31;49mTo cancel:$([char]0x0048)[0m press CTRL + C
$([char]0x0048)[0;32;49mTo begin:$([char]0x0048)[0m press enter MULTIPLE (2-3) TIMES
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
echo "Checking/installing 7zip"
scoop uninstall 7zip *>$null # uninstall encase there was a previous failure
scoop install 7zip *>$null 
ExitIfFailed

# 
# install git
# 
echo "Checking/installing git"
scoop uninstall git *>$null # uninstall encase there was a previous failure
scoop install git *>$null
ExitIfFailed
# install openssh (for git)
echo "Checking/installing openssh"
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
echo "Checking/installing ruby"
scoop uninstall ruby *>$null
scoop install ruby *>$null
ExitIfFailed
$Env:path += "$Home\scoop\apps\ruby\current\bin"
# setup msys2 (for ruby)
scoop uninstall msys2 *>$null
scoop install msys2
"exit
" | msys2

# 
# install atk_toolbox 
# 
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
$print_command = @"
    Start cmd /k "echo ============================== & echo '        ATK Installed' & echo ==============================" 
"@
$file_name = "___AtkPrintDone.bat"
# remove the old print statement if there was one
Remove-Item "$Home\AppData\local\Microsoft\WindowsApps\$file_name" -erroraction 'silentlycontinue' *>$null
# create the new one
New-Item -Path "$Home\AppData\local\Microsoft\WindowsApps\" -Name "$file_name" -ItemType "file" -Value $print_command
