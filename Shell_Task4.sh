Task
1: Process Selection:
The script should accept a command-line argument to specify the target process to monitor. For example: ./monitor_process.sh <process_name>.

2:Process Existence Check:
Implement a function that checks if the specified process is currently running on the system.
If the process is running, print a message indicating its presence.

3:Restarting the Process:
If the process is not running, implement a function that attempts to restart the process automatically.
Print a message indicating the attempt to restart the process.
Ensure the script does not enter an infinite loop while restarting the process. Limit the number of restart attempts.

4:Automation:
Provide instructions on how to schedule the script to run at regular intervals using a cron job or any other appropriate scheduling method.

5:Documentation:
Include clear and concise comments in the script to explain its logic and functionality.
Write a separate document describing the purpose of the script, how to use it, and any specific considerations.

CODE - 1

#!/bin/bash

# Function to check if the specified process is running
is_process_running() {
    if pgrep -x "$1" >/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to restart the process using systemctl
restart_process() {
    local process_name="$1"
    echo "Process $process_name is not running. Attempting to restart..."

    # Check if the user has the privilege to restart the process
    if sudo systemctl restart "$process_name"; then
        echo "Process $process_name restarted successfully."
    else
        echo "Failed to restart $process_name. Please check the process manually."
    fi
}

# Check if a process name is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

process_name="$1"
max_attempts=3
attempt=1

# Loop to check and restart the process
while [ $attempt -le $max_attempts ]; do
    if is_process_running "$process_name"; then
        echo "Process $process_name is running."
    else
        restart_process "$process_name"
    fi

    attempt=$((attempt + 1))
    sleep 5  # Wait for 5 seconds before the next check
done

echo "Maximum restart attempts reached. Please check the process manually."




Task Set 2 -

Task 1: Implementing Basic Metrics Monitoring
Write a Bash script that monitors the CPU usage, memory usage, and disk space usage of the system. The script should display these metrics in a clear and organized manner, allowing users to interpret the data easily. The script should use the top, free, and df commands to fetch the metrics.

Task 2: User-Friendly Interface
Enhance the script by providing a user-friendly interface that allows users to interact with the script through the terminal. Display a simple menu with options to view the metrics and an option to exit the script.

Task 3: Continuous Monitoring with Sleep
Introduce a loop in the script to allow continuous monitoring until the user chooses to exit. After displaying the metrics, add a "sleep" mechanism to pause the monitoring for a specified interval before displaying the metrics again. Allow the user to specify the sleep interval.

Task 4: Monitoring a Specific Service (e.g., Nginx)
Extend the script to monitor a specific service like Nginx. Check if the service is running and display its status. If it is not running, provide an option for the user to start the service. Use the systemctl or appropriate command to check and control the service.

Task 5: Allow User to Choose a Different Service
Modify the script to give the user the option to monitor a different service of their choice. Prompt the user to enter the name of the service they want to monitor, and display its status accordingly.

Task 6: Error Handling
Implement error handling in the script to handle scenarios where commands fail or inputs are invalid. Display meaningful error messages to guide users on what went wrong and how to fix it.


CODE -

#!/bin/bash

# Function to display system metrics (CPU, memory, disk space)
function view_system_metrics() {
    echo "---- System Metrics ----"
    # Fetch CPU usage using `top` command and extract the value using awk
    cpu_usage=$(top -bn 1 | grep '%Cpu' | awk '{print $2}')
    # Fetch memory usage using `free` command and extract the value using awk
    mem_usage=$(free | grep Mem | awk '{printf("%.1f", $3/$2 * 100)}')
    # Fetch disk space usage using `df` command and extract the value using awk
    disk_usage=$(df -h / | tail -1 | awk '{print $5}')
    
    echo "CPU Usage:  $cpu_usage%   Mem Usage:  $mem_usage%   Disk Space:  $disk_usage"
}

# Function to monitor a specific service
function monitor_service() {
    echo "---- Monitor a Specific Service ----"
    read -p "Enter the name of the service to monitor: " service_name

    # Check if the service is running using `systemctl` command
    if systemctl is-active --quiet $service_name; then
        echo "$service_name is running."
    else
        echo "$service_name is not running."
        read -p "Do you want to start $service_name? (Y/N): " choice
        if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
            # Start the service using `systemctl` command
            systemctl start $service_name
            echo "$service_name started successfully."
        fi
    fi
}

# Main loop for continuous monitoring
while true; do
    echo "---- Monitoring Metrics Script ----"
    echo "1. View System Metrics"
    echo "2. Monitor a Specific Service"
    echo "3. Exit"

    read -p "Enter your choice (1, 2, or 3): " choice

    case $choice in
        1)
            view_system_metrics
            ;;
        2)
            monitor_service
            ;;
        3)
            echo "Exiting the script. Goodbye!"
            exit 0
            ;;
        *)
            echo "Error: Invalid option. Please choose a valid option (1, 2, or 3)."
            ;;
    esac

    # Sleep for 5 seconds before displaying the menu again
    sleep 5
done
