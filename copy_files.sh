#!/bin/bash

green='\033[0;32m'
red='\033[1;91m'
blue='\033[1;34m'
NC='\033[0m'

guest_user=$1
guest_address=$2

show_menu() {
    echo -e "${green}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${green}Meniu Transfer Fisiere cu SCP${NC}"
    echo -e  "${green}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${green}1. Copiaza de la Guest la Host${NC}"
    echo -e "${green}2. Copiaza de la Host la Guest${NC}"
    echo -e "${green}3. Cauta un fisier sau director dupa nume pe sistemul remote${NC}"
    echo -e "${green}4. Listeaza fisierele din directorul curent pe sistemul remote${NC}"
    echo -e "${green}5. Exit${NC}"
    echo -e "${green}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
}

copy_from_guest_to_host() {
    echo -e "${red}GUEST -> HOST${NC}"
    echo -e "${green}Calea catre fisier/director Guest:${NC} "
    read guest_path
    echo -e "${green}Calea catre directorul local pe Host:${NC} " 
    read local_path

    ssh "$guest_user@$guest_address" "[ -e \"$guest_path\" ]"
    if [ $? -ne 0 ]; then
        echo -e "${red}Eroare: Calea guest specificată nu există pe mașina remote!${NC}"
        return
    fi

    echo -e "${blue}Local path: $local_path${NC}"
    echo -e "${blue}Guest path: $guest_path${NC}"
    scp "$guest_user@$guest_address:$guest_path" "$local_path"
    if [ $? -eq 0 ]; then
        echo -e "${green}Copiere finalizata.${NC}"
    else
        echo -e "${red}Eroare în timpul copierii.${NC}"
    fi
}

copy_from_host_to_guest() {
    echo -e "${red}HOST -> GUEST${NC}"
    echo -e "${green}Calea catre fisier/director local pe Host:${NC} "
    read local_path
    echo -e "${green}Calea catre directorul remote pe Guest:${NC} " 
    read guest_path

    ssh "$guest_user@$guest_address" "[ -e \"$guest_path\" ]"
    if [ $? -ne 0 ]; then
        echo -e "${red}Eroare: Calea guest specificata nu exista pe masina remote!${NC}"
        return
    fi

    if [ ! -e "$local_path" ]; then
        echo -e "${red}Eroare: Calea locala specificata nu exista pe masina locala!${NC}"
        return
    fi
    
    echo -e "${blue}Local path: $local_path${NC}"
    echo -e "${blue}Guest path: $guest_path${NC}"

    scp "$local_path" "$guest_user@$guest_address:$guest_path"
    
    if [ $? -eq 0 ]; then
        echo -e "${green}Copiere finalizată${NC}"
    else
        echo -e "${red}Eroare în timpul copierii${NC}"
    fi
}

search_file_or_directory_on_remote() {
    echo -e "${green}Cauti un fisier sau un director? (f/d):${NC}"
    read type
    echo -e "${green}Introdu numele fisierului sau directorului de cautat pe sistemul remote:${NC}"
    read name

    if [[ "$type" == "f" ]]; then
        find_type="-type f"
        echo -e "${blue}Caut fisierul '$name' pe sistemul remote...${NC}"
    elif [[ "$type" == "d" ]]; then
        find_type="-type d"
        echo -e "${blue}Caut directorul '$name' pe sistemul remote...${NC}"
    else
        echo -e "${red}Tip invalid. Te rog introdu 'f' pentru fisier sau 'd' pentru director.${NC}"
        return
    fi

    result=$(ssh "$guest_user@$guest_address" "find . $find_type -name \"$name\" 2>/dev/null")
    if [ -z "$result" ]; then
        echo -e "${red}'$name' nu a fost gasit pe sistemul remote.${NC}"
    else
        echo -e "${green}'$name' a fost gasit pe sistemul remote:${NC}"
        echo -e "${blue}$result${NC}"
    fi
}

list_files_in_current_directory() {
    echo -e "${blue}Listarea fișierelor din directorul curent pe sistemul remote...${NC}"
    ssh "$guest_user@$guest_address" "ls -al"
}

while true; do
    show_menu
    echo -e "${green}Introduceti optiunea dorita:${NC} "
    read option
    case $option in
        1) copy_from_guest_to_host ;;
        2) copy_from_host_to_guest ;;
        3) search_file_or_directory_on_remote ;;
        4) list_files_in_current_directory ;;
        5) echo -e "${green}Exit.${NC}"; exit 0 ;;
        *) echo -e "${red}Optiune invalida!${NC}"; sleep 1 ;;
    esac
done
