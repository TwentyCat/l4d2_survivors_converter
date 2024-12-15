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