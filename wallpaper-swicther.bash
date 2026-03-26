#!/bin/bash

export DISPLAY=:0
export XAUTHORITY=/home/user/.Xauthority

LOG_FILE="/home/user/scripts/wallpaper-switcher.log"

HOUR=$(date +"%H")

if [ "$HOUR" -ge 6 ] && [ "$HOUR" -lt 18 ]; then
    WALLPAPER="/home/user/Pictures/Wallpapers/morning.jpg"
else
    WALLPAPER="/home/user/Pictures/Wallpapers/night.jpg"
fi

# Fungsi untuk log + notif
log_and_notify() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
    notify-send "Wallpaper Switcher" "$message"
}

# Path untuk dummy black wallpaper
BLACK_WALLPAPER="/home/user/Pictures/Wallpapers/black.jpg"

# Kalau belum ada black.jpg, buat otomatis
if [ ! -f "$BLACK_WALLPAPER" ]; then
    convert -size 1920x1080 xc:black "$BLACK_WALLPAPER"
fi

# Fungsi untuk ganti wallpaper dengan transisi
change_wallpaper_with_fade() {
    local target="$1"
    
    # Step 1: ganti ke hitam
    plasma-apply-wallpaperimage "$BLACK_WALLPAPER"
    sleep 0.5
    
    # Step 2: ganti ke wallpaper target
    plasma-apply-wallpaperimage "$target"
}

# Main
if [ -f "$WALLPAPER" ]; then
    if change_wallpaper_with_fade "$WALLPAPER"; then
        log_and_notify "Wallpaper berhasil diganti ke: $WALLPAPER (dengan transisi)"
    else
        log_and_notify "Gagal mengganti wallpaper!"
    fi
else
    log_and_notify "Wallpaper file tidak ditemukan: $WALLPAPER"
fi
