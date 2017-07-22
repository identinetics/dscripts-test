#!/usr/bin/env bash

ldapsearch -h localhost -p $SLAPDPORT -x -D cn=admin,dc=at -w $ROOTPW -s base -b '' -LLL '+'