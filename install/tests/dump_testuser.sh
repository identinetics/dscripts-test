#!/usr/bin/env bash

rootdn=$(grep ^rootdn /etc/openldap/slapd.conf | awk {'print $2'} | tr -d '"')
suffix=$(grep ^suffix /etc/openldap/slapd.conf | awk {'print $2'} | tr -d '"')

ldapsearch -h localhost -p $SLAPDPORT \
    -x -D $rootdn -w $ROOTPW \
    -b $suffix -LLL 'cn=*'

# sample commands
# ldapsearch -h localhost -p $SLAPDPORT -x -D $rootdn -w $ROOTPW -b $suffix -LLL 'uid=test.user1234567'
# ldapmodify -h localhost -p $SLAPDPORT -x -D $rootdn -w $ROOTPW -c -f /tmp/x.ldif
# ldapdelete -h localhost -p $SLAPDPORT -x -D $rootdn -w $ROOTPW uid=test.user2_adam,ou=user,ou=ph08,o=BMUKK
