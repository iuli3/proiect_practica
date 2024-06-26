#!/bin/bash
user=$1
host=$2

red='\033[1;91m'
NC='\033[0m'


ssh "$1@$2"<<EOF
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "${red}Monitorizare Resurse${NC}"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    
    echo "${red}Tip OS:${NC} $(uname -o)"
    echo "${red}Nume OS:${NC} $(lsb_release -i | cut -f 2)"
    echo "${red}Versiune OS:${NC} $(lsb_release -r | cut -f 2)"
    echo "${red}Arhitectură:${NC} $(uname -m)"
    echo "${red}Versiune Kernel:${NC} $(uname -r)"
    echo "${red}Hostname:${NC} $(hostname)"
    echo "${red}IP Intern:${NC} $(hostname -I | cut -d ' ' -f 1)"
    echo "${red}IP Extern:${NC} $(curl -s ifconfig.me)"
    echo -n "${red}Nume servere DNS:${NC} "
    grep '^nameserver' /etc/resolv.conf | cut -d ' ' -f 2
    echo "${red}Utilizatori conectați:${NC}"
    who

    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "${red}Utilizare RAM:${NC}"
    free -h

    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "${red}Utilizare CPU:${NC}"
    top -bn1 | grep 'Cpu(s)' | sed 's/^.*: //'

    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "${red}Utilizare I/O:${NC}"
    iostat

    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "${red}Temperatură:${NC}"
    sensors

    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "${red}Utilizare disc:${NC}"
    df -h

    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "${red}Medie încărcare:${NC}"
    uptime | sed 's/^.*load average: //'

    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "${red}Uptime sistem:${NC}"
    uptime -p


EOF
