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
