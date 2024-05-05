#!/bin/bash

# Argumentos: unidad de destino y espacio
UNIDAD_DESTINO="/mnt/unidadProyecto/"
ESPACIO=$1

# Verifica si la unidad de destino está montada
if mountpoint -q "$UNIDAD_DESTINO" ; then
    echo "Unidad de destino montada."

    # Verifica si existe la carpeta ESPACIO
    CARPETA_DESTINO="$UNIDAD_DESTINO$ESPACIO"
    if [ ! -d "$CARPETA_DESTINO" ]; then
        echo "Carpeta $ESPACIO no existe en la unidad de destino. Creando carpeta..."
        mkdir -p "$CARPETA_DESTINO"
    fi
else
    echo "Error: La unidad de destino no está montada."
    exit 1 # Devuelve código de error 1
fi

exit 0 # Todo está bien, devuelve 0
