param ([switch]$nolink)

function Install-Link($src, $dest) {
    if (Test-Path -PathType Container $dest) {
        cmd /c rmdir "$dest"
    }
    elseif (Test-Path -PathType Leaf $dest) {
        cmd /c del "$dest"
    }

    if (Test-Path -PathType Container $src) {
        cmd /c mklink /j "$dest" "$src"
    }
    elseif (Test-Path -PathType Leaf $src) {
        cmd /c mklink "$dest" "$src"
    }
}

function Install-Copy($src, $dest) {
    Copy-Item $src $dest -Force -Verbose
}

function Install-EnvVar($name, $value) {
    write-host "setx $name $value"
    setx $name $value >$null
}

$jachymko = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$jachymkoPS1 = "$jachymko\Windows\ps1"
$prefix = $Env:UserProfile

import-module "$jachymkoPS1\Utils.psm1" -force

if (-not (Test-IsAdmin) -and -not $nolink) {
    throw "This script should be ran elevated because it creates directory junctions.`r`n" +
          "Alternatively, you can run it with -NoLink, in which case everything will be`r`n" +
          "copied to $Env:UserProfile."
}

if ($nolink) {
    write-warning "Copying files instead of making junctions!!!"
}

if (-not (Test-Path "$prefix\.jachymko")) {
    Install-Link $jachymko "$prefix\.jachymko"
}

Install-Copy "$jachymko\gitconfig"   "$prefix\.gitconfig"
Install-Link "$jachymko\gitignore"   "$prefix\.gitignore"
Install-Link "$jachymko\vim"         "$prefix\vimfiles"
Install-Link "$jachymko\vim\vimrc"   "$prefix\_vimrc"
Install-Link "$jachymko\vim\gvimrc"  "$prefix\_gvimrc"
Install-Link "$jachymko\Windows\ps1" "$prefix\Documents\WindowsPowerShell" 

$Env:Editor  = "$jachymko\Windows\bin\vim\gvim.exe"

$UserPath = "$jachymko\Windows\bin;$jachymkoPS1"
$Env:Path = "$UserPath;$Env:Path"
$Env:PSModulePath = "$jachymkoPS1;$Env:PSModulePath"

Install-EnvVar Path   $UserPath
Install-EnvVar Editor $Env:Editor
Install-EnvVar SModulePath $jachymkoPS1

Get-ChildItem $jachymko\Windows\install-* |% {
    switch -Regex($_.FullName) {
        '\.(cmd|ps1)$' { & $_; break }
        '\.reg$'       { reg import $_ 2>$null; break }
    }
}
