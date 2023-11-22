Task
Process Selection:

The script should accept a command-line argument to specify the target process to monitor. For example: ./monitor_process.sh <process_name>.
Process Existence Check:

Implement a function that checks if the specified process is currently running on the system.
If the process is running, print a message indicating its presence.
Restarting the Process:

If the process is not running, implement a function that attempts to restart the process automatically.
Print a message indicating the attempt to restart the process.
Ensure the script does not enter an infinite loop while restarting the process. Limit the number of restart attempts.
Automation:

Provide instructions on how to schedule the script to run at regular intervals using a cron job or any other appropriate scheduling method.
Documentation:

Include clear and concise comments in the script to explain its logic and functionality.
Write a separate document describing the purpose of the script, how to use it, and any specific considerations.

