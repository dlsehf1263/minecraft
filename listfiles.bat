@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
@echo off
REM chcp는 한글 사용할 수 있게 도와줌. echo off 순서가 잘못되면 chcp가 무효화 되는듯.
REM 위 주석도 맨 위에 있으면 배치파일 이상해짐.

REM 대상 폴더 경로 설정
set "folder_path=files"
set "output_file=filelist.json"

REM JSON 파일 초기화
echo { > "%output_file%"

call :processFolder "%folder_path%"

REM JSON 파일 종료
echo "/":[] >> "%output_file%"
echo } >> "%output_file%"

exit /b

REM 재귀적으로 폴더 항목을 JSON 형식으로 기록하는 함수
:processFolder
set "current_path=%~1"
REM 이하의 %~1은 processFolder를 call했을 때 전달되는 첫번째 인자를 가리킴.

REM 현재 폴더의 파일 목록 생성
set file_list=
for /f "delims=" %%f in ('dir /b /A-D "!current_path!"') do (
    set "filename=%%~nxf"
    
    for %%A in ("!current_path!\!filename!") do (
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
    REM 상대 경로로 변환
    REM "%folder_path%" -> "" / "%folder_path%\mods" -> "\mods"
    set "folder_name=!current_path:%folder_path%=!"
    
    REM 첫 문자 제거
    if "!folder_name!" neq "" (
        set "folder_name=!folder_name:~1!"
    )

    echo "!folder_name!": !file_list!], >> "%output_file%"
)

REM 하위 폴더가 있는 경우 재귀 호출
for /f "delims=" %%d in ('dir /b /ad "%~1"') do (
    REM !current_path! 대신 %~1을 직접 사용하는 이유는,
    REM current_path는 함수가 호출될 때마다 그 호출 스택에 맞게 하나가 생성되는 게 아니라 하나만 생성되고 계속 돌려 쓰게된다.
    REM 재귀 호출이 끝나고 다시 이 함수로 돌아왔을 때 원래의 값은 찾을 수 없게 되기 때문이다.
    call :processFolder "%~1\%%d"
)

exit /b
