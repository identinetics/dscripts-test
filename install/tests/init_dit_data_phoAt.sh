#!/bin/sh

echo "loading /etc/openldap with initial tree data "

rootdn=$(grep ^rootdn /etc/openldap/slapd.conf | awk {'print $2'} | tr -d '"')

ldapadd -h $SLAPDHOST -p $SLAPDPORT \
    -x -D $rootdn -w $ROOTPW \
    -c -f /opt/sample_data/etc/openldap/data/phoAt_init.ldif
