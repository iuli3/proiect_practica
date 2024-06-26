#!/bin/bash
user=$1
host=$2

red='\033[1;91m'
NC='\033[0m'

log_dir="/home/iuli/git/proiect_practica/logs"
user_dir="$log_dir/$user@$host"
cpu_file="$user_dir/cpu_alerts.txt"

if [[ ! -d "$user_dir" ]]
then
    mkdir -p "$user_dir"
fi

if [[ ! -f "$cpu_file" ]]
then 
    touch "$cpu_file"
fi

ssh "$1@$2"<<EOF
    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}Monitorizare Resurse${NC}"
    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    
    echo -e "${red}Tip OS:${NC} $(uname -o)"
    echo -e "${red}Nume OS:${NC} $(lsb_release -i | cut -f 2)"
    echo -e "${red}Versiune OS:${NC} $(lsb_release -r | cut -f 2)"
    echo -e "${red}Arhitectură:${NC} $(uname -m)"
    echo -e "${red}Versiune Kernel:${NC} $(uname -r)"
    echo -e "${red}Hostname:${NC} $(hostname)"
    echo -e "${red}IP Intern:${NC} $(hostname -I | cut -d ' ' -f 1)"
    echo -e "${red}IP Extern:${NC} $(curl -s ifconfig.me)"
    echo -en "${red}Nume servere DNS:${NC} "
    grep '^nameserver' /etc/resolv.conf | cut -d ' ' -f 2
    echo -e "${red}Utilizatori conectați:${NC}"
    who

    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}Utilizare RAM:${NC}"
    free -h

    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}Utilizare CPU:${NC}"
    cpu_usage=\$(top -bn1 | grep 'Cpu(s)' | awk '{printf "%.0f", \$2 + \$4}')
    echo "\$cpu_usage%"

    cpu_usage="${cpu_usage%%,*}"
    echo "$cpu_usage"

    if [[ "$cpu_usage" -gt 70 ]]; then
        timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        alert="[$timestamp] ALERTĂ: Utilizarea CPU-ului este peste 70% pentru $user@$host. CPU-ul era utilizat $cpu_usage."
        echo "$alert" >> "$cpu_file"
        DISPLAY=:0 notify-send 'ALERTĂ: Utilizare CPU' "$alert"
    fi

    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}Utilizare I/O:${NC}"
    iostat

    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}Temperatură:${NC}"
    sensors

    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}Utilizare disc:${NC}"
    df -h

    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}Medie încărcare:${NC}"
    uptime | sed 's/^.*load average: //'

    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}Uptime sistem:${NC}"
    uptime -p

EOF
