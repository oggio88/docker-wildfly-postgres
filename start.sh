#!/bin/bash

WILDFLY_PWD="123456"

mkdir /run/postgresql
chown postgres:postgres /run/postgresql

if [[ $(ls /var/lib/postgres/data/ | wc -l) -eq 0 ]]; then
    echo First run: adding admin user to wildfly and creating postgres database
    su wildfly -c "/opt/wildfly/bin/add-user.sh admin $WILDFLY_PWD"
    su postgres -c "initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'"
    su postgres -c "/usr/bin/pg_ctl -s -D /var/lib/postgres/data start -w"
    su postgres -c "createuser wildfly"
    su postgres -c "createdb wildfly -O wildfly"
    su postgres -c "/usr/bin/pg_ctl -s -D /var/lib/postgres/data stop -m fast"
fi

/usr/bin/supervisord -n

