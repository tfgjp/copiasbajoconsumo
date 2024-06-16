#!/bin/bash

# Función para verificar si sdb1 está montada en /proyecto
check_mount() {
    if mountpoint -q /sdb1/proyecto; then
        echo "La unidad sdb1 está montada en /proyecto."
    else
        echo "Error: la unidad sdb1 no está montada en /proyecto."
        exit 1
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

    project_dir="/sdb1/proyecto/$username"
    if [ -d "$project_dir" ]; then
        echo "La carpeta $project_dir ya existe. Inténtelo de nuevo."
        exit 1
    else
        sudo mkdir -p "$project_dir"
        sudo chown "$username:copiaseg" "$project_dir"
        sudo chmod 700 "$project_dir"

        sudo -u "$username" ssh-keygen -t rsa -N '' -f /home/"$username"/.ssh/id_rsa

        echo "Las claves se han generado en /home/$username/.ssh/"
        echo "Clave pública:"
        sudo cat /home/"$username"/.ssh/id_rsa.pub
        echo "Clave privada:"
        sudo cat /home/"$username"/.ssh/id_rsa
    fi
}

# Función para borrar usuario
delete_user() {
    check_mount

    read -p "Ingrese el nombre del usuario a borrar: " username
    if id "$username" &>/dev/null; then
        sudo userdel -r "$username"
        project_dir="/sdb1/proyecto/$username"
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
