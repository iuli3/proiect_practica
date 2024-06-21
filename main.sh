#!/bin/bash

ssh_menu() {
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "SSH Connect"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Enter SSH Credentials"
    echo -n "Username: "
    read user
    echo -n "Hostname or IP: "
    read host
    echo ""
    python3 connectSSH.py "$user" "$host"
}

show_menu() {
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Main Menu"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "1. Monitor Resources"
    echo "2. Control Services"
    echo "3. Copy Files"
    echo "4. Install App"
    echo "5. Security Check"
    echo "6. Exit"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Choose an option: "
}

while true; do
    ssh_menu  
    show_menu  

    read choice
    case $choice in
        1) ./monitor.sh "$user" "$host" ;;
        #2) ./control_services.sh "$user" "$host" ;;
        6) echo "Exiting..."; break ;;
        *) echo "Invalid option";;
    esac
done
