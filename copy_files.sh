#!/bin/bash

green='\033[0;32m'
red='\033[1;91m'
NC='\033[0m'

show_menu() {
    echo -e "${green}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${green}Meniu Transfer Fisiere cu SCP${NC}"
    echo -e  "${green}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${green}1. Copiaza de la Guest la Host${NC}"
    echo -e "${green}2. Copiaza de la Host la Guest${NC}"
    echo -e "${green}3. Iesire${NC}"
    echo -e "${green}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
}

copy_from_guest_to_host() {
    echo -e "${red}GUEST -> HOST"
    echo -e "${green}Calea catre fisier/director Guest:${NC} "
    read guest_path
    echo -e "${green}Calea catre directorul local pe Host:${NC} " 
    read local_path

    ssh "$guest_user@$guest_address" "[ -e \"$guest_path\" ]"
    if [ $? -ne 0 ]; then
        echo -e "${red}Eroare: Calea guest specificată nu există pe mașina remote!${NC}"
        return
    fi

    echo  "Local path: $local_path"
    echo "Guest path: $guest_path"
    scp "$guest_user@$guest_address:$guest_path" "$local_path"
    echo -e "${green}Copiere finalizata.${NC}"
}


copy_from_host_to_guest() {
    echo "HOST -> GUEST"
    echo -e "${green}Calea catre fisier/director local pe Host:${NC} "
    read local_path
    echo -e "${green}Calea catre directorul remote pe Guest: ${NC}" 
    read guest_path

    ssh "$guest_user@$guest_address" "[ -e \"$guest_path\" ]"
    if [ $? -ne 0 ]; then
        echo -e "${red}Eroare: Calea guest specificată nu există pe mașina remote!${NC}"
        return
    fi

    if [ ! -e "$local_path" ]; then
        echo -e "${red}Eroare: Calea locală specificată nu există pe mașina locală!${NC}"
        return
    fi
    
    echo "Local path: $local_path"
    echo "Guest path: $guest_path"

    scp "$local_path" "$guest_user@$guest_address:$guest_path"
    
    if [ $? -eq 0 ]; then
        echo -e "${green}Copiere finalizată.${NC}"
    else
        echo -e "${red}Eroare în timpul copierii.${NC}"
    fi
}

while true; do
    show_menu
    echo -e "${green}Introduceti optiunea dorita: "
    read option
    case $option in
        1) copy_from_guest_to_host ;;
        2) copy_from_host_to_guest ;;
        3) exit 0 ;;
        *) echo -e "${red}Optiune invalida!${NC}"; sleep 1 ;;
    esac
    
done