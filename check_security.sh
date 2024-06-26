#!/bin/bash

user=$1
host=$2

RED='\033[0;31m'
NC='\033[0m'

log_dir="/home/iuli/git/proiect_practica/logs"
user_dir="$log_dir/$user@$host"
file="$user_dir/securityCheck.txt"


if [[ ! -d "$user_dir" ]]; then
    mkdir -p "$user_dir"
fi

if [[ ! -f "$file" ]]; then
    touch "$file"
fi


run_check() {
    local description="$1"
    local command="$2"
    {
        echo "### $description ###"
        echo "Comanda: $command"
        ssh "$user@$host" "$command" 2>/dev/null  
        echo "----------------------------------------"
    } >> "$file"
}

run_security_checks() {
    local vulnerability_found=false
    local vulnerable_package="openssl"
    local vulnerable_version="1.0.2g-1ubuntu4.20"
    local installed_version=$(ssh "$user@$host" "dpkg-query -W -f='\${Version}' $vulnerable_package 2>/dev/null")
    
    if [ "$installed_version" == "$vulnerable_version" ]; then
        echo -e "${RED}!!! Vulnerabilitate detectata: $vulnerable_package la versiunea $installed_version !!!${NC}"
        echo -e "${RED}!!! Verificati si actualizati pachetul pentru a remedia problema !!!${NC}"
        echo ""
        vulnerability_found=true
    fi

    run_check "Verificarea permisiunilor pentru /etc/passwd" "ls -l /etc/passwd"
    run_check "Verificarea permisiunilor pentru /etc/shadow" "ls -l /etc/shadow"
    run_check "Verificarea permisiunilor pentru /etc/ssh/sshd_config" "ls -l /etc/ssh/sshd_config"
    
  
    run_check "Verificarea proceselor neobisnuite" "ps aux | grep -E '(nmap|netcat|nc|telnet)'"

    
    local vulnerable_packages=("apache2" "nginx" "mysql-server")
    for package in "${vulnerable_packages[@]}"; do
        if ssh "$user@$host" "dpkg -l | grep -qw $package 2>/dev/null"; then
            echo -e "${RED}!!! Vulnerabilitate potentiala: $package este instalat !!!${NC}"
            echo ""
            vulnerability_found=true
        fi
    done

   
    run_check "Verificarea utilizatorilor fara parole" "awk -F: '(\$2 == \"\" ) { print \$1 }' /etc/shadow"
    
    run_check "Verificarea fisierelor cu setuid/setgid" "find / -perm /6000 -type f -exec ls -ld {} \; 2>/dev/null"

  
    if [ "$vulnerability_found" = true ]; then
        echo -e "${RED}!!! Vulnerabilitati gasite pe sistemul $host. Verificati detaliile în fisierul de log: $file !!!${NC}"
    fi
}

{
    echo "### Inceperea verificarilor de securitate pentru $user@$host ###"
    echo "Data: $(date)"
    echo "----------------------------------------"
} >> "$file"


run_security_checks


{
    echo "### Verificarile de securitate s-au încheiat pentru $user@$host ###"
} >> "$file"

echo "Rezultatele verificarilor sunt stocate în $file"
