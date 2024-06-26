#!/bin/bash

username=$1
hostname=$2

list_remote_processes() {
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Lista proceselor active pe serverul remote"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    ssh $username@$hostname "ps -e -o pid,user,%cpu,command --sort=-%cpu | head -n 10"
}

kill_remote_process() {
    local pid=$1
    if [ -z "$pid" ]; then
        echo "EROARE: PID-ul procesului nu a fost specificat."
        return 1
    fi

    if ssh $username@$hostname "ps -p $pid > /dev/null"; then
        echo "Opresc procesul cu PID-ul $pid pe serverul remote..."
        ssh $username@$hostname "kill -9 $pid"
        echo "Procesul cu PID-ul $pid a fost oprit pe serverul remote."
    else
        echo "Nu exista niciun proces cu PID-ul $pid pe serverul remote sau PID-ul nu este valid."
    fi
}

while true; do
    echo ""
    echo "1. Listare primele 10 procese dupa % CPU pe serverul remote"
    echo "2. Opreste proces dupa PID pe serverul remote"
    echo "3. Iesire din program"
    echo ""
    read -p "Alege optiunea: " choice

    case $choice in
        1)
            list_remote_processes ;;
        2)
            read -p "Introdu PID-ul procesului pe care doresti sa-l opresti: " pid
            kill_remote_process $pid ;;
        3)
            echo "Iesire din program."
            break ;;
        *)
            echo "Optiune invalida. Te rog sa alegi din nou." ;;
    esac
done
