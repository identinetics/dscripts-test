import argparse
import logging
import os
from ldap3 import Server, Connection, ALL, LDIF, MODIFY_REPLACE
from ldap3.core.exceptions import LDAPEntryAlreadyExistsResult


def main():
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    get_args()
    server = Server('%s:%s' % (args.host, args.port), get_info=ALL)
    conn_root = connect_ldap(server, args.rootdn, args.rootpw)
    add_test_user(conn_root)
    dump_test_user(conn_root)
    change_password(conn_root, args.testdn, 'test')
    conn_testuser = connect_ldap(server, args.testdn, 'test')
    delete_test_user(conn_root, args.testdn)


def get_args():
    rootpw = os.environ['ROOTPW'] if 'ROOTPW' in os.environ else 'changeit'
    port = os.environ['SLAPDPORT'] if 'SLAPDPORT' in os.environ else '8389'
    parser = argparse.ArgumentParser(description='py ldap3 test script')
    parser.add_argument('-b', '--basedn', dest='basedn', required=True)
    parser.add_argument('-D', '--rootdn', dest='rootdn', required=True)
    parser.add_argument('-H', '--host', dest='host', default='localhost')
    parser.add_argument('-p', '--port', dest='port', default=port)
    parser.add_argument('-w', '--rootpw', dest='rootpw', default=rootpw)
    global args
    args = parser.parse_args()
    args.testgn = 'Adam'
    args.testsn = 'Bäcker'
    args.testcn = args.testgn + ' ' + args.testsn
    args.testuid = 'testuser2_adambaecker'
    args.testdn = 'uid=%s,%s' % (args.testuid, args.basedn)


def connect_ldap(server, binddn, password):
    logging.info('connecting to %s as %s' % (server, binddn))
    connection = Connection(server, binddn, password, auto_bind=True, raise_exceptions=True)
    return connection


def add_test_user(connection):
    logging.info('=== add user ' + args.testdn)
    try:
        connection.add(
            args.testdn, 'inetOrgPerson',
            {'objectClass': 'inetOrgPerson',
             'cn': args.testcn,
             'gn': args.testgn,
             'sn': args.testsn,
             'uid': args.testuid,
            }
        )
    except LDAPEntryAlreadyExistsResult:
        logging.info('Entry %s already exists' % args.testdn)


def dump_test_user(connection):
    logging.info('=== dump_testuser')
    connection.search(args.basedn, '(uid=%s)' % args.testuid)
    logging.info(connection.entries)


def change_password(connection, userdn, userpw):
    logging.info('=== change password')
    connection.modify(userdn, {'userPassword': [(MODIFY_REPLACE, [userpw])]})


def connect_ldap_as_testuser(userdn, userpw):
    logging.info('=== connecting as ' + userdn)
    connection = Connection(s, userdn, userpw, auto_bind=True, raise_exceptions=True)
    connection.search(args.basedn, '(uid=%s)' % args.testuid)
    logging.info('=== dumping own entry ' + userdn)
    logging.info(connection.entries)

def delete_test_user(connection, dn):
    logging.info('=== deleting ' + dn)
    connection.delete(dn)


main()
