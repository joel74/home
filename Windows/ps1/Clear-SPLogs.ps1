$Hive12 = "$Env:CommonProgramFiles\Microsoft Shared\Web Server Extensions\12"
$Services = 'SPTimerV3', 'SPTrace', 'W3SVC'

$LogSize = $(get-item $Hive12\LOGS\* -force | measure-object length -sum).sum / 1mb


stop-service $Services -force

write-warning ("Deleting {0:0.00} MB of logs..." -f $LogSize)
remove-item $Hive12\LOGS\* -force

start-service $Services
