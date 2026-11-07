#!/bin/bash

# Linux File Permission and Ownership Audit

echo "=========================================="
echo " LINUX FILE PERMISSION AND OWNERSHIP AUDIT"
echo "=========================================="

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script using sudo."
    exit 1
fi

PASS=0
WARN=0

FILES=(
    "/etc/passwd"
    "/etc/shadow"
    "/etc/group"
    "/etc/gshadow"
    "/etc/sudoers"
)

echo ""
echo "Starting Linux File Security Audit..."
echo ""

for FILE in "${FILES[@]}"; do

    if [ -f "$FILE" ]; then

        OWNER=$(stat -c "%U" "$FILE")
        PERM=$(stat -c "%a" "$FILE")

        echo "File: $FILE"
        echo "Owner: $OWNER"
        echo "Permissions: $PERM"

        if [ "$OWNER" = "root" ]; then
            echo "Ownership Status: PASS"
            ((PASS++))
        else
            echo "Ownership Status: WARNING"
            ((WARN++))
        fi

        case "$FILE" in
            "/etc/shadow"|"/etc/gshadow")
                MAX=640
                ;;
            *)
                MAX=644
                ;;
        esac

        if [ "$((8#$PERM))" -le "$((8#$MAX))" ]; then
            echo "Permission Status: PASS"
            ((PASS++))
        else
            echo "Permission Status: WARNING"
            ((WARN++))
        fi

        echo "------------------------------------------"

    else
        echo "File not found: $FILE"
        ((WARN++))
    fi

done

echo ""
echo "=========================================="
echo "             AUDIT SUMMARY"
echo "=========================================="
echo "Total PASS Checks: $PASS"
echo "Total WARNING Checks: $WARN"
echo "Audit Completed Successfully"
echo "=========================================="
