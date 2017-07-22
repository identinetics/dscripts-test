#!/bin/sh

echo 'initialize slapd.conf with phoAt schema'

mv /etc/openldap/slapd.conf /etc/openldap/slapd.conf.default
mv /etc/openldap/slapd_phoAtRepl_example.conf /etc/openldap/slapd.conf

mv /etc/openldap/slapd_phoAtRepl_hosts /etc/openldap/slapd_hosts
mv /etc/openldap/slapd_phoAtRepl_slapd_repl.conf /etc/openldap/slapd_repl.conf

if [ $(grep -q '^rootpw' /etc/openldap/slapd.conf) ]; then
    echo "rootpw directive already set in slapd.conf"
else
    slappasswd -s $ROOTPW > /tmp/rootpw
    printf "\nrootpw $(cat /tmp/rootpw)" >> /etc/openldap/slapd.conf
    rm -f /tmp/rootpw
    echo "rootpw directive added to slapd.conf"
fi

