#!/bin/bash

# Verifica que se haya proporcionado la IP del dispositivo como parámetro
# La IP del dispositivo se pasa como primer argumento del script
#IP_DISPOSITIVO="192.168.99.11"
#UNIDADTRABAJO="/scripts/"

IP_DISPOSITIVO="192.168.12.94"
UNIDADTRABAJO="/scripts/proyecto"

cd $UNIDADTRABAJO

# Desmonta la unidad cifrada
sudo umount /mnt/unidadProyecto/
if [ $? -ne 0 ]; then
    echo "Error al desmontar unidadProyecto"
    exit 1
else
    echo "unidadProyecto desmontada con éxito"
fi

# Cierra el mapeo del dispositivo cifrado
sudo cryptsetup close cifrada
if [ $? -ne 0 ]; then
    echo "Error al cerrar el dispositivo cifrado"
    exit 1
else
    echo "Dispositivo cifrado cerrado con éxito"
fi

#Instrucción de apagado del enchufe electrónico
./hs100/hs100.sh off -i $IP_DISPOSITIVO
