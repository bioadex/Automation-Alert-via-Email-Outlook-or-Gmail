#!/bin/bash

set -euo pipefail

source "/home/user/.ftp_credentials"

LOCAL_FILE="/home/user/files/report.txt"
LOGFILE="/var/log/ftp_upload.log"
EMAIL="youremail@gmail.com"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

if [ ! -f "$LOCAL_FILE" ]; then
    echo "$DATE - File not found: $LOCAL_FILE" >> "$LOGFILE"
    echo "FTP upload failed: file not found" | mail -s "FTP Upload FAILED" "$EMAIL"
    exit 1
fi

lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" <<EOF
set ftp:ssl-allow no
cd "$REMOTE_DIR"
put "$LOCAL_FILE"
bye
EOF

echo "$DATE - FTP upload successful" >> "$LOGFILE"
echo "File uploaded successfully to Customer_AKA-TECH-IT at $DATE" | mail -s "FTP Upload Confirmation" "$EMAIL"
