@echo off
setlocal enabledelayedexpansion
@REM Here If you to change the delims change from here,As advice use on of this delims [#,$,&,§] and also don't write more then 1 character
set delims=#
:Menu
echo ---------------------------------------------
echo ----- Wellcom to To-Do-List Application -----
echo ---------------------------------------------
echo [1] Add new task
echo [2] View all tasks
echo [3] Delete one task
echo [4] Delete all tasks
echo [5] Edit task
echo [6] Settings
echo [7] Exit 
set /p op=Choose an option [1-7]? 
cls 
if %op% EQU 1 (
    goto add_task
) else if %op% EQU 2 (
    goto view_all_tasks
) else if %op% EQU 3 (
    goto delete_one_task
) else if %op% EQU 4 (
    goto delete_all_tasks
) else if %op% EQU 5 (
    goto Update
) else if %op% EQU 6 (
    goto settings
) else (
    goto exit_s
)



:add_task
echo ----------------------------
echo ------- Add New Task -------
echo ----------------------------
set /p title=Title: 
set /p des=Description(in one line): 
set /p dif=Difficulty from 1 to 3[Easy - Normal - Hard] only number : 
if not "%dif%"=="1" if not "%dif%"=="2" if not "%dif%"=="3" (
    set dif=1
)
echo %title%%delims%%des%%delims%%dif% >> tasks.txt
echo The tasks was added successfully!
pause
cls
goto Menu


:view_all_tasks
echo --------------------------------------------------------------------
echo ------------------------ List Of Tasks INFO ------------------------
echo --------------------------------------------------------------------
if not exist "tasks.txt" (
        echo No tasks to display..
        pause
        cls
        goto Menu
)
set count=0
for /f "tokens=1,2,3 delims=%delims%" %%a in (tasks.txt) do (
    set /a count=!count!+1
    echo ###### Tasks Number [!count!] ######
    echo - Tasks Title: %%a
    echo - Tasks Description:
    echo                     "%%b"
    @REM To trim any space or anything
    set diff=%%c
    set diff=!diff: =!
    if "!diff!" == "1" (
        echo - Difficulty: Easy
    ) else if "!diff!" == "2" (
        echo - Difficulty: Normal
    ) else if "!diff!" == "3" (
        echo - Difficulty: Hard
    )
    echo --------------------------------------------------------------------
)

pause
cls
goto Menu

:delete_one_task
echo -------------------------------
echo ------- Delete One Task -------
echo -------------------------------
if not exist "tasks.txt" (
        echo There are no tasks to delete!, create one task at least
        pause
        cls
        goto Menu
)
set /p task_num=Enter Task Number: 
set count=0
set found=0
for /f "tokens=1,2,3 delims=%delims%" %%a in (tasks.txt) do (
    set /a count=!count!+1
    if %task_num% EQU !count! (
        set found=1
        echo ------------------------------------
        echo - Tasks Title: %%a
        echo - Tasks Description:
        echo  "%%b"
        set diff=%%c
        set diff=!diff: =!
        if "!diff!" == "1" (
            echo - Difficulty: Easy
        ) else if "!diff!" == "2" (
            echo - Difficulty: Normal
        ) else if "!diff!" == "3" (
            echo - Difficulty: Hard
        )
        echo ------------------------------------
    )
)
if !found! EQU 1 (
    set /p deleted=Are you sure that you want to delete this task?[Y/N]? 
    if /i "!deleted!" EQU "Y" (
        set k=0
        copy tasks.txt temp.txt
        del tasks.txt /q /f
        for /f "usebackq delims=" %%i in (temp.txt) do (
            set /a k=!k!+1
            if !k! NEQ %task_num% (
                echo %%i >> tasks.txt
            )
        )
        del temp.txt /q /f
        echo Task deleted successfully!
    ) else (
        echo Task is not deleted!
    )
) else (
    echo Task number %task_num% was not found!
)
pause
cls
goto Menu



:delete_all_tasks
echo --------------------------------
echo ------- Delete All Tasks -------
echo --------------------------------
set /p del_all=Are you sure that you want to delete all tasks?[Y/N]? 
if /i "%del_all%"=="Y" (
    if not exist "tasks.txt" (
        echo The file does not exist!
    ) else (
        echo all tasks are deleted successfully!
        del tasks.txt /q /f
    )
)
pause
cls
goto Menu




:Update
echo ----------------------------
echo ------- Update Tasks -------
echo ----------------------------
if not exist "tasks.txt" (
        echo There are no tasks to Update!, create one task at least
        pause
        cls
        goto Menu
)
set /p task_num=Enter Task Number: 
set count=0
set found=0
@REM This code only to display task info
for /f "tokens=1,2,3 delims=%delims%" %%a in (tasks.txt) do (
    set /a count=!count!+1
    if !task_num! EQU !count! (
        set found=1
        echo ------------------------------------
        echo - Tasks Title: %%a
        echo - Tasks Description:
        echo  "%%b"
        set diff=%%c
        set diff=!diff: =!
        if "!diff!" == "1" (
            echo - Difficulty: Easy
        ) else if "!diff!" == "2" (
            echo - Difficulty: Normal
        ) else if "!diff!" == "3" (
            echo - Difficulty: Hard
        )
        echo ------------------------------------
    )
)

if !found! EQU 1 (
    echo Option:
    echo [1] Title
    echo [2] Description
    echo [3] Difficulty
    echo [4] Exit
    set /p update_op=Choose only one thing [1-3]: 

    cls
    echo ----------------------------
    echo ------- Update Tasks -------
    echo ----------------------------
    set task_title=
    set task_description=
    set task_difficulty=
    set count=0
    for /f "tokens=1,2,3 delims=%delims%" %%a in (tasks.txt) do (
        set /a count=!count!+1
        if !task_num! EQU !count! (
            set found=1
            echo ## Task Info
            echo - Tasks Title: %%a
            echo - Tasks Description:
            echo  "%%b"
            set diff=%%c
            set diff=!diff: =!
            if "!diff!" == "1" (
                echo - Difficulty: Easy
            ) else if "!diff!" == "2" (
                echo - Difficulty: Normal
            ) else if "!diff!" == "3" (
                echo - Difficulty: Hard
            )
            set task_title=%%a
            set task_description=%%b
            set task_difficulty=%%c
        )
    )

    @REM echo Update OP : !update_op!
    if !update_op! EQU 1 (
        set /p task_title=Enter new Title: 
    ) else if !update_op! EQU 2 (
        echo Description here
        set /p task_description=Enter new description, in one line only: 
    ) else if !update_op! EQU 3 (
        echo Difficulty here
        set /p task_difficulty=Enter new difficulty from 1 to 3 [Easy - Normal - Hard]: 
        
        if not "!task_difficulty!"=="1" if not "!task_difficulty!"=="2" if not "!task_difficulty!"=="3" (
            set task_difficulty=1
        )
    ) else (
        pause 
        cls
        goto Menu
    )
    
    set /p updated=Are you sure that you want to update this task?[Y/N]? 
    if /i "!updated!" EQU "Y" (
        set k=0
        copy tasks.txt temp.txt
        del tasks.txt /q /f
        set UpdatedTask=!task_title!%delims%!task_description!%delims%!task_difficulty!
        for /f "usebackq delims=" %%i in (temp.txt) do (
            set /a k=!k!+1
            if !k! EQU !task_num! (
                echo !UpdatedTask! >> tasks.txt
            ) else (
                echo %%i >> tasks.txt
            )
        )
        del temp.txt /q /f
        echo Task Updated successfully!
    ) else (
        echo Task is not updated!
    )
) else (
    echo Task number %task_num% was not found!
)
pause
cls
goto Menu





:settings
echo --------------------
echo ----- Settings -----
echo --------------------
set ColorCode=00
set /p theme=Enter The number 1 or 2 to change the theme[Dark - Light]: 
if %theme% EQU 1 (
    set /a ColorCode= %ColorCode%+00
) else (
    set /a ColorCode= %ColorCode%+70
)
echo Enter a number from 1 to 6 to change the font color
echo [1] Blue
echo [2] Green
echo [3] Aqua
echo [4] Red
echo [5] Purple
echo [6] Yellow
set /p fontColor=Choose one of them: 
if %fontColor% EQU 1 (
    set /a ColorCode= %ColorCode%+1
) else if  %fontColor% EQU 2 (
    set /a ColorCode= %ColorCode%+2
) else if  %fontColor% EQU 3 (
    set /a ColorCode= %ColorCode%+3
) else if  %fontColor% EQU 4 (
    set /a ColorCode= %ColorCode%+4
) else if  %fontColor% EQU 5 (
    set /a ColorCode= %ColorCode%+5
) else if  %fontColor% EQU 6 (
    set /a ColorCode= %ColorCode%+6
) else (
    set /a ColorCode= %ColorCode%+4
)
color %ColorCode%
set /p change_again=Do you want to change them again? [Y/N]? 
if /i "%change_again%"=="Y" (
    cls
    goto settings
) else (
    cls 
    goto Menu
)

:exit_s
echo ---------------------------
echo ------- EXIT Screen -------
echo ---------------------------
pause
endlocal