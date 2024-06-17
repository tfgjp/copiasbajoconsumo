#!/bin/bash

#Parametrización:
# La IP del dispositivo enchufe
#IP_DISPOSITIVO="192.168.99.11"


IP_DISPOSITIVO="192.168.12.94"


cd ~

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

#Instrucción de apagado del enchufe smart
./hs100/hs100.sh off -i $IP_DISPOSITIVO
