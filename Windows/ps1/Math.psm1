function pow($x,$n)
{
   [math]::pow($x, $n)
}

function log10($n)
{
    [math]::log10($n)
}

function fact($n)
{
    $result = 1; 
   
    while ($n -gt 1) 
    { 
        $result *= $n; 
        $n-- 
    }
    
    $result
}

Export-ModuleMember pow, log10, fact