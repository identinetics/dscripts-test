#!/usr/bin/env bash

rootdn=$(grep ^rootdn /etc/openldap/slapd.conf | awk {'print $2'} | tr -d '"')
suffix=$(grep ^suffix /etc/openldap/slapd.conf | awk {'print $2'} | tr -d '"')

python3 /tests/test1.py -D $rootdn -b $suffix
