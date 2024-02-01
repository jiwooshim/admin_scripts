#!/bin/bash

# Check if the script is being run with root privileges
if [[ $EUID -ne 0 ]]; then
            echo "This script must be run as root."
                exit 1
fi

# Get the server hostname
hostname=$(hostname)
echo "Server Hostname: $hostname"

# Get the Ubuntu version
ubuntu_version=$(lsb_release -ds)
echo "Ubuntu Version: $ubuntu_version"

# Get the kernel version
kernel_version=$(uname -r)
echo "Kernel Version: $kernel_version"

# Get the CPU information
cpu_info=$(cat /proc/cpuinfo | grep "model name" | head -n 1 | awk -F ": " '{print $2}')
echo "CPU Information: $cpu_info"

# Get the total memory
total_memory=$(free -h --si | awk '/^Mem:/{print $2}')
echo "Total Memory: $total_memory"

# Get the total storage
total_storage=$(df -h / | awk '/^\/dev/{print $2}')
echo "Total Storage: $total_storage"

# Get the IP address
ip_address=$(hostname -I | awk '{print $1}')
echo "IP Address: $ip_address"

# Get the network interface information
network_info=$(ip addr show)
echo -e "Network Interface Information:\n$network_info"

# Get the open ports
open_ports=$(netstat -tuln | awk '/^tcp/ {print $4}' | awk -F ":" '{print $NF}' | sort -n | uniq)
echo -e "Open Ports:\n$open_ports"

# Get the installed web server software
web_server=$(systemctl list-units --type=service --state=running | grep -i "apache2\|nginx" | awk '{print $1}')
if [[ ! -z $web_server ]]; then
            echo "Installed Web Server: $web_server"
    else
                echo "No web server software (Apache or Nginx) found."
fi

# Get the installed database server software
database_server=$(systemctl list-units --type=service --state=running | grep -i "mysql\|postgresql" | awk '{print $1}')
if [[ ! -z $database_server ]]; then
            echo "Installed Database Server: $database_server"
    else
                echo "No database server software (MySQL or PostgreSQL) found."
fi

# Get the installed PHP version
php_version=$(php -v | grep -i "php-cli" | awk '{print $2}')
if [[ ! -z $php_version ]]; then
            echo "Installed PHP version: $php_version"
    else
                echo "No PHP installation found."
fi
