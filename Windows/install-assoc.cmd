@echo off
@setlocal

    ::
    :: make edit verb default and use Editor
    ::

    call :SetEditorDefaultVerb batfile edit
    call :SetEditorDefaultVerb cmdfile edit
    call :SetEditorDefaultVerb jsfile  edit
    call :SetEditorDefaultVerb jsefile edit
    call :SetEditorDefaultVerb regfile edit
    call :SetEditorDefaultVerb vbefile edit
    call :SetEditorDefaultVerb vbsfile edit
    call :SetEditorDefaultVerb wsffile edit
    call :SetEditorDefaultVerb wshfile edit

    call :SetEditorDefaultVerb Microsoft.PowerShellData.1    edit
    call :SetEditorDefaultVerb Microsoft.PowerShellModule.1  edit
    call :SetEditorDefaultVerb Microsoft.PowerShellScript.1  edit
    call :SetEditorDefaultVerb Microsoft.PowerShellXMLData.1 edit

    ::
    :: change open or edit verb to use Editor
    :: instead of notepad, but keep open as
    :: the default verb
    ::

    call :SetEditorAssoc htmlfile edit
    call :SetEditorAssoc inffile  open
    call :SetEditorAssoc inifile  open
    call :SetEditorAssoc txtfile  open
    call :SetEditorAssoc xmlfile  edit

goto :eof

:SetEditorDefaultVerb (class)
    call :SetDefaultVerb %1 edit
    call :SetEditorAssoc  %1 edit
goto :eof

:SetDefaultVerb (class, verb)
    reg add HKCU\Software\Classes\%1\shell\ /f /ve /d %2 >NUL
goto :eof

:SetEditorAssoc (class, verb)
    call :SetAssoc %1 %2 "\"%%%%Editor%%%%\" \"%%%%1\""
goto :eof

:SetAssoc (class, verb, commandline)
    reg add HKCU\Software\Classes\%1\shell\%2\command /f /ve /t REG_EXPAND_SZ /d %3 > NUL
goto :eof
