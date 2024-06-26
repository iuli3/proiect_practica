#!/bin/bash

magenta='\033[0;35m'
blue='\033[0;34m'
red='\033[1;91m'
green='\033[0;32m' 
NC='\033[0m'

ssh_menu() {
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "SSH Connect"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Credentiale SSH"
    echo -n "Username: "
    read user
    echo -n "Hostname or IP: "
    read host
    echo ""
}

show_menu() {
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${magenta}Meniu principal${NC}"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}1. Monitorizeaza Resurse${NC}"
    echo -e "2. Controleaza procese"
    echo -e "${green}3. Copiere fisiere${NC}"
    echo "4. Instalare aplicatii"
    echo "5. Security Check"
    echo "6.. Exit"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Alege optiune: "
}

ssh_menu 

while true; do
     
    show_menu  
    read choice
    case $choice in
        1) ./monitor.sh "$user" "$host" ;;
        2) ./control_processes.sh "$user" "$host" ;;
        3) ./copy_files.sh "$user" "$host" ;;
        4) ./app_install.sh "$user" "$host" ;;
        6) echo "Exiting..."; break ;;
        *) echo "Invalid option";;
    esac
done
