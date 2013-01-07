$gitshell = '~\AppData\Local\GitHub\shell.ps1'

if (-not (Test-Path $gitshell)) {
    write-warning 'GitHub not installed! Get it at http://windows.github.com/'
    Export-ModuleMember -Function @()
    exit
}

. $gitshell -SkipSSHSetup

function Get-GitLinkItem
{
    git ls-files -s |? {
        $_ -match '^120000 (?<sha>.{40}) (.)\s+(?<path>.*)$' } |% {
        (Get-Item $matches['path'])
    }
}

function Get-GitBranch
{
    switch -regex (git branch --verbose)
    {
        '^\* ((?<NoBranch>\(no branch\))|(?<Branch>\w+))\s+(?<Hash>\w+)'
        {
            if ($matches['NoBranch'])
            {
                return $matches['Hash']
            }

            return $matches['Branch']
        }
    }
}

function Get-GitIndexDiff
{
    $added    = 0;
    $deleted  = 0;
    $modified = 0;

    foreach ($f in (git diff-index --cached --name-status HEAD))
    {
        switch ($f[0])
        {
            'A' { $added++ }
            'D' { $deleted++ }
            'M' { $modified++ }
        }
    }

    if ($modified -or ($added -and $deleted))
    {
        return [Char]0x00b1 # plus-minus sign
    }

    if ($added)   { return '+' }
    if ($deleted) { return '-' }

    return ''
}

function Get-GitCachedChanges
{
    if (git ls-files --modified --deleted --others --exclude-standard --directory)
    {
        return [Char]0x2736 # sixpointed black star
    }
}

function Get-GitRepositoryRoot
{
    $path = $pwd.path

    do
    {
        if (test-path $(join-path $path '.git') -type container)
        {
            return $path
        }

        $path = split-path $path -parent
    }
    while ($path)
}

function Get-GitRepositoryName
{
    return split-path (Get-GitRepositoryRoot) -leaf
}

function PromptExtension
{
    $repo = Get-GitRepositoryName

    if ($repo)
    {
        "$($repo)$([Char]0x205e)$(Get-GitIndexDiff)$(Get-GitBranch)$(Get-GitCachedChanges)"
    }
}

