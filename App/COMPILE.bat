:: Pre-defined Params
@echo off&setlocal EnableDelayedExpansion

if /i "%lang%"=="eng" (set "appListUITXT=UIStringList_COMPILE_ENG"&mode con cols=120 lines=32)
if /i "%lang%"=="chs" (set "appListUITXT=UIStringList_COMPILE_CHS"&mode con cols=120 lines=30)

:: Redirect to Process_Compile if is compiling
if defined compiling (goto Process_Compile)
set "materialsFolder=%toolPath%1_Materials"
set "portraitsFolder=%toolPath%2_Portraits"
set "survivorsFolder=%toolPath%3_Survivors"
set "weaponsFolder=%toolPath%4_Weapons"
set "outputFolder=%toolPath%5_OUTPUT"
set "logsFolder=%toolPath%6_LOGS"
set "appFolder=%toolPath%App"

set "appListFolder=%appFolder%\ListFiles"
set "appAddoninfoFolder=%appFolder%\Addoninfo"
set "appGameFolder=%appFolder%\Game"
set "appBinFolder=%appGameFolder%\bin"
set "appBinNekoMDLFolder=%appGameFolder%\bin_nekomdl"
set "appBinExec=%appBinFolder%\studiomdl.exe"
set "appBinNekoMDLExec=%appBinNekoMDLFolder%\nekomdl.exe"
set "appPortraitsFolder=%appFolder%\Portraits"
set "appPortraitsFolderTXT=%appPortraitsFolder%\ReadME.txt"
set "appSurvivorsFolder=%appFolder%\Survivors"
set "appWeaponsFolder=%appFolder%\Weapons"
set "appConfig=%appFolder%\config.ini"
set "appConfigDef=%appFolder%\config_default.ini"
set "appConfigSaveString=empty"
set "appListUI=%appListFolder%\%appListUITXT%.txt"
set "appListSurvivorsParms=%appListFolder%\SurvivorParmList.txt"
set "appListAddoninfoTXT=%appListFolder%\AddoninfoContentList.txt"
set "appListBinGame=%appListFolder%\BinGameFileList.txt"
set "appListBinNekoMDL=%appListFolder%\BinNekoFileList.txt"
set "appListPortraitsVMT=%appListFolder%\VMTContentList.txt"
set "appListCharNameSpecialChars=%appListFolder%\CharNameSpecialCharsList.txt"
set "appCompileCommand=%appFolder%\COMPILE_COMMANDS.bat"
set "appLogErrorTXT=%logsFolder%\ERRORLOG.log"

set "outputFolderSurvivors=%appGameFolder%\left4dead2\models\survivors"
set "outputFolderWeapons=%appGameFolder%\left4dead2\models\weapons\arms"

set "failPortraits=0"
set "failAddoninfo=0"
set "failSurvivorModels=0"
set "failWeaponModels=0"

set "config=0"
set "sysTime=null"
set "currentChar=null"

:: Load UI Strings
if not defined toolPath (cd..&set "toolPath=!cd!\")
if not exist "%appListUI%" (exit)
for /f "usebackq eol=; tokens=1,2 delims==" %%a in ("%appListUI%") do (set "%%a=%%b")

:: Check consistency of directories
if not exist "%materialsFolder%" (set "failReason3=1"&goto CheckFailed)
if not exist "%portraitsFolder%" (set "failReason3=1"&goto CheckFailed)
if not exist "%survivorsFolder%" (set "failReason3=1"&goto CheckFailed)
if not exist "%weaponsFolder%" (set "failReason3=1"&goto CheckFailed)
if not exist "%outputFolder%" (set "failReason3=1"&goto CheckFailed)
if not exist "%logsFolder%" (set "failReason3=1"&goto CheckFailed)

:: Redirect to Clear or Reset mode
if defined modeClear (goto ClearMode)
if defined modeClearConfirmed (goto ClearModeStart)
if defined modeReset (goto ResetMode)

call :Func_CheckFiles

:: Get User Params
for /f "usebackq tokens=1,2,3,4,5,6,7,8,9,10 delims=," %%a in ("%appFolder%\config.ini") do (
if not defined oriAnims (set "oriAnims=%%a")
	set "enable_Nick=%%b"
	set "enable_Rochelle=%%c"
	set "enable_Coach=%%d"
	set "enable_Ellis=%%e"
	set "enable_Bill=%%f"
	set "enable_Zoey=%%g"
	set "enable_Louis=%%h"
	set "enable_Francis=%%i"
	set "enable_nekomdl=%%j"
	goto exitloop0
	)
:exitloop0
if exist "%appFolder%\*.lastrun" (
	for /f "tokens=*" %%a in ('dir /a /b "%appFolder%\*.lastrun"') do (set "charName=%%~na")
	) else (
	set "charName="
	)
if not defined charName (set "charName=%uiGInfo0%")
if not defined oriAnims (set "oriAnims=zoey")
if not defined enable_Nick (set "enable_Nick=1")
if not defined enable_Rochelle (set "enable_Rochelle=1")
if not defined enable_Coach (set "enable_Coach=1")
if not defined enable_Ellis (set "enable_Ellis=1")
if not defined enable_Bill (set "enable_Bill=1")
if not defined enable_Zoey (set "enable_Zoey=1")
if not defined enable_Louis (set "enable_Louis=1")
if not defined enable_Francis (set "enable_Francis=1")
if not defined enable_nekomdl (set "enable_nekomdl=1")

:: Generate Information
goto CharNameCheck_0
:GenerateInformation
set "enable_info_line1="
set "enable_info_line2="
set "enable_num=0"
if "%enable_Nick%" == "1" (set /a "enable_num=%enable_num%+1"&set "enable_info_line1=%enable_info_line1%Nick ")
if "%enable_Rochelle%" == "1" (set /a "enable_num=%enable_num%+1"&set "enable_info_line1=%enable_info_line1%Rochelle ")
if "%enable_Coach%" == "1" (set /a "enable_num=%enable_num%+1"&set "enable_info_line1=%enable_info_line1%Coach ")
if "%enable_Ellis%" == "1" (set /a "enable_num=%enable_num%+1"&set "enable_info_line1=%enable_info_line1%Ellis ")
if "%enable_Bill%" == "1" (set /a "enable_num=%enable_num%+1"&set "enable_info_line2=%enable_info_line2%Bill ")
if "%enable_Zoey%" == "1" (set /a "enable_num=%enable_num%+1"&set "enable_info_line2=%enable_info_line2%Zoey ")
if "%enable_Louis%" == "1" (set /a "enable_num=%enable_num%+1"&set "enable_info_line2=%enable_info_line2%Louis ")
if "%enable_Francis%" == "1" (set /a "enable_num=%enable_num%+1"&set "enable_info_line2=%enable_info_line2%Francis ")

set "oriAnims_info=null"
if /i "%oriAnims%" == "nick" (set "oriAnims_info=%uiGInfo1%")
if /i "%oriAnims%" == "rochelle" (set "oriAnims_info=%uiGInfo2%")
if /i "%oriAnims%" == "coach" (set "oriAnims_info=%uiGInfo3%")
if /i "%oriAnims%" == "ellis" (set "oriAnims_info=%uiGInfo4%")
if /i "%oriAnims%" == "bill" (set "oriAnims_info=%uiGInfo5%")
if /i "%oriAnims%" == "zoey" (set "oriAnims_info=%uiGInfo6%")
if /i "%oriAnims%" == "francis" (set "oriAnims_info=%uiGInfo7%")
if /i "%oriAnims%" == "louis" (set "oriAnims_info=%uiGInfo8%")

set "bin_info=null"
if /i "%enable_nekomdl%" == "1" (call set "bin_info=%uiGInfo9%") else (call set "bin_info=%uiGInfo10%")

if "%charName%" == "%uiGInfo0%" (goto UI_InputCharName)
if "%config%" == "1" (goto UI_Config)
if "%enable_num%" == "0" (goto UI_Config)
if "%oriAnims_info%" == "null" (goto UI_Config)

:: Save Configs to App Folder
set "appConfigSaveString=%oriAnims%,%enable_Nick%,%enable_Rochelle%,%enable_Coach%,%enable_Ellis%,%enable_Bill%,%enable_Zoey%,%enable_Louis%,%enable_Francis%,%enable_nekomdl%"
del /q "%appConfig%">nul 2>nul
(echo %appConfigSaveString%)>>"%appConfig%"
del /q "%appFolder%\*.lastrun">nul 2>nul
type nul>>"%appFolder%\%charName%.lastrun"

:UI_Welcome
cls&color 0A&call title %uiWelcomeTitle%
echo,&echo,
echo,%uiWelcome0%
echo,&echo,
call echo,%uiWelcome1%
echo,
call echo,%uiWelcome2%
echo,
call echo,%uiWelcome3%
echo, 
call echo,%uiWelcome4%
echo,&echo,
echo,%uiWelcome5%
echo,&echo,&echo,
echo,%uiWelcome6%
echo,
echo,%uiWelcome7%
echo,%uiWelcome8%
echo,&echo,&echo,
echo,%uiWelcome9%
echo,&echo,
echo,%uiWelcome10%
choice /n /c AD
if "%errorlevel%" == "1" (set "config=1"&goto UI_Config)
if "%errorlevel%" == "2" (goto Process_Start)

:UI_Config
cls&color 0B&title %uiConfigTitle%
echo,&echo,
if "%charName%" == "%uiGInfo0%" (color 0C&call echo,%uiConfig11%) else (call echo,%uiConfig12%)
echo,
if "%oriAnims_info%" == "null" (color 0C&echo,%uiConfig13%) else (call echo,%uiConfig14%)
echo,
if "%enable_num%" == "0" (color 0C&echo,%uiConfig15%) else (call echo,%uiConfig16%)
echo,
if "%enable_nekomdl%" == "1" (echo,%uiConfig17%) else (echo,%uiConfig18%)
echo,
echo,
echo,%uiConfig0%
echo,
call echo,%uiConfig1%
call echo,%uiConfig2%
echo,%uiConfig3%
echo,%uiConfig4%
echo,	
echo,%uiConfig5%
echo,%uiConfig6%
echo,%uiConfig7%
echo,%uiConfig8%
echo,
echo,%uiConfig9%
echo,%uiConfig10%
echo,
echo,
echo,%uiConfig20%
echo,
echo,%uiConfig21%
set "config=1"
choice /n /c 0123456789ASDNRCEBZLF
if "%errorlevel%" == "1" (set "enable_Nick=0"&set "enable_Rochelle=0"&set "enable_Coach=0"&set "enable_Ellis=0"&set "enable_Bill=0"&set "enable_Zoey=0"&set "enable_Louis=0"&set "enable_Francis=0")
if "%errorlevel%" == "2" (
	if "%enable_Nick%" == "1" (set "enable_Nick=0")
	if "%enable_Nick%" == "0" (set "enable_Nick=1")
	)
if "%errorlevel%" == "3" (
	if "%enable_Rochelle%" == "1" (set "enable_Rochelle=0")
	if "%enable_Rochelle%" == "0" (set "enable_Rochelle=1")
	)
if "%errorlevel%" == "4" (
	if "%enable_Coach%" == "1" (set "enable_Coach=0")
	if "%enable_Coach%" == "0" (set "enable_Coach=1")
	)
if "%errorlevel%" == "5" (
	if "%enable_Ellis%" == "1" (set "enable_Ellis=0")
	if "%enable_Ellis%" == "0" (set "enable_Ellis=1")
	)
if "%errorlevel%" == "6" (
	if "%enable_Bill%" == "1" (set "enable_Bill=0")
	if "%enable_Bill%" == "0" (set "enable_Bill=1")
	)
if "%errorlevel%" == "7" (
	if "%enable_Zoey%" == "1" (set "enable_Zoey=0")
	if "%enable_Zoey%" == "0" (set "enable_Zoey=1")
	)
if "%errorlevel%" == "8" (
	if "%enable_Louis%" == "1" (set "enable_Louis=0")
	if "%enable_Louis%" == "0" (set "enable_Louis=1")
	)
if "%errorlevel%" == "9" (
	if "%enable_Francis%" == "1" (set "enable_Francis=0")
	if "%enable_Francis%" == "0" (set "enable_Francis=1")
	)
if "%errorlevel%" == "10" (set "enable_Nick=1"&set "enable_Rochelle=1"&set "enable_Coach=1"&set "enable_Ellis=1"&set "enable_Bill=1"&set "enable_Zoey=1"&set "enable_Louis=1"&set "enable_Francis=1")
if "%errorlevel%" == "11" (set "config=0")
if "%errorlevel%" == "12" (goto UI_InputCharName)
if "%errorlevel%" == "13" (
	if "%enable_nekomdl%" == "1" (set "enable_nekomdl=0")
	if "%enable_nekomdl%" == "0" (set "enable_nekomdl=1")
	)
if "%errorlevel%" == "14" (set "oriAnims=nick")
if "%errorlevel%" == "15" (set "oriAnims=rochelle")
if "%errorlevel%" == "16" (set "oriAnims=coach")
if "%errorlevel%" == "17" (set "oriAnims=ellis")
if "%errorlevel%" == "18" (set "oriAnims=bill")
if "%errorlevel%" == "19" (set "oriAnims=zoey")
if "%errorlevel%" == "20" (set "oriAnims=louis")
if "%errorlevel%" == "21" (set "oriAnims=francis")
goto GenerateInformation

:UI_InputCharName
cls&color 0B
echo,&echo,
echo,%uiConfig22%
echo,&echo,
if "%charName%" == "%uiGInfo0%" ((set /p charName=%uiConfig24%)) else ((set /p charName=%uiConfig23%))
goto CharNameCheck_0

:CharNameCheck_0
:: Remove special chars
for /f "usebackq delims=" %%a in ("%appListCharNameSpecialChars%") do (
	set charName=!charName:%%a=!
	if not defined charName (set charName=%uiGInfo0%&goto UI_InputCharName)
	)
:: Remove equals
for /f "tokens=1,2 delims== " %%b in ('echo,%charName%') do (
	if /i "%%b" == "echo" (set charName=%uiGInfo0%&goto UI_InputCharName) 
	set charName=%%b%%c
	)
set "charName_1="
set "charName_2="
:CharNameCheck_1
:: Remove additional special chars
if 1==%charName%1%charName% (goto CharNameCheck_2)
set charName_1=%charName:~0,1%
if **==%charName_1%%charName_1% (set charName_1=)
if ""==%charName_1%%charName_1% (set charName_1=)
set charName=%charName:~1%
set charName_2=%charName_2%%charName_1%
goto CharNameCheck_1
:CharNameCheck_2
set charName=%charName_2%
:: If failed, fallback to default charName
if not defined charName (set "charName=%uiGInfo0%")
:: Redirect
goto GenerateInformation

:Func_CheckFiles
:: Check (1/2)
set "check_userfiles_valid=1"
set "check_appfiles_valid=1"
:: User: Portraits
if not exist "%portraitsFolder%\i.vtf" (set "failReason4=1"&set "check_userfiles_valid=0")
if not exist "%portraitsFolder%\l.vtf" (set "failReason4=1"&set "check_userfiles_valid=0")
if not exist "%portraitsFolder%\s.vtf" (set "failReason4=1"&set "check_userfiles_valid=0")
:: User: Survivors
if not exist "%survivorsFolder%\1_main.qci" (set "failReason8=1"&set "check_userfiles_valid=0")
dir "%survivorsFolder%\*.smd" /b /s>nul 2>nul
if "%errorlevel%" == "1" (set "failReason8=1"&set "check_userfiles_valid=0")
:: User: Weapons
if not exist "%weaponsFolder%\1_main.qci" (set "failReason9=1"&set "check_userfiles_valid=0")
dir "%weaponsFolder%\*.smd" /b /s>nul 2>nul
if "%errorlevel%" == "1" (set "failReason9=1"&set "check_userfiles_valid=0")
:: App: ListFiles
if not exist "%appListBinGame%" (set "check_appfiles_valid=0")
if not exist "%appListBinNekoMDL%" (set "check_appfiles_valid=0")
if not exist "%appListPortraitsVMT%" (set "check_appfiles_valid=0")
if not exist "%appListAddoninfoTXT%" (set "check_appfiles_valid=0")
if not exist "%appListSurvivorsParms%" (set "check_appfiles_valid=0")
if not exist "%appListCharNameSpecialChars%" (set "check_appfiles_valid=0")
:: App: Default Studiomdl
for /f "usebackq eol=; delims=" %%i in ("%appListBinGame%") do (if not exist "%appBinFolder%\%%i" (set "check_appfiles_valid=0"))
:: App: NekoMDL
for /f "usebackq eol=; delims=" %%i in ("%appListBinNekoMDL%") do (if not exist "%appBinNekoMDLFolder%\%%i" (set "check_appfiles_valid=0"))
:: App: Gameinfo.txt
if not exist "%appGameFolder%\left4dead2\gameinfo.txt" (set "check_appfiles_valid=0")
:: Redirect
if "%check_userfiles_valid%" == "0" (goto CheckFailed)
if "%check_appfiles_valid%" == "0" (set "failReason3=1"&goto CheckFailed)
goto :EOF

:Process_Start
:: Delete temp files before start processing
call :Func_ClearCompileTempFiles
del /q "%logsFolder%\*.log">nul 2>nul
del /q "%outputFolderSurvivors%\*.mdl">nul 2>nul
del /q "%outputFolderSurvivors%\*.vtx">nul 2>nul
del /q "%outputFolderSurvivors%\*.vvd">nul 2>nul
del /q "%outputFolderWeapons%\*.mdl">nul 2>nul
del /q "%outputFolderWeapons%\*.vtx">nul 2>nul
del /q "%outputFolderWeapons%\*.vvd">nul 2>nul
:: Generate Systime
for /l %%i in (0,1,9) do (if "%time:~0,2%" == "%%i" (set "sysTimeHour=0%%i") else (set "sysTimeHour=%time:~0,2%"))
set "sysTime=%date%_%sysTimeHour%%time:~3,2%%time:~6,2%"
set "sysTime=%sysTime: =%"
set "sysTime=%sysTime:/=%"
set "sysTime=%sysTime:\=%"
set "sysTime=%sysTime:-=%"
:Process_Retry
:: Reset Params if Retrying
if defined retry (
	set "failPortraits=0"
	set "failAddoninfo=0"
	set "failSurvivorModels=0"
	set "failWeaponModels=0"
	set "retry="
	set "warning="
	set "failReason0="
	set "failReason1="
	set "failReason2="
	set "failReason3="
	set "failReason4="
	set "failReason5="
	set "failReason6="
	set "failReason7="
	set "failReason8="
	set "failReason9="
	)
:: Reset Logs
del /s "%logsFolder%\*_%sysTime%.log">nul 2>nul

:: Check (2/2)
call :Func_CheckFiles
:: Check User Params
if not defined charName (set "check_charName_valid=0") else (set "check_charName_valid=1")
if not defined oriAnims (set "oriAnims=%uiConfig25%")
if not defined enable_Nick (set "enable_Nick=0")
if not defined enable_Rochelle (set "enable_Rochelle=0")
if not defined enable_Coach (set "enable_Coach=0")
if not defined enable_Ellis (set "enable_Ellis=0")
if not defined enable_Bill (set "enable_Bill=0")
if not defined enable_Zoey (set "enable_Zoey=0")
if not defined enable_Louis (set "enable_Louis=0")
if not defined enable_Francis (set "enable_Francis=0")

set "check_enable_valid=0"
if "%enable_Nick%" == "1" (set "check_enable_valid=1")
if "%enable_Rochelle%" == "1" (set "check_enable_valid=1")
if "%enable_Coach%" == "1" (set "check_enable_valid=1")
if "%enable_Ellis%" == "1" (set "check_enable_valid=1")
if "%enable_Bill%" == "1" (set "check_enable_valid=1")
if "%enable_Zoey%" == "1" (set "check_enable_valid=1")
if "%enable_Louis%" == "1" (set "check_enable_valid=1")
if "%enable_Francis%" == "1" (set "check_enable_valid=1")

set "check_oriAnims_valid=0"
if /i "%oriAnims%" == "nick" (set "check_oriAnims_valid=1")
if /i "%oriAnims%" == "rochelle" (set "check_oriAnims_valid=1")
if /i "%oriAnims%" == "coach" (set "check_oriAnims_valid=1")
if /i "%oriAnims%" == "ellis" (set "check_oriAnims_valid=1")
if /i "%oriAnims%" == "bill" (set "check_oriAnims_valid=1")
if /i "%oriAnims%" == "zoey" (set "check_oriAnims_valid=1")
if /i "%oriAnims%" == "francis" (set "check_oriAnims_valid=1")
if /i "%oriAnims%" == "louis" (set "check_oriAnims_valid=1")

if "%check_charName_valid%" == "0" (set "failReason0=1"&goto CheckFailed)
if "%check_oriAnims_valid%" == "0" (set "failReason1=1"&goto CheckFailed)
if "%check_enable_valid%" == "0" (set "failReason2=1"&goto CheckFailed)
if "%check_appfiles_valid%" == "0" (set "failReason3=1"&goto CheckFailed)

goto Process_LaunchThreads

:Process_LaunchThreads
if not defined charSeq (set "charSeq=1")
for /f "usebackq skip=%charSeq% eol=; tokens=1,2,3,4,5,6,7 delims=," %%a in ("%appListSurvivorsParms%") do (
	set /a "charSeq=charSeq+1"
	set "currentChar=%%a"
	set "light=%%b"
	set "p1=%%c"
	set "p2=%%d"
	set "p3=%%e"
	set "m1=%%f"
	set "m2=%%g"
	call set "enabled=enable_!currentChar!"
	call set "enabled=%%!enabled!%%"
	
	if "!enabled!" == "0" (goto Process_LaunchThreads)
	if /i "!currentChar!" == "end" (set "charSeq=1"&goto Process_Wait)
	
	set "compiling=1"
	start /min "" "%appFolder%\COMPILE.BAT"
	)>nul 2>nul

:Process_Wait
cls&title %uiCompileTitle0%
echo,&echo,&echo,%uiCompile1%
echo,&echo,
timeout /t 2 /nobreak>nul
:Process_Wait_Loop
timeout /t 1 /nobreak>nul
set threadCount=0
for /f "tokens=*" %%a in ('tasklist ^| findstr /i "nekomdl.exe studiomdl.exe"') do (
	set /a "threadCount=threadCount+1"
	)
if "%threadCount%" == "0" (goto Process_WaitFinished)
call title %uiCompileTitle1%
goto Process_Wait_Loop

:Process_WaitFinished
:: Remove Logs of Success, and export WARNS to anothor log file
del /q "%appLogErrorTXT%">nul 2>nul
type nul>>"%appLogErrorTXT%"
for %%a in ("%logsFolder%\*.log") do (
	findstr /i "warning unknown error" "%%a"
	if "!errorlevel!" == "1" (
	del /q "%%a"
	) else (
	set warning=1
	for /f "delims=" %%b in ('findstr /i "warning unknown error" "%%a"') do (findstr /i "%%b" "%appLogErrorTXT%" || echo %%b>>"%appLogErrorTXT%")
	)
	)>nul 2>nul
:: Verify Output Files
for /f "usebackq skip=%charSeq% eol=; tokens=1,2,3,4,5,6,7 delims=," %%a in ("%appListSurvivorsParms%") do (
	set /a "charSeq=charSeq+1"
	set "currentChar=%%a"
	set "light=%%b"
	set "p1=%%c"
	set "p2=%%d"
	set "p3=%%e"
	set "m1=%%f"
	set "m2=%%g"
	call set "enabled=enable_!currentChar!"
	call set "enabled=%%!enabled!%%"
	:: Redirect {
	if "!enabled!" == "0" (goto Process_WaitFinished)
	if /i "!currentChar!" == "end" (set "charSeq=1"&goto Process_Finished)
	:: Redirect }
	:: Redefined directory param
	set "targetFolder=%outputFolder%\%sysTime%_%charName%_!currentChar!"
	set "targetFolderAddoninfo=!targetFolder!\addoninfo.txt"
	set "targetFolderSurvivors=!targetFolder!\models\survivors"
	set "targetFolderWeapons=!targetFolder!\models\weapons\arms"
	:: Addoninfo
	if not exist "!targetFolderAddoninfo!" (set "failAddoninfo=1")
	:: Portraits
	if not exist "!targetFolder!\materials\vgui\!charName!_!currentChar!.vtf" (set "failPortraits=1")
	if not exist "!targetFolder!\materials\vgui\!charName!_!currentChar!_Incap.vtf" (set "failPortraits=1")
	if not exist "!targetFolder!\materials\vgui\!charName!_!currentChar!_Lobby.vtf" (set "failPortraits=1")
	if not exist "!targetFolder!\materials\vgui\!p1!.vmt" (set "failPortraits=1")
	if not exist "!targetFolder!\materials\vgui\!p2!.vmt" (set "failPortraits=1")
	if not exist "!targetFolder!\materials\vgui\!p3!.vmt" (set "failPortraits=1")
	:: Survivor Model
	if not exist "!targetFolderSurvivors!\!m1!.mdl" (set "failSurvivorModels=1")
	if not exist "!targetFolderSurvivors!\!m1!.dx90.vtx" (set "failSurvivorModels=1")
	if not exist "!targetFolderSurvivors!\!m1!.vvd" (set "failSurvivorModels=1")
	if "!light!" == "1" (
		if not exist "!targetFolderSurvivors!\!m1!_light.ani" (set "failSurvivorModels=1")
		if not exist "!targetFolderSurvivors!\!m1!_light.mdl" (set "failSurvivorModels=1")
		if not exist "!targetFolderSurvivors!\!m1!_light.dx90.vtx" (set "failSurvivorModels=1")
		if not exist "!targetFolderSurvivors!\!m1!_light.vvd" (set "failSurvivorModels=1")
	)
	:: Weapon Model
	if not exist "!targetFolderWeapons!\!m2!.mdl" (set "failWeaponModels=1")
	if not exist "!targetFolderWeapons!\!m2!.dx90.vtx" (set "failWeaponModels=1")
	if not exist "!targetFolderWeapons!\!m2!.vvd" (set "failWeaponModels=1")
	:: Set parms if failed
	if "!failAddoninfo!" == "1" (set "failReason5=1")
	if "!failPortraits!" == "1" ("set failReason4=1")
	if "!failSurvivorModels!" == "1" (set "failReason6=1")
	if "!failWeaponModels!" == "1" (set "failReason7=1")
	:: Redirect if failed
	if "!failAddoninfo!" == "1" (goto CheckFailed)
	if "!failPortraits!" == "1" (goto CheckFailed)
	if "!failSurvivorModels!" == "1" (goto CheckFailed)
	if "!failWeaponModels!" == "1" (goto CheckFailed)
	)>nul 2>nul

:Process_Finished
call :Func_ClearCompileTempFiles

:UI_End
cls&color 0A&title %uiEndTitle%
echo,&echo,
if defined warning (
	echo,%uiEnd3%
	) else (
	echo,%uiEnd0%
	del /q "%appLogErrorTXT%">nul 2>nul
	)
echo,
echo,%uiEnd1%
if defined warning (
	echo,
	echo,%uiEnd4%
	echo,&echo,
	echo,%uiEnd5%
	echo,
	echo,%uiEnd6%
	echo,&echo,&echo,
	) else (
	echo,&echo,&echo,
	echo,%uiEnd2%&pause>nul&exit
	)

set "userInput=null"
set /p "userInput=%uiEnd7%"
if "%userInput%" == "1" (start "" "%appLogErrorTXT%")
exit

:CheckFailed
:: Clear Failed Outputs {
set "charSeq=1"
:CheckFailedLoop
for /f "usebackq skip=%charSeq% eol=; tokens=1,2,3,4,5,6,7 delims=," %%a in ("%appListSurvivorsParms%") do (
	set /a "charSeq=charSeq+1"
	set "currentChar=%%a"
	call set "enabled=enable_!currentChar!"
	call set "enabled=%%!enabled!%%"
	:: Redirect {
	if "!enabled!" == "0" (goto CheckFailedLoop)
	if /i "!currentChar!" == "end" (set "charSeq=1")
	:: Redirect }
	rd /s /q "%outputFolder%\%sysTime%_%charName%_!currentChar!">nul 2>nul
	)>nul 2>nul
:: Clear Failed Outputs }
call :Func_ClearCompileTempFiles
:: Redirect
goto UI_Fail

:UI_Fail
title %uiFailedTitle%&cls&color 0C
echo,&echo,
set "allowRetry=0"
if defined failReason0 (echo,%uiFailedReason0%&echo,)
if defined failReason1 (echo,%uiFailedReason1%&echo,)
if defined failReason2 (echo,%uiFailedReason2%&echo,)
if defined failReason3 (echo,%uiFailedReason3%&echo,)
if defined failReason4 (
	echo,%uiFailedReason4%&echo,&echo,%uiFailedReason4_1%&echo,
	if defined compiling (set "allowRetry=1")
	)
if defined failReason5 (
	echo,%uiFailedReason5%&echo,&echo,%uiFailedReason5_1%&echo,
	if defined compiling (set "allowRetry=1")
	)
if defined failReason6 (
	echo,%uiFailedReason6%&echo,&echo,%uiFailedReason6_1%&echo,%uiFailedReason6_2%&echo,
	if defined compiling (set "allowRetry=1")
	)
if defined failReason7 (
	echo,%uiFailedReason7%&echo,&echo,%uiFailedReason7_1%&echo,%uiFailedReason7_2%&echo,
	if defined compiling (set "allowRetry=1")
	)
if defined failReason8 (echo,%uiFailedReason8%&echo,)
if defined failReason9 (echo,%uiFailedReason9%&echo,)
echo,&echo,

if "%allowRetry%" == "1" (
	echo,%uiFailed0%
	echo,&echo,&echo,
	) else (
	echo,%uiFailed1%&pause>nul & exit
	)

pause>nul
set "retry=1"
cls&color 0A
goto Process_Retry

:Func_ClearCompileTempFiles
rd /s /q "%survivorsFolder%\ANIMS\">nul 2>nul
rd /s /q "%weaponsFolder%\ANIMS\">nul 2>nul
del /q "%survivorsFolder%\*.qc">nul 2>nul
del /q "%weaponsFolder%\*.qc">nul 2>nul
goto :EOF

:ClearMode
cls&color 0C&title %uiClearTitle%
echo,&echo,
echo,%uiClear0%
echo,&echo,&echo,&echo,
timeout /t 1 /nobreak>nul
echo,%uiClear1%&pause>nul
echo,&echo,%uiClear2%&pause>nul
:ClearModeStart
rd /s /q "%materialsFolder%"&mkdir "%materialsFolder%">nul 2>nul
del /q "%portraitsFolder%\*.vtf">nul 2>nul
del /q "%survivorsFolder%\*.smd">nul 2>nul
del /q "%survivorsFolder%\*.vta">nul 2>nul
del /q "%survivorsFolder%\*.vrd">nul 2>nul
del /q "%survivorsFolder%\*_animation.qci">nul 2>nul
del /q "%survivorsFolder%\*_bone.qci">nul 2>nul
del /q "%survivorsFolder%\*_box.qci">nul 2>nul
del /q "%survivorsFolder%\*_collision.qci">nul 2>nul
del /q "%survivorsFolder%\*.qc">nul 2>nul
del /q "%survivorsFolder%\*_flex.qci">nul 2>nul
del /q "%survivorsFolder%\*_lod.qci">nul 2>nul
del /q "%weaponsFolder%\*.smd">nul 2>nul
del /q "%weaponsFolder%\*.vrd">nul 2>nul
del /q "%weaponsFolder%\*_animation.qci">nul 2>nul
del /q "%weaponsFolder%\*_bone.qci">nul 2>nul
del /q "%weaponsFolder%\*_box.qci">nul 2>nul
del /q "%weaponsFolder%\*_collision.qci">nul 2>nul
del /q "%weaponsFolder%\*.qc">nul 2>nul
del /q "%weaponsFolder%\*_flex.qci">nul 2>nul
del /q "%weaponsFolder%\*_lod.qci">nul 2>nul
del /q "%logsFolder%\*.log">nul 2>nul
if defined modeClearConfirmed (goto AutoPlacingToolStart>nul 2>nul) else (exit)

:ResetMode
cls&color 0C&title %uiResetTitle%
echo,&echo,
echo,%uiReset0%
echo,&echo,&echo,&echo,
timeout /t 1 /nobreak>nul
echo,%uiReset1%&pause>nul
echo,&echo,%uiReset2%&pause>nul
rd /s /q "%materialsFolder%"&mkdir "%materialsFolder%">nul 2>nul
rd /s /q "%portraitsFolder%"&mkdir "%portraitsFolder%">nul 2>nul
rd /s /q "%survivorsFolder%"&mkdir "%survivorsFolder%">nul 2>nul
rd /s /q "%weaponsFolder%"&mkdir "%weaponsFolder%">nul 2>nul
rd /s /q "%outputFolder%"&mkdir "%outputFolder%">nul 2>nul
rd /s /q "%logsFolder%"&mkdir "%logsFolder%">nul 2>nul
del /q "%appFolder%\*.lastrun">nul 2>nul
copy /y "%appPortraitsFolderTXT%" "%portraitsFolder%\">nul 2>nul
copy /y "%appConfigDef%" "%appFolder%\config.ini">nul 2>nul
type nul>>"%survivorsFolder%\1_main.qci"
type nul>>"%weaponsFolder%\1_main.qci"
exit

:Process_Compile
set "targetFolder=%outputFolder%\%sysTime%_%charName%_%currentChar%"
cls&echo,&echo,&call echo,%uiCompile0%&echo,&echo,
:: (1/7) Clear Existed Logs
del /q "%logsFolder%\%sysTime%_%currentChar%_Survivor.log">nul 2>nul
del /q "%logsFolder%\%sysTime%_%currentChar%_Survivor_Light.log">nul 2>nul
del /q "%logsFolder%\%sysTime%_%currentChar%_Weapon.log">nul 2>nul
:: (2/7) Copy Materials
xcopy "%materialsFolder%\*.*" "%targetFolder%\materials\" /e /y>nul 2>nul
:: (3/7) Move Addonimage.jpg
move /y "%targetFolder%\materials\addonimage.jpg" "%targetFolder%\">nul 2>nul
:: (4/7) Create Portraits
mkdir "%targetFolder%\materials\vgui\">nul 2>nul
:: (4.1/7) Copy VTF
copy /y "%portraitsFolder%\s.vtf" "%targetFolder%\materials\vgui\%charName%_%currentChar%.vtf">nul 2>nul
copy /y "%portraitsFolder%\i.vtf" "%targetFolder%\materials\vgui\%charName%_%currentChar%_Incap.vtf">nul 2>nul
copy /y "%portraitsFolder%\l.vtf" "%targetFolder%\materials\vgui\%charName%_%currentChar%_Lobby.vtf">nul 2>nul
:: (4.2/7) Create VMT
set "ptab=	"
for /L %%a in (1,1,3) do (
	set "vmtSeq="
	set "vmtSeq=%%a"
	call set "vmtFileName=%%p!vmtSeq!%%"
	set "loopSeq=0"
	set "vmtTempString="
	:: (1/3) Panel
	if "!vmtSeq!" == "1" (
		for /f "usebackq eol=; delims=" %%i in ("%appListPortraitsVMT%") do (set "vmtTempString=%ptab%"$basetexture"%ptab%"VGUI\%charName%_%currentChar%"")
		)
	:: (2/3) Incap
	if "!vmtSeq!" == "2" (
		for /f "usebackq eol=; delims=" %%i in ("%appListPortraitsVMT%") do (set "vmtTempString=%ptab%"$basetexture"%ptab%"VGUI\%charName%_%currentChar%_Incap"")
		)
	:: (3/3) Lobby
	if "!vmtSeq!" == "3" (
		for /f "usebackq eol=; delims=" %%i in ("%appListPortraitsVMT%") do (set "vmtTempString=%ptab%"$basetexture"%ptab%"VGUI\%charName%_%currentChar%_Lobby"")
		)
	for /f "usebackq eol=; delims=" %%i in ("%appListPortraitsVMT%") do (
		set /a "loopSeq=loopSeq+1"
		if "!loopSeq!" == "3" (echo !vmtTempString!>>"%targetFolder%\materials\vgui\!vmtFileName!.vmt")
		echo %%i>>"%targetFolder%\materials\vgui\!vmtFileName!.vmt"
		)
	)
:: (5/7) Create Addoninfo Using UTF-8
chcp 65001>nul 2>nul
set "targetFolderAddoninfo=%targetFolder%\addoninfo.txt"
copy /y "%appFolder%\Addoninfo\addoninfo.txt" "%targetFolderAddoninfo%">nul 2>nul
set "loopSeq=0"
for /f "usebackq eol=; delims=" %%i in ("%appListAddoninfoTXT%") do (
	set /a "loopSeq=loopSeq+1"
	if "!loopSeq!" == "3" (echo %ptab%"addontitle"%ptab%"[%currentChar%] %charName%">>"%targetFolderAddoninfo%")
	echo %%i>>"%targetFolderAddoninfo%"
	)
cls&echo,&echo,&call echo,%uiCompile0%
:: (6/7) Compile Models
if "%enable_nekomdl%" == "1" (set "studiomdlExec=%appBinNekoMDLExec%") else (set "studiomdlExec=%appBinExec%")
set "studiomdlOpt=-game "%appGameFolder%\left4dead2" -nop4 -verbose"
set "targetFolderSurvivors=%targetFolder%\models\survivors"
set "targetFolderWeapons=%targetFolder%\models\weapons\arms"
:: (6.1/7) Weapon Model
xcopy "%appWeaponsFolder%\ANIMS\*.*" "%weaponsFolder%\ANIMS\" /e /y>nul 2>nul
copy /y "%appWeaponsFolder%\%currentChar%.qc" "%weaponsFolder%\">nul 2>nul
set "curCommand=weapon"&start /min "" "%appCompileCommand%"
:: (6.2/7) Survivor Model
xcopy "%appSurvivorsFolder%\ANIMS\*.*" "%survivorsFolder%\ANIMS\" /e /y>nul 2>nul
:: Check Proportions {
set "proportionsExists=0"
if exist "%survivorsFolder%\a_proportions.smd" (set "proportionsExists=1")
if exist "%survivorsFolder%\a_proportions_corrective_animation.smd" (set "proportionsExists=1")
:: Case0: Proportions Not Exists
if "%proportionsExists%" == "0" (
	copy /y "%appSurvivorsFolder%\%oriAnims%2%currentChar%_NoProportions.qc" "%survivorsFolder%\">nul 2>nul
	set "curCommand=survivor_nop"&start /min "" "%appCompileCommand%"
	if "%light%" == "1" (
		copy /y "%appSurvivorsFolder%\%oriAnims%2%currentChar%_light_NoProportions.qc" "%survivorsFolder%\">nul 2>nul
		set "curCommand=survivor_nop_light"&start /min "" "%appCompileCommand%"
		)
	)
:: Case1: Proportions Exists
if "%proportionsExists%" == "1" (
	copy /y "%appSurvivorsFolder%\%oriAnims%2%currentChar%.qc" "%survivorsFolder%\">nul 2>nul
	set "curCommand=survivor"&start /min "" "%appCompileCommand%"
	if "%light%" == "1" (
		copy /y "%appSurvivorsFolder%\%oriAnims%2%currentChar%_light.qc" "%survivorsFolder%\">nul 2>nul
		set "curCommand=survivor_light"&start /min "" "%appCompileCommand%"
		)
	)
:: Check Proportions }
:: Sub-processes exit
exit