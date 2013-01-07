#requires -version 2
$typename = 'SendMessageTimeout_6a057adb_f92f_4e34_bda2_42bc79d05f5c'
$type     = $typename -as [type]
if (-not $type) {
    # import sendmessagetimeout from win32
    $type = add-type -pass -Name $typename -MemberDefinition @"
    [DllImport("user32", SetLastError = true)]
    public static extern IntPtr SendMessageTimeout(
        IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
        uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@
}

$result           = [uintptr]::zero
$HWND_BROADCAST   = [intptr]0xffff
$WM_SETTINGCHANGE = [uint32]0x1a
$SMTO_NORMAL      = [uint32]0

# notify all windows of environment block change
$null = $type::SendMessageTimeout(
    $HWND_BROADCAST, $WM_SETTINGCHANGE,
    [uintptr]::Zero, "Environment",
    $SMTO_NORMAL, 1000, [ref]$result)
