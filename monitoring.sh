#!/bin/bash
system_info=$(uname -a)
cpu_info_physical_id=$(grep "physical id" /proc/cpuinfo | wc -l)
cpu_info_processor=$(grep "processor" /proc/cpuinfo | wc -l)

total_memory_kb=$(free | awk '$1 == "Mem:" {print $2}')
total_memory_mb=`expr $total_memory_kb / 1024`
used_memory_kb=$(free | awk '$1 == "Mem:" {print $3}')
used_memory_mb=`expr $used_memory_kb / 1024`
used_memory_percent=$(awk 'BEGIN{ printf"%.2f", '$used_memory_kb' / '$total_memory_kb' * 100 }')

total_disk_kb=$(df --total | awk '$1 == "total" {print $2}')
convert_kb_to_gb=`expr 1024 \* 1024`
total_disk_gb=`expr $total_disk_kb / $convert_kb_to_gb`
used_disk_kb=$(df --total | awk '$1 == "total" {print $3}')
used_disk_mb=`expr $used_disk_kb / 1024`
used_disk_percent=$(awk 'BEGIN{ printf"%.2f", '$used_disk_kb' / '$total_disk_kb' * 100 }')

cpu_load_percent=$(top -bn1 | awk '/%Cpu/ { printf "%.1f\n", $2 + $4 }')

last_reboot_timedate=$(who -b | awk '$1 == "system" { print $3 " " $4 }')

lvm_count=$(lsblk | grep "lvm" | wc -l)
lvm_check=$(if [ $lvm_count -le 0 ]; then echo no; else echo yes; fi)

establish_tcp=$(ss -t | grep "ESTAB" | wc -l)

login_users=$(who | wc -l)

host_ip_address=$(hostname -I)
mac_address=$(ip addr | grep "ether" | awk '{ print $2 }')

sudo_count=$(journalctl -q _COMM=sudo | grep "COMMAND" | wc -l)

wall "    #Architecture: $system_info
    #CPU physical : $cpu_info_physical_id
    #vCPU : $cpu_info_processor
    #Memory Usage: $used_memory_mb/${total_memory_mb}MB (${used_memory_percent}%)
    #Disk Usage: $used_disk_mb/${total_disk_gb}Gb (${used_disk_percent}%)
    #CPU load: $cpu_load_percent%
    #Last boot: $last_reboot_timedate
    #LVM use: $lvm_check
    #Connections TCP : $establish_tcp ESTABLISHED
    #User log: $login_users
    #Network: IP $host_ip_address(${mac_address})
    #Sudo : $sudo_count cmd"
