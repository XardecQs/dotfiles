#!/usr/bin/env bash

# Configurar entorno DBUS para notificaciones
export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus

# Configuración
MAX_VOL=1.5  # 150% (límite de wpctl)
SINK="@DEFAULT_AUDIO_SINK@"
SOURCE="@DEFAULT_AUDIO_SOURCE@"
ICON_SOUND="audio-volume-high"
ICON_MUTED="audio-volume-muted"
ICON_MIC="microphone-sensitivity-high"
ICON_MIC_MUTED="microphone-sensitivity-muted"

# Opciones por defecto
NOTIFY=1
INFO=0

# Procesar argumentos para opciones globales
args=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--no-notify)
            NOTIFY=0
            shift
            ;;
        -i|--info)
            INFO=1
            shift
            ;;
        *)
            args+=("$1")
            shift
            ;;
    esac
done

# Actualizar parámetros posicionales
set -- "${args[@]}"

# Mostrar información si se solicita
if [[ $INFO -eq 1 ]]; then
    status_sink=$(wpctl get-volume $SINK 2>/dev/null)
    vol_sink=$(awk '{print $2 * 100 "%"}' <<< "$status_sink" || echo "N/A")
    muted_sink=$(grep -q "MUTED" <<< "$status_sink" && echo "Sí" || echo "No")

    status_source=$(wpctl get-volume $SOURCE 2>/dev/null)
    muted_source=$(grep -q "MUTED" <<< "$status_source" && echo "Sí" || echo "No")

    max_percent=$(awk "BEGIN {print int($MAX_VOL * 100)}")
    
    echo "Información de Volumen:"
    echo "---------------------------------"
    echo "Dispositivo de Salida:   $SINK"
    echo "Volumen Actual:          $vol_sink"
    echo "Silenciado:              $muted_sink"
    echo "Dispositivo de Entrada:  $SOURCE"
    echo "Micrófono Silenciado:    $muted_source"
    echo "Volumen Máximo:          ${max_percent}%"
    echo "Incremento Predeterminado: 5%"
    exit 0
fi

show_notification() {
    (( NOTIFY == 0 )) && return
    
    local type=$1
    case $type in
        sink)
            local status=$(wpctl get-volume $SINK)
            local muted=$(grep -o MUTED <<< "$status")
            local vol=$(awk '{print $2 * 100 "%"}' <<< "$status")
            
            if [[ "$muted" = "MUTED" ]]; then
                notify-send -i $ICON_MUTED "Sonido Muteado" -h string:x-canonical-private-synchronous:volume
            else
                notify-send -i $ICON_SOUND "Volumen: $vol" -h string:x-canonical-private-synchronous:volume
            fi
            ;;
        source)
            local status=$(wpctl get-volume $SOURCE)
            local muted=$(grep -o MUTED <<< "$status")
            
            if [[ "$muted" = "MUTED" ]]; then
                notify-send -i $ICON_MIC_MUTED "Micrófono Muteado" -h string:x-canonical-private-synchronous:mic
            else
                notify-send -i $ICON_MIC "Micrófono Activo" -h string:x-canonical-private-synchronous:mic
            fi
            ;;
    esac
}

adjust_volume() {
    local direction=$1
    local percent=${2:-5}
    local amount="${percent}%$direction"
    
    wpctl set-volume $SINK $amount --limit $MAX_VOL
    show_notification sink
}

set_volume() {
    local percent=$1
    local max_percent=$(awk "BEGIN {print int($MAX_VOL * 100)}")
    
    if ! [[ "$percent" =~ ^[0-9]+$ ]]; then
        echo "Error: El porcentaje debe ser un número entero (0-${max_percent})"
        exit 1
    fi
    
    local vol=$(awk "BEGIN {print $percent / 100}")
    wpctl set-volume $SINK $vol --limit $MAX_VOL
    show_notification sink
}

toggle_mute() {
    wpctl set-mute $SINK toggle
    show_notification sink
}

toggle_mic_mute() {
    wpctl set-mute $SOURCE toggle
    show_notification source
}

case $1 in
    up)
        adjust_volume "+" $2
        ;;
    down)
        adjust_volume "-" $2
        ;;
    set)
        if [ -z "$2" ]; then
            echo "Error: Se requiere especificar un porcentaje"
            exit 1
        fi
        set_volume "$2"
        ;;
    toggle-mute)
        toggle_mute
        ;;
    toggle-mic-mute)
        toggle_mic_mute
        ;;
    *)
        max_percent=$(awk "BEGIN {print int($MAX_VOL * 100)}")
        echo "Uso: $0 [opciones] [comando] [parámetros]"
        echo "Comandos:"
        echo "  up [porcentaje]      Sube el volumen (default 5%)"
        echo "  down [porcentaje]    Baja el volumen (default 5%)"
        echo "  set <0-${max_percent}>    Establece volumen al porcentaje indicado"
        echo "  toggle-mute          Alternar mute del sonido"
        echo "  toggle-mic-mute      Alternar mute del micrófono"
        echo "Opciones:"
        echo "  -n, --no-notify      No enviar notificaciones"
        echo "  -i, --info           Mostrar información de configuración"
        echo "Ejemplos:"
        echo "  $0 -n up 10         # Sube 10% sin notificación"
        echo "  $0 set 75           # Establece volumen al 75%"
        echo "  $0 --info           # Muestra información y sale"
        exit 1
        ;;
esac