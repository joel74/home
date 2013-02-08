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

function which($cmd)
{
    (Get-Command $cmd).Definition
}

function guid($f)
{
    [Guid]::NewGuid().ToString($f)
}

function deurl($s)
{
    [web.httputility]::UrlDecode($s)
}

function Install-Assembly {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]] $LiteralPath
    )
    process {
        foreach ($p in $LiteralPath) {
            $PSCmdlet.WriteVerbose("Adding $p to GAC")
            & ~\.jachymko\Windows\bin\GacUtil.exe -nologo -i $p
        }
    }
}

set-alias gac Install-Assembly
set-alias la Get-ChildItem
export-modulemember -alias * -function *
