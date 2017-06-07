#!/bin/sh

#
# A script to check configuration of ntpd for validation in the ansible role
#
ntpd_out=`ntpd -c $1 --saveconfigquit=/dev/null 2>&1`
echo $ntpd_out | grep -q error
[ $? -ne 0 ]
