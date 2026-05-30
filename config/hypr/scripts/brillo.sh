#!/bin/bash

brillo_minimo=2

# Validar argumentos
if [[ $# -ne 2 || ! "$2" =~ ^[0-9]+$ ]]; then
    echo "Uso: $0 [up|down] [valor]"
    exit 1
fi

case "$1" in
    up)
        brightnessctl set "$2"%+
        ;;
    down)
        current=$(brightnessctl g)
        max=$(brightnessctl m)
        current_percent=$((current * 100 / max))
        nuevo_brillo=$((current_percent - $2))
        
        if (( nuevo_brillo < brillo_minimo )); then
            brightnessctl set "${brillo_minimo}%"
        else
            brightnessctl set "$2"%-
        fi
        ;;
    *)
        echo "Dirección inválida. Usa 'up' o 'down'."
        exit 1
        ;;
esac
