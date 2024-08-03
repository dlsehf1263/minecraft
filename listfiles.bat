@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

REM 대상 폴더 경로 설정
set "folder_path=files"
set "output_file=filelist.json"

REM JSON 파일 초기화
echo { > "%output_file%"

REM 재귀적으로 폴더 항목을 JSON 형식으로 기록하는 함수
call :processFolder "%folder_path%"

REM JSON 파일 종료
echo ".":[] >> "%output_file%"
echo } >> "%output_file%"

echo JSON 파일이 생성되었습니다: %output_file%
exit /b

:processFolder
set "current_folder=%~1"

REM 현재 폴더의 파일 목록 생성
set file_list=
for /f "delims=" %%f in ('dir /b /A-D "%current_folder%"') do (
    set "filename=%%~nxf"
    
    for %%A in ("!current_folder!\!filename!") do (
        set filesize=%%~zA
    )

    set data=["%%~nxf",!filesize!]

    if "!file_list!"=="" (
        set "file_list=[!data!"
    ) else (
        set "file_list=!file_list!, !data!"
    )
)

REM JSON에 현재 폴더의 파일 목록 추가
if "!file_list!" neq "" (
    set "folder_name=!current_folder:%folder_path%=!"  REM 상대 경로로 변환
    echo !folder_name! REM 신기하게 이게 있고 없고에 따라 /가 붙거나 없어진다.
    set "folder_name=!folder_name:~1!"  REM 첫 문자 제거
    echo "!folder_name!": !file_list!], >> "%output_file%"
)

REM 하위 폴더가 있는 경우 재귀 호출
for /f "delims=" %%d in ('dir /b /ad "%current_folder%"') do (
    call :processFolder !current_folder!/%%d
)

exit /b
