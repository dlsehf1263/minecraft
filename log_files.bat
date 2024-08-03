@echo off
setlocal enabledelayedexpansion

REM 대상 폴더 경로 설정
set "folder_path=mods"
set "output_file=output.json"

REM JSON 파일 초기화
echo [ > "%output_file%"

REM 카운터 초기화
set count=0

REM 재귀적으로 폴더 항목을 JSON 형식으로 기록하는 함수
call :processFolder "%folder_path%"

REM JSON 파일 종료
echo ] >> "%output_file%"

echo JSON 파일이 생성되었습니다: %output_file%
exit /b

:processFolder
set "current_folder=%~1"

for /f "delims=" %%f in ('dir /b /s "%current_folder%"') do (
    set "filename=%%~nxf"
    set "filepath=%%f"
    if !count! gtr 0 (
        echo , >> "%output_file%"
    )
    echo {"name": "!filename!", "path": "!filepath!"} >> "%output_file%"
    set /a count+=1
)

exit /b
