#!/bin/bash

setup_kick_spoofing() {
    # Check if user is root or sysmaint
    if [[ $(whoami) != "root" && $(whoami) != "sysmaint" ]]; then
        echo "Error: This function requires 'root' or 'sysmaint' privileges."
        exit 1
    fi

if ! command -v macchanger &> /dev/null; then
    echo "Error: 'macchanger' is not installed."
    echo "Please install it first (sudo apt update && sudo apt upgrade && sudo apt install macchanger)."
    exit 1
fi

    echo "Creating MAC spoofing script for kicksecure..."

    # 1. Create the script
    sudo tee /usr/local/bin/mac-spoof-monitor.sh > /dev/null << 'EOF'
#!/bin/bash
CONFIG_FILE="/tmp/macspoof.conf"
INTERFACE="eth0"

# If config file EXISTS, do nothing
[ -f "$CONFIG_FILE" ] && exit 0

# If config file does NOT exist:
touch "$CONFIG_FILE"
#chown user:user "$CONFIG_FILE"
#chmod ugo=rwx "$CONFIG_FILE"

#down interface
ip link set $INTERFACE down

/usr/bin/macchanger -r $INTERFACE

#for vendor mac spoofing
#/usr/bin/macchanger -A $INTERFACE

#for vendor mac spoofing manual
#/usr/bin/macchanger --mac=mac-vendor-name $INTERFACE

#up interface
ip link set $INTERFACE up

#restart network to apply mac spoofing
systemctl restart networking
EOF

    sudo chmod +x /usr/local/bin/mac-spoof-monitor.sh

    # 2. Create the systemd service unit
    echo "Creating systemd service unit..."
    sudo tee /etc/systemd/system/mac-spoof-monitor.service > /dev/null << 'EOF'
[Unit]
Description=MAC Spoof Monitor Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/mac-spoof-monitor.sh
User=root
EOF

    # 3. Create the systemd timer unit
    echo "Creating systemd timer unit..."
    sudo tee /etc/systemd/system/mac-spoof-monitor.timer > /dev/null << 'EOF'
[Unit]
Description=Monitor MAC Spoof Config Every 30 Seconds

[Timer]
OnBootSec=1min
OnUnitActiveSec=30s
Unit=mac-spoof-monitor.service

[Install]
WantedBy=timers.target
EOF

    # 4. Reload and Enable
    echo "Reloading systemd and enabling the timer..."
    sudo systemctl daemon-reload
    sudo systemctl enable --now mac-spoof-monitor.timer
    
    echo "Done. Files created at:"
    echo "/usr/local/bin/mac-spoof-monitor.sh"
    echo "/etc/systemd/system/mac-spoof-monitor.service"
    echo "/etc/systemd/system/mac-spoof-monitor.timer"
}

# Simple Menu
while true; do
    echo ""
    echo "1. Setup MAC Spoofing Service (Root/sysmaint only)"
    echo "2. Activate Spoofing (Remove config file)"
    echo "3. Check Status"
    echo "4. Exit"
    read -p "Select option: " choice

    case $choice in
        1)
            setup_kick_spoofing
            ;;
        2)
            
                rm -rf /tmp/macspoof.conf
                echo "Config file removed. MAC will change within 30 seconds."
                echo "Run 'ip a' to check the new MAC."
            ;;
        3)
            echo "--- Service Status ---"
            systemctl status mac-spoof-monitor.timer --no-pager
            systemctl status mac-spoof-monitor.service --no-pager
            
            echo ""
            echo "--- Config File Check ---"
            if [ -f /tmp/macspoof.conf ]; then
                echo "File /tmp/macspoof.conf EXISTS. Spoofing is done/paused."
                echo "Check your MAC with: ip a"
            else
                echo "File /tmp/macspoof.conf MISSING. Waiting for timer (up to 30s)."
                echo "If not working, check files at:"
                echo "/usr/local/bin/mac-spoof-monitor.sh"
                echo "/etc/systemd/system/mac-spoof-monitor.service"
                echo "/etc/systemd/system/mac-spoof-monitor.timer"
            fi
            ;;
        4)
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done


