param($jachymko)

if (-not $jachymko) {
    throw "path to jachymko dotfiles not specified"
}

$extensions = '001 7z arj bz2 bzip2 cab cpio deb dmg fat gz gzip hfs ' +
              'iso lha lzh lzma ntfs rar rpm squashfs swm tar taz tbz ' +
              'tbz2 tgz tpz txz vhd wim xar xz z zip' -split ' '

$Root7z = "HKCU\Software\7-Zip"

write-host "Installing 7zip: " -NoNewline

reg add $Root7z    /f /v Lang              /d en >$null
reg add $Root7z\FM /f /v Editor            /d $Env:Editor >$null
reg add $Root7z\FM /f /v ShowDots          /d 1 /t REG_DWORD >$null
reg add $Root7z\FM /f /v ShowRealFileIcons /d 1 /t REG_DWORD >$null
reg add $Root7z\FM /f /v FullRow           /d 1 /t REG_DWORD >$null
reg add $Root7z\FM /f /v Toolbars          /d 1 /t REG_DWORD >$null

$extensions |% {
	reg add "HKCU\Software\Classes\.$_"                         /f /ve /d "7-Zip.$_" >$null
	reg add "HKCU\Software\Classes\7-Zip.$_\Shell\open\command" /f /ve /d "\""$jachymko\Windows\bin\7zip\7zFM.exe\"" \""%1\""" >$null
	reg add "HKCU\Software\Classes\7-Zip.$_\DefaultIcon"        /f /ve /t REG_EXPAND_SZ /d '%SystemRoot%\system32\zipfldr.dll' >$null
    write-host ".$_ " -NoNewline
}

Write-Host