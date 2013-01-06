function Start-MSSQL
{
    Start-Service 'MSSQL*' -Exclude '*ADHelper*'
}

function Stop-MSSQL
{
    Stop-Service 'MSSQL*' -Force
}
