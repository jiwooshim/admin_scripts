#!/bin/bash

# Check if the script is being run with root privileges
if [[ $EUID -ne 0 ]]; then
echo "This script must be run as root."
exit 1
fi

# Function to check if the user is in the sudo group
is_user_in_sudo_group() {
  local username=$1
  getent group sudo | grep -q "\b$username\b"
}

# Display the list of users
echo "List of users:"
cut -d: -f1 /etc/passwd

# Prompt the user to choose the action
read -p "Do you want to (1) delete a user or (2) remove a user from the sudo group without deleting? (Enter 1 or 2): " action

if [[ $action == "1" ]]; then
# Read the username from user input
read -p "Enter the username of the user to be deleted: " username

# Check if the user exists
if ! id -u "$username" >/dev/null 2>&1; then
echo "The user '$username' does not exist."
exit 1
fi

# Prompt the user to confirm the deletion
read -p "Are you sure you want to delete the user '$username'? This action is irreversible. (y/n): " confirm

if [[ $confirm =~ ^[Yy]$ ]]; then
# Delete the user and their home directory
userdel -r "$username"
echo "User '$username' has been deleted."
else
echo "Deletion of user '$username' has been canceled."
fi
elif [[ $action == "2" ]]; then
# Read the username from user input
read -p "Enter the username of the user: " username

# Check if the user exists
if ! id -u "$username" >/dev/null 2>&1; then
echo "The user '$username' does not exist."
exit 1
fi

# Check if the user is in the sudo group
if ! is_user_in_sudo_group "$username"; then

