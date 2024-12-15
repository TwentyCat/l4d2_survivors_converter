set "materialsFolder=%toolPath%1_Materials"
set "portraitsFolder=%toolPath%2_Portraits"
set "survivorsFolder=%toolPath%3_Survivors"
set "weaponsFolder=%toolPath%4_Weapons"

set "appListFolder=%appFolder%\ListFiles"
set "appVPKConverterFolder=%appFolder%\VPKConverter"
set "appVPKConverterExec=%appVPKConverterFolder%\vpk.exe"
set "appCrowbarDecompilerFolder=%appFolder%\CrowbarDecompiler"
set "appCrowbarDecompilerExec=%appCrowbarDecompilerFolder%\CrowbarDecompiler.exe"
set "appListUI0=%appListFolder%\%appListUITXT0%.txt"
set "appListUI1=%appListFolder%\%appListUITXT1%.txt"
set "appListPortraits=%appListFolder%\PortraitFileNameList.txt"
set "appListSurvivors=%appListFolder%\SurvivorFileNameList.txt"
set "appListSurvivorsAnims=%appListFolder%\SurvivorAnimList.txt"
set "appListWeapons=%appListFolder%\WeaponFileNameList.txt"
set "appSysVarChecker=%appFolder%\SYSTEMVARCHECKER.bat"
set "appUIStringLoader=%appFolder%\UISTRINGLOADER.bat"

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
set "appListUI0=%appListFolder%\%appListUITXT0%.txt"
set "appListUI1=%appListFolder%\%appListUITXT1%.txt"
set "appListSurvivorsParms=%appListFolder%\SurvivorParmList.txt"
set "appListAddoninfoTXT=%appListFolder%\AddoninfoContentList.txt"
set "appListBinGame=%appListFolder%\BinGameFileList.txt"
set "appListBinNekoMDL=%appListFolder%\BinNekoFileList.txt"
set "appListPortraitsVMT=%appListFolder%\VMTContentList.txt"
set "appListCharNameSpecialChars=%appListFolder%\CharNameSpecialCharsList.txt"
set "appCompileCommand=%appFolder%\COMPILE_COMMANDS.bat"
set "appLogErrorTXT=%logsFolder%\ERRORLOG.log"
set "appSysVarChecker=%appFolder%\SYSTEMVARCHECKER.bat"
set "appUIStringLoader=%appFolder%\UISTRINGLOADER.bat"

set "outputFolderSurvivors=%appGameFolder%\left4dead2\models\survivors"
set "outputFolderWeapons=%appGameFolder%\left4dead2\models\weapons\arms"

:: Load UI Strings
if not exist "%appUIStringLoader%" (exit) else (call "%appUIStringLoader%")

:: Check System Variable
if not exist "%appSysVarChecker%" (exit) else (call "%appSysVarChecker%")

goto :EOF