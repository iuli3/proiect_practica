#!/bin/bash

username=$1
hostname=$2
blue='\033[1;34m'
red='\033[1;91m'
NC='\033[0m'

list_remote_processes() {
    echo -e "${blue}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${blue}Lista proceselor active pe serverul remote"
    echo -e "${blue}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    ssh $username@$hostname "ps -e -o pid,user,%cpu,command --sort=-%cpu | head -n 10"
}

kill_remote_process() {
    local pid=$1
    if [ -z "$pid" ]; then
        echo -e "${red}EROARE: PID-ul procesului nu a fost specificat.${NC}"
        return 1
    fi

    if ssh $username@$hostname "ps -p $pid > /dev/null"; then
        echo -e "${blue}Opresc procesul cu PID-ul $pid pe serverul remote...${NC}"
        ssh $username@$hostname "kill -9 $pid"
        echo -e "${blue}Procesul cu PID-ul $pid a fost oprit pe serverul remote.${NC}"
    else
        echo -e "${red}Nu exista niciun proces cu PID-ul $pid pe serverul remote sau PID-ul nu este valid.${NC}"
    fi
}

start_remote_process() {
    local command=$1
    if [ -z "$command" ]; then
        echo -e "${red}EROARE: Comanda procesului nu a fost specificata.${NC}"
        return 1
    fi

    echo -e "${blue}Pornez procesul '$command' pe serverul remote...${NC}"
   ssh $username@$hostname "nohup $command > /dev/null 2>&1 &"
    echo -e "${blue}Procesul '$command' a fost pornit pe serverul remote.${NC}"
}

list_all_processes() {
    echo -e "${blue}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${blue}Lista tuturor proceselor pe serverul remote${NC}"
    echo -e "${blue}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    ssh $username@$hostname "ps -e -o pid,user,%cpu,command --sort=-%cpu"
}

search_remote_process() {
    echo -e "${green}Introdu numele procesului pe care doresti sa-l cauti:${NC}"
    read process_name

    echo -e "${blue}Caut procesul '$process_name' pe serverul remote...${NC}"
    result=$(ssh $username@$hostname "ps -e -o pid,user,%cpu,command | grep -i \"$process_name\"")
    
    if [ -z "$result" ]; then
        echo -e "${red}Procesul '$process_name' nu a fost gasit pe serverul remote.${NC}"
    else
        echo -e "${green}Procesul '$process_name' a fost gasit pe serverul remote:${NC}"
        echo -e "${blue}$result${NC}"
        
      
        pids=$(echo "$result" | awk '{print $1}')
        echo -e "${green}PID-urile procesului '$process_name':${NC}"
        echo -e "${blue}$pids${NC}"
    fi
}

while true; do
    echo ""
    echo -e "${blue}1. Listare primele 10 procese dupa % CPU pe serverul remote${NC}"
    echo -e "${blue}2. Opreste proces dupa PID pe serverul remote${NC}"
    echo -e "${blue}3. Porneste un proces pe serverul remote${NC}"
    echo -e "${blue}4. Listare toate procesele pe serverul remote${NC}"
    echo -e "${blue}5. Cauta un proces pe serverul remote${NC}"
    echo -e "${blue}6. Exit${NC}"
    echo ""
    echo -e "${blue}Alege optiunea: ${NC}" 
    read  choice

    case $choice in
        1)list_remote_processes ;;
        2) echo -e "${blue}Introdu PID-ul procesului pe care doresti sa-l opresti:${NC} " 
            read  pid
            kill_remote_process $pid ;;
        3)echo -e "${blue}Introdu comanda procesului pe care doresti sa-l pornesti:${NC}"
            read command
            start_remote_process "$command" ;;
        4)list_all_processes ;;
        5)search_remote_process ;;
        6)echo -e "${blue}Exiting...${NC}"
            break ;;
        *) echo -e "${red}Optiune invalida. Te rog sa alegi din nou.${NC}" ;;
    esac
done
