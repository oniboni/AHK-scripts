#Persistent
#SingleInstance
SetKeyDelay, 0, 200
;SendMode Play

SetFormat, float, 03  ; Omit decimal point from axis position percentages.
GetKeyState, joy_buttons, JoyButtons


Info(joy_buttons, joy_name, joy_info)
{
	info = 
	Loop %joy_buttons%
	{
		GetKeyState, joy%a_index%, joy%a_index%
		state := joy%a_index%
		info = %info%Getkeystate`,joy%a_index%`, joy%a_index% %state%`n
	}
	
	MsgBox, Name: %joy_name%`nInfo: %joy_info%`nButtons: %joy_buttons%`n%info%
	return
}

gosub TestActive
;Info(joy_buttons, joy_name, joy_info)


SetTimer, WatchButtons, 5
SetTimer, WatchPOVandAxis, 5 	; Bewegen
SetTimer, WatchZABXY, 5			; Laufen Kriechen
SetTimer, WatchR, 5 			; Objekte vor/zurueck
SetTimer, TestActive, 1000

return

TestActive:
	GetKeyState, joy_name, JoyName
	GetKeyState, joy_info, JoyInfo
	IfNotInString, joy_name, Microsoft PC-Joystick Driver
	{
		MsgBox, XBOX Controller not connected.
		ExitApp
	}
	return

WatchPOVandAxis:
	GetKeyState, JoyX, JoyX  ; Get position of X axis.
	GetKeyState, JoyY, JoyY  ; Get position of Y axis.
	GetKeyState, POV, JoyPOV  ; Get position of the POV control.
	XKeyPrev = %XKey%  ; Prev now holds the key that was down before (if any).
	YKeyPrev = %YKey%
	
	XKey =
	YKey =
	
	if POV < 0   ; No angle to report
	{	
		if JoyX > 70
			XKey = Right
		else if JoyX < 30
			XKey = Left

		if JoyY > 70
			YKey = Down
		else if JoyY < 30
			YKey = Up
	}
	else 
	{
		if POV > 29250
			YKey = Up
		else if POV between 0 and 6750
			YKey = Up
		else if POV between 11251 and 24750
			YKey = Down
			
		if POV between 2251 and 15750
			XKey = Right
		else if POV between 20251 and 33750
			XKey = Left
	}
	
	;ToolTip, XKeyPrev:    %XKey%`nYKeyPrev: %YKey%
	
	if XKey <> XKeyPrev
		if XKeyPrev
			Send {%XKeyPrev% up}
		if XKey
			Send {%XKey% down}
	
	if YKey <> YKeyPrev
		if YKeyPrev
			Send {%YKeyPrev% up}
		if YKey
			Send {%YKey% down}
	
	Sleep 100
	
	return
	
WatchZABXY:
	GetKeyState, Z, JoyZ ; LT and RT
	GetKeyState, A, Joy1
	GetKeyState, B, Joy2
	GetKeyState, X, Joy3
	GetKeyState, Y, Joy4
	KeyPrev = %Key%

	if Z = 100
		Key = LCtrl ;Kriechen
	else if Z = 0
		Key = Shift ;Rennen
	else if A = D		;Aktionstasten Anzeige
		Key = Numpad2
	else if B = D
		Key = Numpad6
	else if X = D
		Key = Numpad4
	else if Y = D
		Key = Numpad8
	else
		Key =
	
	;ToolTip, XKeyPrev: %Key%
	
	if Key = %KeyPrev% 
		return
		
	if KeyPrev
		Send, {%KeyPrev% up}
	if Key
		Send, {%Key% down}
		
	return

WatchR:
	GetKeyState, R, JoyR ; UP/DOWN right JS
	;ToolTip, R: %R%

	if R = 000
		Send {PgUp} ; naechstes Obj.
	if R = 100
		Send {PgDn} ; vorheriges Obj.

	return

WatchButtons:
	;GetKeyState, A, Joy1
	;GetKeyState, B, Joy2
	;GetKeyState, X, Joy3
	;GetKeyState, Y, Joy4
	;GetKeyState, LB, Joy5
	GetKeyState, RB, Joy6
	GetKeyState, Back, Joy7
	GetKeyState, Start, Joy8
	;GetKeyState, LJ, Joy9
	;GetKeyState, RJ, Joy10
	
	; Pause
	if Back = D 
		Send {Esc}
	
	; Enter
	if Start = D 
		Send {Enter}
	
	; Inventar
	if RB = D
		Send {Space}
	
	return
