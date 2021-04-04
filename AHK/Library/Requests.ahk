; Requests

GOV_UK_Notify()
{
	global dialogueColour, GUKN_type
	
	title := "Notification type"
	GUIStart := 60
	GUIWidth := 100
	yAdditive := 10
	
	Gui, GUKN_main:Font, s12
	Gui, GUKN_main:Color, % dialogueColour
	Gui, GUKN_main:Add, Text, x10 y%yAdditive%, Type:
	Gui, GUKN_main:Add, DropDownList, x%GUIStart% y%yAdditive% W%GUIWidth% vGUKN_type, SMS||email|letter
	
	yAdditive := yAdditive + 50
	
	Gui, GUKN_main:Add, Button, x150 y%yAdditive% default gGUKN_mainOK,  &OK
	Gui, GUKN_main:Add, Button, x200 y%yAdditive% gGUKN_mainClose,  &Cancel
	Gui, GUKN_main:Show,, % title
	Gui, GUKN_main:+AlwaysOnTop
	WinWaitClose, % title
	return
}




GUKN_mainOK()
{
	global GUKN_type
	
	Gui, GUKN_main:Submit, NoHide
	Gui, GUKN_main:Destroy
	
	if (GUKN_type == "SMS")
	{
		GUKN_SMS()
	}
	else if (GUKN_type == "email")
	{
		GUKN_email()
	}
	else if (GUKN_type == "letter")
	{
		GUKN_letter()
	}
	
	return
}




GUKN_mainButtonCancel()
{
	GUKN_mainClose()
}
GUKN_mainGuiClose()
{
	GUKN_mainClose()
}
GUKN_mainClose()
{
	Gui, GUKN_main:Destroy
	return
}




GUKN_SMS()
{
	global dialogueColour, GUKN_mobileNumber, GUKN_SMS_message
	
	title := "Send SMS message"
	GUIStart := 120
	GUIWidth := 300
	yAdditive := 10
	
	Gui, GUKN_SMS:Font, s12
	Gui, GUKN_SMS:Color, % dialogueColour
	Gui, GUKN_SMS:Add, Text, x10 y%yAdditive%, Mobile number:
	Gui, GUKN_SMS:Add, Edit, x%GUIStart% y%yAdditive% W%GUIWidth% vGUKN_mobileNumber
	yAdditive := yAdditive + 50
	
	Gui, GUKN_SMS:Add, Text, x10 y%yAdditive%, Message:
	Gui, GUKN_SMS:Add, Edit, x%GUIStart% y%yAdditive% W%GUIWidth% H100 vGUKN_SMS_message, % "Test Message, change as needed"
	yAdditive := yAdditive + 120
	
	Gui, GUKN_SMS:Add, Button, x300 y%yAdditive% default gGUKN_SMSOK,  &OK
	Gui, GUKN_SMS:Add, Button, x350 y%yAdditive% gGUKN_SMSClose,  &Cancel
	Gui, GUKN_SMS:Show,, % title
	Gui, GUKN_SMS:+AlwaysOnTop
	WinWaitClose, % title

	return
}




GUKN_SMSOK()
{
	global CurrentDirectory, dialogueColour, API_key
	global SMS_template_ID, GUKN_mobileNumber
	global GUKN_SMS_message
	
	pass := False
	
	Gui, GUKN_SMS:Submit, NoHide
	Gui, GUKN_SMS:Destroy
	
	if !MobileNumberCheck(GUKN_mobileNumber)
		return "Fail"

	MobileNumber := "+44" . SubStr(GUKN_mobileNumber, 2)
	variables := "SMS;" . API_key . ";" . SMS_template_ID . ";" .  MobileNumber . ";" .  GUKN_SMS_message
	sendMessageGUKN("SMS message", variables)
	return
}




GUKN_SMSButtonCancel()
{
	GUKN_SMSClose()
}
GUKN_SMSGuiClose()
{
	GUKN_SMSClose()
}
GUKN_SMSClose()
{
	Gui, GUKN_SMS:Destroy
	return
}




GUKN_email()
{
	global dialogueColour, GUKN_email_address, GUKN_email_subject, GUKN_email_body
	
	title := "Send email"
	GUIStart := 120
	GUIWidth := 300
	yAdditive := 10
	
	Gui, GUKN_email:Font, s12
	Gui, GUKN_email:Color, % dialogueColour
	Gui, GUKN_email:Add, Text, x10 y%yAdditive%, email:
	Gui, GUKN_email:Add, Edit, x%GUIStart% y%yAdditive% W%GUIWidth% vGUKN_email_address, % "mark.allan.bailey@gmail.com"
	yAdditive := yAdditive + 50
	
	Gui, GUKN_email:Add, Text, x10 y%yAdditive%, % "Subject:"
	Gui, GUKN_email:Add, Edit, x%GUIStart% y%yAdditive% W%GUIWidth% H100 vGUKN_email_subject, % "Test subject, change as needed"
	yAdditive := yAdditive + 120
	
	Gui, GUKN_email:Add, Text, x10 y%yAdditive%, % "Body:"
	Gui, GUKN_email:Add, Edit, x%GUIStart% y%yAdditive% W%GUIWidth% H100 vGUKN_email_body, % "Test body, change as needed"
	yAdditive := yAdditive + 120
	
	Gui, GUKN_email:Add, Button, x200 y%yAdditive% default gGUKN_emailOK,  &OK
	Gui, GUKN_email:Add, Button, x250 y%yAdditive% gGUKN_emailClose,  &Cancel
	Gui, GUKN_email:Show,, % title
	Gui, GUKN_email:+AlwaysOnTop
	WinWaitClose, % title

	return
}




GUKN_emailOK()
{
	global CurrentDirectory, dialogueColour, API_key
	global email_template_ID
	global GUKN_email_address, GUKN_email_subject, GUKN_email_body
	
	Gui, GUKN_email:Submit, NoHide
	Gui, GUKN_email:Destroy
	
	if (not InStr(GUKN_email_address, "@"))
	{
		msgbox, % "Error with email address, please try again!"
		return False
	}

	variables := "email;" . API_key . ";" . email_template_ID . ";" .  GUKN_email_address . ";" .  GUKN_email_subject . ";" . GUKN_email_body
	sendMessageGUKN("email", variables)
	return True
}




GUKN_emailButtonCancel()
{
	GUKN_emailClose()
}
GUKN_emailGuiClose()
{
	GUKN_emailClose()
}
GUKN_emailClose()
{
	Gui, GUKN_email:Destroy
	return
}




GUKN_letter()
{
	global dialogueColour, GUKN_letter_to, GUKN_letter_address
	global GUKN_letter_from, GUKN_letter_header, GUKN_letter_body
	
	title := "Send letter"
	GUIStart := 120
	GUIWidth := 600
	yAdditive := 10
	
	Gui, GUKN_letter:Font, s12
	Gui, GUKN_letter:Color, % dialogueColour
	Gui, GUKN_letter:Add, Text, x10 y%yAdditive%, To:
	Gui, GUKN_letter:Add, Edit, x%GUIStart% y%yAdditive% W%GUIWidth% vGUKN_letter_to, % "Mark Bailey"
	yAdditive := yAdditive + 50
	
	Gui, GUKN_letter:Add, Text, x10 y%yAdditive%, Address:
	Gui, GUKN_letter:Add, Edit, x%GUIStart% y%yAdditive% W%GUIWidth% H100 vGUKN_letter_address, % "Gaudete 1 Hambutts Mead`r`nPainswick`r`nGL6 6RP"
	yAdditive := yAdditive + 120
	
	Gui, GUKN_letter:Add, Text, x10 y%yAdditive%, % "From:"
	Gui, GUKN_letter:Add, Edit, x%GUIStart% y%yAdditive% W%GUIWidth% H30 vGUKN_letter_from, % "Dr Mark Bailey"
	yAdditive := yAdditive + 40
	
	Gui, GUKN_letter:Add, Text, x10 y%yAdditive%, % "Header:"
	Gui, GUKN_letter:Add, Edit, x%GUIStart% y%yAdditive% W%GUIWidth% H100 vGUKN_letter_header, % "Test header, change as needed"
	yAdditive := yAdditive + 120
	
	Gui, GUKN_letter:Add, Text, x10 y%yAdditive%, % "Letter body:"
	Gui, GUKN_letter:Add, Edit, x%GUIStart% y%yAdditive% W%GUIWidth% H100 vGUKN_letter_body, % "Test body, change as needed"
	yAdditive := yAdditive + 120
	
	Gui, GUKN_letter:Add, Button, x200 y%yAdditive% default gGUKN_letterOK,  &OK
	Gui, GUKN_letter:Add, Button, x250 y%yAdditive% gGUKN_letterClose,  &Cancel
	Gui, GUKN_letter:Show,, % title
	Gui, GUKN_letter:+AlwaysOnTop
	WinWaitClose, % title

	return
}




GUKN_letterOK()
{
	global CurrentDirectory, dialogueColour, API_key
	global letter_template_ID
	global GUKN_letter_to, GUKN_letter_address
	global GUKN_letter_from, GUKN_letter_header, GUKN_letter_body
	
	Gui, GUKN_letter:Submit, NoHide
	Gui, GUKN_letter:Destroy
	
	addressConverted := GUKN_letter_to . "`n" . GUKN_letter_address
	addressConverted := strReplace(addressConverted, "`n", "//")
	variables := "letter;" . API_key . ";" . letter_template_ID . ";" . addressConverted . ";" . GUKN_letter_from . ";" .  GUKN_letter_header . ";" . GUKN_letter_body
	sendMessageGUKN("Letter", variables)
	return
}




GUKN_letterButtonCancel()
{
	GUKN_letterClose()
}
GUKN_letterGuiClose()
{
	GUKN_letterClose()
}
GUKN_letterClose()
{
	Gui, GUKN_letter:Destroy
	return
}




sendMessageGUKN(method, variables, MMF := False)
{
	global pythonEXEPath
	
	outcome := "timeOut"

	pythonMessages := new MemoryMappedFile_IPC("AHK_2_Python_IPC", False)
	pythonMessages.send("GOV_UK_notify", variables)

	Run, % pythonEXEPath ;,, Hide
	
	Loop 600		; 600 x 100 = 1 min
	{
		returnResult := pythonMessages.read()
		returnResultSplit := strSplit(returnResult, "|")
		
		if (returnResultSplit[1] = "SPRead")
		{
			outcome := returnResultSplit[2]
			break
		}
		
		sleep 100
	}
	
	if (instr(outcome, "pass") = 1)
	{
		;msgbox, % method . " sent " . outcome
		return True
	}
	else if (outCome = "timeOut")
	{
		msgbox, % "The GOV.uk Notification program (written in python) did not start and hence the " . method . " has not been sent!"
		return False
	}
	else if (outcome = "Wrong initial arguement")
	{
		msgbox, % "Wrong initial arguement provided"
		return False
	}
	else if (outcome = "fail")
	{
		msgbox, % method . " - request failed!"
		return False
	}
	else if (outcome = "wrong method")
	{
		msgbox, % method . " - wrong method provided to python script"
		return False
	}
	else
	{
		msgbox, % "AHK error with " . method . " function [" . outcome . "]!"
		return False
	}	
	
	return False
}




MobileNumberCheck(number)
{
	if (StrLen(number) == 11)
		if (SubStr(number,1,2) == "07")
			if (not number ~= "[^0-9]")
				return True
	
	; Return false if above fails
	msgbox, % "Error with mobile number. Please try again"
	return False

}



