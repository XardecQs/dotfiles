#!/bin/bash

# Definir las rutas de las carpetas
original_dir="/home/xardec/.icons/KoraCustom/places/originals"
symbolic_dir="/home/xardec/.icons/KoraCustom/places/scalable"

# Recorrer todos los archivos .svg en la carpeta original
for file in "$original_dir"/*.svg; do
  # Obtener solo el nombre del archivo (sin la ruta completa)
  filename=$(basename "$file")
  
  # Crear el enlace simbólico en la carpeta symbolic
  ln -sf "$original_dir/$filename" "$symbolic_dir/$filename"
done

echo "Enlaces simbólicos creados correctamente en $symbolic_dir"