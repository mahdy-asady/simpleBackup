@echo off
REM Set the path of backup files. the below line MUST BE at line 3. the installer changes its content
SET backupFolder=D:\Data\Backup

if "%1" == "-i" GOTO Install
if "%1" == "-I" GOTO Install
if "%1" == "-b" GOTO Backup
if "%1" == "-B" GOTO Backup
REM else show help
GOTO Help




REM ***************************************************************************************************************************************
REM ***************************************************************************************************************************************
:Backup
REM get name of folder that we want to backup. the folder name will be the name of backup file
for %%I in (%2) do set FolderName=%%~nxI
REM get folder of this batch file. it is used to create temporary files and spinner batch file
SET rootPath=%~dp0

REM content of spinner batch file
(
echo @echo off
echo if exist stopslash.dat del stopslash.dat
echo :start
echo ^<nul set /p ="."
echo timeout 2 ^>nul
echo if exist %rootPath%stopslash.dat del %rootPath%stopslash.dat^&goto endfile
echo goto start
echo :endfile
echo exit
)>%rootPath%spinner.bat


echo.
echo.
echo.
echo.
echo             ,,                              ,,                                                                        
echo   .M"""bgd  db                            `7MM              `7MM"""Yp,                `7MM                            
echo  ,MI    "Y                                  MM                MM    Yb                  MM                            
echo  `MMb.    `7MM  `7MMpMMMb.pMMMb. `7MMpdMAo. MM  .gP"Ya        MM    dP  ,6"Yb.  ,p6"bo  MM  ,MP'`7MM  `7MM `7MMpdMAo. 
echo    `YMMNq.  MM    MM    MM    MM   MM   `Wb MM ,M'   Yb       MM"""bg. 8)   MM 6M'  OO  MM ;Y     MM    MM   MM   `Wb 
echo  .     `MM  MM    MM    MM    MM   MM    M8 MM 8M""""""       MM    `Y  ,pm9MM 8M       MM;Mm     MM    MM   MM    M8 
echo  Mb     dM  MM    MM    MM    MM   MM   ,AP MM YM.    ,       MM    ,9 8M   MM YM.    , MM `Mb.   MM    MM   MM   ,AP 
echo  P"Ybmmd" .JMML..JMML  JMML  JMML. MMbmmd'.JMML.`Mbmmd'     .JMMmmmd9  `Moo9^Yo.YMbmd'.JMML. YA.  `Mbod"YML. MMbmmd'  
echo                                    MM                                                                        MM       
echo                                  .JMML.                                                                    .JMML.  

REM Run spinner
<nul set /p ="Backup in progress"
start /b %rootPath%spinner.bat
REM Run winrar to compress folder with my rule
%rootPath%Rar.exe a -r -k -idq -m5 -rr5p -s -ag[YYYY-MM-DD]N "%backupFolder%\%FolderName%" %2

REM After finishing rar. creating a temporary file. this tells to spinner to finsh its job
echo "Mehrsoft">%rootPath%stopslash.dat
:waitdel
REM Waiting to spinner.bat to delete temporary file and exit
if exist %rootPath%stopslash.dat goto waitdel

del %rootPath%spinner.bat
echo.
echo                                  ****************************************
echo                                  **          Backup Finished!          **
echo                                  ****************************************
timeout 2 >nul
exit

goto END




REM ***************************************************************************************************************************************
REM ***************************************************************************************************************************************
:Install


goto END



REM ***************************************************************************************************************************************
REM ***************************************************************************************************************************************
:Help
echo %0 %*
echo Usage: backup.bat [Switches] [Path]
echo   Switches:
echo     -b: do backup of the folder Path
echo     -i: install backup utility in windows registry. so you can back up any folder by right click on it and select "Backup"
echo.
echo Backup example: Backup.bat -b "C:\Data"
echo   It will backup folder "C:\Data"
:END
