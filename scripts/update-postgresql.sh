#!/usr/bin/env bash

# Stop the service
sudo systemctl stop postgresql.service

# Install the packages
sudo pacman -Su postgresql postgresql-libs

# Eventually remove backup data
sudo rm -rf /var/lib/postgres/olddata

# Backup data
sudo mv /var/lib/postgres/data /var/lib/postgres/olddata

# Create new PostgreSQL data folder
sudo mkdir /var/lib/postgres/data

# Change ownership to postgres user
sudo chown postgres:postgres /var/lib/postgres/data

# Re-initialize the DB with correct defaults
sudo -u postgres initdb -D /var/lib/postgres/data --locale=en_US.UTF-8 --encoding=UTF8 --data-checksums

# Restart the service
sudo systemctl start postgresql.service

# Add superuser to current `postgres` DB
psql -U postgres << EOF
    CREATE USER odoo;
    ALTER USER odoo WITH SUPERUSER;
EOF
