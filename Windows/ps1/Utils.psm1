function color($color)
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

Export-ModuleMember color, reboot, Test-IsAdmin