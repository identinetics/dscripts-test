#!/bin/sh

echo "loading /etc/openldap with sample data "
rootdn=$(grep ^rootdn /etc/openldap/slapd.conf | awk {'print $2'} | tr -d '"')

ldapadd -h $SLAPDHOST -p $SLAPDPORT \
    -x -D $rootdn -w $ROOTPW \
    -c -f /opt/sample_data/etc/openldap/data/phoAt_test.ldif

ldappasswd -h $SLAPDHOST -p $SLAPDPORT \
    -x -D $rootdn -w $ROOTPW \
    -s 'test' \
    'cn=test.user1234567, ou=user, ou=ph08, o=BMUKK'
