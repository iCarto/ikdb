#!/bin/bash

# Este script no está pensando para su ejecución directa, si no como una guía

set -e

install_postgres_ppa() {
    # Borrar el source antiguo si existe
    rm /etc/apt/sources.list.d/pgdg.list*
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
    wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
    apt-get update
}

install_postgres() {
    local PG_VERSION=${1}
    local POSTGIS_VERSION=${2}

    apt-get install "postgresql-${PG_VERSION}" "postgresql-contrib-${PG_VERSION}" "postgresql-server-dev-${PG_VERSION}" "postgresql-${PG_VERSION}-postgis-${POSTGIS_VERSION}" "postgresql-plperl-${PG_VERSION}"
    # apt-get install -y postgresql-${PG_VERSION}-postgis-${POSTGIS_VERSION}-scripts # para instalar topology, tiger, ...7
    apt-get install --no-install-recommends postgis

    mv "/etc/postgresql/${PG_VERSION}/main/postgresql.conf" "/etc/postgresql/${PG_VERSION}/main/postgresql.conf.${PG_VERSION}.org"
    grep -v '^#' "/etc/postgresql/${PG_VERSION}/main/postgresql.conf.${PG_VERSION}.org" | grep '^[ ]*[a-z0-9]' > "/etc/postgresql/${PG_VERSION}/main/postgresql.conf"
    grep -v '^#' "/etc/postgresql/${PG_VERSION}/main/postgresql.conf.${PG_VERSION}.org" | grep '^[ ]*[a-z0-9]' > "/etc/postgresql/${PG_VERSION}/main/postgresql.conf.${PG_VERSION}.org.no_comments"

    mv "/etc/postgresql/${PG_VERSION}/main/pg_hba.conf" "/etc/postgresql/${PG_VERSION}/main/pg_hba.conf.${PG_VERSION}.org"
    grep -v '^#' "/etc/postgresql/${PG_VERSION}/main/pg_hba.conf.${PG_VERSION}.org" | grep '^[ ]*[a-z0-9]' > "/etc/postgresql/${PG_VERSION}/main/pg_hba.conf"
    grep -v '^#' "/etc/postgresql/${PG_VERSION}/main/pg_hba.conf.${PG_VERSION}.org" | grep '^[ ]*[a-z0-9]' > "/etc/postgresql/${PG_VERSION}/main/pg_hba.conf.${PG_VERSION}.org.no_comments"

}

ensure_postgres_config_permissions() {
    chown postgres:postgres "/etc/postgresql/${PG_VERSION}/main/pg_hba.conf"
    chown postgres:postgres "/etc/postgresql/${PG_VERSION}/main/postgresql.conf"
    chmod 640 "/etc/postgresql/${PG_VERSION}/main/pg_hba.conf"
    chmod 644 "/etc/postgresql/${PG_VERSION}/main/postgresql.conf"

    chmod a-w "/etc/postgresql/${PG_VERSION}/main/postgresql.conf.${PG_VERSION}.org"
    chmod a-w "/etc/postgresql/${PG_VERSION}/main/postgresql.conf.${PG_VERSION}.org.no_comments"
    chmod a-w "/etc/postgresql/${PG_VERSION}/main/pg_hba.conf.${PG_VERSION}.org.no_comments"
}

purge_postgres() {
    local OLD_PG_VERSION=${1}

    if [ -z "${OLD_PG_VERSION}" ]; then
        echo "Missed parameter"
        return 1
    fi

    apt-get purge "postgresql-${OLD_PG_VERSION}"
    rm -rf "/var/lib/postgresq/${OLD_PG_VERSION}"
    rm -rf "/etc/postgresql/${OLD_PG_VERSION}"
    rm /var/log/postgresql/postgresql-"${OLD_PG_VERSION}"-main.log*
}

dump_restore_bd() {
    local PG_VERSION=${1}
    local POSTGIS_VERSION=${2}
    local OLD_PG_VERSION=${3}
    local DATABASE=${4}
    local OWNER=${5}
    local LOCALE=${6}

    export PGCLUSTER="${PG_VERSION}/main"
    # pg_dumpall --version

    # shellcheck disable=SC2024
    sudo -u postgres pg_dumpall --globals-only -p 5432 > /tmp/roles.sql
    sudo -u postgres psql -p 5433 -f /tmp/roles.sql

    sudo -u postgres pg_dump -p 5432 -Fc -Z9 -E UTF-8 -b -f "/tmp/${DATABASE}.dump" "${DATABASE}"
    sudo -u postgres createdb -p 5433 -E UTF8 --locale="${LOCALE}" --owner "${OWNER}" "${DATABASE}"

    # Si el dump no usa `CREATE EXTENSION` hacerlo mano
    # sudo -u postgres psql -p 5433 -d "${DATABASE}" -c "CREATE EXTENSION postgis;"

    # para postgis-3 hay que usar en este punto POSTGIS_VERSION=3.0
    perl "/usr/share/postgresql/${PG_VERSION}/contrib/postgis-${POSTGIS_VERSION}/postgis_restore.pl" "/tmp/${DATABASE}.dump" | sudo -u postgres psql -p 5433 -d "${DATABASE}" 2> /tmp/errors.txt
}

# Variables used:
#
OLD_PG_VERSION=
PG_VERSION=
POSTGIS_VERSION=
DATABASE=
LOCALE= # to be used in the database
#
# Se asume que al menos hasta el final del proceso se puede acceder a los
# clusters mediante _local peer_ con el antiguo en 5432 y el nuevo en 5433
# También se asume que hay una sóla base de datos a mover al nuevo clúster

# **Make a backup**

install_postgres_ppa
install_postgres "${PG_VERSION}" "${POSTGIS_VERSION}"
# Edit (or cp from a tested config):
# -    "/etc/postgresql/${PG_VERSION}/main/pg_hba.conf"
# -    "/etc/postgresql/${PG_VERSION}/main/postgresql.conf"
ensure_postgres_config_permissions "${PG_VERSION}" "${POSTGIS_VERSION}"

dump_restore_bd "${PG_VERSION}" "${POSTGIS_VERSION}" "${OLD_PG_VERSION}" "${DATABASE}" "${OWNER}"

cat /tmp/errors.txt
# Gestionar problemas con `spatial_ref_sys`

vacuumdb -p 5433 --all --analyze-in-stages
reindexdb -p 5433 --all

systemctl stop postgresql

sed -i 's/port[ ]*=[ ]*5432/port = 5433/' "/etc/postgresql/${OLD_PG_VERSION}/main/postgresql.conf"
sed -i 's/port[ ]*=[ ]*5433/port = 5432/' "/etc/postgresql/${PG_VERSION}/main/postgresql.conf"
sed -i 's/^auto/manual/' "/etc/postgresql/${OLD_PG_VERSION}/main/start.conf"
systemctl start postgresql "${PG_VERSION}"

purge_postgres "${OLD_PG_VERSION}"

# Si vamos a actualizar el servidor. Tras instalar postgres con los pasos anteriores
# a una versión que exista en ambos
# apt-get update
# apt-get upgrade
# do-release-upgrade
# install_postgres_ppa
