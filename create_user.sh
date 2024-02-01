#!/bin/bash

# Check if the script is being run with root privileges
if [[ $EUID -ne 0 ]]; then
            echo "This script must be run as root."
                exit 1
fi

# Read the username from user input
read -p "Enter the username for the new user: " username

# Check if the username is already taken
if id -u "$username" >/dev/null 2>&1; then
            echo "The username '$username' is already in use. Please choose a different username."
                exit 1
fi

# Generate a random password
password=$(openssl rand -base64 12 | tr -d '/+=' | head -c 16)


# Create the user with the initial password
useradd -m -s /bin/bash "$username"
echo "$username:$password" | chpasswd

# Force the user to change the password upon first login
chage -d 0 "$username"

# Prompt the user whether to assign sudo privileges
read -p "Do you want to assign sudo privileges to the user '$username'? (y/n): " assign_sudo

if [[ $assign_sudo =~ ^[Yy]$ ]]; then
            usermod -aG sudo "$username"
                echo "Sudo privileges have been assigned to the user '$username'."
fi

# Display the username and initial password
echo "User '$username' has been created with the initial password: $password"
