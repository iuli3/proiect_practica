#!/bin/bash


show_menu() {
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "  Meniu Transfer Fisiere cu SCP"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "1. Copiaza de la Guest la Host"
    echo "2. Copiaza de la Host la Guest"
    echo "3. Iesire"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}

copy_from_guest_to_host() {
    echo "GUEST -> HOST"
    read -p "Calea catre fisier/director Guest: " guest_path
    read -p "Calea catre directorul local pe Host: " local_path

    ssh "$guest_user@$guest_address" "[ -e \"$guest_path\" ]"
    if [ $? -ne 0 ]; then
        echo "Eroare: Calea guest specificată nu există pe mașina remote!"
        return
    fi

    echo "Local path: $local_path"
    echo "Guest path: $guest_path"
    scp "$guest_user@$guest_address:$guest_path" "$local_path"
    echo "Copiere finalizata."
}


copy_from_host_to_guest() {
    echo "HOST -> GUEST"
    read -p "Calea catre fisier/director local pe Host: " local_path
    read -p "Calea catre directorul remote pe Guest: " guest_path

    ssh "$guest_user@$guest_address" "[ -e \"$guest_path\" ]"
    if [ $? -ne 0 ]; then
        echo "Eroare: Calea guest specificată nu există pe mașina remote!"
        return
    fi
    
    if [ ! -e "$local_path" ]; then
        echo "Eroare: Calea locală specificată nu există pe mașina locală!"
        return
    fi
    
    echo "Local path: $local_path"
    echo "Guest path: $guest_path"

    scp "$local_path" "$guest_user@$guest_address:$guest_path"
    
    if [ $? -eq 0 ]; then
        echo "Copiere finalizată."
    else
        echo "Eroare în timpul copierii."
    fi
}

while true; do
    show_menu
    read -p "Introduceti optiunea dorita: " option
    case $option in
        1) copy_from_guest_to_host ;;
        2) copy_from_host_to_guest ;;
        3) exit 0 ;;
        *) echo "Optiune invalida!"; sleep 1 ;;
    esac
    echo
done