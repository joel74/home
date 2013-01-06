dir ~\.jachymko\Windows\ps1\*.psm1 | import-module -force

if (([io.driveinfo]'d:').DriveType -eq 'Fixed') {
    cd d:\
}
