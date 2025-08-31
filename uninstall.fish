#!/usr/bin/env fish

# Prompt the user and read a single character into the 'reply' variable.
read -P "Would you like to uninstall Uni-Sync? [N/y]: " -n 1 reply
echo # Print a newline for better formatting.

# Check if the user's reply matches 'Y' or 'y' using regex.
if string match -r '^[Yy]$' -- $reply
    echo 'Uninstalling Uni-Sync...'
    sudo systemctl disable uni-sync
    sudo rm /etc/systemd/system/uni-sync.service
    cp -f /etc/uni-sync/uni-sync.json ./uni-sync-backup.json
    sudo rm /etc/uni-sync/uni-sync.json
    sudo rm -r /etc/uni-sync
    echo 'Uni-Sync has been removed.'
else
    # This block runs if the user enters 'n' or any other key.
    echo 'Uninstall cancelled.'
end
