@echo on
REM Definiciones
set usuarioB=carraixet
set direccionB=192.168.12.20
set rutaLocal=C:\Users\miwin\Documents\backup
set rutaDestinoWSL=/mnt/unidadProyecto/backup
set usuario_local=miwin



cd C:\

REM Convierte la ruta de Windows a una ruta de estilo Unix
set rutaWSL=%rutaLocal:\=/%

REM Se utiliza WSL para transferir la carpeta cifrada
wsl rsync -avz /mnt/c/Users/%usuario_local%/Documents/backup %usuarioB%@%direccionB%:%rutaDestinoWSL%
