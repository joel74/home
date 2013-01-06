function prompt_history
{
    $id = 0
    $item = Get-History -Count 1

    if ($item)
    {
        $id = $item.Id
    }

    ($id + 1)
}

function Update-Title
{
    $title = (get-location).ProviderPath

    if ($title -match '\:\:(.*)$')
    {
        $title = $matches[1]
    }

    $title += ' - Windows PowerShell'

    if ($IsAdmin)
    {
        $title += ' (Administrator)'
    }

    $host.UI.RawUI.WindowTitle = $title
}

function prompt
{
    Write-Host -NoNewLine -ForegroundColor Yellow "[$(Prompt_history)] "

    if ($Function:PromptExtension)
    {
        $value = (PromptExtension)

        if ($value)
        {
            Write-Host -NoNewLine -ForegroundColor Yellow "[$value] "
        }
    }

    Write-Host -NoNewLine -ForegroundColor Yellow "$([Char]0x00bb)"

    Update-Title
    return " "
}

Export-ModuleMember -Function prompt 
