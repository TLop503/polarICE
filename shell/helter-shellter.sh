#!/bin/bash

##### README #####
# Edit /etc/ssh/sshd_config and set:
# ForceCommand /path/to/this/file/helter-shellter.sh
# then restart sshd


MAX_COMMANDS=3

# Prevent spawning new shells
export SHELL=/usr/local/bin/countdown-shell.sh  # Ensure re-execution of restricted shell
export PATH="/usr/bin:/bin"  # Restrict PATH to prevent access to unexpected programs
unalias -a  # Remove any user-defined aliases

echo "You have $MAX_COMMANDS commands before disconnection. Thank you for complying with dad.corps enhanced security measures. Enjoy your stay!"

for ((i=1; i<=MAX_COMMANDS; i++)); do
    read -p "$USER@$(hostname):$PWD$ " -e CMD
    history -s "$CMD"  # Store command in history

    # Block spawning new shells
    if [[ "$CMD" =~ "/bin/bash" ]]; then
        echo "Shell access is restricted."
        continue
    fi
    
    if [[ "$CMD" =~ "/bin/sh" ]]; then
        echo "Shell access is restricted."
        continue
    fi

    if [[ "$CMD" =~ "exec sh" ]]; then
        echo "Shell access is restricted."
        continue
    fi

    if [[ -z "$CMD" ]]; then
        continue  # Ignore empty input
    elif [[ "$CMD" == "exit" ]]; then
        break
    fi

    eval "$CMD"  # Execute the command
done

echo "Command limit reached. Disconnecting..."
sleep 1
exit
