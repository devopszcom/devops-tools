# Backup

```bash
# Install 7z: for compression and encryption
sudo apt install -y p7zip-full
```

## Backup with Dropbox CLI

https://github.com/dropbox/dbxcli


### 1. Install Dropbox CLI

```bash
# Install Dropbox CLI
DROPBOX_CLI_VERSION=v2.1.1

sudo wget https://github.com/dropbox/dbxcli/releases/download/${DROPBOX_CLI_VERSION}/dbxcli-linux-amd64 -O /usr/local/bin/dbxcli

sudo chmod +x /usr/local/bin/dbxcli
```


### 2. Authorize Dropbox Account

```bash
dbxcli account
```


### 3. Backup script

Flow:

1. Dump database
2. Create backup file: compression & encryption
3. Backup to Dropbox
4. Clean

Example: [backup_ghost_dropbox.sh](./backup_ghost_dropbox.sh)


### 4. Cronjob

By default, in cron environment:

```
PATH=/usr/bin:/bin
```

If you want to run the command located in /usr/local/bin, you need to update the cron environment variables as follows:


```bash
crontab -e
```

```bash
PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
LD_LIBRARY_PATH=/usr/local/lib

# m h  dom mon dow   command
# Backup for DevOpsZ
1 1 * * * /home/prod/doz-blog/backup_ghost_dropbox.sh >> /home/prod/doz-blog/logs/cron.log 2>&1

```
