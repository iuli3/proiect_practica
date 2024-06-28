#!/bin/bash
user=$1
host=$2

red='\033[1;91m'
NC='\033[0m'


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
    echo -e "${red}Starea serviciu ssh:${NC}"
    systemctl status sshd

    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}Utilizare disc:${NC}"
    df -h

    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}Medie încărcare:${NC}"
    uptime | sed 's/^.*load average: //'

    echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${red}Uptime sistem:${NC}"
    uptime -p

    echo -e "${red}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${red}Starea și disponibilitatea sistemului de fișiere:${NC}"
    df -h /

EOF
