# =============================
# Windows Volatile Data Collector
# =============================

# Generate timestamp for files
$timestamp = (Get-Date).ToString("yyyyMMddHHmmss")

# Output directory
$outDir = "volatile_data_ps"

# Create directory if it doesn't exist
if (!(Test-Path -Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
    Write-Host "[+] Created directory: $outDir"
} else {
    Write-Host "[*] Directory already exists: $outDir"
}

# Helper function to safely create output file with timestamp if exists
function Write-VolatileOutput {
    param(
        [string]$FileName,
        [string]$Command
    )

    $filePath = "$outDir\$FileName.txt"

    # If file exists, append timestamp to avoid overwriting
    if (Test-Path $filePath) {
        $filePath = "$outDir\${FileName}_$timestamp.txt"
        Write-Host "[!] File exists, creating new: $(Split-Path $filePath -Leaf)"
    } else {
        Write-Host "[+] Creating: $FileName.txt"
    }

    # Execute command and write output
    Invoke-Expression $Command | Out-File -Encoding utf8 $filePath
}

# =============================
# Collect volatile information
# =============================

Write-VolatileOutput -FileName "system_info" -Command "systeminfo"
Write-VolatileOutput -FileName "system_time" -Command "(Get-Date).ToString('yyyy-MM-dd HH:mm:ss')"
Write-VolatileOutput -FileName "network_info" -Command "ipconfig /all"
Write-VolatileOutput -FileName "arp_cache" -Command "arp -a"
Write-VolatileOutput -FileName "routing_table" -Command "route print"
Write-VolatileOutput -FileName "dns_cache" -Command "ipconfig /displaydns"
Write-VolatileOutput -FileName "users_list" -Command "net user"
Write-VolatileOutput -FileName "logged_on_users" -Command "query user"
Write-VolatileOutput -FileName "net_sessions" -Command "net session"
Write-VolatileOutput -FileName "open_shares" -Command "net share"
Write-VolatileOutput -FileName "running_processes" -Command "tasklist /V"
Write-VolatileOutput -FileName "running_services" -Command "net start"
Write-VolatileOutput -FileName "startup_programs" -Command "wmic startup get caption,command"
Write-VolatileOutput -FileName "scheduled_tasks" -Command "schtasks /query /fo LIST /v"
Write-VolatileOutput -FileName "network_connections" -Command "netstat -ano"
Write-VolatileOutput -FileName "firewall_rules" -Command "netsh advfirewall firewall show rule name=all"
Write-VolatileOutput -FileName "browser_history_hint" -Command "wmic process where ""name='chrome.exe' OR name='firefox.exe' OR name='msedge.exe'"" get CommandLine"
Write-VolatileOutput -FileName "environment_variables" -Command "Get-ChildItem Env: | Format-List"

# Attempt to collect PowerShell history (if enabled)
$psHistoryPath = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
if (Test-Path $psHistoryPath) {
    Copy-Item $psHistoryPath "$outDir\powershell_history_$timestamp.txt"
    Write-Host "[+] PowerShell history collected."
} else {
    Write-Host "[!] No PowerShell history found."
}

Write-Host "`n=== Collection Complete ==="
Write-Host "All outputs stored in: $outDir"