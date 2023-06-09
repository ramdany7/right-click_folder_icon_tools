::      Template Info
::===================================
::#  "Folder - Horizontal" PSD Template by 90scomics.com
::#  Convert and edit using ImageMagick.
::# -------------------------------------------------------------------

::                Template Config
::========================================================
::--------- Test Mode -------
set "testmode=no"
set "testmode-auto-execute=yes"
::--------- Display ---------
set "display-discimage=no"
set "display-movieinfo=no"
set "Show-Rating=yes"
set "Show-Genre=yes"
set "genre-characters-limit=26"
set "show-clearArt=no"
set "use-Logo-instead-folderName=no"
set "FolderNameShort-characters-limit=10"
set "FolderNameLong-characters-limit=38"
::------ Image source -------
set "folderhorizontal-top=%rcfi%\img\folderhorizontal-top.png"
set "folderhorizontal-topfx=%rcfi%\img\folderhorizontal-topfx.png"
set "folderhorizontal-topshadow=%rcfi%\img\folderhorizontal-topshadow.png"
set "folderhorizontal-main=%rcfi%\img\folderhorizontal-main.png"
set "folderhorizontal-mainfx=%rcfi%\img\folderhorizontal-mainfx.png"
set "star-image=%rcfi%\img\star.png"
set "disc-image=%rcfi%\img\disc-vinyl.png"
set "background-image=%rcfi%\img\- background.png"
::========================================================




:: Get Movie info from .nfo file
:GetInfo
setlocal
for %%F in ("%cd%") do set "foldername=%%~nxF"
set "FolNamShort=%foldername%"
set "FolNamShortLimit=%FolderNameShort-characters-limit%"
set /a "FolNamShortLimit=%FolNamShortLimit%+1"
set "FolNamLong=%foldername%"
set "FolNamLongLimit=%FolderNameLong-characters-limit%"
set /a "FolNamLongLimit=%FolNamLongLimit%+1"
:GetInfo-FolderName-Short
set /a FolNamShortCount+=1
if not "%_FolNamShort%"=="%FolderName%" (
	call set "_FolNamShort=%%FolderName:~0,%FolNamShortCount%%%"
	goto GetInfo-FolderName-Short
)
set /A "FolNamShortLimiter=%FolNamShortLimit%-4"
if %FolNamShortCount% GTR %FolNamShortLimit% call set "FolNamShort=%%FolderName:~0,%FolNamShortLimiter%%%..."
:GetInfo-FolderName-Long
set /a FolNamLongCount+=1
if not "%_FolNamLong%"=="%FolderName%" (
	call set "_FolNamLong=%%FolderName:~0,%FolNamLongCount%%%"
	goto GetInfo-FolderName-Long
)
set /A "FolNamLongLimiter=%FolNamLongLimit%-4"
if %FolNamLongCount% GTR %FolNamLongLimit% call set "FolNamLong=%%FolderName:~0,%FolNamLongLimiter%%%..."

if "%display-movieinfo%"=="yes" (
	if not exist "*.nfo" (
		echo %TAB% %g_%No ".nfo" detected.%r_% 
		goto Layer
	)
) else (goto Layer)
for %%N in (*.nfo) do (
	set "nfoName=%%~nxN"
	for /f "usebackq tokens=1,2,3,4 delims=<>" %%C in ("%%N") do (
		if /i not "%%D"=="" (
			if /i not "%%D"=="genre" (set "%%D=%%E") else (
				set "genre=%%E" 
				call :GetInfo-Collect
			)
		)
	)
)
if not defined value		echo %TAB%%r_%%i_% %_%%g_% Error: No rating value provided in "%nfoName%"%r_%
if not defined genre		echo %TAB%%r_%%i_% %_%%g_% Error: No genre provided in "%nfoName%"%r_%
set "rating=%value:~0,3%"
set "genre=__%_genre%"
set "genre=%genre:__, =%"
set "genre=%genre:Science Fiction=SciFi%"
set "GenreLimit=%genre-characters-limit%"
set /a "GenreLimit=%GenreLimit%+1"
:GetInfo-Genre
set /a GenreCount+=1
if not "%_genre%"=="%genre%" (
	call set "_genre=%%genre:~0,%GenreCount%%%"
	goto GetInfo-Genre
)
set /A "GenreLimiter=%GenreLimit%-4"
if %GenreCount% GTR %GenreLimit% call set "genre=%%genre:~0,%GenreLimiter%%%..."
goto Layer
:GetInfo-Collect
set "_genre=%_genre%, %genre%"
exit /b



:Layer
:LAYER-BACKGROUND
set BACKGROUND-CODE= ( "%background-image%" ^
	-scale 512x512! ^
	-background none ^
	-extent 512x512 ^
 ) -compose Over


:LAYER-DISC_IMAGE
if exist "*discart.png" (
	for %%D in (*discart.png) do set "discart=%%~fD"
) else set "discart=%disc-image%"
set DISC-IMAGE-CODE= ( "%discart%" ^
	 -scale 300x300! ^
	 -background none ^
	 -gravity Northwest ^
	 -geometry +110+74 ^
	 ( +clone -background BLACK -shadow 100x1.3+2+2 ) ^
	 +swap -background none -layers merge -extent 512x512 ^
	 ) -compose Over -composite

if /i not "%display-discimage%"=="yes" set "DISC-IMAGE-CODE="


:LAYER-STAR_IMAGE
if defined rating set STAR-IMAGE-CODE= ( ^
	 "%star-image%" ^
	 -scale 75x75! ^
	 -gravity Northwest ^
	 -geometry +5+382 ^
	 ( +clone -background BLACK% ^
	 -shadow 40x1.2+1.8+3 ) ^
	 +swap -background none -layers merge -extent 512x512 ^
	 ) -compose Over -composite

if /i not "%Show-Rating%" EQU "yes" set "STAR-IMAGE-CODE="
if /i not "%display-movieinfo%" EQU "yes" set "STAR-IMAGE-CODE="


:LAYER-RATING_TEXT
if defined RATING set RATING-CODE= ( ^
	 -font Arial-Bold ^
	 -fill BLACK ^
	 -pointsize 26 ^
	 label:"%rating%" ^
	 -gravity Northwest ^
	 -geometry +23+411 ^
	 ( +clone -background black -shadow 0x1.3+2+3.5 ) ^
	 +swap -background none -layers merge -extent 512x512 ^
	 ) -compose Over -composite 
 
if /i not "%Show-Rating%" EQU "yes" set "RATING-CODE="
if /i not "%display-movieinfo%" EQU "yes" set "RATING-CODE="


:LAYER-GENRE_TEXT
if defined GENRE set GENRE-CODE= ( ^
	 -font Arial-Bold ^
	 -fill BLACK ^
	 -pointsize 25 ^
	 -gravity Northwest ^
	 -geometry +67+418 ^
	 label:"%genre%" ^
	 ( +clone -background ORANGE -shadow 70x1+0.6+0.6 ) +swap -background none -layers merge ^
	 ( +clone -background YELLOW -shadow 70x1-0.6-0.6 ) +swap -background none -layers merge ^
	 ( +clone -background ORANGE -shadow 70x1-0.6+0.6 ) +swap -background none -layers merge ^
	 ( +clone -background ORANGE -shadow 70x1+0.6-0.6 ) +swap -background none -layers merge ^
	 ) -composite 

if /i not "%Show-Genre%" EQU "yes" set "GENRE-CODE="
if /i not "%display-movieinfo%" EQU "yes" set "GENRE-CODE="

:LAYER-LOGO_IMAGE
if exist "*Logo.png" (
	for %%D in (*Logo.png) do set "Logo=%%~fD"
) else set "Logo="
set Logo-IMAGE-CODE= ( "%Logo%" ^
	 -scale 160x55! ^
	 -background none ^
	 -gravity Northwest ^
	 -geometry +51+86 ^
	 ) -compose Over -composite
if not defined Logo set "Logo-IMAGE-CODE="
if /i not "%use-Logo-instead-folderName%"=="yes" set "Logo-IMAGE-CODE="

:LAYER-CLEARART_IMAGE
if exist "*clearart.png" (
	for %%D in (*clearart.png) do set "clearart=%%~fD"
) else set "clearart="
set CLEARART-IMAGE-CODE= ( "%clearart%" ^
	 -scale 248x ^
	 -background none ^
	 -gravity Northwest ^
	 -geometry +223+3 ^
	 ) -compose Over -composite
if not defined clearart set "CLEARART-IMAGE-CODE="
if /i not "%show-clearArt%"=="yes" set "CLEARART-IMAGE-CODE="

:LAYER-POSTER_TOP
set POSTER-TOP-CODE= ( ^
	 "%inputfile%" ^
	 -scale 512x512! ^
	 -blur 0x19 ^
	 "%folderhorizontal-TOP%" ) -compose over -composite ^
	 ( "%folderhorizontal-TOPfx%" -scale 512x512! ) -compose over -composite


:LAYER-FOLDER_NAME
set FOLDER-NAME-SHORT-CODE= ^
	( ^
	 -font Arial-Bold ^
	 -fill white ^
	 -density 420 ^
	 -pointsize 5 ^
	 -gravity Northwest ^
	 -geometry +20+44 ^
	 label:"%FolNamShort%" ^
	 ( +clone -background BLACK -shadow 10x5+0.6+0.6 ) +swap -background none -layers merge ^
	 ( +clone -background BLACK -shadow 10x5-0.6-0.6 ) +swap -background none -layers merge ^
	 ( +clone -background BLACK -shadow 10x5-0.6+0.6 ) +swap -background none -layers merge ^
	 ( +clone -background BLACK -shadow 10x5+0.6-0.6 ) +swap -background none -layers merge ^
	 ) -composite

set FOLDER-NAME-LONG-CODE= ^
	 ( ^
	 -font Arial-Bold  ^
	 -fill white ^
	 -density 450 ^
	 -pointsize 3 ^
	 -kerning 2 ^
	 -gravity Northwest ^
	 -geometry -10+80 ^
	 label:"%FolNamLong%" ^
	 ( +clone -background BLACK -shadow 10x5+0.2+0.2 ) +swap -background none -layers merge ^
	 ( +clone -background BLACK -shadow 10x5-0.2-0.2 ) +swap -background none -layers merge ^
	 ( +clone -background BLACK -shadow 10x5-0.2+0.2 ) +swap -background none -layers merge ^
	 ( +clone -background BLACK -shadow 10x5+0.2-0.2 ) +swap -background none -layers merge ^
	 ) -composite
if %FolNamShortCount% LEQ %FolNamShortLimit% set "FOLDER-NAME-LONG-CODE="
if defined Logo-IMAGE-CODE set "FOLDER-NAME-LONG-CODE=" &set "FOLDER-NAME-SHORT-CODE="
	 
:LAYER-TOP-POSTER-SHADOW
set POSTER-TOP-SHADOW-CODE= ( "%folderhorizontal-TOPshadow%" -scale 512x512! ) -compose over -composite


:LAYER-POSTER-MAIN
set POSTER-MAIN-CODE= ( ^
	 "%inputfile%" ^
	 -scale 495x307! ^
	 -gravity Northwest ^
	 -geometry +8+141 ^
	 "%folderhorizontal-main%" ) -compose over -composite ^
	 ( "%folderhorizontal-mainfx%" -scale 512x512! ) -compose over -composite




::      Template Command
::===================================
:EXECUTE-TEMPLATE
 "%Converter%" ^
  %BACKGROUND-CODE% ^
  %POSTER-TOP-CODE% ^
  %FOLDER-NAME-SHORT-CODE% ^
  %FOLDER-NAME-LONG-CODE% ^
  %Logo-IMAGE-CODE% ^
  %DISC-IMAGE-CODE% ^
  %CLEARART-IMAGE-CODE% ^
  %POSTER-TOP-SHADOW-CODE% ^
  %POSTER-MAIN-CODE% ^
  %STAR-IMAGE-CODE% ^
  %RATING-CODE% ^
  %GENRE-CODE% ^
  -scale 256x256! ^
 "%outputfile%"
endlocal