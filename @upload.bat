call listfiles.bat

setlocal

set currentDate=%DATE%
set currentTime=%TIME%

git remote add origin https://github.com/dlsehf1263/minecraft.git
git branch -M main
git add .
git commit -m "%currentDate% %currentTime%"
git push -u origin main

endlocal