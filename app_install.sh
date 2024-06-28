#!/bin/bash

NC='\033[0m'
pink='\033[1;35m'
red='\033[1;91m'



install_app() {
    local username=$1
    local hostname=$2
    local date_time=$(date +'%Y-%m-%d %H:%M:%S') 

    echo -e "${pink}Numele aplicatiei: ${NC}"
    read app_name


    echo -e "${pink}Instalare aplicatie $app_name pe serverul remote $hostname...${NC}"
    ssh -tt $username@$hostname "sudo apt-get update && sudo apt-get install -y $app_name"
    
    if [ $? -eq 0 ]; then
        echo -e "${pink}Aplicatia $app_name a fost instalata pe $hostname.${NC}"
        echo -e "Data si Ora: $date_time" >> "$file"
        echo -e "Utilizator si Hostname: $username@$hostname" >> "$file"
        echo -e "Numele Aplicatiei: $app_name" >> "$file"
        echo -e "Rezultat: Instalare cu succes" >> "$file"
    else
        echo -e "${red}Eroare la instalarea aplicatiei $app_name pe $hostname.${NC}"
        echo -e "Data si Ora: $date_time" >> "$file"
        echo -e "Utilizator si Hostname: $username@$hostname" >> "$file"
        echo -e "Numele Aplicatiei: $app_name" >> "$file"
        echo -e "Rezultat: Eroare la instalare" >> "$file"
        return 1
    fi
}




username=$1
hostname=$2



log_dir="/home/iuli/git/proiect_practica/logs"
user_dir="$log_dir/$username@$hostname"
file="$user_dir/app_installog.txt"
if [[ ! -d "$user_dir" ]]; then
    mkdir -p "$user_dir"
fi

if [[ ! -f "$file" ]]; then
    touch "$file"
fi


while true; do
    echo -e "${pink}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${pink}1. Instalare aplicatie${NC}"
    echo -e "${pink}2. Iesire${NC}"
    read -p "$(echo -e ${pink}Alege optiunea: ${NC})" choice

    case $choice in
        1) install_app $username $hostname  ;;
        2) echo -e "${pink}Exit${NC}"
           exit 0
           ;;
        *) echo -e "${red}Optiune invalida. Alegeti din nou.${NC}"
           ;;
    esac

    echo ""
done
