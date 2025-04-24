#!/bin/bash
set -x

# Define variables
CONTAINER_NAME="mysql-db"
DB_USER="root"    # Replace with your MySQL username
DB_PASS="Admin@1234" # Replace with your MySQL password
S3_BUCKET="s3://crb-databse-backup/backup/"
DATE=$(date +"%Y-%m-%d")

# Backup databases
docker exec ${CONTAINER_NAME} /usr/bin/mysqldump -u${DB_USER} -p${DB_PASS} common_db > /tmp/common_db_backup_${DATE}.sql
docker exec ${CONTAINER_NAME} /usr/bin/mysqldump -u${DB_USER} -p${DB_PASS} drizzle_user_db > /tmp/drizzle_user_db_backup_${DATE}.sql

# Upload to S3
aws s3 cp /tmp/common_db_backup_${DATE}.sql ${S3_BUCKET}
aws s3 cp /tmp/drizzle_user_db_backup_${DATE}.sql ${S3_BUCKET}

# Remove local backup files
rm /tmp/common_db_backup_${DATE}.sql
rm /tmp/drizzle_user_db_backup_${DATE}.sql
