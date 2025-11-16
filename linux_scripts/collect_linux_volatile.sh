#!/bin/bash

# set -e  # Quit on errors

# Timestamp function
timestamp=$(date +"%Y%m%d_%H%M%S")

# Output directory
OUTDIR="linux_volatile_data"

if [ ! -d "$OUTDIR" ]; then
    mkdir "$OUTDIR"
fi

# Function to save output 
write_output () {
    local filename="$OUTDIR/$1.txt"

    # If file exists, append timestamp
    if [ -f "$filename" ]; then
        filename="$OUTDIR/${1}_${timestamp}.txt"
    fi

    echo "[*] Collecting: $1"

    # Run the command, but DO NOT exit script if it fails
    bash -c "$2" > "$filename" 2>&1 || echo "[!] Command failed: $2" >> "$filename"
}


# Collect Volatile Information; add more that you need

write_output "system_info"           "uname -a"
write_output "hostname"              "hostnamectl"
write_output "uptime"                "uptime"
write_output "current_time"          "date"
write_output "logged_in_users"       "who -a"
write_output "env_variables"         "env"
write_output "bash_history"          "cat ~/.bash_history"

# Process & memory
write_output "running_processes"     "ps auxww"
write_output "open_files"            "lsof -nP"
write_output "kernel_modules"        "lsmod"
write_output "dmesg_logs"            "dmesg --ctime"

# Network
write_output "network_interfaces"    "ip addr show"
write_output "network_routes"        "ip route show"
write_output "arp_cache"             "arp -a"
write_output "listening_ports"       "ss -tunlp"
write_output "active_connections"    "ss -tnaup"

# Authentication & user info
write_output "last_logins"           "last -a"
write_output "sudoers_file"          "cat /etc/sudoers"
write_output "passwd_file"           "cat /etc/passwd"
write_output "shadow_file_permissions" "ls -l /etc/shadow"

# Scheduled tasks
write_output "crontab_root"          "crontab -l"
write_output "cron_system"           "ls -l /etc/cron.*"
write_output "services_status"       "systemctl list-units --type=service --all"

# System logs
write_output "auth_log"              "cat /var/log/auth.log 2>/dev/null || echo 'auth.log not available'"
write_output "syslog"                "cat /var/log/syslog 2>/dev/null || echo 'syslog not available'"
write_output "secure_log"            "cat /var/log/secure 2>/dev/null || echo 'secure log not available'"

# Shell session info
write_output "open_sessions"         "w"
write_output "tty_sessions"          "ps -eaf | grep tty"

# File system
write_output "mounted_filesystems"   "mount"
write_output "disk_usage"            "df -h"
write_output "recent_files"          "find / -type f -mtime -2 -print 2>/dev/null"

# Running binaries and permissions
write_output "suid_files"            "find / -perm -4000 -type f 2>/dev/null"
write_output "capabilities"          "getcap -r / 2>/dev/null"

# ==============================
# Done
# ==============================
echo ""
echo "==============================================="
echo " Linux volatile data collection completed."
echo " Saved under: $OUTDIR/"
echo " Timestamp used for duplicates: $timestamp"
echo "==============================================="
