@echo off
:: (7/7) Start Compiling
call :Func_GetCompileFileFullPath

if /i "%curCommand%" == "weapon" (
	title %currentChar% - Weapon
	call :Func_InjectNekoCommandsIntoQC
	call :Func_StartCompile
	call :Func_WeaponFileOperations
)

if /i "%curCommand%" == "survivor" (
	title %currentChar% - Survivor
	call :Func_InjectNekoCommandsIntoQC
	call :Func_StartCompile
	call :Func_SurvivorFileOperations
)

if /i "%curCommand%" == "survivor_light" (
	title %currentChar% - Survivor Light
	call :Func_InjectNekoCommandsIntoQC
	call :Func_StartCompile
	call :Func_SurvivorFileOperations_Light
)

if /i "%curCommand%" == "survivor_nop" (
	title %currentChar% - Survivor NoProportions
	call :Func_InjectNekoCommandsIntoQC
	call :Func_StartCompile
	call :Func_SurvivorFileOperations
)

if /i "%curCommand%" == "survivor_light_nop" (
	title %currentChar% - Survivor Light NoProportions
	call :Func_InjectNekoCommandsIntoQC
	call :Func_StartCompile
	call :Func_SurvivorFileOperations_Light
)

exit

:Func_GetCompileFileFullPath
if /i "%curCommand%" == "weapon" (
	set "curQCFullPath=%weaponsFolder%\%curQCName%.qc"
	) else (
	set "curQCFullPath=%survivorsFolder%\%curQCName%.qc"
	)
set "curLogFullPath=%logsFolder%\%curLogName%.log"
goto :EOF

:Func_InjectNekoCommandsIntoQC
if "%enable_nekomdl%" == "1" (
	if "%enable_nekomdl_largebuffer%" == "1" (
		echo,>>"%curQCFullPath%"
		echo $FileBufferSize 16>>"%curQCFullPath%"
		)
	if "%enable_nekomdl_largebuffer%" == "2" (
		echo,>>"%curQCFullPath%"
		echo $FileBufferSize 32>>"%curQCFullPath%"
		)
	)
goto :EOF

:Func_StartCompile
"%studiomdlExec%" %studiomdlOpt% "%curQCFullPath%" >> "%curLogFullPath%"
goto :EOF

:Func_WeaponFileOperations
mkdir "%targetFolderWeapons%"
move /y "%outputFolderWeapons%\%m2%.mdl" "%targetFolderWeapons%\"
move /y "%outputFolderWeapons%\%m2%.dx90.vtx" "%targetFolderWeapons%\"
move /y "%outputFolderWeapons%\%m2%.vvd" "%targetFolderWeapons%\"
goto :EOF

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