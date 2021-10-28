#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Dmitriy Sukhov

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------


#include <GUIConstants.au3>
#include <MsgBoxConstants.au3>

Local $hGui, $msg, $inpBarCode, $BtnOk, $idComboBox

If $CmdLine[0] = 3 Then

   $barcode = $CmdLIne[1]
   $speed = $CmdLIne[1]
   $time = $CmdLIne[3]

   sleep($time)
   AutoItSetOption("SendKeyDelay",$speed)
   Send($barcode & "{ENTER}")
Else
Local $hGui, $msg, $inpBarCode, $BtnOk, $idComboBox

   $width = 330
   $height = 260

   $hGui = GUICreate("Barcode Scanner", 270, 210, @DesktopWidth/2 - $width/2, @DesktopHeight/2 - $height/2)
   GUICtrlCreateLabel("Введите штрихкод:", 10, 15, 150, 20, $GUI_SS_DEFAULT_INPUT)
   $inpBarCode = GUICtrlCreateInput("", 10, 35, 200, 20)
    GUICtrlSetTip($inpBarCode, "Поле для ввода штрихкода\трека карты\номера товара\ и т.д")
   GUICtrlCreateLabel("Установите скорость эмулятора (в мс):", 10, 65, 150, 30)
   $inpSpeed = GUICtrlCreateInput("0", 10, 95, 200, 20, $ES_NUMBER)
   GUICtrlSetTip($inpSpeed, "Изменяет продолжительность паузы между эмулированными нажатиями клавиш. По умолчанию 0")
   GUICtrlSetState(-1, $GUI_DROPACCEPTED)

   GUICtrlCreateLabel("Выберите приложение из списка:", 10, 120, 150, 30)
   Local $idComboBox = GUICtrlCreateCombo("Sales", 10, 150, 185, 20, $CBS_DROPDOWNLIST)
   GUICtrlSetData(-1, "Logistics" , "")
   GUICtrlSetData(-1, "Custom" , "")
   GUICtrlSetTip($idComboBox, "Здесь можно выбрать на какое приложение переключится и отсканировать штрихкод.")

   $BtnOk = GUICtrlCreateButton("Scan", 10, 180, 50)
   GUISetState()

   While 1
	   $msg = GUIGetMsg()
	   Switch $msg
		   Case $GUI_EVENT_CLOSE
			   ExitLoop
			Case $BtnOk
			   If StringInStr(GUICtrlRead($inpBarCode), " ") Then
				  MsgBox(0, "Error", "Значение поля «Введите штрихкод:» не должно содержать пробелов")
			   ElseIf GUICtrlRead($inpBarCode) == ""  Then
				    MsgBox(0, "Error", "Не введено значение штрихкода в поле «Введите штрихкод:»")
			   ElseIf GUICtrlRead($inpSpeed) == ""  Then
				    MsgBox(0, "Error", "Не установлена скорость эмулятора сканера")
			   Else
					handleApp()
			   EndIf
	   EndSwitch
	WEnd
 EndIf

  Func handleApp()
	  Local $tmp = GUICtrlRead($idComboBox)

	  Switch $tmp
		 Case "Sales"
			If (WinActivate("[REGEXPTITLE:NTSwincash sales/register EP12]")) Then
			   Scan()
			Else
			   MsgBox(0, "Error", "Главное окно Sales не открыто")
			EndIf
		 Case "Logistics"
			   If (WinActivate("[REGEXPTITLE:NTSwincash central logistics]")) Then
				  Scan()
			   	Else
				  MsgBox(0, "Error", "Главное окно Logistics не открыто")
			EndIf
		 Case Else
			   MsgBox($MB_SYSTEMMODAL, "Сканирование", "Пожалуйста, переключитесь на нужное приложение, сканирование начнется автоматически через 3 секунды.", 3)
			   Scan()
	  EndSwitch
   EndFunc


Func Scan()
   sleep(1000)
   AutoItSetOption("SendKeyDelay",$inpSpeed)
   Send(GUICtrlRead($inpBarCode) & "{ENTER}")
   EndFunc
