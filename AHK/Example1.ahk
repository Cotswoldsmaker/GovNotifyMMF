; Send SMS messages, emails for letters

; *********
; Variables
; *********

GUKN_type := ""
GUKN_mobileNumber := ""

GUKN_email_address := ""
GUKN_email_subject := ""
GUKN_email_body := ""

GUKN_letter_to := ""
GUKN_letter_address := ""
GUKN_letter_from := ""
GUKN_letter_header := ""
GUKN_letter_body := ""

CurrentDirectory := A_ScriptDir . "\"
pythonEXEPath := CurrentDirectory . "Library\GovNotifyMMF.exe"

dialogueColour := "00FFFF"
Developing := True




; *********
; Libraries
; *********

#include %A_ScriptDir%\Library\Private variables.ahk
#include %A_ScriptDir%\Library\Requests.ahk
#include %A_ScriptDir%\Library\VBA_AHK_IPC.ahk



; *********
; Functions
; *********

GOV_UK_Notify()
msgbox, Complete
ExitApp



