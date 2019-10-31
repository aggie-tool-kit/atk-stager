# TODO:
    # - check if ruby is already installed, and what version


Clear-Host
read-host "Hello!

NOTE 1!
    Even if you see errors, let the installer handle the errors.
    If you cancel in the middle, a halfway-installed tool can be really difficult to fix.

NOTE 2!
    Sometimes YOU NEED TO PRESS ENTER at random times. There will not be a prompt.
    It normally only happens once after the 'extracting *some package name*' lines.

        This is a bug with an external package, and we're working on fixing it. 
        Due to the way Windows CMD works, 
        and since it only happens sometimes,
        it is very difficult to fix.

NOTE 3
    This installer will take awhile to complete (~10 minutes)

Press ENTER to continue with the install


"

# 
# install scoop
# 
if (-not (cmd.exe /c "where scoop")) {
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
}
# go home
cd $Home


$reset_command = @"
@echo off
::
:: RefreshEnv.cmd
::
:: Batch file to read environment variables from registry and
:: set session variables to these values.
::
:: With this batch file, there should be no need to reload command
:: environment every time you want environment changes to propagate

echo | set /p dummy="Reading environment variables from registry. Please wait... "

goto main

:: Set one environment variable from registry key
:SetFromReg
    "%WinDir%\System32\Reg" QUERY "%~1" /v "%~2" > "%TEMP%\_envset.tmp" 2>NUL
    for /f "usebackq skip=2 tokens=2,*" %%A IN ("%TEMP%\_envset.tmp") do (
        echo/set %~3=%%B
    )
    goto :EOF

:: Get a list of environment variables from registry
:GetRegEnv
    "%WinDir%\System32\Reg" QUERY "%~1" > "%TEMP%\_envget.tmp"
    for /f "usebackq skip=2" %%A IN ("%TEMP%\_envget.tmp") do (
        if /I not "%%~A"=="Path" (
            call :SetFromReg "%~1" "%%~A" "%%~A"
        )
    )
    goto :EOF

:main
    echo/@echo off >"%TEMP%\_env.cmd"

    :: Slowly generating final file
    call :GetRegEnv "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" >> "%TEMP%\_env.cmd"
    call :GetRegEnv "HKCU\Environment">>"%TEMP%\_env.cmd" >> "%TEMP%\_env.cmd"

    :: Special handling for PATH - mix both User and System
    call :SetFromReg "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" Path Path_HKLM >> "%TEMP%\_env.cmd"
    call :SetFromReg "HKCU\Environment" Path Path_HKCU >> "%TEMP%\_env.cmd"

    :: Caution: do not insert space-chars before >> redirection sign
    echo/set Path=%%Path_HKLM%%;%%Path_HKCU%% >> "%TEMP%\_env.cmd"

    :: Cleanup
    del /f /q "%TEMP%\_envset.tmp" 2>nul
    del /f /q "%TEMP%\_envget.tmp" 2>nul

    :: Set these variables
    call "%TEMP%\_env.cmd"

    echo | set /p dummy="Done"
    echo .
"@
if (-not (cmd.exe /c "where RefreshEnv")) {
    New-Item -Path "$Home\AppData\local\Microsoft\WindowsApps\" -Name "RefreshEnv.cmd" -ItemType "file" -Value $reset_command
}
function ExitIfFailed { 
    if ($?) { } else { echo "There was an error when performing the install. There should be other output included above"; exit 1 } 
}

$Env:path += "$Home\scoop\shims"

# use a better protocol to fix a bug
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# install git
scoop uninstall 7zip # for saftey reasons
scoop install 7zip
ExitIfFailed

scoop uninstall git
scoop install git
ExitIfFailed

scoop uninstall openssh
scoop install openssh
ExitIfFailed
# make sure the extras bucket is included
scoop bucket add extras
scoop bucket add versions
# install ruby & gem
scoop uninstall ruby
scoop install ruby
ExitIfFailed
$Env:path += "$Home\scoop\apps\ruby\current\bin"
# setup msys2 (for ruby)
scoop uninstall msys2
scoop install msys2
"exit
" | msys2
# install atk_toolbox
& "$Home\scoop\apps\ruby\current\bin\gem.cmd" install atk_toolbox
# create the atk temp directory if it doesn't exist
$temp_dir = "$Home\atk\temp"
if(!(Test-Path -Path $temp_dir )){
    md $temp_dir
}
# delete any previous setup
Remove-Item -Path "$Home\atk\temp\setup.rb" -Force -ErrorAction SilentlyContinue
# download and run the script
$install_script = (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/aggie-tool-kit/atk-stager/master/setup.rb')
New-Item -Path "$Home\atk\temp" -Name "setup.rb" -ItemType "file" -Value $install_script
ruby "$Home\atk\temp\setup.rb"
Clear-Host
read-host "
-------------------------------------
ATK should be successfully installed!
-------------------------------------

1. CMD needs to be restarted
2. If you have VS Code (or other command lines) they will also need to be restarted

Press ENTER to close this prompt
"
exit