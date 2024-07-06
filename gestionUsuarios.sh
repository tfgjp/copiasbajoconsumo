#!/bin/bash


unidad_destino="${1:-mnt/unidadProyecto}"  
usuario="${2:-}"  

# Función para verificar si la unidad está montada
check_mount() {
    if [ -z "$usuario" ]; then
        # Verificar solo la unidad si el nombre de usuario está vacío
        if mountpoint -q "/$unidad_destino"; then
            echo "La unidad $unidad_destino está montada."
        else
            echo "Error: la unidad $unidad_destino no está montada."
            exit 1
        fi
    else
        # Verificar la unidad y el punto de montaje del usuario si se proporciona el nombre de usuario
        punto_montaje="$unidad_destino/$usuario"
        if mountpoint -q "/$punto_montaje"; then
            echo "La unidad $unidad_destino está montada en /$punto_montaje."
        else
            echo "Error: la unidad $unidad_destino no está montada en /$punto_montaje."
            exit 1
        fi
    fi
}

# Función para crear   usuario
create_user() {
    check_mount
    
    while true; do
        read -p "Ingrese el nombre del nuevo usuario (mínimo 5 caracteres): " username
        if [[ ${#username} -lt 5 ]]; then
            echo "El nombre de usuario debe tener al menos 5 caracteres."
        elif id "$username" &>/dev/null; then
            echo "El usuario $username ya existe. Por favor, elija otro nombre."
        else
            break
        fi
    done

    while true; do
        read -s -p "Ingrese la contraseña: " password1
        echo
        read -s -p "Confirme la contraseña: " password2
        echo
        if [ "$password1" != "$password2" ]; then
            echo "Las contraseñas no coinciden. Inténtelo de nuevo."
        else
            break
        fi
    done
    
    sudo useradd -m -s /bin/bash -G copiaseg "$username"
    echo "$username:$password1" | sudo chpasswd

    project_dir="${unidad_destino}/${username}"
    if [ -d "$project_dir" ]; then
        echo "La carpeta $project_dir ya existe. Inténtelo de nuevo."
        exit 1
    else
        echo "Creo el espacio $project_dir"
	sudo mkdir -p "$project_dir"
        sudo chown "$username:copiaseg" "$project_dir"
        sudo chmod 700 "$project_dir"

        sudo -u "$username" ssh-keygen -t rsa -N '' -f /home/"$username"/.ssh/id_rsa

        echo "Las claves se han generado en /home/$username/.ssh/"
        echo "Clave pública:"
        sudo cat /home/"$username"/.ssh/id_rsa.pub
	sudo cp /home/"$username"/.ssh/id_rsa.pub  /home/"$username"/.ssh/authorized_keys
	sudo chown $username  /home/"$username"/.ssh/authorized_keys
        echo "Clave privada:"
        sudo cat /home/"$username"/.ssh/id_rsa
	echo "Operación realizada correctamente."
	echo "Copie su clave púbica y privada en el usuario remoto"
	echo "recuerde copiarla con los permisos 600 en la carpeta .ssh de su usuario"
	echo "Personalice el script de envio de datos para que realice la copia de seguridad "
	echo "en la siguiente direcci�ón $project_dir , donde se le han asignado permisos"
	echo ""
    fi
}

# Función para borrar usuario
delete_user() {
    check_mount
    
    read -p "Ingrese el nombre del usuario a borrar: " username
    if id "$username" &>/dev/null; then
        sudo userdel -r "$username"
	
        project_dir="$unidad_destino/$username"
        if [ -d "$project_dir" ]; then
            sudo rm -rf "$project_dir"
        fi
        echo "El usuario $username y su carpeta de proyecto han sido eliminados."
    else
        echo "El usuario $username no existe."
    fi
}

echo "Seleccione una opción:"
echo "1. Crear un usuario"
echo "2. Borrar un usuario"
read -p "Opción: " option

case $option in
    1)
        create_user
        ;;  # Fin del bloque de código para la opción 1
    2)
        delete_user
        ;;  # Fin del bloque de código para la opción 2
    *)
        echo "Opción no válida."
        ;;  # Fin del bloque de código para cualquier otra opción no válida
esac
