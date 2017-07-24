#!/usr/bin/env bash


echo "starting slapd, DEBUGLEVEL=$DEBUGLEVEL"

slapd -4 -h ldap://$SLAPDHOST:$SLAPDPORT/ -d $DEBUGLEVEL -f /etc/openldap/slapd.conf
