#!/usr/bin/env bash

ldapsearch -h localhost -p $SLAPDPORT -x -D cn=admin,o=BMUKK -w \
    $ROOTPW -b o=BMUKK -L 'cn=*'

# ldapsearch -h localhost -p $SLAPDPORT -x -D cn=admin,o=BMUKK -w \
#    $ROOTPW -b o=BMUKK -L 'uid=test.user1234567'
# ldapmodify -h localhost -p $SLAPDPORT -x -D cn=admin,o=BMUKK -w \
#    $ROOTPW -c -f /tmp/x.ldif
# ldapdelete -h localhost -p $SLAPDPORT -x -D cn=admin,o=BMUKK -w \
#    $ROOTPW uid=test.user2_adam,ou=user,ou=ph08,o=BMUKK
