#!/bin/bash

# Script para Android
# Dirección IP de la Raspberry
IP_RASPBERRY="192.168.99.102"
# Usuario en la Raspberry 
USUARIO="project"
# Ruta local a respaldar
RUTA_LOCAL="/data/data/com.termux/files/home/storage/shared/Pictures"
# Espacio en la Raspberry donde se almacenará el respaldo
ESPACIO="AndroidDesdeMovil"

# Ejecuta inicia_unidad.sh en la Raspberry 
ssh ${USUARIO}@${IP_RASPBERRY} 'bash /scripts/inicia_unidad.sh'
if [ $? -ne 0 ]; then
    echo "Error al iniciar la unidad en la Raspberry Pi."
    exit 1
fi

# Ejecuta verificaMontajeYCarpeta.sh en la Raspberry Pi
ssh ${USUARIO}@${IP_RASPBERRY} "bash /scripts/verificaMontajeYCarpeta.sh ${ESPACIO}"
if [ $? -ne 0 ]; then
    echo "Error al verificar montaje y carpeta en la Raspberry Pi."
    exit 1
fi

# Ejecuta rsync para hacer el respaldo en la Raspberry Pi
rsync -avr --progress ${RUTA_LOCAL} ${USUARIO}@${IP_RASPBERRY}:/mnt/unidadProyecto/${ESPACIO}/
if [ $? -ne 0 ]; then
    echo "Error al realizar el respaldo con rsync."
    exit 1
fi

# Ejecuta finaliza_unidad.sh en la Raspberry 
ssh ${USUARIO}@${IP_RASPBERRY} 'bash /scripts/finaliza_unidad.sh'
if [ $? -ne 0 ]; then
    echo "Error al finalizar la unidad en la Raspberry Pi."
    exit 1
fi
