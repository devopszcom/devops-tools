#!/bin/bash
set -e

#
# Backup Ghost Blog
#

#
# Fix: cron use /usr/bin/local
#
# PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
# LD_LIBRARY_PATH=/usr/local/lib
#

# Config
PROJECT_NAME=doz-blog
DROPBOX_PATH=/05-DevOpsZ/Backup/${PROJECT_NAME}

DATA_TYPE=ghost

DOCKER_NETWORK=doz-blog_back
DB_HOST=doz-blog_mariadb_1
DB_PORT=3306
DB_USER=ghost
DB_PASSWORD=random-db-password
DB_NAME=ghost

STAGE_ENV=prod
ENCRYPTION_PASSWORD=random-encryption-password

# Default config
BASE_DIR=$(dirname "$(readlink -f $0)")

BACKUP_DATE=`date '+%Y%m%d_%H%M%S'`
BACKUP_FILENAME=${PROJECT_NAME}_${STAGE_ENV}_${DATA_TYPE}_${BACKUP_DATE}
BACKUP_DIR_TMP=BACKUP_FILENAME

cd ${BASE_DIR}

# 1. Dump mysql
docker run --rm \
    --network ${DOCKER_NETWORK} \
    mariadb:10.3 \
    mysqldump \
        -h ${DB_HOST} \
        --port ${DB_PORT} \
        -u${DB_USER} \
        -p${DB_PASSWORD} \
        ${DB_NAME} > ghost.sql

# 2. Create backup file
# - mysql
# - files
rm -rf ${BACKUP_DIR_TMP}
mkdir -p ${BACKUP_DIR_TMP}

mv ghost.sql ${BACKUP_DIR_TMP}
cp -r ghost-data ${BACKUP_DIR_TMP}
rm -rf ${BACKUP_DIR_TMP}/ghost-data/logs

7z a -p${ENCRYPTION_PASSWORD} ${BACKUP_FILENAME}.7z ${BACKUP_DIR_TMP}

# 3. Backup to Dropbox
dbxcli put ${BACKUP_FILENAME}.7z ${DROPBOX_PATH}/${BACKUP_FILENAME}.7z

# 4. Clean
rm ${BACKUP_FILENAME}.7z
rm -rf ${BACKUP_DIR_TMP}
