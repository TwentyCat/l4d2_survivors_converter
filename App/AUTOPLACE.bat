:: Pre-defined Params
@echo off&setlocal EnableDelayedExpansion

if /i "%lang%"=="eng" (set "appListUITXT=UIStringList_AUTOPLACE_ENG"&mode con cols=120 lines=32)
if /i "%lang%"=="chs" (set "appListUITXT=UIStringList_AUTOPLACE_CHS"&mode con cols=120 lines=30)

set "materialsFolder=%toolPath%\1_Materials"
set "portraitsFolder=%toolPath%\2_Portraits"
set "survivorsFolder=%toolPath%\3_Survivors"
set "weaponsFolder=%toolPath%\4_Weapons"
set "appFolder=%toolPath%App"

set "appListFolder=%appFolder%\ListFiles"
set "appVPKConverterFolder=%appFolder%\VPKConverter"
set "appVPKConverterExec=%appVPKConverterFolder%\vpk.exe"
set "appCrowbarDecompilerFolder=%appFolder%\CrowbarDecompiler"
set "appCrowbarDecompilerExec=%appCrowbarDecompilerFolder%\CrowbarDecompiler.exe"

set "appListUI=%appListFolder%\%appListUITXT%.txt"
set "appListPortraits=%appListFolder%\PortraitFileNameList.txt"
set "appListSurvivors=%appListFolder%\SurvivorFileNameList.txt"
set "appListSurvivorsAnims=%appListFolder%\SurvivorAnimList.txt"
set "appListWeapons=%appListFolder%\WeaponFileNameList.txt"

:: Load UI Strings
if not defined toolPath (cd..&set "toolPath=!cd!\")
if not exist "%appListUI%" (exit)
for /f "usebackq eol=; tokens=1,2 delims==" %%a in ("%appListUI%") do (set "%%a=%%b")

:: Self Check
if not defined file (set "failReason0=1"&goto CheckFailScreen)
if not exist %file% (set "failReason0=1"&goto CheckFailScreen)
if not "%fileExt%" == ".vpk" (set "failReason1=1"&goto CheckFailScreen)
if not exist "%appVPKConverterExec%" (set "failReason2=1"&goto CheckFailScreen)
if not exist "%appCrowbarDecompilerExec%" (set "failReason2=1"&goto CheckFailScreen)
if not exist "%appListPortraits%" (set "failReason2=1"&goto CheckFailScreen)
if not exist "%appListSurvivors%" (set "failReason2=1"&goto CheckFailScreen)
if not exist "%appListSurvivorsAnims%" (set "failReason2=1"&goto CheckFailScreen)
if not exist "%appListWeapons%" (set "failReason2=1"&goto CheckFailScreen)
:: Check if VPK is occupied by other process 1st time
rename %file% "%fileNameWithExt%">nul 2>nul
if "%errorlevel%" == "1" (set "failReason3=1"&goto CheckFailScreen)

:Screen_Welcome
cls & color 0A &call title %uiWelcomeTitle%
echo,&echo,
echo,%uiWelcome0%
echo,&echo,
echo,%uiWelcome1%
echo,%uiWelcome2%
echo,%uiWelcome3%
echo,&echo,&echo,&echo,&echo,
timeout /t 1 /nobreak>nul
echo,%uiWelcome4%&pause>nul
echo,&echo,%uiWelcome5%&pause>nul

set "modeClearConfirmed=1"
call "%appFolder%\COMPILE.bat"

:AutoPlacingToolStart
cls&echo,&echo,&echo,%uiPlacingTool0%&echo,&echo,

:: Generate Systime
for /l %%i in (0,1,9) do (if "%time:~0,2%" == "%%i" (set "sysTimeHour=0%%i") else (set "sysTimeHour=%time:~0,2%"))
set "sysTime=%date%_%sysTimeHour%%time:~3,2%%time:~6,2%"
set "sysTime=%sysTime: =%"
set "sysTime=%sysTime:/=%"
set "sysTime=%sysTime:\=%"
set "sysTime=%sysTime:-=%"
:: Unpack VPK
set "lastChar=null"
set "lastCharDigit=0"
set "lastCharIsSpace=0"

pushd "%vpkPath%\"

:VPKConverter_PREVENT_SPACE
set /a "lastCharDigit=lastCharDigit-1"
set "lastChar=!vpkName:~%lastCharDigit%,1!"
if "%lastChar%" == " " (goto VPKConverter_PREVENT_SPACE) else (goto VPKConverter_PROCESS_GET_NEW_FILENAME)

:VPKConverter_PROCESS_GET_NEW_FILENAME
set /a "lastCharDigit=lastCharDigit+1"
if "%lastCharDigit%" == "0" (set "vpkName1=%vpkName%"&goto VPKConverter_PROCESS_EXTRACT) else (set "vpkName1=!vpkName:~0,%lastCharDigit%!")
if exist "%vpkName1%.vpk" (goto VPKConverter_PROCESS_RENAME) else (goto VPKConverter_PROCESS_EXTRACT)

:VPKConverter_PROCESS_RENAME
cls&title %vpkName1%
for /f "tokens=2" %%b in ('tasklist /FI "WindowTitle eq %vpkName1%" /FO LIST ^| findstr /B "PID:"') do (set "vpkName1Ext=%%b")
set "vpkName1=%vpkName1%_%vpkName1Ext%"

:VPKConverter_PROCESS_EXTRACT
:: Check if VPK is occupied by other process 2nd times
rename "%vpkName%.vpk" "%vpkName1%.vpk"
if "%errorlevel%" == "1" (set "failReason3=1"&goto ClearTempFiles)
set "targetPath=%~d1%~p1%vpkName1%"
set "targetPath_Exist=%~d1%~p1%vpkName1%_%sysTime%"

:: Set another name for vpkName1, if a folder named as vpkName1 exists
if exist "%targetPath%" (
	copy /y "%vpkName1%.vpk" "%vpkName1%_%sysTime%.vpk"
	set "vpkName1=%vpkName1%_%sysTime%"
	)>nul 2>nul
set "targetPath=%~d1%~p1%vpkName1%"

"%appVPKConverterExec%" "%vpkName1%.vpk">nul
if not exist "%targetPath%" (goto VPKConverter_PROCESS_EXTRACT_ALTERNATE)
rename "%targetPath%" "%vpkName1%"
goto VPKConverterEND

:VPKConverter_PROCESS_EXTRACT_ALTERNATE
title %vpkName1%
for /f "tokens=2" %%b in ('tasklist /FI "WindowTitle eq %vpkName1%" /FO LIST ^| findstr /B "PID:"') do (set "vpkName1Ext=%%b")
copy /y "%vpkPath%\%vpkName1%.vpk" "%vpkPath%\20catprocessing_%vpkName1Ext%.vpk">nul 2>nul
"%appVPKConverterExec%" "20catprocessing_%vpkName1Ext%.vpk">nul
rename "%vpkPath%\20catprocessing_%vpkName1Ext%" "%vpkName1%">nul 2>nul
del /s /q "%vpkPath%\20catprocessing_%vpkName1Ext%.vpk">nul 2>nul
goto VPKConverterEND

:VPKConverterEND
set "vpkExtractPath=%~d1%~p1%vpkName1%"

set "vpkMaterialsExist=1"
set "vpkPortraitsExist=1"
set "vpkSurvivorsExist=1"
set "vpkMDLValid=1"
set "vpkWeaponsExist=1"

:: Get Portraits
for /f "usebackq tokens=1,2 delims=," %%a in ("%appListPortraits%") do (
	set "vtfFileType=%%b"
	set "file=%%a"
	set "vmtFile=%vpkExtractPath%\!file!.vmt"
	set "vtfFile=%vpkExtractPath%\!file!.vtf"
	set "vmtFileOriginalName=!vmtFile:%vpkExtractPath%\materials\vgui\=!"
	:: Use $basetexture path firstly, fallback using default path
	for /f "tokens=2" %%i in ('findstr /i "$basetexture" "!vmtFile!"') do (
		set "vtfFile=%%i"
		set "vtfFile=!vtfFile:"=!"
		set "vtfFile=!vtfFile:/=\!"
		set "vtfFile=!vtfFile:.vtf=!"
		set "vtfFile=%vpkExtractPath%\materials\!vtfFile!.vtf"
	)>nul 2>nul
	copy /y "!vtfFile!" "%portraitsFolder%\!vtfFileType!.vtf"
	)>nul 2>nul

:: Replace L with S, if L not exist
if not exist "%portraitsFolder%\l.vtf" (copy /y "%portraitsFolder%\s.vtf" "%portraitsFolder%\l.vtf")>nul 2>nul
:: Replace S with L, if S not exist
if not exist "%portraitsFolder%\s.vtf" (copy /y "%portraitsFolder%\l.vtf" "%portraitsFolder%\s.vtf")>nul 2>nul

if not exist "%portraitsFolder%\i.vtf" (set "vpkPortraitsExist=0")
if not exist "%portraitsFolder%\l.vtf" (set "vpkPortraitsExist=0")
if not exist "%portraitsFolder%\s.vtf" (set "vpkPortraitsExist=0")

:: Get Materials
rd /s /q "%vpkExtractPath%\materials\vgui">nul 2>nul
xcopy "%vpkExtractPath%\materials\*.*" "%materialsFolder%\" /e /y>nul 2>nul
:: Get Addonimage.jpg
copy /y "%vpkExtractPath%\addonimage.jpg" "%materialsFolder%\">nul 2>nul

:: Get Models
:: Clear Previous Config
rd /s /q "%APPDATA%\ZeqMacaw\CrowbarDecompiler 0.71">nul 2>nul
:: Clear 1_main.qci
del /s "%survivorsFolder%\1_main.qci">nul 2>nul
del /s "%weaponsFolder%\1_main.qci">nul 2>nul
type nul>>"%survivorsFolder%\1_main.qci"
type nul>>"%weaponsFolder%\1_main.qci"

:: Survivors
for /f "usebackq tokens=*" %%a in ("%appListSurvivors%") do (
	set "mdlFile=%%a"
	set "mdlFileNameSurvivor=!mdlFile:models\survivors\=!"
	set "mdlFileNameSurvivor=!mdlFileNameSurvivor:.mdl=!"
	set "mdlFileSurvivor=%vpkExtractPath%\!mdlFile!"
    if exist "!mdlFileSurvivor!" (goto GetSurvivorsMDLFinished)
	)
:GetSurvivorsMDLFinished
if not defined mdlFileSurvivor (set "mdlFileSurvivor=null")
if not defined mdlFileNameSurvivor (set "mdlFileNameSurvivor=null")
if exist "%mdlFileSurvivor%" (
	:: Decompile
	"%appCrowbarDecompilerExec%" "%mdlFileSurvivor%" Survivor_%sysTime%
	:: Check if necessary QCIs are present
	if not exist "%vpkpath%\Survivor_%sysTime%\%mdlFileNameSurvivor%_bone.qci" (set "vpkMDLValid=0")
	if not exist "%vpkpath%\Survivor_%sysTime%\%mdlFileNameSurvivor%_animation.qci" (set "vpkMDLValid=0")
	:: Write IKRULE block
	findstr /i "$poseparameter $ikchain $ikautoplaylock" "%vpkpath%\Survivor_%sysTime%\%mdlFileNameSurvivor%_animation.qci">>"%vpkpath%\Survivor_%sysTime%\%mdlFileNameSurvivor%_animation_temp.qci"
	:: Write OTHER blocks
	findstr /v /i "$modelname CrowbarDecompiler" "%vpkpath%\Survivor_%sysTime%\%mdlFileNameSurvivor%.qc">>"%vpkpath%\Survivor_%sysTime%\1_main.qci"
	)>nul 2>nul else (
	set "vpkSurvivorsExist=0"
	)

if exist "%mdlFileSurvivor%" (
	:: Get Survivors Animation Name
	for /f "tokens=2" %%i in ('findstr /i "$includemodel" "%vpkpath%\Survivor_%sysTime%\%mdlFileNameSurvivor%_animation.qci"') do (
		set "mdlAnimationName=%%i"
		set "mdlAnimationName=!mdlAnimationName:"=!"
		set "mdlAnimationName=!mdlAnimationName:survivors/=!"
		set "mdlAnimationName=!mdlAnimationName:.mdl=!"
		goto GetAnimationNameFinished
		)
	)>nul 2>nul
:GetAnimationNameFinished
if exist "%mdlFileSurvivor%" (
	for /f "usebackq eol=; tokens=1,2,3 delims=," %%a in ("%appListSurvivorsAnims%") do (
		if /i "%mdlAnimationName%" == "%%a" (set "oriAnims=%%b"&set "oriAnims_info=%%c")
		)
	move /y "%vpkpath%\Survivor_%sysTime%\%mdlFileNameSurvivor%_animation_temp.qci" "%vpkpath%\Survivor_%sysTime%\%mdlFileNameSurvivor%_animation.qci"
	)>nul 2>nul

if exist "%mdlFileSurvivor%" (
	:: Copy Files to user folder
	copy /y "%vpkpath%\Survivor_%sysTime%\*.smd" "%survivorsFolder%\"
	copy /y "%vpkpath%\Survivor_%sysTime%\*.vrd" "%survivorsFolder%\"
	copy /y "%vpkpath%\Survivor_%sysTime%\*.vta" "%survivorsFolder%\"
	copy /y "%vpkpath%\Survivor_%sysTime%\%mdlFileNameSurvivor%_anims\a_proportions.smd" "%survivorsFolder%\"
	copy /y "%vpkpath%\Survivor_%sysTime%\%mdlFileNameSurvivor%_anims\a_proportions_corrective_animation.smd" "%survivorsFolder%\"
	REM copy /y "%vpkpath%\Survivor_%sysTime%\%mdlFileNameSurvivor%_anims\reference.smd" "%survivorsFolder%\"
	copy /y "%vpkpath%\Survivor_%sysTime%\*.qci" "%survivorsFolder%\"
	)>nul 2>nul

:: Weapons
for /f "usebackq tokens=*" %%a in ("%appListWeapons%") do (
	set "mdlFile=%%a"
	set "mdlFileNameWeapon=!mdlFile:models\weapons\arms\=!"
	set "mdlFileNameWeapon=!mdlFileNameWeapon:.mdl=!"
	set "mdlFileWeapon=%vpkExtractPath%\!mdlFile!"
    if exist "!mdlFileWeapon!" (goto GetWeaponsMDLFinished)
	)
:GetWeaponsMDLFinished
if not defined mdlFileWeapon (set "mdlFileWeapon=null")
if not defined mdlFileNameWeapon (set "mdlFileNameWeapon=null")
if exist "%mdlFileWeapon%" (
	:: Decompile
	"%appCrowbarDecompilerExec%" "%mdlFileWeapon%" Weapon_%sysTime%>nul
	:: Check if necessary QCIs are present
	if not exist "%vpkpath%\Weapon_%sysTime%\%mdlFileNameWeapon%_bone.qci" (set "vpkMDLValid=0")
	if not exist "%vpkpath%\Weapon_%sysTime%\%mdlFileNameWeapon%_animation.qci" (set "vpkMDLValid=0")
	:: Tweak QC file
	findstr /v /i "_animation.qci $modelname CrowbarDecompiler" "%vpkpath%\Weapon_%sysTime%\%mdlFileNameWeapon%.qc">>"%vpkpath%\Weapon_%sysTime%\1_main.qci"
	:: Copy Files to user folder
	copy /y "%vpkpath%\Weapon_%sysTime%\*.smd" "%weaponsFolder%\"
	copy /y "%vpkpath%\Weapon_%sysTime%\*.qci" "%weaponsFolder%\"
	copy /y "%vpkpath%\Weapon_%sysTime%\*.vrd" "%weaponsFolder%\"
	)>nul 2>nul else (
	set "vpkWeaponsExist=0"
	)

:ClearTempFiles
:: Clear Extracted and Temp Files
rd /s /q "%vpkExtractPath%">nul 2>nul
rd /s /q "%vpkpath%\Survivor_%sysTime%">nul 2>nul
rd /s /q "%vpkpath%\Weapon_%sysTime%">nul 2>nul
del /q "%targetPath_Exist%.vpk">nul 2>nul

if "%vpkPortraitsExist%" == "1" if "%vpkSurvivorsExist%" == "1" if "%vpkWeaponsExist%" == "1" if "%vpkMDLValid%" == "1" (goto ProcessCompleteScreen)
goto ProcessFailScreen

:CheckFailScreen
cls&color 0C
echo,
if defined failReason0 (echo,&echo,%uiFailedReason0%&echo,)
if defined failReason1 (echo,&echo,%uiFailedReason1%&echo,)
if defined failReason2 (echo,&echo,%uiFailedReason2%&echo,)
if defined failReason3 (echo,&echo,%uiFailedReason3%&echo,)
echo,&echo,&echo,
echo,%uiFailed0%&pause>nul&exit

:ProcessFailScreen
cls&color 0C
echo,&echo,
if "%vpkPortraitsExist%" == "0" (echo,%uiProcFailedReason0%&echo,)
if "%vpkSurvivorsExist%" == "0" (echo,%uiProcFailedReason1%&echo,)
if "%vpkWeaponsExist%" == "0" (echo,%uiProcFailedReason2%&echo,)
if "%vpkMDLValid%" == "0" (echo,%uiProcFailedReason3%&echo,)
echo,&echo,&echo,
if "%vpkMDLValid%" == "1" (echo,%uiProcFailed0%)
if "%vpkPortraitsExist%" == "0" if "%vpkSurvivorsExist%" == "0" if "%vpkWeaponsExist%" == "0" (
	rd /s /q "%materialsFolder%"
	mkdir "%materialsFolder%"
	cls&echo,&echo,&echo,%uiProcFailed1%&echo,
	)>nul 2>nul
echo,&echo,&echo,
echo,%uiProcFailed2%&pause>nul&exit

:ProcessCompleteScreen
cls&color 0A
echo,&echo,&echo,%uiProcComplete0%
echo,
echo,
if defined oriAnims_info (call echo,%uiProcComplete1%) else (echo,)
echo,&echo,&echo,&echo,&echo,&echo,
echo,%uiProcComplete2%&pause>nul
set "modeClearConfirmed="
call "%appFolder%\COMPILE.bat"