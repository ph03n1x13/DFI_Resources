## This is a collection of windows utility scripts to run Digital Forensics Investigation  

- `collect_volatile_data.ps1`: This script collects some critical volatile data like network status, system info, system time and date, arp cache, running services, environment variables etc. among others. This script keeps a little footpring in the system being investigated.  
How to Run:   
- Open a powershell in admin mode  
- Run the following command from the directory the script belongs  
`C:> powershell -ExecutionPolicy Bypass -File .\collect_volatile_data.ps1`  
 

