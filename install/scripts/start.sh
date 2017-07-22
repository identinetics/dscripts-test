#!/usr/bin/env bash

#[ -z $SLAPDHOST ] && echo 'SLAPDHOST not set' && exit 1
#cp /etc/hosts /tmp/hosts
#
## maybe there is a prepared hosts file
#if [ -e /etc/openldap/slapd_hosts ] ; then
#	cp /etc/openldap/slapd_hosts /etc/hosts
#else
#	# add SLAPDHOST to /etc/hosts
#	sed -e "s/$HOSTNAME\$/$HOSTNAME $SLAPDHOST/" /tmp/hosts > /etc/hosts
#fi

slapd -4 -h ldap://$SLAPDHOST:$SLAPDPORT/ -d $DEBUGLEVEL -f /etc/openldap/slapd.conf
