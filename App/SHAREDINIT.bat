set "materialsFolder=%toolPath%1_Materials"
set "portraitsFolder=%toolPath%2_Portraits"
set "survivorsFolder=%toolPath%3_Survivors"
set "weaponsFolder=%toolPath%4_Weapons"
set "outputFolder=%toolPath%5_OUTPUT"
set "logsFolder=%toolPath%6_LOGS"

set "appListFolder=%appFolder%\ListFiles"
set "appListUI0=%appListFolder%\%appListUITXT0%.txt"
set "appListUI1=%appListFolder%\%appListUITXT1%.txt"
set "appListPortraits=%appListFolder%\PortraitFileNameList.txt"
set "appListSurvivors=%appListFolder%\SurvivorFileNameList.txt"
set "appListSurvivorsAnims=%appListFolder%\SurvivorAnimList.txt"
set "appListWeapons=%appListFolder%\WeaponFileNameList.txt"
set "appListSurvivorsParms=%appListFolder%\SurvivorParmList.txt"
set "appListAddoninfoTXT=%appListFolder%\AddoninfoContentList.txt"
set "appListBinGame=%appListFolder%\BinGameFileList.txt"
set "appListBinNekoMDL=%appListFolder%\BinNekoFileList.txt"
set "appListPortraitsVMT=%appListFolder%\VMTContentList.txt"
set "appListCharNameSpecialChars=%appListFolder%\CharNameSpecialCharsList.txt"

set "appVPKConverterFolder=%appFolder%\VPKConverter"
set "appVPKConverterExec=%appVPKConverterFolder%\vpk.exe"
set "appCrowbarDecompilerFolder=%appFolder%\CrowbarDecompiler"
set "appCrowbarDecompilerExec=%appCrowbarDecompilerFolder%\CrowbarDecompiler.exe"
set "appAddoninfoFolder=%appFolder%\Addoninfo"
set "appPortraitsFolder=%appFolder%\Portraits"
set "appPortraitsFolderTXT=%appPortraitsFolder%\ReadME.txt"
set "appSurvivorsFolder=%appFolder%\Survivors"
set "appWeaponsFolder=%appFolder%\Weapons"
set "appGameFolder=%appFolder%\Game"
set "appBinFolder=%appGameFolder%\bin"
set "appBinNekoMDLFolder=%appGameFolder%\bin_nekomdl"
set "appBinExec=%appBinFolder%\studiomdl_8tools.exe"
set "appBinNekoMDLExec=%appBinNekoMDLFolder%\nekomdl_8tools.exe"
set "appConfig=%appFolder%\config.ini"
set "appConfigDef=%appFolder%\config_default.ini"
set "appPortraitsVTFFPSDef=%appFolder%\VTFframerate_default.ini"
set "appConfigSaveString=empty"
set "appCompileCommand=%appFolder%\COMPILE_COMMANDS.bat"
set "appLogErrorTXT=%logsFolder%\ERRORLOG.log"

set "outputFolderSurvivors=%appGameFolder%\left4dead2\models\survivors"
set "outputFolderWeapons=%appGameFolder%\left4dead2\models\weapons\arms"
set "outputPortraitsVTFFPS=%portraitsFolder%\VTFframerate.ini"

set "ptab=	"

:: Load UI Strings
if not defined toolPath (cd..&set "toolPath=!cd!\")
if not exist "%appListUI0%" (exit)
if not exist "%appListUI1%" (exit)
for /f "usebackq eol=; tokens=1,2 delims==" %%a in ("%appListUI0%") do (set "%%a=%%b")
for /f "usebackq eol=; tokens=1,2 delims==" %%a in ("%appListUI1%") do (set "%%a=%%b")

:: Check System Variable
:Func_CheckSystemVar_Start

set "testVarFile=20cat.tmp1"
set "testRegFile=SystemVaribleFix.reg"
set "testVarSeqNum=1"
set "testVarStr="
set "testVarOK="
set "testVarChoice="
del /q %testVarFile%>nul 2>nul
set path>>"%testVarFile%"

:Func_CheckSystemVar_Loop
for /f "usebackq tokens=%testVarSeqNum% delims==;" %%a in ("%testVarFile%") do (
	set "testVarStr=%%a"
	if not defined testVarStr (goto Func_CheckSystemVar_End)
	set "testVarStr=%%a\winload.exe"
	set /a "testVarSeqNum=!testVarSeqNum!+1"
	if exist "!testVarStr!" (set "testVarOK=1"&goto Func_CheckSystemVar_End) else (goto Func_CheckSystemVar_Loop)
	)
	
:Func_CheckSystemVar_End
del /q %testVarFile%>nul 2>nul
if not defined testVarOK (
	cls&title %uiCheckTitle%
	echo,&echo,
	echo,%uiCheck0%
	echo,
	echo,%uiCheck1%
	echo,
	echo,%uiCheck2%
	echo,
	echo,&echo,&echo,&echo,
	echo,%uiCheck3%
	set /p testVarChoice=
	if /i "!testVarChoice!" == "y" (
		cls
		echo,&echo,
		echo,%uiCheck4_0%
		echo,
		echo,%uiCheck4_1%
		echo,%uiCheck4_2%
		echo,%uiCheck4_3%
		echo,%uiCheck4_4%
		echo,&echo,
		start /wait "" "%appFolder%\%testRegFile%"
		echo,%uiCheck5%
		pause>nul&exit
		)
	goto Func_CheckSystemVar_Start
	)

goto :EOF