setlocal

:: 버전
set currentDate=%DATE%
set currentTime=%TIME%
echo %currentDate% %currentTime% > version.txt

:: 모드
set "folder=mods"
> mods.txt echo.
for %%f in (%folder%\*) do echo %%~nxf >> mods.txt

endlocal

git remote add origin https://github.com/dlsehf1263/minecraft.git
git branch -M main
git add .
git commit --allow-empty-message -m ""
git push -u origin main