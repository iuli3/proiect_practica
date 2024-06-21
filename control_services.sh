#!/bin/bash


user=$1
host=$2

list_services() {
    ssh "$user@$host" 'sudo -S systemctl list-unit-files --type=service'
}


stop_service() {
    local service_name=$1
    ssh "$user@$host" "sudo systemctl stop $service_name"
}

start_service() {
    local service_name=$1
    ssh "$user@$host" "sudo systemctl start $service_name"
}

show_menu() {
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Control Servicii - Meniu"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "1. Listare servicii disponibile"
    echo "2. Oprire serviciu"
    echo "3. Pornire serviciu"
    echo "4. Ieșire"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Alegeți o opțiune: "
}



while true; do
    show_menu
    read choice

    case $choice in
        1) echo "Listare servicii disponibile:"
           list_services
           ;;
        2) echo -n "Introduceti numele serviciului pentru oprire: "
           read service_to_stop
           stop_service "$service_to_stop"
           ;;
        3) echo -n "Introduceti numele serviciului pentru pornire: "
           read service_to_start
           start_service "$service_to_start"
           ;;
        4) echo "Iesire din program."
           exit 0
           ;;
        *) echo "Optiune invalida. Alegeti din nou."
           ;;
    esac

    echo ""  ]
done
