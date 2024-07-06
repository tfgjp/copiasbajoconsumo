#!/bin/bash

# Dirección IP de la Raspberry.
IP_RASPBERRY="192.168.99.102"

# Usuario en la Raspberry
prefijo="nuevouser/"
USUARIO="nuevouser"


# Ruta local a respaldar
RUTA_LOCAL="/home/estudio/Escritorio/otroUser"
# Espacio en la Raspberry Pi donde se almacenará el respaldo
ESPACIO="backupProyecto"



# Archivo de log
LOG_FILE="logfile.log"

# Redirige stdout y stderr al archivo de log
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Inicio del script: $(date)"

# Ejecuta inicia_unidad.sh en la Raspberry Pi
ssh ${USUARIO}@${IP_RASPBERRY} " /scripts/inicia_unidad.sh"
if [ $? -ne 0 ]; then
    echo "Error al iniciar la unidad en la Raspberry Pi."
    exit 1
fi

# Ejecuta verificaMontajeYCarpeta.sh en la Raspberry Pi
ssh ${USUARIO}@${IP_RASPBERRY} " /scripts/verificaMontajeYCarpeta.sh ${ESPACIO}"
if [ $? -ne 0 ]; then
    echo "Error al verificar montaje y carpeta en la Raspberry Pi."
    exit 1
fi

# Ejecuta rsync para hacer el respaldo en la Raspberry Pi
 rsync -avr --progress ${RUTA_LOCAL} ${USUARIO}@${IP_RASPBERRY}:/mnt/unidadProyecto/${ESPACIO}/  > resultado
resultado=$(cat resultado)
cat resultado


if [ $? -ne 0 ]; then
    echo "Error al realizar el respaldo con rsync."
    exit 1
fi

# Ejecuta finaliza_unidad.sh en la Raspberry Pi
ssh ${USUARIO}@${IP_RASPBERRY} " /scripts/finaliza_unidad.sh"
if [ $? -ne 0 ]; then
    echo "Error al finalizar la unidad montada en la Raspberry Pi."
    exit 1
fi

echo "Fin del script: $(date)"
