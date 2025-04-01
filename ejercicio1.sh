#!/bin/bash

#verificar si es root
if [ "$EUID" -ne 0 ]; then
	echo "Error: no esta ejecutando el script con root"
	exit 1
else 
	echo "Script ejecutado con usuario root"
fi

#recibimiento de parametros
if [ "$#" -ne 3 ]; then
	echo "Parametros necesario: $0 <usuario> <grupo> <ruta_archivo>" >&2
	exit 1
fi

#parametros a variables locales
usuario=$1
grupo=$2
archivo=$3

#Ver si el archivo existe
if [ ! -e "$archivo" ]; then
	echo "Error: EL archivo '$archivo' no existe"
	exit 1
fi 

#ver si el grupo existen, sino crearlo
if getent group "$grupo" > /dev/null 2>&1; then
	echo "El grupo '$grupo' ya existe"
else
	echo "EL grupo '$grupo' no existe. Creando grupo..."
       	groupadd "$grupo"
	exit 1
fi

# Creacion del usuario si no existe
if id "$usuario" > /dev/null 2>&1; then
	echo "Usuario $usuario existente. Agregando a grupo '$grupo'"
	usermod -aG "$grupo" "$usuario"
else 
	echo "Usuario no existente"
echo "Creando usuario '$usuario'..."
echo "Agregando usuario a $grupo"
useradd -m -g "$grupo" "$usuario"
fi 


#Modificacion de pertenencia
chown "$usuario":"$grupo" "$archivo"
echo "Ahora el archivo: $(basename "$archivo") pertenece al usuario: $usuario y al grupo: $grupo"

#Modificacion de permisos
chmod 740 "$archivo"
echo se han cambiado los permisos del archivo a: $(ls -l "$archivo")
