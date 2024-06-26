#!/bin/bash

install_app() {
    local username=$1
    local hostname=$2
    echo -n "Numele aplicatiei: "
    read app_name

    if [ -z "$app_name" ]; then
        echo -e "\033[1;91mNumele aplicatiei nu a fost specificat.\033[0m"
        return 1
    fi

    echo -e "\033[0;34mInstalare aplicatie $app_name pe serverul remote $hostname...\033[0m"
    ssh -tt $username@$hostname "sudo apt-get update && sudo apt-get install -y $app_name"
    if [ $? -eq 0 ]; then
        echo -e "\033[0;34mAplicatia $app_name a fost instalata pe $hostname.\033[0m"
    else
        echo -e "\033[1;91mEroare la instalarea aplicatiei $app_name pe $hostname.\033[0m"
    fi
}

if [ $# -ne 2 ]; then
    echo "Utilizare: $0 <username> <hostname>"
    exit 1
fi

username=$1
hostname=$2

while true; do
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "1. Instalare aplicatie"
    echo "2. Iesire"
    read -p "Alege optiunea: " choice

    case $choice in
        1) install_app $username $hostname ;;
        2) echo "Iesire din program."
           exit 0
           ;;
        *) echo "Optiune invalida. Alegeti din nou."
           ;;
    esac

    echo ""
done
