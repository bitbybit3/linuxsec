#!/bin/bash

echo "======================================="
echo " Linux Kernel Security Audit"
echo "======================================="

check_parameter() {
    parameter=$1
    recommended=$2

    current=$(sysctl -n $parameter 2>/dev/null)

    if [ "$current" == "$recommended" ]; then
        echo "[PASS] $parameter = $current"
    else
        echo "[WARNING] $parameter = $current (Recommended: $recommended)"
    fi
}

check_parameter kernel.randomize_va_space 2
check_parameter net.ipv4.ip_forward 0
check_parameter kernel.kptr_restrict 2
check_parameter fs.suid_dumpable 0
check_parameter kernel.dmesg_restrict 1

echo
echo "Audit Completed."
