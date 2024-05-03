#!/bin/bash

# Define the service file path
SERVICE_FILE="/etc/systemd/system/nvidia-persistent-mode.service"

# Check if the script is run as root, exit if not
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Check if nvidia-smi is available
if ! command -v nvidia-smi &> /dev/null; then
    echo "nvidia-smi could not be found, please install NVIDIA drivers" >&2
    exit 1
fi

# Create the systemd service file
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Enable NVIDIA GPU Persistent Mode
After=syslog.target

[Service]
Type=oneshot
ExecStart=/usr/bin/nvidia-smi -pm 1

[Install]
WantedBy=multi-user.target
EOF

# Output what the script is doing
echo "Systemd service file has been created at $SERVICE_FILE"

# Reload systemd to recognize the new service
systemctl daemon-reload
if [ $? -ne 0 ]; then
    echo "Failed to reload systemd, the service might not work as expected" >&2
    exit 1
fi

# Enable the service so it starts at boot
systemctl enable nvidia-persistent-mode.service
if [ $? -ne 0 ]; then
    echo "Failed to enable the service, it will not start on boot" >&2
    exit 1
fi

# Start the service immediately to apply the change without rebooting
systemctl start nvidia-persistent-mode.service
if [ $? -ne 0 ]; then
    echo "Failed to start the service, persistent mode might not be enabled" >&2
    exit 1
fi

echo "NVIDIA GPU Persistent Mode has been successfully enabled and will be activated on every boot."
