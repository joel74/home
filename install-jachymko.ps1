param ([switch]$nolink)

$jachymko = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$jachymkoPS1 = "$jachymko\Windows\ps1"
$prefix = $Env:UserProfile

ls $jachymkoPS1\*.psm1 | import-module -force

function Install-Link($src, $dest) {
    if (Test-Path $dest -PathType Container) {
        # delete destination using rmdir
        # removes junctions but doesn't delete the linked content
        cmd /c rmdir $dest /s /q
    }
    elseif (Test-Path $dest -PathType Leaf) {
        cmd /c del $dest /f
    }

    if ($nolink) {
        Install-Copy $src $dest
    }
    else {
        if (Test-Path $src -PathType Container) {
            cmd /c mklink /j $dest $src
        }
        elseif (Test-Path $src -PathTy Leaf) {
            cmd /c mklink $dest $src
        }
        else {
            Write-Warning "$src not found"
        }
    }
}

function Install-Copy($src, $dest) {
    if (Test-Path $src -PathType Container) {
        cmd /c mkdir $dest
        cmd /c xcopy $src $dest /e /f
    }
    else {
        cmd /c copy $src $dest
    }
}

function Install-EnvVar($name, $value) {
    write-host "setx $name $value"
    setx $name $value >$null
}

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
Install-EnvVar PSModulePath $jachymkoPS1

Get-ChildItem $jachymko\Windows\install-* |% {
    switch -Regex($_.FullName) {
        '\.(cmd|ps1)$' { & $_; break }
        '\.reg$'       { reg import $_ 2>$null; break }
    }
}

cd $jachymko
git submodule update --init
