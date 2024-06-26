#!/bin/bash

magenta='\033[0;35m'
blue='\033[0;34m'
red='\033[1;91m'
green='\033[0;32m' 
NC='\033[0m'
pink='\033[1;35m' 
turcoaz='\033[0;36m'

choose_user() {
    echo -e "${pink}Alege un utilizator:${NC}"
    echo -e "${pink}1. iuli@172.20.10.2${NC}"
    echo -e "${pink}2. iuli@127.0.0.1${NC}"
    read -p "Optiune: " user_choice

    case $user_choice in
        1)
            user="iuli"
            host="172.20.10.2"
            ;;
        2)
            user="iuli"
            host="127.0.0.1"
            ;;
        *)
            echo -e "${red}Optiune invalida. Te rog sa alegi din nou.${NC}"
            choose_user
            ;;
    esac
}

ssh_menu() {
    # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    # echo "SSH Connect"
    # echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    # echo "Credentiale SSH"
    # echo -n "Username: "
    # read user
    # echo -n "Hostname or IP: "
    # read host
    # echo ""
    if ! ssh $user@$host "grep -q \"$(cat ~/.ssh/id_rsa.pub)\" ~/.ssh/authorized_keys"; then
        ssh-copy-id -i ~/.ssh/id_rsa.pub $user@$host
    else
        echo "Cheia publica este deja prezenta pe sistemul remote"
    fi


}

show_menu() {
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${magenta}Meniu principal${NC}"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}1. Monitorizeaza Resurse${NC}"
    echo -e "${blue}2. Controleaza procese${NC}"
    echo -e "${green}3. Copiere fisiere${NC}"
    echo -e "${pink}4. Instalare aplicatii${NC}"
    echo -e "${turcoaz}5. Security Check${NC}"
    echo -e "${red}6. Exit${NC}"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Alege optiune: "
}

choose_user

ssh_menu 

while true; do
     
    show_menu  
    read choice
    case $choice in
        1) ./monitor.sh "$user" "$host" ;;
        2) ./control_processes.sh "$user" "$host" ;;
        3) ./copy_files.sh "$user" "$host" ;;
        4) ./app_install.sh "$user" "$host" ;;
        5) ./check_security.sh "$user" "$host" ;;
        6) break ;;
        *) echo "Invalid option";;
    esac
done
