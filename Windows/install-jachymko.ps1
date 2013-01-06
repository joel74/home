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

$jachymko = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$prefix = $Env:UserProfile

if (-not (Test-Path "$prefix\.jachymko")) {
	Install-Link $jachymko "$prefix\.jachymko"
}

Install-Link "$jachymko\gitconfig" "$prefix\.gitconfig"
Install-Link "$jachymko\gitignore" "$prefix\.gitignore"
Install-Link "$jachymko\vim"       "$prefix\.vim"
Install-Link "$jachymko\vim\vimrc" "$prefix\_vimrc"
