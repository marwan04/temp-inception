#!/bin/bash

# Check if the secret file exists
if [ ! -f /run/secrets/wp_admin_password ]; then
    echo "Error: wp_admin_password secret not found at /run/secrets/wp_admin_password"
    exit 1
fi

# Read password from Docker secret
FTP_PASSWORD=$(cat /run/secrets/wp_admin_password)

# Create FTP user if it doesn't exist
if ! id "ftpuser" &>/dev/null; then
    useradd -m ftpuser
    echo "Created user ftpuser"
fi

# Set password for FTP user
echo "ftpuser:$FTP_PASSWORD" | chpasswd

if [ $? -eq 0 ]; then
    echo "Password set successfully for ftpuser"
else
    echo "Failed to set password for ftpuser"
    exit 1
fi

# Make sure the user owns their home directory
chown -R ftpuser:ftpuser /home/ftpuser

echo "Starting vsftpd..."
# Execute the original command
exec "$@"