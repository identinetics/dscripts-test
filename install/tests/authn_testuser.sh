#!/usr/bin/env bash

rootdn=$(grep ^rootdn /etc/openldap/slapd.conf | awk {'print $2'} | tr -d '"')
suffix=$(grep ^suffix /etc/openldap/slapd.conf | awk {'print $2'} | tr -d '"')

ldapsearch -h localhost -p $SLAPDPORT -x -D \
    'cn=test.user1234567,ou=user,ou=ph08,o=BMUKK' \
    -w test -b $suffix -L 'objectclass=*'

#ldapsearch -h localhost -p $SLAPDPORT -x -D \
#    uid=tester@testinetics.at,gln=9110017333914,dc=wpv,dc=at \
#    -w test -b dc=at -L 'uid=tester@testinetics.at'

#ldapsearch -h localhost -p $SLAPDPORT -x -D \
#    uid=test.user2_adam,dc=schule,dc=at \
#    -w test -b dc=at -L 'uid=test.user2_adam'

#ldapsearch -h localhost -p $SLAPDPORT -x -D \
#    uid=test.user3_eva,dc=schule,dc=at \
#    -w test -b dc=at -L 'uid=test.user3_eva'

#ldapsearch -h localhost -p $SLAPDPORT -x -D \
#    uid=test.user4_berta,dc=schule,dc=at \
#    -w test -b dc=at -L 'uid=test.user4_berta'
