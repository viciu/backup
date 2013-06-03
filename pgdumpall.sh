#!/bin/bash

FILE_NAME=$(date +'%Y-%m-%d').sql
sudo -u postgres /usr/bin/pg_dumpall > /backup/pgsql/${FILE_NAME}
gzip /backup/pgsql/${FILE_NAME}

