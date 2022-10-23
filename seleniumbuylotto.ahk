SChrome_UpdateDriver()
;셀레니움 업데이트

Gui, Add, Edit, x12 y9 w220 h30 -VScroll vusername, ID
Gui, Add, Edit, x12 y49 w220 h30 -VScroll vuserpass , Password
Gui, Add, Button, x242 y9 w80 h70 -VScroll gbuy default, 자동구매
GuiControl, +password -WantReturn, userpass
Gui, Show, x1037 y541 h91 w333, 로또 자동구매기
Return

GuiClose:
ExitApp

buy:
gui,submit,nohide
gui destroy
coordmode, mouse, screen
coordmode, pixel, screen

IfWinNotExist,ahk_class Chrome_WidgetWin_1
{
FileGetVersion, Version_Chrome, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
if(ErrorLevel=1)
{
	run, "C:\Program Files\Google\Chrome\Application\chrome.exe" "--remote-debugging-port=9222"
}else{
	run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "--remote-debugging-port=9222"
}

	on=0
}
; 크롬 켜져있는지 확인 꺼져있으면 on에 0저장

IfWinExist,ahk_class Chrome_WidgetWin_1
{
	WinActivate,ahk_class Chrome_WidgetWin_1
	send,^t
	on=1
}
; 크롬 켜져있어서 ctrl+t로 새탭열고 a변수에 1저장


if(on=1)
{
	driver.switchtonextwindow()
;크롬이 켜져있기때문에 탭전환 셀리니움명령
}


driver:=Chromeget()

sleep,500

driver.get("https://dhlottery.co.kr")
sleep,500

driver.window.maximize()
sleep,500


money := driver.PageSource()
FoundPos:=RegExMatch(money, "var userId = ""(.*?)"";", output, sp:=1)


if (output1="")
	;로그인이 안되어있을때
{
While (! loginbtn := driver.FindElementByXpath("/html/body/div[1]/header/div[2]/div[2]/form/div/ul/li[1]"))
    Sleep, 10
loginbtn.click()

;로그인버튼클릭

While (! id := driver.FindElementByXpath("//*[@id='userId']"))
	Sleep, 10
id.clear()


sleep,500

id.sendkeys(username)

pass:= driver.FindElementByXpath("//*[@id='article']/div[2]/div/form/div/div[1]/fieldset/div[1]/input[2]")
pass.sendkeys(userpass)

login := driver.FindElementByXpath("//*[@id='article']/div[2]/div/form/div/div[1]/fieldset/div[1]/a")
login.click()

}


While (! buy:= driver.FindElementByXpath("//*[@id='gnb']/ul/li[1]/a"))
	sleep, 10
buy.click()
sleep, 500
lotto:=driver.FindElementByXpath("//*[@id='gnb']/ul/li[1]/div/ul/li[1]/a")
lotto.click()
sleep, 500


driver.SwitchToNextWindow()
sleep,500


driver.SwitchToFrame("ifrm_tab")
sleep,500


loop,5
{


Random, num1, 1, 45

Loop
{
Random, num2, 1, 45
if (num2 = num1)
{
Continue
}
break
}

Loop
{

Random, num3, 1, 45

if (num3 = num1 || num3 = num2)

{

Continue

}

break

}

Loop
{

Random, num4, 1, 45

if (num4 = num1 || num4 = num2 || num4 = num3)

{

Continue

}

break

}

Loop

{

Random, num5, 1, 45

if (num5 = num1 || num5 = num2 || num5 = num3 || num5 = num4)

{

Continue

}

break

}

Loop

{

Random, num6, 1, 45

if (num6 = num1 || num6 = num2 || num6 = num3 || num6 = num4 || num6 = num5)

{

Continue

}

break

}

;MsgBox, %num1% | %num2% | %num3% | %num4% | %num5% | %num6%


num := [num1,num2,num3,num4,num5,num6]

while(a_index<7){
pos := "/html/body/div[1]/div[2]/div[1]/div[2]/div[1]/div[1]/div[2]/label[" . num[A_index] . "]"
;MsgBox, % pos
driver.findElementByXpath(pos).click()
}
sleep, 500
driver.findElementByXpath("/html/body/div[1]/div[2]/div[1]/div[2]/div[1]/div[2]/input").click()
}
ExitApp

F12::
ExitApp
return

F11::
reload
return


ChromeGet(IP_Port := "127.0.0.1:9222")
{
	driver := ComObjCreate("Selenium.ChromeDriver")
	driver.SetCapability("debuggerAddress", IP_Port)
	driver.Start()
	return driver
}


SChrome_UpdateDriver(){
	; Function Updates the Chromedriver by checking the versions and downloading the latest chromedriver.
	; Written by AHK_User
	; Thanks to tmplinshi

	;~ Dir_Chromedriver:= "C:\Users\" A_UserName "\AppData\Local\SeleniumBasic\chromedriver.exe"
	Dir_Chromedriver:= "C:\Program Files\SeleniumBasic\chromedriver.exe"

	SplitPath, Dir_Chromedriver, , Folder_Chromedriver
	;C:\Program Files\Google\Chrome\Application\chrome.exe
	;C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
	FileGetVersion, Version_Chrome, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
	if(ErrorLevel=1)
	{
		FileGetVersion, Version_Chrome, C:\Program Files\Google\Chrome\Application\chrome.exe
	}


	Version_Chrome := RegexReplace(Version_Chrome, "\.\d+$")

	; Get Chromedriver version
	Version_ChromeDriver := RunHide("""" Dir_Chromedriver """ --version")
	;~ DebugWindow("`nVersion Chromedriver:" Version_Chromedriver,Clear:=0,LineBreak:=1)
	Version_ChromeDriver := RegexReplace(Version_ChromeDriver, "[^\d]*([\.\d]*).*", "$1")

	;~ DebugWindow("Version Chrome:"  Version_Chrome "`nVersion Chromedriver:" Version_Chromedriver,Clear:=0,LineBreak:=1)

	; Check if versions are equal
	if InStr(Version_Chromedriver, Version_Chrome){
		return
	}

; Find the matching Chromedriver
	oHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	oHTTP.Open("GET", "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_"  Version_Chrome, true)
	oHTTP.Send()
	oHTTP.WaitForResponse()
	Version_Chromedriver := oHTTP.ResponseText

	;~ DebugWindow("The latest release of Chromedriver is:" Version_ChromeDriver,Clear:=0,LineBreak:=1)

	if InStr(Version_Chromedriver, "NoSuchKey"){
		MsgBox,16,Testing,Error`nVersion_Chromedriver
		return
	}

; Download the Chromedriver
	Url_ChromeDriver := "https://chromedriver.storage.googleapis.com/" Version_Chromedriver "/chromedriver_win32.zip"
	URLDownloadToFile, %Url_ChromeDriver%,  %A_ScriptDir%/chromedriver_win32.zip

; Unzip Chromedriver_win32.zip
	fso := ComObjCreate("Scripting.FileSystemObject")
	AppObj := ComObjCreate("Shell.Application")
	FolderObj := AppObj.Namespace(A_ScriptDir "\chromedriver_win32.zip")

	FileCreateDir, Folder_Chromedriver "\Backup"
	FileMoveDir, Dir_Chromedriver, Folder_Chromedriver "\Backup\", 1
	FileObj := FolderObj.ParseName("chromedriver.exe")
	AppObj.Namespace(Folder_Chromedriver "\").CopyHere(FileObj, 4|16)

	return
}

RunHide(Command) {
	dhw := A_DetectHiddenWindows
	DetectHiddenWindows, On
	Run, %ComSpec%,, Hide, cPid
	WinWait, ahk_pid %cPid%
	DetectHiddenWindows, %dhw%
	DllCall("AttachConsole", "uint", cPid)

	Shell := ComObjCreate("WScript.Shell")
	Exec := Shell.Exec(Command)
	Result := Exec.StdOut.ReadAll()

	DllCall("FreeConsole")
	Process, Close, %cPid%
	Return Result
}

