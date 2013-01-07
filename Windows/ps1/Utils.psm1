﻿function color($color)
{
    & $Env:ComSpec /c color $color
}

function Test-IsAdmin
{
    $wi = [Security.Principal.WindowsIdentity]::GetCurrent()

    try
    {
        $principal = new-object Security.Principal.WindowsPrincipal $wi
        $principal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator )
    }
    finally
    {
        $wi.Dispose()
    }
}

function reboot
{
    shutdown -f -r -t 0
}

function which($cmd)
{
    (Get-Command $cmd).Definition
}

function guid($f)
{
    [Guid]::NewGuid().ToString($f)
}
