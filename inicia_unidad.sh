#!/bin/bash
# Parámetros
IP_DISPOSITIVO="192.168.99.11"
UNIDAD="/dev/sda"
UNIDADTRABAJO="/scripts/"

cd $UNIDADTRABAJO
# Enciende el dispositivo y espera porque tiene tarda unos segundos en funcionar.
./hs100/hs100.sh on -i $IP_DISPOSITIVO
sleep 10s

# Intenta montar la unidad y verifica si el montaje fue ok
if grep /mnt/unidadCifrada /proc/mounts > /dev/null 2>&1; then
    echo "unidadCifrada montada ....OK"
else
    echo "Montando unidadCifrada..."
    sudo cat llave.key | sudo cryptsetup open --type luks $UNIDAD cifrada
    sudo mount /dev/mapper/cifrada /mnt/unidadProyecto/
    echo "unidadCifra montada"

    # Verifica nuevamente si la unidad está montada
    if grep /mnt/unidadProyecto /proc/mounts > /dev/null 2>&1; then
        echo "unidadCifra montada con éxito"
    else
        echo "Error: Fallo al montar unidadCifrada"
        exit 1
    fi
fi
