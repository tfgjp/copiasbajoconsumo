REM Definiciones
set USUARIO=project
set IP_RASPBERRY=192.168.99.102
set RUTA_LOCAL=/mnt/c/Users/miwin/Desktop/backup
set RUTA_DESTINO=/mnt/unidadProyecto/backup
set PREFIJO= # En este caso a nulo.
set ESPACIO="proyectodesdewin"

echo Cargando WSL...
wsl echo WSL Cargado
REM Convertir la ruta de Windows a una ruta de estilo GNU-Linux
set RUTA_WSL=%RUTA_LOCAL:/=//%
echo Iniciando conexión en Raspberry.
:: Ejecuta inicia_unidad.sh en la Raspberry Pi
wsl ssh %USUARIO%@%IP_RASPBERRY% " /scripts/inicia_unidad.sh"
IF %ERRORLEVEL% NEQ 0 (
    echo Error al iniciar la unidad en la Raspberry Pi.
    exit /b 1
)

echo Conectando con la unidad Raspberry....
:: Ejecuta verificaMontajeYCarpeta.sh en la Raspberry Pi
wsl ssh %USUARIO%@%IP_RASPBERRY% " /scripts/verificaMontajeYCarpeta.sh %ESPACIO%"
IF %ERRORLEVEL% NEQ 0 (
    echo Error al verificar montaje y carpeta en la Raspberry Pi.
    exit /b 1
)

echo Se procede a ejecutar copia de seguridad...
::Realiza la copia de seguridad mediante wsl + rsync
wsl rsync -avz  %USUARIO%@%IP_RASPBERRY%:%RUTA_DESTINO%/%ESPACIO% %RUTA_WSL% 

:: Ejecuta finaliza_unidad.sh en la Raspberry Pi
echo Se procede a apagar la unidad USB.
wsl ssh %USUARIO%@%IP_RASPBERRY% " /scripts/finaliza_unidad.sh"
IF %ERRORLEVEL% NEQ 0 (
    echo Error al finalizar la unidad en la Raspberry Pi.
    exit /b 1
)
echo Finalizado el proceso. Presione cualquier tecla para finalizar.
pause
