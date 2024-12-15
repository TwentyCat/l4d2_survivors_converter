if not defined toolPath (cd..&set "toolPath=!cd!\")
if not exist "%appListUI0%" (exit)
if not exist "%appListUI1%" (exit)
for /f "usebackq eol=; tokens=1,2 delims==" %%a in ("%appListUI0%") do (set "%%a=%%b")
for /f "usebackq eol=; tokens=1,2 delims==" %%a in ("%appListUI1%") do (set "%%a=%%b")

goto :EOF