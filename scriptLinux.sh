#!/bin/bash

# Dirección IP de la Raspberry.
IP_RASPBERRY="192.168.99.101"

# Usuario en la Raspberry
USUARIO="project"


# Ruta local a respaldar
RUTA_LOCAL="/mnt/sambito/unidadw/Estudio/Proyecto"
# Espacio en la Raspberry Pi donde se almacenará el respaldo
ESPACIO="backupProyecto"
prefijo="proyecto/"

# Ejecuta inicia_unidad.sh en la Raspberry Pi
ssh ${USUARIO}@${IP_RASPBERRY} " /scripts/${prefijo}inicia_unidad.sh"
if [ $? -ne 0 ]; then
    echo "Error al iniciar la unidad en la Raspberry Pi."
    exit 1
fi

# Ejecuta verificaMontajeYCarpeta.sh en la Raspberry Pi
ssh ${USUARIO}@${IP_RASPBERRY} " /scripts/${prefijo}verificaMontajeYCarpeta.sh ${ESPACIO}"
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
ssh ${USUARIO}@${IP_RASPBERRY} " /scripts/${prefijo}finaliza_unidad.sh"
if [ $? -ne 0 ]; then
    echo "Error al finalizar la unidad montada en la Raspberry Pi."
    exit 1
fi
