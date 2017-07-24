#!/usr/bin/env bash

rootdn=$(grep ^rootdn /etc/openldap/slapd.conf | awk {'print $2'} | tr -d '"')

ldapsearch -h localhost -p $SLAPDPORT -x -D $rootdn -w $ROOTPW -s base -b '' -LLL '+'