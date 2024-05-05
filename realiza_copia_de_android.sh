#!/bin/bash

# Direcciones IP y parámetros
IP_DESTINO="192.168.99.102"
PUERTO_SSH="8022"
UNIDAD_ORIGEN="/data/data/com.termux/files/home/storage/shared/Pictures"
UNIDAD_DESTINO="/mnt/unidadProyecto/"
ESPACIO="fotosAndroid"

# Inicia la unidad
./inicia_unidad.sh 

# Verifica si la unidad de destino está montao

# Llama al script de verificación
./verificaMontajeYCarpeta.sh  "$ESPACIO"   #El script ya tiene la carpeta destino que tiene que ser el mismo.
resultado=$?

# Verifica el resultado del script de verificación
if [ $resultado -eq 0 ]; then
    echo "Verificación exitosa, procediendo con rsync..."

    # Ejecuta el comando rsync
#     rsync -vr -e "ssh -p $PUERTO_SSH" $IP_DESTINO:$UNIDAD_ORIGEN/  $UNIDAD_DESTINO$ESPACIO
     rsync -vr -e "ssh -p $PUERTO_SSH" $IP_DESTINO:$UNIDAD_ORIGEN/ "$UNIDAD_DESTINO$ESPACIO"
else
    echo "Error en la verificación: Código $resultado"
fi
# Finaliza la unidad
./finaliza_unidad.sh 
