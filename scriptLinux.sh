#!/bin/bash

# Dirección IP de la Raspberry.
#IP_RASPBERRY="192.168.99.101"
IP_RASPBERRY="192.168.12.20"

# Usuario en la Raspberry
#USUARIO="project"
USUARIO="carraixet"

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


#PREPRODUCCIÓN
#if ping -c 1 ${IP_RASPBERRY} &> /dev/null
#then  #Envía el resultado por telegram, para la raspberry de prueba
#	cat resultado  | ssh ${USUARIO}@${IP_RASPBERRY} "sudo telegram-send 'Se ha realizado la copia de seguridad con los siguientes datos:' 'Fecha y hora:'$(date) '$resultado'"
# 	echo "Hay conexión a la unidad para enviar mensaje. Se envía mensaje"
#else
#  echo "No hay conexión a la unidad de envío de mensajes. No se envía mensaje telemático"
#fi

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
