@echo off
:: Script per aggiornare Windows, i driver, pulire il disco, ottimizzare la RAM, deframmentare il disco, tweak di sistema e altro

::Carica la tabella caratteri corretta
chcp 65001

:: Verifica dei privilegi di amministratore
NET FILE > NUL 2>&1
if '%errorlevel%' == '0' (
    echo Eseguendo come amministratore... OK
) else (
	color 4
    echo AVVISO: Questo script richiede diritti di amministratore.
    echo Apri il prompt come amministratore e riprova.
    pause
    exit
)
:: Impostazione colori per gli effetti grafici
color 0A
cls

:: Effetto grafico iniziale
echo -----------------------------------------------------------
echo           Benvenuto nello script di manutenzione
echo -----------------------------------------------------------
timeout /T 2 >nul
cls

:: Menu principale
:menu
color 0A
cls
echo -----------------------------------------------------------
echo Opzioni Disponibili:
echo 0  - Crea un punto di ripristino 
echo 1  - Aggiorna programmi con Winget
echo 2  - Aggiorna programmi con Winget (inclusi sconosciuti)
echo 3  - Aggiorna Driver
echo 4  - Aggiorna Sistema Operativo (Windows Update)
echo 5  - Pulizia del disco
echo 6  - Controlla e ripara il sistema (SFC e DISM)
echo 7  - Ottimizza la RAM
echo 8  - Deframmenta o ottimizza il disco (HDD/SSD)
echo 9  - Tweak di sistema (ottimizzazione prestazioni, memoria, rete)
echo 10 - Blocca permanentemente un sito web
echo 11 - Gestione Periferiche
echo 12 - Gestione Disco
echo 13 - 
echo 14 - Riavvia il sistema
echo 15 - Visualizza aiuto di Winget
echo 16 - Uscita
echo -----------------------------------------------------------
set /p scelta=Seleziona un'opzione [0-16] e premi invio: 

:: Seleziona l'opzione del menu
if "%scelta%"=="0" goto PuntoRipristino
if "%scelta%"=="1" goto Winget
if "%scelta%"=="2" goto Winget_include_unknown
if "%scelta%"=="3" goto update_drivers
if "%scelta%"=="4" goto update_windows
if "%scelta%"=="5" goto pulizia
if "%scelta%"=="6" goto salute
if "%scelta%"=="7" goto RAM
if "%scelta%"=="8" goto deframmenta
if "%scelta%"=="9" goto tweak_sistema
if "%scelta%"=="10" goto bloccaSito
if "%scelta%"=="11" goto gestionePC
if "%scelta%"=="12" goto gestioneDisco
if "%scelta%"=="13" goto attivazione
if "%scelta%"=="14" goto riavvio
if "%scelta%"=="15" goto help
if "%scelta%"=="16" goto end

:: Se l'input non è valido
echo Opzione non valida. Riprova.
timeout /T 3 >nul
goto menu

:: Esegue il comando PowerShell per creare il punto di ripristino
:PuntoRipristino
color 6
cls
echo -----------------------------------------------------------
echo Creazione di un punto di ripristino del sistema
echo -----------------------------------------------------------

:: Verifica se è stato creato un punto di ripristino nelle ultime 24 ore
for /f "tokens=*" %%a in ('powershell -Command "Get-ComputerRestorePoint | Where-Object { $_.CreationTime -gt (Get-Date).AddHours(-24) } | Measure-Object"') do set "restorePoints=%%a"

if "%restorePoints%"=="0" (
cld
echo -----------------------------------------------------------
    echo Non è stato creato un punto di ripristino nelle ultime 24 ore.
    echo Creazione di un nuovo punto di ripristino...
echo -----------------------------------------------------------
    powershell -Command "Checkpoint-Computer -Description 'Punto di ripristino automatico' -RestorePointType MODIFY_SETTINGS"
    if %ERRORLEVEL%==0 (
	cls
	echo -----------------------------------------------------------
        echo Punto di ripristino creato con successo!
	echo -----------------------------------------------------------
    ) else (
		cls
		echo -----------------------------------------------------------
        echo Si e' verificato un errore durante la creazione del punto di ripristino.
		echo -----------------------------------------------------------
    )
) else (
	cls
	echo -----------------------------------------------------------
    echo E' gia' stato creato un punto di ripristino nelle ultime 24 ore.
    echo Nessuna operazione necessaria.
	echo -----------------------------------------------------------
)

timeout /t 5 >nul
goto menu

:: Esegui aggiornamenti con Winget
:Winget
color e
cls
echo -----------------------------------------------------------
echo Eseguendo aggiornamenti con Winget...
echo -----------------------------------------------------------
timeout /T 1 >nul
winget upgrade --all
if %ERRORLEVEL%==0 (
    echo Aggiornamento completato con successo.
) else (
    echo Si è verificato un errore durante l'aggiornamento.
	pause)
timeout /T 3 >nul
goto menu

:: Esegui aggiornamenti con Winget (inclusi sconosciuti)
:Winget_include_unknown
color 3
cls
echo -----------------------------------------------------------
echo Eseguendo aggiornamenti con Winget (inclusi sconosciuti)...
echo -----------------------------------------------------------
timeout /T 1 >nul
winget upgrade --all --include-unknown
if %ERRORLEVEL%==0 (
    echo Aggiornamento completato con successo.
) else (
    echo Si è verificato un errore durante l'aggiornamento.
	pause)
timeout /T 3 >nul
goto menu

:: Aggiorna i driver
:update_drivers
color 1
cls
echo -----------------------------------------------------------
echo Aggiornamento dei driver in corso...
echo -----------------------------------------------------------
timeout /T 1 >nul
:: Esempio di utilizzo di uno strumento di terze parti (modifica il percorso se necessario)
if exist "C:\Program Files (x86)\360\Total Security\Utils\360DrvMgr\DriverUpdater.exe" (
    "C:\Program Files (x86)\360\Total Security\Utils\360DrvMgr\DriverUpdater.exe"
    cls
	echo -----------------------------------------------------------
	echo Aggiornamento driver completato.
	echo -----------------------------------------------------------
) else (
    echo Strumento di aggiornamento driver non trovato.
    echo Installa uno strumento come Driver Booster o Snappy Driver Installer.
)
pause
goto menu

:: Aggiorna il sistema operativo (Windows Update)
:update_windows
color 4
cls
echo -----------------------------------------------------------
echo Aggiornamento del sistema operativo in corso...
echo -----------------------------------------------------------
timeout /T 1 >nul
powershell -Command "Install-Module PSWindowsUpdate -Force -Confirm:$false"
powershell -Command "Get-WindowsUpdate -AcceptAll -Install -AutoReboot"
if %ERRORLEVEL%==0 (
    echo Aggiornamento di Windows completato con successo.
) else (
    echo Si è verificato un errore durante l'aggiornamento di Windows.
	pause)
timeout /T 3 >nul
goto menu

:: Pulizia del disco
:pulizia
color 5
cls
echo -----------------------------------------------------------
echo Pulizia del disco in corso...
echo -----------------------------------------------------------
timeout /T 1 >nul
cleanmgr /sagerun:1
if %ERRORLEVEL%==0 (
    echo Pulizia del disco completata con successo.
) else (
    echo Si è verificato un errore durante la pulizia del disco.
	pause)
timeout /T 3 >nul
goto menu

:: Ottimizzazione della RAM
:RAM
color 6
:: Ottimizzazione della RAM (termina i processi che consumano troppa RAM)
cls
echo -----------------------------------------------------------
echo Ottimizzazione della RAM in corso...
echo -----------------------------------------------------------
timeout /T 1 >nul
powershell -Command "Clear-Host; Get-Process | Where-Object {$_.Handles -gt 5000} | Sort-Object -Property Handles -Descending | Select-Object
timeout /T 3 >nul
goto menu

:: Controlla e ripara il sistema (SFC e DISM)
:salute
color b
cls
echo -----------------------------------------------------------
echo Controllo e riparazione del sistema in corso...
echo -----------------------------------------------------------
echo Esecuzione di SFC (System File Checker)...
sfc /scannow
echo Esecuzione di DISM (Deployment Imaging Service and Management Tool)...
dism /online /cleanup-image /restorehealth
if %ERRORLEVEL%==0 (
    echo Controllo e riparazione del sistema completati con successo.
) else (
    echo Si è verificato un errore durante il controllo o la riparazione del sistema.
	pause)
timeout /T 3 >nul
goto menu

:: Deframmenta o ottimizza il disco (HDD/SSD)
:deframmenta
color c
cls
echo -----------------------------------------------------------
echo Elenco delle unità' disponibili:
echo -----------------------------------------------------------
powershell -Command "Get-Volume | Where-Object { $_.DriveType -eq 'Fixed' } | Format-Table DriveLetter, FileSystemLabel, SizeRemaining, Size, @{Name='Tipo';Expression={if ((Get-PhysicalDisk -DeviceNumber $_.DriveLetter[0]).MediaType -eq 'HDD') {'HDD'} else {'SSD'}}}"
echo -----------------------------------------------------------
set /p driveLetter=Inserisci la lettera dell'unità' da deframmentare/ottimizzare (es. C): 

:: Verifica se l'unità' esiste
powershell -Command "$drive = Get-Volume -DriveLetter %driveLetter% -ErrorAction SilentlyContinue; if (-not $drive) { exit 1 }"
if %ERRORLEVEL%==1 (
    echo L'unita' %driveLetter% non esiste. Riprova.
    pause
    goto deframmenta
)

:: Verifica se l'unità' è un HDD o un SSD
powershell -Command "$driveType = (Get-PhysicalDisk -DeviceNumber (Get-Volume -DriveLetter %driveLetter%).DriveLetter[0]).MediaType; if ($driveType -eq 'HDD') { defrag %driveLetter%: /U /V; Write-Output 'Deframmentazione completata per HDD.' } else { Optimize-Volume -DriveLetter %driveLetter% -ReTrim -Verbose; Write-Output 'Ottimizzazione completata per SSD.' }"
if %ERRORLEVEL%==0 (
    echo Operazione completata con successo.
) else (
    echo Si è verificato un errore durante l'operazione.
	pause
)
timeout /T 3 >nul
goto menu

:: Tweak di sistema (ottimizzazione prestazioni, memoria, rete)
:tweak_sistema
color d
cls
echo -----------------------------------------------------------
echo Applicazione tweak di sistema...
echo -----------------------------------------------------------
timeout /T 1 >nul

:: Ottimizzazione delle prestazioni
echo Ottimizzazione delle prestazioni...
powercfg /h off >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f >nul

:: Disabilitazione servizi non critici
echo Disabilitazione servizi non critici...
sc config "SysMain" start= disabled >nul
sc stop "SysMain" >nul
sc config "DiagTrack" start= disabled >nul
sc stop "DiagTrack" >nul

:: Ottimizzazione memoria virtuale
echo Ottimizzazione memoria virtuale...
wmic computersystem where name="%COMPUTERNAME%" set AutomaticManagedPagefile=False >nul
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=8192 >nul

:: Ottimizzazione di rete
echo Ottimizzazione di rete...
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global rss=enabled >nul

echo Tweak di sistema applicati con successo.
timeout /T 5 >nul
goto menu

:gestionePC
color 6
cls
echo -----------------------------------------------------------
echo Gestione periferiche del PC...
echo -----------------------------------------------------------
timeout /T 1 >nul
start devmgmt.msc
timeout /T 3 >nul
goto menu

:gestioneDisco
color 6
cls
echo -----------------------------------------------------------
echo Gestione dei dischi del PC...
echo -----------------------------------------------------------
timeout /T 1 >nul
start diskmgmt.msc
timeout /T 3 >nul
goto menu


:: Riavvia il sistema
:riavvio
color e
cls
echo -----------------------------------------------------------
echo Riavvio del sistema in corso...
echo -----------------------------------------------------------
timeout /T 1 >nul
shutdown /r /t 0
goto end

::Attivazione di Windows 10/11 e Office
:attivazione
color b
cls
echo -----------------------------------------------------------
echo 
echo -----------------------------------------------------------

goto menu


:: Blocca l'accesso a un sito specifico, indirizzandolo a 127.0.0.1 nel file HOSTS
:bloccaSito
color a
cls
echo -----------------------------------------------------------
echo Blocco di un sito web modificando il file hosts
echo -----------------------------------------------------------
setlocal enabledelayedexpansion

:: Imposta automaticamente l'IP a 127.0.0.1
set ip=127.0.0.1

:: Richiede l'url del sito da bloccare
set /p hostname="Inserisci il nome del sito (es. www.esempio.com): "

:: Percorso del file hosts
set hostspath=%SystemRoot%\System32\drivers\etc\hosts

:: Controlla se il sito è già presente
findstr /i /c:"%hostname%" "%hostspath%" >nul
if %errorlevel% equ 0 (
	cls
	echo ----------------------------------------------------------------
    echo Il sito %hostname% e' gia' presente nel file hosts.
	echo ----------------------------------------------------------------
    timeout /T 2 >nul
    goto menu
)

:: Aggiunta della voce al file hosts
echo %ip% %hostname% >> "%hostspath%"
cls
echo -------------------------------------------------------------------
echo Il sito %hostname% e' stato aggiunto con successo con l'IP %ip%!
echo -------------------------------------------------------------------
timeout /T 3 >nul
goto menu

:: Mostra l'aiuto di Winget
:help
color 9
cls
echo -----------------------------------------------------------
echo Visualizzando l'aiuto di Winget...
echo -----------------------------------------------------------
timeout /T 1 >nul
winget -?
pause
goto menu

:: Fine dell'esecuzione
:end
color a
cls
echo -----------------------------------------------------------
echo Uscita dallo script. Arrivederci!
echo -----------------------------------------------------------
timeout /T 3 >nul
exit
