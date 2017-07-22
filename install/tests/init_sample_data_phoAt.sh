#!/bin/sh

echo "loading /etc/openldap with sample data "

ldapadd -h $SLAPDHOST -p $SLAPDPORT \
    -x -D cn=admin,o=BMUKK -w $ROOTPW \
    -c -f /opt/sample_data/etc/openldap/data/phoAt_test.ldif

ldappasswd -h $SLAPDHOST -p $SLAPDPORT \
    -x -D cn=admin,o=BMUKK -w $ROOTPW \
    -s 'test' \
    'cn=test.user1234567, ou=user, ou=ph08, o=BMUKK'
