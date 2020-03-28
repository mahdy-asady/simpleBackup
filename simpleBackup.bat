@echo off
CLS&color
setlocal
:: Set the path of backup files. the below line MUST BE at line 4. the installer will change its content
SET backupBankFolder=D:\Data\Backup
:: get folder of this batch file. it is used to create temporary files and spinner batch file
SET rootPath=%~dp0
:: process arguments
if "%1" == "-i" GOTO Install
if "%1" == "-I" GOTO Install
if "%1" == "-b" GOTO Backup
if "%1" == "-B" GOTO Backup
:: else show help
GOTO Help
:: ***************************************************************************************************************************************
:: ***************************************************************************************************************************************
:Backup
REM get name of folder that we want to backup. the folder name will be the name of backup file
for %%I in (%2) do set FolderName=%%~nxI
echo:
echo:
echo:
echo:
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
:: First check if backupBankFolder exists. if not show error and tell user to run installer
if not exist %backupBankFolder%\ (
  echo:
  echo                            ****************************************************************
  echo                            **                           Error!                           **
  echo                            ** Bank folder not exist. Please run "simpleBackup -i" first. **
  echo                            ****************************************************************
  setlocal enableextensions enabledelayedexpansion
  for /l %%i in (1,1,7) do (
    set /A r = %%i%%2
	if !r! EQU 0 color 4
	if !r! EQU 1 color 7
    timeout 1 >nul
  )
  endlocal
  GOTO END
)
:: content of spinner batch file
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
:: Run spinner
<nul set /p ="Backup in progress"
start /b %rootPath%spinner.bat
:: Run WinRAR to compress folder with my rule
%rootPath%Rar.exe a -r -k -idq -m5 -rr5p -s -ag[YYYY-MM-DD]N "%backupBankFolder%\%FolderName%" %2
:: After finishing Rar.exe, creating a temporary file. this tells to spinner to finsh its job
echo "Mehrsoft">%rootPath%stopslash.dat
:waitdel
:: Waiting to spinner.bat to delete temporary file and exit
if exist %rootPath%stopslash.dat goto waitdel
del %rootPath%spinner.bat
color 2
echo:
echo                                        ****************************************
echo                                        **          Backup Finished!          **
echo                                        ****************************************
goto END
:: ***************************************************************************************************************************************
:: ***************************************************************************************************************************************
:Install
echo simpleBackup Installer
echo Please enter path of backup Bank folder. all your backups will save at this folder.
echo Current path is "%backupBankFolder%". If it is ok then just press Enter. otherwise type your path.
echo Note that the trailing slash should be removed.
:getPath
set tempBankFolder=
set /P tempBankFolder="Bank Folder: "
if "%tempBankFolder%" == "" set tempBankFolder=%backupBankFolder%
if not exist %tempBankFolder%\ (
  echo Error! folder not exist. Enter correct one.
  GOTO getPath
)
:: edit line 5 of current batch file
setlocal enableextensions enabledelayedexpansion
set /A i=0
for /f "delims=" %%f in ('type "%0"^&cd.^>"%0"') do (
  set /A i+=1
  if !i! EQU 5 (
    echo SET backupBankFolder=%tempBankFolder%>>%0
  ) else (
	Setlocal DisableDelayedExpansion
      echo %%f>>%0
	Endlocal
  )
)
endlocal
:: add to Registry
reg add HKCR\Directory\shell\Backup /v icon /f /d "%%systemroot%%\system32\setupapi.dll,46">NUL
reg add HKCR\Directory\shell\Backup\command /ve /f /d "%~f0 -b ""%%1""">NUL
color 2
echo:
echo               ******************************************************************************
echo               **                           Software Installed!                            **
echo               ** Now you can right click on every folder that you want and click "Backup" **
echo               ******************************************************************************
GOTO END
:: ***************************************************************************************************************************************
:: ***************************************************************************************************************************************
:Help
echo %0 %*
echo Usage: backup.bat [Switches] [Path]
echo   Switches:
echo     -b: do backup of the folder Path
echo     -i: install backup utility in windows registry. so you can back up any folder by right click on it and select "Backup"
echo:
echo Backup example: Backup.bat -b "C:\Data"
echo   It will backup folder "C:\Data"
:END
timeout 2 >nul
color
endlocal
