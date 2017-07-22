import os
from ldap3 import Server, Connection, ALL, LDIF, MODIFY_REPLACE

# variables
rootpw = os.environ['ROOTPW'] if 'ROOTPW' in os.environ else 'changeit'
port = os.environ['SLAPDPORT'] if 'SLAPDPORT' in os.environ else '8389'
host = 'localhost:' + port
rootdn = 'o=BMUKK'
admindn = 'cn=admin,o=BMUKK'
userdn = 'cn=test.user1234567,ou=user,ou=ph08,o=BMUKK'
testpw = 'test'

print('connecting as ' + admindn)
s = Server(host, get_info=ALL)
conn1 = Connection(s, admindn, rootpw, auto_bind=True, raise_exceptions=True)

print('dump_testuser search')
conn1.search(rootdn, '(objectclass=*)')
print(conn1.entries)

print('change password')
conn1.modify(userdn, {'userPassword': [(MODIFY_REPLACE, ['newpass'])]})

print('connecting as ' + userdn)
conn2 = Connection(s, userdn, 'newpass', auto_bind=True, raise_exceptions=True)
conn2.search(rootdn, '(cn=*)')
print(conn2.entries)
