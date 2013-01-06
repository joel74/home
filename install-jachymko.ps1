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
    Copy-Item $src $dest -Force
}

$jachymko = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$prefix = $Env:UserProfile

if (-not (Test-Path "$prefix\.jachymko")) {
	Install-Link $jachymko "$prefix\.jachymko"
}

Install-Copy "$jachymko\gitconfig" "$prefix\.gitconfig"
Install-Link "$jachymko\gitignore" "$prefix\.gitignore"
Install-Link "$jachymko\vim"       "$prefix\.vim"
Install-Link "$jachymko\vim\vimrc" "$prefix\_vimrc"

$jachymkoPS1 = "$jachymko\Windows\ps1"
$Env:Editor  = "$jachymko\Windows\vim\gvim.exe"


$UserPath = "$jachymko\Windows\bin;$jachymkoPS1"
$Env:Path = "$UserPath;$Env:Path"
$Env:PSModulePath = "$jachymkoPS1;$Env:PSModulePath"

setx Path   $UserPath
setx Editor $Env:Editor
setx PSModulePath $Env:PSModulePath

& "$jachymko\Windows\install-7zip.ps1" $prefix