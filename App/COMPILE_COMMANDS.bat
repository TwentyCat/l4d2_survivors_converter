@echo off&mode con cols=120 lines=30
:: (7/7) Move Output Files and Clear Temp Files
if /i "%curCommand%" == "weapon" (
	title %currentChar% - Weapon
	"%studiomdlExec%" %studiomdlOpt% "%weaponsFolder%\%currentChar%.qc" >> "%logsFolder%\%sysTime%_%currentChar%_Weapon.log"
	mkdir "%targetFolderWeapons%"
	move /y "%outputFolderWeapons%\%m2%.mdl" "%targetFolderWeapons%\"
	move /y "%outputFolderWeapons%\%m2%.dx90.vtx" "%targetFolderWeapons%\"
	move /y "%outputFolderWeapons%\%m2%.vvd" "%targetFolderWeapons%\"
)>nul 2>nul

if /i "%curCommand%" == "survivor_nop" (
	title %currentChar% - Survivor ^(NoProportions^)
	"%studiomdlExec%" %studiomdlOpt% "%survivorsFolder%\%oriAnims%2%currentChar%_NoProportions.qc" >> "%logsFolder%\%sysTime%_%currentChar%_Survivor.log"
	call :Func_SurvivorFileOperations
)

if /i "%curCommand%" == "survivor_nop_light" (
	title %currentChar% - Survivor ^(NoProportions, Light^)
	"%studiomdlExec%" %studiomdlOpt% "%survivorsFolder%\%oriAnims%2%currentChar%_light_NoProportions.qc" >> "%logsFolder%\%sysTime%_%currentChar%_Survivor_Light.log"
	call :Func_SurvivorFileOperations_Light
)

if /i "%curCommand%" == "survivor" (
	title %currentChar% - Survivor
	"%studiomdlExec%" %studiomdlOpt% "%survivorsFolder%\%oriAnims%2%currentChar%.qc" >> "%logsFolder%\%sysTime%_%currentChar%_Survivor.log"
	call :Func_SurvivorFileOperations
)

if /i "%curCommand%" == "survivor_light" (
	title %currentChar% - Survivor ^(Light^)
	"%studiomdlExec%" %studiomdlOpt% "%survivorsFolder%\%oriAnims%2%currentChar%_light.qc" >> "%logsFolder%\%sysTime%_%currentChar%_Survivor_Light.log"
	call :Func_SurvivorFileOperations_Light
)
exit

:Func_SurvivorFileOperations
mkdir "%targetFolderSurvivors%">nul 2>nul
move /y "%outputFolderSurvivors%\%m1%.mdl" "%targetFolderSurvivors%\"
move /y "%outputFolderSurvivors%\%m1%.dx90.vtx" "%targetFolderSurvivors%\"
move /y "%outputFolderSurvivors%\%m1%.vvd" "%targetFolderSurvivors%\"
move /y "%outputFolderSurvivors%\%m1%.phy" "%targetFolderSurvivors%\"
goto :EOF
:Func_SurvivorFileOperations_Light
mkdir "%targetFolderSurvivors%">nul 2>nul
move /y "%outputFolderSurvivors%\%m1%_light.ani" "%targetFolderSurvivors%\"
move /y "%outputFolderSurvivors%\%m1%_light.mdl" "%targetFolderSurvivors%\"
move /y "%outputFolderSurvivors%\%m1%_light.dx90.vtx" "%targetFolderSurvivors%\"
move /y "%outputFolderSurvivors%\%m1%_light.vvd" "%targetFolderSurvivors%\"
move /y "%outputFolderSurvivors%\%m1%_light.phy" "%targetFolderSurvivors%\"
goto :EOF