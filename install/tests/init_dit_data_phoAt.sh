#!/bin/sh

echo "loading /etc/openldap with initial tree data "

ldapadd -h $SLAPDHOST -p $SLAPDPORT \
    -x -D cn=admin,o=BMUKK -w $ROOTPW \
    -c -f /opt/sample_data/etc/openldap/data/phoAt_init.ldif
