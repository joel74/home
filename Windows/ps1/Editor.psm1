function e {
    $OFS = "`n"
    $strings = "$input" -replace "`r`n", "`n"
    $OutputEncoding = new-object Text.UTF8Encoding $false

    if ($strings) {
        $strings | & $Env:Editor @args -
    }
    else {
        if ($args.length) {
            & $Env:Editor --remote-silent @args
        }
        else {
            & $Env:Editor --remote-silent 
        }
    }
}
