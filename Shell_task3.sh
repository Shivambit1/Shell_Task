Task :-

Part 1: Account Creation
Implement an option -c or --create that allows the script to create a new user account. The script should prompt the user to enter the new username and password.

Ensure that the script checks whether the username is available before creating the account. If the username already exists, display an appropriate message and exit gracefully.

After creating the account, display a success message with the newly created username.

Part 2: Account Deletion
Implement an option -d or --delete that allows the script to delete an existing user account. The script should prompt the user to enter the username of the account to be deleted.

Ensure that the script checks whether the username exists before attempting to delete the account. If the username does not exist, display an appropriate message and exit gracefully.

After successfully deleting the account, display a confirmation message with the deleted username.

Part 3: Password Reset
Implement an option -r or --reset that allows the script to reset the password of an existing user account. The script should prompt the user to enter the username and the new password.

Ensure that the script checks whether the username exists before attempting to reset the password. If the username does not exist, display an appropriate message and exit gracefully.

After resetting the password, display a success message with the username and the updated password.

Part 4: List User Accounts
Implement an option -l or --list that allows the script to list all user accounts on the system. The script should display the usernames and their corresponding user IDs (UID).
Part 5: Help and Usage Information
Implement an option -h or --help that displays usage information and the available command-line options for the script.
Bonus Points (Optional)
If you want to challenge yourself further, you can add additional features to the script, such as:

Displaying more detailed information about user accounts (e.g., home directory, shell, etc.).
Allowing the modification of user account properties (e.g., username, user ID, etc.).


CODE :- 

#!/bin/bash

# Function to display usage information and available options
function display_usage {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -c, --create     Create a new user account."
    echo "  -d, --delete     Delete an existing user account."
    echo "  -r, --reset      Reset password for an existing user account."
    echo "  -l, --list       List all user accounts on the system."
    echo "  -h, --help       Display this help and exit."
}

# Function to create a new user account
function create_user {
    read -p "Enter the new username: " username

    # Check if the username already exists
    if id "$username" &>/dev/null; then
        echo "Error: The username '$username' already exists. Please choose a different username."
    else
        # Prompt for password (Note: You might want to use 'read -s' to hide the password input)
        read -p "Enter the password for $username: " password

        # Create the user account
        useradd -m -p "$password" "$username"
        echo "User account '$username' created successfully."
    fi
}

# Function to delete an existing user account
function delete_user {
    read -p "Enter the username to delete: " username

    # Check if the username exists
    if id "$username" &>/dev/null; then
        userdel -r "$username"  # -r flag removes the user's home directory
        echo "User account '$username' deleted successfully."
    else
        echo "Error: The username '$username' does not exist. Please enter a valid username."
    fi
}

# Function to reset the password for an existing user account
function reset_password {
    read -p "Enter the username to reset password: " username

    # Check if the username exists
    if id "$username" &>/dev/null; then
        # Prompt for password (Note: You might want to use 'read -s' to hide the password input)
        read -p "Enter the new password for $username: " password

        # Set the new password
        echo "$username:$password" | chpasswd
        echo "Password for user '$username' reset successfully."
    else
        echo "Error: The username '$username' does not exist. Please enter a valid username."
    fi
}

# Function to list all user accounts on the system
function list_users {
    echo "User accounts on the system:"
    cat /etc/passwd | awk -F: '{ print "- " $1 " (UID: " $3 ")" }'
}

# Check if no arguments are provided or if the -h or --help option is given
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    display_usage
    exit 0
fi

# Command-line argument parsing
while [ $# -gt 0 ]; do
    case "$1" in
        -c|--create)
            create_user
            ;;
        -d|--delete)
            delete_user
            ;;
        -r|--reset)
            reset_password
            ;;
        -l|--list)
            list_users
            ;;
        *)
            echo "Error: Invalid option '$1'. Use '--help' to see available options."
            exit 1
            ;;
    esac
    shift
done


